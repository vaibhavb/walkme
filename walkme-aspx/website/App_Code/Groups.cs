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
using System.Collections;

namespace Microsoft.Health.Applications.WalkMe
{
    public class groupStepCount
    {
        public long weekly;
        public long monthly;
        public long total;
        public long annual;
        public groupStepCount()
        {
            weekly = 0;
            monthly = 0;
            total = 0;
            annual = 0;
        }
    }


    public class GroupModel
    {
        public group data;

        private GroupModel(group g)
        {
            this.data = g;
        }

        public static int NumberOfGroups()
        {
            DataClassesDataContext db = new DataClassesDataContext();
            var query = (from g in db.groups
                         select g).Count();
            return query;
        }

        public static void FetchTop5(DataGrid dg)
        {
            DataClassesDataContext db = new DataClassesDataContext();
            var query = (from g in db.groups
                         where g.group_private == 0
                         select new
                         {
                             g_data = g,
                             userCount = (from o in db.group_user_assocs
                                          where o.group_id == g.group_id
                                          select o).Count()
                         });
            var top5 = (from h in query
                        orderby h.userCount descending
                        select new
                        {
                            group_name = String.Format("<a href='groups.aspx?g_id={0}'>{1}</a>", h.g_data.group_id.ToString(), h.g_data.group_name.ToString()),
                            userCount = h.userCount,
                            group_description = h.g_data.group_description.ToString()

                        });
            dg.DataSource = top5.Take(5);
            dg.DataBind();
        }

        public static int NumUsers(int g_id)
        {
            DataClassesDataContext db = new DataClassesDataContext();
            var query = (from g in db.group_user_assocs
                         where g.group_id == g_id
                         select g).Count();
            return query;
        }

        public static groupStepCount TotalNumSteps(int g_id)
        {
            groupStepCount totals = new groupStepCount();
            DataClassesDataContext db = new DataClassesDataContext();
            var query = (from g in db.group_user_assocs
                         where g.group_id == g_id
                         select g.user_id);
            var subquery = (from o in db.users
                            where (query.Contains(o.user_id))
                            select o);
            if (subquery.Sum(i => i.user_weekly_steps).HasValue)
                totals.weekly = (long)subquery.Sum(i => i.user_weekly_steps);
            if (subquery.Sum(i => i.user_monthly_steps).HasValue)
                totals.monthly = (long)subquery.Sum(i => i.user_monthly_steps);
            if (subquery.Sum(i => i.user_annual_steps).HasValue)
                totals.annual = (long)subquery.Sum(i => i.user_annual_steps);
            if (subquery.Sum(i => i.user_total_steps).HasValue)
                totals.total = (long)subquery.Sum(i => i.user_total_steps);
            return totals;
        }

        public static void GroupUserList(int g_id, DataGrid dg)
        {
            DataClassesDataContext db = new DataClassesDataContext();
            var query = (from g in db.group_user_assocs
                         where g.group_id == g_id
                         select g.user_id);
            var subquery = (from o in db.users
                            where (query.Contains(o.user_id))
                            orderby o.user_weekly_steps descending
                            select new
                            {
                                nickname = o.user_nickname,
                                weekly_steps = (int)((o.user_weekly_steps == null) ? 0 : o.user_weekly_steps),
                                monthly_steps = (int)((o.user_monthly_steps == null) ? 0 : o.user_monthly_steps),
                                annual_steps = (int)((o.user_annual_steps == null) ? 0 : o.user_annual_steps),
                                total_steps = (int)((o.user_total_steps == null) ? 0 : o.user_total_steps),

                            });
            dg.DataSource = subquery;
            dg.DataBind();
        }

        public static rankStruct GroupUserRank(int g_id, ProfileModel profile)
        {
            rankStruct r = new rankStruct();
            DataClassesDataContext db = new DataClassesDataContext();
            var query = (from g in db.group_user_assocs
                         where g.group_id == g_id
                         select g.user_id);

            var subquery = (from o in db.users
                            where (query.Contains(o.user_id) && (o.user_weekly_steps > profile.UserCtx.user_weekly_steps))
                            orderby o.user_weekly_steps ascending
                            select o);

            r.number = query.Count();
            if (subquery.Count() == 0)
            {
                r.rank = 1;
                r.LeaderSteps = (long)profile.UserCtx.user_weekly_steps;
            }
            else
            {
                r.rank = subquery.Count() + 1;
                r.LeaderSteps = (long)subquery.First().user_weekly_steps;
            }
            return r;
        }

