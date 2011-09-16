using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Collections.Generic;

using Microsoft.Health;
using Microsoft.Health.ItemTypes;
using Microsoft.Health.Web;

namespace Microsoft.Health.Applications.WalkMe
{
    /// <summary>
    /// Summary description for WalkMiBasePage
    /// </summary>
    public class WlkMiBasePage : HealthServicePage
    {
        public WlkMiBasePage()
        {
        }

        public bool LogOnIsRequired
        {
            get
            {
                return this.LogOnRequired;
            }
        }

        public ProfileModel WlkMiUser;

        protected void Page_Init(Object sender, EventArgs e)
        {
            // Preventing XSRF
            // TODO: use a different canary
            // ViewStateUserKey = Session.SessionID;
        }

        protected override void OnPreLoad(EventArgs e)
        {
            base.OnPreLoad(e);
            if (this.LogOnRequired)
            {
                // TODO: Try to fetch the profile a more performant way
                // We can not cache this since we will run in a web-farm without a state server
                // Make sure that every request reads this from the DB only once. 
                WlkMiUser = ProfileModel.FetchAndInsert(
                   this.PersonInfo.SelectedRecord.Id, this.PersonInfo.PersonId);

                // Note the properties below will get saved only if profile is saved.
                // Ideally they should be moved when the HV login happens
                WlkMiUser.UserCtx.user_last_client_ip = Request.UserHostAddress;
                WlkMiUser.UserCtx.user_last_login = DateTime.Now;

            }
            Control c = this.Page.Master.FindControl("Form1");
            Panel panel = (Panel)c.FindControl("errorMessage");
            panel.Visible = false;
        }

        public GraphingLayer MakeGraph(string item, string length)
        {
            if (this.LogOnRequired)
            {
                Item itemType = (Item)Enum.Parse(typeof(Item), item);
                Dictionary<string, string> xyData = WalkLogModel.FetchSteps(item,
                this.WlkMiUser.UserCtx.user_id,
                length);
                if (xyData == null)
                    return null;
                GoalModel goal = GoalModel.Fetch(this.WlkMiUser.UserCtx.user_id);
                if (!length.Contains("WeekTrend"))
                    return new GraphingLayer(item, length, xyData, null);
                else
                {
                    switch (itemType)
                    {
                        case Item.AerobicSteps:
                            if (goal.data.daily_goal_aerobic_steps.HasValue)
                                return new GraphingLayer(item, length, xyData, goal.data.daily_goal_aerobic_steps.Value);
                            else
                                return new GraphingLayer(item, length, xyData, 0);
                        case Item.Calories:
                            if (goal.data.daily_goal_calories.HasValue)
                                return new GraphingLayer(item, length, xyData, goal.data.daily_goal_calories.Value);
                            else
                                return new GraphingLayer(item, length, xyData, 0);
                        case Item.Distance:
                            if (goal.data.daily_goal_distance.HasValue)
                                return new GraphingLayer(item, length, xyData, goal.data.daily_goal_distance.Value);
                            else
                                return new GraphingLayer(item, length, xyData, 0);
                        default:
                            if (goal.data.daily_goal_steps.HasValue)
                                return new GraphingLayer(item, length, xyData, goal.data.daily_goal_steps.Value);
                            else
                                return new GraphingLayer(item, length, xyData, 0);
                    }
                }
            }
            return null;
        }

