using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using System.Text;

using Microsoft.Health;
using Microsoft.Health.Web;
using Microsoft.Health.ItemTypes;
using Microsoft.Health.ItemTypes.Old;

namespace Microsoft.Health.Applications.WalkMe
{
    /// <summary>
    /// Class to encapsulate sync behavior with HV.
    /// </summary>
    public class HVSync
    {
        public static void OnlineSyncUser(ProfileModel profile, PersonInfo info, bool partialSync)
        {
            string syncType = "partial";
            DateTime? lastSyncTime = profile.UserCtx.hv_last_sync_time;
            DateTime timeStamp = DateTime.Now;

            // reset lastsynctime if this is a full sync
            if (!lastSyncTime.HasValue || !partialSync)
            {
                WlkMiTracer.Instance.Log("HVSync.cs:OnlineSyncUser", WlkMiEvent.UserSync,
                      WlkMiCat.Info, string.Format("Full syncing for User: {0}",
                        profile.UserCtx.user_id));
                lastSyncTime = null;
            }

            // Retrieve the latest info from HealthVault
            HealthRecordItemCollection items =
                GetHVItemsOnline(info, lastSyncTime);
            if (items != null && items.Count > 0)
            {
                foreach (HealthRecordItem item in items)
                {
                    // Do the distinct per item work
                    ProcessStepsHealthItem(item, profile);
                }
            }

            //only update the last sync time if we are able to download items
            if (items != null)
            {
                //set last sync time
                profile.UserCtx.hv_last_sync_time = timeStamp;
                profile.Save();
            }

            // Clear the WlkMi data cache if the last sync is null or this is a full sync
            if (!lastSyncTime.HasValue || !partialSync)
            {
                WlkMiTracer.Instance.Log("HVSync.cs:OnlineSyncUser", WlkMiEvent.UserSync,
                      WlkMiCat.Info, string.Format("Full sync deleting information for User: {0}",
                        profile.UserCtx.user_id));
                lastSyncTime = null;
                WalkLogModel.ClearUserCache(profile);
                syncType = "full";
            }

            //Processtotals for this user
            WalkLogModel.ProcessTotals(profile.UserCtx.user_id);

            WlkMiTracer.Instance.Log("HVSync:OnlineSyncUser", WlkMiEvent.UserSync,
                WlkMiCat.Info, string.Format("Completed Online {1} Sync of User: {0}",
                profile.UserCtx.user_id.ToString(), syncType));
        }

        private static void ProcessStepsHealthItem(HealthRecordItem item, ProfileModel profile)
        {
            if (item.TypeId.Equals(AerobicSession.TypeId))
            {
                AerobicSession aerobic = (AerobicSession)item;

                // Only add items with Steps
                if (aerobic.Session.NumberOfSteps > 0)
                {

                    // Is Step in Cache ?
                    DataClassesDataContext db = new DataClassesDataContext();
                    var query = (from g in db.walk_logs
                                 where ((g.log_user == profile.UserCtx.user_id) &&
                                       (g.hv_item_id == item.Key.Id))
                                 select g).SingleOrDefault();
                    // Update or Insert?
                    if (query != null)
                    {
                        query =
                            PopulateWalkLogFromHV(
                                query, aerobic, profile);
                        db.SubmitChanges();
                    }
                    else
                    {
                        walk_log entity = new walk_log();
                        entity = PopulateWalkLogFromHV(
                            entity, aerobic, profile);
                        WalkLogModel.Insert(entity);
                    }
                }

            }
            else if (item.TypeId.Equals(Exercise.TypeId))
            {
                Exercise exercise = (Exercise)item;

                // Only add items with Steps
                double numberOfSteps = 0;
                try
                {
                    numberOfSteps =
                        exercise.Details[ExerciseDetail.Steps_count].Value.Value;
                }
                catch
                {
                    WlkMiTracer.Instance.Log("HVSync.cs:ProcessStepsHealthItem", WlkMiEvent.AppDomain, WlkMiCat.Warning,
                        string.Format("UserId {0} has no pedometer data in HV item", profile.UserCtx.user_id));
                    return;
                }

                if (numberOfSteps > 0)
                {

                    // Is Step in Cache ?
                    DataClassesDataContext db = new DataClassesDataContext();
                    var query = (from g in db.walk_logs
                                 where ((g.log_user == profile.UserCtx.user_id) &&
                                       (g.hv_item_id == item.Key.Id))
                                 select g).SingleOrDefault();
                    // Update or Insert?
                    if (query != null)
                    {
                        query =
                            PopulateWalkLogFromHV(
                                query, exercise, profile);
                        db.SubmitChanges();
                    }
                    else
                    {
                        walk_log entity = new walk_log();
                        entity = PopulateWalkLogFromHV(
                            entity, exercise, profile);
                        WalkLogModel.Insert(entity);
                    }
                }
            }
        }


