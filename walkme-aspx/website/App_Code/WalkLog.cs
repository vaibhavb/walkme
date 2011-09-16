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
using System.Collections.Generic;

/// <summary>
/// Summary description for WalkLog
/// </summary>
namespace Microsoft.Health.Applications.WalkMe
{
    public class WalkLogModel
    {
        public walk_log data;
        private const int NUM_MONTHS = 12;
        private const int NUM_YEARS = 3;
        private const int NUM_WEEKS = 4;

        private WalkLogModel(walk_log g)
        {
            this.data = g;
        }

        public static WalkLogModel Fetch(int id)
        {
            DataClassesDataContext db = new DataClassesDataContext();
            walk_log t;
            var query = (from g in db.walk_logs
                         where g.log_user == id
                         select g);
            if (query.ToList().Count == 0)
            {
                t = new walk_log();
                t.log_user = id;
                db.GetTable<walk_log>().InsertOnSubmit(t);
            }
            else
            {
                t = query.First();
            }
            WalkLogModel p = new WalkLogModel(t);
            return p;
        }

        public static int NumberOfLogs()
        {
            DataClassesDataContext db = new DataClassesDataContext();
            var query = (from g in db.walk_logs
                         select g).Count();
            return query;
        }

        public static Dictionary<string, string>
            FetchSteps(string item, int id, string length)
        {
            Time periodSpan = (Time)Enum.Parse(typeof(Time), length);
            Item itemType = (Item)Enum.Parse(typeof(Item), item);
            DataClassesDataContext db = new DataClassesDataContext();
            switch (periodSpan)
            {
                case Time.Week:
                    {
                        Dictionary<string, string> dict = new Dictionary<string, string>();
                        var query = (from g in db.walk_logs
                                     where ((g.log_user == id) && (g.log_date >= (DateTime.Now.AddDays(-7))) && (g.log_date <= DateTime.Now))
                                     orderby g.log_date
                                     select g);
                        if (query.Count() == 0) return null;
                        double? sum = 0;
                        for (int i = 6; i >= 0; i--)
                        {
                            sum = 0;
                            foreach (var entry in query)
                            {
                                if (entry.log_date == DateTime.Now.Date.AddDays(-i))
                                {
                                    switch (itemType)
                                    {
                                        case Item.AerobicSteps:
                                            {
                                                if (entry.log_aerobicsteps.HasValue)
                                                    sum += (double?)entry.log_aerobicsteps;
                                                break;
                                            }
                                        case Item.Calories:
                                            {
                                                if (entry.log_calories.HasValue)
                                                    sum += entry.log_calories;
                                                break;
                                            }
                                        case Item.Distance:
                                            {
                                                if (entry.log_distance.HasValue)
                                                    sum += entry.log_distance;
                                                break;
                                            }
                                        default:
                                            {
                                                if (entry.log_steps.HasValue)
                                                    sum += (double)entry.log_steps;
                                                break;
                                            }
                                    }
                                }
                            }
                            String value = string.Format("{0}", sum);
                            String X_labels;
                            if (i == 0)
                                X_labels = "Today";
                            else
                                X_labels = string.Format("{0}", DateTime.Now.AddDays(-i).ToString("ddd"));

                            dict.Add(X_labels,
                                value);

                        }
                        return dict;
                    }
                case Time.WeekTrend:
                    {
                        Dictionary<string, string> dict = new Dictionary<string, string>();
                        var query = (from g in db.walk_logs
                                     where ((g.log_user == id) && (g.log_date >= (DateTime.Now.AddDays(-7))) && (g.log_date <= DateTime.Now))
                                     orderby g.log_date
                                     select g);
                        if (query.Count() == 0) return null;
                        double? sum = 0;
                        for (int i = 6; i >= 0; i--)
                        {
                            foreach (var entry in query)
                            {
                                if (entry.log_date == DateTime.Now.Date.AddDays(-i))
                                {
                                    switch (itemType)
                                    {
                                        case Item.AerobicSteps:
                                            {
                                                if (entry.log_aerobicsteps.HasValue)
                                                    sum += (double?)entry.log_aerobicsteps;
                                                break;
                                            }
                                        case Item.Calories:
                                            {
                                                if (entry.log_calories.HasValue)
                                                    sum += entry.log_calories;
                                                break;
                                            }
                                        case Item.Distance:
                                            {
                                                if (entry.log_distance.HasValue)
                                                    sum += entry.log_distance;
                                                break;
                                            }
                                        default:
                                            {
                                                if (entry.log_steps.HasValue)
                                                    sum += (double)entry.log_steps;
                                                break;
                                            }
                                    }
                                }
                            }
                            String value = string.Format("{0}", sum);
                            String X_labels;
                            if (i == 0)
                                X_labels = "Today";
                            else
                                X_labels = string.Format("{0}", DateTime.Now.AddDays(-i).ToString("ddd"));

                            dict.Add(X_labels,
                                value);

                        }
                        return dict;
                    }
                case Time.Month:
                    {
                        Dictionary<string, string> dict = new Dictionary<string, string>();
                        var query = (from g in db.walk_logs
                                     where ((g.log_user == id) && (g.log_date >= (DateTime.Now.AddDays(-7 * NUM_WEEKS))) && (g.log_date <= DateTime.Now))
                                     orderby g.log_date
                                     select g);
                        if (query.Count() == 0) return null;

                        double?[] sum = new double?[NUM_WEEKS];
                        for (int i = 0; i < sum.Length; i++)
                        {
                            sum[i] = 0;
                        }
                        foreach (var entry in query)
                        {
                            switch (itemType)
                            {
                                case Item.AerobicSteps:
                                    {
                                        sum[DateTime.Now.Subtract(entry.log_date).Days / 7] += (double?)entry.log_aerobicsteps;
                                        break;
                                    }
                                case Item.Calories:
                                    {
                                        sum[DateTime.Now.Subtract(entry.log_date).Days / 7] += entry.log_calories;
                                        break;
                                    }
                                case Item.Distance:
                                    {
                                        sum[DateTime.Now.Subtract(entry.log_date).Days / 7] += entry.log_distance;
                                        break;
                                    }
                                default:
                                    {
                                        sum[DateTime.Now.Subtract(entry.log_date).Days / 7] += (double)entry.log_steps;
                                        break;
                                    }
                            }

                        }
                        for (int i = sum.Length - 1; i >= 0; i--)
                        {
                            String value = string.Format("{0}", sum[i]);
                            String X_labels;
                            if (i == 0)
                                X_labels = "This Week";
                            else if (i == 1)
                                X_labels = string.Format("{0} Week Ago", i);
                            else
                                X_labels = string.Format("{0} Weeks Ago", i);
                            dict.Add(X_labels, value);
                        }

                        return dict;

                    }
                case Time.Year:
                    {
                        Dictionary<string, string> dict = new Dictionary<string, string>();
                        var query = (from g in db.walk_logs
                                     where ((g.log_user == id) && (g.log_date >= (DateTime.Now.AddMonths(-NUM_MONTHS))) && (g.log_date <= DateTime.Now))
                                     orderby g.log_date
                                     select g);
                        if (query.Count() == 0) return null;

                        double?[] sum = new double?[NUM_MONTHS];
                        for (int i = 0; i < sum.Length; i++)
                        {
                            sum[i] = 0;
                        }
                        foreach (var entry in query)
                        {
                            switch (itemType)
                            {
                                case Item.AerobicSteps:
                                    {
                                        sum[entry.log_date.Month - 1] += (double?)entry.log_aerobicsteps;
                                        break;
                                    }
                                case Item.Calories:
                                    {
                                        sum[entry.log_date.Month - 1] += entry.log_calories;
                                        break;
                                    }
                                case Item.Distance:
                                    {
                                        sum[entry.log_date.Month - 1] += entry.log_distance;
                                        break;
                                    }
                                default:
                                    {
                                        sum[entry.log_date.Month - 1] += (double)entry.log_steps;
                                        break;
                                    }
                            }

                        }
                        for (int i = sum.Length - 1; i >= 0; i--)
                        {
                            String value = string.Format("{0}", sum[i]);

                            String X_labels = string.Format("{0}", DateTime.Now.AddMonths(-i).ToString("MMM"));
                            dict.Add(X_labels, value);
                        }

                        return dict;
                    }
            }
            return null;
        }

