DECLARE 
val NUMBER;
BEGIN
FOR I IN (SELECT TABLE_NAME FROM USER_TABLES) LOOP
EXECUTE IMMEDIATE 'SELECT count(*) FROM ' || i.table_name INTO val;
DBMS_OUTPUT.PUT_LINE(i.table_name || ' ==> ' || val );
END LOOP;
END;
/