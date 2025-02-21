sudo apt install mariadb-server mariadb-backup -y \
&& mariadb -e "create database test1" \
&& mariadb -e "create table test1.test1_tbl (id int not null auto_increment, \`desc\` varchar(100), primary key (id)); \
insert into test1.test1_tbl (\`desc\`) values ('hi'); \
insert into test1.test1_tbl (\`desc\`) values ('my name is'); \
insert into test1.test1_tbl (\`desc\`) values ('IZEX');" \
&& mkdir -p /var/mariadb_backup/full \
&& mariabackup --backup --target-dir=/var/mariadb_backup/full \
&& mariadb -e "drop database test1;" \
&& systemctl stop mariadb \
&& sudo rm -rf /var/lib/mysql/* \
&& mariabackup --prepare --target-dir=/var/mariadb_backup/full \
&& mariabackup --copy-back --target-dir=/var/mariadb_backup/full \
&& chown -R mysql:mysql /var/lib/mysql \
&& systemctl start mariadb