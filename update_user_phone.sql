CREATE OR REPLACE PROCEDURE person_update_phone(p_user_id NUMBER, p_new_phone VARCHAR2, p_phone_type VARCHAR2)
is
    user_exist BOOLEAN;
    v_phone_exist NUMBER(2);
begin 

    SELECT check_user_exist(p_user_id) 
    into user_exist
    from dual;

    IF user_exist = FALSE THEN
        RAISE_application_error(-20002, 'the user does not exist');
    END if;

    
    select COUNT(*)
    into v_phone_exist from PERSON_PHONES
    where PERSON_ID = p_user_id AND PHONE_TYPE = p_phone_type;
    if (v_phone_exist != 0) THEN
        UPDATE PERSON_PHONES set PHONE = p_new_phone 
        where PERSON_ID = p_user_id and PHONE_TYPE = p_phone_type;
        COMMIT ;
    ELSE
        RAISE_application_error(-20001, 'the user has not a ' || p_phone_type || ' phone');
    END if;

    EXCEPTION
        when OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An error accured ' || SQLERRM);

END;


