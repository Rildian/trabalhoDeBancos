DELIMITER $$

CREATE TRIGGER antes_inserir_departamento
BEFORE INSERT ON departamento
FOR EACH ROW
	BEGIN
		IF NEW.nome_departamento IS NULL THEN
			SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Nome de dep. não pode ser nulo.';
		END IF;
	END$$
        
DELIMITER ;

DELIMITER $$

CREATE TRIGGER antes_inserir_cargo 
BEFORE INSERT ON cargo
FOR EACH ROW
	BEGIN
		IF NEW.titulo_cargo IS NULL THEN
			SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Título do cargo não pode ser nulo.';
		END IF;
        
        IF (SELECT COUNT(titulo_cargo) FROM cargo WHERE titulo_cargo = NEW.titulo_cargo) > 0 THEN 
			SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Título de cargo já existente.';
		END IF;
        
        IF NEW.salario_base < 0 THEN
			SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Erro. Salário negativo.';
		END IF;
	END$$
    
DELIMITER ;

DELIMITER $$ 

CREATE TRIGGER antes_inserir_funcionario
BEFORE INSERT ON funcionario
FOR EACH ROW
	BEGIN
		IF NEW.nome IS NULL THEN
			SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Nome não pode ser nulo.';
		END IF;
        
        IF NEW.id_departamento IS NULL OR NEW.id_departamento <= 0 THEN
			SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'ID de departamento inválido.';
		END IF;
        
        IF (SELECT COUNT(email) FROM funcionario WHERE NEW.email = email) > 0 THEN
			SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Email já existente.';
		END IF;
        
        IF (SELECT COUNT(CPF) FROM funcionario WHERE NEW.CPF = CPF) > 0 THEN
			SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'CPF já registrado.';
		END IF;
        
        IF LENGTH(NEW.CPF) != 13 THEN
			SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'CPF inválido.';
		END IF;
        
        IF NEW.id_cargo IS NULL THEN 
			SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Cargo inválido.';
		END IF;
        
        IF (NEW.data_contratacao IS NULL) THEN
			SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Data de contratação nula.';
		END IF;
        
        IF NEW.salario < 0 THEN
			SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Salário inválido';
		END IF;
        
	END$$
        
DELIMITER ;

DELIMITER $$

CREATE TRIGGER antes_inserir_folha_pagamento
BEFORE INSERT ON folha_pagamento
FOR EACH ROW
	BEGIN
		IF NEW.id_funcionario IS NULL THEN 
			SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Id funcionário inválido.';
		END IF;
        
        IF (NEW.data_pagamento IS NULL) THEN 
			SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Data de pagamento inválida.';
		END IF;
        
        IF (NEW.salario_liquido < 0) THEN
			SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Salário inválido.';
		END IF;
	END $$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER antes_inserir_beneficios
BEFORE INSERT ON beneficios
FOR EACH ROW
BEGIN
    IF NEW.tipo_beneficio IS NULL OR NEW.tipo_beneficio = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Tipo de benefício não pode ser nulo ou vazio.';
    END IF;

    IF NEW.valor <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Valor do benefício deve ser positivo.';
    END IF;

    IF NEW.id_funcionario IS NULL OR NEW.id_funcionario <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ID do funcionário inválido.';
    END IF;
END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER antes_inserir_treinamento
BEFORE INSERT ON treinamento
FOR EACH ROW
BEGIN
    IF NEW.nome_treinamento IS NULL OR NEW.nome_treinamento = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Nome do treinamento não pode ser nulo ou vazio.';
    END IF;

    IF NEW.data_treinamento IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Data do treinamento não pode ser nula.';
    END IF;

    IF NEW.carga_horaria <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Carga horária deve ser positiva.';
    END IF;

    IF NEW.id_funcionario IS NULL OR NEW.id_funcionario <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ID do funcionário inválido.';
    END IF;
END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER antes_inserir_candidatos
BEFORE INSERT ON candidatos
FOR EACH ROW
BEGIN
    IF NEW.nome IS NULL OR NEW.nome = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Nome do candidato não pode ser nulo ou vazio.';
    END IF;

    IF NEW.email IS NULL OR NEW.email = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Email do candidato não pode ser nulo ou vazio.';
    END IF;

    IF (SELECT COUNT(*) FROM candidatos WHERE email = NEW.email) > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Email já cadastrado para outro candidato.';
    END IF;

    IF NEW.id_cargo_pretendido IS NOT NULL THEN
        IF NEW.id_cargo_pretendido <= 0 OR (SELECT COUNT(*) FROM cargo WHERE id_cargo = NEW.id_cargo_pretendido) = 0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'ID do cargo pretendido inválido ou não existente.';
        END IF;
    END IF;
END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER antes_inserir_historico_promocoes
BEFORE INSERT ON historico_promocoes
FOR EACH ROW
BEGIN
    IF NEW.id_funcionario IS NULL OR NEW.id_funcionario <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ID do funcionário inválido.';
    END IF;

    IF NEW.id_cargo_anterior IS NULL OR NEW.id_cargo_anterior <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ID do cargo anterior inválido.';
    END IF;

    IF NEW.id_cargo_novo IS NULL OR NEW.id_cargo_novo <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ID do cargo novo inválido.';
    END IF;

    IF (SELECT COUNT(*) FROM cargo WHERE id_cargo = NEW.id_cargo_anterior) = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cargo anterior não existe.';
    END IF;

    IF (SELECT COUNT(*) FROM cargo WHERE id_cargo = NEW.id_cargo_novo) = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cargo novo não existe.';
    END IF;

    IF NEW.data_promocao IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Data da promoção não pode ser nula.';
    END IF;
END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER antes_inserir_historico_departamento
BEFORE INSERT ON historico_departamento
FOR EACH ROW
BEGIN
    IF NEW.id_funcionario IS NULL OR NEW.id_funcionario <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ID do funcionário inválido.';
    END IF;

    IF NEW.id_departamento_anterior IS NULL OR NEW.id_departamento_anterior <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ID do departamento anterior inválido.';
    END IF;

    IF NEW.id_departamento_novo IS NULL OR NEW.id_departamento_novo <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ID do departamento novo inválido.';
    END IF;

    IF (SELECT COUNT(*) FROM departamento WHERE id_departamento = NEW.id_departamento_anterior) = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Departamento anterior não existe.';
    END IF;

    IF (SELECT COUNT(*) FROM departamento WHERE id_departamento = NEW.id_departamento_novo) = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Departamento novo não existe.';
    END IF;

    IF NEW.data_mudanca IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Data de mudança não pode ser nula.';
    END IF;
END$$

DELIMITER ;