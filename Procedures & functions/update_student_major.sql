CREATE OR REPLACE PROCEDURE update_major(p_student_id NUMBER, p_major VARCHAR2 )
is
    student_exist BOOLEAN;
    
begin 

    SELECT check_student_exist(p_student_id) 
    into student_exist
    from dual;

    IF student_exist = FALSE THEN
        RAISE_application_error(-20001, 'the student does not exist');
    END if;
    
    UPDATE PERSON_STUDENT set major = p_major
    WHERE student_id = p_student_id;
    DBMS_OUTPUT.PUT_LINE('major updated');
END;
