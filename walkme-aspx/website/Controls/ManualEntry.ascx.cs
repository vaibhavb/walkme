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
    public partial class Controls_ManualEntry : System.Web.UI.UserControl
    {
        private void GetMyMonthList(DropDownList MyddlMonthList, bool SetCurrentMonth)
        {
            DateTime month = Convert.ToDateTime("1/1/2008");
            for (int i = 0; i < 12; i++)
            {

                DateTime NextMont = month.AddMonths(i);
                ListItem list = new ListItem();
                list.Text = NextMont.ToString("MMMM");
                list.Value = NextMont.Month.ToString();
                MyddlMonthList.Items.Add(list);
            }
            if (SetCurrentMonth == true)
            {
                MyddlMonthList.Items.FindByValue(DateTime.Now.Month.ToString()).Selected = true;
            }
        }

        private void GetMyDayList(DropDownList MyddlDayList, bool SetCurrentDay)
        {
            DateTime day = Convert.ToDateTime("1/1/2008");
            for (int i = 0; i < 31; i++)
            {

                DateTime NextDay = day.AddDays(i);
                ListItem list = new ListItem();
                list.Text = NextDay.ToString("dd");
                list.Value = NextDay.Day.ToString();
                MyddlDayList.Items.Add(list);
            }
            if (SetCurrentDay == true)
            {
                MyddlDayList.Items.FindByValue(DateTime.Now.Day.ToString()).Selected = true;
            }
        }

        private void GetMyYearList(DropDownList MyddlYearList, bool SetCurrentYear)
        {
            DateTime year = DateTime.Now;
            for (int i = 0; i < 3; i++)
            {

                DateTime PriorYear = year.AddYears(-i);
                ListItem list = new ListItem();
                list.Text = PriorYear.ToString("yyyy");
                list.Value = PriorYear.Year.ToString();
                MyddlYearList.Items.Add(list);
            }
            if (SetCurrentYear == true)
            {
                MyddlYearList.Items.FindByValue(DateTime.Now.Year.ToString()).Selected = true;
            }
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            if (!this.IsPostBack)
            {
                GetMyMonthList(dd_mm, true);
                GetMyDayList(dd_dd, true);
                GetMyYearList(dd_yy, true);
            }
        }


        protected void Button_StoreSteps_Click(object sender, EventArgs e)
        {
            WlkMiBasePage page = (WlkMiBasePage)this.Page;

            DateTime date = new DateTime(Convert.ToInt32(dd_yy.SelectedItem.Value), Convert.ToInt32(dd_mm.SelectedItem.Value), Convert.ToInt32(dd_dd.SelectedItem.Value));
            try
            {
                if (dd_measure.SelectedItem.Value.Contains("Steps"))
                {
                    int steps;
                    int.TryParse(TextBox_Steps.Text, out steps);
                    DataChecks.AssertValidSteps(steps);
                    HVSync.SaveStepsToHV(page.PersonInfo, date, steps, page.WlkMiUser);
                    this.lbl_saved.Text = String.Concat(steps, " steps stored");
                }
                else
                {
                    double steps;
                    double.TryParse(TextBox_Steps.Text, out steps);
                    DataChecks.AssertValidCalDistance(steps);
                    HVSync.SaveMilesToHV(page.PersonInfo, date, steps, page.WlkMiUser);
                    this.lbl_saved.Text = String.Concat(steps, " miles stored");
                }
                HVSync.OnlineSyncUser(page.WlkMiUser, page.PersonInfo, true);
            }
            catch (WlkMiException exp)
            {
                ((WlkMiBasePage)this.Page).ShowError(exp.Message);
            }
            page.RefreshUserCtx();
            this.tr_saved.Visible = true;
            this.TextBox_Steps.Text = "";
        }
    }
}