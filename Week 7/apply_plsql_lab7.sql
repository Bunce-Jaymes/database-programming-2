/*
||  Name:          apply_plsql_lab7.sql
||  Date:          11 Nov 2016
||  Purpose:       Complete 325 Chapter 8 lab.
*/

@/home/student/Data/cit325/lib/Oracle12cPLSQLCode/Introduction/create_video_store.sql

-- Open log file.
SPOOL apply_plsql_lab7.txt

-- Enter your solution here.

SELECT system_user_id
,      system_user_name
FROM   system_user
WHERE  system_user_name = 'DBA';

UPDATE system_user
SET    system_user_name = 'DBA'
WHERE  system_user_name LIKE 'DBA%';

DECLARE
  /* Create a local counter variable. */
  lv_counter  NUMBER := 2;

  /* Create a collection of two-character strings. */
  TYPE numbers IS TABLE OF NUMBER;

  /* Create a variable of the roman_numbers collection. */
  lv_numbers  NUMBERS := numbers(1,2,3,4);

BEGIN
  /* Update the system_user names to make them unique. */
  FOR i IN 1..lv_numbers.COUNT LOOP
    /* Update the system_user table. */
    UPDATE system_user
    SET    system_user_name = system_user_name || ' ' || lv_numbers(i)
    WHERE  system_user_id = lv_counter;

    /* Increment the counter. */
    lv_counter := lv_counter + 1;
  END LOOP;
END;
/

SELECT system_user_id
,      system_user_name
FROM   system_user
WHERE  system_user_name LIKE 'DBA%';

BEGIN
  FOR i IN (SELECT uo.object_type
            ,      uo.object_name
            FROM   user_objects uo
            WHERE  uo.object_name = 'INSERT_CONTACT') LOOP
    EXECUTE IMMEDIATE 'DROP ' || i.object_type || ' ' || i.object_name;
  END LOOP;
END;
/

