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