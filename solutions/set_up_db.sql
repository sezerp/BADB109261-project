CREATE DATABASE IF NOT EXISTS portal;
ALTER SCHEMA portal CHARACTER SET utf8 COLLATE utf8_polish_ci;

CREATE USER IF NOT EXISTS 'liquibas_user'@'%' IDENTIFIED BY 'sm@l0@t@';
GRANT ALL PRIVILEGES ON portal.* TO 'liquibase_user'@'%' WITH GRANT OPTION;

--  VARCHAR used over char because MariaDB does not allow creating indexes on TEXT data type
--  id mostly will have the length < 65 and stored in format such as GUID
--  or Secure Random Ids https://jmcardon.github.io/tsec/docs/common.html then the length 80 should
--  be enough for other SQL DB engine such as PostgreSQL the TEXT should be better chose

CREATE TABLE users
(
    id                VARCHAR(80)         NOT NULL,
    login             TEXT                NOT NULL,
    email             TEXT                NOT NULL,
    login_lowercase   VARCHAR(50)         NOT NULL,
    email_lowercase   VARCHAR(80)         NOT NULL,
    password          TEXT                NOT NULL    COMMENT 'password will store as hashes',
    name              VARCHAR(20)         NOT NULL,
    surname           VARCHAR(30)         NOT NULL,
--   the constrain NOT NULL is checking in trigger regarding to https://stackoverflow.com/questions/8220137/does-sql-standard-specify-the-order-of-constraint-validation-and-trigger-firing
    profession        VARCHAR(20)                     COMMENT 'the constrain NOT NULL checking on trigger',
    created_on        TIMESTAMP(0)        NOT NULL
);

ALTER TABLE users
    ADD CONSTRAINT users_id PRIMARY KEY (id);
CREATE UNIQUE INDEX users_login_lowercase ON users (login_lowercase);
CREATE UNIQUE INDEX users_email_lowercase ON users (email_lowercase);
CREATE INDEX user_full_name_idx ON users (name, surname);

CREATE TABLE api_keys
(
    id          VARCHAR(80)         NOT NULL,
    user_id     VARCHAR(80)         NOT NULL,
    created_on  TIMESTAMP                       COMMENT 'Fill on trigger',
    valid_until TIMESTAMP           NOT NULL
);
ALTER TABLE api_keys
    ADD CONSTRAINT api_keys_id PRIMARY KEY (id);
ALTER TABLE api_keys
    ADD CONSTRAINT api_keys_user_id_fk FOREIGN KEY (user_id) REFERENCES users (id)
        ON DELETE CASCADE ON UPDATE CASCADE;


CREATE TABLE password_reset_codes
(
    id          VARCHAR(80)        NOT NULL,
    user_id     VARCHAR(80)        NOT NULL,
    valid_until TIMESTAMP          NOT NULL
);
ALTER TABLE password_reset_codes
    ADD CONSTRAINT password_reset_codes_id PRIMARY KEY (id);
ALTER TABLE password_reset_codes
    ADD CONSTRAINT password_reset_codes_user_fk
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE ON UPDATE CASCADE;


CREATE TABLE scheduled_emails
(
    id        VARCHAR(80)   NOT NULL,
    recipient TEXT          NOT NULL,
    subject   TEXT          NOT NULL,
    content   TEXT          NOT NULL
);
ALTER TABLE scheduled_emails
    ADD CONSTRAINT scheduled_emails_id PRIMARY KEY (id);

CREATE TABLE interests
(
    id        VARCHAR(80)   NOT NULL,
    name      TEXT          NOT NULL,
    user_id   VARCHAR(80)   NOT NULL
);

ALTER TABLE interests
    ADD CONSTRAINT interests_id PRIMARY KEY (id);

ALTER TABLE interests
    ADD CONSTRAINT interests_id_fk FOREIGN KEY (user_id) REFERENCES users (id)
        ON DELETE CASCADE;


CREATE TABLE user_post
(
    id          VARCHAR(80)     NOT NULL,
    content     TEXT            NOT NULL,
    tags        TEXT            NOT NULL,
    likes       INT             NOT NULL DEFAULT 0,
    user_id     VARCHAR(80)     NOT NULL,
    created_at  TIMESTAMP       NOT NULL,
    updated_at  TIMESTAMP       NOT NULL
);

ALTER TABLE user_post
    ADD CONSTRAINT user_post_id PRIMARY KEY (id);

ALTER TABLE user_post
    ADD CONSTRAINT user_post_id_fk FOREIGN KEY (user_id) REFERENCES users (id)
        ON DELETE CASCADE ON UPDATE CASCADE;


