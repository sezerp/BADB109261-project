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