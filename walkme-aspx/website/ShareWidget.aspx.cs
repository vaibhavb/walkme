using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Microsoft.Health.Applications.WalkMe
{
    public partial class ShareWidget : WlkMiBasePage
    {
        protected override bool LogOnRequired
        {
            get
            {
                return false;
            }
        }

        /// <summary>
        /// Should not be SSL since the widget can do http only
        /// </summary>
        protected override bool IsPageSslSecure
        {
            get
            {
                return false;
            }
        }

        private string _userId = string.Empty;
        public string UserId
        {
            set
            {
                _userId = value;
            }
            get
            {
                return _userId;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            ((WlkMiMasterPage)Master).SetPageMetadata("WalkMe Sharing Widget", null, null);
            if (!String.IsNullOrEmpty(Request.QueryString["user_id"]))
            {
                UserId = Request.QueryString["user_id"];
            }
            else
            {
                ShowError("Invalid redirect, this page requires user_id");
            }
        }
    }
}