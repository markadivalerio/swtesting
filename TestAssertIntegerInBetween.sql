--EXEC tSQLt.NewTestClass 'testAIB';
--GO
CREATE OR ALTER PROCEDURE testAIB.[test 01 - PositiveCase]
AS
BEGIN

EXEC tSQLt.[AssertIntegerInBetween] 2, 1,3
END;
GO

CREATE OR ALTER PROCEDURE testAIB.[test 02 - NegativeCase Should Fail]
AS
BEGIN
 EXEC tSQLt.ExpectException @Message = ':1 is not in between 2 and 3', @ExpectedSeverity = 16, @ExpectedState = 10;
EXEC tSQLt.[AssertIntegerInBetween] 1, 2,3
END;
GO

CREATE OR ALTER PROCEDURE testAIB.[test 03 - NegativeCase Should FailFail]
AS
BEGIN
EXEC tSQLt.ExpectException @Message= ' is not in range', @ExpectedSeverity = 16, @ExpectedState = 10;
EXEC tSQLt.[AssertIntegerInBetween] 1, 4,6
END;
GO

CREATE OR ALTER PROCEDURE testAIB.[test 04 - NullCase Should Fail]
AS
BEGIN
EXEC tSQLt.ExpectException @Message= ' is not in range', @ExpectedSeverity = 16, @ExpectedState = 10;
EXEC tSQLt.[AssertIntegerInBetween] 1, null,3
END;
GO


EXEC tSQLt.Run 'testAIB';

 

