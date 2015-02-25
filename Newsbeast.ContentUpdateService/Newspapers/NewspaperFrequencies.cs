using System;
using System.ComponentModel;
using System.Data.Linq.Mapping;
namespace Newsbeast.ContentUpdateService.Newspapers
{
    [Table(Name = "dbo.cms_DC_NewsPaperFreq")]
    public class NewspaperFrequencies : INotifyPropertyChanging, INotifyPropertyChanged
    {
        private static PropertyChangingEventArgs emptyChangingEventArgs = new PropertyChangingEventArgs(string.Empty);
        private int _rowID;
        private int _langID;
        private string _status;
        private DateTime _statusChangedDate;
        private string _fr_title;
        private string _fr_image;
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
        [Column(Storage = "_fr_title", DbType = "NVarChar(500)")]
        public string fr_title
        {
            get
            {
                return this._fr_title;
            }
            set
            {
                if (this._fr_title != value)
                {
                    this.SendPropertyChanging();
                    this._fr_title = value;
                    this.SendPropertyChanged("fr_title");
                }
            }
        }
        [Column(Storage = "_fr_image", DbType = "NVarChar(500)")]
        public string fr_image
        {
            get
            {
                return this._fr_image;
            }
            set
            {
                if (this._fr_image != value)
                {
                    this.SendPropertyChanging();
                    this._fr_image = value;
                    this.SendPropertyChanged("fr_image");
                }
            }
        }
        protected virtual void SendPropertyChanging()
        {
            if (this.PropertyChanging != null)
            {
                this.PropertyChanging(this, NewspaperFrequencies.emptyChangingEventArgs);
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
