SET SERVEROUTPUT ON
BEGIN
    FOR priv_rec IN (
        SELECT privilege
        FROM dba_tab_privs
        WHERE grantee = 'SCHEMA_RO'
        UNION
        SELECT privilege
        FROM dba_sys_privs
        WHERE grantee = 'SCHEMA_RO' AND privilege != 'CREATE SESSION'
        UNION
        SELECT role AS privilege
        FROM dba_role_privs
        WHERE grantee = 'SCHEMA_RO'
    )
    LOOP
        -- Generate REVOKE statements
        DBMS_OUTPUT.PUT_LINE('REVOKE ' || priv_rec.privilege || ' FROM SCHEMA_RO;');
    END LOOP;
END;
/