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