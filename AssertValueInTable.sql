USE [SWTEST]
GO

/****** Object:  StoredProcedure [tSQLt].[AssertValueInTable]    Script Date: 4/12/2020 6:35:16 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create  or alter  PROCEDURE [tSQLt].[AssertValueInTable]
  @TableName varchar(max),
  @ColumnName nvarchar(max),
  @ValueToCheck int ,
  @Message NVARCHAR(MAX) = ''
AS
BEGIN
begin try

  EXEC tSQLt.AssertObjectExists @TableName;

  DECLARE @FullName NVARCHAR(MAX);
  IF(OBJECT_ID(@TableName) IS NULL AND OBJECT_ID('tempdb..'+@TableName) IS NOT NULL)
  BEGIN
    SET @FullName = CASE WHEN LEFT(@TableName,1) = '[' THEN @TableName ELSE QUOTENAME(@TableName)END;
  END;
  ELSE
  BEGIN
    SET @FullName = tSQLt.Private_GetQuotedFullName(OBJECT_ID(@TableName));
  END;

  DECLARE @cmd NVARCHAR(MAX);
  DECLARE @exists INT;
 -- SET @cmd = 'SELECT @exists = CASE WHEN EXISTS(SELECT 1 FROM '+@FullName+') THEN 1 ELSE 0 END;'
 set @cmd='select @exists = case when exists (select 1 from '+@FullName+' where '+@ColumnName+' = '+cast(@ValueToCheck as nvarchar(max))+') then 1 else 0 end;'
  EXEC sp_executesql @cmd,N'@exists INT OUTPUT', @exists OUTPUT;

    
  IF(@exists <> 1)
  BEGIN
    DECLARE @TableToText NVARCHAR(MAX);
    EXEC tSQLt.TableToText @TableName = @FullName,@txt = @TableToText OUTPUT;
    DECLARE @Msg NVARCHAR(MAX);
	declare  @ErrorMessage varchar(150)= @FullName + ' was not empty:' + CHAR(13) + CHAR(10)+ @TableToText;
	RAISERROR (@ErrorMessage, 16, 11)
  END
end try
begin catch
	set @ErrorMessage  =  'Exception was thrown'  ;
	RAISERROR (@ErrorMessage, 16, 11)
end catch

END

GO


