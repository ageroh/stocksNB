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
        protected DateTime theDate;
        protected int PapersCategory;
        protected int PublicationID;
        private string shortDate = string.Empty;
        private string shortDateToday = string.Empty;
        private string codesWidget = string.Empty;
        private int filterPageType = 1;
        protected bool HasCodes;
        private string[] codeArr = new string[20];
        protected string catCodeList = string.Empty;
        protected bool isWidget;

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

        public string IsWidget
        {
            get
            {
                return this.isWidget.ToString();
            }
            set
            {
                this.isWidget = bool.Parse(value);
            }
        }


        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                On_Init( Convert.ToDateTime(Request.QueryString["dt"]), Request.QueryString["codesWidget"], Int32.Parse(Request.QueryString["tp"]), Int32.Parse(Request.QueryString["pct"]), Int32.Parse(Request.QueryString["pbid"]));
            }

        }

        
        protected virtual string GetCommandTextTestArgs()
        {
            string text = string.Empty;
            string arg = string.Empty;
            string str = string.Empty;
            string text2 = string.Empty;
            if (this.PapersCategory != 0 && !this.isWidget)
            {
                text = " AND Category= " + this.PapersCategory.ToString() + " ";
            }
            arg = " AND DATEDIFF(d,publ_date,'" + this.shortDate + "')=0 ";
            if (this.isWidget)
            {
                arg = " AND DATEDIFF(d,publ_date,'" + this.shortDateToday + "')=0 ";
            }
            if (this.HasCodes)
            {
                int num = 1;
                string[] array = this.codeArr;
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
                XmlNodeList Titles = xmlDocCheckTodayPapers.SelectNodes("/np[@Title]");
                foreach (XmlNode nextNode in Titles)
                {
                    num++;
                }
            }
            catch (Exception ex)
            {
                Logger currentClassLogger = LogManager.GetCurrentClassLogger();
                currentClassLogger.Debug("query errror.NewsPapers", ex.ToString());
            }
            
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
            if (this.codesWidget != "0")
            {
                text = this.codesWidget;
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
                                    this.HasCodes = true;
                                    this.codeArr[num] = text2;
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
        protected void On_Init(DateTime dt, string codesWidget = null, int tp = 1, int pct = 0, int pbid = 0)
        {
            //Thread.CurrentThread.CurrentUICulture = CultureInfo.GetCultureInfo("en-US");
            //Thread.CurrentThread.CurrentCulture = CultureInfo.GetCultureInfo("en-US");
            this.theDate = dt;
            this.shortDate = this.theDate.ToString("d/M/yyyy");
            this.shortDateToday = DateTime.Now.ToString("d/M/yyyy");
            this.codesWidget = codesWidget;
            this.filterPageType = tp;
            this.HandleCodes();
            if (!this.TodayHasPapers())
            {
                this.theDate = dt;
                this.theDate = this.theDate.AddDays(-1.0);
                this.shortDate = this.theDate.ToString("d/M/yyyy");
                this.shortDateToday = DateTime.Now.AddDays(-1.0).ToString("d/M/yyyy");
            }
            this.PapersCategory = pct;
            this.PublicationID = pbid;
            
        }

        protected void LoadXslParameters(XsltArgumentList Args)
        {

            string parameter = string.Empty;
            if (this.PublicationID != 0)
            {
                parameter = this.GetPublicationDetails();
            }
            else
            {
                parameter = "0";
            }
            string parameter2 = this.CatCodeList;
            if (this.codesWidget != "0")
            {
                parameter2 = this.codesWidget;
            }
        }
         //   Args.AddParam("PublicationString", string.Empty, parameter);
         //   Args.AddParam("CodesWidget", string.Empty, parameter2);
         //   Args.AddParam("PapersCategory", string.Empty, this.PapersCategory);
        

        protected string GetContentXml()
        {
            
            //command :
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
            if (this.PapersCategory != 0 && !this.isWidget)
            {
                text = " AND Category= " + this.PapersCategory.ToString() + " ";
            }
            arg = " AND DATEDIFF(d,publ_date,'" + this.shortDate + "')=0 ";
            if (this.isWidget)
            {
                arg = " AND DATEDIFF(d,publ_date,'" + this.shortDateToday + "')=0 ";
            }
            if (this.HasCodes)
            {
                int num = 1;
                string[] array = this.codeArr;
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
            string text4 = "YellowModules.Sql.NewsPapersListXML.sql";
            text4 = string.Format(text4, arg, text, arg2);

            // return XML result of NewsPapersListXML.sql
            return null;
        }



        private string GetPublicationDetails()
        {
            string result = string.Empty;
            

            XmlDocument xmlDocNewsPapersList = produceXMLfromSQL("NewsPapersList", GetCommandTextPub());
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
            int arg_1A_0 = this.filterPageType;
            if (this.PapersCategory != 0)
            {
                bool arg_29_0 = this.isWidget;
            }
            arg = " AND DATEDIFF(d,publ_date,'" + this.shortDate + "')=0 ";
            if (this.isWidget)
            {
                arg = " AND DATEDIFF(d,publ_date,'" + this.shortDateToday + "')=0 ";
            }
            if (this.PublicationID != 0 && !this.isWidget)
            {
                text = text + " AND pu.rowid= " + this.PublicationID.ToString() + " ";
            }
            return arg + text;
        }


        protected virtual SqlDataReader CodeExists(string CatCode)
        {
            string query = "select catcode from cms_DC_NewsPapersCategories (nolock) where catcode=@catcode and langid=1 and status='published'";
            SqlCommand command = new SqlCommand(query, new SqlConnection(getConStringSQL()));
            command.Parameters.AddWithValue("@catcode", CatCode);
            return command.ExecuteReader(CommandBehavior.CloseConnection);
        }
    }


}