USE [sanjunipero01]
GO

/****** Object:  UserDefinedFunction [dbo].[ConvertNonBasicLatinToBasic]    Script Date: 4/05/2025 12:24:06 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[ConvertNonBasicLatinToBasic]
(
    @inputString NVARCHAR(MAX)
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
    DECLARE @outputString NVARCHAR(MAX) = @inputString;
    
    -- Mapping table for non-basic Latin characters to basic Latin equivalents
    DECLARE @characterMap TABLE
    (
        NonBasicChar NVARCHAR(1) COLLATE Latin1_General_BIN,
        BasicChar NVARCHAR(1) COLLATE Latin1_General_BIN
    );
    
    -- Populate the mapping table with desired replacements
    INSERT INTO @characterMap (NonBasicChar, BasicChar)
    VALUES
        -- Add your non-basic Latin character mappings here
    (N'À', N'A'), (N'Á', N'A'), (N'Â', N'A'), (N'Ã', N'A'), (N'Ä', N'A'), (N'Å', N'A'),
    (N'Æ', N'A'), (N'Ç', N'C'), (N'È', N'E'), (N'É', N'E'), (N'Ê', N'E'), (N'Ë', N'E'),
    (N'Ì', N'I'), (N'Í', N'I'), (N'Î', N'I'), (N'Ï', N'I'), (N'Ð', N'D'), (N'Ñ', N'N'),
    (N'Ò', N'O'), (N'Ó', N'O'), (N'Ô', N'O'), (N'Õ', N'O'), (N'Ö', N'O'), (N'Ø', N'O'),
    (N'Ù', N'U'), (N'Ú', N'U'), (N'Û', N'U'), (N'Ü', N'U'), (N'Ý', N'Y'), (N'Þ', N'T'),
    -- (N'ß', N'ss'),
	(N'à', N'a'), (N'á', N'a'), (N'â', N'a'), (N'ã', N'a'), (N'ä', N'a'),
    (N'å', N'a'), (N'æ', N'a'), (N'ç', N'c'), (N'è', N'e'), (N'é', N'e'), (N'ê', N'e'),
    (N'ë', N'e'), (N'ì', N'i'), (N'í', N'i'), (N'î', N'i'), (N'ï', N'i'), (N'ð', N'd'),
    (N'ñ', N'n'), (N'ò', N'o'), (N'ó', N'o'), (N'ô', N'o'), (N'õ', N'o'), (N'ö', N'o'),
    (N'ø', N'o'), (N'ù', N'u'), (N'ú', N'u'), (N'û', N'u'), (N'ü', N'u'), (N'ý', N'y'),
    (N'þ', N't'), (N'ÿ', N'y'),
    (N'Ā', N'A'), (N'ā', N'a'), (N'Ă', N'A'), (N'ă', N'a'), (N'Ą', N'A'), (N'ą', N'a'),
    (N'Ć', N'C'), (N'ć', N'c'), (N'Ĉ', N'C'), (N'ĉ', N'c'), (N'Ċ', N'C'), (N'ċ', N'c'),
    (N'Č', N'C'), (N'č', N'c'), (N'Ď', N'D'), (N'ď', N'd'), (N'Đ', N'D'), (N'đ', N'd'),
    (N'Ē', N'E'), (N'ē', N'e'), (N'Ĕ', N'E'), (N'ĕ', N'e'), (N'Ė', N'E'), (N'ė', N'e'),
    (N'Ę', N'E'), (N'ę', N'e'), (N'Ě', N'E'), (N'ě', N'e'), (N'Ĝ', N'G'), (N'ĝ', N'g'),
    (N'Ğ', N'G'), (N'ğ', N'g'), (N'Ġ', N'G'), (N'ġ', N'g'), (N'Ģ', N'G'), (N'ģ', N'g'),
    (N'Ĥ', N'H'), (N'ĥ', N'h'), (N'Ħ', N'H'), (N'ħ', N'h'), (N'Ĩ', N'I'), (N'ĩ', N'i'),
    (N'Ī', N'I'), (N'ī', N'i'), (N'Ĭ', N'I'), (N'ĭ', N'i'), (N'Į', N'I'), (N'į', N'i'),
    (N'İ', N'I'), (N'ı', N'i'), (N'Ĳ', N'I'), (N'ĳ', N'i'), (N'Ĵ', N'J'), (N'ĵ', N'j'),
    (N'Ķ', N'K'), (N'ķ', N'k'), (N'ĸ', N'k'), (N'Ĺ', N'L'), (N'ĺ', N'l'), (N'Ļ', N'L'),
    (N'ļ', N'l'), (N'Ľ', N'L'), (N'ľ', N'l'), (N'Ŀ', N'L'), (N'ŀ', N'l'), (N'Ł', N'L'),
    (N'ł', N'l'), (N'Ń', N'N'), (N'ń', N'n'), (N'Ņ', N'N'), (N'ņ', N'n'), (N'Ň', N'N'),
    (N'ň', N'n'), (N'ŉ', N'n'), (N'Ŋ', N'N'), (N'ŋ', N'n'), (N'Ō', N'O'), (N'ō', N'o'),
    (N'Ŏ', N'O'), (N'ŏ', N'o'), (N'Ő', N'O'), (N'ő', N'o'), (N'Œ', N'O'), (N'œ', N'o'),
    (N'Ŕ', N'R'), (N'ŕ', N'r'), (N'Ŗ', N'R'), (N'ŗ', N'r'), (N'Ř', N'R'), (N'ř', N'r'),
    (N'Ś', N'S'), (N'ś', N's'), (N'Ŝ', N'S'), (N'ŝ', N's'), (N'Ş', N'S'), (N'ş', N's'),
    (N'Š', N'S'), (N'š', N's'), (N'Ţ', N'T'), (N'ţ', N't'), (N'Ť', N'T'), (N'ť', N't'),
    (N'Ŧ', N'T'), (N'ŧ', N't'), (N'Ũ', N'U'), (N'ũ', N'u'), (N'Ū', N'U'), (N'ū', N'u'),
    (N'Ŭ', N'U'), (N'ŭ', N'u'), (N'Ů', N'U'), (N'ů', N'u'), (N'Ű', N'U'), (N'ű', N'u'),
    (N'Ų', N'U'), (N'ų', N'u'), (N'Ŵ', N'W'), (N'ŵ', N'w'), (N'Ŷ', N'Y'), (N'ŷ', N'y'),
    (N'Ÿ', N'Y'), (N'Ź', N'Z'), (N'ź', N'z'), (N'Ż', N'Z'), (N'ż', N'z'), (N'Ž', N'Z'),
    (N'ž', N'z')
	;

    DECLARE @currentIndex INT = 1;
    
    WHILE @currentIndex <= LEN(@outputString)
    BEGIN
        DECLARE @currentChar NVARCHAR(1);
        SET @currentChar = SUBSTRING(@outputString, @currentIndex, 1);
        
        IF EXISTS (SELECT 1 FROM @characterMap WHERE NonBasicChar = @currentChar)
        BEGIN
            SET @outputString = STUFF(@outputString, @currentIndex, 1, (SELECT BasicChar FROM @characterMap WHERE NonBasicChar = @currentChar));
        END
        
        SET @currentIndex = @currentIndex + 1;
    END
    
    RETURN @outputString;
END
GO


