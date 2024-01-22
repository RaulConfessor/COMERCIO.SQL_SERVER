CREATE DATABASE COMERCIO
GO

USE COMERCIO
GO

CREATE TABLE  PRODUTO(
	IDPRODUTO INT PRIMARY KEY IDENTITY,
	PRODUTO VARCHAR(30) NOT NULL UNIQUE, 
	CATEGORIA VARCHAR(20),
	PRECO MONEY NOT NULL,
	ID_FORNCEDOR INT
)
GO

CREATE TABLE FORNCEDOR(
	IDFORNCEDOR INT PRIMARY KEY IDENTITY,
	FORNCEDOR VARCHAR(30) NOT NULL,
	CNPJ VARCHAR(20) UNIQUE,
	EMAIL VARCHAR(30) NOT NULL UNIQUE
)
GO

ALTER TABLE PRODUTO ADD CONSTRAINT FK_PRODUTO_FORNCEDOR
FOREIGN KEY (ID_FORNCEDOR) REFERENCES FORNCEDOR(IDFORNCEDOR)
GO

CREATE TABLE TELEFONE(
	IDTELEFONE INT PRIMARY KEY IDENTITY,
	TIPO CHAR(3) CHECK( TIPO IN('TEL','COM')) NOT NULL,
	NUMERO VARCHAR(20) NOT NULL UNIQUE,
	ID_FORNCEDOR INT
)
GO

ALTER TABLE TELEFONE ADD CONSTRAINT FK_TELEFONE_FORNCEDOR
FOREIGN KEY (ID_FORNCEDOR) REFERENCES FORNCEDOR(IDFORNCEDOR)
GO

CREATE TABLE HISTORICO(
	IDHISTORICO INT PRIMARY KEY IDENTITY,
	PRODUTO VARCHAR(30) NOT NULL,
	CATEOGORIA VARCHAR(2) NOT NULL,
	PRECOANTIGO MONEY NOT NULL,
	PRECONOVO MONEY NOT NULL,
	DATA DATETIME,
	USUARIO VARCHAR(30),
	MSG VARCHAR(100)
)
GO



DROP TRIGGER TRG_ATUALIZA_PRECO
GO

CREATE TRIGGER TRG_ATUALIZA_PRECO
ON DBO.PRODUTO
FOR UPDATE
AS 
IF UPDATE(PRECO)
	BEGIN
		DECLARE @IDPRODUTO INT
		DECLARE @PRODUTO VARCHAR(30)
		DECLARE @CATEGORIA VARCHAR(20)
		DECLARE @PRECOANTIGO MONEY
		DECLARE @PRECONOVO MONEY
		DECLARE @DATA DATETIME
		DECLARE @USUARIO VARCHAR(30)
		DECLARE @MSG VARCHAR(100)

		SELECT @IDPRODUTO = IDPRODUTO FROM inserted
		SELECT @PRODUTO = PRODUTO FROM inserted
		SELECT @CATEGORIA = CATEGORIA FROM inserted
		SELECT @PRECOANTIGO = PRECO FROM deleted
		SELECT @PRECONOVO = PRECO FROM inserted

		SET @DATA = GETDATE()
		SET @USUARIO = SUSER_NAME()
		SET @MSG = 'VALOR INSERIDO PELA TRIGGER'

		INSERT INTO HISTORICO(PRODUTO, CATEOGORIA, PRECOANTIGO, PRECONOVO, DATA, USUARIO, MSG)
		VALUES(@PRODUTO, @CATEGORIA, @PRECOANTIGO, @PRECONOVO, @DATA, @USUARIO, @MSG)

	PRINT 'TRIGGER EXECUTADO COM SUCESSO!!'
	END
GO

INSERT INTO FORNCEDOR (FORNCEDOR, CNPJ, EMAIL)
VALUES 
  ('Bauducco', '12345678901234', 'bauducco@email.com'),
  ('Nestlé', '98765432109876', 'nestle@email.com'),
  ('Sadia', '34567890123456', 'sadia@email.com'),
  ('Vigor', '78901234567890', 'vigor@email.com')
