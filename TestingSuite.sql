
EXEC tSQLt.Run 'TestingClass.TestSalesTax'
	
exec tSQLt.PersistTestResults

-- ****************************************************************

EXEC tSQLt.Run 'TestingClass.TestSalesTax2'

exec tSQLt.PersistTestResults

-- ****************************************************************
exec tSQLt.Run 'TestingClass.TestManageContacts'

exec tSQLt.PersistTestResults

-- ****************************************************************

select	Id,
		Class,
		TestCase,
		Result,
		Msg,
		TestStartTime,
		TestEndTime
from		tSQLt.TestResultPersisted
where	ID >= 1010
