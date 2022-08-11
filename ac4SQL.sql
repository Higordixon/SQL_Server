
/* 
    Usando a base Temp, com o modelo estendido da Concessionaria (Cliente,
Vendas2013,Vendas2014, Vendas2015, ...), criar os objetos abaixo conforme as descrições:

    1. Crie uma função X que receba um parâmetro referente ao número do veículo e outro
referente ao Ano de Venda. A função deve retornar o número de vendas referentes ao
veículo no dado ano.

Exemplo:
Veículo 47 no ano 2013: 2 compras
Veículo 15 no ano 2014: 3 compras
Veículo 27 no ano 2015: 1 compra

    2. Crie uma função Y que receba um parâmetro referente ao número do cliente e retorne
todas as compras feitas por este cliente, trazendo as informações abaixo:

    3. Crie uma função Z que receba um parâmetro referente ao número do cliente. A função
deve retornar todo o conteúdo da função Y e mais 3 colunas com o nome
TotalVendasVeiculo2013, TotalVendasVeiculo2014, TotalVendasVeiculo2015. Estas
colunas devem ser preenchidas com as quantidades de compras que o determinado
cliente fez nos respectivos anos. Alguns requisitos devem ser seguidos na função Z:

- Deve necessariamente usar a Função Y e a função X para gerar seus resultados.
- Deve ter o comando INSERT .
- Deve ter WHILE com UPDATE para atualização das 3 colunas de Total.
*/


-- 1 
CREATE FUNCTION [2101386].[X](@Veiculo tinyint, @Ano smallint)
RETURNS SMALLINT
AS
BEGIN
DECLARE @Total SMALLINT

SELECT @Total = Compras from (SELECT COUNT(IdVendas) AS COMPRAS, IdVeiculo, YEAR(DataVenda) AS Ano FROM
	(	SELECT	*
		FROM Vendas2013
		UNION ALL
		SELECT *
		FROM Vendas2014
		UNION ALL
		SELECT *
		FROM Vendas2015) AS A
WHERE IdVeiculo = @Veiculo
		AND YEAR(DataVenda) = @Ano
GROUP BY IdVeiculo, YEAR(DataVenda)) as A
RETURN ISNULL(@Total,0)

END


--2 

CREATE FUNCTION [2101386].[Y](@Cliente tinyint)
RETURNS Table
AS
RETURN 
SELECT	Vendas.IdCliente
		,C.Nome AS NomeCliente
		,C.Sexo
		,C.dtNascimento
		,VENDAS.dataVenda
		,V.IdVeiculo
		,V.Descricao AS NomeVeiculo
		,M.descricao AS Modelo
		,F.Nome As FabricanteNome
FROM (	SELECT	*
		FROM Vendas2013
		UNION ALL
		SELECT *
		FROM Vendas2014
		UNION ALL
		SELECT *
		FROM Vendas2015) AS VENDAS
JOIN Cliente C
	ON Vendas.IdCliente = C.IdCliente
JOIN Veiculo V 
	ON VENDAS.IdVeiculo = V.IdVeiculo
JOIN Modelo M
	ON V.idModelo = M.IdModelo
JOIN Fabricante F
	ON V.idFabricante = F.IdFabricante
WHERE C.idCliente = @Cliente


-- 3

CREATE FUNCTION [2101386].[Z](@Cliente tinyint)
RETURNS @Date TABLE(idCliente Tinyint, Nome VARCHAR(50), Sexo BIT, dtNascimento Date
					, DataVenda Date, idVeiculo SMALLINT, Veiculo VARCHAR(50), Modelo VARCHAR(50), Fabricante VARCHAR(30)
					, TotalVendasVeiculo2013 SMALLINT, TotalVendasVeiculo2014 SMALLINT
					, TotalVendasVeiculo2015 SMALLINT)
AS
BEGIN
	INSERT INTO @Date(IdCliente,Nome,Sexo,dtNascimento,DataVenda,IdVeiculo, Veiculo,Modelo,Fabricante)
	SELECT * FROM [2101386].[Y](@Cliente)

	DECLARE @IdVeiculo int = (SELECT MIN(IdVeiculo) - 1 FROM @Date) 
	
	WHILE EXISTS (SELECT * FROM @Date WHERE IdVeiculo > @idVeiculo )
	BEGIN
		SELECT @IdVeiculo = MIN(IdVeiculo) FROM @Date Where IdVeiculo > @IdVeiculo

		UPDATE @Date SET TotalVendasVeiculo2013 = [2101386].[X](@IdVeiculo, 2013), 
						 TotalVendasVeiculo2014 = [2101386].[X](@IdVeiculo, 2014),
						 TotalVendasVeiculo2015 = [2101386].[X](@IdVeiculo, 2015)
					WHERE IdVeiculo = @IdVeiculo
	END
	RETURN
END

-- Valida��o
SELECT * FROM [2101386].[Z](1)