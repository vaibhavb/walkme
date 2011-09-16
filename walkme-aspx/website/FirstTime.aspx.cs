using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using Microsoft.Health.Applications.WalkMe;

namespace Microsoft.Health.Applications.WalkMe
{
    public partial class FirstTime : WlkMiBasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            WlkMiMasterPage mstrpg = (WlkMiMasterPage)Page.Master;
            mstrpg.SetPageMetadata("Welcome to WalkMe First Time User", null, null);
            mstrpg.HideNav();

            //Fetch information from HealthVault for this user.
            base.WlkMiUser = PopulateWithHVData(base.WlkMiUser);
            base.WlkMiUser.UserCtx.user_nickname =
                base.PersonInfo.SelectedRecord.Name.Replace(" ", "");

            First.WlkMiProfile =
                base.WlkMiUser;
        }

    }
}