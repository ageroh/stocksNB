using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Text;
using System.Xml.Linq;
using System.Xml.XPath;
using System.Threading.Tasks;
using System.Drawing;
using System.Drawing.Imaging;
using System.Drawing.Drawing2D;


namespace Newsbeast.ContentUpdateService.Newspapers
{
    public class NewspapersService : RecurringTask
    {
        private class Page
        {
            public int ID
            {
                get;
                set;
            }
            public int NewspaperID
            {
                get;
                set;
            }
            public DateTime DatePublished
            {
                get;
                set;
            }
            public DateTime DateScanned
            {
                get;
                set;
            }
            public int Number
            {
                get;
                set;
            }
            public string Url
            {
                get;
                set;
            }
            public string NewsPaperTitle
            {
                get;
                set;
            }
        }
        private class PageGroup
        {
            public int NewspaperID
            {
                get;
                set;
            }
            public IEnumerable<NewspapersService.Page> Pages
            {
                get;
                set;
            }
        }
        private class Notification
        {
            public string Message
            {
                get;
                set;
            }
            public NewspapersService.NotificationLevel Level
            {
                get;
                set;
            }
        }
        public enum NotificationLevel
        {
            Info,
            Error
        }
        private NewspaperSettings Settings = new NewspaperSettings();
        protected override int Interval
        {
            get { return this.Settings.UpdateInterval; }
        }

        protected override void ExecuteTask()
        {
            List<DateTime> list = new List<DateTime>();
            list.Add(DateTime.Today.AddDays(-1.0));
            list.Add(DateTime.Today);
            list.Add(DateTime.Today.AddDays(1.0));
            List<NewspapersService.Notification> Notifications = new List<NewspapersService.Notification>();
            NewspapersDataContext DataContext = new NewspapersDataContext();
            DataContext.Connection.Open();
            IEnumerable<Newspaper> Newspapers = (
                from x in DataContext.Newspapers
                select x).ToArray<Newspaper>();
            string[] NewspaperIds = (
                from x in Newspapers
                select x.ID).ToArray<string>();
            NewspaperPublication[] Publications = (
                from x in DataContext.NewspaperPublications
                where NewspaperIds.Contains(x.Publ_Title) && x.Publ_Date >= (DateTime?)DateTime.Today.AddDays(-1.0) && x.Publ_Date <= (DateTime?)DateTime.Today.AddDays(1.0)
                select x).ToArray<NewspaperPublication>();
            if (!Directory.Exists(this.Settings.PhysicalPath))
            {
                Directory.CreateDirectory(this.Settings.PhysicalPath);
            }
            Parallel.ForEach<DateTime>(list, delegate(DateTime Date)
            {
                this.ProcessDate(Date, DataContext, Newspapers, Publications, NewspaperIds, Notifications);
            });
            try
            {
                DataContext.SubmitChanges();
            }
            catch (Exception ex)
            {
                Notifications.Add(new NewspapersService.Notification
                {
                    Level = NewspapersService.NotificationLevel.Error,
                    Message = "There was an error while updating the database: " + ex.ToString()
                });
            }
            DataContext.Connection.Close();
            

            // REMOVE MANUALLY EXPIRE OF CACHE ! - LET VARNISH DECIDE !
            //if ((
            //    from x in Notifications
            //    where x.Level == NewspapersService.NotificationLevel.Info
            //    select x).Any<NewspapersService.Notification>() && !string.IsNullOrEmpty(this.Settings.OnSuccessUrl))
            //{
            //    try
            //    {
            //        WebClient webClient = new WebClient();
            //        webClient.DownloadString(this.Settings.OnSuccessUrl);
            //    }
            //    catch (Exception ex2)
            //    {
            //        Notifications.Add(new NewspapersService.Notification
            //        {
            //            Level = NewspapersService.NotificationLevel.Error,
            //            Message = "Could not expire site cache: " + ex2.ToString()
            //        });
            //    }
            //}

            if (Notifications.Count > 0)
            {
                NewspapersService.Notification[] array = (
                    from x in Notifications
                    where x.Level == NewspapersService.NotificationLevel.Error
                    select x).ToArray<NewspapersService.Notification>();
                NewspapersService.Notification[] array2 = (
                    from x in Notifications
                    where x.Level == NewspapersService.NotificationLevel.Info
                    select x).ToArray<NewspapersService.Notification>();
                StringBuilder stringBuilder = new StringBuilder();
                string text = "Newsbeast: Newspapers updated - ";
                if (array.Count<NewspapersService.Notification>() > 0)
                {
                    text += "Error";
                }
                else
                {
                    text += "Info";
                }
                NewspapersService.Notification[] array3 = array;
                for (int i = 0; i < array3.Length; i++)
                {
                    NewspapersService.Notification notification = array3[i];
                    stringBuilder.AppendFormat("<font color=\"red\">{0}</font><br/>", notification.Message);
                }
                NewspapersService.Notification[] array4 = array2;
                for (int j = 0; j < array4.Length; j++)
                {
                    NewspapersService.Notification notification2 = array4[j];
                    stringBuilder.AppendFormat("{0}<br/>", notification2.Message);
                }
                if (!string.IsNullOrEmpty(this.Settings.NotificationRecipients))
                {
                    SmtpClient smtpClient = new SmtpClient();
                    MailMessage mailMessage = new MailMessage("admin@netvolution.net", this.Settings.NotificationRecipients, text, stringBuilder.ToString());
                    mailMessage.IsBodyHtml = true;
                    try
                    {
                        smtpClient.Send(mailMessage);
                        return;
                    }
                    catch (Exception ex3)
                    {
                        base.Log.Error("Could not notifiy users: " + ex3.ToString());
                        return;
                    }
                }
                base.Log.Info(stringBuilder.ToString());
            }
        }