CREATE TABLE user_post_hist
(
    id          VARCHAR(80)     NOT NULL,
    content     TEXT            NOT NULL,
    tags        TEXT            NOT NULL,
    likes       INT             NOT NULL,
    user_id     VARCHAR(80)     NOT NULL,
    created_at  TIMESTAMP       NOT NULL,
    changed_by  VARCHAR(50)     NOT NULL,
    changed_at  TIMESTAMP       NOT NULL
);


CREATE OR REPLACE TRIGGER user_post_after_upd
    AFTER UPDATE ON user_post FOR EACH ROW
    INSERT user_post_hist
    (
        id,
        content,
        tags,
        likes,
        user_id,
        created_at,
        changed_by,
        changed_at
    )
    VALUES(
              old.id,
              old.content,
              old.tags,
              old.likes,
              old.user_id,
              CURRENT_TIMESTAMP,
              USER(),
              CURRENT_TIMESTAMP
          );


-- junction table
CREATE TABLE friends
(
    id              VARCHAR(80)         NOT NULL,
    user_id         VARCHAR(80)         NOT NULL COMMENT 'id of parent',
    friend_id       VARCHAR(80)         NOT NULL COMMENT 'friend id',
    created_at      TIMESTAMP                                               COMMENT 'set on trigger'
);

ALTER TABLE friends
    ADD CONSTRAINT friend_id PRIMARY KEY (id);

CREATE UNIQUE INDEX unique_friend ON friends (user_id, friend_id);

ALTER TABLE friends
    ADD CONSTRAINT user_id_fk
        FOREIGN KEY (user_id) REFERENCES users (id)
            ON DELETE CASCADE;
ALTER TABLE friends
    ADD CONSTRAINT friend_id_fk
        FOREIGN KEY (friend_id) REFERENCES users (id);


DELIMITER //

CREATE
    TRIGGER friends_ins BEFORE INSERT
    ON friends
    FOR EACH ROW BEGIN

    DECLARE friend_cnt INT;
    SELECT COUNT(*) INTO friend_cnt FROM friends where user_id = NEW.user_id;

    IF(friend_cnt > 100)
    THEN
        signal SQLSTATE '01000' SET message_text = 'The user cannot has more then 100 friends';
    END IF;

    SET NEW.created_at = CURRENT_TIMESTAMP();

END//

DELIMITER ;

DELIMITER //

CREATE
    TRIGGER users_set_default_values_ins BEFORE INSERT
    ON users
    FOR EACH ROW BEGIN

    SET NEW.created_on = CURRENT_TIMESTAMP();
    SET NEW.login_lowercase = LCASE(NEW.login);
    SET NEW.email_lowercase = LCASE(NEW.email);

    IF(NEW.profession IS NULL)
    THEN
        SET NEW.profession = 'N/A';
    END IF;

END//

DELIMITER ;

DELIMITER //
CREATE
    TRIGGER user_post_before_ins BEFORE INSERT
    ON user_post
    FOR EACH ROW BEGIN

    SET NEW.created_at = CURRENT_TIMESTAMP();
    SET NEW.updated_at = CURRENT_TIMESTAMP();

END//
DELIMITER ;

DELIMITER //
CREATE
    TRIGGER api_keys_before_ins BEFORE INSERT
    ON api_keys
    FOR EACH ROW BEGIN

    SET NEW.created_on = CURRENT_TIMESTAMP();

END//
DELIMITER ;

CREATE TABLE comments
(
    id          VARCHAR(80)     NOT NULL,
    user_id     VARCHAR(80)     NOT NULL    COMMENT 'owner user id',
    post_id     VARCHAR(80)     NOT NULL    COMMENT 'post related to post',
    content     TEXT            NOT NULL,
    created_at  TIMESTAMP                   COMMENT 'Filled on trigger'
);

ALTER TABLE comments
    ADD CONSTRAINT comment_id PRIMARY KEY (id);

ALTER TABLE comments
    ADD CONSTRAINT comment_user_id_fk FOREIGN KEY (user_id) REFERENCES users (id)
        ON DELETE CASCADE;

ALTER TABLE comments
    ADD CONSTRAINT comment_post_id_fk FOREIGN KEY (post_id) REFERENCES user_post (id)
        ON DELETE CASCADE;


DELIMITER //

CREATE
    TRIGGER comments_before_ins BEFORE INSERT
    ON comments
    FOR EACH ROW BEGIN

    SET NEW.created_at = CURRENT_TIMESTAMP();

END//

DELIMITER ;

