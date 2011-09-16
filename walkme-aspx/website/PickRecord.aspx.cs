using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;

using Microsoft.Health;
using Microsoft.Health.Web;

namespace Microsoft.Health.Applications.WalkMe
{
    public partial class PickRecord : WlkMiBasePage
    {
        protected void Page_Load(Object sender, EventArgs e)
        {
            ((WlkMiMasterPage)Master).SetPageMetadata("Select Record", null, null);

            AuthenticatedConnection service = this.PersonInfo.Connection;
            PersonInfo personInfo = service.GetPersonInfo();

            String idSelected = Request.QueryString["id"];
            if (idSelected != null)
            {
                Guid guidSelected = new Guid(idSelected);
                if (personInfo.AuthorizedRecords.ContainsKey(guidSelected))
                {
                    this.SetSelectedRecord(
                        personInfo.AuthorizedRecords[guidSelected]);
                    base.RefreshUserCtx();
                }
            }

            datalistRecords.DataSource = personInfo.AuthorizedRecords.Values;
            datalistRecords.DataBind();

        }


        protected void LinkButtonAuthNewRecord_Click(object sender, EventArgs e)
        {
            HealthServicePage page = HttpContext.Current.CurrentHandler as
                    HealthServicePage;

            if (page.IsLoggedIn)
            {
                StringBuilder sb = new StringBuilder(128);

                sb.Append("appid=");
                sb.Append(WebApplicationConfiguration.AppId.ToString());
                sb.Append("&actionqs=");
                sb.Append(HttpUtility.UrlEncode(String.Concat(
                    "redirect=",
                    HttpUtility.UrlEncode(Request.Url.PathAndQuery))));

                page.RedirectToShellUrl(
                    "APPAUTH",
                    sb.ToString());
            }


        }
    }
}