-- Selecionar todas as tabelas presentes no banco de dados, é possível aplicar filtros e ordenações normalmente, urtilizando o WHERE e o ORDER BY
SELECT * FROM INFORMATION_SCHEMA.TABLES;

-- Selecionar o nome e a data de criação das tabelas do banco de dados
SELECT NAME, CREATE_DATE FROM SYS.TABLES 
ORDER BY NAME DESC

-- Selecionar as tabelas e as colunas do banco de dados
SELECT T.NAME, C.NAME, TI.IS_TABLE_TYPE, C.MAX_LENGTH
FROM SYS.TABLES AS T
INNER JOIN SYS.COLUMNS AS C ON T.OBJECT_ID = C.OBJECT_ID
INNER JOIN SYS.TYPES  AS TI ON  C.SYSTEM_TYPE_ID = TI.USER_TYPE_ID
ORDER BY T.NAME, C.NAME

-- Selecionar todas as tabelas, colunas e indíces do banco de dados
SELECT
I.NAME AS NOMEDOINDICE,
T.NAME AS NOMEDATABELA
FROM SYS.DM_DB_PARTITION_STATS AS S
INNER JOIN SYS.INDEXES AS I ON S.OBJECT_ID = I.OBJECT_ID
AND S.INDEX_ID = I.INDEX_ID
AND I.TYPE > 0
INNER JOIN SYS.TABLES T ON T.OBJECT_ID = I.OBJECT_ID
GROUP BY I.NAME, T.NAME
ORDER BY I.NAME, T.NAME


--Executar um comando SQL em todos os bancos de dados presentes no servidor
DECLARE @nomeBanco VARCHAR(50)
DECLARE @sql VARCHAR(256),
		@sql2 NVARCHAR(256)
 
DECLARE cursor_banco_de_dados CURSOR FOR  
SELECT name
FROM master.dbo.sysdatabases
WHERE name NOT IN ('master','model','msdb','tempdb')

OPEN cursor_banco_de_dados   
FETCH NEXT FROM cursor_banco_de_dados INTO @nomeBanco   

 
WHILE @@FETCH_STATUS = 0   
BEGIN   

	DECLARE @IND_EXECUTAR VARCHAR(100)

	SET @sql2 = '
		IF EXISTS (SELECT 1 FROM ' + @nomeBanco + '.INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = ''NOMESCHEMA'' AND TABLE_NAME = ''NOMETABELA'')
			SET @IND_EXECUTAR_IN = ''S''
		ELSE
			SET @IND_EXECUTAR_IN = ''N''
		'
	EXEC SP_EXECUTESQL @sql2, N'@IND_EXECUTAR_IN VARCHAR(100) OUTPUT', @IND_EXECUTAR_IN = @IND_EXECUTAR OUTPUT;

	IF @IND_EXECUTAR IS NOT NULL AND @IND_EXECUTAR = 'S'
	BEGIN

		SET @sql =	'SELECT * FROM ' + @nomeBanco + '.NOMETABELA'
		EXEC(@sql)
	END

	FETCH NEXT FROM cursor_banco_de_dados INTO @nomeBanco   
END   

 
CLOSE cursor_banco_de_dados 
DEALLOCATE cursor_banco_de_dados


--Remover uma tabela e suas chaves estrangeiras:
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'TABLE_NAME')
BEGIN
	ALTER TABLE TABLE_NAME DROP CONSTRAINT FK_NAME
	DROP TABLE TABLE_NAME 
END
GO
