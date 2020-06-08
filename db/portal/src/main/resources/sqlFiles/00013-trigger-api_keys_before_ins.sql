CREATE
    TRIGGER api_keys_before_ins BEFORE INSERT
    ON api_keys
    FOR EACH ROW BEGIN

    SET NEW.created_on = CURRENT_TIMESTAMP();

END//