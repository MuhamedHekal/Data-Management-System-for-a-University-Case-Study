CREATE OR REPLACE PACKAGE student_pkg
IS
    -- update the gpa of the student
    PROCEDURE update_gpa(p_student_id NUMBER, p_gpa NUMBER ) ;

    PROCEDURE update_level(p_student_id NUMBER, p_level VARCHAR2 ) ;

    PROCEDURE update_major(p_student_id NUMBER, p_major VARCHAR2 );

    PROCEDURE update_address(p_user_id NUMBER, p_address VARCHAR2);

    PROCEDURE update_email(p_user_id NUMBER, p_email VARCHAR2);

    PROCEDURE update_phone(p_user_id NUMBER, p_new_phone VARCHAR2, p_phone_type VARCHAR2);

    FUNCTION calculate_gpa(p_student_id NUMBER)
    RETURN NUMBER ;

    PROCEDURE to_postgraduate(p_student_id NUMBER);

END student_pkg;


CREATE OR REPLACE PACKAGE BODY student_pkg
IS

FUNCTION check_user_exist(user_id NUMBER)
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

------------------------------------------------------------------------------
FUNCTION check_student_exist(p_student_id NUMBER)
    RETURN BOOLEAN
    IS
        student_exist NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO student_exist
        FROM PERSON_STUDENT
        WHERE student_id = p_student_id;
        IF (student_exist = 0) THEN
            RETURN FALSE ;
        ELSE
            RETURN TRUE ;
        END IF;
    END;

------------------------------------------------------------------------------
FUNCTION get_grade(grade_num NUMBER)
    RETURN CHAR
    IS
        v_grade CHAR(2);
    BEGIN
        SELECT GRADE 
        into v_grade
        from grade_point
        WHERE "from" <= grade_num and "to" >= grade_num;

        RETURN v_grade;

    END;

------------------------------------------------------------------------------
PROCEDURE update_gpa(p_student_id NUMBER, p_gpa NUMBER )
    is
        student_exist BOOLEAN;
        
    begin 
        student_exist := check_student_exist(p_student_id);
        IF student_exist = FALSE THEN
            RAISE_application_error(-20001, 'the student does not exist');
        END if;
        
        UPDATE PERSON_STUDENT set GPA = p_gpa
        WHERE student_id = p_student_id;
        DBMS_OUTPUT.PUT_LINE('GPA updated');
    END;

------------------------------------------------------------------------------
PROCEDURE update_level(p_student_id NUMBER, p_level VARCHAR2 )
    is
        student_exist BOOLEAN;
        v_STUDENT_TYPE VARCHAR2(20);
    begin 
        student_exist := check_student_exist(p_student_id);
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

------------------------------------------------------------------------------
PROCEDURE update_major(p_student_id NUMBER, p_major VARCHAR2 )
    is
        student_exist BOOLEAN;
        
    begin 

        student_exist := check_student_exist(p_student_id);
        IF student_exist = FALSE THEN
            RAISE_application_error(-20001, 'the student does not exist');
        END if;
        
        UPDATE PERSON_STUDENT set major = p_major
        WHERE student_id = p_student_id;
        DBMS_OUTPUT.PUT_LINE('major updated');
    END;

------------------------------------------------------------------------------
PROCEDURE update_address(p_user_id NUMBER, p_address VARCHAR2)
    is
        user_exist BOOLEAN;
    begin 
        user_exist := check_user_exist(p_user_id);
        IF user_exist = FALSE THEN
            RAISE_application_error(-20001, 'the user does not exist');
        END if;
        
        UPDATE PERSON set ADDRESS = p_address 
        where ID = p_user_id ;
        DBMS_OUTPUT.PUT_LINE('Address update done');
        
        EXCEPTION
            when OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('An error accured ' || SQLERRM);
    END;

------------------------------------------------------------------------------
PROCEDURE update_email(p_user_id NUMBER, p_email VARCHAR2)
    is
        user_exist BOOLEAN;
    begin 

        user_exist := check_user_exist(p_user_id);
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

------------------------------------------------------------------------------
PROCEDURE update_phone(p_user_id NUMBER, p_new_phone VARCHAR2, p_phone_type VARCHAR2)
    is
        user_exist BOOLEAN;
        v_phone_exist NUMBER(2);
    begin 

        user_exist := check_user_exist(p_user_id);
        IF user_exist = FALSE THEN
            RAISE_application_error(-20002, 'the user does not exist');
        END if;

        
        select COUNT(*)
        into v_phone_exist from PERSON_PHONES
        where PERSON_ID = p_user_id AND PHONE_TYPE = p_phone_type;
        if (v_phone_exist != 0) THEN
            UPDATE PERSON_PHONES set PHONE = p_new_phone 
            where PERSON_ID = p_user_id and PHONE_TYPE = p_phone_type;
        
        ELSE
            RAISE_application_error(-20001, 'the user has not a ' || p_phone_type || ' phone');
        END if;

        EXCEPTION
            when OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('An error accured ' || SQLERRM);
            
    END;

------------------------------------------------------------------------------
FUNCTION calculate_gpa(p_student_id NUMBER)
    RETURN NUMBER
    is
        CURSOR student_grade_cur IS
        select sc.STUDENT_ID, sc.GRADE,c.CREDITS
        from student_course sc , course c
        where sc.course_id = c.COURSE_ID and sc.STUDENT_ID = p_student_id; 
        v_grade CHAR(2);
        v_grade_point NUMBER(2,1);
        total_credit_hours NUMBER(4):= 0;
        total_grade_points number(5,2) := 0.0;
        v_gpa number (4,2);
        student_exist BOOLEAN;
    begin 

        student_exist := check_student_exist(p_student_id);
        IF student_exist = FALSE THEN
            RAISE_application_error(-20001, 'the student does not exist');
        END if;

        for student_rec in student_grade_cur LOOP

            v_grade:= get_grade(student_rec.GRADE);
        
            SELECT grade_point
            into v_grade_point
            from GRADE_POINT
            where GRADE = v_grade;

            total_grade_points := total_grade_points + (v_grade_point * student_rec.CREDITS) ;
            total_credit_hours := total_credit_hours + student_rec.CREDITS ;


        END LOOP;

        RETURN total_grade_points/total_credit_hours;
        EXCEPTION
            WHEN ZERO_DIVIDE THEN
            DBMS_OUTPUT.PUT_LINE('Error: Division by zero is not allowed.');
        
    END;
------------------------------------------------------------------------------
PROCEDURE to_postgraduate(p_student_id NUMBER)
    is
        student_exist BOOLEAN;
        p_student_type VARCHAR2(20):= 'postgraduate';
        p_GRADUATION_YEAR NUMBER(4);
    begin 

        student_exist := check_student_exist(p_student_id);
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
    
        EXCEPTION
            when OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('An error accured ' || SQLERRM);

    END;
------------------------------------------------------------------------------

END student_pkg ;