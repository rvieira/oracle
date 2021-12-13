-- -----------------------------------------------------------------------------------
-- File Name    : add-data-file.sql
-- Author       : Ricardo Augusto Ripoll Vieira
-- Description  : Adds a data file to the tablespace (assumed ASM)
-- Requirements : DBA role
-- Last Modified: 11-MAR-2021
-- -----------------------------------------------------------------------------------
alter tablespace &ts add datafile size 30G;
