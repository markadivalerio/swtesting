

create or alter procedure TestingClass.TestGetTriangleType 
as
begin


	--exec tSQLt.AssertEquals 1, 2, 'fail'
	
	--return

	declare	@TriangleTypeActual varchar(25),
			@TriangleTypeExpected varchar(25)

	-- put our test cases into a table
	declare @TestCases table (
	ID int identity(1,1),
	TriangleType varchar(25),
	Side1 decimal(4,2),
	Side2 decimal(4,2),
	Side3 decimal(4,2)
	)

	insert into @TestCases
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

	declare	@TestCasesCount int,
			@ID int = 1,
			@Side1 decimal(4,2),
			@Side2 decimal(4,2),
			@Side3 decimal(4,2),
			@Message varchar(50)

	select @TestCasesCount = count(*) from @TestCases

	-- loop thru the test cases
	while @ID <= @TestCasesCount
	begin
		
		select	@Side1 = Side1,
				@Side2 = Side2,
				@Side3 = Side3,
				@TriangleTypeExpected = TriangleType
		from		@TestCases 
		where	ID = @ID 
		
		-- call the function we are testing
		select @TriangleTypeActual = dbo.GetTriangleType(@Side1, @Side2, @Side3)


		select @Message =   cast(@ID as varchar(3)) + '| ' + cast(@Side1 as varchar(5)) + ', ' +  + cast(@Side2 as varchar(5)) + ', ' +  + cast(@Side3 as varchar(5))

--		print cast(@ID as varchar(3)) + ': ' + @TriangleTypeActual + ', ' + @TriangleTypeExpected + '; ' + cast(@Side1 as varchar(5)) + ', ' +  + cast(@Side2 as varchar(5)) + ', ' +  + cast(@Side3 as varchar(5))
		exec tSQLt.AssertEquals @Expected = @TriangleTypeExpected, @Actual = @TriangleTypeActual, @Message = @Message

		select @ID = @ID + 1
	end


end
GO


