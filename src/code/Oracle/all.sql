CREATE TABLE departamento (
    id_departamento NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome_departamento VARCHAR2(250) NOT NULL UNIQUE
);

CREATE TABLE cargo (
    id_cargo NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome_cargo VARCHAR2(250) NOT NULL UNIQUE
);

CREATE TABLE funcionario (
    id_funcionario NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome VARCHAR2(250) NOT NULL,
    id_departamento NUMBER NOT NULL,
    email VARCHAR2(250) NOT NULL UNIQUE,
    CPF VARCHAR2(14) NOT NULL UNIQUE,
    id_cargo NUMBER NOT NULL,
    salario NUMBER(10,2) NOT NULL CHECK (salario > 0),
    FOREIGN KEY (id_cargo) REFERENCES cargo(id_cargo),
    FOREIGN KEY (id_departamento) REFERENCES departamento(id_departamento) ON DELETE CASCADE
);

CREATE OR REPLACE TRIGGER antes_inserir_funcionario
BEFORE INSERT ON funcionario
FOR EACH ROW
DECLARE
    v_count NUMBER;
BEGIN
    IF :NEW.nome IS NULL THEN
        RAISE_APPLICATION_ERROR(-20001, 'Nome não pode ser nulo.');
    END IF;
    
    IF :NEW.id_departamento IS NULL OR :NEW.id_departamento <= 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'ID de departamento inválido.');
    END IF;
    
    SELECT COUNT(*) INTO v_count FROM funcionario WHERE email = :NEW.email;
    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20003, 'Email já existente.');
    END IF;
    
    SELECT COUNT(*) INTO v_count FROM funcionario WHERE CPF = :NEW.CPF;
    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20004, 'CPF já registrado.');
    END IF;
    
    IF LENGTH(:NEW.CPF) != 14 THEN
        RAISE_APPLICATION_ERROR(-20005, 'CPF inválido.');
    END IF;
    
    IF :NEW.id_cargo IS NULL THEN 
        RAISE_APPLICATION_ERROR(-20006, 'Cargo inválido.');
    END IF;
    
    IF :NEW.salario < 0 THEN
        RAISE_APPLICATION_ERROR(-20007, 'Salário inválido');
    END IF;
END;
/

CREATE OR REPLACE PROCEDURE promover_funcionario(
    p_id_funcionario IN NUMBER,
    p_id_novo_cargo IN NUMBER,
    p_novo_salario IN NUMBER
)
IS
    v_count NUMBER;
    v_current_cargo NUMBER;
    v_current_salary NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count FROM funcionario 
    WHERE id_funcionario = p_id_funcionario;
    
    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20010, 'Funcionário não existe');
    END IF;
    
    SELECT id_cargo, salario INTO v_current_cargo, v_current_salary 
    FROM funcionario 
    WHERE id_funcionario = p_id_funcionario;
    
    IF v_current_cargo = p_id_novo_cargo THEN
        RAISE_APPLICATION_ERROR(-20011, 'Promoção na mesma posição não permitida');
    END IF;
    
    IF p_novo_salario <= v_current_salary THEN
        RAISE_APPLICATION_ERROR(-20012, 'Novo salário deve ser maior que o atual');
    END IF;
    
    IF p_novo_salario <= 0 THEN
        RAISE_APPLICATION_ERROR(-20013, 'Salário inválido');
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
END promover_funcionario;
/

CREATE OR REPLACE PROCEDURE create_funcionario (
    p_nome IN VARCHAR2,
    p_id_departamento IN NUMBER,
    p_email IN VARCHAR2,
    p_CPF IN VARCHAR2,
    p_id_cargo IN NUMBER,
    p_salario IN NUMBER
)
IS
BEGIN
    INSERT INTO funcionario (nome, id_departamento, email, CPF, id_cargo, salario)
    VALUES (p_nome, p_id_departamento, p_email, p_CPF, p_id_cargo, p_salario);
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END create_funcionario;
/

CREATE OR REPLACE PROCEDURE create_cargo (
    p_nome_cargo IN VARCHAR2
)
IS
BEGIN
    INSERT INTO cargo (nome_cargo) VALUES (p_nome_cargo);
    COMMIT;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        RAISE_APPLICATION_ERROR(-20020, 'Cargo já existe');
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END create_cargo;



EXEC create_cargo('Desenvolvedor Web Sênior');


EXEC create_funcionario('Mr N', 1, 'mrn@word.com', '123.456.789-09', 1, 10000);


EXEC promover_funcionario(1, 2, 12000);
