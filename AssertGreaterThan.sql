USE [tSQLt_Example]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [tSQLt].AssertGreaterThan
    @Param1 SQL_VARIANT, 
    @Param2 SQL_VARIANT,
    @Message NVARCHAR(MAX) = ''
AS
BEGIN
    IF @Param1 IS NOT NULL AND @Param2 IS NOT NULL
        AND @Param1 > @Param2
      RETURN 0;

    DECLARE @Msg NVARCHAR(MAX);
    SELECT @Msg = 'Param1 <' + ISNULL(CAST(@Param1 AS NVARCHAR(MAX)), 'NULL') + 
                  '> was not Greater Than Param2 <' + ISNULL(CAST(@Param2 AS NVARCHAR(MAX)), 'NULL') + '>';
    IF((COALESCE(@Message,'') <> '') AND (@Message NOT LIKE '% ')) SET @Message = @Message + ' ';
    EXEC tSQLt.Fail @Message, @Msg;
END;
