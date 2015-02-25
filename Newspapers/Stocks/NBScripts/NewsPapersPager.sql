Declare @QueryStringDate nvarchar(10)
Declare @Today DateTime
Declare @Offset int
Declare @Date DateTime
BEGIN TRY
SET @Offset = 7
SET @Today = CAST(CONVERT( CHAR(8), GetDate(), 112) AS DATETIME)
--SET @QueryStringDate = QueryString.GetString('dt','')

--IF @QueryStringDate != ''
--BEGIN
--    BEGIN TRY
--        SET @Date = CONVERT(datetime,@QueryStringDate)
--    END TRY
--    BEGIN CATCH
--        SET @Date = @Today
--    END CATCH
--END
--ELSE
    SET @Date = @Today

Declare @MinDate DateTime
Declare @MaxDate DateTime
Declare @Data Table(D DateTime,HasRecords bit)


    
SET @MinDate = DATEADD(DAY,-1 * @Offset, @Date)
SET @MaxDate = DATEADD(DAY,@Offset, @Date)

IF @MaxDate > @Today
    SET @MaxDate = @Today



WHILE(@MinDate <= @MaxDate)
BEGIN
    Declare @HasData bit 
    SET @HasData = CASE WHEN (SELECT COUNT(*) FROM cms_DC_NewsPaperPublications  WHERE Publ_Date = @MinDate) > 0 THEN 1 ELSE 0 END
    INSERT INTO @Data
    SELECT @MinDate,@HasData
    SET @MinDate = DATEADD(DAY, 1, @MinDate)
END
Select 
            (@Date) As Active,
            (
                Select 
                    *
                From 
                    @Data
                FOR XML Path('Date'),TYPE
            ) As Dates
FOR XML PATH('NewsPapers')
END TRY
BEGIN CATCH
SELECT 'Error' As M
FOR XML Path('NewsPapers')
END CATCH