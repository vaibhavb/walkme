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

using Microsoft.Health;

namespace Microsoft.Health.Applications.WalkMe
{
    public partial class Details : WlkMiBasePage
    {
        protected override bool LogOnRequired
        {
            get
            {
                return false;
            }
        }



        protected void Page_Load(object sender, EventArgs e)
        {
            //TODO: Add alt field to image tags 
            ((WlkMiMasterPage)Master).SetPageMetadata("WalkMe Home", null, null);
            string href = "https://accountservices.passport.net/reg.srf?wa=wsignin1.0&rpsnv=10&ct=1232750082&rver=4.5.2130.0&wp=HBI&wreply={SHELLURL}auth.aspx%3Fappid%3D{APPID}%26redirect%3Dhttp%253a%252f%252fapps.healthvault.com%252fapp4%252fRedirect.aspx%26trm%3Dpost%26cbpage%3Dlogin%26lc%3D1033%26x%3D6.0.11557.0&id=255006&cb=appid%3d{APPID}%26redirect%3dhttp%253a%252f%252fapps.healthvault.com%252fapp4%252fRedirect.aspx%26trm%3dpost%26cbpage%3dlogin%26lc%3d1033%26x%3d6.0.11557.0&sl=1&lc=1033";
            // TODO: replace this with web application configuration class
            string shell = HttpUtility.HtmlEncode(System.Configuration.
                        ConfigurationManager.AppSettings["ShellUrl"]);
            string appid = HttpUtility.HtmlEncode(System.Configuration.
                ConfigurationManager.AppSettings["ApplicationId"]);

            href = href.Replace("{SHELLURL}", shell);
            href = href.Replace("{APPID}", appid);

            //TODO: Configure redirect url properly
            LinkToPassport.HRef = href;
        }
    }
}