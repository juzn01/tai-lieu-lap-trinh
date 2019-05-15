--TAO DB
CREATE DATABASE QLHOCSINH
--TAO BANG CLASS
USE QLHOCSINH
GO
DROP TABLE CLASS
CREATE TABLE CLASS
(
CLASSCODE CHAR(6),
TEACHER NVARCHAR(30),
TIMESLOT NVARCHAR(12),
CLOSEDATE SMALLDATETIME
)
--THEM DL VAO BANG CLASS
INSERT INTO CLASS
VALUES('C0907I','LAMVT','13H30-17H30','5/31/2010')

INSERT INTO CLASS
VALUES('C0808G','LAMVT','07H30-11H30',GETDATE())

INSERT INTO CLASS
VALUES('C0906L','LAMVT','17H30-19H30','5/31/2010')

SELECT *
FROM CLASS

--TAO CHI MUC CLUSTERED
--XOA CHI MUC
IF EXISTS(SELECT * FROM SYSINDEXES 
WHERE NAME = 'IX_CLASS02')
	DROP INDEX CLASS.IX_CLASS02
GO
CREATE CLUSTERED INDEX IX_CLASS02
ON CLASS(CLASSCODE DESC) WITH(FILLFACTOR = 60)
GO
SELECT *
FROM CLASS

CREATE UNIQUE INDEX IX_CLASS02
ON CLASS(CLASSCODE)
--XEM TT CUA CHI MUC TREN BANG CLASS
SP_HELPINDEX CLASS
--TO CHUC LAI CAU TRUC CHI MUC

ALTER INDEX IX_CLASS02
ON CLASS REBUILD DISABLE

SELECT * 
FROM CLASS WITH(INDEX = IX_CLASS02)
WHERE CLASSCODE LIKE '%0%'