        private void ProcessDate(DateTime Date, NewspapersDataContext DataContext, IEnumerable<Newspaper> Newspapers, NewspaperPublication[] Publications, string[] NewspaperIds, 
            List<NewspapersService.Notification> Notifications)
        {
            try
            {
                string requestUriString = this.CreateUrl(Date);
                HttpWebRequest httpWebRequest = WebRequest.Create(requestUriString) as HttpWebRequest;
                httpWebRequest.Timeout = this.Settings.RequestTimeout;
                if (!string.IsNullOrEmpty(this.Settings.UserName))
                {
                    httpWebRequest.Credentials = new NetworkCredential(this.Settings.UserName, this.Settings.Password);
                }
                HttpWebResponse httpWebResponse = httpWebRequest.GetResponse() as HttpWebResponse;
                XDocument xDocument = XDocument.Load(httpWebResponse.GetResponseStream());
                IEnumerable<XElement> source = xDocument.Root.XPathSelectElements("/pages/page");
                IEnumerable<NewspapersService.Page> source2 =
                    from x in source
                    select new NewspapersService.Page
                    {
                        ID = int.Parse(x.Element("id").Value),
                        NewspaperID = int.Parse(x.Element("newspaper_id").Value),
                        Number = int.Parse(x.Element("page_number").Value),
                        Url = x.Element("url").Value,
                        DateScanned = DateTime.ParseExact(x.Element("date_scanned").Value, "yyyy-MM-dd", CultureInfo.InvariantCulture),
                        DatePublished = DateTime.ParseExact(x.Element("date_published").Value, "yyyy-MM-dd", CultureInfo.InvariantCulture),
                        NewsPaperTitle = x.Element("title").Value
                    };
                NewspapersService.PageGroup[] source3 = (
                    from x in source2
                    where NewspaperIds.Contains(x.NewspaperID.ToString())
                    group x by x.NewspaperID).Select(delegate(IGrouping<int, NewspapersService.Page> grp)
                    {
                        NewspapersService.PageGroup pageGroup = new NewspapersService.PageGroup();
                        pageGroup.NewspaperID = grp.Key;
                        pageGroup.Pages =
                            from x in grp
                            select x;
                        return pageGroup;
                    }).ToArray<NewspapersService.PageGroup>();
                Parallel.ForEach<NewspapersService.PageGroup>(source3, delegate(NewspapersService.PageGroup x)
                {
                    int MaxPage = (
                        from page in x.Pages
                        select page.Number).Max();
                    NewspapersService.Page page5 = (
                        from page in x.Pages
                        where page.Number == 1
                        orderby page.ID descending
                        select page).DefaultIfEmpty(null).FirstOrDefault<NewspapersService.Page>();
                    NewspaperPublication page2 = (
                        from pub in Publications
                        where pub.Publ_Title == x.NewspaperID.ToString() && pub.Publ_Date.Value.Date == Date && pub.Pub_back == false
                        select pub).DefaultIfEmpty(null).FirstOrDefault<NewspaperPublication>();
                    NewspapersService.Page page3 = (
                        from page in x.Pages
                        where page.Number == MaxPage
                        orderby page.ID descending
                        select page).DefaultIfEmpty(null).FirstOrDefault<NewspapersService.Page>();
                    NewspaperPublication page4 = (
                        from pub in Publications
                        where pub.Publ_Title == x.NewspaperID.ToString() && pub.Publ_Date.Value.Date == Date && pub.Pub_back == true
                        select pub).DefaultIfEmpty(null).FirstOrDefault<NewspaperPublication>();
                    if (page5 != null)
                    {
                        this.SyncPage(page5, page2, DataContext, Notifications);
                    }
                    if (page3 != null && page3.Number > 1)
                    {
                        this.SyncPage(page3, page4, DataContext, Notifications);
                    }
                });
            }
            catch (Exception ex)
            {
                Notifications.Add(new NewspapersService.Notification
                {
                    Level = NewspapersService.NotificationLevel.Error,
                    Message = "There was an error while updating date " + Date.ToString("dd/MM/yyyy") + ": " + ex.ToString()
                });
            }
        }

