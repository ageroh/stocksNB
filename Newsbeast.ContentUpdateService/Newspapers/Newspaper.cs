using System;
using System.ComponentModel;
using System.Data.Linq.Mapping;

namespace Newsbeast.ContentUpdateService.Newspapers
{
    [Table(Name = "dbo.cms_DC_NewsPapers")]
    public class Newspaper : INotifyPropertyChanging, INotifyPropertyChanged
    {
        private static PropertyChangingEventArgs emptyChangingEventArgs = new PropertyChangingEventArgs(string.Empty);
        private int _rowID;
        private int _langID;
        private string _status;
        private DateTime _statusChangedDate;
        private string _Title;
        private string _PaperUrl;
        private string _Category;
        private string _ID;
        private string _freq;
        private bool? _isInactive;
        public event PropertyChangingEventHandler PropertyChanging;
        public event PropertyChangedEventHandler PropertyChanged;
        [Column(Storage = "_rowID", DbType = "Int NOT NULL", IsPrimaryKey = true)]
        public int rowID
        {
            get
            {
                return this._rowID;
            }
            set
            {
                if (this._rowID != value)
                {
                    this.SendPropertyChanging();
                    this._rowID = value;
                    this.SendPropertyChanged("rowID");
                }
            }
        }
        [Column(Storage = "_langID", DbType = "Int NOT NULL", IsPrimaryKey = true)]
        public int langID
        {
            get
            {
                return this._langID;
            }
            set
            {
                if (this._langID != value)
                {
                    this.SendPropertyChanging();
                    this._langID = value;
                    this.SendPropertyChanged("langID");
                }
            }
        }
        [Column(Storage = "_status", DbType = "VarChar(30) NOT NULL", CanBeNull = false, IsPrimaryKey = true)]
        public string status
        {
            get
            {
                return this._status;
            }
            set
            {
                if (this._status != value)
                {
                    this.SendPropertyChanging();
                    this._status = value;
                    this.SendPropertyChanged("status");
                }
            }
        }
        [Column(Storage = "_statusChangedDate", DbType = "DateTime NOT NULL")]
        public DateTime statusChangedDate
        {
            get
            {
                return this._statusChangedDate;
            }
            set
            {
                if (this._statusChangedDate != value)
                {
                    this.SendPropertyChanging();
                    this._statusChangedDate = value;
                    this.SendPropertyChanged("statusChangedDate");
                }
            }
        }
        [Column(Storage = "_Title", DbType = "NVarChar(500)")]
        public string Title
        {
            get
            {
                return this._Title;
            }
            set
            {
                if (this._Title != value)
                {
                    this.SendPropertyChanging();
                    this._Title = value;
                    this.SendPropertyChanged("Title");
                }
            }
        }
        [Column(Storage = "_PaperUrl", DbType = "NVarChar(500)")]
        public string PaperUrl
        {
            get
            {
                return this._PaperUrl;
            }
            set
            {
                if (this._PaperUrl != value)
                {
                    this.SendPropertyChanging();
                    this._PaperUrl = value;
                    this.SendPropertyChanged("PaperUrl");
                }
            }
        }
        [Column(Storage = "_Category", DbType = "NVarChar(500)")]
        public string Category
        {
            get
            {
                return this._Category;
            }
            set
            {
                if (this._Category != value)
                {
                    this.SendPropertyChanging();
                    this._Category = value;
                    this.SendPropertyChanged("Category");
                }
            }
        }
        [Column(Storage = "_ID", DbType = "NVarChar(500)")]
        public string ID
        {
            get
            {
                return this._ID;
            }
            set
            {
                if (this._ID != value)
                {
                    this.SendPropertyChanging();
                    this._ID = value;
                    this.SendPropertyChanged("ID");
                }
            }
        }
        [Column(Storage = "_freq", DbType = "NVarChar(500)")]
        public string freq
        {
            get
            {
                return this._freq;
            }
            set
            {
                if (this._freq != value)
                {
                    this.SendPropertyChanging();
                    this._freq = value;
                    this.SendPropertyChanged("freq");
                }
            }
        }
        [Column(Storage = "_isInactive", DbType = "Bit")]
        public bool? isInactive
        {
            get
            {
                return this._isInactive;
            }
            set
            {
                if (this._isInactive != value)
                {
                    this.SendPropertyChanging();
                    this._isInactive = value;
                    this.SendPropertyChanged("isInactive");
                }
            }
        }
        protected virtual void SendPropertyChanging()
        {
            if (this.PropertyChanging != null)
            {
                this.PropertyChanging(this, Newspaper.emptyChangingEventArgs);
            }
        }
        protected virtual void SendPropertyChanged(string propertyName)
        {
            if (this.PropertyChanged != null)
            {
                this.PropertyChanged(this, new PropertyChangedEventArgs(propertyName));
            }
        }
    }
}
