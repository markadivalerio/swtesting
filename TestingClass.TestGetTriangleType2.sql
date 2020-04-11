

create or alter procedure TestingClass.TestGetTriangleType2
as
begin


	--exec tSQLt.AssertEquals 1, 2, 'fail'
	
	--return

	declare	@TriangleTypeActual varchar(25),
			@TriangleTypeExpected varchar(25)

	declare	@TestCasesCount int,
			@ID int = 1,
			@Side1 decimal(4,2),
			@Side2 decimal(4,2),
			@Side3 decimal(4,2),
			@Message varchar(50)

	select @TestCasesCount = count(*) from TestCasesGetTriangleType

	-- loop thru the test cases
	while @ID <= @TestCasesCount
	begin
		
		select	@Side1 = Side1,
				@Side2 = Side2,
				@Side3 = Side3,
				@TriangleTypeExpected = TriangleType
		from		TestCasesGetTriangleType 
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


