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
    public partial class Controls_UserProfile : System.Web.UI.UserControl
    {
        private ProfileModel m_profile;
        public ProfileModel WlkMiProfile
        {
            get
            {
                return m_profile;
            }
            set
            {
                m_profile = value;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!this.IsPostBack)
            {
                for (int i = 0; i <= 12; i++)
                {
                    height_feet.Items.Add(
                        new ListItem(i.ToString(), i.ToString()));
                    height_inches.Items.Add(
                        new ListItem(i.ToString(), i.ToString()));
                }
            }
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            Zip.Text = DataDisplayChecks.DisplayZip(this.WlkMiProfile.UserCtx.user_zip);
            Birthyear.Text = DataDisplayChecks.DisplayBirthYear(this.WlkMiProfile.UserCtx.user_birthyear);

            string height = DataDisplayChecks.DisplayHeight(
                    this.WlkMiProfile.UserCtx.user_height);
            if (string.IsNullOrEmpty(height))
            {
                height_feet.SelectedIndex = 0;
                height_inches.SelectedIndex = 0;
            }
            else
            {
                int h;
                int.TryParse(height, out h);
                height_feet.SelectedIndex = (h / 12);
                height_inches.SelectedIndex = (h % 12);
            }

            Weight.Text = DataDisplayChecks.DisplayWeight(this.WlkMiProfile.UserCtx.user_weight);
            Stride.Text = DataDisplayChecks.DisplayStride(this.WlkMiProfile.UserCtx.user_stride);
            NickName.Text = this.WlkMiProfile.UserCtx.user_nickname != null ?
                this.WlkMiProfile.UserCtx.user_nickname.ToString() : "";
        }

        public void DoSubmit(object sender, EventArgs e)
        {
            try
            {
                this.WlkMiProfile.UserCtx.user_nickname = NickName.Text;

                int birthyear;
                Int32.TryParse(Birthyear.Text, out birthyear);
                DataChecks.AssertValidAge(birthyear);
                this.WlkMiProfile.UserCtx.user_birthyear = birthyear;

                int zip;
                Int32.TryParse(Zip.Text, out zip);
                DataChecks.AssertValidZip(zip);
                this.WlkMiProfile.UserCtx.user_zip = zip;

                int stride;
                Int32.TryParse(Stride.Text, out stride);
                DataChecks.AssertValidStride(stride);
                this.WlkMiProfile.UserCtx.user_stride = stride;

                int height; int feet; int inches;
                int.TryParse(height_feet.SelectedValue, out feet);
                int.TryParse(height_inches.SelectedValue, out inches);
                height = feet * 12 + inches;
                DataChecks.AssertValidHeight(height);
                this.WlkMiProfile.UserCtx.user_height = height;

                int weight;
                Int32.TryParse(Weight.Text, out weight);
                DataChecks.CheckValidWeight(weight);
                this.WlkMiProfile.UserCtx.user_weight = weight;

                this.WlkMiProfile.Save();
                this.lbl_saved.Visible = true;
            }
            catch (WlkMiException exp)
            {
                ((WlkMiBasePage)this.Page).ShowError(exp.Message);
            }

        }

        public void Resync(object sender, EventArgs e)
        {
            HVSync.OnlineSyncUser(((WlkMiBasePage)this.Page).WlkMiUser,
                ((WlkMiBasePage)this.Page).PersonInfo, false);
            this.lbl_saved.Visible = false;
        }
    }
}