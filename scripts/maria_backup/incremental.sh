sudo apt install mariadb-server mariadb-backup -y \
&& mariadb -e "create database test1" \
&& mariadb -e "create table test1.test1_tbl (id int not null auto_increment, \`desc\` varchar(100), primary key (id)); \
insert into test1.test1_tbl (\`desc\`) values ('hi'); \
insert into test1.test1_tbl (\`desc\`) values ('my name is'); \
insert into test1.test1_tbl (\`desc\`) values ('IZEX');" \
&& mkdir -p /var/mariadb_backup/full \
&& mariabackup --backup --target-dir=/var/mariadb_backup/full \
&& mariadb -e "insert into test1.test1_tbl (\`desc\`) values ('orange'); \
insert into test1.test1_tbl (\`desc\`) values ('sweet and sour');" \
&& mariabackup --backup --target-dir=/var/mariadb_backup/inc1 --incremental-basedir=/var/mariadb_backup/full \
&& mariadb -e "insert into test1.test1_tbl (\`desc\`) values ('velvet'); \
insert into test1.test1_tbl (\`desc\`) values ('overground');" \
&& mariabackup --backup --target-dir=/var/mariadb_backup/inc2 --incremental-basedir=/var/mariadb_backup/inc1 \
&& mariadb -e "drop database test1;" \
&& systemctl stop mariadb \
&& sudo rm -rf /var/lib/mysql/* \
&& mariabackup --prepare --target-dir=/var/mariadb_backup/full \
&& mariabackup --prepare --target-dir=/var/mariadb_backup/full --incremental-dir=/var/mariadb_backup/inc1 \
&& mariabackup --prepare --target-dir=/var/mariadb_backup/full --incremental-dir=/var/mariadb_backup/inc2 \
&& mariabackup --copy-back --target-dir=/var/mariadb_backup/full \
&& chown -R mysql:mysql /var/lib/mysql \
&& systemctl start mariadb \
&& mariadb -e "select * from test1.test1_tbl;"