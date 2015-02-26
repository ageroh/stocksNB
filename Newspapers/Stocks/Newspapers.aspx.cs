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


namespace Newspapers
{
    public partial class WebForm1 : Common
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if(!Page.IsPostBack)
            {

                // produce XML from SQL queries.
                XmlDocument xmlDocNewsPapersPager = produceXMLfromSQL("NewsPapersPager");
                XmlDocument xmlDocNewsPaperCategories = produceXMLfromSQL("NewsPaperCategories");
                XmlDocument xmlDocdaysWithNoPublications = produceXMLfromSQL("daysWithNoPublications");

                XmlDocument xmlDocAllNewspapers = produceXMLfromSQL("NewsPapersContainer300_V2");

                //XsltSettings settings = new XsltSettings();
                //settings.EnableScript = true;
                StringWriter writer = new StringWriter();           // write results of XSL transformations 
                StringWriter writer2 = new StringWriter();
                StringWriter writer3 = new StringWriter();
                StringWriter writer4 = new StringWriter();


                if (xmlDocNewsPapersPager != null && xmlDocNewsPaperCategories != null )
                {
                    try{
                        string MyXsltPath = Server.MapPath("~/NBScripts/NewsPapersPager.xslt");
                        XslCompiledTransform XSLTransform = new XslCompiledTransform();
                        XSLTransform.Load(MyXsltPath, new XsltSettings(false, true), null);//, settings, null);
                        XSLTransform.Transform(xmlDocNewsPapersPager, null, writer);
                    }
                    catch (FileNotFoundException eex) { return; }

                    LoadHTMLPager.InnerHtml = writer.ToString();
                    
                    

                    try {
                        string MyXsltPath = Server.MapPath("~/NBScripts/NewsPaperCategories.xslt");
                        XslCompiledTransform XSLTransform = new XslCompiledTransform();
                        XSLTransform.Load(MyXsltPath, new XsltSettings(false, true), null);//, settings, null);
                        XSLTransform.Transform(xmlDocNewsPapersPager, null, writer2);
                    }
                    catch (FileNotFoundException eex){return;}

                    LoadHTMLCategories.InnerHtml = writer2.ToString();


                    try
                    {
                        string MyXsltPath = Server.MapPath("~/NBScripts/daysWithNoPublications.xslt");
                        XslCompiledTransform XSLTransform = new XslCompiledTransform();
                        XSLTransform.Load(MyXsltPath, new XsltSettings(false, true), null);//, settings, null);
                        XSLTransform.Transform(xmlDocdaysWithNoPublications, null, writer3);
                    }
                    catch (FileNotFoundException eex) { return; }

                    LoadHTMLNoPub.InnerHtml = writer3.ToString();

                    
                }

            }
        }


    }
}