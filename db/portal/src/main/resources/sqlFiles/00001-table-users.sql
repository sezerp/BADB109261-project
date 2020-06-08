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