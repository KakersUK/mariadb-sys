#
# View for everyone. but field "description_kr" is only for Korean.
#
# Name: v$db_health_check
# Author: YJ
# Date: 2016.08.08
# Desc: database health check 
# 
# MariaDB [sys]> select * from v$db_health_check;
# +-----------------+-------------------------------+-----------------+----------+
# | category        | division                      | current_percent | state    |
# +-----------------+-------------------------------+-----------------+----------+
# | Connection      | Refued Connection             |            99.8 | Critical |
# | Connection      | Connection Usage              |            44.8 | NULL     |
# ...
# | Open Files      | Open Files Ratio              |             0.2 | NULL     |
# +-----------------+-------------------------------+-----------------+----------+
#
CREATE OR REPLACE
ALGORITHM=UNDEFINED
DEFINER = 'root'@'localhost'
SQL SECURITY INVOKER
VIEW `v$db_health_check`
AS
SELECT 'Connection' AS category
      ,'Refued Connection' AS division
      ,round(MAX(IF(variable_name = 'ABORTED_CONNECTS', variable_value, 0)) /
             MAX(IF(variable_name = 'CONNECTIONS', variable_value, 0)) * 100
            ,1) AS current_percent
      ,CASE 
       WHEN (MAX(IF(variable_name = 'ABORTED_CONNECTS', variable_value, 0)) /
             MAX(IF(variable_name = 'CONNECTIONS', variable_value, 0)) * 100
            ) BETWEEN 30 AND 80
       THEN 'Warning'
       WHEN (MAX(IF(variable_name = 'ABORTED_CONNECTS', variable_value, 0)) /
             MAX(IF(variable_name = 'CONNECTIONS', variable_value, 0)) * 100
            ) > 80
       THEN 'Critical'
       END AS state
  FROM information_schema.global_status
 WHERE variable_name IN ('ABORTED_CONNECTS', 'CONNECTIONS')
UNION ALL
SELECT 'Connection' AS category
      ,'Connection Usage' AS division
      ,round(s.variable_value / v.variable_value * 100, 1) AS current_percent
      ,CASE 
       WHEN (s.variable_value / v.variable_value * 100
            ) > 90
       THEN 'Warning'
       END AS state
  FROM information_schema.global_status s, information_schema.global_variables v
 WHERE s.variable_name IN ('THREADS_CONNECTED')
   AND v.variable_name IN ('MAX_CONNECTIONS')
UNION ALL
SELECT 'Connection' AS category
      ,'Max Connection Used Usage' AS division
      ,round(s.variable_value / v.variable_value * 100, 1) AS current_percent
      ,CASE 
       WHEN (s.variable_value / v.variable_value * 100
            ) > 90
       THEN 'Warning'
       END AS state
  FROM information_schema.global_status s, information_schema.global_variables v
 WHERE s.variable_name IN ('MAX_USED_CONNECTIONS')
   AND v.variable_name IN ('MAX_CONNECTIONS')
UNION ALL
SELECT 'Index' AS category
      ,'Percentage of Full table scan' AS division
      ,round(
             (
              MAX(IF(variable_name = 'HANDLER_READ_RND_NEXT', variable_value, 0)) +
              MAX(IF(variable_name = 'HANDLER_READ_RND', variable_value, 0))
             )
             /SUM(variable_value)
            ,1) AS current_percent
      ,CASE 
       WHEN (
             (
              MAX(IF(variable_name = 'HANDLER_READ_RND_NEXT', variable_value, 0)) +
              MAX(IF(variable_name = 'HANDLER_READ_RND', variable_value, 0))
             )
             /SUM(variable_value)
            ) BETWEEN 20 AND 40
       THEN 'Warning'
       WHEN (
             (
              MAX(IF(variable_name = 'HANDLER_READ_RND_NEXT', variable_value, 0)) +
              MAX(IF(variable_name = 'HANDLER_READ_RND', variable_value, 0))
             )
             /SUM(variable_value)
            ) > 40
       THEN 'Critical'
       END AS state
  FROM information_schema.global_status
 WHERE variable_name IN ('HANDLER_READ_RND', 'HANDLER_READ_KEY', 'HANDLER_READ_FIRST', 'HANDLER_READ_RND_NEXT', 'HANDLER_READ_PREV')
