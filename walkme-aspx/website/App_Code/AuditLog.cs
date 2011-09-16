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
using System.Data.SqlClient;

namespace Microsoft.Health.Applications.WalkMe
{
    public static class AuditLogModelSql
    {
        /// <summary>
        /// Get all the audit logs
        /// </summary>
        /// <param name="partnerInfoConnection">connection string</param>
        /// <returns>DataSet</returns>
        public static DataSet GetLogsWithSearch(string WlkMiSearchString, 
            string WlkMiCategory,
            string WlkMiEventVar)
        {

            WlkMiCat cat = WlkMiCat.Info;
            if (!string.IsNullOrEmpty(WlkMiCategory))
            {
                cat = (WlkMiCat)Enum.Parse(typeof(WlkMiCat), WlkMiCategory);
            }
            WlkMiEvent evnt = WlkMiEvent.UserSync;
            if (!string.IsNullOrEmpty(WlkMiEventVar))
            {
                evnt = (WlkMiEvent)Enum.Parse(typeof(WlkMiEvent), WlkMiEventVar);
            }

            if (!String.IsNullOrEmpty(WlkMiSearchString))
            {

                string wlkMiSearchString = WlkMiSearchString.TrimEnd();
                wlkMiSearchString = wlkMiSearchString.TrimStart();
                SqlCommand sql = new SqlCommand(
                    string.Format("select * from wc_audit_log where (application_name like '%{0}%' or " +
                                        "event_message like '%{0}%') and (event_id = {1})" + 
                                        " and (event_severity = {2}) ", 
                                        wlkMiSearchString,
                                        (ushort) evnt,
                                        (ushort) cat),
                    new SqlConnection(Constants.ConnectionString));
                DataSet ds = new DataSet();
                SqlDataAdapter sqlData = new SqlDataAdapter(sql);
                sqlData.Fill(ds);
                return ds;
            }
            else
            {
                SqlCommand sql = new SqlCommand(
                    string.Format("select * from wc_audit_log where (event_id = {0})" +
                                        " and (event_severity = {1}) ",
                                        (ushort)evnt,
                                        (ushort)cat),
                    new SqlConnection(Constants.ConnectionString));
                DataSet ds = new DataSet();
                SqlDataAdapter sqlData = new SqlDataAdapter(sql);
                sqlData.Fill(ds);
                return ds;
            }
        }

        public static DataSet GetLogsByCategory(WlkMiCat categoryType)
        {            
            SqlParameter param = new SqlParameter("@categoryType", categoryType);
            SqlCommand sql = new SqlCommand(
                "select * from wc_audit_log where event_id=@categoryType",
                new SqlConnection(Constants.ConnectionString));
            sql.Parameters.Add(param);

            DataSet ds = new DataSet();
            SqlDataAdapter sqlData = new SqlDataAdapter(sql);
            sqlData.Fill(ds);
            return ds;
        }

        public static int TotalWidgetImpressions()
        {
            DataClassesDataContext db = new DataClassesDataContext();
            var query = (from g in db.wc_audit_logs
                         where (g.event_id == (int) WlkMiEvent.WidgetRss ||
                                g.event_id == (int) WlkMiEvent.WidgetImg ||
                                g.event_id == (int) WlkMiEvent.Widget) &&
                                g.event_severity == (int) WlkMiCat.Info                               
                         select g).Count();
            return query;
        }

    }
}
