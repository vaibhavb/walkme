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
    public partial class Controls_GoalEditor : System.Web.UI.UserControl
    {
        private GoalModel m_goalModel;
        public GoalModel WlkMiGoalModel
        {
            get
            {
                return m_goalModel;
            }
            set
            {
                m_goalModel = value;
            }
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            Distance.Text = DataDisplayChecks.DisplayDouble(this.WlkMiGoalModel.data.daily_goal_distance);

            AerobicSteps.Text = DataDisplayChecks.DisplayInt(this.WlkMiGoalModel.data.daily_goal_aerobic_steps);

            Steps.Text = DataDisplayChecks.DisplayInt(this.WlkMiGoalModel.data.daily_goal_steps);

            Calories.Text = DataDisplayChecks.DisplayDouble(this.WlkMiGoalModel.data.daily_goal_calories);
        }

        public void DoSubmit(object sender, EventArgs e)
        {
            int steps;
            int.TryParse(Steps.Text, out steps);
            DataChecks.AssertValidSteps(steps);


            int aerobicsteps;
            int.TryParse(AerobicSteps.Text, out aerobicsteps);
            DataChecks.AssertValidSteps(aerobicsteps);
            this.WlkMiGoalModel.data.daily_goal_aerobic_steps = aerobicsteps;

            double distance;
            double.TryParse(Distance.Text, out distance);
            DataChecks.AssertValidCalDistance(distance);

            double calories;
            double.TryParse(Calories.Text, out calories);
            DataChecks.AssertValidCalDistance(calories);

            if (this.WlkMiGoalModel.data.daily_goal_steps != steps)
            {
                if ((distance == 0) || (this.WlkMiGoalModel.data.daily_goal_distance == distance))
                {
                    this.WlkMiGoalModel.data.daily_goal_distance = DataConversion.GetDistanceFromSteps(this.WlkMiGoalModel.data.user_stride, steps);
                }

                if ((calories == 0) || (this.WlkMiGoalModel.data.daily_goal_calories == calories))
                {
                    this.WlkMiGoalModel.data.daily_goal_calories = DataConversion.GetEnergyFromDistanceAndWeight(this.WlkMiGoalModel.data.daily_goal_distance.Value, this.WlkMiGoalModel.data.user_weight);
                }
            }
            else
            {
                this.WlkMiGoalModel.data.daily_goal_distance = distance;
                this.WlkMiGoalModel.data.daily_goal_calories = calories;
            }

            this.WlkMiGoalModel.data.daily_goal_steps = steps;

            this.WlkMiGoalModel.Save();
            this.lbl_saved.Visible = true;
        }
    }
}