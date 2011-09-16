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
    public partial class Goals : WlkMiBasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Goal.WlkMiGoalModel = GoalModel.Fetch(
          this.WlkMiUser.UserCtx.user_id);
            ((WlkMiMasterPage)Master).SetPageMetadata("WalkMe Set Goals", null, null);
        }
    }
}