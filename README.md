# The MariaDB sys schema

## Comment

This schema was written by getting an idea from The MySQL sys schema (https://github.com/mysql/mysql-sys).

But all scripts have been written by myself, it did not use The MySQL sys schema.

A collection of views to help MariaDB administrators get insight in to MariaDB Database usage.

There are install files available for over MariaDB 10.0.x. To load these, you must position yourself within the directory that you downloaded to.

## Installation

The objects should all be created as the root user (but run with the privileges of the invoker).

For instance if you download to /tmp/mariadb-sys/, and want to install the schema you should:

```
cd /tmp/mariadb-sys/
mysql -u root -p < ./mariadb_sys_install.sql
```

Or if you would like to log in to the client, and install the schema:

```
cd /tmp/mariadb-sys/
mysql -u root -p 
SOURCE ./mariadb_sys_install.sql
```

## Overview of objects

### db_all_objects

#### Description

List of all objects within all schemas

#### Structures

```
MariaDB [(none)]> desc sys.db_all_objects;
+-------------+--------------+------+-----+---------+-------+
| Field       | Type         | Null | Key | Default | Extra |
+-------------+--------------+------+-----+---------+-------+
| schema_name | varchar(64)  | NO   |     |         |       |
| object_type | varchar(64)  | YES  |     | NULL    |       |
| object_name | varchar(130) | YES  |     | NULL    |       |
+-------------+--------------+------+-----+---------+-------+
```

#### Example

```
MariaDB [sys]> select * from db_all_objects;
+--------------------+-------------+---------------------------------------+
| schema_name        | object_type | object_name                           |
+--------------------+-------------+---------------------------------------+
| information_schema | SYSTEM VIEW | ALL_PLUGINS                           |
| information_schema | SYSTEM VIEW | APPLICABLE_ROLES                      |
...
| sys                | INDEX(BTREE) | PRIMARY(workload_sql_text)           |
| sys                | PROCEDURE    | workload_proc_run_snapshot           |
| sys                | EVENT        | workload_event_schedule              |
+--------------------+-------------+---------------------------------------+
```

### db_user_privileges

#### Description

List of all user's privileges

#### Structures

```
MariaDB [(none)]> desc sys.db_user_privileges;
+----------------+--------------+------+-----+---------+-------+
| Field          | Type         | Null | Key | Default | Extra |
+----------------+--------------+------+-----+---------+-------+
| table_catalog  | varchar(512) | NO   |     |         |       |
| table_schema   | varchar(64)  | NO   |     |         |       |
| table_name     | varchar(64)  | NO   |     |         |       |
| table_type     | varchar(64)  | NO   |     |         |       |
| grantee        | varchar(190) | NO   |     |         |       |
| privilege_type | varchar(64)  | NO   |     |         |       |
| is_grantable   | varchar(3)   | NO   |     |         |       |
+----------------+--------------+------+-----+---------+-------+
```

#### Example

```
MariaDB [sys]> select * from db_user_privileges;
+---------------+--------------+---------------------------+------------+--------------------+----------------+--------------+
| table_catalog | table_schema | table_name                | table_type | grantee            | privilege_type | is_grantable |
+---------------+--------------+---------------------------+------------+--------------------+----------------+--------------+
| def           | sys          | db_all_objects            | VIEW       | 'root'@'localhost' | SELECT         | YES          |
| def           | sys          | db_user_privileges        | VIEW       | 'root'@'localhost' | SELECT         | YES          |
...
| def           | sys          | v$threads                 | VIEW       | 'root'@'localhost' | SELECT         | YES          |
+---------------+--------------+---------------------------+------------+--------------------+----------------+--------------+
```

### v$db_health_check

#### Description

MariaDB health check - Key Item


#### Structures

```
MariaDB [(none)]> desc sys.v$db_health_check;
+-----------------+--------------+------+-----+---------+-------+
| Field           | Type         | Null | Key | Default | Extra |
+-----------------+--------------+------+-----+---------+-------+
| category        | varchar(15)  | NO   |     |         |       |
| division        | varchar(29)  | NO   |     |         |       |
| current_percent | double(18,1) | YES  |     | NULL    |       |
| state           | varchar(8)   | YES  |     | NULL    |       |
+-----------------+--------------+------+-----+---------+-------+
```

#### Example

```
MariaDB [sys]> select * from v$db_health_check;
+-----------------+-------------------------------+-----------------+----------+
| category        | division                      | current_percent | state    |
+-----------------+-------------------------------+-----------------+----------+
| Connection      | Refued Connection             |            99.8 | Critical |
| Connection      | Connection Usage              |            44.8 | NULL     |
...
| Open Files      | Open Files Ratio              |             0.2 | NULL     |
+-----------------+-------------------------------+-----------------+----------+
```

### v$innodb_lock ★

#### Description

Current InnoDB row level lock

If you want to kill thread, you can referenced the "kill_thread" column.

Only the top-level lock is displayed as the holder. The rest threads are displayed as waiters.

If kill the top-level lock, the top-level lock in the rest threads will become the holder.

#### Structures

```
MariaDB [(none)]> desc sys.v$innodb_lock;
+---------------------------+---------------------+------+-----+---------------------+-------+
| Field                     | Type                | Null | Key | Default             | Extra |
+---------------------------+---------------------+------+-----+---------------------+-------+
| thread_id                 | varchar(25)         | YES  |     | NULL                |       |
| thread_status             | varchar(16)         | NO   |     |                     |       |
| trx_state                 | varchar(13)         | NO   |     |                     |       |
| trx_started               | datetime            | NO   |     | 0000-00-00 00:00:00 |       |
| trx_wait_started          | datetime            | YES  |     | NULL                |       |
| wait_secs                 | bigint(21)          | YES  |     | NULL                |       |
| lock_type                 | varchar(67)         | YES  |     | NULL                |       |
| lock_table                | varchar(1024)       | YES  |     |                     |       |
| lock_index                | varchar(1024)       | YES  |     | NULL                |       |
| trx_query                 | varchar(1024)       | YES  |     | NULL                |       |
| trx_operation_state       | varchar(64)         | YES  |     | NULL                |       |
| waiting_trx_rows_locked   | bigint(21) unsigned | NO   |     | 0                   |       |
| waiting_trx_rows_modified | bigint(21) unsigned | NO   |     | 0                   |       |
| trx_lock_memory_bytes     | bigint(21) unsigned | NO   |     | 0                   |       |
| kill_thread               | varchar(26)         | YES  |     | NULL                |       |
+---------------------------+---------------------+------+-----+---------------------+-------+
```

#### Example

### v$meta_lock ★

#### Description

Current Metadata lock info

If you want to kill thread, you can referenced the "kill_thread" column.

#### Structures

```
MariaDB [(none)]> desc sys.v$meta_lock;
+--------------------+--------------+------+-----+---------+-------+
| Field              | Type         | Null | Key | Default | Extra |
+--------------------+--------------+------+-----+---------+-------+
| schema_name        | varchar(64)  | YES  |     | NULL    |       |
| object_name        | varchar(64)  | YES  |     | NULL    |       |
| meta_lock_type     | varchar(30)  | YES  |     | NULL    |       |
| meta_lock_mode     | varchar(24)  | YES  |     | NULL    |       |
| meta_lock_duration | varchar(30)  | YES  |     | NULL    |       |
| thread_id          | bigint(4)    | YES  |     | 0       |       |
| user               | varchar(193) | YES  |     | NULL    |       |
| thread_status      | varchar(16)  | YES  |     |         |       |
| thread_time_sec    | int(7)       | YES  |     | 0       |       |
| thread_info        | longtext     | YES  |     | NULL    |       |
| kill_thread        | varchar(25)  | YES  |     | NULL    |       |
+--------------------+--------------+------+-----+---------+-------+
```

#### Example

```
MariaDB [sys]> select * from v$meta_lock;
+-------------+-------------------+-----------------+------------------+--------------------+-----------+--------------------+---------------+-----------------+---------------------------+-------------+
| schema_name | object_name       | meta_lock_type  | meta_lock_mode   | meta_lock_duration | thread_id | user               | thread_status | thread_time_sec | thread_info               | kill_thread |
+-------------+-------------------+-----------------+------------------+--------------------+-----------+--------------------+---------------+-----------------+---------------------------+-------------+
| sys         | v$meta_lock       | Table           | MDL_SHARED_READ  | MDL_TRANSACTION    |    303860 | root@localhost     | Query         |               0 | select * from v$meta_lock | KILL 303860 |
+-------------+-------------------+-----------------+------------------+--------------------+-----------+--------------------+---------------+-----------------+---------------------------+-------------+
```

### v$threads ★

#### Description

Current all threads

#### Structures

```
MariaDB [(none)]> desc sys.v$threads;
+-------------------+---------------------+------+-----+---------+-------+
| Field             | Type                | Null | Key | Default | Extra |
+-------------------+---------------------+------+-----+---------+-------+
| thread_id         | bigint(4)           | NO   |     | 0       |       |
| user              | varchar(197)        | YES  |     | NULL    |       |
| schema_name       | varchar(64)         | YES  |     | NULL    |       |
| thread_status     | varchar(16)         | NO   |     |         |       |
| thread_sec        | int(7)              | NO   |     | 0       |       |
| memory_used       | int(7)              | NO   |     | 0       |       |
| thread_state      | varchar(64)         | YES  |     | NULL    |       |
| thread_info       | longtext            | YES  |     | NULL    |       |
| trx_existence     | varchar(3)          | NO   |     |         |       |
| trx_id            | varchar(18)         | YES  |     |         |       |
| trx_rows_modified | bigint(21) unsigned | YES  |     | 0       |       |
| lock_wait_sec     | bigint(21)          | YES  |     | NULL    |       |
| lock_table        | varchar(1024)       | YES  |     |         |       |
| lock_index        | varchar(1024)       | YES  |     | NULL    |       |
| lock_type         | varchar(32)         | YES  |     |         |       |
+-------------------+---------------------+------+-----+---------+-------+
```

#### Example

```
MariaDB [sys]> select * from v$threads;
+-----------+-------------------------------+-------------+---------------+------------+-------------+-----------------------------+-------------------------+---------------+--------+-------------------+---------------+------------+------------+-----------+
| thread_id | user                          | schema_name | thread_status | thread_sec | memory_used | thread_state                | thread_info             | trx_existence | trx_id | trx_rows_modified | lock_wait_sec | lock_table | lock_index | lock_type |
+-----------+-------------------------------+-------------+---------------+------------+-------------+-----------------------------+-------------------------+---------------+--------+-------------------+---------------+------------+------------+-----------+
|       368 | `root`@`localhost`            | sys         | Query         |          0 |      844672 | Filling schema table        | select * from v$threads | NO            | NULL   |              NULL |          NULL | NULL       | NULL       | NULL      |
...
|         2 | `event_scheduler`@`localhost` | NULL        | Daemon        |        149 |       44280 | Waiting for next activation | NULL                    | NO            | NULL   |              NULL |          NULL | NULL       | NULL       | NULL      |
+-----------+-------------------------------+-------------+---------------+------------+-------------+-----------------------------+-------------------------+---------------+--------+-------------------+---------------+------------+------------+-----------+
```
