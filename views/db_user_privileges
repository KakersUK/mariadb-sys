#
# Name: db_user_privilegs
# Author: YJ
# Date: 2016.07.19
# Desc: user privileges list
#
CREATE OR REPLACE
ALGORITHM=UNDEFINED
DEFINER = 'root'@'localhost'
SQL SECURITY INVOKER
VIEW sys.`db_user_privileges`
AS
SELECT t.table_catalog
      ,t.table_schema
      ,t.table_name
      ,t.table_type
      ,p.grantee
      ,p.privilege_type
      ,p.is_grantable
  FROM information_schema.tables t
  JOIN information_schema.user_privileges p
    ON t.table_catalog = p.table_catalog
UNION ALL
SELECT t.table_catalog
      ,t.table_schema
      ,t.table_name
      ,t.table_type
      ,p.grantee
      ,p.privilege_type
      ,p.is_grantable
  FROM information_schema.tables t
  JOIN information_schema.schema_privileges p
    ON t.table_catalog = p.table_catalog
   AND t.table_schema = p.table_schema
UNION ALL
SELECT t.table_catalog
      ,t.table_schema
      ,t.table_name
      ,t.table_type
      ,p.grantee
      ,p.privilege_type
      ,p.is_grantable
  FROM information_schema.tables t
  JOIN information_schema.table_privileges p
    ON t.table_catalog = p.table_catalog
   AND t.table_schema = p.table_schema
   AND t.table_name = p.table_name
;
