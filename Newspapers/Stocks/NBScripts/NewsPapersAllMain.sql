set dateformat dmy; 
select 
Title,
paperUrl,
Category,

publ_photo,
substring(publ_photo, 0, charindex('.jpg',publ_photo))+ '_277x343.jpg' as publ_photo_277x343,
substring(publ_photo, 0, charindex('.jpg',publ_photo))+ '_213x298.jpg' as publ_photo_213x298,

publ_date,
pu.rowid as pbid,
c.CatName ,
fr.fr_title,
fr.fr_image,
(select top 5
		Title,
		paperUrl,
		Category,
		publ_photo,
		publ_date,
		pu2.rowid as pbid,
		c2.CatName ,
		fr2.fr_title,
		fr2.fr_image
		from cms_dc_newspaperpublications pu2 (nolock)
		inner join cms_dc_newspapers np2 (nolock) on publ_title = np2.ID 
		inner join cms_DC_NewsPapersCategories c2 (nolock) on c2.rowID = np2.Category 
		left join cms_DC_NewsPaperFreq fr2 on fr2.rowID = np.freq
		where 1=1 and 
			pu2.status='published' and 
			np2.status='published' and 
			c2.status='published' 
			and np2.langid=1 and 
			pu2.langid=1 
			AND DATEDIFF(d,publ_date,pu.publ_date) > 0 AND DATEDIFF(d,publ_date,pu.publ_date) < 15 
			AND
			Pub_back = pu.Pub_back 
			AND Publ_Title=pu.Publ_Title
			AND Category = np.Category
		order by publ_date desc ,Title asc 
  		FOR XML PATH('latest'),TYPE)
from cms_dc_newspaperpublications pu 
inner join cms_dc_newspapers np on publ_title = np.ID 
inner join cms_DC_NewsPapersCategories c on c.rowID = np.Category 
left join cms_DC_NewsPaperFreq fr on fr.rowID = np.freq
where 1=1
and pu.status='published' and np.status='published' and c.status='published'
and np.langid=1 and pu.langid=1
{0}
order by isnull(c.catorder,100),Title asc 
FOR XML Path('details'),ROOT('PaperesResults')