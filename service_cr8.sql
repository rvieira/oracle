BEGIN
  DBMS_SERVICE.create_service(
    service_name => 'my_new_service',
    network_name => 'my_new_service'
  );
END;
/