UNION ALL
SELECT 'Temporary Table' AS category
      ,'Disk Used ratio' AS division
      ,round(MAX(IF(variable_name = 'CREATED_TMP_DISK_TABLES', variable_value, 0)) /
             MAX(IF(variable_name = 'CREATED_TMP_TABLES', variable_value, 0)) * 100
            ,1) AS current_percent
      ,CASE 
       WHEN (MAX(IF(variable_name = 'CREATED_TMP_DISK_TABLES', variable_value, 0)) /
             MAX(IF(variable_name = 'CREATED_TMP_TABLES', variable_value, 0)) * 100
            ) BETWEEN 50 AND 75
       THEN 'Warning'
       WHEN (MAX(IF(variable_name = 'CREATED_TMP_DISK_TABLES', variable_value, 0)) /
             MAX(IF(variable_name = 'CREATED_TMP_TABLES', variable_value, 0)) * 100
            ) > 75
       THEN 'Critical'
       END AS state
  FROM information_schema.global_status
 WHERE variable_name IN ('CREATED_TMP_DISK_TABLES', 'CREATED_TMP_TABLES')
UNION ALL
SELECT 'Table Locks' AS category
      ,'Lock Connections' AS division
      ,round(MAX(IF(variable_name = 'TABLE_LOCKS_WAITED', variable_value, 0)) /
             SUM(variable_value) * 100
            ,1) AS current_percent
      ,CASE 
       WHEN (MAX(IF(variable_name = 'TABLE_LOCKS_WAITED', variable_value, 0)) /
             SUM(variable_value) * 100
            ) BETWEEN 30 AND 60
       THEN 'Warning'
       WHEN (MAX(IF(variable_name = 'TABLE_LOCKS_WAITED', variable_value, 0)) /
             SUM(variable_value) * 100
            ) > 60
       THEN 'Critical'
       END AS state
  FROM information_schema.global_status
 WHERE variable_name IN ('TABLE_LOCKS_WAITED', 'TABLE_LOCKS_IMMEDIATE')
UNION ALL
SELECT 'InnoDB Cache' AS category
      ,'Cache write wait required' AS division
      ,round(MAX(IF(variable_name = 'INNODB_BUFFER_POOL_WAIT_FREE', variable_value, 0)) /
             MAX(IF(variable_name = 'INNODB_BUFFER_POOL_WRITE_REQUESTS', variable_value, 0)) * 100
            ,1) AS current_percent
      ,CASE 
       WHEN (MAX(IF(variable_name = 'INNODB_BUFFER_POOL_WAIT_FREE', variable_value, 0)) /
             MAX(IF(variable_name = 'INNODB_BUFFER_POOL_WRITE_REQUESTS', variable_value, 0)) * 100
            ) BETWEEN 0.001 AND 10
       THEN 'Warning'
       WHEN (MAX(IF(variable_name = 'INNODB_BUFFER_POOL_WAIT_FREE', variable_value, 0)) /
             MAX(IF(variable_name = 'INNODB_BUFFER_POOL_WRITE_REQUESTS', variable_value, 0)) * 100
            ) > 10
       THEN 'Critical'
       END AS state
  FROM information_schema.global_status
 WHERE variable_name IN ('INNODB_BUFFER_POOL_WAIT_FREE', 'INNODB_BUFFER_POOL_WRITE_REQUESTS')
