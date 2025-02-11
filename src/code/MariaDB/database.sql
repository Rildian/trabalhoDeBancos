/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

CREATE DATABASE IF NOT EXISTS `trabalhobancos` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_uca1400_ai_ci */;
USE `trabalhobancos`;

CREATE TABLE IF NOT EXISTS `beneficios` (
  `id_beneficio` int(11) NOT NULL AUTO_INCREMENT,
  `tipo_beneficio` varchar(250) NOT NULL,
  `valor` decimal(10,2) NOT NULL CHECK (`valor` > 0),
  `id_departamento` int(11) NOT NULL,
  PRIMARY KEY (`id_beneficio`),
  KEY `id_departamento` (`id_departamento`),
  CONSTRAINT `beneficios_ibfk_1` FOREIGN KEY (`id_departamento`) REFERENCES `departamento` (`id_departamento`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `buscar_funcionario`(
	IN `p_id_funcionario` INT
)
BEGIN
	SELECT * FROM funcionario 
   WHERE id_funcionario = p_id_funcionario;
END//
DELIMITER ;

CREATE TABLE IF NOT EXISTS `candidatos` (
  `id_candidato` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(250) NOT NULL,
  `email` varchar(250) NOT NULL,
  `id_cargo_pretendido` int(11) DEFAULT NULL,
  `data_aplicacao` date DEFAULT curdate(),
  PRIMARY KEY (`id_candidato`),
  UNIQUE KEY `email` (`email`),
  KEY `id_cargo_pretendido` (`id_cargo_pretendido`),
  CONSTRAINT `candidatos_ibfk_1` FOREIGN KEY (`id_cargo_pretendido`) REFERENCES `cargo` (`id_cargo`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

CREATE TABLE IF NOT EXISTS `cargo` (
  `id_cargo` int(11) NOT NULL AUTO_INCREMENT,
  `nome_cargo` varchar(250) NOT NULL,
  PRIMARY KEY (`id_cargo`),
  UNIQUE KEY `nome_cargo` (`nome_cargo`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `create_cargo`(
	IN `p_nome_cargo` VARCHAR(50)
)
BEGIN
	INSERT INTO cargo (nome_cargo) VALUES (p_nome_cargo);
END//
DELIMITER ;

DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `create_departamento`(
	IN `p_nome_departamento` VARCHAR(50)
)
BEGIN
	INSERT INTO departamento (nome_departamento) VALUES (p_nome_departamento);
END//
DELIMITER ;

DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `create_funcionario`(
	IN `p_nome` VARCHAR(50),
	IN `p_id_departamento` INT,
	IN `p_email` VARCHAR(50),
	IN `p_CPF` VARCHAR(50),
	IN `p_id_cargo` INT,
	IN `p_salario` FLOAT
)
BEGIN
    INSERT INTO funcionario (nome, id_departamento, email, CPF, id_cargo, salario)
    VALUES (p_nome, p_id_departamento, p_email, p_CPF, p_id_cargo, p_salario);
END//
DELIMITER ;

CREATE TABLE IF NOT EXISTS `departamento` (
  `id_departamento` int(11) NOT NULL AUTO_INCREMENT,
  `nome_departamento` varchar(250) NOT NULL,
  PRIMARY KEY (`id_departamento`),
  UNIQUE KEY `nome_departamento` (`nome_departamento`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

CREATE TABLE IF NOT EXISTS `folha_pagamento` (
  `id_folha` int(11) NOT NULL AUTO_INCREMENT,
  `id_funcionario` int(11) NOT NULL,
  `data_pagamento` date NOT NULL,
  `salario_liquido` decimal(10,2) NOT NULL CHECK (`salario_liquido` > 0),
  PRIMARY KEY (`id_folha`),
  KEY `id_funcionario` (`id_funcionario`),
  CONSTRAINT `folha_pagamento_ibfk_1` FOREIGN KEY (`id_funcionario`) REFERENCES `funcionario` (`id_funcionario`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

CREATE TABLE IF NOT EXISTS `funcionario` (
  `id_funcionario` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(250) NOT NULL,
  `id_departamento` int(11) NOT NULL,
  `email` varchar(250) NOT NULL,
  `CPF` varchar(14) NOT NULL,
  `id_cargo` int(11) NOT NULL,
  `salario` decimal(10,2) NOT NULL CHECK (`salario` > 0),
  PRIMARY KEY (`id_funcionario`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `CPF` (`CPF`),
  KEY `id_cargo` (`id_cargo`),
  KEY `id_departamento` (`id_departamento`),
  CONSTRAINT `funcionario_ibfk_1` FOREIGN KEY (`id_cargo`) REFERENCES `cargo` (`id_cargo`) ON UPDATE CASCADE,
  CONSTRAINT `funcionario_ibfk_2` FOREIGN KEY (`id_departamento`) REFERENCES `departamento` (`id_departamento`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `gerar_relatorio`()
BEGIN
	SELECT 
    d.id_departamento,
    d.nome_departamento,
    COUNT(f.id_funcionario) AS total_funcionarios,
    SUM(f.salario) AS custo_total_salarios,
    AVG(f.salario) AS media_salarial  -- Remova a vírgula aqui
FROM departamento d
LEFT JOIN funcionario f 
    ON d.id_departamento = f.id_departamento  -- Complete a condição
LEFT JOIN cargo cg 
    ON f.id_cargo = cg.id_cargo
GROUP BY d.id_departamento
ORDER BY d.nome_departamento;

END//
DELIMITER ;

DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `mudar_departamento`(
	IN `p_id_funcionario` INT,
	IN `p_id_departamento` INT,
	IN `p_id_novo_departamento` INT
)
BEGIN
	UPDATE funcionario
   SET id_departamento = p_id_novo_departamento
   WHERE id_funcionario = p_id_funcionario;
END//
DELIMITER ;

DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `promover_funcionario`(
	IN `p_id_funcionario` INT,
	IN `p_id_cargo_atual` INT,
	IN `p_id_novo_cargo` INT,
	IN `p_salario_atual` FLOAT,
	IN `p_novo_salario` FLOAT
)
BEGIN
	 UPDATE funcionario
    SET 
        id_cargo = p_id_novo_cargo,
        salario = p_novo_salario  
    WHERE 
        id_funcionario = p_id_funcionario;
END//
DELIMITER ;

DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `remover_cargo`(
	IN `p_id_cargo` INT
)
BEGIN
	DELETE FROM cargo
   WHERE id_cargo = p_id_cargo;
END//
DELIMITER ;

DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `remover_departamento`(
	IN `p_id_departamento` INT
)
BEGIN
	DELETE FROM
		departamento
	WHERE 
		(id_departamento = p_id_departamento);
END//
DELIMITER ;

DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `remover_funcionario`(
	IN `p_id_funcionario` INT
)
BEGIN
	DELETE FROM
		funcionario
	WHERE 
		(p_id_funcionario = id_funcionario);
END//
DELIMITER ;

DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `todos_os_cargos`(
	IN `` INT
)
BEGIN
	SELECT * FROM cargo 
	ORDER BY nome_cargo;
END//
DELIMITER ;

DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `todos_os_funcionarios`()
BEGIN
	SELECT * FROM funcionario
	ORDER BY id_funcionario;
END//
DELIMITER ;

CREATE TABLE IF NOT EXISTS `treinamento` (
  `id_treinamento` int(11) NOT NULL AUTO_INCREMENT,
  `nome_treinamento` varchar(250) NOT NULL,
  `data_treinamento` date NOT NULL,
  `carga_horaria` int(11) DEFAULT NULL CHECK (`carga_horaria` > 0),
  `id_funcionario` int(11) NOT NULL,
  PRIMARY KEY (`id_treinamento`),
  KEY `id_funcionario` (`id_funcionario`),
  CONSTRAINT `treinamento_ibfk_1` FOREIGN KEY (`id_funcionario`) REFERENCES `funcionario` (`id_funcionario`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='';
DELIMITER //
CREATE DEFINER=`root`@`localhost` TRIGGER `cargo_before_insert` BEFORE INSERT ON `cargo` FOR EACH ROW BEGIN
	IF NEW.nome_cargo IS NULL THEN
			SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Nome de cargo inválido.';
		END IF;
        
        IF (SELECT COUNT(nome_cargo) FROM cargo WHERE nome_cargo = NEW.nome_cargo) > 0 THEN 
			SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Função já existente.';
		END IF;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='';
DELIMITER //
CREATE DEFINER=`root`@`localhost` TRIGGER `departamento_before_insert` BEFORE INSERT ON `departamento` FOR EACH ROW BEGIN
		IF NEW.nome_departamento IS NULL THEN
			SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Nome de dep. não pode ser nulo.';
		END IF;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='';
DELIMITER //
CREATE DEFINER=`root`@`localhost` TRIGGER `funcionario_before_insert` BEFORE INSERT ON `funcionario` FOR EACH ROW BEGIN
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
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
