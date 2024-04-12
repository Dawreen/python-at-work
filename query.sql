
WITH
trigger AS (
  SELECT
    id_execution,
    contract_code,
    scenario,
    channel
  FROM `$source_project.operational_support.wifi_test_trigger`
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
  FROM `$source_project.operational_support.wifi_test`
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
  id_execution,
  contract_code,
  scenario,
  channel,
  outcome,
  date_execution_ts,
FROM
  outcome_per_execution

