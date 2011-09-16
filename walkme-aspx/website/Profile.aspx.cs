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

namespace Microsoft.Health.Applications.WalkMe
{
    /// <summary>
    /// Just a placeholder page for the Profile Control, since we have a different control for 
    /// firsttime run it might make sense to pull that control here.
    /// TODO: Get rid of profile control
    /// </summary>
    public partial class MemberProfile : WlkMiBasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            ((WlkMiMasterPage)Master).SetPageMetadata("WalkMe User Profile", null, null);

            UserProfile.WlkMiProfile =
                base.WlkMiUser;
            // Clear the first user flow in case its going to be used.
            UserProfile.WlkMiProfile.IsNewUser = false;

            if (!string.IsNullOrEmpty(Request.QueryString["sync"]))
            {
                this.ph_sync.Visible = true;

            }


            // TODO: Coppied code over from HVDefault so that the Sync button can
            // post back to this page instead of the dashboard. Please verify that
            // it's correct.

            HttpCookie syncCookie = Request.Cookies[Constants.UserSyncCookieName];

            HandleCookieRefresh();

            if (CheckCookie(syncCookie))
            {
                if (!string.IsNullOrEmpty(Request.QueryString["dr"]) && Request.QueryString["dr"] == "true")
                {
                    HVSync.OnlineSyncUser(base.WlkMiUser, PersonInfo, false);
                }
                else
                {
                    HVSync.OnlineSyncUser(base.WlkMiUser, PersonInfo, true);
                }

            }
        }

        private void HandleCookieRefresh()
        {
            if (!string.IsNullOrEmpty(Request.QueryString["cr"]) && Request.QueryString["cr"] == "true")
            {
                base.ResetSyncCookie();
                if (!string.IsNullOrEmpty(Request.QueryString["dr"]) && Request.QueryString["dr"] == "true")
                {
                    Response.Redirect("~/Profile.aspx?dr=true&sync=true");
                }
            }
        }


    }
}