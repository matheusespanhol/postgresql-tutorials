/* Download and install
git clone https://github.com/citusdata/pg_shard.git
cd pg_shard/
make
make install
*/

CREATE EXTENSION pg_shard;
ALTER SYSTEM SET shared_preload_libraries TO 'pg_shard';

/*
cat $PGDATA/pg_worker_list.conf
pgdaycps_node1	5432
pgdaycps_node2	5433
pgdaycps_node3	5434

pg_ctl restart
---
*/

SELECT master_create_distributed_table('movies', 'movieid');
SELECT master_create_worker_shards('movies', 21, 2);

/*
split -n l/4 movies.csv chunks/
find chunks/ -type f | xargs -n 1 -P 4 sh -c 'echo $0 `copy_to_distributed_table -C $0 movies`'
*/
