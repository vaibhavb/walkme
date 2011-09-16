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

namespace Microsoft.Health.Applications.WalkMe
{
    public partial class SignOut : WlkMiBasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            WlkMiTracer.Instance.Log("SignOut.aspx.cs", WlkMiEvent.AppDomain,
                WlkMiCat.Info, string.Format("Signout Event User: {0}",
                base.WlkMiUser.UserCtx.user_id.ToString()));
            this.SignOut();
            base.ResetSyncCookie();
        }
    }
}