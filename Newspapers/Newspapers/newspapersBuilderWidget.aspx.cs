using System;
using System.Collections.Specialized;
using System.Collections;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;
using System.Configuration;
using System.Net;
using System.Xml;
using System.IO;
using System.Web.Configuration;
using Newspapers;

public partial class newspapersBuilderWidget : Common
{
    protected void Page_Load(object sender, EventArgs e)
    {
//        string Categories = Request["cats"];
//        string Domain = Request["domain"];
//        string Width = Request["width"];

        string Categories = this.Request.QueryString["cats"];
        string Domain = this.Request.QueryString["domain"];
        string Width = this.Request.QueryString["width"];


        InsertInDatabase(Categories, Domain, Width);
    }


    void InsertInDatabase(string Categories, string Domain, string Width)
    {


        string query = "";
        int res = -1;
        string Hash = String.Empty;

        try
        {
            // Insert new widget first
            using (SqlConnection con = new SqlConnection(getConStringSQL()))
            {
                con.Open();
                query = @"Insert Into cms_DC_NewsPapersWidget(langId, status, statusChangedDate, domain, widgetWidth, cats, isActive) Values 
                                                           (1, 'published', GetDate(), @domain, @widgetWidth, @cats, 1)  select  IDENT_CURRENT(‘cms_DC_NewsPapersWidget’)";
                using (SqlCommand Command = new SqlCommand("usp_Create_New_NP_Widget", con))
                {
                    Command.CommandType = CommandType.StoredProcedure;
                    Command.Parameters.AddWithValue("@domain", Domain);
                    Command.Parameters.AddWithValue("@widgetWidth", Width);
                    Command.Parameters.AddWithValue("@cats", Categories);
                    res = (int)Command.ExecuteScalar();
                }
                con.Close();
            }


            // fix HASH from id
           Hash = makeHash(Categories + Domain + Width + res.ToString());

            // update records HASH value.
            using (SqlConnection con = new SqlConnection(getConStringSQL()))
            {
                con.Open();
                query = @"update cms_DC_NewsPapersWidget SET Hash = '" +Hash+ "' where rowid = " + res;
                using (SqlCommand Command = new SqlCommand(query, con))
                {
                    res = (int)Command.ExecuteScalar();
                }
                con.Close();
            }

        }
        catch (Exception ex)
        {
            NLog.Logger Log = NLog.LogManager.GetCurrentClassLogger();
            Log.Debug("newspapersBuilderWidget" + ex.ToString());
        }
        finally
        {
            Response.Write("<script type='text/javascript' src='http://" + Request.ServerVariables["SERVER_NAME"] + "/paperFeedWidget.aspx?h=" + Hash + "&w=" + Width + "'></script>");
        }

    }

    private string makeHash(string key)
    {
        System.Security.Cryptography.MD5CryptoServiceProvider x = new System.Security.Cryptography.MD5CryptoServiceProvider();
        byte[] bs = System.Text.Encoding.UTF8.GetBytes(key);
        bs = x.ComputeHash(bs);
        System.Text.StringBuilder s = new System.Text.StringBuilder();
        foreach (byte b in bs)
        {
            s.Append(b.ToString("x2").ToLower());
        }
        string res = s.ToString();
        return res;
    }
}
