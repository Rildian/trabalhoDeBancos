-- criações

CALL create_departamento(p_nome_departamento); 
CALL create_cargo(p_nome_cargo); 
CALL create_funcionario(p_nome, p_id_departamento, p_email, p_CPF, p_id_cargo, p_salario);
CALL create_folha_pagamento(p_id_funcionario, p_data_pagamento, p_salario_liquido); 
CALL create_beneficios(p_tipo_beneficio, p_valor, p_id_departamento); 
CALL create_treinamento(p_nome_treinamento, p_data_treinamento, p_carga_horaria, p_id_funcionario); 
CALL create_candidatos(p_nome, p_email, p_id_cargo_pretendido, p_data_aplicacao); 

-- remoções

CALL remove_funcionarios(p_id_funcionario); 
CALL remove_departamento(p_id_departamento); 
CALL remove_cargo(p_id_cargo); 

-- updates

CALL promover_funcionario(p_id_funcionario, p_id_cargo_atual, p_id_novo_cargo, p_salario_atual, p_novo_salario); 
CALL mudar_departamento(p_id_funcionario, p_id_departamento, p_id_novo_departamento); 

-- consultas
CALL relatorio_departamentos(); 
CALL buscar_funcionario(p_id_funcionario); 
CALL todos_cargos(); 
CALL buscar_cargo(p_id_cargo); 
CALL todos_funcionarios(); 
CALL funcionarios_por_departamento(p_id_departamento); 
CALL beneficios_departamento(p_id_departamento); 

