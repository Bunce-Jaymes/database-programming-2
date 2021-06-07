/*
||  Name:          apply_plsql_lab8.sql
||  Date:          11 Nov 2016
||  Purpose:       Complete 325 Chapter 9 lab.
*/

-- Open log file.
SPOOL apply_plsql_lab8.txt

-- Enter your solution here.
SET SERVEROUTPUT ON SIZE UNLIMITED

@/home/student/Data/cit325/lab7/apply_plsql_lab7.sql

CREATE OR REPLACE PACKAGE contact_package IS

  PROCEDURE insert_contact
  ( pv_first_name          VARCHAR2
  , pv_middle_name         VARCHAR2
  , pv_last_name           VARCHAR2
  , pv_contact_type        VARCHAR2
  , pv_account_number      VARCHAR2
  , pv_member_type         VARCHAR2
  , pv_credit_card_number  VARCHAR2
  , pv_credit_card_type    VARCHAR2
  , pv_city                VARCHAR2
  , pv_state_province      VARCHAR2
  , pv_postal_code         VARCHAR2
  , pv_address_type        VARCHAR2
  , pv_country_code        VARCHAR2
  , pv_area_code           VARCHAR2
  , pv_telephone_number    VARCHAR2
  , pv_telephone_type      VARCHAR2
  , pv_user_name           VARCHAR2);

  PROCEDURE insert_contact
  ( pv_first_name          VARCHAR2
  , pv_middle_name         VARCHAR2
  , pv_last_name           VARCHAR2
  , pv_contact_type        VARCHAR2
  , pv_account_number      VARCHAR2
  , pv_member_type         VARCHAR2
  , pv_credit_card_number  VARCHAR2
  , pv_credit_card_type    VARCHAR2
  , pv_city                VARCHAR2
  , pv_state_province      VARCHAR2
  , pv_postal_code         VARCHAR2
  , pv_address_type        VARCHAR2
  , pv_country_code        VARCHAR2
  , pv_area_code           VARCHAR2
  , pv_telephone_number    VARCHAR2
  , pv_telephone_type      VARCHAR2
  , pv_user_id             NUMBER  := -1 );
END contact_package;
/

DESC contact_package;

