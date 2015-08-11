/* Download and install
cd /usr/local/src
wget http://pgfoundry.org/frs/download.php/3392/plproxy-2.5.tar.gz
tar zxvf plproxy-2.5.tar.gz
cd plproxy-2.5
yum -y install gcc gcc-c++ flex bison
make
make install/
*/
CREATE EXTENSION plproxy;
CREATE SERVER srv_pgdaycps FOREIGN DATA WRAPPER plproxy OPTIONS (connection_lifetime '1800', 
p0 'dbname=pgdaycps host=pgdaycps_node0 port=5432',
p1 'dbname=pgdaycps host=pgdaycps_node1 port=5432',
p2 'dbname=pgdaycps host=pgdaycps_node2 port=5432',
p3 'dbname=pgdaycps host=pgdaycps_node3 port=5432'
);
CREATE USER MAPPING FOR proxy SERVER srv_pgdaycps OPTIONS (user 'node_user', password 'node_pass');

-- Nodes
CREATE TABLE plproxy_movies AS SELECT * FROM movies_jsonb;

CREATE FUNCTION insert_movies(movieId int,title text,others jsonb)
RETURNS void AS $$
BEGIN
        INSERT INTO plproxy_movies VALUES (movieId,title,others);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION select_movies(fmovieId int)
RETURNS TABLE(tmovieId int,title text,others jsonb) AS $$
BEGIN
       RETURN QUERY SELECT * FROM plproxy_movies WHERE movieid = fmovieId;
END;
$$ LANGUAGE plpgsql;

-- Master
CREATE OR REPLACE FUNCTION insert_movies(movieId int,title text,others jsonb)
RETURNS void AS $$
    CLUSTER 'srv_pgdaycps';
    RUN ON hashtext(movieId::text);
$$ LANGUAGE plproxy;

CREATE OR REPLACE FUNCTION select_movies(fmovieId int)
RETURNS TABLE(tmovieId int,title text,others jsonb) AS $$
    CLUSTER 'srv_pgdaycps';
    RUN ON ALL;
$$ LANGUAGE plproxy;

CREATE OR REPLACE FUNCTION select_movies(fmovieId int)
RETURNS TABLE(tmovieId int,title text,others jsonb) AS $$
    CLUSTER 'srv_pgdaycps';
    RUN ON hashtext(fmovieId::text);
$$ LANGUAGE plproxy;
