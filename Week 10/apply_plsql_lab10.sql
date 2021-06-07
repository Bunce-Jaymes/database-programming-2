/*
||  Name:          apply_plsql_lab10.sql
||  Date:          11 Nov 2016
||  Purpose:       Complete 325 Chapter 11 lab.
*/

-- Open log file.
SPOOL apply_plsql_lab10.txt

-- ... insert your solution here ...

DROP TYPE base_t FORCE;

CREATE OR REPLACE TYPE base_t IS OBJECT
    ( oname VARCHAR2(30)
    , name VARCHAR2(30)
    , CONSTRUCTOR FUNCTION base_t RETURN SELF AS RESULT
    , CONSTRUCTOR FUNCTION base_t
    ( oname VARCHAR2
    , name VARCHAR2) RETURN SELF AS RESULT
    , MEMBER FUNCTION get_name RETURN VARCHAR2
    , MEMBER FUNCTION get_oname RETURN VARCHAR2
    , MEMBER PROCEDURE set_oname
    ( oname VARCHAR2)
    , MEMBER FUNCTION to_string RETURN VARCHAR2)
INSTANTIABLE NOT FINAL;
/

DESC base_t

DROP TABLE logger;
DROP SEQUENCE logger_s;

CREATE TABLE logger
    ( logger_id NUMBER
    , log_text BASE_T);

CREATE SEQUENCE logger_s;

DESC logger

CREATE OR REPLACE TYPE BODY base_t IS

    CONSTRUCTOR FUNCTION base_t RETURN SELF AS RESULT IS
    BEGIN
        self.oname := 'BASE_T';
        RETURN;
    END;
    
    CONSTRUCTOR FUNCTION base_t
    ( oname VARCHAR2
    , name VARCHAR2) RETURN SELF AS RESULT IS
    BEGIN
        self.oname := oname;
        IF name IS NOT NULL AND name IN ('NEW', 'OLD') THEN
            self.name := name;
        END IF;
        RETURN;
    END;
    
    MEMBER FUNCTION get_name RETURN VARCHAR2 IS
    BEGIN
        RETURN self.name;
    END get_name;
    
    MEMBER FUNCTION get_oname RETURN VARCHAR2 IS
    BEGIN
        RETURN self.oname;
    END get_oname;
    
    MEMBER PROCEDURE set_oname ( oname VARCHAR2) IS
    BEGIN
        self.oname := oname;
    END set_oname;
    
    MEMBER FUNCTION to_string RETURN VARCHAR2 IS
    BEGIN
        RETURN '['||self.oname||']';
    END to_string;
END;
/

DECLARE
  lv_instance  BASE_T := base_t();
BEGIN
  dbms_output.put_line('Default  : ['||lv_instance.get_oname()||']');
  
  lv_instance.set_oname('SUBSTITUTE');

  dbms_output.put_line('Override : ['||lv_instance.get_oname()||']');
END;
/

INSERT INTO logger
VALUES (logger_s.NEXTVAL, base_t());

DECLARE
  /* Declare a variable of the UDT type. */
  lv_base  BASE_T;
BEGIN
  /* Assign an instance of the variable. */
  lv_base := base_t(
      oname => 'BASE_T'
    , name => 'NEW' );

    /* Insert instance of the base_t object type into table. */
    INSERT INTO logger
    VALUES (logger_s.NEXTVAL, lv_base);

    /* Commit the record. */
    COMMIT;
END;
/

COLUMN oname     FORMAT A20
COLUMN get_name  FORMAT A20
COLUMN to_string FORMAT A20
SELECT t.logger_id
,      t.log.oname AS oname
,      NVL(t.log.get_name(),'Unset') AS get_name
,      t.log.to_string() AS to_string
FROM  (SELECT l.logger_id
       ,      TREAT(l.log_text AS base_t) AS log
       FROM   logger l) t
WHERE  t.log.oname = 'BASE_T';

DROP TYPE item_t FORCE;

