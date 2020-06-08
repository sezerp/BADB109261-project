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