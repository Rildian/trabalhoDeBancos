-- inserindos valores
-- execute os dois abaixo (1a inserção)
CALL create_cargo('Estagiário');
CALL create_cargo('Trainee');


-- departamentos
CALL create_departamento('TI');
CALL create_departamento('Recursos Humanos');
CALL create_departamento('Financeiro');
CALL create_departamento('Marketing');
CALL create_departamento('Vendas');
CALL create_departamento('Operações');

-- funcionários
CALL create_funcionario('Mark Zuck', 1, 'zuzu@facebook.com', '123.456.789-09', 7, 3000.00);
CALL create_funcionario('Maria Oliveira', 1, 'maria.oliveira@empresa.com', '987.654.321-00', 3, 4000.00);
CALL create_funcionario('Pedro Costa', 3, 'pedro.costa@empresa.com', '456.789.123-45', 11, 3500.00);
CALL create_funcionario('Ana Souza', 4, 'ana.souza@empresa.com', '321.654.987-00', 15, 2800.00);
CALL create_funcionario('Carlos Rocha', 5, 'carlos.rocha@empresa.com', '654.321.987-12', 19, 4200.00);

-- Inserir Benefícios
CALL create_beneficios('Auxílio psicológico', 500.00, 1);   -- ti
CALL create_beneficios('Plano de Saúde', 800.00, 2);  -- rh
CALL create_beneficios('Auxílio Home Office', 300.00, 1); -- ti
CALL create_beneficios('Vale Transporte', 250.00, 3); -- financeiro


CALL create_folha_pagamento(1, '2024-05-05', 3000 + 500 + 300);  -- joão 
CALL create_folha_pagamento(2, '2024-05-05', 4000 + 800);        -- maria 
CALL create_folha_pagamento(3, '2024-05-05', 3500 + 250);        -- pedro 

-- treinamentos
CALL create_treinamento('Introdução ao Java', '2024-05-10', 8, 1);
CALL create_treinamento('Python para analise de dados', '2024-05-10', 10, 9);
CALL create_treinamento('Gestão de Pessoas', '2024-05-12', 6, 2);
CALL create_treinamento('Excel Avançado', '2024-05-15', 4, 3);

-- candidatos
CALL create_candidatos('Fernanda Lima', 'fernanda.lima@email.com', 8, '2024-05-01');
CALL create_candidatos('Ricardo Alves', 'ricardo.alves@email.com', 12, '2024-05-02');
CALL create_candidatos('Juliana Martins', 'juliana.martins@email.com', 16, '2024-05-03');

-- cargos

CALL create_cargo('Desenvolvedor Júnior');
CALL create_cargo('Desenvolvedor Pleno');
CALL create_cargo('Desenvolvedor Sênior');
CALL create_cargo('Analista de Recursos Humanos Júnior');
CALL create_cargo('Analista de Recursos Humanos Pleno');
CALL create_cargo('Analista de Recursos Humanos Sênior');
CALL create_cargo('Gerente de Recursos Humanos');
CALL create_cargo('Arquiteto de Software');
CALL create_cargo('Gerente de TI');
CALL create_cargo('Analista Financeiro Júnior');
CALL create_cargo('Analista Financeiro Pleno');
CALL create_cargo('Analista Financeiro Sênior');
CALL create_cargo('Gerente Financeiro');
CALL create_cargo('Analista de Marketing Júnior');
CALL create_cargo('Analista de Marketing Pleno');
CALL create_cargo('Analista de Marketing Sênior');
CALL create_cargo('Gerente de Marketing');
CALL create_cargo('Representante de Vendas Júnior');
CALL create_cargo('Representante de Vendas Pleno');
CALL create_cargo('Representante de Vendas Sênior');
CALL create_cargo('Gerente de Vendas');
CALL create_cargo('Analista de Operações Júnior');
CALL create_cargo('Analista de Operações Pleno');
CALL create_cargo('Analista de Operações Sênior');
CALL create_cargo('Coordenador de Operações');




CALL create_funcionario(); -- nome, id dep, email, cpf, id cargo, salario

CALL create_departamento('TI');
CALL create_cargo('Estagiário');
CALL create_cargo('Trainee');
CALL create_cargo('Desenvolvedor Júnior');

CALL create_funcionario('Pitágoras Martins', 1, 'pitagoras@ufc.com', '123.456.789-12', 3, 2000); -- id 7
CALL buscar_funcionario(7);
CALL promover_funcionario(7, 3, 5, 2000, 10000);
CALL buscar_funcionario(7);






CALL promover_funcionario(6, 1, 3, 2000, 4500);




CALL create_beneficios(); --
CALL create_departamento(); --
CALL create_folha_pagamento(); --
CALL create_treinamento(); --
CALL mudar_departamento(); --
CALL promover_funcionario(); --
CALL remove_cargo(); --
CALL remove_funcionarios(); --