        private void SyncPage(NewspapersService.Page RemotePage, NewspaperPublication Page, NewspapersDataContext DataContext, List<NewspapersService.Notification> Notifications)
        {
            string fileName = this.GetFileName(RemotePage.Url, RemotePage.DatePublished, RemotePage.NewspaperID.ToString(), RemotePage.Number > 1, RemotePage.ID);
            string publ_Photo = this.MakeRelativeWebPath(fileName);
            if (Page == null)
            {
                try
                {
                    this.DownloadImage(RemotePage.Url, fileName);
                }
                catch (Exception ex)
                {
                    Notifications.Add(new NewspapersService.Notification
                    {
                        Level = NewspapersService.NotificationLevel.Error,
                        Message = string.Format("Could not download image {0} for paper {1}: {2}. Action: insert.", RemotePage.Url, string.Concat(new object[]
						{
							RemotePage.NewsPaperTitle,
							" (ID ",
							RemotePage.NewspaperID,
							")"
						}), ex.Message)
                    });
                    return;
                }
                Page = new NewspaperPublication
                {
                    rowID = DataContext.GetId(DataContext.Mapping.GetTable(typeof(NewspaperPublication)).TableName.ToLower().Replace("dbo.", string.Empty), "rowid"),
                    langID = 1,
                    status = "published",
                    Publ_ID = RemotePage.ID.ToString(),
                    Publ_Date = new DateTime?(RemotePage.DatePublished),
                    statusChangedDate = DateTime.Now,
                    Pub_back = new bool?(RemotePage.Number > 1),
                    Publ_Title = RemotePage.NewspaperID.ToString(),
                    Publ_Photo = publ_Photo
                };
                DataContext.NewspaperPublications.InsertOnSubmit(Page);
                Notifications.Add(new NewspapersService.Notification
                {
                    Level = NewspapersService.NotificationLevel.Info,
                    Message = string.Format("Inserted issue for {0}, {1} (page number {2}).", string.Concat(new object[]
					{
						RemotePage.NewsPaperTitle,
						" (ID ",
						RemotePage.NewspaperID,
						")"
					}), RemotePage.DatePublished.ToString("dd/MM/yyyy"), RemotePage.Number)
                });
                return;
            }
            if (int.Parse(Page.Publ_ID) < RemotePage.ID)
            {
                try
                {
                    this.DownloadImage(RemotePage.Url, fileName);
                }
                catch (Exception ex2)
                {
                    Notifications.Add(new NewspapersService.Notification
                    {
                        Level = NewspapersService.NotificationLevel.Error,
                        Message = string.Format("Could not download image {0} for paper {1}: {2}. Action: update.", RemotePage.Url, string.Concat(new object[]
						{
							RemotePage.NewsPaperTitle,
							" (ID ",
							RemotePage.NewspaperID,
							")"
						}), ex2.Message)
                    });
                    return;
                }
                Page.Publ_ID = RemotePage.ID.ToString();
                Page.statusChangedDate = DateTime.Now;
                Page.Publ_Photo = publ_Photo;
                Notifications.Add(new NewspapersService.Notification
                {
                    Level = NewspapersService.NotificationLevel.Info,
                    Message = string.Format("Updated issue for {0}, {1} (page number {2}).", string.Concat(new object[]
					{
						RemotePage.NewsPaperTitle,
						" (ID ",
						RemotePage.NewspaperID,
						")"
					}), RemotePage.DatePublished.ToString("dd/MM/yyyy"), RemotePage.Number)
                });
                return;
            }
            if (!File.Exists(string.Format("{0}{1}", this.Settings.PhysicalPath, Path.GetFileName(Page.Publ_Photo))))
            {
                try
                {
                    this.DownloadImage(RemotePage.Url, fileName);
                }
                catch (Exception ex3)
                {
                    Notifications.Add(new NewspapersService.Notification
                    {
                        Level = NewspapersService.NotificationLevel.Error,
                        Message = string.Format("Could not download image {0} for paper {1}: {2}. Action: Restore missing image.", RemotePage.Url, string.Concat(new object[]
						{
							RemotePage.NewsPaperTitle,
							" (ID ",
							RemotePage.NewspaperID,
							")"
						}), ex3.Message)
                    });
                    return;
                }
                Notifications.Add(new NewspapersService.Notification
                {
                    Level = NewspapersService.NotificationLevel.Info,
                    Message = string.Format("Restored missing image for issue for {0}, {1} (page number {2}).", string.Concat(new object[]
					{
						RemotePage.NewsPaperTitle,
						" (ID ",
						RemotePage.NewspaperID,
						")"
					}), RemotePage.DatePublished.ToString("dd/MM/yyyy"), RemotePage.Number)
                });
            }
        }
        private void DownloadImage(string url, string fileName)
        {
            WebClient webClient = new WebClient();
            string fileName2 = string.Format("{0}{1}", this.Settings.PhysicalPath, fileName);

            string filenameClean = (fileName2.Contains(".jpg") ? fileName2.Substring(0, fileName2.IndexOf(".jpg")) : fileName2);
            // fetch and download big image 
            webClient.DownloadFile(url, fileName2);

            // open downloaded image..
            Image image1 = Image.FromFile(fileName2, true);

            // resize to custom 2 dimensions
            if ( File.Exists(filenameClean + "_277x343.jpg") )
                File.Delete(filenameClean + "_277x343.jpg");
            Image imgnew = FixedSize(image1, 277, 343);
            if( imgnew == null)
                base.Log.Error("Could not Save image in 277x343 : " + filenameClean);
            else
                imgnew.Save(filenameClean + "_277x343.jpg", System.Drawing.Imaging.ImageFormat.Jpeg);


            // crop and resize image for main page
            if ( File.Exists(filenameClean + "_213x298.jpg") )
                File.Delete(filenameClean + "_213x298.jpg");
            if (!SaveCroppedImage(image1, 213, 298, filenameClean + "_213x298.jpg"))
            {
                base.Log.Error("Could not Save image in 213x298 : " + filenameClean);
            }

        }
        private string MakeRelativeWebPath(string FileName)
        {
            return string.Format("{0}{1}", this.Settings.WebPath, FileName);
        }
        private string GetFileName(string url, DateTime Date, string NewspaperId, bool IsBack, int ID)
        {
            string extension = Path.GetExtension(url);
            return string.Format("{4}{0}-{1}{3}{2}", new object[]
			{
				NewspaperId,
				Date.ToString("yyyyMMdd"),
				extension,
				IsBack ? "-back" : string.Empty,
				ID
			});
        }
        private string CreateUrl(DateTime dateTime)
        {
            return string.Format(this.Settings.UrlFormat, this.Settings.APIKey, dateTime);
        }


