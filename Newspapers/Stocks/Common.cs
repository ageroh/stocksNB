using System.Web;
using System.Data.SqlClient;
using System.Data.Sql;
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
using System.Web.Hosting;

namespace Newspapers
{
    public class Common : System.Web.UI.Page
    {
        public static string path = HostingEnvironment.MapPath (@"~/NBScripts/");

        public static XmlDocument produceXMLfromSQL(String SQLFileQuery, string args)
        {
            XmlDocument xdoc = new XmlDocument();
            SqlConnection cnn = null;
            SqlCommand cmd = null;

            try
            {
                cnn = new SqlConnection();
                cnn.ConnectionString = getConStringSQL();
                cnn.Open();

                string selectQry = File.ReadAllText(path + SQLFileQuery + ".sql");
                if (args != null)
                    selectQry = string.Format(selectQry, args);

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

        public static XmlDocument produceXMLfromSQL(String SQLFileQuery)
        {
            XmlDocument xdoc = new XmlDocument();
            SqlConnection cnn = null;
            SqlCommand cmd = null;

            try
            {
                cnn = new SqlConnection();
                cnn.ConnectionString = getConStringSQL();
                cnn.Open();

                string selectQry = File.ReadAllText(path + SQLFileQuery + ".sql");

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




        public static string getConStringSQL()
        {
            try
            {
                System.Configuration.Configuration rootWebConfig = System.Web.Configuration.WebConfigurationManager.OpenWebConfiguration("~/");

                System.Configuration.ConnectionStringSettings connString;
                if (rootWebConfig.ConnectionStrings.ConnectionStrings.Count > 0)
                {
                    connString = rootWebConfig.ConnectionStrings.ConnectionStrings["ProductionCstr"];
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