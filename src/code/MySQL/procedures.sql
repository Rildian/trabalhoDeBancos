DELIMITER //

CREATE PROCEDURE create_departamento (
	IN p_nome_departamento VARCHAR(250)
	)
BEGIN
	INSERT INTO departamento (nome_departamento) VALUES (p_nome_departamento);
END //
    
DELIMITER ;

DELIMITER // 

CREATE PROCEDURE create_cargo (
	IN p_nome_cargo VARCHAR(250)
    )
BEGIN
	INSERT INTO cargo (nome_cargo) VALUES (p_nome_cargo);
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE create_funcionario (
    IN p_nome VARCHAR(250),
    IN p_id_departamento INT,
    IN p_email VARCHAR(250),
    IN p_CPF VARCHAR(14),
    IN p_id_cargo INT,
    IN p_salario DECIMAL(10,2)
)
BEGIN
    INSERT INTO funcionario (nome, id_departamento, email, CPF, id_cargo, salario)
    VALUES (p_nome, p_id_departamento, p_email, p_CPF, p_id_cargo, p_salario);
END //

DELIMITER //

CREATE PROCEDURE create_folha_pagamento (
    IN p_id_funcionario INT,
    IN p_data_pagamento DATE,
    IN p_salario_liquido DECIMAL(10,2)
)
BEGIN
    INSERT INTO folha_pagamento (id_funcionario, data_pagamento, salario_liquido)
    VALUES (p_id_funcionario, p_data_pagamento, p_salario_liquido);
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE create_beneficios (
    IN p_tipo_beneficio VARCHAR(250),
    IN p_valor DECIMAL(10,2),
    IN p_id_departamento INT
)
BEGIN
    INSERT INTO beneficios (tipo_beneficio, valor, id_departamento)
    VALUES (p_tipo_beneficio, p_valor, p_id_departamento);
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE create_treinamento (
    IN p_nome_treinamento VARCHAR(250),
    IN p_data_treinamento DATE,
    IN p_carga_horaria INT,
    IN p_id_funcionario INT
)
BEGIN
    INSERT INTO treinamento (nome_treinamento, data_treinamento, carga_horaria, id_funcionario)
    VALUES (p_nome_treinamento, p_data_treinamento, p_carga_horaria, p_id_funcionario);
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE create_candidatos (
    IN p_nome VARCHAR(250),
    IN p_email VARCHAR(250),
    IN p_id_cargo_pretendido INT,
    IN p_data_aplicacao DATE
)
BEGIN
    INSERT INTO candidatos (nome, email, id_cargo_pretendido, data_aplicacao)
    VALUES (p_nome, p_email, p_id_cargo_pretendido, p_data_aplicacao);
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE remove_funcionarios (
	IN p_id_funcionario INT)
    
     IF NOT EXISTS (SELECT 1 FROM funcionario WHERE p_id_funcionario = id_funcionario) THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Funcionário não encontrao';
    END IF;
)
BEGIN
	DELETE FROM
		funcionarios
	WHERE 
		(p_id_funcionario = id_funcionario);
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE remove_departamento (
    IN p_id_departamento INT
)
BEGIN
    IF NOT EXISTS (SELECT * FROM departamento WHERE id_departamento = p_id_departamento) THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Departamento não encontrado';
    END IF;

    DELETE FROM departamento
    WHERE id_departamento = p_id_departamento;
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE remove_cargo (
    IN p_id_cargo INT
)
BEGIN

    IF NOT EXISTS (SELECT 1 FROM cargo WHERE id_cargo = p_id_cargo) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cargo não encontrado';
    END IF;

    DELETE FROM cargo
    WHERE id_cargo = p_id_cargo;
END //

DELIMITER ;

DELIMITER //  

CREATE PROCEDURE promover_funcionario(
    IN p_id_funcionario INT,
    IN p_id_cargo_atual INT,
    IN p_id_novo_cargo INT,
    IN p_salario_atual DECIMAL(10,2),
    IN p_novo_salario DECIMAL(10,2)
)
BEGIN

    IF NOT EXISTS (SELECT id_funcionario FROM funcionario WHERE id_funcionario = p_id_funcionario) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Funcionário não existe';
    END IF;

    IF (p_id_cargo_atual = p_id_novo_cargo) THEN 
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Promoção na mesma posição não é permitida.';
    END IF;

    IF (p_id_novo_cargo = 1 OR p_id_novo_cargo = 2) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Promoção inválida para este cargo.';
    END IF;

    IF (p_novo_salario <= p_salario_atual OR p_novo_salario <= 0) THEN 
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Salário inválido. Deve ser maior que o atual e positivo.';
    END IF;

    UPDATE funcionario
    SET 
        id_cargo = p_id_novo_cargo,
        salario = p_novo_salario  
    WHERE 
        id_funcionario = p_id_funcionario;