GO

INSERT INTO PRODUTO (PRODUTO, CATEGORIA, PRECO, ID_FORNCEDOR)
VALUES 
  ('Panetone', 'Bolos e Doces', 19.99, 1),
  ('Chocolate', 'Doces', 3.49, 2),
  ('Presunto', 'Embutidos', 8.99, 3),
  ('Leite Condensado', 'Laticínios', 5.99, 4),
  ('Pão de Forma', 'Padaria', 2.49, 1),
  ('Iogurte', 'Laticínios', 2.99, 2),
  ('Lasanha', 'Congelados', 12.99, 3),
  ('Queijo Mussarela', 'Queijos', 9.79, 4),
  ('Biscoitos', 'Bolachas', 4.99, 1),
  ('Suco de Frutas', 'Bebidas', 6.99, 2)
GO

INSERT INTO TELEFONE (TIPO, NUMERO, ID_FORNCEDOR)
VALUES 
  ('TEL', '1122334455', 1),
  ('TEL', '9988776655', 1),
  ('COM', '5544332211', 2),
  ('TEL', '9988776656', 3),
  ('TEL', '1122334456', 3),
  ('TEL', '1122334457', 4),
  ('COM', '5544332212', 4),
  ('COM', '6677889901', 4)
GO

SELECT * FROM PRODUTO
SELECT * FROM FORNCEDOR
SELECT * FROM TELEFONE
GO
/*
-- Tabela FORNCEDOR
-- IDFORNCEDOR  FORNCEDOR  CNPJ           EMAIL
1            Bauducco   12345678901234 bauducco@email.com
2            Nestle     98765432104321 nestle@email.com
3            Sadia      45678901234567 sadia@email.com
4            Tirolez    65432109876543 tirolez@email.com

-- Tabela PRODUTO
-- IDPRODUTO  PRODUTO            CATEGORIA      PRECO  ID_FORNCEDOR
1          Panetone           Bolos e Doces    19.99  1
2          Chocolate          Doces            3.49   2
3          Presunto           Embutidos        8.99   3
4          Leite Condensado   Laticínios       5.99   4
5          Pão de Forma        Padaria         2.49   1
6          Iogurte            Laticínios       2.99   2
7          Lasanha            Congelados       12.99  3
8          Queijo Mussarela    Queijos         9.79   4
9          Biscoitos          Bolachas         4.99   1
10         Suco de Frutas     Bebidas          6.99   2

-- Tabela TELEFONE
-- IDTELEFONE  TIPO  NUMERO      ID_FORNCEDOR
1             TEL   1122334455  1
2             TEL   9988776655  1
3             COM   5544332211  2
4             TEL   9988776656  3
5             TEL   1122334456  3
6             TEL   1122334457  4
7             COM   5544332212  4
8             COM   6677889901  4
*/


SELECT * FROM PRODUTO
SELECT * FROM FORNCEDOR
SELECT * FROM TELEFONE
GO

UPDATE PRODUTO SET PRECO = 5.39
WHERE IDPRODUTO = 12
GO
SELECT * FROM HISTORICO

/*
IDHISTORICO | PRODUTO      | CATEGORIA      | PRECOANTIGO | PRECONOVO | DATA                      | USUARIO                    | MSG
-----------------------------------------------------------------------------------------
4           | Chocolate    | Doces          | 5,49        | 5,39      | 2024-01-21 21:16:07.740   | DESKTOP-1VPOTLF\Raul      | VALOR INSERIDO PELA TRIGGER
5           | Panetone     | Bolos e Doces  | 19,99       | 21,989    | 2024-01-21 21:24:37.123   | DESKTOP-1VPOTLF\Raul      | VALOR INSERIDO PELA TRIGGER
7           | Chocolate    | Doces          | 3,49        | 5,39      | 2024-01-21 21:32:41.443   | DESKTOP-1VPOTLF\Raul      | VALOR INSERIDO PELA TRIGGER
*/

