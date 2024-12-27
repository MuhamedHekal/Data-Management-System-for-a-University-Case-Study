CREATE OR REPLACE FUNCTION check_student_exist(p_student_id NUMBER)
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

