set appinfo 'install payment api package'
set serveroutput on

-- при возникновении ошибки выходим
whenever sqlerror exit failure
-- записываем в лог файл результаты наката
spool out.log append

-- считываем версию патча
prompt ====================================================================================================
@services/title.sql
prompt ====================================================================================================

prompt >>>> tables/tables.sql
prompt 
@@tables/tables.sql


prompt >>>> others/before.sql
prompt 
@@others/before.sql


prompt >>>> packages/packages.sql
prompt 
@@packages/packages.sql


prompt >>>> triggers/triggers.sql
prompt 
@@triggers/triggers.sql

spool off

exit;
