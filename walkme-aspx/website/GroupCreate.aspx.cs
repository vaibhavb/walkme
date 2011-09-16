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
    public partial class GroupCreate : WlkMiBasePage
    {

        protected void Page_Load(object sender, EventArgs e)
        {
            ((WlkMiMasterPage)Master).SetPageMetadata("WalkMe Create Group", null, null);
        }

        public void DoSubmit(object sender, EventArgs e)
        {
            group new_group = new group();
            new_group.group_name = GroupName.Text;
            new_group.group_description = Groupdesc.Text;
            //TODO not handle private at this time since we do not have email yet
            //Int32.TryParse(GroupPrivate.SelectedValue, out group_priv);
            new_group.group_private = 0;
            new_group.created_at = DateTime.Now;
            int g_id = GroupModel.SaveGroup(new_group);
            GroupModel.JoinGroup(g_id, this.WlkMiUser.UserCtx.user_id);


            pnl_forms.Visible = false;
            pnl_results.Visible = true;

            lbl_groupDescription.Text = Groupdesc.Text;
            lbl_groupName.Text = GroupName.Text;
            lbl_groupName2.Text = g_id.ToString();


        }
        public void DoFinish(object sender, EventArgs e)
        {
            Response.Redirect("groups.aspx");
        }

    }
}