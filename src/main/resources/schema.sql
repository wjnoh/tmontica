-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema tmontica
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `tmontica` ;

-- -----------------------------------------------------
-- Schema tmontica
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `tmontica` DEFAULT CHARACTER SET utf8 ;
USE `tmontica` ;

-- -----------------------------------------------------
-- Table `tmontica`.`banners`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tmontica`.`banners` ;

CREATE TABLE IF NOT EXISTS `tmontica`.`banners` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `use_page` VARCHAR(255) NULL DEFAULT NULL,
  `usable` TINYINT(1) NOT NULL,
  `img` VARCHAR(255) NOT NULL,
  `link` VARCHAR(255) NOT NULL,
  `start_date` DATETIME NULL DEFAULT NULL,
  `end_date` DATETIME NULL DEFAULT NULL,
  `creator_id` VARCHAR(45) NOT NULL,
  `number` INT(11) NULL DEFAULT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `tmontica`.`users`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tmontica`.`users` ;

CREATE TABLE IF NOT EXISTS `tmontica`.`users` (
  `name` VARCHAR(45) NOT NULL,
  `id` VARCHAR(45) NOT NULL,
  `email` VARCHAR(255) NOT NULL,
  `birth_date` DATETIME NOT NULL,
  `password` VARCHAR(100) NOT NULL,
  `role` CHAR(10) NOT NULL DEFAULT 'user',
  `created_date` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `point` INT(11) NOT NULL DEFAULT '0',
  `is_active` TINYINT(1) NOT NULL DEFAULT 0,
  `activate_code` VARCHAR(45) NULL,
  PRIMARY KEY (`id`))

ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `tmontica`.`find_id`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tmontica`.`find_id` ;

CREATE TABLE `tmontica`.`find_id` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `auth_code` VARCHAR(45) NULL,
  `find_ids` VARCHAR (255) NULL,
  PRIMARY KEY (`id`))

ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `tmontica`.`menus`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tmontica`.`menus` ;

CREATE TABLE IF NOT EXISTS `tmontica`.`menus` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `name_eng` VARCHAR(45) NOT NULL,
  `product_price` INT(11) NOT NULL,
  `category_ko` VARCHAR(45) NOT NULL,
  `category_eng` VARCHAR(45) NOT NULL,
  `monthly_menu` TINYINT(1) NOT NULL,
  `usable` TINYINT(1) NOT NULL,
  `img_url` VARCHAR(255) NOT NULL,
  `description` VARCHAR(255) NULL DEFAULT NULL,
  `sell_price` INT(11) NOT NULL,
  `discount_rate` INT(11) NOT NULL DEFAULT '0',
  `created_date` DATETIME NOT NULL,
  `updated_date` DATETIME NULL DEFAULT NULL,
  `creator_id` VARCHAR(45) NOT NULL,
  `updater_id` VARCHAR(45) NULL DEFAULT NULL,
  `stock` INT(11) NOT NULL,
  `name_ko` VARCHAR(45) NOT NULL,
  `start_date` DATETIME NULL,
  `end_date` DATETIME NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `tmontica`.`cart_menus`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tmontica`.`cart_menus` ;

CREATE TABLE IF NOT EXISTS `tmontica`.`cart_menus` (
  `quantity` INT(11) NOT NULL,
  `option` VARCHAR(255) NULL DEFAULT NULL,
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `user_id` VARCHAR(45) NOT NULL,
  `price` INT(11) NOT NULL,
  `menu_id` INT(11) NOT NULL,
  `direct` TINYINT(1),
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_Cart_item_User`
    FOREIGN KEY (`user_id`)
    REFERENCES `tmontica`.`users` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_cart_menu_menu1`
    FOREIGN KEY (`menu_id`)
    REFERENCES `tmontica`.`menus` (`id`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

-- -----------------------------------------------------
-- Table `tmontica`.`options`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tmontica`.`options` ;

