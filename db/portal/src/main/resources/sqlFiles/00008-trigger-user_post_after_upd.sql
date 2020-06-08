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
