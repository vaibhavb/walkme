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
    public partial class WlkMiMasterPage : System.Web.UI.MasterPage
    {
        string userName;
        public string UserName
        {
            set
            {
                userName = value;
            }
            get
            {
                return userName;
            }
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            // TODO: Make WlkMi favicon.ico

        }
        public void HideNav()
        {
            this.Header.HideNavLinks = true;
        }

        public void SetPageMetadata(String title,
                                String description,
                                String keywordsCSV)
        {
            if (title != null)
                this.SetTitle(title);

            if (description != null)
                this.SetDescription(description);

            if (keywordsCSV != null)
            {
                this.ClearKeywords();
                this.AddKeyword(keywordsCSV);
            }
        }

        public void SetTitle(String title)
        {
            this.eltHead.Title = title;
        }

        public void SetDescription(String description)
        {
            this.eltDescription.Attributes["content"] = description;
        }

        public void AddKeyword(String keyword)
        {
            String existingKeywords = this.eltKeywords.Attributes["content"];
            if (existingKeywords != "") existingKeywords += ", ";
            this.eltKeywords.Attributes["content"] = existingKeywords + keyword;
        }

        public void ClearKeywords()
        {
            this.eltKeywords.Attributes["content"] = "";
        }
    }
}