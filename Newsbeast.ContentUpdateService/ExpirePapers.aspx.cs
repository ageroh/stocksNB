using System;
using System.Collections.Specialized;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;
using System.Configuration;
using Netvolution.Site.Engine.UrlRewriter;
using System.Net;
using System.Xml;
using System.IO;
using Netvolution.Common.Entities;
using Atcom.Site.Modules.DataAccess;






public partial class ExpirePapers : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Type DataCatalogType = Type.GetType(string.Format("Netvolution.Common.Entities.Dc{0},DC{0}", "NewsPaperPublications"), true);
        Utilities.Cache.ExpireEntity(DataCatalogType);
        Response.Write("OK");
    }
}
