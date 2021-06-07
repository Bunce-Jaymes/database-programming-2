/*
||  Name:          apply_plsql_lab11.sql
||  Date:          11 Nov 2016
||  Purpose:       Complete 325 Chapter 12 lab.
||  Dependencies:  Run the Oracle Database 12c PL/SQL Programming setup programs.
*/

@/home/student/Data/cit325/lib/cleanup_oracle.sql
@/home/student/Data/cit325/lib/Oracle12cPLSQLCode/Introduction/create_video_store.sql

SPOOL apply_plsql_lab11.txt

-- ... insert your solution here ...

ALTER TABLE item
ADD (text_file_name VARCHAR2(40));

COLUMN table_name   FORMAT A14
COLUMN column_id    FORMAT 9999
COLUMN column_name  FORMAT A22
COLUMN data_type    FORMAT A12
SELECT   table_name
,        column_id
,        column_name
,        CASE
           WHEN nullable = 'N' THEN 'NOT NULL'
           ELSE ''
         END AS nullable
,        CASE
           WHEN data_type IN ('CHAR','VARCHAR2','NUMBER') THEN
             data_type||'('||data_length||')'
           ELSE
             data_type
         END AS data_type
FROM     user_tab_columns
WHERE    table_name = 'ITEM'
ORDER BY 2;

DESC item;

CREATE TABLE logger
( LOGGER_ID NUMBER
, OLD_ITEM_ID NUMBER
, OLD_ITEM_BARCODE VARCHAR2(20)
, OLD_ITEM_TYPE NUMBER
, OLD_ITEM_TITLE VARCHAR2(60)
, OLD_ITEM_SUBTITLE VARCHAR2(60)
, OLD_ITEM_RATING VARCHAR2(8)
, OLD_ITEM_RATING_AGENCY VARCHAR2(4)
, OLD_ITEM_RELEASE_DATE DATE
, OLD_CREATED_BY NUMBER
, OLD_CREATION_DATE DATE
, OLD_LAST_UPDATED_BY NUMBER
, OLD_LAST_UPDATE_DATE DATE
, OLD_TEXT_FILE_NAME VARCHAR2(40)
, NEW_ITEM_ID NUMBER
, NEW_ITEM_BARCODE VARCHAR2(20)
, NEW_ITEM_TYPE NUMBER
, NEW_ITEM_TITLE VARCHAR2(60)
, NEW_ITEM_SUBTITLE VARCHAR2(60)
, NEW_ITEM_RATING VARCHAR2(8)
, NEW_ITEM_RATING_AGENCY VARCHAR2(4)
, NEW_ITEM_RELEASE_DATE DATE
, NEW_CREATED_BY NUMBER
, NEW_CREATION_DATE DATE
, NEW_LAST_UPDATED_BY NUMBER
, NEW_LAST_UPDATE_DATE DATE
, NEW_TEXT_FILE_NAME VARCHAR2(40)
, CONSTRAINT logger_pk PRIMARY KEY (logger_id));

CREATE SEQUENCE logger_s;

DESC logger;

DECLARE
  /* Dynamic cursor. */
  CURSOR get_row IS
    SELECT * FROM item WHERE item_title = 'Brave Heart';
BEGIN
  /* Read the dynamic cursor. */
  FOR i IN get_row LOOP
 
    INSERT INTO logger
    ( LOGGER_ID
    , OLD_ITEM_ID
    , OLD_ITEM_BARCODE
    , OLD_ITEM_TYPE
    , OLD_ITEM_TITLE
    , OLD_ITEM_SUBTITLE
    , OLD_ITEM_RATING
    , OLD_ITEM_RATING_AGENCY
    , OLD_ITEM_RELEASE_DATE
    , OLD_CREATED_BY
    , OLD_CREATION_DATE
    , OLD_LAST_UPDATED_BY
    , OLD_LAST_UPDATE_DATE
    , OLD_TEXT_FILE_NAME
    , NEW_ITEM_ID
    , NEW_ITEM_BARCODE
    , NEW_ITEM_TYPE
    , NEW_ITEM_TITLE
    , NEW_ITEM_SUBTITLE
    , NEW_ITEM_RATING
    , NEW_ITEM_RATING_AGENCY
    , NEW_ITEM_RELEASE_DATE
    , NEW_CREATED_BY
    , NEW_CREATION_DATE
    , NEW_LAST_UPDATED_BY
    , NEW_LAST_UPDATE_DATE
    , NEW_TEXT_FILE_NAME)
    VALUES
    ( logger_s.NEXTVAL
    , i.ITEM_ID
    , i.ITEM_BARCODE
    , i.ITEM_TYPE
    , i.ITEM_TITLE
    , i.ITEM_SUBTITLE
    , i.ITEM_RATING
    , i.ITEM_RATING_AGENCY
    , i.ITEM_RELEASE_DATE
    , i.CREATED_BY
    , i.CREATION_DATE
    , i.LAST_UPDATED_BY
    , i.LAST_UPDATE_DATE
    , i.TEXT_FILE_NAME
    , i.ITEM_ID
    , i.ITEM_BARCODE
    , i.ITEM_TYPE
    , i.ITEM_TITLE
    , i.ITEM_SUBTITLE
    , i.ITEM_RATING
    , i.ITEM_RATING_AGENCY
    , i.ITEM_RELEASE_DATE
    , i.CREATED_BY
    , i.CREATION_DATE
    , i.LAST_UPDATED_BY
    , i.LAST_UPDATE_DATE
    , i.TEXT_FILE_NAME);
 
  END LOOP;
END;
/

