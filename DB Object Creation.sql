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

GO

alter table tSQLt.TestResultPersisted add TestCaseID int

GO

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
			TestEndTime,
			TestCaseID
	)
	select	Id,
			Class,
			TestCase,
			Name,
			TranName,
			Result,
			Msg = SUBSTRING(Msg, charindex('|', Msg) + 2, len(Msg)),
			TestStartTime,
			TestEndTime,
			TestCaseID = SUBSTRING(Msg, 0, charindex('|', Msg))
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

GO
create or alter function GetTriangleType
(
@Side1 decimal(4,2),
@Side2 decimal(4,2),
@Side3 decimal(4,2)
)
returns varchar(25)
as
begin

	declare @TriangleType varchar(25)

	-- check for valid inputs; reject anything LTE 0
	if isnull(@Side1, 0) <= 0 OR isnull(@Side2, 0) <= 0 OR isnull(@Side3, 0) <= 0
	begin
		select @TriangleType = 'Invalid Sides'
		return @TriangleType
	end

	declare @Sides table (Side int, SideLength decimal(4,2))

	insert into @Sides
	values
	(1, @Side1),
	(2, @Side2),
	(3, @Side3)

	-- determine if the sides can form a valid triangle
	-- valid defined as the 2 shortest sides added together must be longer than the longest side
	declare	@LongestSide int,
			@LongestSideLength decimal(4,2),
			@Other2SidesTotalLength decimal(4,2)

	select	top 1
			@LongestSide = Side,
			@LongestSideLength = SideLength
	from		@Sides
	order	by SideLength desc

	select	@Other2SidesTotalLength = sum(SideLength)
	from		@Sides
	where	Side <> @LongestSide

	-- first check for valid lengths, then triangle type
	if @Other2SidesTotalLength <= @LongestSideLength
	begin
		select @TriangleType = 'Invalid Lengths'
		return @TriangleType
	end

	-- determine what kind of triangle we have
	else if @Side1 = @Side2 and @Side2 = @Side3
		select @TriangleType = 'Equilateral'
	else if  @Side1 = @Side2 OR @Side2 = @Side3 OR @Side1 = @Side3
		select @TriangleType = 'Isosceles'
	else
		select @TriangleType = 'Scalene'


	return @TriangleType

end

GO

if object_id('TestCasesGetTriangleType') is not null
	drop table TestCasesGetTriangleType
GO

-- put our test cases into a table
create table TestCasesGetTriangleType (
ID int identity(1,1),
TriangleType varchar(25),
Side1 decimal(4,2),
Side2 decimal(4,2),
Side3 decimal(4,2)
)

insert into TestCasesGetTriangleType
values
('Invalid Sides', -1, -1, -1),
('Invalid Sides', 0, 0, 0),
('Invalid Sides', -1, 1, 1),
('Invalid Sides', 1, -1, 1),
('Invalid Sides', 1, 1, -1),
('Invalid Sides', 0, 1, 1),
('Invalid Sides', 1, 0, 1),
('Invalid Sides', 1, 1, 0),

('Invalid Lengths', 2.01, 1, 1),
('Invalid Lengths', 1, 2.01, 1),
('Invalid Lengths', 1, 1, 2.01),

('Equilateral', 1, 1, 1),

('Isosceles', 2, 2, 3),
('Isosceles', 2, 3, 2),
('Isosceles', 3, 2, 2),

('Scalene', 3, 4, 5),

('Isosceles', 3, 4, 5) -- invalid test

GO



