CREATE TABLE departamento (
    id_departamento SERIAL PRIMARY KEY,
    nome_departamento VARCHAR(250) NOT NULL UNIQUE
);

CREATE TABLE cargo (
    id_cargo SERIAL PRIMARY KEY,
    nome_cargo VARCHAR(250) NOT NULL UNIQUE
);

CREATE TABLE funcionario (
    id_funcionario SERIAL PRIMARY KEY,
    nome VARCHAR(250) NOT NULL,
    id_departamento INT NOT NULL,
    email VARCHAR(250) NOT NULL UNIQUE,
    CPF VARCHAR(14) NOT NULL UNIQUE,
    id_cargo INT NOT NULL,
    salario DECIMAL(10,2) NOT NULL CHECK (salario > 0),
    FOREIGN KEY (id_cargo) REFERENCES cargo(id_cargo),
    FOREIGN KEY (id_departamento) REFERENCES departamento(id_departamento) ON DELETE CASCADE
);

-- funcionario, cargom dep ja foi executado das tabelas


CREATE TABLE folha_pagamento (
    id_folha SERIAL PRIMARY KEY,
    id_funcionario INT NOT NULL,
    data_pagamento DATE NOT NULL,
    salario_liquido DECIMAL(10,2) NOT NULL CHECK (salario_liquido > 0),
    FOREIGN KEY (id_funcionario) REFERENCES funcionario(id_funcionario) ON DELETE CASCADE
);


CREATE TABLE beneficios (
    id_beneficio SERIAL PRIMARY KEY,
    tipo_beneficio VARCHAR(250) NOT NULL,
    valor DECIMAL(10,2) NOT NULL CHECK (valor > 0),
    id_departamento INT NOT NULL,
    FOREIGN KEY (id_departamento) REFERENCES departamento(id_departamento) ON DELETE CASCADE
);


CREATE TABLE treinamento (
    id_treinamento SERIAL PRIMARY KEY,
    nome_treinamento VARCHAR(250) NOT NULL,
    data_treinamento DATE NOT NULL,
    carga_horaria INT CHECK (carga_horaria > 0),
    id_funcionario INT NOT NULL,
    FOREIGN KEY (id_funcionario) REFERENCES funcionario(id_funcionario) ON DELETE CASCADE
);


CREATE TABLE candidatos (
    id_candidato SERIAL PRIMARY KEY,
    nome VARCHAR(250) NOT NULL,
    email VARCHAR(250) NOT NULL UNIQUE,
    id_cargo_pretendido INT,
    data_aplicacao DATE DEFAULT CURRENT_DATE,
    FOREIGN KEY (id_cargo_pretendido) REFERENCES cargo(id_cargo) ON DELETE SET NULL
);



-- triggers executados: funcionario,


CREATE OR REPLACE FUNCTION antes_inserir_funcionario()
RETURNS TRIGGER AS $$
DECLARE
    v_count INTEGER;
BEGIN
    IF NEW.nome IS NULL THEN
        RAISE EXCEPTION 'Nome não pode ser nulo.';
    END IF;
    
    IF NEW.id_departamento IS NULL OR NEW.id_departamento <= 0 THEN
        RAISE EXCEPTION 'ID de departamento inválido.';
    END IF;
    
    SELECT COUNT(*) INTO v_count FROM funcionario WHERE email = NEW.email;
    IF v_count > 0 THEN
        RAISE EXCEPTION 'Email já existente.';
    END IF;
    
    SELECT COUNT(*) INTO v_count FROM funcionario WHERE CPF = NEW.CPF;
    IF v_count > 0 THEN
        RAISE EXCEPTION 'CPF já registrado.';
    END IF;
    
    IF LENGTH(NEW.CPF) != 14 THEN
        RAISE EXCEPTION 'CPF inválido.';
    END IF;
    
    IF NEW.id_cargo IS NULL THEN 
        RAISE EXCEPTION 'Cargo inválido.';
    END IF;
    
    IF NEW.salario < 0 THEN
        RAISE EXCEPTION 'Salário inválido';
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_antes_inserir_funcionario
BEFORE INSERT ON funcionario
FOR EACH ROW EXECUTE FUNCTION antes_inserir_funcionario();




CREATE OR REPLACE FUNCTION antes_inserir_departamento()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.nome_departamento IS NULL THEN
        RAISE EXCEPTION 'Nome de dep. não pode ser nulo.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_antes_inserir_departamento
BEFORE INSERT ON departamento
FOR EACH ROW EXECUTE FUNCTION antes_inserir_departamento();



CREATE OR REPLACE FUNCTION antes_inserir_cargo()
RETURNS TRIGGER AS $$
DECLARE
    cargo_count INTEGER;