COL logger_id       FORMAT 9999 HEADING "Logger|ID #"
COL old_item_id     FORMAT 9999 HEADING "Old|Item|ID #"
COL old_item_title  FORMAT A20  HEADING "Old Item Title"
COL new_item_id     FORMAT 9999 HEADING "New|Item|ID #"
COL new_item_title  FORMAT A30  HEADING "New Item Title"
SELECT l.logger_id
,      l.old_item_id
,      l.old_item_title
,      l.new_item_id
,      l.new_item_title
FROM   logger l;

CREATE OR REPLACE
  PACKAGE manage_item IS

  PROCEDURE item_insert
  ( PV_NEW_ITEM_ID NUMBER
  , PV_NEW_ITEM_BARCODE VARCHAR2
  , PV_NEW_ITEM_TYPE NUMBER
  , PV_NEW_ITEM_TITLE VARCHAR2
  , PV_NEW_ITEM_SUBTITLE VARCHAR2
  , PV_NEW_ITEM_RATING VARCHAR2
  , PV_NEW_ITEM_RATING_AGENCY VARCHAR2
  , PV_NEW_ITEM_RELEASE_DATE DATE
  , PV_NEW_CREATED_BY NUMBER
  , PV_NEW_CREATION_DATE DATE
  , PV_NEW_LAST_UPDATED_BY NUMBER
  , PV_NEW_LAST_UPDATE_DATE DATE
  , PV_NEW_TEXT_FILE_NAME VARCHAR2 );

  PROCEDURE item_insert
  ( PV_OLD_ITEM_ID NUMBER
  , PV_OLD_ITEM_BARCODE VARCHAR2
  , PV_OLD_ITEM_TYPE NUMBER
  , PV_OLD_ITEM_TITLE VARCHAR2
  , PV_OLD_ITEM_SUBTITLE VARCHAR2
  , PV_OLD_ITEM_RATING VARCHAR2
  , PV_OLD_ITEM_RATING_AGENCY VARCHAR2
  , PV_OLD_ITEM_RELEASE_DATE DATE
  , PV_OLD_CREATED_BY NUMBER
  , PV_OLD_CREATION_DATE DATE
  , PV_OLD_LAST_UPDATED_BY NUMBER
  , PV_OLD_LAST_UPDATE_DATE DATE
  , PV_OLD_TEXT_FILE_NAME VARCHAR2
  , PV_NEW_ITEM_ID NUMBER
  , PV_NEW_ITEM_BARCODE VARCHAR2
  , PV_NEW_ITEM_TYPE NUMBER
  , PV_NEW_ITEM_TITLE VARCHAR2
  , PV_NEW_ITEM_SUBTITLE VARCHAR2
  , PV_NEW_ITEM_RATING VARCHAR2
  , PV_NEW_ITEM_RATING_AGENCY VARCHAR2
  , PV_NEW_ITEM_RELEASE_DATE DATE
  , PV_NEW_CREATED_BY NUMBER
  , PV_NEW_CREATION_DATE DATE
  , PV_NEW_LAST_UPDATED_BY NUMBER
  , PV_NEW_LAST_UPDATE_DATE DATE
  , PV_NEW_TEXT_FILE_NAME VARCHAR2 );

  PROCEDURE item_insert
  ( PV_OLD_ITEM_ID NUMBER
  , PV_OLD_ITEM_BARCODE VARCHAR2
  , PV_OLD_ITEM_TYPE NUMBER
  , PV_OLD_ITEM_TITLE VARCHAR2
  , PV_OLD_ITEM_SUBTITLE VARCHAR2
  , PV_OLD_ITEM_RATING VARCHAR2
  , PV_OLD_ITEM_RATING_AGENCY VARCHAR2
  , PV_OLD_ITEM_RELEASE_DATE DATE
  , PV_OLD_CREATED_BY NUMBER
  , PV_OLD_CREATION_DATE DATE
  , PV_OLD_LAST_UPDATED_BY NUMBER
  , PV_OLD_LAST_UPDATE_DATE DATE
  , PV_OLD_TEXT_FILE_NAME VARCHAR2 );

END manage_item;
/

desc manage_item

