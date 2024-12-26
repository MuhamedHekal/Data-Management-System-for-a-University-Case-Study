CREATE OR REPLACE PROCEDURE student_update_phone(p_student_id NUMBER, p_new_phone VARCHAR2, p_phone_type VARCHAR2)
is
    v_user_count number(1);
    v_phone_exist NUMBER(2);
begin 

    SELECT count(*) into v_user_count from PERSON
    where ID = p_student_id;
    IF v_user_count = 0 THEN
        RAISE_application_error(-20002, 'the user does not exist');
    END if;
    select COUNT(*)
    into v_phone_exist from PERSON_PHONES
    where PERSON_ID = p_student_id AND PHONE_TYPE = p_phone_type;
    if (v_phone_exist != 0) THEN
        UPDATE PERSON_PHONES set PHONE = p_new_phone 
        where PERSON_ID = p_student_id and PHONE_TYPE = p_phone_type;
        COMMIT ;
    ELSE
        RAISE_application_error(-20001, 'the user has not a ' || p_phone_type || ' phone');
    END if;

    EXCEPTION
        when OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An error accured ' || SQLERRM);

END;


declare 
begin 

    STUDENT_UPDATE_PHONE(1,'0111111','mobile');
end;


