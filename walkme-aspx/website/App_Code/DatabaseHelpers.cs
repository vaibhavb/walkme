using System;
using System.Data;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using System.Collections.Generic;
using System.Data.Linq;

namespace Microsoft.Health.Applications.WalkMe
{
    public static class DatabaseHelper
    {
        public const string ConnectionStringName = "WalkMeConnectionString";

        public static DataClassesDataContext GetDashboardData()
        {
            var db = new DataClassesDataContext();
            return db;
        }

        public static void Update<T>(T obj, Action<T> update) where T : class
        {
            using (var db = GetDashboardData())
            {
                db.GetTable<T>().Attach(obj);
                update(obj);
                db.SubmitChanges();
            }
        }
        public static void UpdateAll<T>(List<T> items, Action<T> update) where T : class
        {
            using (var db = GetDashboardData())
            {
                Table<T> table = db.GetTable<T>();
                foreach (T item in items)
                {
                    table.Attach(item);
                    update(item);
                }

                db.SubmitChanges();
            }
        }
        public static void Delete<T>(T entity) where T : class, new()
        {
            using (var db = GetDashboardData())
            {
                Table<T> table = db.GetTable<T>();
                table.Attach(entity);
                table.DeleteOnSubmit(entity);
                db.SubmitChanges();
            }
        }
        public static void Insert<T>(T obj) where T : class
        {
            using (var db = GetDashboardData())
            {
                db.GetTable<T>().InsertOnSubmit(obj);
                db.SubmitChanges();
            }
        }
    }

    /// <summary>
    /// Summary description for LinqHelpers
    /// </summary>
    public partial class DataClassesDataContext
    {
        //partial void Insertuser(user instance)
        //{
        //    instance.created_at = DateTime.Now;
        //}
        //partial void Updateuser(user instance)
        //{
        //    instance.updated_at = DateTime.Now;
        //}
    }

}