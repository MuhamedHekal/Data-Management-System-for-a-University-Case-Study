-- 1- create tabel person
CREATE TABLE person(
    id NUMBER(10) ,
    first_name VARCHAR2(20),
    last_name VARCHAR2(20) NOT NULL,
    gender CHAR(1) NOT NULL,
    address VARCHAR2(50) NOT NULL,
    date_of_birth date NOT NULL,
    email VARCHAR2(50) NOT NULL,
    person_type VARCHAR2(10) NOT NULL,
    CONSTRAINT person_id_pk PRIMARY KEY(id),
    CONSTRAINT person_type_check CHECK (person_type = 'staff' OR person_type = 'student')
);

-- 2- create table person_phones
CREATE TABLE person_phones(
    person_id NUMBER(10),
    phone VARCHAR2(15) NOT NULL,
    phone_type VARCHAR2(15) NOT NULL,
    CONSTRAINT person_id_fk_phone FOREIGN KEY(person_id) REFERENCES person(id),
    CONSTRAINT person_phones_pk PRIMARY KEY(person_id,phone)
);

-- 3- create table person_staff
CREATE TABLE person_staff(
    staff_id NUMBER(10) NOT NULL,
    salary number(8,2) NOT NULL,
    staff_type VARCHAR2(200) NOT NULL , -- store JSON format
    hire_date date NOT NULL,
    CONSTRAINT staff_id_fk FOREIGN KEY(staff_id) REFERENCES person(id),
    CONSTRAINT unique_staff_person_id UNIQUE (staff_id)
);

-- 4- create table person_staff_technical
CREATE TABLE person_staff_technical(
    technical_id NUMBER(10) NOT NULL ,
    tech_expertise VARCHAR2(50) NOT NULL,
    CONSTRAINT technical_id_fk FOREIGN KEY(technical_id) REFERENCES person_staff(staff_id),
    CONSTRAINT unique_technical_person_id UNIQUE (technical_id)
);

-- 5- create table person_staff_technical_certificates
CREATE TABLE person_staff_technical_certificates(
    technical_id NUMBER(10) NOT NULL,
    certificate VARCHAR2(50) ,
    CONSTRAINT technical_id_fk_certificates FOREIGN KEY(technical_id) REFERENCES person_staff(staff_id),
    CONSTRAINT technical_certificates_pk PRIMARY KEY(technical_id,certificate)
);

-- 6- create table person_staff_instructor
CREATE TABLE person_staff_instructor(
    instructor_id NUMBER(10) NOT NULL,
    specialization VARCHAR2(50),
    CONSTRAINT instructor_id_fk FOREIGN KEY(instructor_id) REFERENCES person_staff(staff_id),
    CONSTRAINT unique_instructor_person_id UNIQUE (instructor_id)
);

-- 7- create table person_staff_researcher
CREATE TABLE person_staff_researcher(
    researcher_id NUMBER(10) NOT NULL,
    research_field VARCHAR2(30), 
    num_publish_paper Number(2) NOT NULL,
    supervisor_id NUMBER(10),
    CONSTRAINT researcher_id_fk FOREIGN KEY(researcher_id) REFERENCES person_staff(staff_id),
    CONSTRAINT supervisor_id_fk FOREIGN KEY(supervisor_id) REFERENCES person_staff_instructor(instructor_id),
    CONSTRAINT unique_researcher_person_id UNIQUE (researcher_id)
);

-- 8- create table person_staff_manager
CREATE TABLE person_staff_manager(
    manager_id NUMBER(10) NOT NULL,
    position VARCHAR2(30),
    CONSTRAINT manager_id_fk FOREIGN KEY(manager_id) REFERENCES person_staff(staff_id),
    CONSTRAINT unique_manager_person_id UNIQUE (manager_id)
);

-- 9- create table person_student
CREATE TABLE person_student(
    student_id NUMBER(10) NOT NULL,
    major VARCHAR2(30) NOT NULL, 
    GPA Number(3,2) NOT NULL,
    enrollment_year NUMBER(4) NOT NULL ,
    student_type VARCHAR2(15) NOT NULL,
    CONSTRAINT student_id_fk FOREIGN KEY(student_id) REFERENCES person(id),
    CONSTRAINT student_type CHECK (student_type='undergraduate' OR student_type='postgraduate'),
    CONSTRAINT unique_student_person_id UNIQUE (student_id)
);  

-- 10- create table person_student_postgraduate
CREATE TABLE person_student_postgraduate(
    student_id NUMBER(10) NOT NULL,
    graduation_year VARCHAR2(4) NOT NULL,
    CONSTRAINT post_student_id_fk FOREIGN KEY(student_id) REFERENCES person_student(student_id),
    CONSTRAINT unique_post_student_person_id UNIQUE (student_id)
);

-- 11- create table person_student_undergraduate
CREATE TABLE person_student_undergraduate(
    student_id NUMBER(10) NOT NULL,
    "level" VARCHAR2(10) NOT NULL,
    CONSTRAINT undergraduate_student_id_fk FOREIGN KEY(student_id) REFERENCES person_student(student_id),
    CONSTRAINT unique_under_student_person_id UNIQUE(student_id),
    CONSTRAINT level_under_student_check CHECK("level" = 'freshman' OR "level" = 'sophomore' OR "level" = 'junior' OR "level" = 'senior' )
);

