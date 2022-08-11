/* 
    Um arquivo de Cliente foi encaminhado para importação (Cliente.CSV) e precisaremos prepara-lo
para processamento. Precisaremos realizar as seguintes etapas:

	1. Importar o arquivo original para base TEMP. O arquivo possui respectivamente as colunas id,
data, hora, pessoa, cpf e telefone;

    2. Temos que criar ou uma tabela contendo DDD e UF referente (procurar as regras na internet)
ou regras para colocar a coluna UF na tabela formatada;

    3. Também criaremos uma tabela de Erros de Importação, de mesma estrutura da tabela
original, onde teremos regras que farão com que registros que não estejam de acordo, sejam
inseridos nesta tabela;

    4. Criaremos uma última tabela que conterá apenas os dados validados. Esta tabela terá as
colunas:
– id – coluna da tabela original com mesma numeração
– dataHora - União das colunas Data e Hora
– pessoa – mesma informação da tabela original
– Cpf – o mesmo CPF mas com formatação (ex: 007.478.778-51)
– DDD – Os dois primeiros dígitos do telefone
– Telefone – O restante do telefone, sem o DDD
– UF – Estado referente ao DDD	
*/


-- Analisando os dados
SELECT * FROM Cliente 



-- Cria��o da tabela UFS:
CREATE TABLE UFS(
	DDD CHAR(2),
	UF CHAR(2)
)

-- Populando os registros:
INSERT INTO UFS VALUES
('11',	'SP'),
('12',	'SP'),
('13',	'SP'),
('14',	'SP'),
('15',	'SP'),
('16',	'SP'),
('17',	'SP'),
('18',	'SP'),
('19',	'SP'),
('21',	'RJ'),
('22',	'RJ'),
('24',	'RJ'),
('27',	'ES'),
('28',	'ES'),
('31',	'MG'),
('32',	'MG'),
('33',	'MG'),
('34',	'MG'),
('35',	'MG'),
('37',	'MG'),
('38',	'MG'),
('41',	'PR'),
('42',	'PR'),
('43',	'PR'),
('44',	'PR'),
('45',	'PR'),
('46',	'PR'),
('47',	'SC'),
('48',	'SC'),
('49',	'SC'),
('51',	'RS'),
('53',	'RS'),
('54',	'RS'),
('55',	'RS'),
('61',	'DF'),
('62',	'GO'),
('63',	'TO'),
('64',	'GO'),
('65',	'MT'),
('66',	'MT'),
('67',	'MS'),
('68',	'AC'),
('69',	'RO'),
('71',	'BA'),
('73',	'BA'),
('74',	'BA'),
('75',	'BA'),
('77',	'BA'),
('79',	'SE'),
('81',	'PE'),
('82',	'AL'),
('83',	'PB'),
('84',	'RN'),
('85',	'CE'),
('86',	'PI'),
('87',	'PE'),
('88',	'CE'),
('89',	'PI'),
('91',	'PA'),
('92',	'AM'),
('93',	'PA'),
('94',	'PA'),
('95',	'RR'),
('96',	'AP'),
('97',	'AM'),
('98',	'MA'),
('99',	'MA')


-- Fazendo o tratamento dos dados e utilizando o SELECT INTO, definindo os tipos no pr�pio select:
SELECT	 Id
		,CONVERT(DATETIME, CONCAT(CAST(Data AS VARCHAR(50)),' ',CAST(Hora AS varchar(8))),102) 'DataHora'
		,CAST(CONCAT(SUBSTRING(CPF,1,3), '.',SUBSTRING(CPF,4,3) , '.' , SUBSTRING(CPF,7,3),'-', SUBSTRING(CPF,10,2)) AS char(14)) 'CPF'
		, CAST([Name] AS VARCHAR(50)) 'Nome'
		, UF
		,CAST(LEFT(Telefone,2) AS CHAR(2)) 'DDD'
		,CAST(RIGHT(telefone, 9) AS CHAR(9))'Telefone' 
		INTO Cliente_Limpo
		FROM Cliente C 
		JOIN UFS 
			ON UFS.DDD = LEFT(C.Telefone,2)
		WHERE CPF <> '0' and 
			([NAME] NOT LIKE 'robo%' AND [NAME] <> '0')

-- Invertendo os filtros para selecionar os indesejados para a tabela de erros:
SELECT * 
INTO Cliente_Erros
FROM Cliente 
WHERE CPF = '0' or 
			([NAME]  LIKE 'robo%' or [NAME] = '0')

-- Validando as tabelas
SELECT * FROM Cliente_Limpo
SELECT * FROM Cliente_Erros






