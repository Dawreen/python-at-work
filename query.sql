--  Description: Enriched the export to CMDM, cmdm_export.cmdm_fat_contratto_bb_sf and its export will be substitute with
--               the table operational_support_enriched.contract_skywifi_test_outcomes_actual, derived from
--               operational_support_snapshot.contract_skywifi_test_outcomes_delta_daily.
--  PKs:
--  DM: Paolo Basti
--  Epics: https://agile.at.sky/browse/DPAEP-948
--  Docs: https://wiki.at.sky/x/Y4PHGg
WITH
trigger AS (
  SELECT
    id_execution,
    contract_code,
    scenario,
    channel
  FROM `$source_project_daita.operational_support.skywifi_test_trigger`
  WHERE
    _process_mapping_start_ts >= TIMESTAMP_SUB(TIMESTAMP(@partition_date, 'Europe/Rome'), INTERVAL 60 MINUTE)
    and _process_mapping_start_ts < TIMESTAMP(date_add(DATE(@partition_date), INTERVAL 1 DAY), 'Europe/Rome')
    and DATE(partition_date) between DATE_SUB(DATE(@partition_date), INTERVAL 1 DAY) and DATE(@partition_date)
),
test AS (
  SELECT
    id_execution,
    contract_code,
    id_test_rule,
    date_execution_ts,
    outcome,
    CASE UPPER(TRIM(outcome))
      WHEN 'RED' THEN 3
      WHEN 'AMBER' THEN 2
      WHEN 'GREEN' THEN 1
      WHEN 'GREY' THEN 0
      ELSE CAST(NULL AS INT64)
    END AS rag
  FROM `$source_project_daita.operational_support.skywifi_test`
  WHERE
    _process_mapping_start_ts >= TIMESTAMP_SUB(TIMESTAMP(@partition_date, 'Europe/Rome'), INTERVAL 60 MINUTE)
    and _process_mapping_start_ts < TIMESTAMP(date_add(DATE(@partition_date), INTERVAL 1 DAY), 'Europe/Rome')
    and DATE(partition_date) between DATE_SUB(DATE(@partition_date), INTERVAL 1 DAY) and DATE(@partition_date)
),
test_worst_outcome AS (
  SELECT
    id_execution,
    MAX(rag) AS rag
  FROM test
  GROUP BY
    id_execution
),
outcome_per_execution AS (
  SELECT
    trigger.id_execution,
    trigger.contract_code,
    trigger.scenario,
    trigger.channel,
    test.outcome,
    test.date_execution_ts
  FROM trigger
  INNER JOIN test
    ON trigger.contract_code = test.contract_code
    AND trigger.id_execution = test.id_execution
  INNER JOIN test_worst_outcome
    ON test.id_execution = test_worst_outcome.id_execution
)
SELECT
  CURRENT_TIMESTAMP() as snapshot_time,
  TIMESTAMP_TRUNC(TIMESTAMP(@partition_date), day) as partition_date,
  extract(hour from TIMESTAMP(@partition_date)) as _clustering_hour,
  extract(minute from TIMESTAMP(@partition_date)) as _clustering_minute,
  id_execution,
  contract_code,
  scenario,
  channel,
  outcome,
  date_execution_ts,
FROM
  outcome_per_execution
--qualify(row_number() over(partition by contract_code order by date_execution_ts desc)) = 1
