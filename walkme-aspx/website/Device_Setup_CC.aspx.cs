using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Microsoft.Health.Applications.WalkMe
{
    public partial class Device_Setup_CC : WlkMiBasePage
    {


        protected void Page_Load(object sender, EventArgs e)
        {
            ((WlkMiMasterPage)Master).SetPageMetadata("WalkMe Device Setup", null, null);
        }
    }
}