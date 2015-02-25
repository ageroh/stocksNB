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
using Newspapers;





public partial class PapersFeed : Common
{
    protected void Page_Load(object sender, EventArgs e)
    {
        return;
		Response.ContentType = "text/xml";
        xmlRead();
    }

    bool ExpireCache = false;

    private string xmlRead()
    {

        Response.Write("<empty/>");

        string isPreviousDay = "0";
        String FeedDate = string.Empty;
        isPreviousDay = Request.QueryString["isPreviousDate"];

        //String FeedDate = DateTime.Now.Year + ZeroFiller(DateTime.Now.Month) + ZeroFiller(DateTime.Now.Day);

        if (isPreviousDay == "-1")
        {
            DateTime FeedDateDT = DateTime.Now.AddDays(-1);
            FeedDate = FeedDateDT.Year + ZeroFiller(FeedDateDT.Month) + ZeroFiller(FeedDateDT.Day);
            //Response.Write(FeedDate);
        }
        else
        {
            FeedDate = DateTime.Now.Year + ZeroFiller(DateTime.Now.Month) + ZeroFiller(DateTime.Now.Day);
            //Response.Write(FeedDate);
        }

        //FeedDate = "20101218";
        String FeedUrl = string.Format("http://www.innews.gr/version4/services/frontpages_xml/?api_key=newsbeast_0107&date={0}", FeedDate);
        HttpWebRequest request = (HttpWebRequest)WebRequest.Create("http://www.innews.gr/version4/services/frontpages_xml/?api_key=newsbeast_0107&date=" + FeedDate + "");
        //Response.Write(FeedUrl + "<hr>");
        //HttpWebRequest request = (HttpWebRequest)WebRequest.Create("http://newsbeastdev.atcom.gr/www.innews.gr.xml");
        request.Timeout = 100000;
        request.Credentials = new NetworkCredential("newsbeast", "3ws83@$t");
        Stream receiveStream = Stream.Null;


        try
        {
            HttpWebResponse response = (HttpWebResponse)request.GetResponse();
            receiveStream = response.GetResponseStream();
        }
        catch (Exception ex)
        {
            Response.Write("query errror.NewsPapers Feed");
        }



        XmlDocument GoogleXMLdoc = null;

        try
        {

            GoogleXMLdoc = new XmlDocument();
            GoogleXMLdoc.Load(receiveStream);

            XmlNode root = GoogleXMLdoc.DocumentElement;
            XmlNodeList nodeList = root.SelectNodes("descendant::page");

            int counter = 0;

            Dictionary<int, Publication> papersList = new Dictionary<int, Publication>();
            bool ImageIsValid = false;

            foreach (XmlNode nod in nodeList)
            {

                string feed_id = nod.SelectSingleNode("id").InnerText;
                string feed_title = nod.SelectSingleNode("title").InnerText;
                string feed_date_published = nod.SelectSingleNode("date_published").InnerText;
                string feed_page_number = nod.SelectSingleNode("page_number").InnerText;
                string feed_url = nod.SelectSingleNode("url").InnerText;
                string feed_newspaper_id = nod.SelectSingleNode("newspaper_id").InnerText;
                
                Publication myPaper = new Publication(int.Parse(feed_newspaper_id), feed_id, feed_title, feed_date_published, int.Parse(feed_page_number), feed_url);
                Publication value;

                if (papersList.ContainsKey(int.Parse(feed_newspaper_id)))
                {

                    papersList.TryGetValue(int.Parse(feed_newspaper_id), out value);
                    if (value.PageNumber < int.Parse(feed_page_number))
                    {
                        papersList.Remove(int.Parse(feed_newspaper_id));
                        papersList.Add(int.Parse(feed_newspaper_id), myPaper);
                    }
                }
                else
                {
                    papersList.Add(int.Parse(feed_newspaper_id), myPaper);
                }
              

                if (PaperExists(feed_newspaper_id) && !PublicationExists(feed_id) && feed_page_number == "1")
                {             

                    ImageIsValid = WriteImage(feed_url, Server.MapPath("files/1/paperstemp/" + feed_id + ".jpg"));
                    //byte[] tempFoto = GetBytesFromUrl(feed_url);
                    //WriteBytesToFile(Server.MapPath("files/1/paperstemp/" + feed_id + ".jpg"), tempFoto);
                    if (ImageIsValid)
                        InsertInDatabase(feed_newspaper_id, feed_id, feed_title, feed_date_published, 0);

                    //Response.Write("front:" + feed_newspaper_id + "-" + feed_id + " - " + feed_title + "-" + feed_date_published + "<hr/>");
                    Response.Flush();
                }
               
            }



            foreach (KeyValuePair<int, Publication> KeyVal in papersList)
            {
                

                if (PaperExists(KeyVal.Value.Id.ToString()) && !PublicationExists(KeyVal.Value.Publ_id.ToString()) && KeyVal.Value.PageNumber.ToString() != "1")
                {

                    //Response.Write("back:" + PublicationBackPageAlreadyExists(KeyVal.Value.Id.ToString()).ToString());
                    int rowid = 0;
                    rowid = PublicationBackPageAlreadyExists(KeyVal.Value.Id.ToString());
                    ImageIsValid = WriteImage(KeyVal.Value.Feed_url.ToString(), Server.MapPath("files/1/paperstemp/" + KeyVal.Value.Publ_id.ToString() + ".jpg"));

                    //byte[] tempFoto = GetBytesFromUrl(KeyVal.Value.Feed_url.ToString());
                    //WriteBytesToFile(Server.MapPath("files/1/paperstemp/" + KeyVal.Value.Publ_id.ToString() + ".jpg"), tempFoto);
                    if (ImageIsValid)
                    {
                        if (rowid != 0)
                        {
                            UpdateDatabase(rowid, KeyVal.Value.Id.ToString(), KeyVal.Value.Publ_id.ToString(), KeyVal.Value.Publ_title.ToString(), KeyVal.Value.Pub_date.ToString(), 1);
                        }
                        else
                        {
                            InsertInDatabase(KeyVal.Value.Id.ToString(), KeyVal.Value.Publ_id.ToString(), KeyVal.Value.Publ_title.ToString(), KeyVal.Value.Pub_date.ToString(), 1);
                        }
                    }

                   // Response.Write("back:" + KeyVal.Value.Id.ToString() + "-" + KeyVal.Value.Publ_id.ToString() + " - " + KeyVal.Value.Publ_title.ToString() + "-" + KeyVal.Value.Pub_date.ToString() + "-" + KeyVal.Value.Feed_url.ToString() + "<hr/>");
                    Response.Flush();

                }

            }
        }
        catch (System.Exception ex)
        {
            Response.Write(ex.Message + "/");
        }
        finally
        {
            receiveStream.Close();
        }

        if (ExpireCache)
        {
         //   Type DataCatalogType = Type.GetType(string.Format("Netvolution.Common.Entities.Dc{0},DC{0}", "NewsPaperPublications"), true);
         //   Utilities.Cache.ExpireEntity(DataCatalogType);
        }

        return "-";

    }



