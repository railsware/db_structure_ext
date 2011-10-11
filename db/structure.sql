CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(127) DEFAULT NULL,
  `state` varchar(127) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_review_users_on_email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `profiles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `address1` varchar(127) DEFAULT NULL,
  `address2` varchar(127) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE pending_users (
  `id` int(11),
  `email` varchar(127)
) ENGINE=MyISAM;

CREATE TABLE active_users (
  `id` int(11),
  `email` varchar(127)
) ENGINE=MyISAM;

DROP TABLE IF EXISTS pending_users;

DROP VIEW IF EXISTS pending_users;

CREATE VIEW `pending_users` AS select `users`.`id` AS `id`,`users`.`email` AS `email` from `users` where (`users`.`state` = 'pending');

DROP TABLE IF EXISTS active_users;

DROP VIEW IF EXISTS active_users;

CREATE VIEW `active_users` AS select `users`.`id` AS `id`,`users`.`email` AS `email` from `users` where (`users`.`state` = 'active');

CREATE TRIGGER update_user_state_on_insert BEFORE INSERT ON users FOR EACH ROW begin
  set NEW.state = 'pending';
end;

CREATE PROCEDURE `fix_user_state`()
BEGIN
  UPDATE users SET users.state = 'pending'
  WHERE  state IS NULL;
END;

CREATE FUNCTION `hello`(s char(20)) RETURNS char(50) CHARSET utf8
    DETERMINISTIC
RETURN CONCAT('Hello, ',s,'!');

