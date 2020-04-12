USE [SWTEST]
GO
/****** Object:  StoredProcedure [tSQLt].[AssertIntegerInBetween]    Script Date: 4/12/2020 6:33:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create OR ALTER   PROCEDURE [tSQLt].[AssertIntegerInBetween]
  @InputValue int,
  @LowerRange int ,
  @HeigherRange int ,
  @Message NVARCHAR(MAX) = ''
AS
BEGIN
Declare @ErrorMessage varchar(max)

if(@LowerRange<=@InputValue and @HeigherRange>=@InputValue)
begin
return 0;
end
else
begin
set @ErrorMessage=':'+CAST(@InputValue AS NVARCHAR(MAX)) + ' is not in between '+CAST(@LowerRange AS NVARCHAR(MAX)) +' and '+CAST(@HeigherRange AS NVARCHAR(MAX));
  EXEC tSQLt.Fail @Message, @ErrorMessage;
end;
  
END;