CREATE OR REPLACE
  PACKAGE BODY manage_item IS

  PROCEDURE item_insert
    ( PV_NEW_ITEM_ID NUMBER
    , PV_NEW_ITEM_BARCODE VARCHAR2
    , PV_NEW_ITEM_TYPE NUMBER
    , PV_NEW_ITEM_TITLE VARCHAR2
    , PV_NEW_ITEM_SUBTITLE VARCHAR2
    , PV_NEW_ITEM_RATING VARCHAR2
    , PV_NEW_ITEM_RATING_AGENCY VARCHAR2
    , PV_NEW_ITEM_RELEASE_DATE DATE
    , PV_NEW_CREATED_BY NUMBER
    , PV_NEW_CREATION_DATE DATE
    , PV_NEW_LAST_UPDATED_BY NUMBER
    , PV_NEW_LAST_UPDATE_DATE DATE
    , PV_NEW_TEXT_FILE_NAME VARCHAR2 ) IS

  PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
    manage_item.item_insert(
        PV_OLD_ITEM_ID => null
      , PV_OLD_ITEM_BARCODE => null
      , PV_OLD_ITEM_TYPE => null
      , PV_OLD_ITEM_TITLE => null
      , PV_OLD_ITEM_SUBTITLE => null
      , PV_OLD_ITEM_RATING => null
      , PV_OLD_ITEM_RATING_AGENCY => null
      , PV_OLD_ITEM_RELEASE_DATE => null
      , PV_OLD_CREATED_BY => null
      , PV_OLD_CREATION_DATE => null
      , PV_OLD_LAST_UPDATED_BY => null
      , PV_OLD_LAST_UPDATE_DATE => null
      , PV_OLD_TEXT_FILE_NAME => null
      , PV_NEW_ITEM_ID => PV_NEW_ITEM_ID
      , PV_NEW_ITEM_BARCODE => PV_NEW_ITEM_BARCODE
      , PV_NEW_ITEM_TYPE => PV_NEW_ITEM_TYPE
      , PV_NEW_ITEM_TITLE => PV_NEW_ITEM_TITLE
      , PV_NEW_ITEM_SUBTITLE => PV_NEW_ITEM_SUBTITLE
      , PV_NEW_ITEM_RATING => PV_NEW_ITEM_RATING
      , PV_NEW_ITEM_RATING_AGENCY => PV_NEW_ITEM_RATING_AGENCY
      , PV_NEW_ITEM_RELEASE_DATE => PV_NEW_ITEM_RELEASE_DATE
      , PV_NEW_CREATED_BY => PV_NEW_CREATED_BY
      , PV_NEW_CREATION_DATE => PV_NEW_CREATION_DATE
      , PV_NEW_LAST_UPDATED_BY => PV_NEW_LAST_UPDATED_BY
      , PV_NEW_LAST_UPDATE_DATE => PV_NEW_LAST_UPDATE_DATE
      , PV_NEW_TEXT_FILE_NAME => PV_NEW_TEXT_FILE_NAME);
  EXCEPTION
    WHEN OTHERS THEN
     RETURN;
  END item_insert;

  PROCEDURE item_insert
    ( PV_OLD_ITEM_ID NUMBER
    , PV_OLD_ITEM_BARCODE VARCHAR2
    , PV_OLD_ITEM_TYPE NUMBER
    , PV_OLD_ITEM_TITLE VARCHAR2
    , PV_OLD_ITEM_SUBTITLE VARCHAR2
    , PV_OLD_ITEM_RATING VARCHAR2
    , PV_OLD_ITEM_RATING_AGENCY VARCHAR2
    , PV_OLD_ITEM_RELEASE_DATE DATE
    , PV_OLD_CREATED_BY NUMBER
    , PV_OLD_CREATION_DATE DATE
    , PV_OLD_LAST_UPDATED_BY NUMBER
    , PV_OLD_LAST_UPDATE_DATE DATE
    , PV_OLD_TEXT_FILE_NAME VARCHAR2
    , PV_NEW_ITEM_ID NUMBER
    , PV_NEW_ITEM_BARCODE VARCHAR2
    , PV_NEW_ITEM_TYPE NUMBER
    , PV_NEW_ITEM_TITLE VARCHAR2
    , PV_NEW_ITEM_SUBTITLE VARCHAR2
    , PV_NEW_ITEM_RATING VARCHAR2
    , PV_NEW_ITEM_RATING_AGENCY VARCHAR2
    , PV_NEW_ITEM_RELEASE_DATE DATE
    , PV_NEW_CREATED_BY NUMBER
    , PV_NEW_CREATION_DATE DATE
    , PV_NEW_LAST_UPDATED_BY NUMBER
    , PV_NEW_LAST_UPDATE_DATE DATE
    , PV_NEW_TEXT_FILE_NAME VARCHAR2 ) IS
  
    lv_logger_id  NUMBER;

    PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
    lv_logger_id := logger_s.NEXTVAL;

    SAVEPOINT starting;

    INSERT INTO logger
    ( LOGGER_ID
    , OLD_ITEM_ID
    , OLD_ITEM_BARCODE
    , OLD_ITEM_TYPE
    , OLD_ITEM_TITLE
    , OLD_ITEM_SUBTITLE
    , OLD_ITEM_RATING
    , OLD_ITEM_RATING_AGENCY
    , OLD_ITEM_RELEASE_DATE
    , OLD_CREATED_BY
    , OLD_CREATION_DATE
    , OLD_LAST_UPDATED_BY
    , OLD_LAST_UPDATE_DATE
    , OLD_TEXT_FILE_NAME
    , NEW_ITEM_ID
    , NEW_ITEM_BARCODE
    , NEW_ITEM_TYPE
    , NEW_ITEM_TITLE
    , NEW_ITEM_SUBTITLE
    , NEW_ITEM_RATING
    , NEW_ITEM_RATING_AGENCY
    , NEW_ITEM_RELEASE_DATE
    , NEW_CREATED_BY
    , NEW_CREATION_DATE
    , NEW_LAST_UPDATED_BY
    , NEW_LAST_UPDATE_DATE
    , NEW_TEXT_FILE_NAME )
    VALUES
    ( lv_logger_id
    , PV_OLD_ITEM_ID
    , PV_OLD_ITEM_BARCODE
    , PV_OLD_ITEM_TYPE
    , PV_OLD_ITEM_TITLE
    , PV_OLD_ITEM_SUBTITLE
    , PV_OLD_ITEM_RATING
    , PV_OLD_ITEM_RATING_AGENCY
    , PV_OLD_ITEM_RELEASE_DATE
    , PV_OLD_CREATED_BY
    , PV_OLD_CREATION_DATE
    , PV_OLD_LAST_UPDATED_BY
    , PV_OLD_LAST_UPDATE_DATE
    , PV_OLD_TEXT_FILE_NAME
    , PV_NEW_ITEM_ID
    , PV_NEW_ITEM_BARCODE
    , PV_NEW_ITEM_TYPE
    , PV_NEW_ITEM_TITLE
    , PV_NEW_ITEM_SUBTITLE
    , PV_NEW_ITEM_RATING
    , PV_NEW_ITEM_RATING_AGENCY
    , PV_NEW_ITEM_RELEASE_DATE
    , PV_NEW_CREATED_BY
    , PV_NEW_CREATION_DATE
    , PV_NEW_LAST_UPDATED_BY
    , PV_NEW_LAST_UPDATE_DATE
    , PV_NEW_TEXT_FILE_NAME );
    
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK TO starting;
      RETURN;
  END item_insert;

  PROCEDURE item_insert
      ( PV_OLD_ITEM_ID NUMBER
      , PV_OLD_ITEM_BARCODE VARCHAR2
      , PV_OLD_ITEM_TYPE NUMBER
      , PV_OLD_ITEM_TITLE VARCHAR2
      , PV_OLD_ITEM_SUBTITLE VARCHAR2
      , PV_OLD_ITEM_RATING VARCHAR2
      , PV_OLD_ITEM_RATING_AGENCY VARCHAR2
      , PV_OLD_ITEM_RELEASE_DATE DATE
      , PV_OLD_CREATED_BY NUMBER
      , PV_OLD_CREATION_DATE DATE
      , PV_OLD_LAST_UPDATED_BY NUMBER
      , PV_OLD_LAST_UPDATE_DATE DATE
      , PV_OLD_TEXT_FILE_NAME VARCHAR2 ) IS

     PRAGMA AUTONOMOUS_TRANSACTION;
 BEGIN
    manage_item.item_insert(
        PV_OLD_ITEM_ID => PV_OLD_ITEM_ID
      , PV_OLD_ITEM_BARCODE => PV_OLD_ITEM_BARCODE
      , PV_OLD_ITEM_TYPE => PV_OLD_ITEM_TYPE
      , PV_OLD_ITEM_TITLE => PV_OLD_ITEM_TITLE
      , PV_OLD_ITEM_SUBTITLE => PV_OLD_ITEM_SUBTITLE
      , PV_OLD_ITEM_RATING => PV_OLD_ITEM_RATING
      , PV_OLD_ITEM_RATING_AGENCY => PV_OLD_ITEM_RATING_AGENCY
      , PV_OLD_ITEM_RELEASE_DATE => PV_OLD_ITEM_RELEASE_DATE
      , PV_OLD_CREATED_BY => PV_OLD_CREATED_BY
      , PV_OLD_CREATION_DATE => PV_OLD_CREATION_DATE
      , PV_OLD_LAST_UPDATED_BY => PV_OLD_LAST_UPDATED_BY
      , PV_OLD_LAST_UPDATE_DATE => PV_OLD_LAST_UPDATE_DATE
      , PV_OLD_TEXT_FILE_NAME => PV_OLD_TEXT_FILE_NAME
      , PV_NEW_ITEM_ID => null
      , PV_NEW_ITEM_BARCODE => null
      , PV_NEW_ITEM_TYPE => null
      , PV_NEW_ITEM_TITLE => null
      , PV_NEW_ITEM_SUBTITLE => null
      , PV_NEW_ITEM_RATING => null
      , PV_NEW_ITEM_RATING_AGENCY => null
      , PV_NEW_ITEM_RELEASE_DATE => null
      , PV_NEW_CREATED_BY => null
      , PV_NEW_CREATION_DATE => null
      , PV_NEW_LAST_UPDATED_BY => null
      , PV_NEW_LAST_UPDATE_DATE => null
      , PV_NEW_TEXT_FILE_NAME => null);
  EXCEPTION
    WHEN OTHERS THEN
     RETURN;
  END item_insert;