SELECT IDPRODUTO, PRODUTO, CATEGORIA, PRECO, FORNCEDOR, EMAIL, NUMERO, TIPO
FROM FORNCEDOR
INNER JOIN PRODUTO P
ON IDFORNCEDOR = P.ID_FORNCEDOR
INNER JOIN TELEFONE T
ON IDFORNCEDOR = T.ID_FORNCEDOR
GO

/*
IDPRODUTO | PRODUTO              | CATEGORIA           | PRECO | FORNCEDOR | EMAIL               | NUMERO      | TIPO
------------------------------------------------------------------------------------------------------------------
11        | Panetone            | Bolos e Doces       | 19,99 | Bauducco  | bauducco@email.com | 1122334455  | TEL
11        | Panetone            | Bolos e Doces       | 19,99 | Bauducco  | bauducco@email.com | 9988776655  | TEL
12        | Chocolate           | Doces               | 5,39  | Nestlé    | nestle@email.com   | 5544332211  | COM
13        | Presunto             | Embutidos           | 8,99  | Sadia     | sadia@email.com    | 9988776656  | TEL
13        | Presunto             | Embutidos           | 8,99  | Sadia     | sadia@email.com    | 1122334456  | TEL
14        | Leite Condensado     | Laticínios          | 5,99  | Vigor     | vigor@email.com    | 1122334457  | TEL
14        | Leite Condensado     | Laticínios          | 5,99  | Vigor     | vigor@email.com    | 5544332212  | COM
14        | Leite Condensado     | Laticínios          | 5,99  | Vigor     | vigor@email.com    | 6677889901  | COM
15        | Pão de Forma         | Padaria             | 2,49  | Bauducco  | bauducco@email.com | 1122334455  | TEL
15        | Pão de Forma         | Padaria             | 2,49  | Bauducco  | bauducco@email.com | 9988776655  | TEL
16        | Iogurte              | Laticínios          | 2,99  | Nestlé    | nestle@email.com   | 5544332211  | COM
17        | Lasanha              | Congelados          | 12,99 | Sadia     | sadia@email.com    | 9988776656  | TEL
17        | Lasanha              | Congelados          | 12,99 | Sadia     | sadia@email.com    | 1122334456  | TEL
18        | Queijo Mussarela     | Queijos             | 9,79  | Vigor     | vigor@email.com    | 1122334457  | TEL
18        | Queijo Mussarela     | Queijos             | 9,79  | Vigor     | vigor@email.com    | 5544332212  | COM
18        | Queijo Mussarela     | Queijos             | 9,79  | Vigor     | vigor@email.com    | 6677889901  | COM
19        | Biscoitos            | Bolachas            | 4,99  | Bauducco  | bauducco@email.com | 1122334455  | TEL
19        | Biscoitos            | Bolachas            | 4,99  | Bauducco  | bauducco@email.com | 9988776655  | TEL
20        | Suco de Frutas       | Bebidas             | 6,99  | Nestlé    | nestle@email.com   | 5544332211  | COM
*/


SELECT IDPRODUTO, PRODUTO, PRECO, FORNCEDOR, EMAIL
FROM PRODUTO
INNER JOIN FORNCEDOR
ON IDFORNCEDOR = ID_FORNCEDOR
WHERE FORNCEDOR = 'BAUDUCCO'
GO

/*
IDPRODUTO | PRODUTO         | PRECO | FORNCEDOR | EMAIL
------------------------------------------------------
11        | Panetone        | 19,99 | Bauducco  | bauducco@email.com
15        | Pão de Forma     | 2,49  | Bauducco  | bauducco@email.com
19        | Biscoitos        | 4,99  | Bauducco  | bauducco@email.com
*/
