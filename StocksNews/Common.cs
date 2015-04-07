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
    public class Common : System.Web.UI.Page
    {



        public XmlDocument produceXMLfromSQL(String SQLFileQuery, string replacestr = null)
        {
            XmlDocument xdoc = new XmlDocument();
            SqlConnection cnn = null;
            SqlCommand cmd = null;

            try
            {
                cnn = new SqlConnection();
                cnn.ConnectionString = getConStringSQL();
                cnn.Open();

                string selectQry = File.ReadAllText(Server.MapPath(@"~/NBScripts/" + SQLFileQuery + ".sql"));
                if (replacestr != null)
                {
                    selectQry = selectQry.Replace("$$stockValue$$", replacestr);
                }

                cmd = new SqlCommand(selectQry, cnn);
                //cmd.Parameters.AddWithValue("@ID", ID);

                XmlReader reader = cmd.ExecuteXmlReader();

                if (reader.Read())
                {
                    xdoc.Load(reader);
                    return xdoc;
                }

                return null;
            }

            catch (Exception ex)
            {
                throw ex;
            }

            finally
            {
                cmd.Dispose();
                cnn.Close();
            }

        }



        public string getConStringSQL()
        {
            try
            {
                System.Configuration.Configuration rootWebConfig = System.Web.Configuration.WebConfigurationManager.OpenWebConfiguration("~/");

                System.Configuration.ConnectionStringSettings connString;
                if (rootWebConfig.ConnectionStrings.ConnectionStrings.Count > 0)
                {
                    connString = rootWebConfig.ConnectionStrings.ConnectionStrings["ProductionStocks"];
                    if (connString != null)
                        return connString.ConnectionString;
                    else
                        return null;
                }
                return null;
            }
            catch (Exception e)
            {
                // log error!
                return null;
            }

        }


    }
}