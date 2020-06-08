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