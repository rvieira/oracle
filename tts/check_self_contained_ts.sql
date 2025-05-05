/* 
This script checks the self-contained transport set for the tables sales_1 and sales_2.
*/
EXECUTE DBMS_TTS.TRANSPORT_SET_CHECK('sales_1,sales_2', TRUE);
SELECT * FROM TRANSPORT_SET_VIOLATIONS;
