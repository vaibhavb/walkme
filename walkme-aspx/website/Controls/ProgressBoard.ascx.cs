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
    public partial class Controls_ProgressBoard : System.Web.UI.UserControl
    {
        public string aerobicstepsPercent;
        public string stepsPercent;
        public string caloriesPercent;
        public string distancePercent;


        protected void Page_PreRender(object sender, EventArgs e)
        {
            WlkMiBasePage page = (WlkMiBasePage)this.Page;
            stepsPercent = "0";
            caloriesPercent = "0";
            distancePercent = "0";

            if (page.WlkMiUser.UserCtx.user_weekly_steps.HasValue)
            {
                WeeklySteps.Text = String.Format("{0:0,0}", page.WlkMiUser.UserCtx.user_weekly_steps);
                if (page.WlkMiUser.UserCtx.daily_goal_steps.HasValue && (page.WlkMiUser.UserCtx.daily_goal_steps > 0))
                    stepsPercent = String.Format("{0:0%}", ((double)page.WlkMiUser.UserCtx.user_weekly_steps / 7) / page.WlkMiUser.UserCtx.daily_goal_steps);
            }

            if (page.WlkMiUser.UserCtx.user_weekly_calories.HasValue)
            {
                WeeklyCalories.Text = String.Format("{0:N}", page.WlkMiUser.UserCtx.user_weekly_calories);
                if (page.WlkMiUser.UserCtx.daily_goal_calories.HasValue && (page.WlkMiUser.UserCtx.daily_goal_calories > 0))
                    caloriesPercent = String.Format("{0:0%}", (page.WlkMiUser.UserCtx.user_weekly_calories / 7) / page.WlkMiUser.UserCtx.daily_goal_calories);
            }
            if (page.WlkMiUser.UserCtx.user_weekly_distance.HasValue)
            {
                WeeklyDistance.Text = String.Format("{0:n}", page.WlkMiUser.UserCtx.user_weekly_distance);
                if (page.WlkMiUser.UserCtx.daily_goal_distance.HasValue && (page.WlkMiUser.UserCtx.daily_goal_distance > 0))
                    distancePercent = String.Format("{0:0%}", (page.WlkMiUser.UserCtx.user_weekly_distance / 7) / page.WlkMiUser.UserCtx.daily_goal_distance);
            }
        }

    }
}