END manage_item;
/

DECLARE
  /* Dynamic cursor. */
  CURSOR get_row IS
    SELECT * FROM item WHERE item_title = 'King Arthur';
BEGIN
  /* Read the dynamic cursor. */
  FOR i IN get_row LOOP
    manage_item.item_insert(
        PV_NEW_ITEM_ID => i.ITEM_ID
      , PV_NEW_ITEM_BARCODE => i.ITEM_BARCODE
      , PV_NEW_ITEM_TYPE => i.ITEM_TYPE
      , PV_NEW_ITEM_TITLE => i.ITEM_TITLE || '-Inserted'
      , PV_NEW_ITEM_SUBTITLE => i.ITEM_SUBTITLE
      , PV_NEW_ITEM_RATING => i.ITEM_RATING
      , PV_NEW_ITEM_RATING_AGENCY => i.ITEM_RATING_AGENCY
      , PV_NEW_ITEM_RELEASE_DATE => i.ITEM_RELEASE_DATE
      , PV_NEW_CREATED_BY => i.CREATED_BY
      , PV_NEW_CREATION_DATE => i.CREATION_DATE
      , PV_NEW_LAST_UPDATED_BY => i.LAST_UPDATED_BY
      , PV_NEW_LAST_UPDATE_DATE => i.LAST_UPDATE_DATE
      , PV_NEW_TEXT_FILE_NAME => i.TEXT_FILE_NAME);
 
     manage_item.item_insert(
        PV_OLD_ITEM_ID => i.ITEM_ID
      , PV_OLD_ITEM_BARCODE => i.ITEM_BARCODE
      , PV_OLD_ITEM_TYPE => i.ITEM_TYPE
      , PV_OLD_ITEM_TITLE => i.ITEM_TITLE
      , PV_OLD_ITEM_SUBTITLE => i.ITEM_SUBTITLE
      , PV_OLD_ITEM_RATING => i.ITEM_RATING
      , PV_OLD_ITEM_RATING_AGENCY => i.ITEM_RATING_AGENCY
      , PV_OLD_ITEM_RELEASE_DATE => i.ITEM_RELEASE_DATE
      , PV_OLD_CREATED_BY => i.CREATED_BY
      , PV_OLD_CREATION_DATE => i.CREATION_DATE
      , PV_OLD_LAST_UPDATED_BY => i.LAST_UPDATED_BY
      , PV_OLD_LAST_UPDATE_DATE => i.LAST_UPDATE_DATE
      , PV_OLD_TEXT_FILE_NAME => i.TEXT_FILE_NAME
      , PV_NEW_ITEM_ID => i.ITEM_ID
      , PV_NEW_ITEM_BARCODE => i.ITEM_BARCODE
      , PV_NEW_ITEM_TYPE => i.ITEM_TYPE
      , PV_NEW_ITEM_TITLE => i.ITEM_TITLE || '-Changed'
      , PV_NEW_ITEM_SUBTITLE => i.ITEM_SUBTITLE
      , PV_NEW_ITEM_RATING => i.ITEM_RATING
      , PV_NEW_ITEM_RATING_AGENCY => i.ITEM_RATING_AGENCY
      , PV_NEW_ITEM_RELEASE_DATE => i.ITEM_RELEASE_DATE
      , PV_NEW_CREATED_BY => i.CREATED_BY
      , PV_NEW_CREATION_DATE => i.CREATION_DATE
      , PV_NEW_LAST_UPDATED_BY => i.LAST_UPDATED_BY
      , PV_NEW_LAST_UPDATE_DATE => i.LAST_UPDATE_DATE
      , PV_NEW_TEXT_FILE_NAME => i.TEXT_FILE_NAME);

     manage_item.item_insert(
        PV_OLD_ITEM_ID => i.ITEM_ID
      , PV_OLD_ITEM_BARCODE => i.ITEM_BARCODE
      , PV_OLD_ITEM_TYPE => i.ITEM_TYPE
      , PV_OLD_ITEM_TITLE => i.ITEM_TITLE || '-Deleted'
      , PV_OLD_ITEM_SUBTITLE => i.ITEM_SUBTITLE
      , PV_OLD_ITEM_RATING => i.ITEM_RATING
      , PV_OLD_ITEM_RATING_AGENCY => i.ITEM_RATING_AGENCY
      , PV_OLD_ITEM_RELEASE_DATE => i.ITEM_RELEASE_DATE
      , PV_OLD_CREATED_BY => i.CREATED_BY
      , PV_OLD_CREATION_DATE => i.CREATION_DATE
      , PV_OLD_LAST_UPDATED_BY => i.LAST_UPDATED_BY
      , PV_OLD_LAST_UPDATE_DATE => i.LAST_UPDATE_DATE
      , PV_OLD_TEXT_FILE_NAME => i.TEXT_FILE_NAME);
 
  END LOOP;
