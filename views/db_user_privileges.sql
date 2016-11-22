#
# Name: db_user_privilegs
# Author: YJ
# Last Update: 2016.11.22
# Desc: show list of user's privileges
#
# MariaDB [sys]> select * from db_user_privileges;
# +---------------+--------------------+-----------------+----------------+--------------+------------+-------------+--------------+
# | table_catalog | grantee            | privilege_scope | privilege_type | table_schema | table_name | column_name | is_grantable |
# +---------------+--------------------+-----------------+----------------+--------------+------------+-------------+--------------+
# | def           | 'root'@'localhost' | GLOBAL          | SELECT         | NULL         | NULL       | NULL        | YES          |
# ...
# | def           | 'tester'@'%'       | SCHEMA          | SELECT         | test         | NULL       | NULL        | NO           |
# | def           | 'tester'@'%'       | SCHEMA          | INSERT         | test         | NULL       | NULL        | NO           |
# | def           | 'tester'@'%'       | SCHEMA          | UPDATE         | test         | NULL       | NULL        | NO           |
# +---------------+--------------------+-----------------+----------------+--------------+------------+-------------+--------------+
CREATE
ALGORITHM=UNDEFINED
DEFINER=`root`@`localhost`
SQL SECURITY INVOKER
VIEW `sys`.`db_user_privileges`
AS
SELECT u_p.table_catalog AS table_catalog
      ,u_p.grantee AS grantee
      ,'GLOBAL' AS privilege_scope
      ,u_p.privilege_type AS privilege_type
      ,NULL AS table_schema
      ,NULL AS table_name
      ,NULL AS column_name
      ,u_p.is_grantable AS is_grantable
  FROM information_schema.user_privileges u_p
UNION ALL
SELECT s_p.table_catalog AS table_catalog
      ,s_p.grantee AS grantee
      ,'SCHEMA' AS privilege_scope
      ,s_p.privilege_type AS privilege_type
      ,s_p.table_schema AS table_schema
      ,NULL AS table_name
      ,NULL AS column_name
      ,s_p.is_grantable AS is_grantable
  FROM information_schema.schema_privileges s_p
 WHERE NOT EXISTS (SELECT 1
          FROM information_schema.user_privileges u_p
         WHERE u_p.grantee = s_p.grantee
           AND u_p.table_catalog = s_p.table_catalog
           AND u_p.privilege_type = s_p.privilege_type)
UNION ALL
SELECT t_p.table_catalog AS table_catalog
      ,t_p.grantee AS grantee
      ,'TABLE' AS privilege_scope
      ,t_p.privilege_type AS privilege_type
      ,t_p.table_schema AS table_schema
      ,t_p.table_name AS table_name
      ,NULL AS column_name
      ,t_p.is_grantable AS is_grantable
  FROM information_schema.table_privileges t_p
 WHERE NOT EXISTS (SELECT 1
          FROM information_schema.user_privileges u_p
         WHERE u_p.grantee = t_p.grantee
           AND u_p.table_catalog = t_p.table_catalog
           AND u_p.privilege_type = t_p.privilege_type)
   AND NOT EXISTS (SELECT 1
          FROM information_schema.schema_privileges s_p
         WHERE s_p.grantee = t_p.grantee
           AND s_p.table_catalog = t_p.table_catalog
           AND s_p.table_schema = t_p.table_schema
           AND s_p.privilege_type = t_p.privilege_type)
UNION ALL
SELECT c_p.table_catalog AS table_catalog
      ,c_p.grantee AS grantee
      ,'COLUMN' AS privilege_scope
      ,c_p.privilege_type AS privilege_type
      ,c_p.table_schema AS table_schema
      ,c_p.table_name AS table_name
      ,c_p.column_name AS column_name
      ,c_p.is_grantable AS is_grantable
  FROM information_schema.column_privileges c_p
 WHERE NOT EXISTS (SELECT 1
          FROM information_schema.user_privileges u_p
         WHERE u_p.grantee = c_p.grantee
           AND u_p.table_catalog = c_p.table_catalog
           AND u_p.privilege_type = c_p.privilege_type)
   AND NOT EXISTS (SELECT 1
          FROM information_schema.schema_privileges s_p
         WHERE s_p.grantee = c_p.grantee
           AND s_p.table_catalog = c_p.table_catalog
           AND s_p.table_schema = c_p.table_schema
           AND s_p.privilege_type = c_p.privilege_type)
   AND NOT EXISTS (SELECT 1
          FROM information_schema.table_privileges t_p
         WHERE t_p.grantee = c_p.grantee
           AND t_p.table_catalog = c_p.table_catalog
           AND t_p.table_schema = c_p.table_schema
           AND t_p.table_name = c_p.table_name
           AND t_p.privilege_type = c_p.privilege_type)
;