        public bool SaveCroppedImage(Image image, int maxWidth, int maxHeight, string filePath)
        {
            ImageCodecInfo jpgInfo = ImageCodecInfo.GetImageEncoders()
                                     .Where(codecInfo =>
                                     codecInfo.MimeType == "image/jpeg").First();
            Image finalImage = image;
            System.Drawing.Bitmap bitmap = null;
            try
            {
                int left = 0;
                int top = 0;
                int srcWidth = maxWidth;
                int srcHeight = maxHeight;
                bitmap = new System.Drawing.Bitmap(maxWidth, maxHeight);
                double croppedHeightToWidth = (double)maxHeight / maxWidth;
                double croppedWidthToHeight = (double)maxWidth / maxHeight;

                if (image.Width > image.Height)
                {
                    srcWidth = (int)(Math.Round(image.Height * croppedWidthToHeight));
                    if (srcWidth < image.Width)
                    {
                        srcHeight = image.Height;
                        left = (image.Width - srcWidth) / 2;
                    }
                    else
                    {
                        srcHeight = (int)Math.Round(image.Height * ((double)image.Width / srcWidth));
                        srcWidth = image.Width;
                        top = (image.Height - srcHeight) / 2;
                    }
                }
                else
                {
                    srcHeight = (int)(Math.Round(image.Width * croppedHeightToWidth));
                    if (srcHeight < image.Height)
                    {
                        srcWidth = image.Width;
                        top = (image.Height - srcHeight) / 2;
                    }
                    else
                    {
                        srcWidth = (int)Math.Round(image.Width * ((double)image.Height / srcHeight));
                        srcHeight = image.Height;
                        left = (image.Width - srcWidth) / 2;
                    }
                }
                using (Graphics g = Graphics.FromImage(bitmap))
                {
                    g.SmoothingMode = SmoothingMode.HighQuality;
                    g.PixelOffsetMode = PixelOffsetMode.HighQuality;
                    g.CompositingQuality = CompositingQuality.HighQuality;
                    g.InterpolationMode = InterpolationMode.HighQualityBicubic;
                    g.DrawImage(image, new Rectangle(0, 0, bitmap.Width, bitmap.Height),
                    new Rectangle(left, top, srcWidth, srcHeight), GraphicsUnit.Pixel);
                }
                finalImage = bitmap;
            }
            catch { }
            try
            {
                using (EncoderParameters encParams = new EncoderParameters(1))
                {
                    encParams.Param[0] = new EncoderParameter(System.Drawing.Imaging.Encoder.Quality, (long)100);
                    //quality should be in the range 
                    //[0..100] .. 100 for max, 0 for min (0 best compression)
                    finalImage.Save(filePath, jpgInfo, encParams);
                    return true;
                }
            }
            catch { }
            if (bitmap != null)
            {
                bitmap.Dispose();
            }
            return false;
        } 
 

