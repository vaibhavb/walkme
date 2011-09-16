#region Apache License
//
// Licensed to the Apache Software Foundation (ASF) under one or more 
// contributor license agreements. See the NOTICE file distributed with
// this work for additional information regarding copyright ownership. 
// The ASF licenses this file to you under the Apache License, Version 2.0
// (the "License"); you may not use this file except in compliance with 
// the License. You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
#endregion

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

 /// <summary>
 /// Summary description for GoalModel
 /// </summary>

namespace Microsoft.Health.Applications.WalkMe
{
    public class GoalModel
    {
        public user data;

        private GoalModel(user g)
        {
            this.data = g;
        }

        public static GoalModel Fetch(int userId)
        {
            DataClassesDataContext db = new DataClassesDataContext();
            user t;
            var query = (from g in db.users
                         where g.user_id == userId
                         select g);
            if (query.ToList().Count == 0)
            {
                t = new user();
                t.user_id = userId;
                DatabaseHelper.Insert<user>(t);
                db.SubmitChanges();
            }
            else
            {
                t = query.First();
            }
            GoalModel goal = new GoalModel(t);
            return goal;
        }

        public static int NumberOfGoals()
        {
            DataClassesDataContext db = new DataClassesDataContext();
            var query = (from g in db.users
                         select g).Count();
            return query;
        }

        public void Save()
        {
            DataClassesDataContext db2 = new DataClassesDataContext();
            var user = (from g in db2.users
                        where g.user_id == this.data.user_id
                        select g).First();


            DataClassesDataContext db = new DataClassesDataContext();
            var goal = (from g in db.users
                        where g.user_id == this.data.user_id
                        select g).First();

            goal.daily_goal_steps = this.data.daily_goal_steps;

            if (goal.daily_goal_steps.HasValue)
            {
                if (!(goal.daily_goal_distance.HasValue) || (goal.daily_goal_distance == 0))
                    goal.daily_goal_distance = DataConversion.GetDistanceFromSteps(user.user_stride, goal.daily_goal_steps.Value);
                else
                    goal.daily_goal_distance = this.data.daily_goal_distance;

                if (!(goal.daily_goal_calories.HasValue) || (goal.daily_goal_calories == 0))
                    goal.daily_goal_calories = DataConversion.GetEnergyFromDistanceAndWeight(goal.daily_goal_distance.Value, user.user_weight);
                else
                    goal.daily_goal_calories = this.data.daily_goal_calories;
            }

            goal.daily_goal_aerobic_steps = this.data.daily_goal_aerobic_steps;

            db.SubmitChanges();
        }
    }
}