CREATE OR REPLACE PROCEDURE person_update_email(p_user_id NUMBER, p_email VARCHAR2)
is
    user_exist BOOLEAN;
begin 

    SELECT check_user_exist(p_user_id) 
    into user_exist
    from dual;

    IF user_exist = FALSE THEN
        RAISE_application_error(-20001, 'the user does not exist');
    END if;
    
    UPDATE PERSON set EMAIL = p_email 
    where ID = p_user_id ;
    DBMS_OUTPUT.PUT_LINE('Email update done');
    
    EXCEPTION
        when OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An error accured ' || SQLERRM);
            
END;
