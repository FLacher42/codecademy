SELECT *
FROM subscriptions
LIMIT 100;



SELECT MIN(subscription_start), MAX(subscription_start)
FROM subscriptions;



WITH months AS
(
SELECT
  '2017-01-01' as first_day,
  '2017-01-31' as last_day
UNION
SELECT
  '2017-02-01' as first_day,
  '2017-02-28' as last_day
UNION
SELECT
  '2017-03-01' as first_day,
  '2017-03-31' as last_day
)
SELECT *
FROM months;




WITH months AS
(
SELECT
  '2017-01-01' as first_day,
  '2017-01-31' as last_day
UNION
SELECT
  '2017-02-01' as first_day,
  '2017-02-28' as last_day
UNION
SELECT
  '2017-03-01' as first_day,
  '2017-03-31' as last_day
),
cross_join AS
(SELECT *
FROM subscriptions
CROSS JOIN months)
SELECT *
FROM cross_join



WITH months AS
(
SELECT
  '2017-01-01' as first_day,
  '2017-01-31' as last_day
UNION
SELECT
  '2017-02-01' as first_day,
  '2017-02-28' as last_day
UNION
SELECT
  '2017-03-01' as first_day,
  '2017-03-31' as last_day
),
cross_join AS
(SELECT *
FROM subscriptions
CROSS JOIN months),
status AS
(SELECT id, first_day as month,
CASE
  WHEN (subscription_start < first_day)
    AND (
      subscription_end > first_day
      OR subscription_end IS NULL
    ) AND (
    segment = 87) THEN 1
  ELSE 0
END as is_active_87,
CASE
  WHEN (subscription_start < first_day)
    AND (
      subscription_end > first_day
      OR subscription_end IS NULL
    ) AND (
    segment = 30) THEN 1
  ELSE 0
END as is_active_30
FROM cross_join)
SELECT *
FROM status;





WITH months AS
(
SELECT
  '2017-01-01' as first_day,
  '2017-01-31' as last_day
UNION
SELECT
  '2017-02-01' as first_day,
  '2017-02-28' as last_day
UNION
SELECT
  '2017-03-01' as first_day,
  '2017-03-31' as last_day
),
cross_join AS
(SELECT *
FROM subscriptions
CROSS JOIN months),
status AS
(SELECT id, first_day as month,
CASE
  WHEN (subscription_start < first_day)
    AND (
      subscription_end > first_day
      OR subscription_end IS NULL
    ) AND (
    segment = 87) THEN 1
  ELSE 0
END as is_active_87,
CASE
  WHEN (subscription_start < first_day)
    AND (
      subscription_end > first_day
      OR subscription_end IS NULL
    ) AND (
    segment = 30) THEN 1
  ELSE 0
END as is_active_30,
CASE 
  WHEN (subscription_end BETWEEN first_day AND last_day)
 		AND (segment=87) THEN 1
  ELSE 0
END as is_canceled_87,
CASE 
  WHEN (subscription_end BETWEEN first_day AND last_day)
 		AND (segment=30) THEN 1
  ELSE 0
END as is_canceled_30
 FROM cross_join)
SELECT *
FROM status;




WITH months AS
(
SELECT
  '2017-01-01' as first_day,
  '2017-01-31' as last_day
UNION
SELECT
  '2017-02-01' as first_day,
  '2017-02-28' as last_day
UNION
SELECT
  '2017-03-01' as first_day,
  '2017-03-31' as last_day
),
cross_join AS
(SELECT *
FROM subscriptions
CROSS JOIN months),
status AS
(SELECT id, first_day as month,
CASE
  WHEN (subscription_start < first_day)
    AND (
      subscription_end > first_day
      OR subscription_end IS NULL
    ) AND (
    segment = 87) THEN 1
  ELSE 0
END as is_active_87,
CASE
  WHEN (subscription_start < first_day)
    AND (
      subscription_end > first_day
      OR subscription_end IS NULL
    ) AND (
    segment = 30) THEN 1
  ELSE 0
END as is_active_30,
CASE 
  WHEN (subscription_end BETWEEN first_day AND last_day)
 		AND (segment=87) THEN 1
  ELSE 0
END as is_canceled_87,
CASE 
  WHEN (subscription_end BETWEEN first_day AND last_day)
 		AND (segment=30) THEN 1
  ELSE 0
END as is_canceled_30
 FROM cross_join),
status_aggregate AS
(SELECT
  month,
  SUM(is_active_87) as active_87,
  SUM(is_canceled_87) as canceled_87,
  SUM(is_active_30) as active_30,
  SUM(is_canceled_30) as canceled_30
FROM status
GROUP BY month)
Select month, 1.0 *canceled_87/active_87 as churn_rate_87, 1.0 *canceled_30/active_30 as churn_rate_30
From status_aggregate;