CREATE OR REPLACE PACKAGE BODY contact_package IS

  PROCEDURE insert_contact
  ( pv_first_name          VARCHAR2
  , pv_middle_name         VARCHAR2
  , pv_last_name           VARCHAR2
  , pv_contact_type        VARCHAR2
  , pv_account_number      VARCHAR2
  , pv_member_type         VARCHAR2
  , pv_credit_card_number  VARCHAR2
  , pv_credit_card_type    VARCHAR2
  , pv_city                VARCHAR2
  , pv_state_province      VARCHAR2
  , pv_postal_code         VARCHAR2
  , pv_address_type        VARCHAR2
  , pv_country_code        VARCHAR2
  , pv_area_code           VARCHAR2
  , pv_telephone_number    VARCHAR2
  , pv_telephone_type      VARCHAR2
  , pv_user_name           VARCHAR2) IS


  lv_address_type        VARCHAR2(30);
  lv_contact_type        VARCHAR2(30);
  lv_credit_card_type    VARCHAR2(30);
  lv_member_type         VARCHAR2(30);
  lv_telephone_type      VARCHAR2(30);

  lv_member_id NUMBER;
  lv_system_user_id NUMBER;

  CURSOR get_member IS 
  SELECT member_id FROM member
  WHERE account_number = pv_account_number;

  CURSOR c_system_user IS
  SELECT system_user_id FROM system_user
  WHERE system_user_name = pv_user_name;

    BEGIN

        lv_address_type := pv_address_type;
        lv_contact_type := pv_contact_type;
        lv_credit_card_type := pv_credit_card_type;
        lv_member_type := pv_member_type;
        lv_telephone_type := pv_telephone_type;

        SAVEPOINT starting_point;

        FOR i IN c_system_user LOOP
            lv_system_user_id := i.system_user_id;
        END LOOP;

        OPEN get_member;
        FETCH get_member INTO lv_member_id;

        IF get_member%NOTFOUND THEN
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
                , ( SELECT common_lookup_id
                    FROM common_lookup
                    WHERE common_lookup_table = 'MEMBER'
                    AND common_lookup_column = 'MEMBER_TYPE'
                    AND common_lookup_type = lv_member_type)
                , pv_account_number
                , pv_credit_card_number
                , ( SELECT common_lookup_id
                    FROM common_lookup
                    WHERE common_lookup_table = 'MEMBER'
                    AND common_lookup_column = 'CREDIT_CARD_TYPE'
                    AND common_lookup_type = lv_credit_card_type)
                , lv_system_user_id
                , SYSDATE
                , lv_system_user_id
                , SYSDATE);

            lv_member_id := member_s1.CURRVAL;
        END IF;
                    
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
            , lv_member_id
            , ( SELECT common_lookup_id
                FROM common_lookup
                WHERE common_lookup_table = 'CONTACT'
                AND common_lookup_column = 'CONTACT_TYPE'
                AND common_lookup_type = lv_contact_type)
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
            , ( SELECT common_lookup_id
                FROM common_lookup
                WHERE common_lookup_table = 'ADDRESS'
                AND common_lookup_column = 'ADDRESS_TYPE'
                AND common_lookup_type = lv_address_type)
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
            , ( SELECT common_lookup_id
                    FROM common_lookup
                    WHERE common_lookup_table = 'TELEPHONE'
                    AND common_lookup_column = 'TELEPHONE_TYPE'
                    AND common_lookup_type = lv_telephone_type)
            , pv_country_code
            , pv_area_code
            , pv_telephone_number
            , lv_system_user_id
            , SYSDATE
            , lv_system_user_id
            , SYSDATE);
            
        CLOSE get_member;
        
    COMMIT;

    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK TO starting_point;

    END insert_contact;

    PROCEDURE insert_contact
        ( pv_first_name          VARCHAR2
        , pv_middle_name         VARCHAR2
        , pv_last_name           VARCHAR2
        , pv_contact_type        VARCHAR2
        , pv_account_number      VARCHAR2
        , pv_member_type         VARCHAR2
        , pv_credit_card_number  VARCHAR2
        , pv_credit_card_type    VARCHAR2
        , pv_city                VARCHAR2
        , pv_state_province      VARCHAR2
        , pv_postal_code         VARCHAR2
        , pv_address_type        VARCHAR2
        , pv_country_code        VARCHAR2
        , pv_area_code           VARCHAR2
        , pv_telephone_number    VARCHAR2
        , pv_telephone_type      VARCHAR2
        , pv_user_id             NUMBER  := -1 ) IS


        lv_address_type        VARCHAR2(30);
        lv_contact_type        VARCHAR2(30);
        lv_credit_card_type    VARCHAR2(30);
        lv_member_type         VARCHAR2(30);
        lv_telephone_type      VARCHAR2(30);

        lv_member_id NUMBER;
        lv_system_user_id NUMBER;

        CURSOR get_member IS 
        SELECT member_id FROM member
        WHERE account_number = pv_account_number;

        CURSOR c_system_user IS
        SELECT system_user_id FROM system_user
        WHERE system_user_id = pv_user_id;

            BEGIN

                lv_address_type := pv_address_type;
                lv_contact_type := pv_contact_type;
                lv_credit_card_type := pv_credit_card_type;
                lv_member_type := pv_member_type;
                lv_telephone_type := pv_telephone_type;

                lv_system_user_id := pv_user_id;

                SAVEPOINT starting_point;

                FOR i IN c_system_user LOOP
                    lv_system_user_id := i.system_user_id;
                END LOOP;

                OPEN get_member;
                FETCH get_member INTO lv_member_id;

                IF get_member%NOTFOUND THEN
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
                        , ( SELECT common_lookup_id
                            FROM common_lookup
                            WHERE common_lookup_table = 'MEMBER'
                            AND common_lookup_column = 'MEMBER_TYPE'
                            AND common_lookup_type = lv_member_type)
                        , pv_account_number
                        , pv_credit_card_number
                        , ( SELECT common_lookup_id
                            FROM common_lookup
                            WHERE common_lookup_table = 'MEMBER'
                            AND common_lookup_column = 'CREDIT_CARD_TYPE'
                            AND common_lookup_type = lv_credit_card_type)
                        , lv_system_user_id
                        , SYSDATE
                        , lv_system_user_id
                        , SYSDATE);

                    lv_member_id := member_s1.CURRVAL;
                END IF;
                            
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
                    , lv_member_id
                    , ( SELECT common_lookup_id
                        FROM common_lookup
                        WHERE common_lookup_table = 'CONTACT'
                        AND common_lookup_column = 'CONTACT_TYPE'
                        AND common_lookup_type = lv_contact_type)
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
                    , ( SELECT common_lookup_id
                        FROM common_lookup
                        WHERE common_lookup_table = 'ADDRESS'
                        AND common_lookup_column = 'ADDRESS_TYPE'
                        AND common_lookup_type = lv_address_type)
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
                    , ( SELECT common_lookup_id
                            FROM common_lookup
                            WHERE common_lookup_table = 'TELEPHONE'
                            AND common_lookup_column = 'TELEPHONE_TYPE'
                            AND common_lookup_type = lv_telephone_type)
                    , pv_country_code
                    , pv_area_code
                    , pv_telephone_number
                    , lv_system_user_id
                    , SYSDATE
                    , lv_system_user_id
                    , SYSDATE);
                    
                CLOSE get_member;
                
            COMMIT;

            EXCEPTION
                WHEN OTHERS THEN
                    ROLLBACK TO starting_point;

            END insert_contact;
 END contact_package;
