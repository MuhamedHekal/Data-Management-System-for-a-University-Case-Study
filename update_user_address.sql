CREATE OR REPLACE PROCEDURE person_update_address(p_user_id NUMBER, p_address VARCHAR2)
is
    user_exist BOOLEAN;
begin 

    SELECT check_user_exist(p_user_id) 
    into user_exist
    from dual;

    IF user_exist = FALSE THEN
        RAISE_application_error(-20001, 'the user does not exist');
    END if;
    
    UPDATE PERSON set ADDRESS = p_address 
    where ID = p_user_id ;
    COMMIT ;
    
    EXCEPTION
        when OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An error accured ' || SQLERRM);

END;
