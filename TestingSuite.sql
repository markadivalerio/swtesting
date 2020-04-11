
EXEC tSQLt.Run 'TestingClass.TestSalesTax'
	
exec tSQLt.PersistTestResults

-- ****************************************************************


begin try

EXEC tSQLt.Run 'TestingClass.TestSalesTax2'

exec tSQLt.PersistTestResults

-- ****************************************************************
exec tSQLt.Run 'TestingClass.TestManageContacts'

exec tSQLt.PersistTestResults

-- ****************************************************************

-- ****************************************************************
exec tSQLt.Run 'TestingClass.TestSalesTax3'

exec tSQLt.PersistTestResults

-- ****************************************************************

-- ****************************************************************
exec tSQLt.Run 'TestingClass.TestGetTriangleType'

exec tSQLt.PersistTestResults

-- ****************************************************************

-- ****************************************************************
exec tSQLt.Run 'TestingClass.TestGetTriangleType2'

exec tSQLt.PersistTestResults

-- ****************************************************************

end try

begin catch

	print 'testing errors - see report'

end catch

-- all test results
select	Id,
		Class,
		TestCase,
		Result,
		Msg,
		TestStartTime,
		TestEndTime,
		TestCaseID
from		tSQLt.TestResultPersisted
where	ID >= 1010
order by ID desc

-- triangle test results
select	T.*,
		R.Result,
		R.Msg,
		R.TestStartTime,
		[TestTime (ms)] = datediff(ms, R.TestStartTime, R.TestEndTime)
from		TestCasesGetTriangleType T
left join		tSQLt.TestResultPersisted R on T.ID = R.TestCaseID


--select * from tSQLt.TestResult
