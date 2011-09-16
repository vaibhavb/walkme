using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;

namespace Microsoft.Health.Applications.WalkMe
{
    public partial class Controls_Sharing : System.Web.UI.UserControl
    {
        public string WLKMIWEBSITE
        {
            get
            {
                return "https://apps.healthvault.com/app4";
            }
        }

        public string WIDGETHTML
        {
            get
            {
                return GetWidgetUrl("html");
            }
        }

        public string COPYWIDGETHTML
        {
            get
            {
                return GetWidgetUrl("html").Replace("https", "http");
            }
        }

        public string COPYWIDGETHTMLURL
        {
            get
            {
                return GetWidgetUrl("htmlurl").Replace("https", "http");
            }
        }

        public string IMAGEURL
        {
            get
            {
                return GetWidgetUrl("img");
            }
        }

        public string COPYIMAGEURL
        {
            get
            {
                return GetWidgetUrl("img").Replace("https", "http"); ;
            }
        }

        public string COPYRSSURLENCODED
        {
            get
            {
                return HttpUtility.UrlEncode(
                    GetWidgetUrl("rss").Replace("https", "http"));
            }
        }

        public string RSSTITLE
        {
            get
            {
                ProfileModel user = ((WlkMiBasePage)this.Page).WlkMiUser;
                if (user.UserCtx.user_nickname.ToLower().Equals("walkme_unknown"))
                {
                    return string.Format("{0} WalkLog", "User");
                }
                else
                {
                    return string.Format("{0} WalkLog", user.UserCtx.user_nickname);
                }
            }
        }

        public string OUTLOOKURL
        {
            get
            {
                return GetWidgetUrl("outlook").Replace("https", "http");
            }
        }

        public string SHAREWIDGETURL
        {
            get
            {
                return (new Uri(
                    HttpContext.Current.Request.Url,
                    string.Format("sharewidget.aspx?user_id={0}", USERID)
                    )).ToString().Replace("https", "http");
            }
        }

        public string USERID
        {
            get
            {
                ProfileModel user = ((WlkMiBasePage)this.Page).WlkMiUser;
                if (user.UserCtx != null)
                {
                    return user.UserCtx.user_id.ToString();
                }
                return string.Empty;
            }
        }

        private string GetWidgetUrl(string type)
        {
            ProfileModel user = ((WlkMiBasePage)this.Page).WlkMiUser;

            if (user.UserCtx != null)
            {
                if (type.Equals("html"))
                {
                    return string.Format("<iframe src=\"{0}\" width=\"210px\" height=\"170px\" scrolling=\"no\" frameborder=\"0\"></iframe>",
                    MakeRequestUrl(type, user.UserCtx.user_id).ToString());
                }
                if (type.Equals("htmlurl"))
                {
                    type = "html";
                }
                return (MakeRequestUrl(type, user.UserCtx.user_id).ToString());
            }
            else
            {
                return string.Empty;
            }
        }

        private Uri MakeRequestUrl(string type, int user_id)
        {
            return new Uri(
                HttpContext.Current.Request.Url,
                string.Format("wlkmi.ashx?type={0}&user_id={1}", type, user_id)
                );
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            WlkMiBasePage wlkmiBasePage = this.Page as WlkMiBasePage;

            if (wlkmiBasePage.WlkMiUser.UserCtx.user_sharing_flag == 1)
            {
                ph_share.Visible = true;
                ph_noshare.Visible = false;
                chk_share.Checked = true;
            }
            else
            {
                ph_share.Visible = false;
                ph_noshare.Visible = true;
                chk_share.Checked = false;
            }
        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            WlkMiBasePage wlkmiBasePage = this.Page as WlkMiBasePage;
            this.lbl_saved.Visible = true;
            if (chk_share.Checked == true)
            {
                wlkmiBasePage.WlkMiUser.UserCtx.user_sharing_flag = 1;
                lbl_saved.Text = "Sharing is now on";
            }
            else
            {
                wlkmiBasePage.WlkMiUser.UserCtx.user_sharing_flag = 0;
                lbl_saved.Text = "Sharing is now off";
            }
            wlkmiBasePage.WlkMiUser.Save();
        }
    }
}