CREATE OR REPLACE
  TYPE item_t UNDER base_t
  ( item_id            NUMBER
  , item_barcode       VARCHAR2(20)
  , item_type          NUMBER
  , item_title         VARCHAR2(60)
  , item_subtitle      VARCHAR2(60)
  , item_rating        VARCHAR2(8)
  , item_rating_agency VARCHAR2(4)
  , item_release_date  DATE
  , created_by         NUMBER
  , creation_date      DATE
  , last_updated_by    NUMBER
  , last_update_date   DATE
  , CONSTRUCTOR FUNCTION item_t
    ( oname              VARCHAR2
    , name               VARCHAR2
    , item_id            NUMBER
    , item_barcode       VARCHAR2
    , item_type          NUMBER
    , item_title         VARCHAR2
    , item_subtitle      VARCHAR2
    , item_rating        VARCHAR2
    , item_rating_agency VARCHAR2
    , item_release_date  DATE
    , created_by         NUMBER
    , creation_date      DATE
    , last_updated_by    NUMBER
    , last_update_date   DATE ) RETURN SELF AS RESULT
  , CONSTRUCTOR FUNCTION item_t
    ( oname              VARCHAR2
    , name               VARCHAR2 ) RETURN SELF AS RESULT
  , OVERRIDING MEMBER FUNCTION get_name RETURN VARCHAR2
  , OVERRIDING MEMBER FUNCTION to_string RETURN VARCHAR2)
  INSTANTIABLE NOT FINAL;
/

DESC item_t;

CREATE OR REPLACE
  TYPE BODY item_t IS
    CONSTRUCTOR FUNCTION item_t
    ( oname              VARCHAR2
    , name               VARCHAR2
    , item_id            NUMBER
    , item_barcode       VARCHAR2
    , item_type          NUMBER
    , item_title         VARCHAR2
    , item_subtitle      VARCHAR2
    , item_rating        VARCHAR2
    , item_rating_agency VARCHAR2
    , item_release_date  DATE
    , created_by         NUMBER
    , creation_date      DATE
    , last_updated_by    NUMBER
    , last_update_date   DATE ) RETURN SELF AS RESULT IS
    BEGIN
      self.oname := oname;
      IF name IS NOT NULL AND name IN ('NEW','OLD') THEN
        self.name := name;
      END IF;
  
      self.item_id := item_id;
      self.item_barcode := item_barcode;
      self.item_type := item_type;
      self.item_title := item_title;
      self.item_subtitle := item_subtitle;
      self.item_rating := item_rating;
      self.item_rating_agency := item_rating_agency;
      self.item_release_date := item_release_date;
      self.created_by := created_by;
      self.creation_date := creation_date;
      self.last_updated_by := last_updated_by;
      self.last_update_date := last_update_date;
 
      RETURN;
    END;

    CONSTRUCTOR FUNCTION item_t
    ( oname              VARCHAR2
    , name               VARCHAR2 ) RETURN SELF AS RESULT IS
    BEGIN
      self.oname := oname;
 
      IF name IS NOT NULL AND name IN ('NEW','OLD') THEN
        self.name := name;
      END IF;
      RETURN;
    END;
 
    OVERRIDING MEMBER FUNCTION get_name RETURN VARCHAR2 IS
    BEGIN
      RETURN (self AS base_t).get_name();
    END get_name;
 
    OVERRIDING MEMBER FUNCTION to_string RETURN VARCHAR2 IS
    BEGIN
      RETURN (self AS base_t).to_string()||'.['||self.name||']';
    END to_string;
  END;
/

DROP TYPE contact_t FORCE;

