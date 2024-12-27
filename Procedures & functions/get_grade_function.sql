CREATE OR REPLACE FUNCTION get_grade(grade_num NUMBER)
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

