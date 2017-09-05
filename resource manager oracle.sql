--Criação de plano de resource manager oracle
	
--Criação dos grupos sera utilizado.
BEGIN
	DBMS_RESOURCE_MANAGER.CLEAR_PENDING_AREA;
	DBMS_RESOURCE_MANAGER.CREATE_PENDING_AREA;
	
	DBMS_RESOURCE_MANAGER.CREATE_CONSUMER_GROUP(
		consumer_group => 'GR_APP',comment => 'GR_APP'
	);
	DBMS_RESOURCE_MANAGER.CREATE_CONSUMER_GROUP(
		consumer_group => 'GR_ADM',comment => 'GR_ADM'
	);	
	DBMS_RESOURCE_MANAGER.VALIDATE_PENDING_AREA();
	DBMS_RESOURCE_MANAGER.SUBMIT_PENDING_AREA();
END;
/

--Criação do plano e configuração do grupo
BEGIN
	DBMS_RESOURCE_MANAGER.CLEAR_PENDING_AREA;
	DBMS_RESOURCE_MANAGER.CREATE_PENDING_AREA;
	--Criação do plano.
	DBMS_RESOURCE_MANAGER.CREATE_PLAN(PLAN => 'plan_test', 
	COMMENT => 'Resource');
	--Definido o perfil do grupo para plano.
	DBMS_RESOURCE_MANAGER.CREATE_PLAN_DIRECTIVE(PLAN => 'plan_test',
		GROUP_OR_SUBPLAN => 'GR_ADM',
		COMMENT => 'GR_ADM', 
		--Quantidade cpu reservada.
		MGMT_P1 => 80);
	--Definido o perfil do grupo para plano.
	DBMS_RESOURCE_MANAGER.CREATE_PLAN_DIRECTIVE(PLAN => 'plan_test',
		GROUP_OR_SUBPLAN => 'GR_APP',
		COMMENT => 'GR_APP', MGMT_P2 => 80,
		--Configuração de trocar de grupo quando chegar 10 segundos execução.
		switch_group => 'OTHER_GROUPS',
     	switch_time => 10);
	--Grupo obrigatorio.
	DBMS_RESOURCE_MANAGER.CREATE_PLAN_DIRECTIVE(PLAN => 'plan_test',
		GROUP_OR_SUBPLAN => 'OTHER_GROUPS',
		COMMENT => 'OTHER_GROUPS',MGMT_P2 => 20);
	DBMS_RESOURCE_MANAGER.VALIDATE_PENDING_AREA();
	DBMS_RESOURCE_MANAGER.SUBMIT_PENDING_AREA();
END;
/

--Colocando usuarios no grupo
BEGIN
	SYS.DBMS_RESOURCE_MANAGER.clear_pending_area();
	SYS.DBMS_RESOURCE_MANAGER.create_pending_area();
	--GR_ADM
	SYS.DBMS_RESOURCE_MANAGER_PRIVS.GRANT_SWITCH_CONSUMER_GROUP ( 'OLAPSYS','GR_ADM',false);
	-- podemos utilizar o script para geração automatica.
	/*
	select 'SYS.DBMS_RESOURCE_MANAGER_PRIVS.GRANT_SWITCH_CONSUMER_GROUP ( '||chr(39) || USERNAME  || chr(39) ||','||chr(39)||'GR_ADM'||chr(39)||',false);' from dba_users where DEFAULT_TABLESPACE like '%SYS%' or DEFAULT_TABLESPACE like '%ORA%';
	*/
	SYS.DBMS_RESOURCE_MANAGER.submit_pending_area();
END;
/
--Configurando como grupo principal.
BEGIN
	--user GR_ADM
	SYS.DBMS_RESOURCE_MANAGER.SET_INITIAL_CONSUMER_GROUP ('OLAPSYS','GR_ADM');
	-- podemos utilizar o script para geração automatica.
	/*
	select 'SYS.DBMS_RESOURCE_MANAGER.SET_INITIAL_CONSUMER_GROUP ('||chr(39) || USERNAME  || chr(39) ||','||chr(39)||'GR_ADM'||chr(39)||');' from dba_users where DEFAULT_TABLESPACE like 'SYS%' or DEFAULT_TABLESPACE like 'ORA%';
	*/
	END;
/

	