END //
DELIMITER ;

DELIMITER //

DELIMITER //

CREATE PROCEDURE mudar_departamento(
    IN p_id_funcionario INT,
    IN p_id_departamento INT,
    IN p_id_novo_departamento INT
)
BEGIN

    IF NOT EXISTS (SELECT id_funcionario FROM funcionario WHERE id_funcionario = p_id_funcionario) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Funcionário não encontrado';
    END IF;

    IF p_id_departamento = p_id_novo_departamento THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'O novo departamento não pode ser igual ao departamento atual';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM departamento WHERE id_departamento = p_id_novo_departamento) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Novo departamento não encontrado';
    END IF;

    UPDATE funcionario
    SET id_departamento = p_id_novo_departamento
    WHERE id_funcionario = p_id_funcionario;
END //

DELIMITER ;

-- falta a procedure abaixo, procedure de folha de pagamento, colocar beneficios (tabela) e fazer mais inserções
DELIMITER // 

CREATE PROCEDURE relatorio_departamentos()
BEGIN
    SELECT 
        d.id_departamento,
        d.nome_departamento,
        COUNT(f.id_funcionario) AS total_funcionarios,
        SUM(f.salario) AS custo_total_salarios,
        AVG(f.salario) AS media_salarial,
        COUNT(DISTINCT t.id_treinamento) AS total_treinamentos
    FROM departamento d
    LEFT JOIN funcionario f ON d.id_departamento = f.id_departamento
    LEFT JOIN treinamento t ON f.id_funcionario = t.id_funcionario
    LEFT JOIN cargo cg ON f.id_cargo = cg.id_cargo
    GROUP BY d.id_departamento
    ORDER BY d.nome_departamento;

END //

DELIMITER ;


DELIMITER //
CREATE PROCEDURE buscar_funcionario(
    IN p_id_funcionario INT
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM funcionario WHERE id_funcionario = p_id_funcionario) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Funcionário não encontrado';
    END IF;

    SELECT * FROM funcionario 
    WHERE id_funcionario = p_id_funcionario;
END //
DELIMITER ;


DELIMITER //
CREATE PROCEDURE todos_cargos()
BEGIN
    SELECT * FROM cargo 
    ORDER BY nome_cargo;
END //
DELIMITER ;


DELIMITER //
CREATE PROCEDURE buscar_cargo(
    IN p_id_cargo INT
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM cargo WHERE id_cargo = p_id_cargo) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cargo não encontrado';
    END IF;

    SELECT * FROM cargo 
    WHERE id_cargo = p_id_cargo;
END //
DELIMITER ;


DELIMITER //
CREATE PROCEDURE todos_funcionarios()
BEGIN
    SELECT 
        f.*,
        d.nome_departamento,
        c.nome_cargo
    FROM funcionario f
    INNER JOIN departamento d ON f.id_departamento = d.id_departamento
    INNER JOIN cargo c ON f.id_cargo = c.id_cargo
    ORDER BY f.nome;
END //
DELIMITER ;


DELIMITER //
CREATE PROCEDURE funcionarios_por_departamento(
    IN p_id_departamento INT
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM departamento WHERE id_departamento = p_id_departamento) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Departamento não encontrado';
    END IF;

    SELECT 
        f.*,
        d.nome_departamento,
        c.nome_cargo
    FROM funcionario f
    INNER JOIN departamento d ON f.id_departamento = d.id_departamento
    INNER JOIN cargo c ON f.id_cargo = c.id_cargo
    WHERE f.id_departamento = p_id_departamento
    ORDER BY f.nome;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE beneficios_departamento(
    IN p_id_departamento INT
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM departamento WHERE id_departamento = p_id_departamento) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Departamento não encontrado';
    END IF;

    SELECT * FROM beneficios 
    WHERE id_departamento = p_id_departamento
    ORDER BY tipo_beneficio;
END //
DELIMITER ;
