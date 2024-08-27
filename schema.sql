
-- REPRESENT ARTISTS
CREATE TABLE `artists`(
    `id` INT UNSIGNED AUTO_INCREMENT,
    `name` VARCHAR(30) NOT NULL,
    PRIMARY KEY (`id`)
);

-- REPRESENT USERS;
CREATE TABLE `users`(
    `id` INT UNSIGNED AUTO_INCREMENT,
    `username` VARCHAR(20) UNIQUE NOT NULL,
    PRIMARY KEY(`id`)
);

-- REPRESENT ALBUMS
CREATE TABLE `albums`(
    `id` INT UNSIGNED AUTO_INCREMENT,
    `artist_id` INT UNSIGNED,
    `title` VARCHAR(30) NOT NULL,
    `release_date` DATE NOT NULL,
    `genre` SET('pop','rock','folk','rnb','jazz','indie','metal','alternative') NOT NULL,
    PRIMARY KEY(`id`),
    FOREIGN KEY(`artist_id`) REFERENCES `artists`(`id`)
);

-- REPRESENT SONGS
CREATE TABLE `songs`(
    `id` INT UNSIGNED AUTO_INCREMENT,
    `artist_id` INT UNSIGNED,
    `title` VARCHAR(30) NOT NULL,
    `release_date` DATE NOT NULL,
    `album_id` INT UNSIGNED,
    PRIMARY KEY(`id`),
    FOREIGN KEY(`artist_id`) REFERENCES `artists`(`id`),
    FOREIGN KEY(`album_id`) REFERENCES `albums`(`id`)
);

-- REPRESENT PLAYLISTS CREATED BY USERS
CREATE TABLE `playlists`(
    `id` INT UNSIGNED AUTO_INCREMENT,
    `title` VARCHAR(50) NOT NULL,
    `user_id` INT UNSIGNED,
    PRIMARY KEY(`id`),
    FOREIGN KEY(`user_id`) REFERENCES `users`(`id`)
);

-- REPRESENT TABLE REPRESENTING SONGS IN PLAYLISTS
CREATE TABLE `songs_in_playlists`(
    `id` INT UNSIGNED AUTO_INCREMENT,
    `song_id` INT UNSIGNED,
    `playlist_id` INT UNSIGNED,
    PRIMARY KEY (`id`),
    FOREIGN KEY(`song_id`) REFERENCES `songs`(`id`),
    FOREIGN KEY(`playlist_id`) REFERENCES `playlists`(`id`)
);

-- REPRESENT TABLE CONNECTING USERS AND ARTISTS THEY FOLLOW
CREATE TABLE `following`(
    `id` INT UNSIGNED AUTO_INCREMENT,
    `artist_id` INT UNSIGNED,
    `user_id` INT UNSIGNED,
    PRIMARY KEY(`id`),
    FOREIGN KEY(`artist_id`) REFERENCES `artists`(`id`),
    FOREIGN KEY(`user_id`) REFERENCES `users`(`id`)
);

-- REPRESENT TABLE CONNECTING USERS AND SONGS THEY HAVE LIKED
CREATE TABLE `userlikedsong`(
    `id` INT UNSIGNED AUTO_INCREMENT,
    `song_id` INT UNSIGNED,
    `user_id` INT UNSIGNED,
    PRIMARY KEY(`id`),
    FOREIGN KEY(`song_id`) REFERENCES `songs`(`id`),
    FOREIGN KEY(`user_id`) REFERENCES `users`(`id`)
);


-- CREATE VIEWS

-- VIEW FOR SELECTING DATA CONNECTING PLAYLISTS WITH SONGS THEY INCLUDE
CREATE VIEW `songs_in_playlists_view` AS
SELECT `songs`.`title` AS `songtitle`,`artists`.`name` AS `artistname`,`playlists`.`title` AS `playlisttitle`,`users`.`username` AS `lusername`
 FROM `songs` JOIN `songs_in_playlists` ON `songs`.`id`=`songs_in_playlists`.`song_id`
 JOIN `playlists` ON `playlists`.`id`=`songs_in_playlists`.`playlist_id`
 JOIN `users` ON `playlists`.`user_id`=`users`.`id` JOIN `artists` ON `artists`.`id`=`songs`.`artist_id`;

-- VIEW FOR SELECTING DATA CONNECTING USERS WITH SONGS THEY HAVE LIKED
CREATE VIEW `userlikedsong_view` AS
SELECT `songs`.`title` AS `songtitle`,`artists`.`name` AS `artistname`,`users`.`username` AS `lusername`
 FROM `songs` JOIN `userlikedsong` ON `songs`.`id`=`userlikedsong`.`song_id`
 JOIN `users` ON `users`.`id`=`userlikedsong`.`user_id`
 JOIN `artists` ON `artists`.`id`=`songs`.`artist_id`;


-- VIEW CONNECTING USERS AND ARTISTS THEY FOLLOW
CREATE VIEW `following_view` AS
SELECT
`artists`.`name` AS `artistname`,`users`.`username` AS `fusername`
 FROM `users` JOIN `following` ON `users`.`id`=`following`.`user_id`
JOIN `artists` ON `artists`.`id`=`following`.`artist_id`;


-- CREATE INDEXES TO SPEED UP COMMON QUERIES
CREATE INDEX `artist_name_search` ON `artists`(`name`);
CREATE INDEX `songs_title_search` ON `songs`(`title`);

-- CREATE PROCEDURES TO SIMPLIFY  INSERT QUERIES

delimiter //
-- PROCEDURE FOR INSERTING INTO `following` TABLE
CREATE PROCEDURE `inserting_into_following` (IN `lusername` VARCHAR(20),
IN `artistname` VARCHAR(30))
BEGIN
INSERT INTO `following`(`artist_id`,`user_id`)
SELECT `artists`.`id`,`users`.`id` FROM `artists`,`users`
 WHERE `artists`.`name`=`artistname` AND `users`.`username`=`lusername`;
END//

-- PROCEDURE FOR INSERTING INTO `userlikedsong` TABLE

CREATE PROCEDURE `inserting_into_userlikedsong` (IN `lusername` VARCHAR(20),
 IN `songtitle` VARCHAR(30), IN `artistname` VARCHAR(30))
BEGIN
INSERT INTO `userlikedsong`(`song_id`,`user_id`)
VALUES
((SELECT `songs`.`id` FROM `songs` JOIN `artists` ON `artists`.`id`=`songs`.`artist_id` WHERE `songs`.`title`=`songtitle` AND `artists`.`name`=`artistname`),
(SELECT `users`.`id` FROM `users` WHERE `users`.`username`=`lusername`));
END//


-- PROCEDURE FOR INSERTING INTO `songs_in_playlists` table
CREATE PROCEDURE `inserting_songs_in_playlists` (IN `songtitle` VARCHAR(30),
IN `artistname` VARCHAR(30), IN `playlisttitle` VARCHAR(50),
IN `lusername` VARCHAR(20))
BEGIN
INSERT INTO `songs_in_playlists`(`song_id`,`playlist_id`)
SELECT `songs`.`id`,`playlists`.`id` FROM `songs` JOIN `artists` ON `artists`.`id`=`songs`.`artist_id`,`playlists`
 WHERE `songs`.`title`=`songtitle` AND `artists`.`name`=`artistname`
 AND `playlists`.`title`=`playlisttitle`
  AND `playlists`.`user_id`=(SELECT `id` FROM `users` WHERE `users`.`username`=`lusername`);
END//
delimiter ;