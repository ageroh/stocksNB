--$set cachable false
declare @isClicked int;
SET @isClicked = 0;
declare @startDate datetime;
set @startDate =GETDATE();


declare @cats as nvarchar(100);
set @cats = (select cats from cms_DC_NewsPapersWidget   where [hash]=QueryString.GetString('hash','0') 
and isActive=1)

DECLARE @CatCodes TABLE (
codes nvarchar(30) )
 
if(@cats != 'ALL')
begin
    INSERT INTO @CatCodes (codes)
    select value from dbo.Split(@cats,',')
    where Value <> ''
end
else
begin
    INSERT INTO @CatCodes (codes)
    select distinct CatCode from cms_DC_NewsPapersCategories where CatCode<>''
end

if(@isClicked=0)
begin
set dateformat dmy; 
SET @startDate = (select top 1 publ_date
                from cms_dc_newspaperpublications pu inner join cms_dc_newspapers np on publ_title = np.ID 
                inner join cms_DC_NewsPapersCategories c on c.rowID = np.Category where 1=1 and pu.status='published' 
                and np.status='published' and c.status='published' 
                and np.langid=1 and pu.langid=1     --{0}            
                 AND Pub_back = 0
                and CatCode in (select codes from @CatCodes)
                group by pu.publ_date
                having count(*)>2
                order by publ_date desc)
end;



select *
from(
select 
@startDate as shortDate
,@startDate as prevDate1
,dateadd(d,-1,@startDate) as prevDate2
,dateadd(d,-2,@startDate) as prevDate3
,dateadd(d,-3,@startDate) as prevDate4
,dateadd(d,-4,@startDate) as prevDate5
, null as codes
, 'Dates' as [type]
union
select  null as shortDate,
		null as prevDate1,
		null as prevDate2,
		null as prevDate3,
		null as prevDate4,
		null as prevDate5,
	   codes
	   , 'Codes' as [type] 
from @CatCodes
)codesAndDates
FOR XML Path('Detail'),Root('All') 
--for xml auto