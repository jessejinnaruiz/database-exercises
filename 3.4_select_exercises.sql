USE albums_db;
DESCRIBE albums;
SELECT * FROM albums_db.albums;

-- The name of all albums by Pink Floyd
SELECT * FROM albums_db.albums WHERE artist = 'Pink Floyd';

-- The year Sgt. Pepper's Lonely Hearts Club Band was released
SELECT release_date FROM albums_db.albums WHERE name = 'Sgt. Pepper\'s Lonely Hearts Club Band';

-- The genre for the album Nevermind
SELECT genre FROM albums_db.albums WHERE name = 'Nevermind';

-- Which albums were released in the 1990s
SELECT * FROM albums_db.albums WHERE release_date BETWEEN 1990 AND 2000;

-- Which albums had less than 20 million certified sales
SELECT * FROM albums_db.albums WHERE sales < 20;

-- All the albums with a genre of "Rock". Why do these query results not include albums with a genre of "Hard rock" or "Progressive rock"?
SELECT * FROM albums_db.albums WHERE genre = 'Rock';
-- this is because it looks for exact string matches.
SELECT * FROM albums_db.albums WHERE genre LIKE '%Rock%';
-- this query finds geners that contain the word rock with other characters on either side of the word 'rock'

