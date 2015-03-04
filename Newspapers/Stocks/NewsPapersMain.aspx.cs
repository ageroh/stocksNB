using System;
using System.Collections.Generic;

using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Xml.Xsl;

using System.Xml;
using System.Xml.XPath;
using System.Data.SqlTypes;

using System.Collections;
using System.IO;
using System.Text;
using System.Web.Configuration;
using NLog;


namespace Newspapers
{
    public partial class NewsPaperMain : Common
    {
        protected static DateTime theDate;
        protected static int PapersCategory;
        protected static int PublicationID;
        private static string shortDate = string.Empty;
        private static string shortDateToday = string.Empty;
        private static string codesWidget = string.Empty;
        private static int filterPageType = 1;
        protected static bool HasCodes;
        private static string[] codeArr = new string[20];
        protected static string catCodeList = string.Empty;
        protected static bool isWidget;

        public string CatCodeList
        {
            get
            {
                return catCodeList;
            }
            set
            {
                catCodeList = value;
            }
        }

        public string IsWidget
        {
            get
            {
                return isWidget.ToString();
            }
            set
            {
                isWidget = bool.Parse(value);
            }
        }


        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
//                On_Init(Convert.ToDateTime(Request.QueryString["dt"]), Request.QueryString["codesWidget"], Int32.Parse(Request.QueryString["tp"]), Int32.Parse(Request.QueryString["pct"]), Int32.Parse(Request.QueryString["pbid"]));

                On_Init(this.Request.QueryString["dt"]
                        , this.Request.QueryString["tp"]
                        , this.Request.QueryString["pct"]
                        , this.Request.QueryString["pbid"]
                );

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


