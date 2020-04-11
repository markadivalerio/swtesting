
-- run the test in a try/catch block b/c we might get errors
-- catch is stubbed out because we're getting the results from a persisted table

begin try

	exec tSQLt.Run 'TestingClass.TestGetTriangleType2'

end try

begin catch

	declare @E varchar(1) -- stub

end catch

-- save the results
exec tSQLt.PersistTestResults

-- view the results
select	T.*,
		R.Result,
		R.Msg,
		R.TestStartTime,
		[TestTime (ms)] = datediff(ms, R.TestStartTime, R.TestEndTime)
from		TestCasesGetTriangleType T
left join	tSQLt.TestResultPersisted R on T.ID = R.TestCaseID

