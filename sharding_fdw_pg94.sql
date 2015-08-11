CREATE EXTENSION postgres_fdw;
CREATE SERVER srv_pgdaycps1 FOREIGN DATA WRAPPER postgres_fdw OPTIONS (host 'pgdaycps_node1',dbname 'pgdaycps');
CREATE SERVER srv_pgdaycps2 FOREIGN DATA WRAPPER postgres_fdw OPTIONS (host 'pgdaycps_node2',dbname 'pgdaycps');
CREATE SERVER srv_pgdaycps3 FOREIGN DATA WRAPPER postgres_fdw OPTIONS (host 'pgdaycps_node3',dbname 'pgdaycps');
CREATE USER MAPPING FOR postgres SERVER srv_pgdaycps1 OPTIONS (user 'postgres', password 'postgres');
CREATE USER MAPPING FOR postgres SERVER srv_pgdaycps2 OPTIONS (user 'postgres', password 'postgres');
CREATE USER MAPPING FOR postgres SERVER srv_pgdaycps3 OPTIONS (user 'postgres', password 'postgres');
CREATE FOREIGN TABLE fdw_movies1 (movieId int,title text,others jsonb) 
	SERVER srv_pgdaycps1 OPTIONS (schema_name 'movielens', table_name 'fdw_movies');
CREATE FOREIGN TABLE fdw_movies2 (movieId int,title text,others jsonb) 
	SERVER srv_pgdaycps2 OPTIONS (schema_name 'movielens', table_name 'fdw_movies');
CREATE FOREIGN TABLE fdw_movies3 (movieId int,title text,others jsonb) 
	SERVER srv_pgdaycps3 OPTIONS (schema_name 'movielens', table_name 'fdw_movies');
CREATE OR REPLACE VIEW fdw_movies AS
        SELECT 'node1' AS node,* FROM fdw_movies1
        UNION ALL
        SELECT 'node2' AS node,* FROM fdw_movies2
        UNION ALL
        SELECT 'node3' AS node,* FROM fdw_movies3;