/

INSERT INTO system_user
( system_user_id
, system_user_name
, system_user_group_id
, system_user_type
, first_name
, middle_initial
, last_name
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( 6
, 'BONDSB'
, 1
, 1
, 'Barry'
, 'L'
, 'Bonds'
, 1
, SYSDATE
, 1
, SYSDATE);

INSERT INTO system_user
( system_user_id
, system_user_name
, system_user_group_id
, system_user_type
, first_name
, middle_initial
, last_name
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( 7
, 'CURRYW'
, 1
, 1
, 'Wardell'
, 'S'
, 'Curry'
, 1
, SYSDATE
, 1
, SYSDATE);


INSERT INTO system_user
( system_user_id
, system_user_name
, system_user_group_id
, system_user_type
, first_name
, middle_initial
, last_name
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( -1
, 'ANONYMOUS'
, 1
, 1
, ''
, ''
, ''
, 1
, SYSDATE
, 1
, SYSDATE);


COL system_user_id  FORMAT 9999  HEADING "System|User ID"
COL system_user_name FORMAT A12  HEADING "System|User Name"
COL first_name       FORMAT A10  HEADING "First|Name"
COL middle_initial   FORMAT A2   HEADING "MI"
COL last_name        FORMAT A10  HeADING "Last|Name"
SELECT system_user_id
,      system_user_name
,      first_name
,      middle_initial
,      last_name
FROM   system_user
WHERE  last_name IN ('Bonds','Curry')
OR     system_user_name = 'ANONYMOUS';

BEGIN
    contact_package.insert_contact
    ( pv_first_name => 'Charlie'
    , pv_middle_name => NULL
    , pv_last_name => 'Brown'
    , pv_contact_type => 'CUSTOMER'
    , pv_account_number => 'SLC-000011'
    , pv_member_type => 'GROUP'
    , pv_credit_card_number => '8888-6666-8888-4444'
    , pv_credit_card_type => 'VISA_CARD'
    , pv_city => 'Lehi'
    , pv_state_province => 'Utah'
    , pv_postal_code => '84043'
    , pv_address_type => 'HOME'
    , pv_country_code => '001'
    , pv_area_code => '207'
    , pv_telephone_number => '877-4321'
    , pv_telephone_type => 'HOME'
    , pv_user_name => 'DBA 3');
END;
/

BEGIN
    contact_package.insert_contact
    ( pv_first_name => 'Peppermint'
    , pv_middle_name => NULL
    , pv_last_name => 'Patty'
    , pv_contact_type => 'CUSTOMER'
    , pv_account_number => 'SLC-000011'
    , pv_member_type => 'GROUP'
    , pv_credit_card_number => '8888-6666-8888-4444'
    , pv_credit_card_type => 'VISA_CARD'
    , pv_city => 'Lehi'
    , pv_state_province => 'Utah'
    , pv_postal_code => '84043'
    , pv_address_type => 'HOME'
    , pv_country_code => '001'
    , pv_area_code => '207'
    , pv_telephone_number => '877-4321'
    , pv_telephone_type => 'HOME'
    -- , pv_user_name => NULL
    -- , pv_user_id => NULL
    );
END;
/

BEGIN
    contact_package.insert_contact
    ( pv_first_name => 'Sally'
    , pv_middle_name => NULL
    , pv_last_name => 'Brown'
    , pv_contact_type => 'CUSTOMER'
    , pv_account_number => 'SLC-000011'
    , pv_member_type => 'GROUP'
    , pv_credit_card_number => '8888-6666-8888-4444'
    , pv_credit_card_type => 'VISA_CARD'
    , pv_city => 'Lehi'
    , pv_state_province => 'Utah'
    , pv_postal_code => '84043'
    , pv_address_type => 'HOME'
    , pv_country_code => '001'
    , pv_area_code => '207'
    , pv_telephone_number => '877-4321'
    , pv_telephone_type => 'HOME'
    , pv_user_id => 6
    );
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
WHERE  c.last_name IN ('Brown','Patty');

DROP PROCEDURE insert_contact;

CREATE OR REPLACE PACKAGE contact_package IS

  FUNCTION insert_contact
  ( pv_first_name          VARCHAR2
  , pv_middle_name         VARCHAR2
  , pv_last_name           VARCHAR2
  , pv_contact_type        VARCHAR2
  , pv_account_number      VARCHAR2
  , pv_member_type         VARCHAR2
  , pv_credit_card_number  VARCHAR2
  , pv_credit_card_type    VARCHAR2
  , pv_city                VARCHAR2
  , pv_state_province      VARCHAR2
  , pv_postal_code         VARCHAR2
  , pv_address_type        VARCHAR2
  , pv_country_code        VARCHAR2
  , pv_area_code           VARCHAR2
  , pv_telephone_number    VARCHAR2
  , pv_telephone_type      VARCHAR2
  , pv_user_name           VARCHAR2) RETURN NUMBER;

  FUNCTION insert_contact
  ( pv_first_name          VARCHAR2
  , pv_middle_name         VARCHAR2
  , pv_last_name           VARCHAR2
  , pv_contact_type        VARCHAR2
  , pv_account_number      VARCHAR2
  , pv_member_type         VARCHAR2
  , pv_credit_card_number  VARCHAR2
  , pv_credit_card_type    VARCHAR2
  , pv_city                VARCHAR2
  , pv_state_province      VARCHAR2
  , pv_postal_code         VARCHAR2
  , pv_address_type        VARCHAR2
  , pv_country_code        VARCHAR2
  , pv_area_code           VARCHAR2
  , pv_telephone_number    VARCHAR2
  , pv_telephone_type      VARCHAR2
  , pv_user_id             NUMBER  := -1 ) RETURN NUMBER;
END contact_package;
/

DESC contact_package;

CREATE OR REPLACE PACKAGE BODY contact_package IS

  FUNCTION insert_contact
  ( pv_first_name          VARCHAR2
  , pv_middle_name         VARCHAR2
  , pv_last_name           VARCHAR2
  , pv_contact_type        VARCHAR2
  , pv_account_number      VARCHAR2
  , pv_member_type         VARCHAR2
  , pv_credit_card_number  VARCHAR2
  , pv_credit_card_type    VARCHAR2
  , pv_city                VARCHAR2
  , pv_state_province      VARCHAR2
  , pv_postal_code         VARCHAR2
  , pv_address_type        VARCHAR2
  , pv_country_code        VARCHAR2
  , pv_area_code           VARCHAR2
  , pv_telephone_number    VARCHAR2
  , pv_telephone_type      VARCHAR2
  , pv_user_name           VARCHAR2) RETURN NUMBER IS


  lv_address_type        VARCHAR2(30);
  lv_contact_type        VARCHAR2(30);
  lv_credit_card_type    VARCHAR2(30);
  lv_member_type         VARCHAR2(30);
  lv_telephone_type      VARCHAR2(30);

  lv_member_id NUMBER;
  lv_system_user_id NUMBER;

  CURSOR get_member IS 
  SELECT member_id FROM member
  WHERE account_number = pv_account_number;

  CURSOR c_system_user IS
  SELECT system_user_id FROM system_user
  WHERE system_user_name = pv_user_name;

    BEGIN

        lv_address_type := pv_address_type;
        lv_contact_type := pv_contact_type;
        lv_credit_card_type := pv_credit_card_type;
        lv_member_type := pv_member_type;
        lv_telephone_type := pv_telephone_type;

        SAVEPOINT starting_point;

        FOR i IN c_system_user LOOP
            lv_system_user_id := i.system_user_id;
        END LOOP;

        OPEN get_member;
        FETCH get_member INTO lv_member_id;

        IF get_member%NOTFOUND THEN
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
                , ( SELECT common_lookup_id
                    FROM common_lookup
                    WHERE common_lookup_table = 'MEMBER'
                    AND common_lookup_column = 'MEMBER_TYPE'
                    AND common_lookup_type = lv_member_type)
                , pv_account_number
                , pv_credit_card_number
                , ( SELECT common_lookup_id
                    FROM common_lookup
                    WHERE common_lookup_table = 'MEMBER'
                    AND common_lookup_column = 'CREDIT_CARD_TYPE'
                    AND common_lookup_type = lv_credit_card_type)
                , lv_system_user_id
                , SYSDATE
                , lv_system_user_id
                , SYSDATE);

            lv_member_id := member_s1.CURRVAL;
        END IF;
                    
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
            , lv_member_id
            , ( SELECT common_lookup_id
                FROM common_lookup
                WHERE common_lookup_table = 'CONTACT'
                AND common_lookup_column = 'CONTACT_TYPE'
                AND common_lookup_type = lv_contact_type)
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
            , ( SELECT common_lookup_id
                FROM common_lookup
                WHERE common_lookup_table = 'ADDRESS'
                AND common_lookup_column = 'ADDRESS_TYPE'
                AND common_lookup_type = lv_address_type)
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
            , ( SELECT common_lookup_id
                    FROM common_lookup
                    WHERE common_lookup_table = 'TELEPHONE'
                    AND common_lookup_column = 'TELEPHONE_TYPE'
                    AND common_lookup_type = lv_telephone_type)
            , pv_country_code
            , pv_area_code
            , pv_telephone_number
            , lv_system_user_id
            , SYSDATE
            , lv_system_user_id
            , SYSDATE);
            
        CLOSE get_member;
        
    COMMIT;
    RETURN 0;

    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK TO starting_point;

    END insert_contact;

    FUNCTION insert_contact
        ( pv_first_name          VARCHAR2
        , pv_middle_name         VARCHAR2
        , pv_last_name           VARCHAR2
        , pv_contact_type        VARCHAR2
        , pv_account_number      VARCHAR2
        , pv_member_type         VARCHAR2
        , pv_credit_card_number  VARCHAR2
        , pv_credit_card_type    VARCHAR2
        , pv_city                VARCHAR2
        , pv_state_province      VARCHAR2
        , pv_postal_code         VARCHAR2
        , pv_address_type        VARCHAR2
        , pv_country_code        VARCHAR2
        , pv_area_code           VARCHAR2
        , pv_telephone_number    VARCHAR2
        , pv_telephone_type      VARCHAR2
        , pv_user_id             NUMBER  := -1 ) RETURN NUMBER IS


        lv_address_type        VARCHAR2(30);
        lv_contact_type        VARCHAR2(30);
        lv_credit_card_type    VARCHAR2(30);
        lv_member_type         VARCHAR2(30);
        lv_telephone_type      VARCHAR2(30);

        lv_member_id NUMBER;
        lv_system_user_id NUMBER;

        CURSOR get_member IS 
        SELECT member_id FROM member
        WHERE account_number = pv_account_number;

        CURSOR c_system_user IS
        SELECT system_user_id FROM system_user
        WHERE system_user_id = pv_user_id;

            BEGIN

                lv_address_type := pv_address_type;
                lv_contact_type := pv_contact_type;
                lv_credit_card_type := pv_credit_card_type;
                lv_member_type := pv_member_type;
                lv_telephone_type := pv_telephone_type;

                lv_system_user_id := pv_user_id;

                SAVEPOINT starting_point;

                FOR i IN c_system_user LOOP
                    lv_system_user_id := i.system_user_id;
                END LOOP;

                OPEN get_member;
                FETCH get_member INTO lv_member_id;

                IF get_member%NOTFOUND THEN
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
                        , ( SELECT common_lookup_id
                            FROM common_lookup
                            WHERE common_lookup_table = 'MEMBER'
                            AND common_lookup_column = 'MEMBER_TYPE'
                            AND common_lookup_type = lv_member_type)
                        , pv_account_number
                        , pv_credit_card_number
                        , ( SELECT common_lookup_id
                            FROM common_lookup
                            WHERE common_lookup_table = 'MEMBER'
                            AND common_lookup_column = 'CREDIT_CARD_TYPE'
                            AND common_lookup_type = lv_credit_card_type)
                        , lv_system_user_id
                        , SYSDATE
                        , lv_system_user_id
                        , SYSDATE);

                    lv_member_id := member_s1.CURRVAL;
                END IF;
                            
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
                    , lv_member_id
                    , ( SELECT common_lookup_id
                        FROM common_lookup
                        WHERE common_lookup_table = 'CONTACT'
                        AND common_lookup_column = 'CONTACT_TYPE'
                        AND common_lookup_type = lv_contact_type)
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
                    , ( SELECT common_lookup_id
                        FROM common_lookup
                        WHERE common_lookup_table = 'ADDRESS'
                        AND common_lookup_column = 'ADDRESS_TYPE'
                        AND common_lookup_type = lv_address_type)
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
                    , ( SELECT common_lookup_id
                            FROM common_lookup
                            WHERE common_lookup_table = 'TELEPHONE'
                            AND common_lookup_column = 'TELEPHONE_TYPE'
                            AND common_lookup_type = lv_telephone_type)
                    , pv_country_code
                    , pv_area_code
                    , pv_telephone_number
                    , lv_system_user_id
                    , SYSDATE
                    , lv_system_user_id
                    , SYSDATE);
                    
                CLOSE get_member;
                
            COMMIT;
            RETURN 0;

            EXCEPTION
                WHEN OTHERS THEN
                    ROLLBACK TO starting_point;

            END insert_contact;
 END contact_package;
