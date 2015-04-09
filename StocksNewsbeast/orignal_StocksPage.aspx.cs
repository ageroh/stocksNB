using System.Web;
using System.Data.SqlClient;
using System;

using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;
using System.Xml.XPath;
using System.Xml.Xsl;
using System.Data.SqlTypes;

using System.Collections;
using System.IO;
using System.Text;
using System.Web.Configuration;
using System.Collections.Generic;


namespace StocksNews
{
    public partial class orignal_StocksPage : Common
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if(!Page.IsPostBack)
            {
                //Response.ContentEncoding = Encoding.UTF8;
                string v = "stocksIndex";
                XmlDocument xmlDoc = produceXMLfromSQL(v);

                if( xmlDoc != null)
                {
                    try{
                        string MyXsltPath = Server.MapPath("~/NBScripts/" + v + ".xslt");

                        XslCompiledTransform XSLTransform = new XslCompiledTransform();
                        XsltSettings settings = new XsltSettings();
                        settings.EnableScript = true;
                        XSLTransform.Load(MyXsltPath, new XsltSettings(false, true), null);//, settings, null);
                        
                        StringWriter writer = new StringWriter();
                        
                        XSLTransform.Transform(xmlDoc, null , writer);
                        LoadHTML.InnerHtml = writer.ToString();

                    }
                    catch(FileNotFoundException eex)
                    {
                        return;
                    }

                }

            }
        }


    }
}