/* Download and install
wget http://ufpr.dl.sourceforge.net/project/postgres-xl/Releases/Version_9.2rc/postgres-xl-v9.2-src.tar.gz
yum install openjade docbook-dsssl docbook-utils docbook-style-dsssl
tar zxvf postgres-xl-v9.2-src.tar.gz
cd postgres-xl
./configure --prefix=/usr/local/postgres-xl-9.2
make
make install
cd contrib/pgxc_ctl
make
make install
ln -s /usr/local/postgres-xl-9.2 /usr/local/pgsql

su - postgres
pgxc_ctl prepare
(vim ~/pgxc_ctl/pgxc_ctl.conf)
pgxc_ctl init all
*/

CREATE TABLE ratings (userId int,movieId int,rating numeric,timestamp bigint) DISTRIBUTE BY HASH (movieId);
COPY ratings FROM '/home/postgres/ml-latest/ratings.csv' CSV HEADER;
