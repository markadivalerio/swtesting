USE tSQLt_Example
GO
--	  AssertEmptyTable
--    AssertEqualsString
--    AssertEquals
--    *AssertLessThan
--    *AssertGreaterThan

--EXEC tSQLt.AssertEmptyTable 'tSQLt.AssertValidation'

--EXEC tSQLt.NewTestClass 'testAET';
--GO

--CREATE TABLE tSQLt.testDemoTable(  I INT )

CREATE OR ALTER PROCEDURE testAET.[test 01 - table empty]
AS
BEGIN
    DELETE FROM tSQLt.testDemoTable
    EXEC tSQLt.AssertEmptyTable 'tSQLt.testDemoTable'
END;
GO



CREATE OR ALTER PROCEDURE testAET.[test 02 - table not empty]
AS
BEGIN
    DELETE FROM tSQLt.testDemoTable

	INSERT INTO [tSQLt].[testDemoTable] ([I]) VALUES (1)

    EXEC tSQLt.AssertEmptyTable 'tSQLt.testDemoTable', 'Expected Failure'
END;
GO


CREATE OR ALTER PROCEDURE testAET.[test 03 - table does not exist]
AS
BEGIN
    EXEC tSQLt.AssertEmptyTable 'tSQLt.thisIsANonExistantTable', 'Expected Failure'
END;
GO

EXEC tSQLt.Run 'testAET';