END;
/

COL logger_id       FORMAT 9999 HEADING "Logger|ID #"
COL old_item_id     FORMAT 9999 HEADING "Old|Item|ID #"
COL old_item_title  FORMAT A20  HEADING "Old Item Title"
COL new_item_id     FORMAT 9999 HEADING "New|Item|ID #"
COL new_item_title  FORMAT A30  HEADING "New Item Title"
SELECT l.logger_id
,      l.old_item_id
,      l.old_item_title
,      l.new_item_id
,      l.new_item_title
FROM   logger l;

CREATE OR REPLACE
  TRIGGER item_trig
  BEFORE INSERT OR UPDATE OF item_title ON item
  FOR EACH ROW
  DECLARE
    lv_input_title    VARCHAR2(40);
    lv_title          VARCHAR2(20);
    lv_subtitle       VARCHAR2(20);
    lv_update_needed  NUMBER;
    e EXCEPTION;
    PRAGMA EXCEPTION_INIT(e,-20001);
  BEGIN
    IF INSERTING THEN
      manage_item.item_insert(
          PV_NEW_ITEM_ID => :new.ITEM_ID
        , PV_NEW_ITEM_BARCODE => :new.ITEM_BARCODE
        , PV_NEW_ITEM_TYPE => :new.ITEM_TYPE
        , PV_NEW_ITEM_TITLE => :new.ITEM_TITLE
        , PV_NEW_ITEM_SUBTITLE => :new.ITEM_SUBTITLE
        , PV_NEW_ITEM_RATING => :new.ITEM_RATING
        , PV_NEW_ITEM_RATING_AGENCY => :new.ITEM_RATING_AGENCY
        , PV_NEW_ITEM_RELEASE_DATE => :new.ITEM_RELEASE_DATE
        , PV_NEW_CREATED_BY => :new.CREATED_BY
        , PV_NEW_CREATION_DATE => :new.CREATION_DATE
        , PV_NEW_LAST_UPDATED_BY => :new.LAST_UPDATED_BY
        , PV_NEW_LAST_UPDATE_DATE => :new.LAST_UPDATE_DATE
        , PV_NEW_TEXT_FILE_NAME => :new.TEXT_FILE_NAME );

      lv_input_title := :new.ITEM_TITLE;
      lv_update_needed := 0;
 
      IF REGEXP_INSTR(lv_input_title,':') > 0 AND
         REGEXP_INSTR(lv_input_title,':') = LENGTH(lv_input_title) THEN
        lv_title   := SUBSTR(lv_input_title, 1, REGEXP_INSTR(lv_input_title,':') - 1);
        lv_subtitle := '';
        lv_update_needed := 1;
      ELSIF REGEXP_INSTR(lv_input_title,':') > 0 THEN
        lv_title    := SUBSTR(lv_input_title, 1, REGEXP_INSTR(lv_input_title,':') - 1);
        lv_subtitle := LTRIM(SUBSTR(lv_input_title,REGEXP_INSTR(lv_input_title,':') + 1, LENGTH(lv_input_title)));
        lv_update_needed := 1;
      END IF;

      IF lv_update_needed = 1 THEN
          manage_item.item_insert(
              PV_OLD_ITEM_ID => :new.ITEM_ID
            , PV_OLD_ITEM_BARCODE => :new.ITEM_BARCODE
            , PV_OLD_ITEM_TYPE => :new.ITEM_TYPE
            , PV_OLD_ITEM_TITLE => :new.ITEM_TITLE
            , PV_OLD_ITEM_SUBTITLE => :new.ITEM_SUBTITLE
            , PV_OLD_ITEM_RATING => :new.ITEM_RATING
            , PV_OLD_ITEM_RATING_AGENCY => :new.ITEM_RATING_AGENCY
            , PV_OLD_ITEM_RELEASE_DATE => :new.ITEM_RELEASE_DATE
            , PV_OLD_CREATED_BY => :new.CREATED_BY
            , PV_OLD_CREATION_DATE => :new.CREATION_DATE
            , PV_OLD_LAST_UPDATED_BY => :new.LAST_UPDATED_BY
            , PV_OLD_LAST_UPDATE_DATE => :new.LAST_UPDATE_DATE
            , PV_OLD_TEXT_FILE_NAME => :new.TEXT_FILE_NAME
            , PV_NEW_ITEM_ID => :new.ITEM_ID
            , PV_NEW_ITEM_BARCODE => :new.ITEM_BARCODE
            , PV_NEW_ITEM_TYPE => :new.ITEM_TYPE
            , PV_NEW_ITEM_TITLE => lv_title
            , PV_NEW_ITEM_SUBTITLE => lv_subtitle
            , PV_NEW_ITEM_RATING => :new.ITEM_RATING
            , PV_NEW_ITEM_RATING_AGENCY => :new.ITEM_RATING_AGENCY
            , PV_NEW_ITEM_RELEASE_DATE => :new.ITEM_RELEASE_DATE
            , PV_NEW_CREATED_BY => :new.CREATED_BY
            , PV_NEW_CREATION_DATE => :new.CREATION_DATE
            , PV_NEW_LAST_UPDATED_BY => :new.LAST_UPDATED_BY
            , PV_NEW_LAST_UPDATE_DATE => :new.LAST_UPDATE_DATE
            , PV_NEW_TEXT_FILE_NAME => :new.TEXT_FILE_NAME );

          :new.ITEM_TITLE := lv_title;
          :new.ITEM_SUBTITLE := lv_subtitle;
      END IF;

      IF :new.item_id IS NULL THEN
        SELECT item_s1.NEXTVAL
        INTO   :new.item_id
        FROM   dual;
      END IF;
    ELSIF UPDATING THEN
      manage_item.item_insert(
          PV_OLD_ITEM_ID => :old.ITEM_ID
        , PV_OLD_ITEM_BARCODE => :old.ITEM_BARCODE
        , PV_OLD_ITEM_TYPE => :old.ITEM_TYPE
        , PV_OLD_ITEM_TITLE => :old.ITEM_TITLE
        , PV_OLD_ITEM_SUBTITLE => :old.ITEM_SUBTITLE
        , PV_OLD_ITEM_RATING => :old.ITEM_RATING
        , PV_OLD_ITEM_RATING_AGENCY => :old.ITEM_RATING_AGENCY
        , PV_OLD_ITEM_RELEASE_DATE => :old.ITEM_RELEASE_DATE
        , PV_OLD_CREATED_BY => :old.CREATED_BY
        , PV_OLD_CREATION_DATE => :old.CREATION_DATE
        , PV_OLD_LAST_UPDATED_BY => :old.LAST_UPDATED_BY
        , PV_OLD_LAST_UPDATE_DATE => :old.LAST_UPDATE_DATE
        , PV_OLD_TEXT_FILE_NAME => :old.TEXT_FILE_NAME
        , PV_NEW_ITEM_ID => :new.ITEM_ID
        , PV_NEW_ITEM_BARCODE => :new.ITEM_BARCODE
        , PV_NEW_ITEM_TYPE => :new.ITEM_TYPE
        , PV_NEW_ITEM_TITLE => :new.ITEM_TITLE
        , PV_NEW_ITEM_SUBTITLE => :new.ITEM_SUBTITLE
        , PV_NEW_ITEM_RATING => :new.ITEM_RATING
        , PV_NEW_ITEM_RATING_AGENCY => :new.ITEM_RATING_AGENCY
        , PV_NEW_ITEM_RELEASE_DATE => :new.ITEM_RELEASE_DATE
        , PV_NEW_CREATED_BY => :new.CREATED_BY
        , PV_NEW_CREATION_DATE => :new.CREATION_DATE
        , PV_NEW_LAST_UPDATED_BY => :new.LAST_UPDATED_BY
        , PV_NEW_LAST_UPDATE_DATE => :new.LAST_UPDATE_DATE
        , PV_NEW_TEXT_FILE_NAME => :new.TEXT_FILE_NAME );

      lv_input_title := :new.ITEM_TITLE;
      lv_update_needed := 0;
 
      IF REGEXP_INSTR(lv_input_title,':') > 0 AND
         REGEXP_INSTR(lv_input_title,':') = LENGTH(lv_input_title) THEN
        lv_title   := SUBSTR(lv_input_title, 1, REGEXP_INSTR(lv_input_title,':') - 1);
        lv_subtitle := '';
        lv_update_needed := 1;
      ELSIF REGEXP_INSTR(lv_input_title,':') > 0 THEN
        lv_title    := SUBSTR(lv_input_title, 1, REGEXP_INSTR(lv_input_title,':') - 1);
        lv_subtitle := LTRIM(SUBSTR(lv_input_title,REGEXP_INSTR(lv_input_title,':') + 1, LENGTH(lv_input_title)));
        lv_update_needed := 1;
      END IF;

      IF lv_update_needed = 1 THEN
          manage_item.item_insert(
              PV_OLD_ITEM_ID => :new.ITEM_ID
            , PV_OLD_ITEM_BARCODE => :new.ITEM_BARCODE
            , PV_OLD_ITEM_TYPE => :new.ITEM_TYPE
            , PV_OLD_ITEM_TITLE => :new.ITEM_TITLE
            , PV_OLD_ITEM_SUBTITLE => :new.ITEM_SUBTITLE
            , PV_OLD_ITEM_RATING => :new.ITEM_RATING
            , PV_OLD_ITEM_RATING_AGENCY => :new.ITEM_RATING_AGENCY
            , PV_OLD_ITEM_RELEASE_DATE => :new.ITEM_RELEASE_DATE
            , PV_OLD_CREATED_BY => :new.CREATED_BY
            , PV_OLD_CREATION_DATE => :new.CREATION_DATE
            , PV_OLD_LAST_UPDATED_BY => :new.LAST_UPDATED_BY
            , PV_OLD_LAST_UPDATE_DATE => :new.LAST_UPDATE_DATE
            , PV_OLD_TEXT_FILE_NAME => :new.TEXT_FILE_NAME
            , PV_NEW_ITEM_ID => :new.ITEM_ID
            , PV_NEW_ITEM_BARCODE => :new.ITEM_BARCODE
            , PV_NEW_ITEM_TYPE => :new.ITEM_TYPE
            , PV_NEW_ITEM_TITLE => lv_title
            , PV_NEW_ITEM_SUBTITLE => lv_subtitle
            , PV_NEW_ITEM_RATING => :new.ITEM_RATING
            , PV_NEW_ITEM_RATING_AGENCY => :new.ITEM_RATING_AGENCY
            , PV_NEW_ITEM_RELEASE_DATE => :new.ITEM_RELEASE_DATE
            , PV_NEW_CREATED_BY => :new.CREATED_BY
            , PV_NEW_CREATION_DATE => :new.CREATION_DATE
            , PV_NEW_LAST_UPDATED_BY => :new.LAST_UPDATED_BY
            , PV_NEW_LAST_UPDATE_DATE => :new.LAST_UPDATE_DATE
            , PV_NEW_TEXT_FILE_NAME => :new.TEXT_FILE_NAME );

          :new.ITEM_TITLE := lv_title;
          :new.ITEM_SUBTITLE := lv_subtitle;
      END IF;
    END IF;
  END item_trig;