BEGIN
    IF NEW.nome_cargo IS NULL THEN
        RAISE EXCEPTION 'Nome de cargo inválido.';
    END IF;

    SELECT COUNT(*) INTO cargo_count 
    FROM cargo 
    WHERE nome_cargo = NEW.nome_cargo;

    IF cargo_count > 0 THEN
        RAISE EXCEPTION 'Função já existente.';
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_antes_inserir_cargo
BEFORE INSERT ON cargo
FOR EACH ROW EXECUTE FUNCTION antes_inserir_cargo();


CREATE OR REPLACE FUNCTION antes_inserir_folha_pagamento()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.id_funcionario IS NULL THEN 
        RAISE EXCEPTION 'Id funcionário inválido.';
    END IF;
    
    IF NEW.data_pagamento IS NULL THEN 
        RAISE EXCEPTION 'Data de pagamento inválida.';
    END IF;
    
    IF NEW.salario_liquido < 0 THEN
        RAISE EXCEPTION 'Salário inválido.';
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_antes_inserir_folha_pagamento
BEFORE INSERT ON folha_pagamento
FOR EACH ROW EXECUTE FUNCTION antes_inserir_folha_pagamento();


CREATE OR REPLACE FUNCTION antes_inserir_beneficios()
RETURNS TRIGGER AS $$
DECLARE
    dept_count INTEGER;
BEGIN
    IF NEW.tipo_beneficio IS NULL OR NEW.tipo_beneficio = '' THEN
        RAISE EXCEPTION 'Tipo de benefício não pode ser nulo ou vazio.';
    END IF;

    IF NEW.valor <= 0 THEN
        RAISE EXCEPTION 'Valor do benefício deve ser positivo.';
    END IF;

    IF NEW.id_departamento IS NULL OR NEW.id_departamento <= 0 THEN
        RAISE EXCEPTION 'ID de departamento inválido.';
    END IF;
    
    SELECT COUNT(*) INTO dept_count 
    FROM departamento 
    WHERE id_departamento = NEW.id_departamento;

    IF dept_count = 0 THEN
        RAISE EXCEPTION 'Id departamento não encontrado.';
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_antes_inserir_beneficios
BEFORE INSERT ON beneficios
FOR EACH ROW EXECUTE FUNCTION antes_inserir_beneficios();


CREATE OR REPLACE FUNCTION antes_inserir_treinamento()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.nome_treinamento IS NULL OR NEW.nome_treinamento = '' THEN
        RAISE EXCEPTION 'Nome do treinamento não pode ser nulo ou vazio.';
    END IF;

    IF NEW.data_treinamento IS NULL THEN
        RAISE EXCEPTION 'Data do treinamento não pode ser nula.';
    END IF;

    IF NEW.carga_horaria <= 0 THEN
        RAISE EXCEPTION 'Carga horária deve ser positiva.';
    END IF;

    IF NEW.id_funcionario IS NULL OR NEW.id_funcionario <= 0 THEN
        RAISE EXCEPTION 'ID do funcionário inválido.';
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_antes_inserir_treinamento
BEFORE INSERT ON treinamento
FOR EACH ROW EXECUTE FUNCTION antes_inserir_treinamento();


CREATE OR REPLACE FUNCTION antes_inserir_candidatos()
RETURNS TRIGGER AS $$
DECLARE
    email_count INTEGER;
    cargo_count INTEGER;
BEGIN
    IF NEW.nome IS NULL OR NEW.nome = '' THEN
        RAISE EXCEPTION 'Nome do candidato não pode ser nulo ou vazio.';
    END IF;

    IF NEW.email IS NULL OR NEW.email = '' THEN
        RAISE EXCEPTION 'Email do candidato não pode ser nulo ou vazio.';
    END IF;

    SELECT COUNT(*) INTO email_count 
    FROM candidatos 
    WHERE email = NEW.email;

    IF email_count > 0 THEN
        RAISE EXCEPTION 'Email já cadastrado para outro candidato.';
    END IF;

    IF NEW.id_cargo_pretendido IS NOT NULL THEN
        IF NEW.id_cargo_pretendido <= 0 THEN
            RAISE EXCEPTION 'ID do cargo pretendido inválido.';
        END IF;
        
        SELECT COUNT(*) INTO cargo_count 
        FROM cargo 
        WHERE id_cargo = NEW.id_cargo_pretendido;

        IF cargo_count = 0 THEN
            RAISE EXCEPTION 'Cargo pretendido não existente.';
        END IF;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_antes_inserir_candidatos