DROP PROCEDURE insert_contact;
CREATE OR REPLACE PROCEDURE insert_contact

    ( pv_first_name VARCHAR2
    , pv_middle_name VARCHAR2
    , pv_last_name VARCHAR2
    , pv_contact_type VARCHAR2
    , pv_account_number VARCHAR2
    , pv_member_type VARCHAR2
    , pv_credit_card_number VARCHAR2
    , pv_credit_card_type VARCHAR2
    , pv_city VARCHAR2
    , pv_state_province VARCHAR2
    , pv_postal_code VARCHAR2
    , pv_address_type VARCHAR2
    , pv_country_code VARCHAR2
    , pv_area_code VARCHAR2
    , pv_telephone_number VARCHAR2
    , pv_telephone_type VARCHAR2
    , pv_user_name VARCHAR2) IS
    
    lv_member_type NUMBER;
    lv_credit_card_type NUMBER;
    lv_contact_type NUMBER;
    lv_address_type NUMBER;
    lv_telephone_type NUMBER;
    lv_system_user_id NUMBER;

    CURSOR get_type(cv_table_name  VARCHAR2
            ,cv_column_name VARCHAR2
            ,cv_lookup_type VARCHAR2) IS
            SELECT common_lookup_id
            FROM common_lookup
            WHERE common_lookup_table  = cv_table_name
            AND   common_lookup_column = cv_column_name
            AND   common_lookup_type   = cv_lookup_type;

    BEGIN
        
        FOR i IN get_type('MEMBER', 'MEMBER_TYPE', PV_MEMBER_TYPE) LOOP
            lv_member_type := i.common_lookup_id;
        END LOOP;
        FOR i IN get_type('MEMBER', 'CREDIT_CARD_TYPE', PV_CREDIT_CARD_TYPE) LOOP
            lv_credit_card_type := i.common_lookup_id;
        END LOOP;
        FOR i IN get_type('CONTACT', 'CONTACT_TYPE', PV_CONTACT_TYPE) LOOP
            lv_contact_type := i.common_lookup_id;
        END LOOP;
        FOR i IN get_type('ADDRESS', 'ADDRESS_TYPE', PV_ADDRESS_TYPE) LOOP
            lv_address_type := i.common_lookup_id;
        END LOOP;
        FOR i IN get_type('TELEPHONE', 'TELEPHONE_TYPE', PV_TELEPHONE_TYPE) LOOP
            lv_telephone_type := i.common_lookup_id;
        END LOOP;

        SELECT system_user_id INTO lv_system_user_id FROM system_user
            WHERE system_user_name = pv_user_name;
        
    
        SAVEPOINT starting_point;  
        
        INSERT INTO member
        ( member_id
        , member_type
        , account_number
        , credit_card_number
        , credit_card_type
        , created_by
        , creation_date
        , last_updated_by
        , last_update_date)
        VALUES
        ( member_s1.NEXTVAL
        , lv_member_type
        , pv_account_number
        , pv_credit_card_number
        , lv_credit_card_type
        , lv_system_user_id
        , SYSDATE
        , lv_system_user_id
        , SYSDATE);
            
        INSERT INTO contact
        ( contact_id
        , member_id
        , contact_type
        , last_name
        , first_name
        , middle_name
        , created_by
        , creation_date
        , last_updated_by
        , last_update_date)
        VALUES
        ( contact_s1.NEXTVAL
        , member_s1.CURRVAL
        , lv_contact_type
        , pv_last_name
        , pv_first_name
        , pv_middle_name
        , lv_system_user_id
        , SYSDATE
        , lv_system_user_id
        , SYSDATE);
        
        INSERT INTO address
        VALUES
        ( address_s1.NEXTVAL
        , contact_s1.CURRVAL
        , lv_address_type
        , pv_city
        , pv_state_province
        , pv_postal_code
        , lv_system_user_id
        , SYSDATE
        , lv_system_user_id
        , SYSDATE);
        
        INSERT INTO telephone
        VALUES
        ( telephone_s1.NEXTVAL
        , contact_s1.CURRVAL
        , address_s1.CURRVAL
        , lv_telephone_type
        , pv_country_code
        , pv_area_code
        , pv_telephone_number
        , lv_system_user_id
        , SYSDATE
        , lv_system_user_id
        , SYSDATE);
        
        COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK TO starting_point;
END insert_contact;
/

DESC insert_contact;

BEGIN
    insert_contact
    ( 'Charles'
    , 'Francis'
    , 'Xavier'
    , 'CUSTOMER'
    , 'SLC-000008'
    , 'INDIVIDUAL'
    , '7777-6666-5555-4444'
    , 'DISCOVER_CARD'
    , 'Milbridge'
    , 'Maine'
    , '04658'
    , 'HOME'
    , '001'
    , '207'
    , '111-1234'
    , 'HOME'
    , 'DBA 2');
END;
/

COL full_name      FORMAT A24
COL account_number FORMAT A10 HEADING "ACCOUNT|NUMBER"
COL address        FORMAT A22
COL telephone      FORMAT A14

SELECT c.first_name
||     CASE
         WHEN c.middle_name IS NOT NULL THEN ' '||c.middle_name||' ' ELSE ' '
       END
||     c.last_name AS full_name
,      m.account_number
,      a.city || ', ' || a.state_province AS address
,      '(' || t.area_code || ') ' || t.telephone_number AS telephone
FROM   member m INNER JOIN contact c
ON     m.member_id = c.member_id INNER JOIN address a
ON     c.contact_id = a.contact_id INNER JOIN telephone t
ON     c.contact_id = t.contact_id
AND    a.address_id = t.address_id
WHERE  c.last_name = 'Xavier';

BEGIN
    insert_contact
    ( 'Maura'
    , 'Jane'
    , 'Haggerty'
    , 'CUSTOMER'
    , 'SLC-000009'
    , 'INDIVIDUAL'
    , '8888-7777-6666-5555'
    , 'MASTER_CARD'
    , 'Bangor'
    , 'Maine'
    , '04401'
    , 'HOME'
    , '001'
    , '207'
    , '111-1234'
    , 'HOME'
    , 'DBA 2');
END;
/

