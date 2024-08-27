-- In this SQL file, write (and comment!) the typical SQL queries users will run on your database

-- In this SQL file, write (and comment!) the typical SQL queries users will run on your database

--add new artists
INSERT INTO `artists` (`name`)
VALUES ('Tom Odell'),('Maneskin'),('Imagine Dragons');

--add a new user
INSERT INTO `users` (`username`) VALUES ('despi');

--add new albums
INSERT INTO `albums`(`artist_id`,`title`,`release_date`,`genre`)
VALUES
((SELECT `id` FROM `artists` WHERE `artists`.`name`='Tom Odell'),'Long Way Down','2013-06-24','folk,indie,pop'),
((SELECT `id` FROM `artists` WHERE `artists`.`name`='Tom Odell'),'Wrong Crowd','2016-06-10','indie,pop'),
((SELECT `id` FROM `artists` WHERE `artists`.`name`='Tom Odell'),'Jubilee Road','2018-10-26','indie,pop'),
((SELECT `id` FROM `artists` WHERE `artists`.`name`='Tom Odell'),'Monsters','2021-07-09','indie,pop'),
((SELECT `id` FROM `artists` WHERE `artists`.`name`='Tom Odell'),'Black Friday','2021-01-26','indie,pop'),
((SELECT `id` FROM `artists` WHERE `artists`.`name`='Maneskin'),'Rush','2023-01-20','rock,pop'),
((SELECT `id` FROM `artists` WHERE `artists`.`name`='Maneskin'),'Teatro d ira Vol I','2021-03-19','rock');



--add new songs
INSERT INTO `songs`(`title`,`release_date`,`album_id`,`artist_id`)
VALUES
('Coraline','2021-03-19',(SELECT `id` FROM `albums` WHERE `title`='Teatro d ira Vol I' AND `release_date`='2021-03-19'),(SELECT `id` FROM `artists` WHERE `name`='Maneskin')),
('Vent anni','2020-10-30',(SELECT `id` FROM `albums` WHERE `title`='Teatro d ira Vol I' AND `release_date`='2021-03-19'),(SELECT `id` FROM `artists` WHERE `name`='Maneskin')),
('Zitti e buoni','2021-03-19',(SELECT `id` FROM `albums` WHERE `title`='Teatro d ira Vol I' AND `release_date`='2021-03-19'),(SELECT `id` FROM `artists` WHERE `name`='Maneskin')),
('The Loneliest','2022-10-07',(SELECT `id` FROM `albums` WHERE `title`='Rush' AND `release_date`='2023-01-20'),(SELECT `id` FROM `artists` WHERE `name`='Maneskin')),
('Gossip','2023-01-13',(SELECT `id` FROM `albums` WHERE `title`='Rush' AND `release_date`='2023-01-20'),(SELECT `id` FROM `artists` WHERE `name`='Maneskin'));

--add a new playlist
INSERT INTO `playlists`(`title`,`user_id`)
VALUES
('Best Maneskin songs',(SELECT `id` FROM `users` WHERE `username`='despi'));

--populate playlist with songs
CALL `inserting_songs_in_playlists` ('The Loneliest','Maneskin','Best Maneskin songs','despi');

CALL `inserting_songs_in_playlists` ('Gossip','Maneskin','Best Maneskin songs','despi');
CALL `inserting_songs_in_playlists` ('Zitti e buoni','Maneskin','Best Maneskin songs','despi');
CALL `inserting_songs_in_playlists` ('Vent anni','Maneskin','Best Maneskin songs','despi');
CALL `inserting_songs_in_playlists` ('Coraline','Maneskin','Best Maneskin songs','despi');

-- add a new follower to an artist
CALL `inserting_into_following`('despi','Imagine Dragons');
CALL `inserting_into_following`('despi','Tom Odell');

-- add a like to a song by a certain user
CALL `inserting_into_userlikedsong`('despi','Coraline','Maneskin');

-- find all albums by an artist
SELECT `title` AS 'album title',`release_date` AS 'release date',`genre` AS 'album genre'
 FROM `albums`
 WHERE `artist_id`=(SELECT `id` FROM `artists` WHERE `name`='Tom Odell');

--find all songs in a playlist
SELECT `songtitle`,`artistname`
FROM `songs_in_playlists_view`
WHERE `playlisttitle`='Best Maneskin songs' AND `lusername`='despi';


-- find all the songs a user has liked
SELECT `songtitle`,`artistname` FROM `userlikedsong_view`
WHERE `lusername`='despi';

-- find all the artists a user is following
SELECT `artistname` FROM `following_view`
WHERE `fusername`='despi';

--update the genre of an album
UPDATE `albums`
SET `genre`='alternative,rock'
WHERE `title`='Teatro d Ira Vol I' AND 'release_date'='24-06-2013';