        public static walk_log PopulateWalkLogFromHV(walk_log entity,
            AerobicSession aerobics, ProfileModel profile)
        {
            entity.log_user = profile.UserCtx.user_id;
            //TODO: obtain weight from HV when the steps were recorded
            entity.log_weight = profile.UserCtx.user_weight;
            entity.log_date = aerobics.When.ToDateTime();
            entity.log_steps = aerobics.Session.NumberOfSteps;
            entity.log_aerobicsteps = aerobics.Session.NumberOfAerobicSteps;

            if (aerobics.Session.Distance != null)
            {
                entity.log_distance = aerobics.Session.Distance.Meters / 1609.344;
            }
            else
            {
                // Get distance from steps
                entity.log_distance = DataConversion.GetDistanceFromSteps(
                    profile.UserCtx.user_stride,
                    aerobics.Session.NumberOfSteps.Value);
            }

            if (aerobics.Session.Energy.HasValue)
            {
                entity.log_calories = aerobics.Session.Energy;
            }
            else
            {
                // Get energy from steps
                entity.log_calories = DataConversion.GetEnergyFromSteps(
                    profile.UserCtx.user_stride,
                    profile.UserCtx.user_weight,
                    aerobics.Session.NumberOfSteps.Value);
            }
            entity.hv_item_id = aerobics.Key.Id;
            entity.updated_at = DateTime.Now;
            return entity;
        }

        public static walk_log PopulateWalkLogFromHV(walk_log entity,
            Exercise exercise, ProfileModel profile)
        {
            entity.log_user = profile.UserCtx.user_id;

            //TODO: obtain weight from HV when the steps were recorded
            entity.log_weight = profile.UserCtx.user_weight;

            entity.log_date = new DateTime(
                exercise.When.ApproximateDate.Year,
                exercise.When.ApproximateDate.Month.HasValue ?
                    exercise.When.ApproximateDate.Month.Value : 1,
                exercise.When.ApproximateDate.Day.HasValue ?
                    exercise.When.ApproximateDate.Day.Value : 1,
                exercise.When.ApproximateTime.Hour,
                exercise.When.ApproximateTime.Minute,
                exercise.When.ApproximateTime.Second.HasValue ?
                    exercise.When.ApproximateTime.Second.Value : 1);

            long steps = (long)exercise.Details[ExerciseDetail.Steps_count].Value.Value;
            entity.log_steps = steps;

            int aerobicSteps = 0;
            try
            {
                aerobicSteps = (int)exercise.Details[ExerciseDetail.AerobicSteps_count].Value.Value;
            }
            catch
            {
                // eat 
            }
            entity.log_aerobicsteps = aerobicSteps;


            if (exercise.Distance != null)
            {
                entity.log_distance = DataConversion.ConvertMetersToMiles(
                    exercise.Distance.Meters);
            }
            else
            {
                // Get distance from steps
                entity.log_distance = DataConversion.GetDistanceFromSteps(
                    profile.UserCtx.user_stride,
                    steps);
            }

            double? calories = null;
            try
            {
                calories =
                    exercise.Details[ExerciseDetail.CaloriesBurned_calories].Value.Value;
            }
            catch
            {
                // eat calorie errors
            }
            if (calories.HasValue)
            {
                entity.log_calories = calories.Value;
            }
            else
            {
                // Get energy from steps
                entity.log_calories = DataConversion.GetEnergyFromSteps(
                    profile.UserCtx.user_stride,
                    profile.UserCtx.user_weight,
                    steps);
            }
            entity.hv_item_id = exercise.Key.Id;
            entity.updated_at = DateTime.Now;
            return entity;
        }


        public static void OfflineSyncUser(ProfileModel profile)
        {
            DateTime timeStamp = DateTime.Now;

            // Retrieve the latest info from HealthVault
            if (profile.UserCtx.hv_personid != null)
            {
                HealthRecordItemCollection items = GetHVItemsOffline(profile.UserCtx.hv_personid,
                    profile.UserCtx.hv_recordid, profile.UserCtx.hv_last_sync_time);
                if (items != null && items.Count > 0)
                {
                    foreach (HealthRecordItem item in items)
                    {
                        // Do the distinct per item work
                        ProcessStepsHealthItem(item, profile);
                    }
                    WlkMiTracer.Instance.Log("HVSync.cs:OfflineSyncUser", WlkMiEvent.AppSync,
                        WlkMiCat.Info, string.Format("Number of items retrieved from HV: {0}",
                        items.Count));
                }
                //only update the last sync time if we are able to download items
                if (items != null)
                {
                    //set last sync time
                    profile.UserCtx.hv_last_sync_time = timeStamp;
                    profile.Save();
                }
            }

            // Clear the WlkMi data cache if the last sync is null
            // In other words, you can also set the time stamp for user's last sync to null
            // to trigger a full offline sync.
            // TODO: Consider not doing this for production
            if (!profile.UserCtx.hv_last_sync_time.HasValue)
            {
                WlkMiTracer.Instance.Log("HVSync.cs:OfflineSyncUser", WlkMiEvent.AppSync,
                    WlkMiCat.Info, string.Format("Deleting information for user {0}",
                    profile.UserCtx.user_id));

                WalkLogModel.ClearUserCache(profile);
            }

            // Processtotals for this user
            WalkLogModel.ProcessTotals(profile.UserCtx.user_id);

            WlkMiTracer.Instance.Log("HVSync.cs:OfflineSyncUser", WlkMiEvent.AppSync,
                WlkMiCat.Info, string.Format("Completed Offline Sync of User: {0}",
                profile.UserCtx.user_id.ToString()));
        }

