set dateformat dmy; 
select 
Title,
paperUrl,
Category,
publ_photo,
substring(publ_photo, 0, charindex('.jpg',publ_photo))+ '_277x343.jpg' as publ_photo_277x343,
publ_date,
pu.rowid as pbid,
c.CatName 
from cms_dc_newspaperpublications pu 
inner join cms_dc_newspapers np on publ_title = np.ID 
inner join cms_DC_NewsPapersCategories c on c.rowID = np.Category 
where 1=1
and pu.status='published' and np.status='published' and c.status='published'
and np.langid=1 and pu.langid=1
and np.Category != 9
{0}
order by isnull(c.catorder,100),Title asc ,Pub_back asc
FOR XML Path('details'),ROOT('PaperesResults')