use SWTEST
GO

-- ****************************************************************
--- copy the results table to keep the test results permanently
-- ****************************************************************

if OBJECT_ID('tSQLt.TestResultPersisted' ) is not null
	drop table tSQLt.TestResultPersisted

select	* 
into		tSQLt.TestResultPersisted
from		tSQLt.TestResult
where	1 = 0

-- creates the test class for our proc
exec tSQLt.NewTestClass 'TestingClass'

GO

if OBJECT_ID('tSQLt.PersistTestResults', 'P') is not null
	drop procedure tSQLt.PersistTestResults

GO

create procedure tSQLt.PersistTestResults
as

begin
	set identity_insert tSQLt.TestResultPersisted on

	insert into tSQLt.TestResultPersisted
	(
			Id,
			Class,
			TestCase,
			Name,
			TranName,
			Result,
			Msg,
			TestStartTime,
			TestEndTime
	)
	select	Id,
			Class,
			TestCase,
			Name,
			TranName,
			Result,
			Msg,
			TestStartTime,
			TestEndTime
	from		tSQLt.TestResult

	set identity_insert tSQLt.TestResultPersisted off
end

GO

use Northwind

-- ****************************************************************
--- create objects to be tested 
-- ****************************************************************

IF OBJECT_ID('GetSalesTax_NW', 'FN') IS NOT NULL
DROP FUNCTION GetSalesTax_NW;
GO
 
CREATE FUNCTION GetSalesTax_NW(@amt MONEY, @rate decimal(4,2))
RETURNS MONEY
AS BEGIN
RETURN (@amt * (@rate))
END;
GO


-- create a table and then a procedure to add or remove records

if OBJECT_ID('Contacts', 'U') is not null
	drop table Contacts 

create table Contacts (
ID int identity(1,1),
NameFirst varchar(10), -- keep the name unusually short so we can trigger a failure in a test
NameLast varchar(25)
)

GO

if OBJECT_ID('ManageContacts', 'P') is not null
	drop procedure ManageContacts

GO

create procedure ManageContacts
@ID int = null OUTPUT,
@NameFirst varchar(10) = null,
@NameLast varchar(25) = null,
@Action char(1) -- expects I: insert, D: delete, U: update, T: truncate
as

begin

	if @Action not in ('I', 'D', 'U', 'T')
		RAISERROR ('@Action has invalid value', 11, 1)

	if @Action = 'I'
		insert into Contacts (NameFirst, NameLast) values (@NameFirst, @NameLast)
	else if @Action = 'D'
		delete Contacts where ID = @ID
	else if @Action = 'U'
		update	Contacts 
		set		NameFirst = @NameFirst,
				NameLast = @NameLast
		where	ID = @ID
	else if @Action = 'T'
		truncate table Contacts

end