/

CREATE OR REPLACE
  TRIGGER item_delete_trig
  BEFORE DELETE ON item
  FOR EACH ROW
  DECLARE
    e EXCEPTION;
    PRAGMA EXCEPTION_INIT(e,-20001);
  BEGIN
    IF DELETING THEN
      manage_item.item_insert(
          PV_OLD_ITEM_ID => :old.ITEM_ID
        , PV_OLD_ITEM_BARCODE => :old.ITEM_BARCODE
        , PV_OLD_ITEM_TYPE => :old.ITEM_TYPE
        , PV_OLD_ITEM_TITLE => :old.ITEM_TITLE
        , PV_OLD_ITEM_SUBTITLE => :old.ITEM_SUBTITLE
        , PV_OLD_ITEM_RATING => :old.ITEM_RATING
        , PV_OLD_ITEM_RATING_AGENCY => :old.ITEM_RATING_AGENCY
        , PV_OLD_ITEM_RELEASE_DATE => :old.ITEM_RELEASE_DATE
        , PV_OLD_CREATED_BY => :old.CREATED_BY
        , PV_OLD_CREATION_DATE => :old.CREATION_DATE
        , PV_OLD_LAST_UPDATED_BY => :old.LAST_UPDATED_BY
        , PV_OLD_LAST_UPDATE_DATE => :old.LAST_UPDATE_DATE
        , PV_OLD_TEXT_FILE_NAME => :old.TEXT_FILE_NAME );
    END IF;
  END item_delete_trig;
