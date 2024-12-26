-- =======================================================
-- cleanup old CDS schema, if found and requested
-- =======================================================

ACCEPT overwrite_schema PROMPT 'Do you want to overwrite the schema, if it already exists? [YES|no]: ' DEFAULT 'YES'

SET SERVEROUTPUT ON;
DECLARE
   v_user_exists   all_users.username%TYPE;
BEGIN
   SELECT MAX(username) INTO v_user_exists
      FROM all_users WHERE username = 'CDS';
   -- Schema already exists
   IF v_user_exists IS NOT NULL THEN
      -- Overwrite schema if the user chose to do so
      IF UPPER('&overwrite_schema') = 'YES' THEN
         EXECUTE IMMEDIATE 'DROP USER CDS CASCADE';
         DBMS_OUTPUT.PUT_LINE('Old CDS schema has been dropped.');
      -- or raise error if the user doesn't want to overwrite it
      ELSE
         RAISE_APPLICATION_ERROR(-20997, 'Abort: the schema already exists and the user chose not to overwrite it.');
      END IF;
   END IF;
END;
/
SET SERVEROUTPUT OFF;

-- =======================================================
-- create the CDS schema user
-- =======================================================
CREATE USER CDS IDENTIFIED BY cds
            ;

GRANT CREATE MATERIALIZED VIEW,
      CREATE PROCEDURE,
      CREATE SEQUENCE,
      CREATE SESSION,
      CREATE SYNONYM,
      CREATE TABLE,
      CREATE TRIGGER,
      CREATE TYPE,
      CREATE VIEW
  TO CDS;

ALTER USER CDS QUOTA UNLIMITED ON USERS;
-- =======================================================
-- create the CDS schema objects
-- =======================================================

@@tables_DDl.sql

-- =======================================================
-- populate tables with data
-- =======================================================

@@populate_tables.sql

