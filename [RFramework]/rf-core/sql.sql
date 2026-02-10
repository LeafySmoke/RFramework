CREATE TABLE IF NOT EXISTS `players` (
    `license` varchar(50) PRIMARY KEY,
    `money` int DEFAULT 0,
    `job` varchar(50) DEFAULT 'unemployed',
    `char_id` INT DEFAULT 1
);

CREATE TABLE IF NOT EXISTS `characters` (
    `char_id` INT AUTO_INCREMENT PRIMARY KEY,
    `license` VARCHAR(50),
    `first_name` VARCHAR(50),
    `last_name` VARCHAR(50),
    `skin` TEXT DEFAULT '{}',  -- JSON for appearance (model, components)
    `position` TEXT  -- JSON for last pos (e.g., {x=0,y=0,z=0,h=0})
);

CREATE TABLE IF NOT EXISTS `vehicles` (
    `plate` VARCHAR(8) PRIMARY KEY,
    `owner_license` VARCHAR(50),
    `model` VARCHAR(50),
    `props` TEXT  -- JSON for vehicle props (mods, color)
);