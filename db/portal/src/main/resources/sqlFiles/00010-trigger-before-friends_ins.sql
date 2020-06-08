
CREATE
    TRIGGER friends_ins BEFORE INSERT
    ON friends
    FOR EACH ROW BEGIN

    DECLARE friend_cnt INT;
    SELECT COUNT(*) INTO friend_cnt FROM friends where user_id = NEW.user_id;

    IF(friend_cnt > 100)
    THEN
        signal SQLSTATE '01000' SET message_text = 'The user cannot has more then 100 friends';
    END IF;

    SET NEW.created_at = CURRENT_TIMESTAMP();

END//