CREATE TABLE IF NOT EXISTS `tmontica`.`options` (
  `name` VARCHAR(45) NOT NULL,
  `price` INT(11) NOT NULL,
  `type` VARCHAR(45) NOT NULL,
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `tmontica`.`menu_options`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tmontica`.`menu_options` ;

CREATE TABLE IF NOT EXISTS `tmontica`.`menu_options` (
  `menu_id` INT(11) NOT NULL,
  `option_id` INT(11) NOT NULL,
  PRIMARY KEY (`menu_id`, `option_id`),
  CONSTRAINT `fk_menu_has_option_menu2`
    FOREIGN KEY (`menu_id`)
    REFERENCES `tmontica`.`menus` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_menu_has_option_option2`
    FOREIGN KEY (`option_id`)
    REFERENCES `tmontica`.`options` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

-- -----------------------------------------------------
-- Table `tmontica`.`orders`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tmontica`.`orders` ;

CREATE TABLE IF NOT EXISTS `tmontica`.`orders` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `order_date` DATETIME NOT NULL,
  `payment` VARCHAR(45) NOT NULL,
  `total_price` INT(11) NOT NULL,
  `used_point` INT(11) NULL DEFAULT NULL,
  `real_price` INT(11) NOT NULL,
  `status` CHAR(10) NOT NULL,
  `user_id` VARCHAR(45) NOT NULL,
  `user_agent` VARCHAR(255) NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_order_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `tmontica`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `tmontica`.`order_details`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tmontica`.`order_details` ;

CREATE TABLE IF NOT EXISTS `tmontica`.`order_details` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `order_id` INT NOT NULL,
  `option` VARCHAR(255) NULL DEFAULT NULL,
  `price` INT(11) NOT NULL,
  `quantity` INT(11) NOT NULL,
  `menu_id` INT(11) NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_order_detail_menu1`
    FOREIGN KEY (`menu_id`)
    REFERENCES `tmontica`.`menus` (`id`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_order_detail_order1`
    FOREIGN KEY (`order_id`)
    REFERENCES `tmontica`.`orders` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

-- -----------------------------------------------------
-- Table `tmontica`.`order_status_logs`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tmontica`.`order_status_logs` ;

CREATE TABLE IF NOT EXISTS `tmontica`.`order_status_logs` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `status_type` VARCHAR(45) NOT NULL,
  `editor_id` VARCHAR(45) NOT NULL,
  `order_id` INT NOT NULL,
  `modified_date` DATETIME NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_order_status_log_order1`
    FOREIGN KEY (`order_id`)
    REFERENCES `tmontica`.`orders` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;



-- -----------------------------------------------------
-- Table `tmontica`.`points`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tmontica`.`points` ;

CREATE TABLE IF NOT EXISTS `tmontica`.`points` (
  `user_id` VARCHAR(45) NOT NULL,
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `type` CHAR(10) NOT NULL,
  `date` DATETIME NOT NULL,
  `amount` INT(11) NOT NULL,
  `description` VARCHAR(255), NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_point_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `tmontica`.`users` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

-- -----------------------------------------------------
-- Table `tmontica`.`sales_agegroup_data`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tmontica`.`sales_agegroup_data` ;

CREATE TABLE `tmontica`.`sales_agegroup_data` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `reg_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `age_group` VARCHAR(45) NOT NULL,
  `total_price` INT NOT NULL,
  PRIMARY KEY (`idnew_table`));

ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

-- -----------------------------------------------------
-- Table `tmontica`.`sales_menu_data`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tmontica`.`sales_menu_data` ;

CREATE TABLE `tmontica`.`sales_menu_data` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `reg_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `menu_id` INT NOT NULL,
  `total_price` INT NOT NULL,
  PRIMARY KEY (`idnew_table`));

ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

-- -----------------------------------------------------
-- Table `tmontica`.`order_useragent_data`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tmontica`.`order_useragent_data` ;

CREATE TABLE `tmontica`.`order_useragent_data` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `reg_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `user_agent` VARCHAR(45) NOT NULL,
  `count` INT NOT NULL,
  PRIMARY KEY (`id`));

ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;
