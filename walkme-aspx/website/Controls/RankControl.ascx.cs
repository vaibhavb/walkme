using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Microsoft.Health.Applications.WalkMe
{
    public partial class Controls_RankControl : System.Web.UI.UserControl
    {
        public float calcBMI;
        private void GetIcon(rankStruct rs, Image img)
        {
            if (rs.rank < .333 * rs.number)
            {
                img.ImageUrl = "~/images/1feet.gif";
            }
            else if (rs.rank < .667 * rs.number)
            {
                img.ImageUrl = "~/images/2feet.gif";
            }
            else
            {
                img.ImageUrl = "~/images/3feet.gif";
            }
        }
        protected void Page_PreRender(object sender, EventArgs e)
        {

            WlkMiBasePage page = (WlkMiBasePage)this.Page;
            rankStruct ra = ProfileModel.GetRank(page.WlkMiUser, RankType.Zip);

            if (page.WlkMiUser.UserCtx.user_birthyear != 0)
            {
                lbl_age.Text = String.Format("({0} - {1})", (DateTime.Now.Year - page.WlkMiUser.UserCtx.user_birthyear - 2), (DateTime.Now.Year - page.WlkMiUser.UserCtx.user_birthyear + 2));
            }
            if (page.WlkMiUser.UserCtx.user_zip != 0)
            {
                lbl_location.Text = page.WlkMiUser.UserCtx.user_zip.ToString();
            }


            if (page.WlkMiUser.UserCtx.user_total_steps > 0)
            {
                LocationRank.Text = DataConversion.AddOrdinalSuffix(ra.rank);
                NumLocation.Text = ra.number.ToString();
                StepsBehindLoc.Text = String.Format("{0:0,0}", (ra.LeaderSteps - page.WlkMiUser.UserCtx.user_weekly_steps));
                RenderNumPeopleText(lbl_location_people, ra);

                ra = ProfileModel.GetRank(page.WlkMiUser, RankType.BirthYear);
                AgeRank.Text = DataConversion.AddOrdinalSuffix(ra.rank);
                NumAge.Text = ra.number.ToString();
                StepsBehindAge.Text = String.Format("{0:0,0}", (ra.LeaderSteps - page.WlkMiUser.UserCtx.user_weekly_steps));
                RenderNumPeopleText(lbl_age_people, ra);


                calcBMI = (float)Math.Round(DataConversion.GetBMI(page.WlkMiUser.UserCtx.user_height, page.WlkMiUser.UserCtx.user_weight), 2);
                ra = ProfileModel.GetRank(page.WlkMiUser, RankType.BMI);
                BMIRank.Text = DataConversion.AddOrdinalSuffix(ra.rank);
                NumBMI.Text = ra.number.ToString();
                StepsBehindBMI.Text = String.Format("{0:0,0}", (ra.LeaderSteps - page.WlkMiUser.UserCtx.user_weekly_steps));
                RenderNumPeopleText(lbl_bmi_people, ra);

                lbl_bmi.Text = String.Format("{0} - {1}", Math.Round(calcBMI - 1, 0), Math.Round(calcBMI + 1, 0));

            }
            else
            {
                //TODO: This needs to fixed so that it doesn't grab 3 all the time.
                RenderNumPeopleText(lbl_location_people, ra);
                RenderNumPeopleText(lbl_age_people, ra);
                RenderNumPeopleText(lbl_bmi_people, ra);

                plh_location_data.Visible = false;
                plh_location_NoData.Visible = true;

                plh_age_data.Visible = false;
                plh_age_noData.Visible = true;

                plh_bmi_data.Visible = false;
                plh_bmi_noData.Visible = true;

                lbl_bmi.Text = "No Data";
            }


            //TODO: Move leader determination numbers in constants.cs

        }
        private void RenderNumPeopleText(Label lbl, rankStruct ra)
        {
            if (ra.number > 1)
                lbl.Text = "people in this group";
            else
                lbl.Text = "person in this group";
        }
    }
}