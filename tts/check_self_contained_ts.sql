EXECUTE DBMS_TTS.TRANSPORT_SET_CHECK('sales_1,sales_2', TRUE);
SELECT * FROM TRANSPORT_SET_VIOLATIONS;
