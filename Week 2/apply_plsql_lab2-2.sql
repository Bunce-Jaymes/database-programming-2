/*
||  Name:          apply_plsql_lab2-2.sql
||  Date:          11 Nov 2016
||  Purpose:       Complete 325 Chapter 3 lab.
*/

-- Call seeding libraries.
--@/home/student/Data/cit325/lib/cleanup_oracle.sql
--@/home/student/Data/cit325/lib/Oracle12cPLSQLCode/Introduction/create_video_store.sql

-- Open log file.
-- SPOOL apply_plsql_lab2-2.txt

-- Enter your solution here.
SET SERVEROUTPUT ON SIZE UNLIMITED
SET VERIFY OFF

DECLARE
    lv_raw_input varchar2(50);
    lv_input varchar2(10);
BEGIN
    lv_raw_input := '&1';
    
    IF lv_raw_input IS NULL THEN
        lv_input := 'World';
    ELSIF LENGTH(lv_raw_input) <= 10 THEN
        lv_input := lv_raw_input;
    ELSE
        lv_input := SUBSTR(lv_raw_input, 1, 10);
    END IF;
    dbms_output.put_line('Hello '||lv_input||'!');
EXCEPTION
    WHEN others THEN
        dbms_output.put_line('An error occurred while running the code.');
        dbms_output.put_line(SQLERRM);
END;
/
-- Close log file.
-- SPOOL OFF
QUIT;
