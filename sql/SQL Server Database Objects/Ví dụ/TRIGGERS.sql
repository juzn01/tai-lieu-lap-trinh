USE QLDIEM
GO
SELECT *
FROM MARK
--TAO TRIGGER INSERT DAM BAO RANG
--GIA TRI THEM VAO TRUONG WMARK VA PMARK 
--KO NHO HON 0 VA LON HON 25
CREATE TRIGGER ONINSERT
ON MARK
FOR INSERT
AS
--DOC GIA WMARK VA PMARK NHAP VAO
DECLARE @WMARK FLOAT,
		@PMARK FLOAT
SELECT @WMARK = WMARK FROM INSERTED
SELECT @PMARK = PMARK FROM INSERTED
IF @WMARK < 0 OR @WMARK > 25 OR @PMARK < 0 OR @PMARK > 25
BEGIN
	PRINT 'WMARK VA PMARK KHONG NHO HON 0 VA LON HON 25'
	ROLLBACK TRAN
END
--KIEM THU TRIGGER
DELETE FROM MARK WHERE WMARK = -1
INSERT INTO MARK 
VALUES('A002','HDJ',10,20,14.5)
--UPDATE CO 2 CAP: CAP BANG VA CAP COT
--CAP COT: TAO TRIGGER KO PHEP CAP NHAT TREN COT MARK CUA BANG MARK
CREATE TRIGGER ONUPDATE
ON MARK
FOR UPDATE
AS
IF UPDATE(MARK)
BEGIN
	PRINT 'COT MARK KO THE CAP NHAT'
	ROLLBACK TRAN
END
--KIEM THU TRIGGER
UPDATE MARK
SET MARK = MARK + 1
--CAP BANG: TAO TRIGGER DAM BAO RANG GIA TRI CAP NHAT
--CUA BIRTHDATE KHONG LON HON 1-1-1995
CREATE TRIGGER UPDATEONSTUDENT
ON STUDENT
FOR UPDATE
AS
IF (SELECT BIRTHDATE FROM INSERTED) > '1/1/1995'
BEGIN
	PRINT 'BAN CHUA DEN TUOI DI HOC'
	ROLLBACK TRAN
END
UPDATE STUDENT
SET BIRTHDATE = '6/11/1996'
WHERE ROLLNO = 'A0002'

SELECT *
FROM MARK
CREATE TRIGGER UPDATEONMARK
ON MARK
FOR UPDATE
AS
IF (SELECT WMARK FROM INSERTED) < (SELECT WMARK FROM DELETED)
BEGIN
	PRINT 'GIA TRI CAP NHAT KHONG NHO HON GIA TRI HIEN TAI'
	ROLLBACK TRANSACTION
END
--KIEM THU TRIGGER
UPDATE MARK
SET WMARK = WMARK - 1
WHERE ROLLNO = 'B01'

SELECT *
FROM STUDENT
SELECT *
FROM MARK

--TAO TRIGGER DELETE DAM BAO RANG NHUNG HOC SINH
--LOP C0611L KO DUOC XOA
CREATE TRIGGER DELETEONMARK
ON MARK
FOR DELETE
AS
IF EXISTS(SELECT D.*
FROM DELETED D INNER JOIN STUDENT S ON D.ROLLNO = S.ROLLNO
WHERE S.CLASSCODE = 'C0611L')
BEGIN
	PRINT'KHONG THE XOA SV LOP C0611L'
	ROLLBACK TRAN
END
--KIEM THU TRIGGER
DELETE FROM MARK
WHERE ROLLNO = 'B01'

SELECT * FROM MYSTUDENT

TRUNCATE TABLE MYSTUDENT

INSERT INTO MYSTUDENT(ROLLNO,CLASSCODE,FULLNAME,MALE,BIRTHDATE)
(SELECT ROLLNO,CLASSCODE,FULLNAME,MALE,BIRTHDATE FROM STUDENT)
--TAO TRIGGER INSERT DEM SO BAN GHI DUOC CHEN
--VAO BANG MYSTUDENT
ALTER TRIGGER INSERTONMYSTUDENT
ON MYSTUDENT
WITH ENCRYPTION
AFTER INSERT
AS
DECLARE @NUMROW INT
SELECT @NUMROW = COUNT(*) FROM INSERTED
PRINT 'BAN DA CHEN '+CAST(@NUMROW AS CHAR(3))+' BAN GHI' 
--
delete from student 
where rollno = 'B02'
--TAO TRIGGER INSTEAD OF XOA DAY CHUYEN TREN BANG STUDENT
CREATE TRIGGER DELETEONSTUDENT
ON STUDENT
INSTEAD OF DELETE
AS
--XOA TU BANG CON
DELETE FROM MARK WHERE ROLLNO IN
(SELECT ROLLNO FROM DELETED)
--XOA BANG CHA
DELETE FROM STUDENT WHERE ROLLNO IN 
(SELECT ROLLNO FROM DELETED)

SELECT * FROM STUDENT

SP_HELPTEXT INSERTONMYSTUDENT
--TRIGGER DDL: DAM BAO RANG NGUOI DUNG KO DUOC 
--TAO BANG
CREATE TRIGGER CREATE_PERMISSION
ON DATABASE -- MUC DATABASE
FOR CREATE_TABLE
AS
BEGIN
PRINT 'BAN KO CO QUYEN TAO BANG'
ROLLBACK TRAN
END
--KIEM THU TRIGGER
CREATE TABLE MYTABLE(COL1 INT, COL2 CHAR(2))
--XOA DDL TRIGGER
DROP TRIGGER CREATE_PERMISSION ON DATABASE

SELECT * FROM SYS.TRIGGERS WHERE NAME = 'INSERTONMYSTUDENT'
SELECT * FROM SYS.SQL_MODULES WHERE OBJECT_ID = 