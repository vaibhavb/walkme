using System;
using System.Data;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;


namespace Microsoft.Health.Applications.WalkMe
{

    public class rankStruct
    {
        public int rank;
        public int number;
        public long LeaderSteps;

    }

    public enum RankType : int
    {
        BirthYear = 0,
        Zip = 1,
        BMI = 2
    }

    public class ProfileModel
    {
        public user UserCtx;
        public bool IsNewUser = false;

        private ProfileModel(user g, bool isNewUser)
        {
            this.UserCtx = g;
            this.IsNewUser = isNewUser;
            // We consider user to be new if registration is not complete
            if (g.user_reg_complete_flag <= 0)
            {
                this.IsNewUser = true;
            }
        }

        public static ProfileModel IsUserPublic(int user_id)
        {
            DataClassesDataContext db = new DataClassesDataContext();
            user t;
            var query = (from g in db.users
                         where ((g.user_id == user_id) && (g.user_sharing_flag == 1))
                         select g);
            if (query.ToList().Count == 0)
            {
                return null;
            }
            else
            {
                t = query.First();
                return new ProfileModel(t, false);
            }
        }

        public static int NumberOfUsers()
        {
            DataClassesDataContext db = new DataClassesDataContext();
            var query = (from g in db.users
                         select g).Count();
            return query;
        }

        public static rankStruct GetRank(ProfileModel user, RankType type)
        {
            // We are computing ranks / groups using zip, birthyear and BMI
            // If one of the above values is not available in the users profile, then ranking is based on everyone
            rankStruct r = new rankStruct();
            //location
            // TODO: Create database index on weekly steps and make it non-nullable

            int weekly_steps = user.UserCtx.user_weekly_steps.HasValue ? user.UserCtx.user_weekly_steps.Value : 0;
            DataClassesDataContext db = new DataClassesDataContext();

            var query2 = (from g in db.users
                          select g);

            if (type.Equals(RankType.Zip))
            {
                int zip = user.UserCtx.user_zip;

                //Find how the user is doing in the whole sample

                if (DataChecks.CheckValidZip(user.UserCtx.user_zip))
                {
                    query2 = (from g in db.users
                              where (g.user_zip / 1000 == zip / 1000)
                              select g);
                }
            }
            else if (type.Equals(RankType.BirthYear))
            {
                int birthyear = user.UserCtx.user_birthyear;
                //age
                if (DataChecks.CheckValidAge(user.UserCtx.user_birthyear))
                {
                    query2 = (from g in db.users
                              where ((g.user_birthyear >= (birthyear - 2)) && (g.user_birthyear <= (birthyear + 2)))
                              select g);
                }
            }
            else if (type.Equals(RankType.BMI))
            {
                if (DataChecks.CheckValidHeight((int)user.UserCtx.user_height) && DataChecks.CheckValidWeight(user.UserCtx.user_weight))
                {
                    float bmi = DataConversion.GetBMI(user.UserCtx.user_height, user.UserCtx.user_weight);
                    //bmi +/- 1 range
                    query2 = (from g in db.users
                              where (((float)(g.user_weight * 703) >= (bmi - 1) * (float)(g.user_height * g.user_height)) && ((float)(g.user_weight * 703) <= (bmi + 1) * (float)(g.user_height * g.user_height)))
                              select g);
                }
            }
            var query3 = (from g in query2
                          where (g.user_weekly_steps > weekly_steps)
                          orderby g.user_weekly_steps ascending
                          select g);

            r.number = query2.Count();
            if (query3.Count() == 0)
            {
                r.rank = 1;
                r.LeaderSteps = (long)weekly_steps;
            }
            else
            {
                r.rank = query3.Count() + 1;
                r.LeaderSteps = (long)query3.First().user_weekly_steps;
            }

            return r;
        }

        public static ProfileModel Fetch(Guid hvRecordId)
        {
            DataClassesDataContext db = new DataClassesDataContext();
            var query = (from g in db.users
                         where g.hv_recordid == hvRecordId
                         select g).FirstOrDefault();
            if (query != null)
            {
                return new ProfileModel(query, false);
            }
            return null;
        }

        public static ProfileModel FetchAndInsert(Guid hvRecordId, Guid hvPersonId)
        {
            DataClassesDataContext db = new DataClassesDataContext();
            user t;
            ProfileModel p;
            var query = (from g in db.users
                         where g.hv_recordid == hvRecordId
                         select g);
            if (query.ToList().Count == 0)
            {
                t = new user();
                t.hv_recordid = hvRecordId;
                // Need to populate HV Person ID
                t.hv_personid = hvPersonId;

                t.updated_at = DateTime.Now;
                t.created_at = DateTime.Now;

                t.user_nickname = "WalkMe_UnKnown";
                t.user_stride = 24;
                t.user_birthyear = 1900;
                t.user_height = 1;
                t.user_weight = 0;
                t.user_zip = 00000;
                t.daily_goal_aerobic_steps = 0;
                t.daily_goal_calories = 0;
                t.daily_goal_distance = 0;
                t.daily_goal_steps = 2500;
                t.user_reg_complete_flag = 0;

                t.user_annual_steps = 0;
                t.user_monthly_steps = 0;
                t.user_weekly_steps = 0;

                t.user_sharing_flag = 0;

                t.user_weekly_calories = 0;
                t.user_weekly_distance = 0;

                t.user_total_distance = 0;
                t.user_total_steps = 0;

                db.GetTable<user>().InsertOnSubmit(t);
                db.SubmitChanges();
                p = new ProfileModel(t, true);
            }
            else
            {
                t = query.First();
                p = new ProfileModel(t, false);
            }
            return p;
        }

        public void Save()
        {
            DataClassesDataContext db = new DataClassesDataContext();
            var user = (from g in db.users
                        where g.user_id == this.UserCtx.user_id
                        select g).First();
            user.user_email = this.UserCtx.user_email;
            user.user_height = this.UserCtx.user_height;
            user.user_weight = this.UserCtx.user_weight;
            user.user_stride = this.UserCtx.user_stride;
            user.user_nickname = this.UserCtx.user_nickname;
            user.user_zip = this.UserCtx.user_zip;
            user.user_birthyear = this.UserCtx.user_birthyear;
            user.user_last_client_ip = this.UserCtx.user_last_client_ip;
            user.hv_personid = this.UserCtx.hv_personid;
            user.hv_last_sync_time = this.UserCtx.hv_last_sync_time;
            user.updated_at = DateTime.Now;
            user.user_reg_complete_flag = 1;
            user.daily_goal_steps = this.UserCtx.daily_goal_steps;
            user.user_sharing_flag = this.UserCtx.user_sharing_flag;
            db.SubmitChanges();
        }
    }
}