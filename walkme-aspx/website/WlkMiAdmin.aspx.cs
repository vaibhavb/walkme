using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Text;
using System.Data.SqlClient;
using System.Linq;

namespace Microsoft.Health.Applications.WalkMe
{
    public partial class WlkMiAdmin : WlkMiBasePage
    {

        protected void Page_Load(object sender, EventArgs e)
        {
            // Check if user is admin, abort if not
            if (!PersonInfo.SelectedRecord.Id.Equals(Constants.AdminGuid))
            {
                Response.Clear();
                Response.Write("Not authorized");
                Response.End();
            }

            //TODO: Add ability to seed the sync mechanism and admins from admin page.
            //Obtain current time
            CurrentTime.Text = DateTime.Now.ToString("dddd, MMMM dd, yyyy HH:mm:ss");
            NumUsers.Text = ProfileModel.NumberOfUsers().ToString();
            numGoals.Text = GoalModel.NumberOfGoals().ToString();
            numLog.Text = WalkLogModel.NumberOfLogs().ToString();
            numWidgetImpressions.Text = AuditLogModelSql.TotalWidgetImpressions().ToString();

            if (!Page.IsPostBack)
            {
                LogCategories.DataSource = Enum.GetNames(typeof(WlkMiCat));
                LogEvents.DataSource = Enum.GetNames(typeof(WlkMiEvent));
            }
            this.DataBind();
        }


        protected void Page_PreRender(object sender, EventArgs e)
        {

        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            // Lets put the secret sync row in the table only if its not present
            DataClassesDataContext db = new DataClassesDataContext();
            var query = (from g in db.sync_settings
                         where g.sync_job_id == Constants.AppSyncRowKey
                         select g).FirstOrDefault();
            if (query == null)
            {
                sync_setting startRow = new sync_setting();
                startRow.sync_job_id = Constants.AppSyncRowKey;
                startRow.sync_status = Constants.SyncNotStarted;
                startRow.sync_frequency_hours = Constants.SyncFrequency;
                startRow.sync_server_name = this.Server.MachineName;
                startRow.sync_timestamp = DateTime.MinValue;
                db.GetTable<sync_setting>().InsertOnSubmit(startRow);
                db.SubmitChanges();
            }
        }


        protected void SearchButton_Click(object sender, EventArgs e)
        {
            GridViewAuditLogs.DataBind();
        }

        protected void ClearButton_Click(object sender, EventArgs e)
        {
            TextBoxSearch.Text = "";
            // TODO: Add an all category
            LogCategories.SelectedValue = Enum.GetName(typeof(WlkMiCat), WlkMiCat.Info);
            LogEvents.SelectedValue = Enum.GetName(typeof(WlkMiEvent), WlkMiEvent.UserSync);
            GridViewAuditLogs.DataBind();
        }

        protected void CatEvntButton_Click(object sender, EventArgs e)
        {
            TextBoxSearch.Text = "";
            GridViewAuditLogs.DataBind();
        }
    }
}