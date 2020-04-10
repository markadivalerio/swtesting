USE [SWTest]
GO


create or alter PROCEDURE [tSQLt].[AssertLesserThan]
    @Lesser SQL_VARIANT,
    @Greater SQL_VARIANT,
    @Message NVARCHAR(MAX) = ''
AS
BEGIN
    IF @Lesser < @Greater 
		AND @Lesser IS NOT NULL 
		AND @Greater IS NOT NULL
      RETURN 0;

    DECLARE @Msg NVARCHAR(MAX);
    SELECT @Msg =ISNULL(CAST(@Lesser AS NVARCHAR(MAX)), 'NULL') + 
                  ' is NOT less than ' + ISNULL(CAST(@Greater AS NVARCHAR(MAX)), 'NULL');
    IF((COALESCE(@Message,'') <> '') AND (@Message NOT LIKE '% ')) SET @Message = @Message + ' ';
    EXEC tSQLt.Fail @Message, @Msg;
END;
