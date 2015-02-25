using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Linq;
using System.Data.Linq.Mapping;
using System.Data.SqlClient;
using Newsbeast.ContentUpdateService.Properties;

namespace Newsbeast.ContentUpdateService.Newspapers
{
    [Database(Name = "Newsbeast_no_tables")]
    public class NewspapersDataContext : DataContext
    {
        private static MappingSource mappingSource = new AttributeMappingSource();
        private Dictionary<string, int> Keys = new Dictionary<string, int>();
        private object lockobject = new object();
        public Table<NewspaperFrequencies> NewspaperFrequencies
        {
            get
            {
                return base.GetTable<NewspaperFrequencies>();
            }
        }
        public Table<NewspaperPublication> NewspaperPublications
        {
            get
            {
                return base.GetTable<NewspaperPublication>();
            }
        }
        public Table<Newspaper> Newspapers
        {
            get
            {
                return base.GetTable<Newspaper>();
            }
        }
        public Table<NewspaperCategory> NewspaperCategories
        {
            get
            {
                return base.GetTable<NewspaperCategory>();
            }
        }
        public NewspapersDataContext()
            : base(Settings.Default.NewsBeastConnectionString, NewspapersDataContext.mappingSource)
        {
        }
        public NewspapersDataContext(string connection)
            : base(connection, NewspapersDataContext.mappingSource)
        {
        }
        public NewspapersDataContext(IDbConnection connection)
            : base(connection, NewspapersDataContext.mappingSource)
        {
        }
        public NewspapersDataContext(string connection, MappingSource mappingSource)
            : base(connection, mappingSource)
        {
        }
        public NewspapersDataContext(IDbConnection connection, MappingSource mappingSource)
            : base(connection, mappingSource)
        {
        }
        public override void SubmitChanges(ConflictMode failureMode)
        {
            if (this.Keys.Count > 0)
            {
                foreach (KeyValuePair<string, int> current in this.Keys)
                {
                    using (SqlCommand sqlCommand = new SqlCommand(string.Empty, base.Connection as SqlConnection))
                    {
                        sqlCommand.CommandText = "\r\nUPDATE [cms_Identities]\r\n   SET [IdentityValue] = @Value\r\n WHERE [IdentityKey] = @Key\r\n";
                        sqlCommand.Parameters.AddWithValue("@Key", current.Key);
                        sqlCommand.Parameters.AddWithValue("@Value", current.Value);
                        sqlCommand.ExecuteNonQuery();
                    }
                }
            }
            base.SubmitChanges(failureMode);
        }
        public int GetId(string TableName, string Column)
        {
            int result;
            using (SqlCommand sqlCommand = new SqlCommand(string.Empty, new SqlConnection(base.Connection.ConnectionString)))
            {
                sqlCommand.Connection.Open();
                sqlCommand.CommandText = "\r\nDECLARE @Id INT\r\nEXEC dbo.cms_GetNewId @Table,\r\n    @Field,\r\n    @NewId = @Id OUTPUT\r\nSELECT @Id\r\n";
                sqlCommand.Parameters.AddWithValue("@Table", TableName);
                sqlCommand.Parameters.AddWithValue("@Field", Column);
                try
                {
                    result = (int)sqlCommand.ExecuteScalar();
                }
                finally
                {
                    sqlCommand.Connection.Close();
                }
            }
            return result;
        }
    }
}