        public static HealthRecordItemCollection GetHVItemsOnline(PersonInfo info, DateTime? lastSync)
        {
            HealthRecordSearcher searcher = info.SelectedRecord.CreateSearcher();

            HealthRecordFilter filter = new HealthRecordFilter(Exercise.TypeId,
                AerobicSession.TypeId);

            if (lastSync.HasValue)
                filter.UpdatedDateMin = (DateTime)lastSync;


            // TODO: Add filter so that we get only items with steps
            searcher.Filters.Add(filter);
            HealthRecordItemCollection items = searcher.GetMatchingItems()[0];

            return items;
        }

        public static HealthRecordItemCollection GetHVItemsOffline(Guid personId,
            Guid recordGuid, DateTime? lastSync)
        {
            // Do the offline connection
            OfflineWebApplicationConnection offlineConn =
                new OfflineWebApplicationConnection(personId);
            offlineConn.RequestTimeoutSeconds = 180;  //extending time to prevent time outs for accounts with large number of items
            offlineConn.Authenticate();
            HealthRecordAccessor accessor =
                new HealthRecordAccessor(offlineConn, recordGuid);
            HealthRecordSearcher searcher = accessor.CreateSearcher();

            HealthRecordFilter filter = new HealthRecordFilter(Exercise.TypeId,
                AerobicSession.TypeId);

            if (lastSync.HasValue)
                filter.UpdatedDateMin = (DateTime)lastSync;

            searcher.Filters.Add(filter);

            HealthRecordItemCollection items = null;
            try
            {
                items = searcher.GetMatchingItems()[0];
            }
            catch (Exception err)
            {
                WlkMiTracer.Instance.Log("HVSync.cs:GetHVItemsOffline", WlkMiEvent.AppSync, WlkMiCat.Error,
                        string.Format("Error for user {0} : {1} ",
                        recordGuid.ToString(), err.ToString()));
            }
            return items;
        }

        public static void SyncWlkMiWithHealthVault(
            DateTime? lastUpdatedDate)
        {
            WlkMiTracer.Instance.Log("HVSync.cs", WlkMiEvent.AppSync, WlkMiCat.Info,
                "Getting updated records from HealthVault");
            // Do the offline connection
            OfflineWebApplicationConnection offlineConn =
                new OfflineWebApplicationConnection();
            offlineConn.Authenticate();
            IList<Guid> updatedUserIds =
                offlineConn.GetUpdatedRecordsForApplication(lastUpdatedDate);
            WlkMiTracer.Instance.Log("HVSync.cs", WlkMiEvent.AppSync, WlkMiCat.Info,
                string.Format("Got {0} updated records from HealthVault", updatedUserIds.Count));

            foreach (Guid recordid in updatedUserIds)
            {
                ProfileModel syncUser = ProfileModel.Fetch(recordid);
                if (syncUser == null)
                {
                    WlkMiTracer.Instance.Log("HVSync.cs", WlkMiEvent.AppSync, WlkMiCat.Error,
                        string.Format("No WlkMi user found for recordif {0} ", recordid));
                    continue;
                }
                // Decide to update this guy?
                if (syncUser.UserCtx.hv_last_sync_time > DateTime.Now.AddSeconds(
                    -Constants.UserSyncIntervalInSeconds))
                {
                    WlkMiTracer.Instance.Log("HVSync.cs", WlkMiEvent.AppSync, WlkMiCat.Info,
                        string.Format("Skipping sync for user {0} ", syncUser.UserCtx.user_id));
                }
                else
                {
                    HVSync.OfflineSyncUser(syncUser);
                }
            }
        }