                if (xmlDocNewsPapersPager != null && xmlDocNewsPaperCategories != null)
                {
                    try
                    {
                        string MyXsltPath = Server.MapPath("~/NBScripts/NewsPapersPager.xslt");
                        XslCompiledTransform XSLTransform = new XslCompiledTransform();
                        XSLTransform.Load(MyXsltPath, new XsltSettings(false, true), null);//, settings, null);
                        XSLTransform.Transform(xmlDocNewsPapersPager, null, writer);
                    }
                    catch (FileNotFoundException eex) { return; }

                    LoadHTMLPager.InnerHtml = writer.ToString();



                    try
                    {
                        string MyXsltPath = Server.MapPath("~/NBScripts/NewsPaperCategories.xslt");
                        XslCompiledTransform XSLTransform = new XslCompiledTransform();

                        
                        XsltArgumentList argsList = new XsltArgumentList();
                        if(Request.QueryString["pct"]!=null)
                            argsList.AddParam("pct", "", Request.QueryString["pct"]);

                        if (Request.QueryString["tp"] != null)
                            argsList.AddParam("tp", "", Request.QueryString["tp"]);

                        if (Request.QueryString["dt"] != null)
                            argsList.AddParam("dt", "", Request.QueryString["dt"]);

                        if (Request.QueryString["pbid"] != null)
                            argsList.AddParam("pbid", "", Request.QueryString["pbid"]);


                        XSLTransform.Load(MyXsltPath, new XsltSettings(false, true), null);//, settings, null);
                        XSLTransform.Transform(xmlDocNewsPaperCategories, argsList, writer2);
                    }
                    catch (FileNotFoundException eex) { return; }

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


                    GetPublicationDetails();

                }

            }
        }

        
        protected string GetCommandTextTestArgs()
        {
            string text = string.Empty;
            string arg = string.Empty;
            string str = string.Empty;
            string text2 = string.Empty;
            if (PapersCategory != 0 && !isWidget)
            {
                text = " AND Category= " + PapersCategory.ToString() + " ";
            }
            arg = " AND DATEDIFF(d,publ_date,'" + shortDate + "')=0 ";
            if (isWidget)
            {
                arg = " AND DATEDIFF(d,publ_date,'" + shortDateToday + "')=0 ";
            }
            if (HasCodes)
            {
                int num = 1;
                string[] array = codeArr;
                for (int i = 0; i < array.Length; i++)
                {
                    string text3 = array[i];
                    if (!String.IsNullOrEmpty(text3))
                    {
                        if (num == 1)
                        {
                            text2 = text2 + " catcode='" + text3 + "'";
                        }
                        else
                        {
                            text2 = text2 + " OR catcode='" + text3 + "'";
                        }
                    }
                    num++;
                }
                if (!String.IsNullOrEmpty(text2))
                {
                    str = " AND ( " + text2 + ")";
                    text += str;
                }
            }
            return arg + text;

        }
        


        private bool TodayHasPapers()
        {
            int num = 0;
            try
            {
                XmlDocument xmlDocCheckTodayPapers = produceXMLfromSQL("NewsPapersList", this.GetCommandTextTestArgs());
                if (xmlDocCheckTodayPapers != null)
                {
                    XmlNodeList Titles = xmlDocCheckTodayPapers.SelectNodes("/All/Day/Title");
                    foreach (XmlNode nextNode in Titles)
                    {
                        num++;
                    }
                }
            }
            catch (Exception ex)
            {
                Logger currentClassLogger = LogManager.GetCurrentClassLogger();
                currentClassLogger.Debug("query errror.NewsPapers", ex.ToString());
            }
            
            // if Today has more than One newspaper then show them ?
            if (num >= 1)
            {
                return true;
            }
            return false;
        }

        protected void HandleCodes()
        {
            int num = 0;
            string text = this.CatCodeList;
            if (codesWidget != "0")
            {
                text = codesWidget;
            }
            if (!String.IsNullOrEmpty(text))
            {
                string[] array = text.Split(new char[]
				{
					','
				});
                string[] array2 = array;
                for (int i = 0; i < array2.Length; i++)
                {
                    string text2 = array2[i];
                    SqlDataReader sqlDataReader = this.CodeExists(text2);
                    try
                    {
                        if (sqlDataReader.HasRows)
                        {
                            while (sqlDataReader.Read())
                            {
                                if (sqlDataReader["catcode"] != null)
                                {
                                    HasCodes = true;
                                    codeArr[num] = text2;
                                    num++;
                                }
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        Logger currentClassLogger = LogManager.GetCurrentClassLogger();
                        currentClassLogger.Debug("query errror.NewsPapers", ex.ToString());
                    }
                    finally
                    {
                        sqlDataReader.Close();
                    }
                }
            }
        }

        // used as constructor..
        protected void On_Init(string dtStr, string tp = "1", string pct = "0", string pbid = "0")
        {
            theDate = (String.IsNullOrEmpty(dtStr)) ? DateTime.Now : Convert.ToDateTime(dtStr, CultureInfo.CurrentUICulture); 
            shortDate = theDate.ToString("d/M/yyyy");
            shortDateToday = DateTime.Now.ToString("d/M/yyyy");
            //codesWidget = codesWidget;
            filterPageType = (String.IsNullOrEmpty(tp)) ? 1 : Int32.Parse(tp); 
            //HandleCodes();
            if (! TodayHasPapers())
            {
                theDate = (dtStr == null) ? DateTime.Now : Convert.ToDateTime(dtStr, CultureInfo.CurrentUICulture);
                theDate = theDate.AddDays(-1.0);    // Bring one day before ! no!
                shortDate = theDate.ToString("d/M/yyyy");
                shortDateToday = DateTime.Now.AddDays(-1.0).ToString("d/M/yyyy");
            }
            PapersCategory = (String.IsNullOrEmpty(pct)) ? 0 : Int32.Parse(pct); 
            PublicationID = (String.IsNullOrEmpty(pbid)) ? 0 : Int32.Parse(pbid);  
            
        }



        protected void LoadXslParameters(XsltArgumentList Args)
        {

            string parameter = string.Empty;
            if (PublicationID != 0)
            {
                parameter = this.GetPublicationDetails();
            }
            else
            {
                parameter = "0";
            }
            string parameter2 = this.CatCodeList;
            if (codesWidget != "0")
            {
                parameter2 = codesWidget;
            }
        }
         //   Args.AddParam("PublicationString", string.Empty, parameter);
         //   Args.AddParam("CodesWidget", string.Empty, parameter2);
         //   Args.AddParam("PapersCategory", string.Empty, this.PapersCategory);
        

        protected string GetParamsSQL()
        {
            
            //command :
            string text = string.Empty;
            string arg = string.Empty;
            string str = string.Empty;
            string text2 = string.Empty;
            string arg2 = string.Empty;
            if (filterPageType == 1)
            {
                arg2 = " AND Pub_back = 0 ";
            }
            else
            {
                arg2 = " AND Pub_back = 1 ";
            }
            if (PapersCategory != 0 && !isWidget)
            {
                text = " AND Category= " + PapersCategory.ToString() + " ";
            }
            
            if( Convert.ToDateTime(shortDate) > DateTime.Now)
                arg = " AND DATEDIFF(d,publ_date,'" + DateTime.Now.ToShortDateString() + "')=0 ";
            else
                arg = " AND DATEDIFF(d,publ_date,'" + shortDate + "')=0 ";
            if (isWidget)
            {
                arg = " AND DATEDIFF(d,publ_date,'" + shortDateToday + "')=0 ";
            }
            if (HasCodes)
            {
                int num = 1;
                string[] array = codeArr;
                for (int i = 0; i < array.Length; i++)
                {
                    string text3 = array[i];
                    if (!String.IsNullOrEmpty(text3))
                    {
                        if (num == 1)
                        {
                            text2 = text2 + " catcode='" + text3 + "'";
                        }
                        else
                        {
                            text2 = text2 + " OR catcode='" + text3 + "'";
                        }
                    }
                    num++;
                }
                if (!String.IsNullOrEmpty(text2))
                {
                    str = " AND ( " + text2 + ")";
                    text += str;
                }
            }
            
            return arg + text + arg2;

        }



        private string GetPublicationDetails()
        {
            string result = string.Empty;

            XmlDocument xmlDocNewsPapersList = produceXMLfromSQL("NewsPapersAllMain", GetParamsSQL());
            StringWriter writerHTML = new StringWriter();


            try
            {
                string MyXsltPath = Server.MapPath("~/NBScripts/NewsPapersAllMain.xslt");
                XslCompiledTransform XSLTransform = new XslCompiledTransform();
                XSLTransform.Load(MyXsltPath, new XsltSettings(false, true), null);//, settings, null);
                XSLTransform.Transform(xmlDocNewsPapersList, null, writerHTML);
            }
            catch (FileNotFoundException eex) {  }

            NewsPapersListNew.InnerHtml = writerHTML.ToString();


            // tb_show ?
            //result = string.Concat(new string[]
            //{
            //    "tb_show(\"",
            //    readerPublication.GetSqlValue(0).ToString(),
            //    " - ",
            //    readerPublication.GetSqlValue(1).ToString(),
            //    "\",\"http://",
            //    this.Request.ServerVariables["SERVER_NAME"],
            //    "/",
            //    readerPublication.GetSqlValue(3).ToString(),
            //    "\")"
            //});
            return result;
        }

        protected string GetCommandTextPub()
        {
            string text = string.Empty;
            string arg = string.Empty;
            string empty = string.Empty;
            int arg_1A_0 = filterPageType;
            if (PapersCategory != 0)
            {
                bool arg_29_0 = isWidget;
            }
            arg = " AND DATEDIFF(d,publ_date,'" + shortDate + "')=0 ";
            if (isWidget)
            {
                arg = " AND DATEDIFF(d,publ_date,'" + shortDateToday + "')=0 ";
            }
            if (PublicationID != 0 && !isWidget)
            {
                text = text + " AND pu.rowid= " + PublicationID.ToString() + " ";
            }
            return arg + text;
        }


        protected SqlDataReader CodeExists(string CatCode)
        {
            string query = "select catcode from cms_DC_NewsPapersCategories (nolock) where catcode=@catcode and langid=1 and status='published'";
            SqlCommand command = new SqlCommand(query, new SqlConnection(getConStringSQL()));
            command.Parameters.AddWithValue("@catcode", CatCode);
            return command.ExecuteReader(CommandBehavior.CloseConnection);
        }


    }


}