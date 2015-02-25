set dateformat ymd

Declare @startdate datetime
Declare @enddate datetime
Set @startdate='08/08/2010'
Set @enddate=(select distinct 
cast([dbo].[zeroFiller](month(GETDATE())) as nvarchar(10))
+'-'+
cast([dbo].[zeroFiller](day(GETDATE())) as nvarchar(10)) 
+'-'+
cast([dbo].[zeroFiller](year(GETDATE())) as nvarchar(10))
)



Select dateadd(day,number,@startdate) as daysWithNoPublications from master.dbo.spt_values 
where master.dbo.spt_values.type='p' and dateadd(day,number,@startdate)<=@enddate
and dateadd(day,number,@startdate) not in 
(select distinct 
cast(year(Publ_Date) as nvarchar(10))
+'-'+
cast([dbo].[zeroFiller](month(Publ_Date)) as nvarchar(10)) 
+'-'+
cast([dbo].[zeroFiller](day(Publ_Date)) as nvarchar(10))
+' 00:00:00.000'
from cms_DC_NewsPaperPublications)
FOR XML Path('day'),Root('Nopub') 