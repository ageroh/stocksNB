using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Newsbeast.ContentUpdateService.Newspapers
{
    internal class NewspaperSettings : SettingsBase
    {
        private int _UpdateInterval;
        public string APIKey
        {
            get;
            set;
        }
        public string UserName
        {
            get;
            set;
        }
        public string Password
        {
            get;
            set;
        }
        public int UpdateInterval
        {
            get
            {
                return this._UpdateInterval;
            }
            set
            {
                this._UpdateInterval = value * 60 * 1000;
            }
        }
        public string UrlFormat
        {
            get;
            set;
        }
        public int RequestTimeout
        {
            get;
            set;
        }
        public string WebPath
        {
            get;
            set;
        }
        public string PhysicalPath
        {
            get;
            set;
        }
        public string NotificationRecipients
        {
            get;
            set;
        }
        public string OnSuccessUrl
        {
            get;
            set;
        }
    }
}