        public static List<WalkLogModel> FetchAll(int id)
        {
            DataClassesDataContext db = new DataClassesDataContext();
            var query = (from g in db.walk_logs
                         where g.log_user == id
                         select new WalkLogModel(g));
            return query.ToList();
        }

        public static List<WalkLogModel> GetLast10Logs(int userId)
        {
            DataClassesDataContext db = new DataClassesDataContext();
            var query = (from g in db.walk_logs
                         where g.log_user == userId
                         orderby g.log_date descending
                         select new WalkLogModel(g)).Take(10);
            return query.ToList();
        }

        public static long GetTotalSteps(int userId)
        {
            DataClassesDataContext db = new DataClassesDataContext();
            var query = (from g in db.users
                         where g.user_id == userId
                         select g.user_total_steps).FirstOrDefault();
            if (query != null)
                return (long)query;
            else
                return 0;
        }

        public static void ClearUserCache(ProfileModel user)
        {
            DataClassesDataContext db = new DataClassesDataContext();
            var query = from g in db.walk_logs
                        where g.log_user == user.UserCtx.user_id &&
                              g.updated_at < user.UserCtx.hv_last_sync_time
                        select g;

            foreach (var info in query)
            {
                db.walk_logs.DeleteOnSubmit(info);
            }

            db.SubmitChanges();
        }

