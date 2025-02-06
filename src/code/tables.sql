CREATE TABLE departamento (
    id_departamento INT PRIMARY KEY AUTO_INCREMENT,
    nome_departamento VARCHAR(250) NOT NULL UNIQUE
);

CREATE TABLE cargo (
    id_cargo INT PRIMARY KEY AUTO_INCREMENT,
    titulo_cargo VARCHAR(250) NOT NULL UNIQUE,
    salario_base DECIMAL(10, 2) NOT NULL CHECK (salario_base > 0)
);


CREATE TABLE funcionario (
    id_funcionario INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(250) NOT NULL,
    id_departamento INT NOT NULL,
    email VARCHAR(250) NOT NULL UNIQUE,
    CPF VARCHAR(14) NOT NULL UNIQUE,
    id_cargo INT NOT NULL,
    data_contratacao DATE NOT NULL CHECK (data_contratacao <= CURDATE()),
    salario DECIMAL(10, 2) NOT NULL CHECK (salario > 0),
    FOREIGN KEY (id_cargo) REFERENCES cargo(id_cargo) ON UPDATE CASCADE,
    FOREIGN KEY (id_departamento) REFERENCES departamento(id_departamento) ON DELETE RESTRICT
);


CREATE TABLE folha_pagamento (
    id_folha INT PRIMARY KEY AUTO_INCREMENT,
    id_funcionario INT NOT NULL,
    data_pagamento DATE NOT NULL CHECK (data_pagamento <= CURDATE()),
    salario_liquido DECIMAL(10, 2) NOT NULL CHECK (salario_liquido > 0),
    FOREIGN KEY (id_funcionario) REFERENCES funcionario(id_funcionario) ON DELETE CASCADE
);

CREATE TABLE beneficios (
    id_beneficio INT PRIMARY KEY AUTO_INCREMENT,
    tipo_beneficio VARCHAR(250) NOT NULL,
    valor DECIMAL(10,2) NOT NULL CHECK (valor > 0),
    id_funcionario INT NOT NULL,
    FOREIGN KEY (id_funcionario) REFERENCES funcionario(id_funcionario) ON DELETE CASCADE
);

CREATE TABLE treinamento (
    id_treinamento INT PRIMARY KEY AUTO_INCREMENT,
    nome_treinamento VARCHAR(250) NOT NULL,
    data_treinamento DATE NOT NULL,
    carga_horaria INT CHECK (carga_horaria > 0),
    id_funcionario INT NOT NULL,
    FOREIGN KEY (id_funcionario) REFERENCES funcionario(id_funcionario) ON DELETE CASCADE
);

CREATE TABLE candidatos (
    id_candidato INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(250) NOT NULL,
    email VARCHAR(250) NOT NULL UNIQUE,
    id_cargo_pretendido INT,
    data_aplicacao DATE DEFAULT (CURRENT_DATE),
    FOREIGN KEY (id_cargo_pretendido) REFERENCES cargo(id_cargo) ON DELETE SET NULL
);

CREATE TABLE historico_promocoes (
    id_promocao INT PRIMARY KEY AUTO_INCREMENT,
    id_funcionario INT NOT NULL,
    id_cargo_anterior INT NOT NULL,
    id_cargo_novo INT NOT NULL,
    data_promocao DATE DEFAULT (CURRENT_DATE),
    FOREIGN KEY (id_funcionario) REFERENCES funcionario(id_funcionario) ON DELETE CASCADE,
    FOREIGN KEY (id_cargo_anterior) REFERENCES cargo(id_cargo),
    FOREIGN KEY (id_cargo_novo) REFERENCES cargo(id_cargo)
);

CREATE TABLE historico_departamento (
    id_historico INT PRIMARY KEY AUTO_INCREMENT,
    id_funcionario INT NOT NULL,
    id_departamento_anterior INT NOT NULL,
    id_departamento_novo INT NOT NULL,
    data_mudanca DATE DEFAULT (CURRENT_DATE),
    FOREIGN KEY (id_funcionario) REFERENCES funcionario(id_funcionario) ON DELETE CASCADE,
    FOREIGN KEY (id_departamento_anterior) REFERENCES departamento(id_departamento),
    FOREIGN KEY (id_departamento_novo) REFERENCES departamento(id_departamento)
);


DELIMITER //

CREATE PROCEDURE promover_funcionario(
    IN funcionario_id INT,
    IN novo_cargo_id INT
)
BEGIN
    DECLARE cargo_atual_id INT;
    
    -- Verifica se o funcionário existe
    IF NOT EXISTS (SELECT 1 FROM funcionario WHERE id_funcionario = funcionario_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Funcionário não encontrado';
    END IF;
    
    -- Obtém o cargo atual
    SELECT id_cargo INTO cargo_atual_id
    FROM funcionario
    WHERE id_funcionario = funcionario_id;
    
    -- Atualiza o cargo
    UPDATE funcionario
    SET id_cargo = novo_cargo_id
    WHERE id_funcionario = funcionario_id;
    
    -- Registra no histórico
    INSERT INTO historico_promocoes (id_funcionario, id_cargo_anterior, id_cargo_novo)
    VALUES (funcionario_id, cargo_atual_id, novo_cargo_id);
END;
//

DELIMITER ;


