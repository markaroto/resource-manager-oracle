# resource-manager-oracle
Basic plan creation
Comandos importante para utilização

select * from v$rsrcmgrmetric_history;

select username,sid,SERIAL#,process, resource_consumer_group,current_queue_duration from v$session ORDER BY RESOURCE_CONSUMER_GROUP;
select * from dba_rsrc_consumer_group_privs;

select * from V$rsrc_consumer_group;

select osuser,process,schemaname,current_queue_duration from v$session;

alter system set resource_manager_plan=plan_test scope=both;

show parameter resou

exec DBMS_RESOURCE_MANAGER.SWITCH_CONSUMER_GROUP_FOR_SESS (44,5421,'DBA');
