SET NAMES utf8;
SET @sql_log_bin = @@sql_log_bin;
SET sql_log_bin = 0;

CREATE DATABASE IF NOT EXISTS sys DEFAULT CHARACTER SET utf8;

INSTALL PLUGIN metadata_lock_info SONAME 'metadata_lock_info';

USE sys;

SOURCE ./views/v$threads.sql
SOURCE ./views/v$innodb_lock.sql
SOURCE ./views/v$db_checks.sql
SOURCE ./views/v$global_status_kr.sql
SOURCE ./views/db_user_privileges.sql

SOURCE ./views/v$meta_lock.sql

SET @@sql_log_bin = @sql_log_bin;
