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
    public partial class Device : WlkMiBasePage
    {

        protected void Page_Load(object sender, EventArgs e)
        {
            ((WlkMiMasterPage)Master).SetPageMetadata("WalkMe Devices", null, null);
        }
    }
}