DESC insert_contact;

COL full_name      FORMAT A24
COL account_number FORMAT A10 HEADING "ACCOUNT|NUMBER"
COL address        FORMAT A22
COL telephone      FORMAT A14

SELECT c.first_name
||     CASE
         WHEN c.middle_name IS NOT NULL THEN ' '||c.middle_name||' ' ELSE ' '
       END
||     c.last_name AS full_name
,      m.account_number
,      a.city || ', ' || a.state_province AS address
,      '(' || t.area_code || ') ' || t.telephone_number AS telephone
FROM   member m INNER JOIN contact c
ON     m.member_id = c.member_id INNER JOIN address a
ON     c.contact_id = a.contact_id INNER JOIN telephone t
ON     c.contact_id = t.contact_id
AND    a.address_id = t.address_id
WHERE  c.last_name = 'Haggerty';

DROP PROCEDURE insert_contact;
CREATE OR REPLACE FUNCTION insert_contact

    ( pv_first_name VARCHAR2
    , pv_middle_name VARCHAR2
    , pv_last_name VARCHAR2
    , pv_contact_type VARCHAR2
    , pv_account_number VARCHAR2
    , pv_member_type VARCHAR2
    , pv_credit_card_number VARCHAR2
    , pv_credit_card_type VARCHAR2
    , pv_city VARCHAR2
    , pv_state_province VARCHAR2
    , pv_postal_code VARCHAR2
    , pv_address_type VARCHAR2
    , pv_country_code VARCHAR2
    , pv_area_code VARCHAR2
    , pv_telephone_number VARCHAR2
    , pv_telephone_type VARCHAR2
    , pv_user_name VARCHAR2) RETURN NUMBER IS
    
    lv_member_type NUMBER;
    lv_credit_card_type NUMBER;
    lv_contact_type NUMBER;
    lv_address_type NUMBER;
    lv_telephone_type NUMBER;
    lv_system_user_id NUMBER;

    CURSOR get_type(cv_table_name  VARCHAR2
            ,cv_column_name VARCHAR2
            ,cv_lookup_type VARCHAR2) IS
            SELECT common_lookup_id
            FROM common_lookup
            WHERE common_lookup_table  = cv_table_name
            AND   common_lookup_column = cv_column_name
            AND   common_lookup_type   = cv_lookup_type;

    BEGIN
        
        FOR i IN get_type('MEMBER', 'MEMBER_TYPE', PV_MEMBER_TYPE) LOOP
            lv_member_type := i.common_lookup_id;
        END LOOP;
        FOR i IN get_type('MEMBER', 'CREDIT_CARD_TYPE', PV_CREDIT_CARD_TYPE) LOOP
            lv_credit_card_type := i.common_lookup_id;
        END LOOP;
        FOR i IN get_type('CONTACT', 'CONTACT_TYPE', PV_CONTACT_TYPE) LOOP
            lv_contact_type := i.common_lookup_id;
        END LOOP;
        FOR i IN get_type('ADDRESS', 'ADDRESS_TYPE', PV_ADDRESS_TYPE) LOOP
            lv_address_type := i.common_lookup_id;
        END LOOP;
        FOR i IN get_type('TELEPHONE', 'TELEPHONE_TYPE', PV_TELEPHONE_TYPE) LOOP
            lv_telephone_type := i.common_lookup_id;
        END LOOP;

        SELECT system_user_id INTO lv_system_user_id FROM system_user
            WHERE system_user_name = pv_user_name;
        
    
        SAVEPOINT starting_point;  
        
        INSERT INTO member
        ( member_id
        , member_type
        , account_number
        , credit_card_number
        , credit_card_type
        , created_by
        , creation_date
        , last_updated_by
        , last_update_date)
        VALUES
        ( member_s1.NEXTVAL
        , lv_member_type
        , pv_account_number
        , pv_credit_card_number
        , lv_credit_card_type
        , lv_system_user_id
        , SYSDATE
        , lv_system_user_id
        , SYSDATE);
            
        INSERT INTO contact
        ( contact_id
        , member_id
        , contact_type
        , last_name
        , first_name
        , middle_name
        , created_by
        , creation_date
        , last_updated_by
        , last_update_date)
        VALUES
        ( contact_s1.NEXTVAL
        , member_s1.CURRVAL
        , lv_contact_type
        , pv_last_name
        , pv_first_name
        , pv_middle_name
        , lv_system_user_id
        , SYSDATE
        , lv_system_user_id
        , SYSDATE);
        
        INSERT INTO address
        VALUES
        ( address_s1.NEXTVAL
        , contact_s1.CURRVAL
        , lv_address_type
        , pv_city
        , pv_state_province
        , pv_postal_code
        , lv_system_user_id
        , SYSDATE
        , lv_system_user_id
        , SYSDATE);
        
        INSERT INTO telephone
        VALUES
        ( telephone_s1.NEXTVAL
        , contact_s1.CURRVAL
        , address_s1.CURRVAL
        , lv_telephone_type
        , pv_country_code
        , pv_area_code
        , pv_telephone_number
        , lv_system_user_id
        , SYSDATE
        , lv_system_user_id
        , SYSDATE);

        RETURN 0;
        
        COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK TO starting_point;
        RETURN 1;
