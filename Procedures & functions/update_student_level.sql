CREATE OR REPLACE PROCEDURE update_student_level(p_student_id NUMBER, p_level VARCHAR2 )
is
    student_exist BOOLEAN;
    v_STUDENT_TYPE VARCHAR2(20);
begin 

    SELECT check_student_exist(p_student_id) 
    into student_exist
    from dual;
    IF student_exist = FALSE THEN
        RAISE_application_error(-20001, 'the student does not exist');
    END if;
    -- check if the student is under gradeuate first 
    select STUDENT_TYPE into v_STUDENT_TYPE
    from person_student
    WHERE student_id = p_student_id;

    if v_STUDENT_TYPE = 'undergraduate' THEN
        UPDATE PERSON_STUDENT_UNDERGRADUATE set "level" = p_level
        WHERE STUDENT_ID = p_student_id;
        DBMS_OUTPUT.PUT_LINE('level updated');
    ELSE
        RAISE_application_error(-20001, 'the student is not undergraduate');
    END if;
END;