        public static void MyGroupList(int u_id, DataGrid dg)
        {
            DataClassesDataContext db = new DataClassesDataContext();
            ArrayList grouplist = new ArrayList();
            var query = (from g in db.group_user_assocs
                         where g.user_id == u_id
                         select g.group_id);
            var subquery = (from o in db.groups
                            where query.Contains(o.group_id)
                            select new
                            {
                                my_groups = String.Format("<a href='groups.aspx?g_id={0}'>{1}</a>", o.group_id.ToString(), o.group_name.ToString()),
                                group_description = o.group_description.ToString(),

                            });
            dg.DataSource = subquery;
            dg.DataBind();
        }

        public static void Search(string s_string, DataGrid dg)
        {
            DataClassesDataContext db = new DataClassesDataContext();
            ArrayList grouplist = new ArrayList();
            var query = (from g in db.groups
                         where ((g.group_private != 1) && (g.group_name.Contains(s_string) || g.group_description.Contains(s_string)))
                         select new
                         {
                             my_groups = String.Format("<a href='groups.aspx?g_id={0}'>{1}</a>", g.group_id.ToString(), g.group_name.ToString()),
                             group_description = g.group_description.ToString()

                         });
            dg.DataSource = query;
            dg.DataBind();
        }

        public static GroupModel Fetch(int group_id)
        {
            DataClassesDataContext db = new DataClassesDataContext();
            group t;
            GroupModel p;
            var query = (from g in db.groups
                         where g.group_id == group_id
                         select g);
            if (query.Count() > 0)
            {
                t = query.First();
                p = new GroupModel(t);
                return p;
            }
            else return null;
        }

        public void Save()
        {
            DataClassesDataContext db = new DataClassesDataContext();
            var group = (from g in db.groups
                         where g.group_id == this.data.group_id
                         select g).First();
            group.group_description = this.data.group_description;
            group.group_name = this.data.group_name;
            group.group_private = this.data.group_private;
            group.updated_at = DateTime.Now;

            db.SubmitChanges();
        }

        public static void JoinGroup(int g_id, int u_id)
        {
            DataClassesDataContext db = new DataClassesDataContext();
            group_user_assoc new_assoc = new group_user_assoc();
            new_assoc.group_id = g_id;
            new_assoc.user_id = u_id;
            new_assoc.created_at = DateTime.Now;
            new_assoc.updated_at = DateTime.Now;
            db.GetTable<group_user_assoc>().InsertOnSubmit(new_assoc);
            db.SubmitChanges();
        }

        public static void LeaveGroup(int g_id, int u_id)
        {
            DataClassesDataContext db = new DataClassesDataContext();
            var query = (from g in db.group_user_assocs
                         where (g.group_id == g_id && g.user_id == u_id)
                         select g).First();

            db.GetTable<group_user_assoc>().DeleteOnSubmit(query);
            db.SubmitChanges();
        }

        public static void DeleteGroup(int g_id)
        {
            DataClassesDataContext db = new DataClassesDataContext();
            var query = (from g in db.groups
                         where (g.group_id == g_id)
                         select g).First();

            db.GetTable<group>().DeleteOnSubmit(query);
            db.SubmitChanges();
        }

        public static bool IsGroupMember(int g_id, int u_id)
        {
            DataClassesDataContext db = new DataClassesDataContext();
            var query = (from g in db.group_user_assocs
                         where (g.group_id == g_id && g.user_id == u_id)
                         select g).Count();
            return (query == 1);
        }

        public static int SaveGroup(group t)
        {
            DataClassesDataContext db = new DataClassesDataContext();
            t.updated_at = DateTime.Now;
            db.GetTable<group>().InsertOnSubmit(t);
            db.SubmitChanges();
            return t.group_id;
        }
    }
}