-- 12- create table department
CREATE TABLE department(
    department_id NUMBER(10) ,
    department_name VARCHAR2(30),
    building VARCHAR(30) NOT NULL,
    floor_num NUMBER(2) NOT NULL,
    manager_id NUMBER(10) NOT NULL,
    CONSTRAINT department_id_pk PRIMARY KEY(department_id),
    CONSTRAINT department_manager_id_fk FOREIGN KEY(manager_id) REFERENCES person_staff_manager(manager_id)
);

-- 13- create table course
CREATE TABLE course(
    course_id NUMBER(10) NOT NULL ,
    course_name VARCHAR2(30) NOT NULL,
    duration NUMBER(4),
    credits NUMBER(2) NOT NULL,
    CONSTRAINT course_id_pk PRIMARY KEY(course_id)
);

-- 14- create table course_prerequisite
CREATE TABLE course_prerequisite(
    course_id NUMBER(10) NOT NULL,
    prerequisite_id NUMBER(10),
    CONSTRAINT course_id_prerequisite_fk FOREIGN KEY(course_id) REFERENCES course(course_id),
    CONSTRAINT prerequisite_course_id_fk FOREIGN KEY(prerequisite_id) REFERENCES course(course_id),
    CONSTRAINT course_prerequisite_pk PRIMARY KEY(course_id,prerequisite_id)
);

-- 15- create table room
CREATE TABLE room(
    room_id NUMBER(10) NOT NULL ,
    capacity NUMBER(4) NOT NULL,
    room_type VARCHAR2(30) NOT NULL,
    building VARCHAR2(30) NOT NULL,
    floor_num NUMBER(2) NOT NULL,
    CONSTRAINT room_id_pk PRIMARY KEY(room_id)
);

-- 16- create table exam
CREATE TABLE exam(
    exam_id NUMBER(10) NOT NULL ,
    exam_datetime TIMESTAMP NOT NULL,
    team_type VARCHAR2(30) NOT NULL,
    max_marks NUMBER(3) NOT NULL,
    course_id NUMBER(10),
    CONSTRAINT exam_id_pk PRIMARY KEY(exam_id),
    CONSTRAINT exam_course_id_FK FOREIGN KEY(course_id) REFERENCES course(course_id)
);


-- 17- create table instructor_courses
CREATE TABLE instructor_course(
    instructor_id NUMBER(10) NOT NULL ,
    course_id NUMBER(10) NOT NULL,
    instructor_course_datetime TIMESTAMP NOT NULL,
    CONSTRAINT instructor_course_course_id_FK FOREIGN KEY(course_id) REFERENCES course(course_id),
    CONSTRAINT instructor_course_instructor_id_FK FOREIGN KEY(instructor_id) REFERENCES person_staff_instructor(instructor_id),
    CONSTRAINT ins_course_pk PRIMARY KEY(instructor_id, course_id, instructor_course_datetime)
);

-- 18- create table department_students
CREATE TABLE department_student(
    student_id NUMBER(10) NOT NULL,
    department_id NUMBER(10) NOT NULL,
    CONSTRAINT department_student_student_id_fk FOREIGN KEY(student_id) REFERENCES person_student_undergraduate(student_id),
    CONSTRAINT department_student_department_id_fk FOREIGN KEY(department_id) REFERENCES department(department_id),
    CONSTRAINT department_student_pk PRIMARY KEY(student_id)
);

-- 19- create table department_course
CREATE TABLE department_course(
    department_id NUMBER(10) NOT NULL,
    course_id NUMBER(10) NOT NULL,
    CONSTRAINT department_course_department_id_fk FOREIGN KEY(department_id) REFERENCES department(department_id),
    CONSTRAINT department_course_course_id_fk FOREIGN KEY(course_id) REFERENCES course(course_id),
    CONSTRAINT department_course_pk PRIMARY KEY(department_id,course_id)
);

-- 20- create table student_course
CREATE TABLE student_course(
    student_id NUMBER(10) NOT NULL,
    course_id NUMBER(10) NOT NULL,
    grade NUMBER(4),
    CONSTRAINT student_course_student_id_fk FOREIGN KEY(student_id) REFERENCES person_student_undergraduate(student_id),
    CONSTRAINT student_course_course_id_fk FOREIGN KEY(course_id) REFERENCES course(course_id),
    CONSTRAINT student_course_pk PRIMARY KEY(student_id,course_id,grade)
);

-- 21- create table course_room
CREATE TABLE course_room(
    course_id NUMBER(10) NOT NULL,
    room_id NUMBER(10) NOT NULL,
    schedule_datetime TIMESTAMP,
    CONSTRAINT course_room_room_id_fk FOREIGN KEY(room_id) REFERENCES room(room_id),
    CONSTRAINT course_room_course_id_fk FOREIGN KEY(course_id) REFERENCES course(course_id),
    CONSTRAINT course_room_pk PRIMARY KEY(room_id,course_id,schedule_datetime)
);

