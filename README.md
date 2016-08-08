# The Author remarks (저자의 말)

This schema was written by getting an idea from The MySQL sys schema (https://github.com/mysql/mysql-sys).

But all scripts have been written by myself, it did not use The MySQL sys schema.

이 스키마는 MySQL sys 스키마에서 아이디어를 얻어서 작성됐지만, 모두 제가 직접 작성한 것 입니다.

# The MariaDB sys schema

A collection of views to help MariaDB administrators get insight in to MariaDB Database usage.

There are install files available for over MariaDB 10.0.x. To load these, you must position yourself within the directory that you downloaded to.

이 스키마는 MariaDB 10.0.x 이상에서 사용 가능하며, 설치할 때는 소스가 위치한 경로에서 설치를 실행해야 합니다.

* Caution

The most of views are for any users, but the views of the suffix "_kr" are only for Korean users. 

접미어가 "_kr"인 뷰는 한국인만을 위한 뷰입니다.

## Installation (설치)

The objects should all be created as the root user (but run with the privileges of the invoker).

오브젝트들은 root 사용자로 생성되어야 합니다. (단, 실행할 때는 invoker 권한을 사용합니다.)

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

## Overview of objects (객체개요)

to be continue...
