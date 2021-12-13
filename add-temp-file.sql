-- -----------------------------------------------------------------------------------
-- File Name    : add-temp-file.sql
-- Author       : Ricardo Augusto Ripoll Vieira
-- Description  : Adds a temp data file to the temp tablespace (assumed ASM)
-- Requirements : DBA role
-- Last Modified: 11-MAR-2021
-- -----------------------------------------------------------------------------------
alter tablespace temp add tempfile;
