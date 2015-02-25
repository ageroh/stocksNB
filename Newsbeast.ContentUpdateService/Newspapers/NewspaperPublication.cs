using System;
using System.ComponentModel;
using System.Data.Linq.Mapping;

namespace Newsbeast.ContentUpdateService.Newspapers
{
    [Table(Name = "dbo.cms_DC_NewsPaperPublications")]
    public class NewspaperPublication : INotifyPropertyChanging, INotifyPropertyChanged
    {
        private static PropertyChangingEventArgs emptyChangingEventArgs = new PropertyChangingEventArgs(string.Empty);
        private int _rowID;
        private int _langID;
        private string _status;
        private DateTime _statusChangedDate;
        private string _Publ_Title;
        private DateTime? _Publ_Date;
        private string _Publ_Photo;
        private string _Publ_ID;
        private bool? _Pub_back;
        private bool? _copied;
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
        [Column(Storage = "_Publ_Title", DbType = "NVarChar(500)")]
        public string Publ_Title
        {
            get
            {
                return this._Publ_Title;
            }
            set
            {
                if (this._Publ_Title != value)
                {
                    this.SendPropertyChanging();
                    this._Publ_Title = value;
                    this.SendPropertyChanged("Publ_Title");
                }
            }
        }
        [Column(Storage = "_Publ_Date", DbType = "DateTime")]
        public DateTime? Publ_Date
        {
            get
            {
                return this._Publ_Date;
            }
            set
            {
                if (this._Publ_Date != value)
                {
                    this.SendPropertyChanging();
                    this._Publ_Date = value;
                    this.SendPropertyChanged("Publ_Date");
                }
            }
        }
        [Column(Storage = "_Publ_Photo", DbType = "NVarChar(500)")]
        public string Publ_Photo
        {
            get
            {
                return this._Publ_Photo;
            }
            set
            {
                if (this._Publ_Photo != value)
                {
                    this.SendPropertyChanging();
                    this._Publ_Photo = value;
                    this.SendPropertyChanged("Publ_Photo");
                }
            }
        }
        [Column(Storage = "_Publ_ID", DbType = "NVarChar(500)")]
        public string Publ_ID
        {
            get
            {
                return this._Publ_ID;
            }
            set
            {
                if (this._Publ_ID != value)
                {
                    this.SendPropertyChanging();
                    this._Publ_ID = value;
                    this.SendPropertyChanged("Publ_ID");
                }
            }
        }
        [Column(Storage = "_Pub_back", DbType = "Bit")]
        public bool? Pub_back
        {
            get
            {
                return this._Pub_back;
            }
            set
            {
                if (this._Pub_back != value)
                {
                    this.SendPropertyChanging();
                    this._Pub_back = value;
                    this.SendPropertyChanged("Pub_back");
                }
            }
        }
        [Column(Storage = "_copied", DbType = "Bit")]
        public bool? copied
        {
            get
            {
                return this._copied;
            }
            set
            {
                if (this._copied != value)
                {
                    this.SendPropertyChanging();
                    this._copied = value;
                    this.SendPropertyChanged("copied");
                }
            }
        }
        protected virtual void SendPropertyChanging()
        {
            if (this.PropertyChanging != null)
            {
                this.PropertyChanging(this, NewspaperPublication.emptyChangingEventArgs);
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
