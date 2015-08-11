/* Download
wget http://files.grouplens.org/datasets/movielens/ml-latest.zip
unzip ml-latest.zip
*/

CREATE TABLE tags (userId int,movieId int,tag text,timestamp bigint);
CREATE TABLE movies (movieId int,title text,genres text);
CREATE TABLE links (movieId int,imdbId int,tmdbId int);
CREATE TABLE ratings (userId int,movieId int,rating numeric,timestamp bigint);
COPY tags FROM '/home/postgres/ml-latest/tags.csv' CSV HEADER;
COPY movies FROM '/home/postgres/ml-latest/movies.csv' CSV HEADER;
COPY links FROM '/home/postgres/ml-latest/links.csv' CSV HEADER;
COPY ratings FROM '/home/postgres/ml-latest/ratings.csv' CSV HEADER;

CREATE TABLE movies_jsonb (movieId int,title text,others jsonb);
INSERT INTO movies_jsonb SELECT m.movieid,m.title,row_to_json(foo)::jsonb AS links_genres 
			 FROM movies m, LATERAL(
						SELECT 'https://movielens.org/movies/'||links.movieid AS link_movielens,
						       'http://www.imdb.com/title/tt'||imdbid AS link_imdb,
						       'https://www.themoviedb.org/movie/'||tmdbid AS link_themoviedb,
							(string_to_array(genres,'|')) AS genres 
						FROM movies 
						JOIN links USING(movieId) 
						WHERE movieId=m.movieId
					       ) AS foo;
