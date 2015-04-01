
-- /* GMT:0 , so added +2 hours on timestamp */
WITH XMLNAMESPACES ('urn:currency' as currency,'urn:percent' as [percent],'urn:currencychange' as currencychange,'urn:percentchange' as [percentchange])
SELECT 
        (Select Max(dateadd(hour, 2, TimeStamp)) From Security Where ProductCode = 150 and dateadd(hour, 2, TimeStamp) <= GETDATE()) As [@LastUpdate],
        (
        SELECT TOP 1
              CAST([Security].[Last] AS Decimal(15,2)) As [Value],
              CAST([Security].[PercentChange] AS Decimal(15,2)) As [PChange],
              CAST( 
              (Select SUM([Security].Turnover) FROM [Security] Where 
                InstrumentType = 1
                    AND
                ProductCode = 150
              )  / 1000000  AS Decimal(15,2)) As [Volume]
        FROM [Security]
        Where 
            SymbolEng = 'GD'
        FOR XML PATH('MainIndex'),TYPE
        ),
        (
        Select 
            DISTINCT(SUBSTRING(Symbol,1,1)) As Letter
        From
            [Security]
        Where
                InstrumentType = 1
                    AND
                ProductCode = 150
        Order By SUBSTRING(Symbol,1,1) Asc
        FOR XML Path('Letter'),TYPE
        ) AS Letters,
        (
            
            Select 
					[Security].[Symbol] As [@Key],
                    SUBSTRING(Symbol,1,1) As [@Letter],
					[Category].[CategoryName] As [Category],
                    CAST([Security].[Last] AS Decimal(5,2)) As [currencychange:Price],
                    CAST([Security].[TotalVolume] AS Decimal(15,0)) As [TotalVolume],
                    CAST([Security].[PercentChange] AS Decimal(15,2)) As [percentchange:PercentChange],
                    CAST([Security].[High] AS Decimal(15,2)) As [currency:HighPrice],
                    CAST([Security].[Low] AS Decimal(15,2)) As [currency:LowPrice],
                    CAST([Security].[Close1] AS Decimal(15,2)) As [currency:PreviousPrice],
                    CAST([Security].[Bid] AS Decimal(15,2)) As [currency:BuyPrice],
                    CAST([Security].[BidSize] AS Decimal(15,0)) As [BuyVolume],
                    CAST([Security].[Ask] AS Decimal(15,2)) As [currency:SellPrice],
                    CAST([Security].[AskSize] AS Decimal(15,0)) As [SellVolume]
            From
                [Security]
                    Left Join
                [Category]
                    On
                    [Security].[CategoryNo] = [Category].[CategoryNo]
            Where
                InstrumentType = 1
                    AND
                ProductCode = 150
            Order By Symbol Asc
            FOR XML Path('Stock'),TYPE
            )
FOR XML Path('Stocks')