        /// <summary>
        /// This function fetches all the initial data about the user from 
        /// HealthVault, however this data is not updated in HealthVault.
        /// This data comprises of: Name, Email, Weight, Height
        /// </summary>
        public ProfileModel PopulateWithHVData(ProfileModel userContext)
        {
            HealthRecordSearcher searcher =
                PersonInfo.SelectedRecord.CreateSearcher();
            HealthRecordFilter filter =
                new HealthRecordFilter(
                    Personal.TypeId,
                    Contact.TypeId,
                    Weight.TypeId,
                    Height.TypeId);
            searcher.Filters.Add(filter);

            HealthRecordItemCollection items = searcher.GetMatchingItems()[0];

            Weight weight = null;
            Height height = null;
            Contact contact = null;
            Personal personalInfo = null;

            foreach (HealthRecordItem item in items)
            {
                weight = (Weight)FindLatest<Weight>(weight, item);
                height = (Height)FindLatest<Height>(height, item);
                contact = (Contact)FindLatest<Contact>(contact, item);
                personalInfo = (Personal)FindLatest<Personal>(personalInfo, item);
            }

            if (weight != null)
            {
                userContext.UserCtx.user_weight =
                    (int)DataConversion.ConverKgToLb(weight.Value.Kilograms);
            }
            if (height != null)
            {
                userContext.UserCtx.user_height =
                    (int)DataConversion.ConvertMetersToInches(height.Value.Meters);
            }
            if (contact != null)
            {

                // DONOT get PII data

                //if (contact.ContactInformation.PrimaryEmail != null)
                //{
                //    // Try primary email
                //    userContext.UserCtx.user_email = contact.ContactInformation.PrimaryEmail.Address;
                //}
                //else
                //{
                //    // See if their is any other email
                //    if (contact.ContactInformation.Email.Count > 0)
                //    {
                //        userContext.UserCtx.user_email = contact.ContactInformation.Email[0].Address;
                //    }
                //}

                int zip = 0;
                if (contact.ContactInformation.PrimaryAddress != null)
                {
                    int.TryParse(contact.ContactInformation.PrimaryAddress.PostalCode, out zip);
                }
                else
                {
                    // See if their is any other email
                    if (contact.ContactInformation.Address.Count > 0)
                    {
                        int.TryParse(contact.ContactInformation.Address[0].PostalCode, out zip);
                    }
                }
                userContext.UserCtx.user_zip = zip;
            }
            if (personalInfo != null)
            {
                if (personalInfo.BirthDate != null)
                {
                    int year = 0;
                    try
                    {
                        year = personalInfo.BirthDate.Date.Year;
                    }
                    catch
                    {
                        //eat exceptions
                    }
                    if (year > 0)
                    {
                        userContext.UserCtx.user_birthyear = year;
                    }
                }
            }

            return userContext;
        }

        /// <summary>
        /// Get the lastest values for the assigned type
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="weight"></param>
        /// <param name="item"></param>
        /// <returns></returns>
        private HealthRecordItem FindLatest<T>
            (HealthRecordItem thing, HealthRecordItem item)
        {
            if (item is T)
            {
                if (thing == null)
                {
                    return item;
                }
                else
                {
                    if (thing.EffectiveDate < item.EffectiveDate)
                    {
                        return item;
                    }
                }
            }
            return thing;
        }

        public void SetSyncCookie()
        {
            Response.Cookies[Constants.UserSyncCookieName].Value =
                this.WlkMiUser.UserCtx.user_id.ToString();
            Response.Cookies[Constants.UserSyncCookieName].Expires =
                DateTime.Now.AddMinutes(Constants.MinutesUserSyncCookieIsValid);
            return;
        }

        public void ResetSyncCookie()
        {
            Response.Cookies[Constants.UserSyncCookieName].Value =
                this.WlkMiUser.UserCtx.user_id.ToString();
            Response.Cookies[Constants.UserSyncCookieName].Expires =
                DateTime.Now.AddDays(-1);
        }

        public bool CheckCookie(HttpCookie syncCookie)
        {
            // If no cookie came back or the user value doesn't match
            if (syncCookie == null ||
                    !syncCookie.Value.Equals
                    (this.WlkMiUser.UserCtx.user_id.ToString()))
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        public WlkMiTracer AppTracer
        {
            get
            {
                return WlkMiTracer.Instance;
            }
        }

        public void RefreshUserCtx()
        {
            if (this.IsLoggedIn)
            {
                WlkMiUser = ProfileModel.Fetch(
                    base.PersonInfo.SelectedRecord.Id);
            }
        }

        public void ShowError(string message)
        {
            Control c = this.Page.Master.FindControl("Form1");
            Panel panel = (Panel)c.FindControl("errorMessage");
            panel.Visible = true;
            LiteralControl control = new LiteralControl(message);
            panel.Controls.Add(control);
        }
    }
}