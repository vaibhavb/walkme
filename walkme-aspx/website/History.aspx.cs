using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Microsoft.Health.Applications.WalkMe
{
    public partial class History : WlkMiBasePage
    {

        /*
         *     AerobicSteps,
        Calories,
        Fat,
        Steps,
        Distance

         * 
         * */

        public string itemType;
        public string duration;

        protected void Page_Load(object sender, EventArgs e)
        {
            ((WlkMiMasterPage)Master).SetPageMetadata("WalkMe Charts", null, null);

            itemType = "Steps";
            if (!string.IsNullOrEmpty(Request.QueryString.Get("type")))
            {
                itemType = Request.QueryString.Get("type");
            }

            duration = "WeekTrend";
            if (!string.IsNullOrEmpty(Request.QueryString.Get("duration")))
            {
                duration = Request.QueryString.Get("duration");
            }

            switch (itemType)
            {
                case "AerobicSteps":
                    lnk_aerobic.CssClass = "chart-lnk-on";
                    break;
                case "Distance":
                    lnk_distance.CssClass = "chart-lnk-on";
                    break;
                case "Calories":
                    lnk_calories.CssClass = "chart-lnk-on";
                    break;
                default:
                    lnk_steps.CssClass = "chart-lnk-on";
                    break;
            }
            lnk_aerobic.NavigateUrl = "history.aspx?type=AerobicSteps&duration=" + duration;
            lnk_distance.NavigateUrl = "history.aspx?type=Distance&duration=" + duration;
            lnk_calories.NavigateUrl = "history.aspx?type=Calories&duration=" + duration;
            lnk_steps.NavigateUrl = "history.aspx?type=Steps&duration=" + duration;


            switch (duration)
            {
                case "Month":
                    lnk_monthly.CssClass = "chart-lnk-on";

                    break;
                case "Year":
                    lnk_yearly.CssClass = "chart-lnk-on";
                    break;
                case "Week":
                    lnk_weekly.CssClass = "chart-lnk-on";
                    break;
                default:
                    lnk_weeklyTrend.CssClass = "chart-lnk-on";
                    break;
            }
            lnk_monthly.NavigateUrl = "history.aspx?type=" + itemType + "&duration=Month";
            lnk_yearly.NavigateUrl = "history.aspx?type=" + itemType + "&duration=Year";
            lnk_weekly.NavigateUrl = "history.aspx?type=" + itemType + "&duration=Week";
            lnk_weeklyTrend.NavigateUrl = "history.aspx?type=" + itemType + "&duration=WeekTrend";

            GraphingLayer graph = MakeGraph(
                itemType, duration);
            ShowFlash.lineGraph = graph;

        }
    }
}