END insert_contact;
/

DESC insert_contact;

BEGIN
    IF insert_contact
        ( 'Harriet'
        , 'Mary'
        , 'McDonnell'
        , 'CUSTOMER'
        , 'SLC-000010'
        , 'INDIVIDUAL'
        , '9999-8888-7777-6666'
        , 'VISA_CARD'
        , 'Orono'
        , 'Maine'
        , '04469'
        , 'HOME'
        , '001'
        , '207'
        , '111-1234'
        , 'HOME'
        , 'DBA 2') = 0 THEN dbms_output.put_line('The insert_contact function worked correctly.');
    ELSE
        dbms_output.put_line('An error occured when attempting to run this function.');
    END IF;
END;
/

COL full_name      FORMAT A24
COL account_number FORMAT A10 HEADING "ACCOUNT|NUMBER"
COL address        FORMAT A22
COL telephone      FORMAT A14

SELECT c.first_name
||     CASE
         WHEN c.middle_name IS NOT NULL THEN ' '||c.middle_name||' ' ELSE ' '
       END
||     c.last_name AS full_name
,      m.account_number
,      a.city || ', ' || a.state_province AS address
,      '(' || t.area_code || ') ' || t.telephone_number AS telephone
FROM   member m INNER JOIN contact c
ON     m.member_id = c.member_id INNER JOIN address a
ON     c.contact_id = a.contact_id INNER JOIN telephone t
ON     c.contact_id = t.contact_id
AND    a.address_id = t.address_id
WHERE  c.last_name = 'McDonnell';

DROP TYPE contact_obj FORCE;
DROP TYPE contact_tab FORCE;

CREATE OR REPLACE TYPE contact_obj IS OBJECT
    ( first_name VARCHAR2(30)
    , middle_name VARCHAR2(30)
    , last_name VARCHAR2(30));
/

CREATE OR REPLACE TYPE contact_tab IS TABLE OF contact_obj;
/

CREATE OR REPLACE FUNCTION get_contact
 RETURN CONTACT_TAB IS
    lv_contact_tab CONTACT_TAB := contact_tab();
    
    CURSOR c IS
        SELECT first_name, middle_name, last_name
        FROM contact;
BEGIN
    FOR i IN c LOOP
        lv_contact_tab.EXTEND;
        lv_contact_tab(lv_contact_tab.COUNT) := contact_obj(i.first_name, i.middle_name, i.last_name);

    END LOOP;
    RETURN lv_contact_tab;
END;
/

SET PAGESIZE 999
COL full_name FORMAT A24
SELECT first_name || CASE
                       WHEN middle_name IS NOT NULL
                       THEN ' ' || middle_name || ' '
                       ELSE ' '
                     END || last_name AS full_name
FROM   TABLE(get_contact);

-- Close log file.
SPOOL OFF
SHOW ERRORS