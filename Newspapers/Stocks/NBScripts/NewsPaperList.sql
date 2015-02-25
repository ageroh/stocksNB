set dateformat dmy;
select Title,paperUrl,Category,publ_photo,publ_date,pu.rowid,c.CatName
from cms_dc_newspaperpublications pu
inner join cms_dc_newspapers np 
	on publ_title = np.ID
inner join cms_DC_NewsPapersCategories c 
	on c.rowID = np.Category
where  1=1
and pu.status='published' and np.status='published' and c.status='published'
and np.langid=1 and pu.langid=1
{0}
order by cast(isnull(c.catorder,100) as int),Title asc
FOR XML AUTO