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

CREATE OR REPLACE PROCEDURE promover_funcionario(
    p_id_funcionario INT,
    p_id_cargo_atual INT,
    p_id_novo_cargo INT,
    p_salario_atual DECIMAL,
    p_novo_salario DECIMAL
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM funcionario WHERE id_funcionario = p_id_funcionario) THEN
        RAISE EXCEPTION 'Funcionário não existe';
    END IF;

    IF (p_id_cargo_atual = p_id_novo_cargo) THEN 
        RAISE EXCEPTION 'Promoção na mesma posição não é permitida.';
    END IF;

    IF (p_novo_salario <= p_salario_atual OR p_novo_salario <= 0) THEN 
        RAISE EXCEPTION 'Salário inválido. Deve ser maior que o atual e positivo.';
    END IF;

    UPDATE funcionario SET
        id_cargo = p_id_novo_cargo,
        salario = p_novo_salario
    WHERE id_funcionario = p_id_funcionario;
END;
$$;

CREATE OR REPLACE PROCEDURE create_departamento(
    p_nome_departamento VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Insere o novo departamento
    INSERT INTO departamento (nome_departamento) VALUES (p_nome_departamento);
EXCEPTION
    WHEN unique_violation THEN
        RAISE EXCEPTION 'Departamento já existe';
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

CALL create_departamento('TI');
CALL create_cargo('Estagiário')
CALL create_cargo('Cientista de Dados Júnior');
CALL create_cargo('Cientista de Dados Pleno')
select * from cargo;

CALL create_funcionario( -- funcionario de id 2
    'Allan Breno Pereira',
    1,
    'email@empresa.com',
    '123.456.789-09',
    1,  
    10069.00
);

CALL buscar_funcionario(2);


CALL promover_funcionario(
    2,  
    1,  
    3,  
    10069.00, 
    12000.00   
);

CALL buscar_funcionario(2);