BEFORE INSERT ON candidatos
FOR EACH ROW EXECUTE FUNCTION antes_inserir_candidatos();

-- procedures

CREATE OR REPLACE PROCEDURE promover_funcionario(
    p_id_funcionario INT,
    p_id_novo_cargo INT,
    p_novo_salario DECIMAL(10, 2)
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_count INT;
    v_current_cargo INT;
    v_current_salary DECIMAL(10, 2);
BEGIN
    
    SELECT COUNT(*) INTO v_count FROM funcionario 
    WHERE id_funcionario = p_id_funcionario;
    
    IF v_count = 0 THEN
        RAISE EXCEPTION 'Funcionário não existe';
    END IF;
    
    
    SELECT id_cargo, salario INTO v_current_cargo, v_current_salary 
    FROM funcionario 
    WHERE id_funcionario = p_id_funcionario;
    
    
    IF v_current_cargo = p_id_novo_cargo THEN
        RAISE EXCEPTION 'Promoção na mesma posição não permitida';
    END IF;
    
    IF p_novo_salario <= v_current_salary THEN
        RAISE EXCEPTION 'Novo salário deve ser maior que o atual';
    END IF;
    
    IF p_novo_salario <= 0 THEN
        RAISE EXCEPTION 'Salário inválido';
    END IF;
    
    
    UPDATE funcionario SET
        id_cargo = p_id_novo_cargo,
        salario = p_novo_salario
    WHERE id_funcionario = p_id_funcionario;
    
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
$$;

CREATE OR REPLACE PROCEDURE create_funcionario(
    p_nome VARCHAR,
    p_id_departamento INT,
    p_email VARCHAR,
    p_cpf VARCHAR,
    p_id_cargo INT,
    p_salario DECIMAL(10, 2)
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO funcionario (nome, id_departamento, email, cpf, id_cargo, salario)
    VALUES (p_nome, p_id_departamento, p_email, p_cpf, p_id_cargo, p_salario);
EXCEPTION
    WHEN OTHERS THEN
        RAISE;
END;
$$;


CREATE OR REPLACE PROCEDURE create_cargo(
    p_nome_cargo VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO cargo (nome_cargo) VALUES (p_nome_cargo);
EXCEPTION
    WHEN unique_violation THEN
        RAISE EXCEPTION 'Cargo já existe';
    WHEN OTHERS THEN
        RAISE;
END;
$$;


CREATE OR REPLACE PROCEDURE buscar_funcionario(
    p_id_funcionario INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_funcionario funcionario%ROWTYPE;
BEGIN
    
    SELECT * INTO v_funcionario
    FROM funcionario
    WHERE id_funcionario = p_id_funcionario;

    
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Funcionário com ID % não encontrado.', p_id_funcionario;
    END IF;


    RAISE NOTICE 'Funcionário encontrado: %', v_funcionario;
END;
$$;



-- alguns inserts

CALL create_departamento('TI');
CALL create_cargo('Estagiário');
-- CALL create_cargo('Cientista de Dados Júnior');
CALL create_cargo('Cientista de Dados Pleno');
select * from cargo;

CALL create_funcionario( -- funcionario de id 2
    'Allan Breno Pereira',
    1,
    'email@empresa.com',
    '123.456.789-09',
    1,  
    10069.00
);

SELECT * FROM cargo;
CALL buscar_funcionario(2);


-- todas as procedures no postgreesql
CALL create_departamento(p_nome_departamento);


CALL create_cargo(p_nome_cargo);
CALL create_funcionario(
    p_nome,
    p_id_departamento,
    p_email,
    p_cpf,
    p_id_cargo,
    p_salario
);


CALL create_folha_pagamento(
    p_id_funcionario,
    p_data_pagamento,
    p_salario_liquido
);


CALL create_beneficios(
    p_tipo_beneficio,
    p_valor,
    p_id_departamento
);


CALL create_treinamento(
    p_nome_treinamento,
    p_data_treinamento,
    p_carga_horaria
    p_id_funcionario 
);


CALL create_candidatos(
    p_nome,
    p_email,
    p_id_cargo_pretendido,
    p_data_aplicacao 
);


CALL remove_funcionario(p_id_funcionario);


CALL remove_departamento(p_id_departamento);


CALL remove_cargo(p_id_cargo);


CALL promover_funcionario(
    p_id_funcionario,
    p_id_novo_cargo,
    p_novo_salario 
);


CALL mudar_departamento(
    p_id_funcionario,
    p_id_novo_departamento
);


CALL relatorio_departamentos(); -- falta essa 





CALL todos_funcionarios();


CALL beneficios_departamento(p_id_departamento);


CALL buscar_funcionario(p_id_funcionario => 1);


