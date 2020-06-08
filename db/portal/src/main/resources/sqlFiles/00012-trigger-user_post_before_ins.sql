CREATE
    TRIGGER user_post_before_ins BEFORE INSERT
    ON user_post
    FOR EACH ROW BEGIN

    SET NEW.created_at = CURRENT_TIMESTAMP();
    SET NEW.updated_at = CURRENT_TIMESTAMP();

END//