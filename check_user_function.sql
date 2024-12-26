CREATE OR REPLACE FUNCTION check_user_exist(user_id NUMBER)
RETURN BOOLEAN
IS
    user_exist NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO user_exist
    FROM PERSON
    WHERE ID = user_id;
    IF (user_exist = 0) THEN
        RETURN FALSE ;
    ELSE
        RETURN TRUE ;
    END IF;
END;