    void UpdateDatabase(int rowid, string id, string publ_id, string publ_title, string pub_date, int IsBackPage)
    {
        int newID = Identity.GetNewIdentity("cms_dc_newspaperpublications", "rowid");
        String FotoPath = "files/1/paperstemp/" + publ_id + ".jpg";

        string sql = string.Empty;
        sql = @"update  cms_dc_newspaperpublications SET 
            Publ_title = @Publ_title,
            Publ_Date = @Publ_Date,
            Publ_photo = @Publ_photo,
            Publ_id = @Publ_id
            where rowid=@RowId";

        SqlCommand Command = DataUtility.GetCommand(sql);
        Command.Parameters.AddWithValue("@RowId", rowid);
        Command.Parameters.AddWithValue("@langid", 1);
        Command.Parameters.AddWithValue("@Publ_title", id);
        Command.Parameters.AddWithValue("@Publ_photo", FotoPath);
        Command.Parameters.AddWithValue("@Publ_id", publ_id);
        Command.Parameters.AddWithValue("@Publ_Date", System.DateTime.Parse(pub_date));

        Command.ExecuteNonQuery();
        Command.Connection.Close();

        ExpireCache = true;

    }

    void InsertInDatabase(string id, string publ_id, string publ_title, string pub_date, int IsBackPage)
    {
        int newID = Identity.GetNewIdentity("cms_dc_newspaperpublications", "rowid");
        String FotoPath = "files/1/paperstemp/" + publ_id + ".jpg";

        SqlCommand Command = DataUtility.GetCommand(@"
                    Insert Into cms_dc_newspaperpublications(rowID,langId,status,statusChangedDate,Publ_title,Publ_Date,Publ_photo,Publ_id,Pub_back)Values(@RowId,1,'published',GetDate(),@Publ_title,@Publ_Date,@Publ_photo,@Publ_id,@Pub_back)
                    ");
        Command.Parameters.AddWithValue("@RowId", Identity.GetNewIdentity("cms_dc_newspaperpublications", "rowid"));
        Command.Parameters.AddWithValue("@langid", 1);
        Command.Parameters.AddWithValue("@Publ_title", id);
        Command.Parameters.AddWithValue("@Publ_photo", FotoPath);
        Command.Parameters.AddWithValue("@Publ_id", publ_id);
        Command.Parameters.AddWithValue("@Pub_back", IsBackPage);
        Command.Parameters.AddWithValue("@Publ_Date", System.DateTime.Parse(pub_date));

        Command.ExecuteNonQuery();
        Command.Connection.Close();
        ExpireCache = true;

    }

    private int PublicationBackPageAlreadyExists(string titleID)
    {
        int rowid = 0;
        string connectString = ConfigurationManager.ConnectionStrings["FrontendConnectionString"].ConnectionString;
        SqlConnection cnn = new SqlConnection(connectString);
        cnn.Open();

        SqlCommand Command = new SqlCommand();
        Command.CommandType = CommandType.Text;

        Command.CommandText = "select top 1 rowid from cms_DC_NewsPaperPublications where Pub_back=1 and Publ_Title=@Title and  datediff(d,getdate(),publ_date)=0 order by Publ_Date desc";
        Command.Connection = cnn;
        Command.Parameters.AddWithValue("@Title", titleID);

        SqlDataReader Reader = Command.ExecuteReader(CommandBehavior.CloseConnection);
        try
        {
            if (Reader.HasRows)
            {
                while (Reader.Read())
                {
                    rowid = Reader.GetInt32(0);
                }

            }
        }

        catch (Exception ex)
        {
            NLog.Logger Log = NLog.LogManager.GetCurrentClassLogger();
            Log.Debug("query errror. PublicationBackPageAlreadyExists feed" + ex.ToString());
        }
        finally
        {
            Reader.Close();

        }

        return rowid;
    }

    private bool PublicationExists(string id)
    {

        bool result = false;
        string connectString = ConfigurationManager.ConnectionStrings["FrontendConnectionString"].ConnectionString;
        SqlConnection cnn = new SqlConnection(connectString);
        cnn.Open();

        SqlCommand Command = new SqlCommand();
        Command.CommandType = CommandType.Text;

        Command.CommandText = "select * from cms_dc_newspaperpublications where  Publ_ID=@id and status='published'";
        Command.Connection = cnn;
        Command.Parameters.AddWithValue("@id", id);

        SqlDataReader Reader = Command.ExecuteReader(CommandBehavior.CloseConnection);
        try
        {
            if (Reader.HasRows)
            {
                while (Reader.Read())
                {
                    result = true;
                }

            }
        }

        catch (Exception ex)
        {
            NLog.Logger Log = NLog.LogManager.GetCurrentClassLogger();
            Log.Debug("query errror. PaperExists feed" + ex.ToString());
        }
        finally
        {
            Reader.Close();

        }
        return result;
    }

    private bool PaperExists(string id)
    {

        bool result = false;
        string connectString = ConfigurationManager.ConnectionStrings["FrontendConnectionString"].ConnectionString;
        SqlConnection cnn = new SqlConnection(connectString);
        cnn.Open();

        SqlCommand Command = new SqlCommand();
        Command.CommandType = CommandType.Text;

        Command.CommandText = "select * from cms_DC_NewsPapers where  ID=@id and status='published'";
        Command.Connection = cnn;
        Command.Parameters.AddWithValue("@id", id);

        SqlDataReader Reader = Command.ExecuteReader(CommandBehavior.CloseConnection);
        try
        {
            if (Reader.HasRows)
            {
                while (Reader.Read())
                {
                    result = true;
                }

            }
        }

        catch (Exception ex)
        {
            NLog.Logger Log = NLog.LogManager.GetCurrentClassLogger();
            Log.Debug("query errror. PaperExists feed" + ex.ToString());
        }
        finally
        {
            Reader.Close();

        }
        return result;
    }

    string ZeroFiller(int num)
    {
        if (num < 10)
            return "0" + num.ToString();
        else
            return num.ToString();
    }


    private bool WriteImage(string Feed_url, string imagePath)
    {
        byte[] b;
        try
        {
            HttpWebRequest myReq = (HttpWebRequest)WebRequest.Create(Feed_url);
            WebResponse myResp = myReq.GetResponse();

            Stream stream = myResp.GetResponseStream();
            using (BinaryReader br = new BinaryReader(stream))
            {
                try
                {
                    b = br.ReadBytes(5000000);
                    FileStream fs = new FileStream(imagePath, FileMode.Create);
                    BinaryWriter w = new BinaryWriter(fs);
                    try
                    {
                        w.Write(b);

                    }
                    finally
                    {
                        w.Flush();
                        fs.Close();
                        w.Close();
                    }
                    return true;

                }
                catch (Exception ex)
                {
                    
                    NLog.Logger Log = NLog.LogManager.GetCurrentClassLogger();
                    Log.Error("NewsPapers feed BinaryReader " + Feed_url  + " - " + ex.ToString());
                    return false;
                }
                br.Close();

            }
            myResp.Close();
        }
        catch (Exception ex)
        {
            
            NLog.Logger Log = NLog.LogManager.GetCurrentClassLogger();
            Log.Error("NewsPapers feed WebRequest " + Feed_url + " - " + ex.ToString());
            return false;
        }

    }


    static public byte[] GetBytesFromUrl(string url)
    {

        byte[] b;

        HttpWebRequest myReq = (HttpWebRequest)WebRequest.Create(url);
        WebResponse myResp = myReq.GetResponse();

        Stream stream = myResp.GetResponseStream();
        using (BinaryReader br = new BinaryReader(stream))
        {
            try
            {
                b = br.ReadBytes(5000000);

            }
            finally
            {

            }
            br.Close();

        }
        myResp.Close();

        return b;


    }

    static public void WriteBytesToFile(string fileName, byte[] content)
    {
        FileStream fs = new FileStream(fileName, FileMode.Create);
        BinaryWriter w = new BinaryWriter(fs);
        try
        {
            w.Write(content);

        }
        finally
        {
            w.Flush();
            fs.Close();
            w.Close();
        }
    }
}

public class Publication
{
    public Publication(int id, string publ_id, string publ_title, string pub_date, int pageNumber, string feed_url)
    {
        Id = id;
        Publ_id = publ_id;
        Publ_title = publ_title;
        Pub_date = pub_date;
        PageNumber = pageNumber;
        Feed_url = feed_url;
    }

    private int m_pageNumber;
    public int PageNumber
    {
        get { return m_pageNumber; }
        set { m_pageNumber = value; }
    }

    private int m_id;
    public int Id
    {
        get { return m_id; }
        set { m_id = value; }
    }
    private string m_Publ_id;
    public string Publ_id
    {
        get { return m_Publ_id; }
        set { m_Publ_id = value; }
    }
    private string m_Publ_title;
    public string Publ_title
    {
        get { return m_Publ_title; }
        set { m_Publ_title = value; }
    }
    private string m_Pub_date;
    public string Pub_date
    {
        get { return m_Pub_date; }
        set { m_Pub_date = value; }
    }

    private string m_feed_url;
    public string Feed_url
    {
        get { return m_feed_url; }
        set { m_feed_url = value; }
    }
}
