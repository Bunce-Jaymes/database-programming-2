/*
||  Name:          apply_plsql_lab4.sql
||  Date:          11 Nov 2016
||  Purpose:       Complete 325 Chapter 5 lab.
*/

-- Call seeding libraries.
@/home/student/Data/cit325/lib/cleanup_oracle.sql
@/home/student/Data/cit325/lib/Oracle12cPLSQLCode/Introduction/create_video_store.sql

-- Open log file.
SPOOL apply_plsql_lab5.txt

-- Enter your solution here.

CREATE SEQUENCE rating_agency_s START WITH 1001;

CREATE TABLE rating_agency AS
    SELECT rating_agency_s.NEXTVAL AS rating_agency_id
    ,      il.item_rating AS rating
    ,      il.item_rating_agency AS rating_agency
    FROM  (SELECT DISTINCT
          i.item_rating
        , i.item_rating_agency
        FROM   item i) il;
       
SELECT * FROM rating_agency;

ALTER TABLE item ADD (rating_agency_id NUMBER);

SET NULL ''
COLUMN table_name   FORMAT A18
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

DROP TYPE rating_object;

CREATE OR REPLACE
    TYPE rating_object IS OBJECT
    (rating_agency_id   number 
    ,rating             VARCHAR2(5)
    ,rating_agency      VARCHAR2(4));
/

CREATE OR REPLACE TYPE rating_table IS TABLE OF rating_object;
/

DECLARE
    CURSOR rating_cursor IS SELECT * FROM rating_agency;

    lv_rating_collection rating_table:= rating_table();

BEGIN
    FOR rating_element IN rating_cursor LOOP
        lv_rating_collection.EXTEND;
        lv_rating_collection(lv_rating_collection.LAST) := rating_object(rating_element.rating_agency_id, rating_element.rating, rating_element.rating_agency);
    END LOOP;

    FOR i IN 1..lv_rating_collection.LAST LOOP
        UPDATE item SET rating_agency_id = lv_rating_collection(i).rating_agency_id
            WHERE item_rating = lv_rating_collection(i).rating
            AND item_rating_agency = lv_rating_collection(i).rating_agency;
    END LOOP; 

EXCEPTION
  WHEN others THEN
    dbms_output.put_line('Error!: ' || SQLERRM);
END;
/

SELECT   rating_agency_id
,        COUNT(*)
FROM     item
WHERE    rating_agency_id IS NOT NULL
GROUP BY rating_agency_id
ORDER BY 1;

-- Close log file.
SPOOL OFF