CREATE OR REPLACE
  TYPE contact_t UNDER base_t
  ( contact_id       NUMBER
  , member_id        NUMBER
  , contact_type     NUMBER
  , first_name       VARCHAR2(20)
  , middle_name      VARCHAR2(20)
  , last_name        VARCHAR2(20)
  , created_by       NUMBER
  , creation_date    DATE
  , last_updated_by  NUMBER
  , last_update_date DATE
  , CONSTRUCTOR FUNCTION contact_t
    ( oname            VARCHAR2
    , name             VARCHAR2
    , contact_id       NUMBER
    , member_id        NUMBER
    , contact_type     NUMBER
    , first_name       VARCHAR2
    , middle_name      VARCHAR2
    , last_name        VARCHAR2
    , created_by       NUMBER
    , creation_date    DATE
    , last_updated_by  NUMBER
    , last_update_date DATE ) RETURN SELF AS RESULT
  , CONSTRUCTOR FUNCTION contact_t
    ( oname            VARCHAR2
    , name             VARCHAR2 ) RETURN SELF AS RESULT
  , OVERRIDING MEMBER FUNCTION get_name RETURN VARCHAR2
  , OVERRIDING MEMBER FUNCTION to_string RETURN VARCHAR2)
  INSTANTIABLE NOT FINAL;
/

CREATE OR REPLACE
  TYPE BODY contact_t IS
    CONSTRUCTOR FUNCTION contact_t
    ( oname            VARCHAR2
    , name             VARCHAR2
    , contact_id       NUMBER
    , member_id        NUMBER
    , contact_type     NUMBER
    , first_name       VARCHAR2
    , middle_name      VARCHAR2
    , last_name        VARCHAR2
    , created_by       NUMBER
    , creation_date    DATE
    , last_updated_by  NUMBER
    , last_update_date DATE ) RETURN SELF AS RESULT IS
    BEGIN  
      self.oname := oname;
      IF name IS NOT NULL AND name IN ('NEW','OLD') THEN
        self.name := name;
      END IF;
 
      self.contact_id := contact_id;
      self.member_id := member_id;
      self.contact_type := contact_type;
      self.first_name := first_name;
      self.middle_name := middle_name;
      self.last_name := last_name;
      self.created_by := created_by;
      self.creation_date := creation_date;
      self.last_updated_by := last_updated_by;
      self.last_update_date := last_update_date;
 
      RETURN;
    END;

    CONSTRUCTOR FUNCTION contact_t
    ( oname              VARCHAR2
    , name               VARCHAR2 ) RETURN SELF AS RESULT IS
    BEGIN   
      self.oname := oname;
      IF name IS NOT NULL AND name IN ('NEW','OLD') THEN
        self.name := name;
      END IF;
      RETURN;
    END;
 
    OVERRIDING MEMBER FUNCTION get_name RETURN VARCHAR2 IS
    BEGIN
      RETURN (self AS base_t).get_name();
    END get_name;
 
    OVERRIDING MEMBER FUNCTION to_string RETURN VARCHAR2 IS
    BEGIN
      RETURN (self AS base_t).to_string()||'.['||self.name||']';
    END to_string;
  END;
/

DECLARE
  /* Declare a variable of the UDT type. */
  lv_item  ITEM_T;
  lv_contact  CONTACT_T;
BEGIN
  /* Assign an instance of the variable. */
  lv_item := item_t(
      oname => 'ITEM_T'
    , name  => 'NEW' );

  lv_contact := contact_t(
      oname => 'CONTACT_T'
    , name  => 'NEW' );
 
    /* Insert instance of the item_t object type into table. */
    INSERT INTO logger VALUES (logger_s.NEXTVAL, lv_item);

    INSERT INTO logger VALUES (logger_s.NEXTVAL, lv_contact);
 
    /* Commit the record. */
    COMMIT;
END;
/

COLUMN oname     FORMAT A20
COLUMN get_name  FORMAT A20
COLUMN to_string FORMAT A20
SELECT t.logger_id
,      t.log.oname AS oname
,      t.log.get_name() AS get_name
,      t.log.to_string() AS to_string
FROM  (SELECT l.logger_id
       ,      TREAT(l.log_text AS base_t) AS log
       FROM   logger l) t
WHERE  t.log.oname IN ('CONTACT_T','ITEM_T');

-- Close your log file.
SPOOL OFF