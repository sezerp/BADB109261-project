CREATE
    TRIGGER comments_before_ins BEFORE INSERT
    ON comments
    FOR EACH ROW BEGIN

    SET NEW.created_at = CURRENT_TIMESTAMP();

END//