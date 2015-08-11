CREATE EXTENSION postgres_fdw;
CREATE SERVER srv_pgdaycps1 FOREIGN DATA WRAPPER postgres_fdw OPTIONS (host 'pgdaycps_node1',dbname 'pgdaycps');
CREATE SERVER srv_pgdaycps2 FOREIGN DATA WRAPPER postgres_fdw OPTIONS (host 'pgdaycps_node2',dbname 'pgdaycps');
CREATE SERVER srv_pgdaycps3 FOREIGN DATA WRAPPER postgres_fdw OPTIONS (host 'pgdaycps_node3',dbname 'pgdaycps');
CREATE USER MAPPING FOR postgres SERVER srv_pgdaycps1 OPTIONS (user 'postgres', password 'postgres');
CREATE USER MAPPING FOR postgres SERVER srv_pgdaycps2 OPTIONS (user 'postgres', password 'postgres');
CREATE USER MAPPING FOR postgres SERVER srv_pgdaycps3 OPTIONS (user 'postgres', password 'postgres');
CREATE TABLE movies(movieId int,title text,others jsonb);
CREATE FOREIGN TABLE fdw_movies1 () INHERITS (movies) 
	SERVER srv_pgdaycps1 OPTIONS (schema_name 'movielens', table_name 'fdw_movies');
CREATE FOREIGN TABLE fdw_movies2 () INHERITS (movies) 
	SERVER srv_pgdaycps2 OPTIONS (schema_name 'movielens', table_name 'fdw_movies');
CREATE FOREIGN TABLE fdw_movies3 () INHERITS (movies)
	SERVER srv_pgdaycps3 OPTIONS (schema_name 'movielens', table_name 'fdw_movies');
ALTER TABLE fdw_movies1 ADD CHECK (movieid BETWEEN 1 AND 50000);
ALTER TABLE fdw_movies2 ADD CHECK (movieid BETWEEN 50001 AND 100000);
ALTER TABLE fdw_movies3 ADD CHECK (movieid BETWEEN 100001 AND 150000);
