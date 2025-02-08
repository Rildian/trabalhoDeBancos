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
		IF NEW.nome_cargo IS NULL THEN
			SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Nome de cargo inválido.';
		END IF;
        
        IF (SELECT COUNT(nome_cargo) FROM cargo WHERE nome_cargo = NEW.nome_cargo) > 0 THEN 
			SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Função já existente.';
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
        
        IF LENGTH(NEW.CPF) != 14 THEN
			SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'CPF inválido.';
		END IF;
        
        IF NEW.id_cargo IS NULL THEN 
			SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Cargo inválido.';
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

    IF NEW.id_departamento IS NULL OR NEW.id_departamento <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ID de departamento inválido.';
    END IF;
    
    IF NEW.id_departamento NOT IN (SELECT id_departamento FROM departamento) THEN
			SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Id departamento não encontrado.';
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