        public static void ProcessAllTotals()
        {
            DataClassesDataContext db3 = new DataClassesDataContext();
            var userQuery = (from g in db3.users
                             select g);
            foreach (var entry in userQuery)
            {
                ProfileModel prof = ProfileModel.Fetch(entry.hv_recordid);
                HVSync.OfflineSyncUser(prof);
            }
        }

        public static void ProcessTotals(int userId)
        {
            long weekly_steps = 0;
            long monthly_steps = 0;
            long annual_steps = 0;
            long total_steps = 0;
            float weekly_calories = 0;
            float weekly_distance = 0;
            float total_distance = 0;

            DataClassesDataContext db = new DataClassesDataContext();
            //total steps
            var query = (from g in db.walk_logs
                         where g.log_user == userId
                         select g.log_steps).Sum();
            if (query != null)
                total_steps = (long)query;
            //weekly steps
            query = (from g in db.walk_logs
                     where ((g.log_user == userId) &&
                     (g.log_date >= (DateTime.Now.AddDays(-7))) && (g.log_date <= DateTime.Now))
                     select g.log_steps).Sum();
            if (query != null)
                weekly_steps = (long)query;

            //monthly steps
            query = (from g in db.walk_logs
                     where ((g.log_user == userId) &&
                     (g.log_date >= (DateTime.Now.AddDays(-30))) && (g.log_date <= DateTime.Now))
                     select g.log_steps).Sum();
            if (query != null)
                monthly_steps = (long)query;

            //annual steps
            query = (from g in db.walk_logs
                     where ((g.log_user == userId) &&
                     (g.log_date >= (DateTime.Now.AddDays(-365))) && (g.log_date <= DateTime.Now))
                     select g.log_steps).Sum();
            if (query != null)
                annual_steps = (long)query;

            //weekly calories
            var query2 = (from g in db.walk_logs
                          where ((g.log_user == userId) &&
                          (g.log_date >= (DateTime.Now.AddDays(-7))) && (g.log_date <= DateTime.Now))
                          select g.log_calories).Sum();
            if (query2 != null)
                weekly_calories = (float)query2;

            //weekly distance
            query2 = (from g in db.walk_logs
                      where ((g.log_user == userId) &&
                      (g.log_date >= (DateTime.Now.AddDays(-7))) && (g.log_date <= DateTime.Now))
                      select g.log_distance).Sum();
            if (query2 != null)
                weekly_distance = (float)query2;

            //total distance
            query2 = (from g in db.walk_logs
                      where g.log_user == userId
                      select g.log_distance).Sum();
            if (query2 != null)
                total_distance = (long)query2;

            //Store calculated totals in the user table
            DataClassesDataContext db2 = new DataClassesDataContext();
            var user = (from g in db2.users
                        where g.user_id == userId
                        select g).First();
            user.user_total_steps = (int)total_steps;
            user.user_annual_steps = (int)annual_steps;
            user.user_monthly_steps = (int)monthly_steps;
            user.user_weekly_steps = (int)weekly_steps;
            user.user_weekly_calories = (float)weekly_calories;
            user.user_weekly_distance = (float)weekly_distance;
            user.user_total_distance = (float)total_distance;
            user.updated_at = DateTime.Now;
            user.hv_sync_status = Constants.SyncFinished;
            db2.SubmitChanges();
        }

        public static long? TotalStepsWalked()
        {
            DataClassesDataContext db = new DataClassesDataContext();
            var query = (from g in db.walk_logs
                         select g.log_steps).Sum();
            if (query.HasValue)
                return (long)query;
            else
                return 0;
        }

        public static void Insert(walk_log t)
        {
            DataClassesDataContext db = new DataClassesDataContext();
            t.updated_at = DateTime.Now;
            db.GetTable<walk_log>().InsertOnSubmit(t);
            db.SubmitChanges();
        }

        public static void Save(int userId, DateTime date,
            long steps, long aerobicSteps)
        {
            DataClassesDataContext db = new DataClassesDataContext();
            walk_log t = new walk_log();
            t.log_user = userId;
            t.log_date = date;
            t.log_steps = steps;
            t.log_aerobicsteps = aerobicSteps;
            db.GetTable<walk_log>().InsertOnSubmit(t);
            db.SubmitChanges();
        }
    }
}