UNION ALL
SELECT 'InnoDB Cache' AS category
      ,'Cache hit ratio' AS division
      ,round(100 -
             MAX(IF(variable_name = 'INNODB_BUFFER_POOL_READS', variable_value, 0)) /
             MAX(IF(variable_name = 'INNODB_BUFFER_POOL_READ_REQUESTS', variable_value, 0)) * 100
            ,1) AS current_percent
      ,NULL AS state
      ,'InnoDB Buffer pool 에서 읽어 오는 비율' AS description_kr
  FROM information_schema.global_status
 WHERE variable_name IN ('INNODB_BUFFER_POOL_READS', 'INNODB_BUFFER_POOL_READ_REQUESTS')
UNION ALL
SELECT 'Key Cache' AS category
      ,'Cache hit ratio' AS division
      ,round(100 -
             MAX(IF(variable_name = 'KEY_READS', variable_value, 0)) /
             MAX(IF(variable_name = 'KEY_READ_REQUESTS', variable_value, 0)) * 100
            ,1) AS current_percent
      ,CASE 
       WHEN (100 -
             MAX(IF(variable_name = 'KEY_READS', variable_value, 0)) /
             MAX(IF(variable_name = 'KEY_READ_REQUESTS', variable_value, 0)) * 100
            ) < 90
       THEN 'Warning'
       END AS state
  FROM information_schema.global_status
 WHERE variable_name IN ('KEY_READS', 'KEY_READ_REQUESTS')
UNION ALL
SELECT 'Query Cache' AS category
      ,'Query Cache hit ratio' AS division
      ,round(100 -
             MAX(IF(variable_name = 'Qcache_free_blocks', variable_value, 0)) /
             MAX(IF(variable_name = 'Qcache_total_blocks', variable_value, 0)) * 100
            ,1) AS current_percent
      ,CASE 
       WHEN (100 -
             MAX(IF(variable_name = 'Qcache_free_blocks', variable_value, 0)) /
             MAX(IF(variable_name = 'Qcache_total_blocks', variable_value, 0)) * 100
            ) < 25
            OR
            (100 -
             MAX(IF(variable_name = 'Qcache_free_blocks', variable_value, 0)) /
             MAX(IF(variable_name = 'Qcache_total_blocks', variable_value, 0)) * 100
            ) > 80
       THEN 'Warning'
       END AS state
  FROM information_schema.global_status
 WHERE variable_name IN ('Qcache_free_blocks', 'Qcache_total_blocks')
UNION ALL
SELECT 'Open Table' AS category
      ,'Open Table ratio' AS division
      ,round(MAX(IF(variable_name = 'OPEN_TABLES', variable_value, 0)) /
             MAX(IF(variable_name = 'OPENED_TABLES', variable_value, 0)) * 100
            ,1) AS current_percent
      ,CASE 
       WHEN (MAX(IF(variable_name = 'OPEN_TABLES', variable_value, 0)) /
             MAX(IF(variable_name = 'OPENED_TABLES', variable_value, 0)) * 100
            ) < 85
       THEN 'Warning'
       END AS state
  FROM information_schema.global_status
 WHERE variable_name IN ('OPEN_TABLES', 'OPENED_TABLES')
UNION ALL
SELECT 'Open Table' AS category
      ,'Table Open Cache ratio' AS division
      ,round(s.variable_value / v.variable_value * 100, 1) AS current_percent
      ,CASE 
       WHEN (s.variable_value / v.variable_value * 100
            ) > 95
       THEN 'Warning'
       END AS state
  FROM information_schema.global_status s, information_schema.global_variables v
 WHERE s.variable_name IN ('OPEN_TABLES')
   AND v.variable_name IN ('TABLE_OPEN_CACHE')
UNION ALL
SELECT 'Open Files' AS category
      ,'Open Files Ratio' AS division
      ,round(s.variable_value / v.variable_value * 100, 1) AS current_percent
      ,CASE 
       WHEN (s.variable_value / v.variable_value * 100
            ) > 75
       THEN 'Warning'
       END AS state
  FROM information_schema.global_status s, information_schema.global_variables v
 WHERE s.variable_name IN ('OPEN_FILES')
   AND v.variable_name IN ('OPEN_FILES_LIMIT')
;
