--$ADD timedep 3
--$SET contentType text/xml

DECLARE @Offset INT
DECLARE @DayOfWeek INT
SELECT @DayOfWeek = DATEPART(WEEKDAY, GETDATE())

SET @Offset = CASE WHEN 
                @DayOfWeek BETWEEN 2 AND 3 THEN -5  -- Monday, Tuesday (Sunday is the first day of the week)
                ELSE -3 
            END


DECLARE @latestDateTime datetime
Select @latestDateTime = Max(dateadd(hour, 2, TimeStamp)) From Security Where ProductCode = 150 and dateadd(hour, 2, TimeStamp) <= GETDATE()


SELECT 
         'Τελευταία ενημέρωση: ' + CONVERT(VARCHAR, @latestDateTime, 103) + ' ' + CONVERT(VARCHAR, @latestDateTime, 108) As t,
        (
            Select 
                    [Security].[Symbol] As [@s],
                    REPLACE(CAST([Security].[Last] AS Decimal(5,2)),'.',',') As [@l],
                    REPLACE(CAST([Security].[NetChange] AS Decimal(15,2)),'.',',') As [@c],
                    REPLACE(CAST([Security].[PercentChange] AS Decimal(15,2)),'.',',') As [@p],
                    CAST([Security].Volume AS Decimal(15,0)) As [@v]
            From
                [Security]
                    Left Join
                [Category]
                    On
                    [Security].[CategoryNo] = [Category].[CategoryNo]
            Where
                InstrumentType = 1
                    AND
                ProductCode = 150 -- 1 for real time
                      AND  dateadd(hour, 2, [Security].[TimeStamp]) >= DATEADD(DAY,@Offset, GETDATE())
            Order By Symbol Asc
            FOR XML Path('m'),TYPE
        )
        
FOR XML Path('tickdata')