/

DECLARE

    lv_call_function NUMBER;

BEGIN

    lv_call_function := contact_package.insert_contact
    ( pv_first_name => 'Shirley'
    , pv_middle_name => NULL
    , pv_last_name => 'Partridge'
    , pv_contact_type => 'CUSTOMER'
    , pv_account_number => 'SLC-000012'
    , pv_member_type => 'GROUP'
    , pv_credit_card_number => '8888-6666-8888-4444'
    , pv_credit_card_type => 'VISA_CARD'
    , pv_city => 'Lehi'
    , pv_state_province => 'Utah'
    , pv_postal_code => '84043'
    , pv_address_type => 'HOME'
    , pv_country_code => '001'
    , pv_area_code => '207'
    , pv_telephone_number => '877-4321'
    , pv_telephone_type => 'HOME'
    , pv_user_name => 'DBA 3'
    );
    
    lv_call_function := contact_package.insert_contact
    ( pv_first_name => 'Keith'
    , pv_middle_name => NULL
    , pv_last_name => 'Partridge'
    , pv_contact_type => 'CUSTOMER'
    , pv_account_number => 'SLC-000012'
    , pv_member_type => 'GROUP'
    , pv_credit_card_number => '8888-6666-8888-4444'
    , pv_credit_card_type => 'VISA_CARD'
    , pv_city => 'Lehi'
    , pv_state_province => 'Utah'
    , pv_postal_code => '84043'
    , pv_address_type => 'HOME'
    , pv_country_code => '001'
    , pv_area_code => '207'
    , pv_telephone_number => '877-4321'
    , pv_telephone_type => 'HOME'
    , pv_user_id => '6'
    );
    
    lv_call_function := contact_package.insert_contact
    ( pv_first_name => 'Laurie'
    , pv_middle_name => NULL
    , pv_last_name => 'Partridge'
    , pv_contact_type => 'CUSTOMER'
    , pv_account_number => 'SLC-000012'
    , pv_member_type => 'GROUP'
    , pv_credit_card_number => '8888-6666-8888-4444'
    , pv_credit_card_type => 'VISA_CARD'
    , pv_city => 'Lehi'
    , pv_state_province => 'Utah'
    , pv_postal_code => '84043'
    , pv_address_type => 'HOME'
    , pv_country_code => '001'
    , pv_area_code => '207'
    , pv_telephone_number => '877-4321'
    , pv_telephone_type => 'HOME'
    , pv_user_id => '-1'
    );
END;
/

COL full_name      FORMAT A18   HEADING "Full Name"
COL created_by     FORMAT 9999  HEADING "System|User ID"
COL account_number FORMAT A12   HEADING "Account|Number"
COL address        FORMAT A16   HEADING "Address"
COL telephone      FORMAT A16   HEADING "Telephone"
SELECT c.first_name
||     CASE
         WHEN c.middle_name IS NOT NULL THEN ' '||c.middle_name||' ' ELSE ' '
       END
||     c.last_name AS full_name
,      c.created_by
,      m.account_number
,      a.city || ', ' || a.state_province AS address
,      '(' || t.area_code || ') ' || t.telephone_number AS telephone
FROM   member m INNER JOIN contact c
ON     m.member_id = c.member_id INNER JOIN address a
ON     c.contact_id = a.contact_id INNER JOIN telephone t
ON     c.contact_id = t.contact_id
AND    a.address_id = t.address_id
WHERE  c.last_name = 'Partridge';

-- Close log file.
SPOOL OFF

SHOW ERRORS