--$ADD dep DcNewsPapersCategories,DcNewsPapersCategories

select 
    rowid as catID,
    Catname As Catname
from 
    cms_dc_newspapersCategories 
where 
    langid=QueryString.GetInt('la',1)
        and Active=1 and
    status='published' 
order by cast(isnull(catorder,100) as int)
FOR XML Path('details'),Root('CatsResults') 