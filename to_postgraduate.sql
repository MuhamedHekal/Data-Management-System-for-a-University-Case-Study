CREATE OR REPLACE PROCEDURE to_postgraduate(p_student_id NUMBER)
is
    student_exist BOOLEAN;
    p_student_type VARCHAR2(20):= 'postgraduate';
    p_GRADUATION_YEAR NUMBER(4);
begin 

    SELECT check_student_exist(p_student_id) 
    into student_exist
    from dual;

    IF student_exist = FALSE THEN
        RAISE_application_error(-20001, 'the student does not exist');
    END if;
    
    UPDATE PERSON_STUDENT set STUDENT_TYPE = p_student_type
    where STUDENT_ID = p_student_id ;
    
    DBMS_OUTPUT.PUT_LINE('studnet_type update done');

    -- insert into person_student_postgraduate_table
    
    SELECT to_char(sysdate,'yyyy') into p_GRADUATION_YEAR
    from dual;
    insert into PERSON_STUDENT_POSTGRADUATE 
    VALUES(p_student_id,p_GRADUATION_YEAR);
    DBMS_OUTPUT.PUT_LINE('student moved to post_graduation table');

    -- remove the student_data from under_graduate table
    DELETE from PERSON_STUDENT_UNDERGRADUATE 
    WHERE STUDENT_ID = p_student_id;
    COMMIT;
   
    EXCEPTION
        when OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An error accured ' || SQLERRM);
            ROLLBACK;

END;