        /// <summary>
        /// We perform a database update to resolve which server should go first.
        /// </summary>
        /// <returns>Go or No go decision</returns>
        public static bool CheckToPerformHealthVaultSync(string serverName,
            out DateTime? lastUpdatedDate)
        {
            DataClassesDataContext db = new DataClassesDataContext();
            var query = (from g in db.sync_settings
                         where g.sync_job_id == Constants.AppSyncRowKey
                         select g).FirstOrDefault();
            if (query != null)
            {
                lastUpdatedDate =
                    (query.sync_id == Constants.SyncFinished) ?
                    query.sync_timestamp :
                    DateTime.MinValue;

                // Check when was the last sync performed
                if ((DateTime.Now - query.sync_timestamp).TotalMinutes >
                     (query.sync_frequency_hours * 60))
                {
                    // Sync is long overdue or the previous process was zombied
                    // lets try start it
                    query.sync_server_name = serverName;
                    query.sync_timestamp = DateTime.Now;
                    query.sync_status = Constants.SyncStarted;
                    try
                    {
                        db.SubmitChanges();
                    }
                    catch
                    {
                        // Some one changed the data under me!
                        return false;
                    }
                    // Viola! we have the lock!
                    return true;
                }
            }
            lastUpdatedDate = null;
            return false;
        }

        /// <summary>
        /// Create a new step to HealthVault
        /// </summary>
        public static bool SaveStepsToHV(PersonInfo info, DateTime dateRecorded,
            long steps, ProfileModel profile)
        {
            ApproximateDateTime hvDate = new ApproximateDateTime(
                new ApproximateDate(dateRecorded.Year, dateRecorded.Month, dateRecorded.Day),
                new ApproximateTime(
                    dateRecorded.Hour, dateRecorded.Minute, dateRecorded.Second));

            Exercise newData = new Exercise(hvDate,
                new CodableValue("walk", new CodedValue("walk", "aerobic-activities")));

            newData.Details.Add(ExerciseDetail.Steps_count,
                new ExerciseDetail(new CodedValue(ExerciseDetail.Steps_count, "exercise-detail-names"),
                    new StructuredMeasurement(
                        (double)steps,
                        new CodableValue("Count", new CodedValue("Count", "exercise-units")))));

            if (profile.UserCtx.user_stride > 0)
            {
                double? distance = DataConversion.GetDistanceFromSteps(profile.UserCtx.user_stride,
                    steps);
                if (distance.HasValue && distance.Value > 0)
                {
                    newData.Distance = new Length(DataConversion.ConvertMilesToMeters(distance.Value));
                }

                if (profile.UserCtx.user_weight > 0)
                {
                    newData.Details.Add(ExerciseDetail.CaloriesBurned_calories,
                        new ExerciseDetail(new CodedValue(ExerciseDetail.CaloriesBurned_calories, "exercise-detail-names"),
                            new StructuredMeasurement(
                                DataConversion.GetEnergyFromSteps(profile.UserCtx.user_stride,
                                profile.UserCtx.user_weight, (int)steps).Value,
                                new CodableValue("Calories", new CodedValue("Calories", "exercise-units")))
                        ));
                }
            }
            info.SelectedRecord.NewItem(newData);
            return true; //Success
        }

        /// <summary>
        /// Create a new miles to HealthVault
        /// </summary>
        public static bool SaveMilesToHV(PersonInfo info, DateTime dateRecorded,
            double distance, ProfileModel profile)
        {
            ApproximateDateTime hvDate = new ApproximateDateTime(
                new ApproximateDate(dateRecorded.Year, dateRecorded.Month, dateRecorded.Day),
                new ApproximateTime(
                    dateRecorded.Hour, dateRecorded.Minute, dateRecorded.Second));

            Exercise newData = new Exercise((ApproximateDateTime)hvDate,
                new CodableValue("walk", new CodedValue("walk", "aerobic-activities")));

            DisplayValue hvDisplay = new DisplayValue(distance, "Miles");

            //convert miles into meters
            if (distance > 0)
            {
                newData.Distance = new Length(DataConversion.ConvertMilesToMeters(distance),
                    hvDisplay);
            }

            if (profile.UserCtx.user_stride > 0)
                newData.Details.Add(ExerciseDetail.Steps_count,
                    new ExerciseDetail(new CodedValue(ExerciseDetail.Steps_count, "exercise-detail-names"),
                        new StructuredMeasurement(
                            DataConversion.GetStepsFromDistanceAndStride(distance, profile.UserCtx.user_stride),
                            new CodableValue("Count", new CodedValue("Count", "exercise-units")))));

            if (profile.UserCtx.user_weight > 0)
                newData.Details.Add(ExerciseDetail.CaloriesBurned_calories,
                    new ExerciseDetail(new CodedValue(ExerciseDetail.CaloriesBurned_calories, "exercise-detail-names"),
                        new StructuredMeasurement(
                            DataConversion.GetEnergyFromDistanceAndWeightNotNullable(distance, profile.UserCtx.user_weight),
                            new CodableValue("Calories", new CodedValue("Calories", "exercise-units")))
                            ));

            info.SelectedRecord.NewItem(newData);
            return true; //Success
        }
    }
}