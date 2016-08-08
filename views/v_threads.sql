#
# Name: v$threads
# Author: YJ
# Date: 2016.06.27
# MariaDB에 있는 쓰레드 현황 보기
# 
CREATE OR REPLACE
ALGORITHM=UNDEFINED 
DEFINER = 'root'@'localhost'
SQL SECURITY INVOKER
VIEW sys.`v$threads`
AS
SELECT p.id AS thread_id
      ,concat('`', p.user, '`@`', substring_index(p.host, ':', 1), '`') AS user
      ,p.db AS schema_name
      ,p.command AS thread_status
      ,p.time AS thread_sec
      ,p.memory_used
      ,p.state AS thread_state
      ,p.info AS thread_info
      ,if(trx.trx_state is not null, 'YES', 'NO') AS trx_existence
      ,trx.trx_id
      ,trx.trx_rows_modified
      ,timestampdiff(SECOND, trx.trx_wait_started, now()) AS lock_wait_sec
      ,locks.lock_table
      ,locks.lock_index
      ,locks.lock_type
  FROM information_schema.processlist p
  LEFT JOIN information_schema.innodb_trx trx
    ON p.id = trx.trx_mysql_thread_id
  LEFT JOIN information_schema.innodb_locks locks
    ON trx.trx_id = locks.lock_trx_id
;
