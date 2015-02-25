using System;
using System.ComponentModel;
using System.Data.Linq.Mapping;

namespace Newsbeast.ContentUpdateService.Newspapers
{
    [Table(Name = "dbo.cms_DC_NewsPapersCategories")]
    public class NewspaperCategory : INotifyPropertyChanging, INotifyPropertyChanged
    {
        private static PropertyChangingEventArgs emptyChangingEventArgs = new PropertyChangingEventArgs(string.Empty);
        private int _rowID;
        private int _langID;
        private string _status;
        private DateTime _statusChangedDate;
        private string _CatName;
        private int? _CatOrder;
        private string _CatCode;
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
        [Column(Storage = "_CatName", DbType = "NVarChar(500)")]
        public string CatName
        {
            get
            {
                return this._CatName;
            }
            set
            {
                if (this._CatName != value)
                {
                    this.SendPropertyChanging();
                    this._CatName = value;
                    this.SendPropertyChanged("CatName");
                }
            }
        }
        [Column(Storage = "_CatOrder", DbType = "Int")]
        public int? CatOrder
        {
            get
            {
                return this._CatOrder;
            }
            set
            {
                if (this._CatOrder != value)
                {
                    this.SendPropertyChanging();
                    this._CatOrder = value;
                    this.SendPropertyChanged("CatOrder");
                }
            }
        }
        [Column(Storage = "_CatCode", DbType = "NVarChar(500)")]
        public string CatCode
        {
            get
            {
                return this._CatCode;
            }
            set
            {
                if (this._CatCode != value)
                {
                    this.SendPropertyChanging();
                    this._CatCode = value;
                    this.SendPropertyChanged("CatCode");
                }
            }
        }
        protected virtual void SendPropertyChanging()
        {
            if (this.PropertyChanging != null)
            {
                this.PropertyChanging(this, NewspaperCategory.emptyChangingEventArgs);
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