/

ALTER TABLE item DROP CONSTRAINT nn_item_4;

INSERT INTO item (
    ITEM_ID
  , ITEM_BARCODE
  , ITEM_TYPE
  , ITEM_TITLE
  , ITEM_SUBTITLE
  , ITEM_RATING
  , ITEM_RATING_AGENCY
  , ITEM_RELEASE_DATE
  , CREATED_BY
  , CREATION_DATE
  , LAST_UPDATED_BY
  , LAST_UPDATE_DATE)
VALUES (
    ITEM_S1.NEXTVAL
  , 'B01IHVPA8'
  , (SELECT common_lookup_id FROM common_lookup WHERE common_lookup_table = 'ITEM' AND common_lookup_column = 'ITEM_TYPE' AND common_lookup_type = 'BLU-RAY')
  , 'Bourne'
  , ''
  , 'PG-13'
  , 'MPAA'
  , TO_DATE('6-Dec-16')
  , 3
  , SYSDATE
  , 3
  , SYSDATE);

INSERT INTO item (
    ITEM_ID
  , ITEM_BARCODE
  , ITEM_TYPE
  , ITEM_TITLE
  , ITEM_SUBTITLE
  , ITEM_RATING
  , ITEM_RATING_AGENCY
  , ITEM_RELEASE_DATE
  , CREATED_BY
  , CREATION_DATE
  , LAST_UPDATED_BY
  , LAST_UPDATE_DATE)
