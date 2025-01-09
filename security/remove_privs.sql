BEGIN
    FOR rec IN (SELECT grantee, privilege 
                FROM dba_tab_privs 
                WHERE grantee = 'READ_ONLY_SCHEMA') LOOP
        EXECUTE IMMEDIATE 'REVOKE ' || rec.privilege || ' FROM ' || rec.grantee;
    END LOOP;
END;
/