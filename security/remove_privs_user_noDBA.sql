SET SERVEROUTPUT ON
BEGIN
    FOR priv_rec IN (
        SELECT privilege
        FROM all_tab_privs
        WHERE grantee = 'SCHEMA_RO'
        UNION
        SELECT privilege
        FROM user_sys_privs
        WHERE privilege != 'CREATE SESSION'
        UNION
        SELECT granted_role AS privilege
        FROM user_role_privs
    )
    LOOP
        -- Generate REVOKE statements
        DBMS_OUTPUT.PUT_LINE('REVOKE ' || priv_rec.privilege || ' FROM SCHEMA_RO;');
    END LOOP;
END;
/