/*
||  Name:          apply_plsql_lab4.sql
||  Date:          11 Nov 2016
||  Purpose:       Complete 325 Chapter 5 lab.
*/

-- Call seeding libraries.
--@$LIB/cleanup_oracle.sql
--@$LIB/Oracle12cPLSQLCode/Introduction/create_video_store.sql

-- Open log file.
SPOOL apply_plsql_lab4.txt

-- Enter your solution here.

SET SERVEROUTPUT ON
SET VERIFY OFF;

CREATE OR REPLACE TYPE gift IS OBJECT
  ( amount VARCHAR2(8)
  , gift_description VARCHAR2(24));
/

DECLARE
  TYPE day IS TABLE OF VARCHAR2(8);
  day_name DAY := day('first', 'second', 'third', 'fourth', 'fifth', 'sixth', 'seventh', 'eighth', 'ninth', 'tenth', 'eleventh', 'twelfth');
  
  TYPE gift_type IS TABLE OF gift;
  
  gift_name GIFT_TYPE := gift_type(
      gift('and a', 'Partridge in a pear tree')
    , gift('Two', 'Turtle doves')
    , gift('Three', 'French hens')
    , gift('Four', 'Calling birds')
    , gift('Five', 'Golden rings')
    , gift('Six', 'Geese a laying')
    , gift('Seven', 'Swans a swimming')
    , gift('Eight', 'Maids a milking')
    , gift('Nine', 'Ladies dancing')
    , gift('Ten', 'Lords a leaping')
    , gift('Eleven', 'Pipers piping')
    , gift('Twelve', 'Drummers drumming'));

BEGIN
    FOR i IN 1..day_name.COUNT LOOP
        dbms_output.put_line('On the ' || day_name(i) || ' day of Christmas');
        dbms_output.put_line('my true love sent to me:');

        FOR j IN REVERSE 1..i LOOP
            IF j = 1 AND i = 1 THEN 
                dbms_output.put_line('-' || 'A' || ' ' || gift_name(j).gift_description);
            ELSE
                dbms_output.put_line('-' || gift_name(j).amount || ' ' || gift_name(j).gift_description);
            END IF;
        END LOOP;

        dbms_output.put_line(CHR(13));

    END LOOP;


EXCEPTION
  WHEN others THEN
    dbms_output.put_line('Error!: ' || SQLERRM);

END;
/

-- Close log file.
SPOOL OFF
--QUIT;