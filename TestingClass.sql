

/*

testing procedures are created in the SWTest database.  

Objects being tested are in the Northwind database


*/


use SWTest

-- ****************************************************************
--- this proc expects a success and then a failure for AssertEquals
-- ****************************************************************

GO
if OBJECT_ID('TestingClass.TestSalesTax' , 'P') is not null
	drop procedure TestingClass.TestSalesTax
GO
create procedure TestingClass.TestSalesTax 
as
begin

	declare	@OrderId int = 10248

	declare	@TaxAmountProc money,
			@TaxAmountControl money,
			@OrderAmount money,
			@TaxRate decimal(4,2) = 8.25

	select	--OrderID,
			@OrderAmount = sum((UnitPrice * Quantity) * (1 - Discount)),
			@TaxAmountProc = Northwind.dbo.GetSalesTax_NW(sum((UnitPrice * Quantity) * (1 - Discount)),@TaxRate)
	from		Northwind.dbo.[Order Details] 
	where	OrderID = @OrderID
	group by	OrderID 

	select @TaxAmountControl = @OrderAmount * @TaxRate

	select	@TaxAmountControl as TaxAmountControl,
			@TaxAmountProc as TaxAmountProc

	-- expects success
	exec tSQLt.AssertEquals @TaxAmountProc, @TaxAmountControl


	select @TaxAmountControl = @OrderAmount * @TaxRate + 1 -- force a failure

	select	@TaxAmountControl as TaxAmountControl,
			@TaxAmountProc as TaxAmountProc

	-- expects failure
	declare @FailureMessage varchar(250)
	--select @FailureMessage = 'Expected: <' + cast(@TaxAmountProc as varchar(25)) + '> but was: <' + cast(@TaxAmountControl as varchar(25)) + '>; EXPECTED FAILURE'
	select @FailureMessage = 'EXPECTED FAILURE'

	exec tSQLt.AssertEquals @TaxAmountProc, @TaxAmountControl, @FailureMessage
end


-- ****************************************************************
--- this proc expects a failure for AssertEquals
-- ****************************************************************

GO
if OBJECT_ID('TestingClass.TestSalesTax2' , 'P') is not null
	drop procedure TestingClass.TestSalesTax2
GO
create procedure TestingClass.TestSalesTax2 
as
begin

	declare	@OrderId int = 10248

	declare	@TaxAmountProc money,
			@TaxAmountControl money,
			@OrderAmount money,
			@TaxRate decimal(4,2) = 8.25

	select	--OrderID,
			@OrderAmount = sum((UnitPrice * Quantity) * (1 - Discount)),
			@TaxAmountProc = Northwind.dbo.GetSalesTax_NW(sum((UnitPrice * Quantity) * (1 - Discount)),@TaxRate)
	from		Northwind.dbo.[Order Details] 
	where	OrderID = @OrderID
	group by	OrderID 

	select @TaxAmountControl = @OrderAmount * @TaxRate + 1 -- failure

	select	@TaxAmountControl as TaxAmountControl,
			@TaxAmountProc as TaxAmountProc

	-- unit test
	exec tSQLt.AssertEquals @TaxAmountProc, @TaxAmountControl;


end


-- ****************************************************************
--- this proc expects a success and then a failure for AssertEmptyTable
-- ****************************************************************



GO
if OBJECT_ID('TestingClass.TestManageContacts' , 'P') is not null
	drop procedure TestingClass.TestManageContacts
GO
create procedure TestingClass.TestManageContacts 
as
begin


	exec Northwind.dbo.ManageContacts @Action = 'T'

	-- unit test
	exec tSQLt.AssertEmptyTable 'Contacts'

	
	-- insert a record, copy the results to a temp table and test if the 2 tables are equal
	declare @ID int

	exec Northwind.dbo.ManageContacts @Action = 'I', @NameFirst = 'Mike' , @NameLast = 'Jones', @ID = @ID

	select	*
	into		#TempTable
	from		Northwind.dbo.Contacts

	exec tSQLt.AssertEqualsTable 'Northwind.dbo.Contacts', '#temp'

end

