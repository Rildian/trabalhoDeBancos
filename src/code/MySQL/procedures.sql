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
	IN p_nome_cargo VARCHAR(250), IN p_salario_base DECIMAL(10,2)
    )
BEGIN
	INSERT INTO cargo (nome_cargo, salario_base) VALUES (p_nome_cargo, p_salario_base);
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE create_funcionario (
    IN p_nome VARCHAR(250),
    IN p_id_departamento INT,
    IN p_email VARCHAR(250),
    IN p_CPF VARCHAR(14),
    IN p_id_cargo INT,
    IN p_data_contratacao DATE,
    IN p_salario DECIMAL(10,2)
)
BEGIN
    INSERT INTO funcionario (nome, id_departamento, email, CPF, id_cargo, data_contratacao, salario)
    VALUES (p_nome, p_id_departamento, p_email, p_CPF, p_id_cargo, p_data_contratacao, p_salario);
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
    IN p_id_funcionario INT
)
BEGIN
    INSERT INTO beneficios (tipo_beneficio, valor, id_funcionario)
    VALUES (p_tipo_beneficio, p_valor, p_id_funcionario);
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

CREATE PROCEDURE create_historico_promocoes (
    IN p_id_funcionario INT,
    IN p_id_cargo_anterior INT,
    IN p_id_cargo_novo INT,
    IN p_data_promocao DATE
)
BEGIN
    INSERT INTO historico_promocoes (id_funcionario, id_cargo_anterior, id_cargo_novo, data_promocao)
    VALUES (p_id_funcionario, p_id_cargo_anterior, p_id_cargo_novo, p_data_promocao);
END //

DELIMITER ; 

DELIMITER //

CREATE PROCEDURE create_historico_departamento (
    IN p_id_funcionario INT,
    IN p_id_departamento_anterior INT,
    IN p_id_departamento_novo INT,
    IN p_data_mudanca DATE
)
BEGIN
    INSERT INTO historico_departamento (id_funcionario, id_departamento_anterior, id_departamento_novo, data_mudanca)
    VALUES (p_id_funcionario, p_id_departamento_anterior, p_id_departamento_novo, p_data_mudanca);
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
                    IN p_id_novo_cargo INT)
 BEGIN
	IF NOT EXISTS (SELECT id_funcionario FROM funcionario WHERE p_id_funcionario = id_funcionario) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Funcionário não existe';
	END IF;
    
    IF (p_id_cargo_atual = p_id_novo_cargo) THEN 
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Promoção na mesma posição não existe.';
	END IF;
    
    IF (p_id_novo_cargo = 1 OR p_id_novo_cargo = 2) THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Promoção inválida.';
	END IF;
    
    UPDATE funcionario
		SET id_cargo = p_id_novo_cargo
		WHERE
			p_id_funcionario = id_funcionario;
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

    INSERT INTO historico_departamento (id_funcionario, id_departamento_anterior, id_departamento_novo, data_mudanca)
    VALUES (p_id_funcionario, p_id_departamento, p_id_novo_departamento, CURDATE());
END //

DELIMITER ;

-- falta a procedure abaixo, procedure de folha de pagamento, colocar beneficios (tabela) e fazer mais inserções
CREATE PROCEDURE calcular_salario_total(IN p_funcionario_id INT, 
										OUT p_salario)
					

DELIMITER ;





-- essa procedure abaixo deixo por ultima
CREATE PROCEDURE relatorio_departamentos()
BEGIN
    SELECT 
        d.id_departamento,
        d.nome_departamento,
        COUNT(f.id_funcionario) AS total_funcionarios,
        SUM(f.salario) AS custo_total_salarios,
        AVG(f.salario) AS media_salarial,
        COUNT(DISTINCT t.id_treinamento) AS total_treinamentos,
        COUNT(DISTINCT b.id_beneficio) AS total_beneficios,
        SUM(b.valor) AS custo_total_beneficios,
        COUNT(DISTINCT c.id_candidato) AS candidaturas_relacionadas
    FROM departamento d
    LEFT JOIN funcionario f ON d.id_departamento = f.id_departamento
    LEFT JOIN treinamento t ON f.id_funcionario = t.id_funcionario
    LEFT JOIN beneficios b ON f.id_funcionario = b.id_funcionario
    LEFT JOIN cargo cg ON f.id_cargo = cg.id_cargo
    LEFT JOIN candidatos c ON cg.id_cargo = c.id_cargo_pretendido
    GROUP BY d.id_departamento
    ORDER BY d.nome_departamento

END //

DELIMITER ;
