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
using Microsoft.Health;

namespace Microsoft.Health.Applications.WalkMe
{
    public partial class Controls_HVHeader : System.Web.UI.UserControl
    {

        private string userName;
        private string totalSteps;
        private bool hideNavLinks;

        public bool HideNavLinks
        {
            set
            {
                hideNavLinks = value;
            }
            get
            {
                return hideNavLinks;
            }
        }

        public string UserName
        {
            set
            {
                userName = value;
            }
            get
            {
                return userName;
            }
        }

        public string TotalSteps
        {
            set
            {
                totalSteps = value;
            }
            get
            {
                return totalSteps;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void SetNavigationStyles()
        {
            String path = Request.ServerVariables["PATH_INFO"].ToLower();

            if (!String.IsNullOrEmpty(path))
            {
                if (path.IndexOf("device.aspx") != -1 ||
                    path.IndexOf("device_setup.aspx") != -1 ||
                    path.IndexOf("device_setup_cc") != -1)
                {
                    this.div_devices.Attributes["class"] = "nav-item-on";
                }
                if (path.IndexOf("hvdefault.aspx") != -1)
                {
                    this.div_home.Attributes["class"] = "nav-item-strt-on";
                }
                if (path.IndexOf("profile.aspx") != -1)
                {
                    this.div_profile.Attributes["class"] = "nav-item-end-on";
                }
                if (path.IndexOf("history.aspx") != -1)
                {
                    this.div_charts.Attributes["class"] = "nav-item-on";
                }
                if (path.IndexOf("goals.aspx") != -1)
                {
                    this.div_goals.Attributes["class"] = "nav-item-on";
                }
                if (path.IndexOf("share.aspx") != -1)
                {
                    this.div_share.Attributes["class"] = "nav-item-on";
                }
                if (path.IndexOf("groups.aspx") != -1)
                {
                    this.div_groups.Attributes["class"] = "nav-item-on";
                }
                if (path.IndexOf("group_create.aspx") != -1)
                {
                    this.div_groups.Attributes["class"] = "nav-item-on";
                }
                if (path.IndexOf("group_search.aspx") != -1)
                {
                    this.div_groups.Attributes["class"] = "nav-item-on";
                }



            }

        }
        protected void Page_PreRender(object sender, EventArgs e)
        {

            WlkMiBasePage wlkMiPage = Page as WlkMiBasePage;
            if (wlkMiPage.LogOnIsRequired && wlkMiPage.IsLoggedIn)
            {
                HealthRecordInfo recordInfo = wlkMiPage.PersonInfo.SelectedRecord;

                if (recordInfo == null)
                {
                    UserName = "";
                }
                else
                {
                    UserName = recordInfo.Name + " (" + recordInfo.RelationshipName + ")";
                }

                if (wlkMiPage.WlkMiUser.UserCtx.user_total_steps.HasValue)
                    TotalSteps = String.Format("{0:0,0}",
                    (long)wlkMiPage.WlkMiUser.UserCtx.user_total_steps);

                plh_signedIn.Visible = true;
                plh_signedOut.Visible = false;

                if (HideNavLinks)
                {
                    plh_navigation.Visible = false;
                }
                else
                {
                    SetNavigationStyles();
                    plh_navigation.Visible = true;

                }

                lnk_logo.NavigateUrl = "~/hvdefault.aspx";
            }
            else
            {
                plh_navigation.Visible = false;
                plh_signedIn.Visible = false;
                plh_signedOut.Visible = true;

                lnk_logo.NavigateUrl = "~/default.aspx";
            }

        }
    }
}