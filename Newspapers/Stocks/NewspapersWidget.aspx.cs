using System.Web;
using System.Data.SqlClient;
using System;

using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;
using System.Xml.XPath;
using System.Xml.Xsl;
using System.Data.SqlTypes;
using NLog;

using System.Collections;
using System.IO;
using System.Text;
using System.Web.Configuration;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Web.UI.HtmlControls;
using ImageResizer;



namespace Newspapers
{
    public partial class NewsPaperWidget : Common
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if(!Page.IsPostBack)
            {
                OnInit( this.Request.QueryString["dt"]
                        , this.Request.QueryString["codesWidget"]
                        , this.Request.QueryString["hash"]
                        , this.Request.QueryString["tp"]
                        , this.Request.QueryString["pbid"]
                        , this.Request.QueryString["isClicked"]
                );

                StringWriter writer4 = new StringWriter();
                StringWriter WidgetNP = new StringWriter();


                XmlDocument xmlDocWidgetcontainer = produceXMLfromSQL("NewsPapersContainer300_V2");
                XmlDocument xmlDocAllNewspapers = produceXMLfromSQL("NewsPapersWidget", GetArgs(0));

                try
                {
                    string MyXsltPath = Server.MapPath("~/NBScripts/NewsPapersContainer300_V2.xslt");
                    XslCompiledTransform XSLTransform = new XslCompiledTransform();
                    XSLTransform.Load(MyXsltPath, new XsltSettings(false, true), null);//, settings, null);
                    XSLTransform.Transform(xmlDocWidgetcontainer, null, writer4);
                }
                catch (FileNotFoundException eex) { return; }



                try
                {
                    string MyXsltPath = Server.MapPath("~/NBScripts/NewsPapersWidget.xslt");
                    XslCompiledTransform XSLTransform = new XslCompiledTransform();
                    XSLTransform.Load(MyXsltPath, new XsltSettings(false, true), null);//, settings, null);
                    XSLTransform.Transform(xmlDocAllNewspapers, null, WidgetNP);
                }
                catch (FileNotFoundException eex) { return; }

                //HtmlGenericControl divControl = new HtmlGenericControl();
                // divControl = this.Page.FindControl("mainFrame");
                WidgetContainer.InnerHtml = writer4.ToString().Replace("<span>DYNAMICALLY_ADD_CONTENT</span>", WidgetNP.ToString());
                    
            }
        }



        [System.Web.Services.WebMethod(BufferResponse = false)]
        public string RefreshNewspapers(string dtStr, string codesWidget, string hash, string tp, string pbid, string isClicked)
        {
            OnInit(dtStr,codesWidget, hash,tp, pbid,isClicked);

            StringWriter WidgetNP = new StringWriter();
            XmlDocument xmlDocAllNewspapers = produceXMLfromSQL("NewsPapersWidget", GetArgs(0));
            try
            {
                string MyXsltPath = Server.MapPath("~/NBScripts/NewsPapersWidget.xslt");
                XslCompiledTransform XSLTransform = new XslCompiledTransform();
                XSLTransform.Load(MyXsltPath, new XsltSettings(false, true), null);//, settings, null);
                XSLTransform.Transform(xmlDocAllNewspapers, null, WidgetNP);
            }
            catch (FileNotFoundException eex) { return ""; }

            // return new htnl content to replace div.
            return WidgetNP.ToString();
        }


        protected string day1 = "";
        protected string day2 = "";
        protected string day3 = "";
        protected string day4 = "";
        protected string day5 = "";
        protected string shortDateFull = "";
        protected string CatsSelected;
        protected string hash;
        protected DateTime theDate;
        protected int PublicationID;
        private string shortDate = string.Empty;
        private string whereCatsSql = "";
        private string shortDateToday = string.Empty;
        private string codesWidget = string.Empty;
        private int filterPageType = 1;
        protected bool HasCodes;
        private string[] codeArr = new string[20];
        private int isClicked;
        protected string catCodeList = string.Empty;
        protected bool isWidget = true;
        protected bool isSmallWidget;
        public string CatCodeList
        {
            get
            {
                return this.catCodeList;
            }
            set
            {
                this.catCodeList = value;
            }
        }
        public string IsSmallWidget
        {
            get
            {
                return this.isSmallWidget.ToString();
            }
            set
            {
                this.isSmallWidget = bool.Parse(value);
            }
        }


        public static DateTime ToDateTime(String value)
        {
            if (value == null)
                return new DateTime(0);
            return DateTime.Parse(value, CultureInfo.CurrentCulture);
        }


        // ?hash=f195477fb09fcd400d8f77d7b38e5d73&dt=20150224
        protected void OnInit(string dtStr, string codesWidget, string hash, string tp = "1", string pbid = "0", string isClicked = "1")
        {
            DateTime dt = (dtStr == null )? DateTime.Now : Convert.ToDateTime(dtStr, CultureInfo.CurrentUICulture);
            this.isClicked = (isClicked == null) ? 1: Int32.Parse(isClicked); 
            this.theDate = dt;
            this.shortDate = this.theDate.ToString("d/M/yyyy");
            this.shortDateFull = this.theDate.ToString("s");
            this.day1 = DateTime.Now.ToString("s");
            this.day2 = DateTime.Now.AddDays(-1.0).ToString("s");
            this.day3 = DateTime.Now.AddDays(-2.0).ToString("s");
            this.day4 = DateTime.Now.AddDays(-3.0).ToString("s");
            this.day5 = DateTime.Now.AddDays(-4.0).ToString("s");
            this.shortDateToday = DateTime.Now.ToString("d/M/yyyy");
            this.codesWidget = codesWidget;
            this.hash = hash; 
            this.CatsSelected = this.GetPreselectedCategory(this.hash);
            this.filterPageType = (tp == null) ? 1 : Int32.Parse(tp);
            this.HandleCodes();
            this.PublicationID = (pbid == null) ? 0 : Int32.Parse(pbid); 
            
        }

        protected void HandleCodes()
        {
            int num = 0;
            string catsSelected = this.CatsSelected;
            if (!string.IsNullOrEmpty(catsSelected))
            {
                string[] array = catsSelected.Split(new char[]
                {
                    ','
                });
                string[] array2 = array;
                for (int i = 0; i < array2.Length; i++)
                {
                    string text = array2[i];
                    SqlDataReader sqlDataReader = this.CodeExists(text);
                    try
                    {
                        if (sqlDataReader.HasRows)
                        {
                            while (sqlDataReader.Read())
                            {
                                if (sqlDataReader["catcode"] != null)
                                {
                                    this.HasCodes = true;
                                    this.codeArr[num] = text;
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


        private string GetPreselectedCategory(string hash)
        {
            string text = "##GetPreselectedCategory##" + hash;
            if (text == null)
            {
                string query = string.Format("select [dbo].[NewsPaperWidgetGetCategoriesByHash](@hash)", hash);
                SqlCommand command = new SqlCommand(query, new SqlConnection(getConStringSQL()));
                command.Parameters.AddWithValue("@hash", hash);
                SqlDataReader sqlDataReader = command.ExecuteReader(CommandBehavior.CloseConnection);
                try
                {
                    if (sqlDataReader.HasRows)
                    {
                        while (sqlDataReader.Read())
                        {
                            text = sqlDataReader.GetString(0).ToString();
                        }
                        sqlDataReader.Close();
                    }
                }
                catch (Exception ex)
                {
                    Logger currentClassLogger = LogManager.GetCurrentClassLogger();
                    currentClassLogger.Debug("query GetPreselectedCategory. GetPreselectedCategory " + ex.ToString());
                }
                finally
                {
                    command.Connection.Close();
                }
            }
            return text;
        }

        protected void LoadXslParameters(XsltArgumentList Args)
        {
            
            string parameter = this.CatCodeList;
            if (this.codesWidget != "0")
            {
                parameter = this.codesWidget;
            }
            Args.AddParam("CodesWidget", string.Empty, parameter);
            Args.AddParam("hash", string.Empty, this.hash);
            Args.AddParam("CatsSelected", string.Empty, this.CatsSelected);
            Args.AddParam("filterPageType", string.Empty, this.filterPageType);
            Args.AddParam("shortDateToday", string.Empty, this.shortDateToday);
            Args.AddParam("shortDate", string.Empty, this.shortDate);
            Args.AddParam("shortDateFull", string.Empty, this.shortDateFull);
            Args.AddParam("domain", string.Empty, this.GetDomain(this.hash));
            Args.AddParam("prevDate1", string.Empty, this.day1);
            Args.AddParam("prevDate2", string.Empty, this.day2);
            Args.AddParam("prevDate3", string.Empty, this.day3);
            Args.AddParam("prevDate4", string.Empty, this.day4);
            Args.AddParam("prevDate5", string.Empty, this.day5);
        }

        // NewsPapersWidgetXML
        
        protected string GetArgs(int retries)
        {
            string text = string.Empty;
            string arg = string.Empty;
            string str = string.Empty;
            string text2 = string.Empty;
            string arg2 = string.Empty;
            if (this.filterPageType == 1)
            {
                arg2 = " AND Pub_back = 0 ";
            }
            else
            {
                arg2 = " AND Pub_back = 1 ";
            }
            if (this.filterPageType == 3)
            {
                arg2 = "";
            }
            if (this.HasCodes)
            {
                int num = 1;
                string[] array = this.codeArr;
                for (int i = 0; i < array.Length; i++)
                {
                    string text3 = array[i];
                    if (!string.IsNullOrEmpty(text3))
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
                if (!string.IsNullOrEmpty(text2))
                {
                    str = " AND ( " + text2 + ")";
                    text += str;
                }
            }
            if (this.CatsSelected == "0")
            {
                text = " AND 1=2";
            }
            if (retries == 1)
            {
                this.shortDate = this.LastDateExisting(text).ToString("d/M/yyyy");
            }
            if (this.isClicked == 0)
            {
                DateTime dateTime = this.LastDateExisting(text);
                this.shortDate = dateTime.ToString("d/M/yyyy");
                this.shortDateFull = dateTime.ToString("s");
            }
            arg = " AND DATEDIFF(d,publ_date,'" + this.shortDate + "')=0 ";
            // string embeddedResource = Strings.GetEmbeddedResource(typeof(NewsPapersWidget).Assembly, "YellowModules.Sql.NewsPapersWidgetXML.sql");
            return arg + text + arg2;

        }

        private string GetDomain(string hash)
        {
            string text = "HashDomain###" + hash;
            
            if (text == null)
            {
                using (SqlCommand command = new SqlCommand( "Select domain From cms_DC_NewsPapersWidget Where hash = @hash", new SqlConnection(getConStringSQL())))
                {
                    command.Parameters.AddWithValue("@hash", hash);
                    try
                    {
                        text = ((command.ExecuteScalar() as string) ?? string.Empty);
                        text = this.ProcessDomain(text);
                    }
                    finally
                    {
                        command.Connection.Close();
                    }
                }
            }
            return text;
        }

        private string ProcessDomain(string result)
        {
            result = result.Replace("https://", string.Empty);
            result = result.Replace("http://", string.Empty);
            result = result.Replace(":", string.Empty);
            result = result.Replace("/", string.Empty);
            return result;
        }

        protected DateTime LastDateExisting(string categoryClause)
        {
            string query = string.Format("set dateformat dmy; select top 1 publ_date\r\n from cms_dc_newspaperpublications pu inner join cms_dc_newspapers np on publ_title = np.ID \r\n   inner join cms_DC_NewsPapersCategories c on c.rowID = np.Category where 1=1 and pu.status='published' \r\n                and np.status='published' and c.status='published' \r\n                and np.langid=1 and pu.langid=1     {0}            \r\n                 AND Pub_back = 0\r\n   group by pu.publ_date \r\n  having count(*)>2 \r\n  order by publ_date desc", categoryClause);
            DateTime result = DateTime.Now;
            try
            {
                using (SqlConnection con = new SqlConnection(getConStringSQL()))
                {
                    con.Open();
                    using (SqlCommand command = new SqlCommand(query, con))
                    {
                        SqlDataReader sqlDataReader = command.ExecuteReader();


                        if (sqlDataReader.HasRows)
                        {
                            while (sqlDataReader.Read())
                            {
                                result = sqlDataReader.GetDateTime(0);
                            }
                            sqlDataReader.Close();
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                Logger currentClassLogger = LogManager.GetCurrentClassLogger();
                currentClassLogger.Debug("query errror. LastDateExisting " + ex.ToString());
            }
            return result;
            
        }

        protected virtual SqlDataReader CodeExists(string CatCode)
        {
            string query = "select catcode from cms_DC_NewsPapersCategories (nolock) where catcode=@catcode and langid=1 and status='published'";

            using(SqlConnection con = new SqlConnection(getConStringSQL()))
            {
                con.Open();
                using (SqlCommand command = new SqlCommand(query, con))
                {
                    command.Parameters.AddWithValue("@catcode", CatCode);
                    return command.ExecuteReader(CommandBehavior.CloseConnection);
                }
            }
        }

    }
}