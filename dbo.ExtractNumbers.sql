USE [sanjunipero01]
GO

/****** Object:  UserDefinedFunction [dbo].[ExtractNumbers]    Script Date: 4/05/2025 12:24:36 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE FUNCTION [dbo].[ExtractNumbers] (@inputString VARCHAR(8000))
RETURNS VARCHAR(8000)
AS
BEGIN
  DECLARE @outputString VARCHAR(8000) = ''
  DECLARE @pos INT = 1
  WHILE @pos <= LEN(@inputString)
  BEGIN
    IF SUBSTRING(@inputString, @pos, 1) BETWEEN '0' AND '9'
    BEGIN
      SET @outputString = @outputString + SUBSTRING(@inputString, @pos, 1)
    END
    SET @pos = @pos + 1
  END
  RETURN @outputString
END
GO


