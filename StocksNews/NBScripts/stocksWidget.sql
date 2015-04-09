--$ADD timedep 5
DECLARE @Offset INT
DECLARE @DayOfWeek INT
SELECT @DayOfWeek = DATEPART(WEEKDAY, GETDATE())

SET @Offset = CASE WHEN 
                @DayOfWeek BETWEEN 2 AND 3 THEN -5  -- Monday, Tuesday (Sunday is the first day of the week)
                ELSE -3 
            END

-- /* GMT:0 , so added +2 hours on timestamp */
SELECT 
        (Select Max( dateadd(hour, 2, TimeStamp)) From Security Where ProductCode = 150 and dateadd(hour, 2, TimeStamp) <= GETDATE()) As LastUpdate,
          (
        SELECT TOP 1
              CAST([Security].[Last] AS Decimal(15,2)) As [gd],
              CAST([Security].[PercentChange] AS Decimal(15,2)) As [gdc]
        FROM [Security]
        Where 
            SymbolEng = 'GD'
        FOR XML PATH('MainIndex'),TYPE
        ),
        (
            
            Select 
                    [Security].[Symbol] As [@Key],
                    CAST(ISNULL([Security].[Last],0) AS Decimal(5,2)) As [a],
                    CAST(ISNULL([Security].[NetChange],0) AS Decimal(15,2)) As [c],
                    CAST(ISNULL([Security].[PercentChange],0) AS Decimal(15,2)) As [b],
                    CAST(ISNULL([Security].Volume,0) AS Decimal(15,0)) As [d]
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
                    AND dateadd(hour, 2, [Security].[TimeStamp])  >= DATEADD(DAY,@Offset, GETDATE())
            Order By Symbol Asc
            FOR XML Path('Stock'),TYPE
        )
FOR XML Path('Stocks')