        static Image FixedSize(Image imgPhoto, int Width, int Height)
        {
            int sourceWidth = imgPhoto.Width;
            int sourceHeight = imgPhoto.Height;
            int sourceX = 0;
            int sourceY = 0;
            int destX = 0;
            int destY = 0;

            float nPercent = 0;
            float nPercentW = 0;
            float nPercentH = 0;

            try
            {
                nPercentW = ((float)Width / (float)sourceWidth);
                nPercentH = ((float)Height / (float)sourceHeight);
                if (nPercentH < nPercentW)
                {
                    nPercent = nPercentH;
                    destX = System.Convert.ToInt16((Width - (sourceWidth * nPercent)) / 2);
                }
                else
                {
                    nPercent = nPercentW;
                    destY = System.Convert.ToInt16((Height - (sourceHeight * nPercent)) / 2);
                }

                int destWidth = (int)(sourceWidth * nPercent);
                int destHeight = (int)(sourceHeight * nPercent);

                Bitmap bmPhoto = new Bitmap(Width, Height, System.Drawing.Imaging.PixelFormat.Format24bppRgb);
                bmPhoto.SetResolution(imgPhoto.HorizontalResolution, imgPhoto.VerticalResolution);

                Graphics grPhoto = Graphics.FromImage(bmPhoto);
                grPhoto.Clear(Color.White);
                grPhoto.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.HighQualityBicubic;

                grPhoto.DrawImage(imgPhoto,
                    new Rectangle(destX, destY, destWidth, destHeight),
                    new Rectangle(sourceX, sourceY, sourceWidth, sourceHeight),
                    GraphicsUnit.Pixel);

                grPhoto.Dispose();
                return bmPhoto;
            }
            catch (Exception ex)
            {   
                return null;
            }
        }
    }
}
