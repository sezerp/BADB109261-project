CREATE
    TRIGGER users_set_default_values_ins BEFORE INSERT
    ON users
    FOR EACH ROW BEGIN

    SET NEW.created_on = CURRENT_TIMESTAMP();
    SET NEW.login_lowercase = LCASE(NEW.login);
    SET NEW.email_lowercase = LCASE(NEW.email);

    IF(NEW.profession IS NULL)
    THEN
        SET NEW.profession = 'N/A';
    END IF;

END//