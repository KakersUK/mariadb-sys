# mariadb-sys
The MariaDB sys schema


The project was created for the people who use Korean as native language.

But this will be helpful to anyone who understands scripts.

This project was written by getting an idea from mysql-sys project.

But all scripts have been written by myself, it did not use sources in mysql-sql project.


이 프로젝트는 한국어를 모국어로 사용하는 사람들을 위해 작성되었습니다.

< 사전 준비 사항 >

1. sys 스키마 생성

CREATE SCHEMA sys CHARACTER SET utf8 COLLATE utf8_general_ci;

2. plugin 설치 

INSTALL SONAME 'metadata_lock_info';
