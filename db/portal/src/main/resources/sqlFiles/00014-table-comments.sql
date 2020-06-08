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