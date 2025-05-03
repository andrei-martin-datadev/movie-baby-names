USE [sanjunipero01]
GO

/****** Object:  UserDefinedFunction [dbo].[HasNonAlphabeticChar]    Script Date: 4/05/2025 12:23:37 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[HasNonAlphabeticChar]
(
    @inputString NVARCHAR(MAX)
)
RETURNS BIT
AS
BEGIN
    DECLARE @hasNonAlphabeticChar BIT = 0;
    DECLARE @currentChar NVARCHAR(1);
    DECLARE @currentIndex INT = 1;
    
    WHILE @currentIndex <= LEN(@inputString)
    BEGIN
        SET @currentChar = SUBSTRING(@inputString, @currentIndex, 1);
        
        IF @currentChar COLLATE Latin1_General_BIN NOT LIKE N'[A-Za-z ]'
        BEGIN
            SET @hasNonAlphabeticChar = 1;
            BREAK;
        END
        
        SET @currentIndex = @currentIndex + 1;
    END
    
    RETURN @hasNonAlphabeticChar;
END
GO


