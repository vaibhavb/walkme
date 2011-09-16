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
using System.Net;
using System.Threading;
using System.Linq;

using Microsoft.Security.Application;
using Microsoft.Health;

namespace Microsoft.Health.Applications.WalkMe
{
    public partial class HVDefault : WlkMiBasePage
    {

        protected void Page_Load(object sender, EventArgs e)
        {
            ((WlkMiMasterPage)Master).SetPageMetadata("WalkMe Home", null, null);

            // TODO: Infrastructure to display user messages, with a close (X) box
            if (base.WlkMiUser.IsNewUser)
            {
                // TODO: We should not do loggin here
                string msg = string.Format("New User Created User: {0}",
                    base.WlkMiUser.UserCtx.user_id.ToString());
                AppTracer.Log("HVDefault.aspx.cs", WlkMiEvent.UserCreated, WlkMiCat.Info, msg);
                Server.Transfer("~/FirstTime.aspx");
            }
            else
            {
                HttpCookie syncCookie = Request.Cookies[Constants.UserSyncCookieName];

                HandleCookieRefresh();

                if (CheckCookie(syncCookie))
                {
                    // Write the cookie and set the expirate time
                    // TODO: Possibly add more user info like id, last login etx.
                    SetSyncCookie();

                    string msg = string.Format("Syncing User: {0} and writing sync cookie",
                        base.WlkMiUser.UserCtx.user_id.ToString());
                    AppTracer.Log("HVDefault.aspx.cs", WlkMiEvent.UserSync,
                        WlkMiCat.Info, msg);

                    //// Asynchronous processing 
                    //TaskManager tasker = new TaskManager(base.WlkMiUser, PersonInfo);
                    //Guid task = tasker.AddTask(PersonInfo.SelectedRecord.Id);
                    //Thread SyncThread = new Thread(new ThreadStart(tasker.DoHVSync));
                    //SyncThread.Start();

                    //Response.Redirect(string.Format("~/Processing.aspx?t={0}&r={1}",
                    //    task.ToString(), AntiXss.UrlEncode(Request.Url.ToString())));

                    //Response.Buffer = false;
                    //Response.Write("Syncing with HealthVault ...");

                    if (!string.IsNullOrEmpty(Request.QueryString["dr"]) && Request.QueryString["dr"] == "true")
                    {
                        HVSync.OnlineSyncUser(base.WlkMiUser, PersonInfo, false);
                    }
                    else
                    {
                        HVSync.OnlineSyncUser(base.WlkMiUser, PersonInfo, true);
                    }

                    // We do Request.Url so that query params for the first time user are saved
                    // TODO: we should render first hit panel if there is nothing to display in graphs
                    Response.Redirect(Request.Url.ToString());
                }
            }
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            // Weekly steps graph
            if (!base.WlkMiUser.IsNewUser)
            {

                if (this.WlkMiUser.UserCtx.user_weekly_steps.Value > 0)
                {
                    GraphingLayer graphWeekly = MakeGraph("Steps", "WeekTrend");
                    ShowFlashWeekly.lineGraph = graphWeekly;

                    string weeklySteps = String.Format("{0:0,0}", this.WlkMiUser.UserCtx.user_weekly_steps.Value);
                    string goalSteps = String.Format("{0:0,0}", (7 * this.WlkMiUser.UserCtx.daily_goal_steps.Value));

                    WeeklyStep.Text = String.Format
                        ("You have completed {0} of your {1} step goal for this week",
                        weeklySteps, goalSteps);
                }
                else if (this.WlkMiUser.UserCtx.user_monthly_steps.Value > 0)
                {
                    GraphingLayer graphMonthly = MakeGraph("Steps", "Month");
                    ShowFlashWeekly.lineGraph = graphMonthly;

                    WeeklyStep.Text = "Now all you need to do is take some steps for this week";
                }
                else if (this.WlkMiUser.UserCtx.user_annual_steps.Value > 0)
                {
                    GraphingLayer graphYearly = MakeGraph("Steps", "Year");
                    ShowFlashWeekly.lineGraph = graphYearly;

                    WeeklyStep.Text = "Now all you need to do is take some steps for this week";
                }
                else
                {
                    WeeklyStep.Text = "Now all you need to do is take some steps";
                }
            }
            else
            {
                RenderFirstHitPanel();
            }
        }

        private void RenderFirstHitPanel()
        {
            if (!String.IsNullOrEmpty(Request.QueryString["ft"]) && Request.QueryString["ft"] == "true")
            {
                this.pnl_firstHit.Visible = true;
            }
        }

        private void HandleCookieRefresh()
        {
            if (!string.IsNullOrEmpty(Request.QueryString["cr"]) && Request.QueryString["cr"] == "true")
            {
                base.ResetSyncCookie();
                if (!string.IsNullOrEmpty(Request.QueryString["dr"]) && Request.QueryString["dr"] == "true")
                {
                    Response.Redirect("~/HVDefault.aspx?dr=true");
                }
            }
        }

        public class TaskManager
        {
            private Guid m_task_id;
            private Guid m_record_id;
            private ProfileModel m_wlkmi_user;
            private PersonInfo m_hv_user;

            public TaskManager(ProfileModel wlkmi_user, PersonInfo hv_user)
            {
                m_hv_user = hv_user;
                m_wlkmi_user = wlkmi_user;
            }

            public Guid AddTask(Guid recordId)
            {
                Guid g = Guid.NewGuid();
                DataClassesDataContext db = new DataClassesDataContext();
                sync_setting syncTask = new sync_setting();
                syncTask.sync_server_name = g.ToString();
                syncTask.sync_status = 3;
                syncTask.sync_frequency_hours = 0;
                syncTask.sync_timestamp = DateTime.Now;
                db.GetTable<sync_setting>().InsertOnSubmit(syncTask);
                db.SubmitChanges();
                m_task_id = g;
                m_record_id = recordId;
                return g;
            }

            public void DoHVSync()
            {
                HVSync.OnlineSyncUser(m_wlkmi_user, m_hv_user, true);
                FinishTask();
            }

            public void FinishTask()
            {
                DataClassesDataContext db = new DataClassesDataContext();
                var query = (from g in db.sync_settings
                             where g.sync_server_name == m_task_id.ToString()
                             select g).SingleOrDefault();
                query.sync_status = 4;
                db.SubmitChanges();
            }
        }
    }
}