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