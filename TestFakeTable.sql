

create or alter procedure dbo.[testcase 01 testing Fake Table]
@Idreturn int output
as 
begin

Exec tSQLt.FakeTable '[SWTEST].[dbo].[Contacts]'
insert into [SWTEST].[dbo].[Contacts]( [ID]     ,[NameFirst]     ,[NameLast]) values(1,'Sanjai','kanth')
 select top 1 @Idreturn= id from [SWTEST].[dbo].[Contacts] where   [NameFirst]='Sanjai' and [NameLast]='kanth' order by id
END;
GO
 
 EXEC tsqlt.NewTestClass 'testFT'
go
 
 --This SP will fake a table and insert values 
 --SP will insert same record twice and compare the identify values
CREATE OR ALTER PROCEDURE testFT.[testcase 01 comparing fakeTables persistance]
AS
BEGIN
declare @Idreturn1 int 
declare @Idreturn2 int 
EXEC dbo.[testcase 01 testing Fake Table]  @Idreturn1 output
EXEC dbo.[testcase 01 testing Fake Table]  @Idreturn2 output
EXEC tSQLt.AssertEquals @Idreturn1,@Idreturn2,'Not Match'
END;
GO
 
EXEC tsqlt.run 'testFT'

 