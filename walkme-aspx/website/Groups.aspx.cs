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
    public partial class Groups : WlkMiBasePage
    {
        public bool isGroupMember = false;
        private int g_id = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            ((WlkMiMasterPage)Master).SetPageMetadata("WalkMe Groups", null, null);

            int join = 0;
            int leave = 0;
            int invite = 0;

            Int32.TryParse(Page.Request.QueryString["g_id"], out g_id);
            Int32.TryParse(Page.Request.QueryString["join"], out join);
            Int32.TryParse(Page.Request.QueryString["leave"], out leave);
            Int32.TryParse(Page.Request.QueryString["invite"], out invite);


            if (join > 0)
            {
                //join group
                GroupModel.JoinGroup(join, base.WlkMiUser.UserCtx.user_id);
                Response.Redirect("groups.aspx");
            }
            else if (leave > 0)
            {
                //leave group
                GroupModel.LeaveGroup(leave, base.WlkMiUser.UserCtx.user_id);
                //if no more users in group, remove group
                if (GroupModel.NumUsers(leave) == 0)
                {
                    GroupModel.DeleteGroup(leave);
                }
                Response.Redirect("groups.aspx");
            }
            else if (g_id > 0 && invite == 0)
            {
                ShowGeneral.Visible = false;
                ShowMyGroupInvite.Visible = false;
                ph_group_actions.Visible = true;
                ph_toolbar.Visible = true;

                GroupModel g = GroupModel.Fetch(g_id);

                lnk_invite.NavigateUrl = String.Format("groups.aspx?g_id={0}&invite={0}", g_id);

                if (g == null)
                {
                    return;
                }
                groupStepCount sum = GroupModel.TotalNumSteps(g_id);
                if (g.data.group_private == 0)
                {
                    if (GroupModel.IsGroupMember(g_id, this.WlkMiUser.UserCtx.user_id))
                    {
                        //part of group, allow user to leave group
                        ShowMyGroupDetails.Visible = true;
                        rankStruct rank = GroupModel.GroupUserRank(g_id, this.WlkMiUser);
                        GroupNumPeople.Text = rank.number.ToString();
                        GroupRank.Text = DataConversion.AddOrdinalSuffix(rank.rank);
                        //part of group, allow user to leave group
                        ActionText.Text = String.Format("<a class='toolbarlnk' href='groups.aspx?leave={0}'>Leave Group</a>", g_id);

                    }
                    else
                    {
                        //not part of group enable ability to joing group
                        ActionText.Text = String.Format("<a class='toolbarlnk' href='groups.aspx?join={0}'>Join Group</a>", g_id);
                    }

                    GroupNumUsers.Text = GroupModel.NumUsers(g_id).ToString();
                    GroupWeeklySteps.Text = String.Format("{0:0,0}", sum.weekly);
                    GroupMonthlySteps.Text = String.Format("{0:0,0}", sum.monthly);
                    GroupAnnualSteps.Text = String.Format("{0:0,0}", sum.annual);
                    GroupTotalSteps.Text = String.Format("{0:0,0}", sum.total);

                    GroupModel.GroupUserList(g_id, GroupUserList);

                    lbl_groupName.Text = g.data.group_name.ToString();
                    lbl_groupDesc.Text = g.data.group_description.ToString();
                }
            }
            else if (g_id > 0 && invite > 0)
            {
                GroupModel g = GroupModel.Fetch(g_id);
                ShowGeneral.Visible = false;
                ShowMyGroupInvite.Visible = true;
                ph_toolbar.Visible = false;
                ph_group_actions.Visible = false;
                String searchURL = String.Format("http://apps.healthvault.com/app4/groups.aspx?join={0}", g_id);
                lnk_search_url.NavigateUrl = searchURL;
                lnk_search_url.Text = searchURL;


            }
            else
            {
                ShowGeneral.Visible = true;
                ShowMyGroupInvite.Visible = false;
                ph_group_actions.Visible = false;
                ph_toolbar.Visible = true;
                GroupModel.FetchTop5(Top5Groups);
                GroupModel.MyGroupList(this.WlkMiUser.UserCtx.user_id, MyGroups);
            }
        }
        public void DoFinish(object sender, EventArgs e)
        {
            Response.Redirect(String.Format("groups.aspx?g_id={0}", g_id));
        }

    }
}