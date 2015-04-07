using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;

namespace StocksNews
{
    public partial class StocksWidgetN : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            //Response.ContentEncoding = Encoding.UTF8;
            if (!Page.IsPostBack)
            { 
                string qKey = Request.QueryString.Get("pid");
                if (!String.IsNullOrEmpty(qKey))
                {
//                    Response.Redirect("~/StocksPageN.aspx?stock="+qKey);
                    Response.Redirect("http://www.news.gr/stockdetails?symbol=" + qKey);

                }
            }
        }
    }
}