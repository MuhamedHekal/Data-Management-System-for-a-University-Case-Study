CREATE OR REPLACE FUNCTION calculate_gpa(p_student_id NUMBER)
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

    SELECT check_student_exist(p_student_id) 
    into student_exist
    from dual;

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
