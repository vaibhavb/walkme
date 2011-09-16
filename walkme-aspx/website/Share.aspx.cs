using System;
using System.Linq;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Xml.Linq;
using System.Web.Services;
using System.Collections.Generic;

namespace Microsoft.Health.Applications.WalkMe
{
    public partial class Share : WlkMiBasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            ((WlkMiMasterPage)Master).SetPageMetadata("WalkMe Sharing", null, null);
        }

    }
}