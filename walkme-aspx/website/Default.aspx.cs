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
    public partial class Default : WlkMiBasePage
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

        protected new void Page_Init(object sender, EventArgs e)
        {
            StepsWalked.Text = String.Format("{0:0,0}",
                    WalkLogModel.TotalStepsWalked());
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            //TODO: Add alt field to image tags 
            ((WlkMiMasterPage)Master).SetPageMetadata("WalkMe Home", null, null);
        }
    }
}
