#!/bin/bash

echo "Connecting to CDB and retrieving list of open PDBs..."

sqlplus -s / as sysdba <<EOF > pdb_list.tmp
SET HEADING OFF
SET FEEDBACK OFF
SET PAGESIZE 0
SELECT name FROM v\$pdbs WHERE open_mode = 'READ WRITE';
EXIT
EOF

echo "Found PDBs:"
cat pdb_list.tmp

while read pdb; do
  echo "Connecting to PDB: $pdb"
  sqlplus -s / as sysdba <<EOF
  ALTER SESSION SET CONTAINER=$pdb;
  SHOW CON_NAME;
  -- Place your SQL commands below this line if needed
  EXIT;
EOF
done < pdb_list.tmp

rm -f pdb_list.tmp