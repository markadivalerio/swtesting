--EXEC tsqlt.NewTestClass 'testAVT'
--go

CREATE OR ALTER PROCEDURE testAVT.[test 01 - PositiveCase]
AS
BEGIN

EXEC tSQLt.AssertValueInTable 'ContactsDummy', 'ID',1,''
END;
GO

CREATE OR ALTER PROCEDURE testAVT.[test 02 - NegativeCase]
AS
BEGIN
EXEC tSQLt.ExpectException @Message = 'Exception was thrown', @ExpectedSeverity = 16, @ExpectedState = 11;
EXEC tSQLt.AssertValueInTable 'ContactsDummy', 'ID',1000,''
END;
GO

CREATE OR ALTER PROCEDURE testAVT.[test 03 - NegativeCaseInvalidTable]
AS
BEGIN
EXEC tSQLt.ExpectException @Message = ' was empty:', @ExpectedSeverity = 16, @ExpectedState = 11;
EXEC tSQLt.AssertValueInTable 'ContactsDummy1', 'ID',1000,''
END;
GO

CREATE OR ALTER PROCEDURE testAVT.[test 04 - NegativeCaseInvalidColumn]
AS
BEGIN
EXEC tSQLt.ExpectException @Message = ' was empty:', @ExpectedSeverity = 16, @ExpectedState = 11;
EXEC tSQLt.AssertValueInTable 'ContactsDummy', 'ID1',1000,''
END;
GO


  EXEC tSQLt.Run 'testAVT';