VALUES (
    ITEM_S1.NEXTVAL
  , 'B01AT251XY'
  , (SELECT common_lookup_id FROM common_lookup WHERE common_lookup_table = 'ITEM' AND common_lookup_column = 'ITEM_TYPE' AND common_lookup_type = 'BLU-RAY')
  , 'Bourne Legacy:'
  , ''
  , 'PG-13'
  , 'MPAA'
  , TO_DATE('5-Apr-16')
  , 3
  , SYSDATE
  , 3
  , SYSDATE);

INSERT INTO item (
    ITEM_ID
  , ITEM_BARCODE
  , ITEM_TYPE
  , ITEM_TITLE
  , ITEM_SUBTITLE
  , ITEM_RATING
  , ITEM_RATING_AGENCY
  , ITEM_RELEASE_DATE
  , CREATED_BY
  , CREATION_DATE
  , LAST_UPDATED_BY
  , LAST_UPDATE_DATE)
VALUES (
    ITEM_S1.NEXTVAL
  , 'B018FK66TU'
  , (SELECT common_lookup_id FROM common_lookup WHERE common_lookup_table = 'ITEM' AND common_lookup_column = 'ITEM_TYPE' AND common_lookup_type = 'BLU-RAY')
  , 'Star Wars: The Force Awakens'
  , ''
  , 'PG-13'
  , 'MPAA'
  , TO_DATE('5-Apr-16')
  , 3
  , SYSDATE
  , 3
  , SYSDATE);

COL item_id        FORMAT 9999 HEADING "Item|ID #"
COL item_title     FORMAT A20  HEADING "Item Title"
COL item_subtitle  FORMAT A20  HEADING "Item Subtitle"
COL item_rating    FORMAT A6   HEADING "Item|Rating"
COL item_type      FORMAT A18   HEADING "Item|Type"
SELECT i.item_id
,      i.item_title
,      i.item_subtitle
,      i.item_rating
,      cl.common_lookup_meaning AS item_type
FROM   item i INNER JOIN common_lookup cl
ON     i.item_type = cl.common_lookup_id
WHERE  cl.common_lookup_type = 'BLU-RAY';

COL logger_id       FORMAT 9999 HEADING "Logger|ID #"
COL old_item_id     FORMAT 9999 HEADING "Old|Item|ID #"
COL old_item_title  FORMAT A20  HEADING "Old Item Title"
COL new_item_id     FORMAT 9999 HEADING "New|Item|ID #"
COL new_item_title  FORMAT A30  HEADING "New Item Title"
SELECT l.logger_id
,      l.old_item_id
,      l.old_item_title
,      l.new_item_id
,      l.new_item_title
FROM   logger l;

UPDATE item SET item_title = 'Star Wars: The Force Awakens' WHERE ITEM_BARCODE = 'B018FK66TU';

COL item_id        FORMAT 9999 HEADING "Item|ID #"
COL item_title     FORMAT A20  HEADING "Item Title"
COL item_subtitle  FORMAT A20  HEADING "Item Subtitle"
COL item_rating    FORMAT A6   HEADING "Item|Rating"
COL item_type      FORMAT A18   HEADING "Item|Type"
SELECT i.item_id
,      i.item_title
,      i.item_subtitle
,      i.item_rating
,      cl.common_lookup_meaning AS item_type
FROM   item i INNER JOIN common_lookup cl
ON     i.item_type = cl.common_lookup_id
WHERE  cl.common_lookup_type = 'BLU-RAY';

COL logger_id       FORMAT 9999 HEADING "Logger|ID #"
COL old_item_id     FORMAT 9999 HEADING "Old|Item|ID #"
COL old_item_title  FORMAT A20  HEADING "Old Item Title"
COL new_item_id     FORMAT 9999 HEADING "New|Item|ID #"
COL new_item_title  FORMAT A30  HEADING "New Item Title"
SELECT l.logger_id
,      l.old_item_id
,      l.old_item_title
,      l.new_item_id
,      l.new_item_title
FROM   logger l;

DELETE FROM item WHERE ITEM_BARCODE = 'B018FK66TU';

COL item_id        FORMAT 9999 HEADING "Item|ID #"
COL item_title     FORMAT A20  HEADING "Item Title"
COL item_subtitle  FORMAT A20  HEADING "Item Subtitle"
COL item_rating    FORMAT A6   HEADING "Item|Rating"
COL item_type      FORMAT A18   HEADING "Item|Type"
SELECT i.item_id
,      i.item_title
,      i.item_subtitle
,      i.item_rating
,      cl.common_lookup_meaning AS item_type
FROM   item i INNER JOIN common_lookup cl
ON     i.item_type = cl.common_lookup_id
WHERE  cl.common_lookup_type = 'BLU-RAY';

COL logger_id       FORMAT 9999 HEADING "Logger|ID #"
COL old_item_id     FORMAT 9999 HEADING "Old|Item|ID #"
COL old_item_title  FORMAT A20  HEADING "Old Item Title"
COL new_item_id     FORMAT 9999 HEADING "New|Item|ID #"
COL new_item_title  FORMAT A30  HEADING "New Item Title"
SELECT l.logger_id
,      l.old_item_id
,      l.old_item_title
,      l.new_item_id
,      l.new_item_title
FROM   logger l;

-- Close log file.
SPOOL OFF
SHOW ERRORS
