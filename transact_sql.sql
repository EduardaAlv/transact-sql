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
