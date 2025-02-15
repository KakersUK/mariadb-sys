SET NAMES utf8;
SET @sql_log_bin = @@sql_log_bin;
SET sql_log_bin = 0;

CREATE DATABASE IF NOT EXISTS sys DEFAULT CHARACTER SET utf8;

INSTALL PLUGIN metadata_lock_info SONAME 'metadata_lock_info';

USE sys;

SOURCE ./views/v_threads.sql
SOURCE ./views/v_innodb_lock.sql
SOURCE ./views/v_db_health_check.sql
SOURCE ./views/db_all_objects.sql
SOURCE ./views/db_user_privileges.sql

SOURCE ./views/v_meta_lock.sql

SET @@sql_log_bin = @sql_log_bin;
