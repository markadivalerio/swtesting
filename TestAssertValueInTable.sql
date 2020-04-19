--EXEC tsqlt.NewTestClass 'testAVT'



CREATE OR ALTER PROCEDURE testAVT.[test 01 - PositiveCase]
AS
BEGIN

EXEC tSQLt.AssertValueInTable 'ContactsDummy', 'ID',1,''
END;
GO

CREATE OR ALTER PROCEDURE testAVT.[test 01 - NegativeCase]
AS
BEGIN

EXEC tSQLt.AssertValueInTable 'ContactsDummy', 'ID',1000,''
END;
GO

CREATE OR ALTER PROCEDURE testAVT.[test 01 - NegativeCaseInvalidTable]
AS
BEGIN

EXEC tSQLt.AssertValueInTable 'ContactsDummy1', 'ID',1000,''
END;
GO

CREATE OR ALTER PROCEDURE testAVT.[test 01 - NegativeCaseInvalidColumn]
AS
BEGIN

EXEC tSQLt.AssertValueInTable 'ContactsDummy', 'ID1',1000,''
END;
GO


EXEC tsqlt.run 'testAVT'