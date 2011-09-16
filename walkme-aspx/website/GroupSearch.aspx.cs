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
    public partial class GroupsSearch : WlkMiBasePage
    {

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Page.Request.QueryString.Count > 0)
            {
                GroupModel.Search(Page.Request.QueryString["search"], Results);
            }
            ((WlkMiMasterPage)Master).SetPageMetadata("WalkMe Search Group", null, null);
        }

        public void DoSubmit(object sender, EventArgs e)
        {
            StringBuilder sb = new StringBuilder("group_search.aspx?search=#search#");
            sb.Replace("#search#", GroupSearch.Text);
            //new_group.group_name = GroupName.Text;
            Response.Redirect(sb.ToString());
        }
    }
}