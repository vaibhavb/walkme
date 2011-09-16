using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Caching;

namespace Microsoft.Health.Applications.WalkMe
{
    /// <summary>
    /// Summary description for Global
    /// </summary>
    public class Global : HttpApplication
    {
        private static CacheItemRemovedCallback OnCacheRemove = null;

        public Global()
        {
            //
            // TODO: Add constructor logic here
            //
        }
        
        public WlkMiTracer Tracer
        {
            get { return WlkMiTracer.Instance; }
        }

        void Application_Start(object sender, EventArgs e)
        {
            Application.Lock();

            InitializeHVSync();

            Application.UnLock();

            Tracer.Log("Global.asax", WlkMiEvent.AppDomain, WlkMiCat.Info,
                "Starting WebApplication");
        }


        private void InitializeHVSync()
        {
            // Code that runs on application startup
            // Add the HealthVault syncing code runnin in a separate thread.        
            AddTask(Constants.HealthVaultSyncName, Constants.HealthVaultSyncInterval);
        }

        private void AddTask(string name, int seconds)
        {
            OnCacheRemove = new CacheItemRemovedCallback(CacheItemRemoved);
            HttpRuntime.Cache.Insert(name, seconds, null,
                DateTime.Now.AddSeconds(seconds), Cache.NoSlidingExpiration,
                CacheItemPriority.NotRemovable, OnCacheRemove);
        }

        public void CacheItemRemoved(string k, object v, CacheItemRemovedReason r)
        {
            // do stuff here if it matches our taskname, like WebRequest
            if (k.Equals(Constants.HealthVaultSyncName))
            {
                try
                {
                    DateTime? lastCheck;
                    if (HVSync.CheckToPerformHealthVaultSync(Server.MachineName, out lastCheck))
                    {
                        Tracer.Log("Global.asax", WlkMiEvent.AppSync, WlkMiCat.Info,
                            "Starting Sync");
                        HVSync.SyncWlkMiWithHealthVault(lastCheck);
                        Tracer.Log("Global.asax", WlkMiEvent.AppSync, WlkMiCat.Info,
                            "Starting Done");
                    }
                }
                catch (Exception exc)
                {
                    Tracer.Log("Global.asax", WlkMiEvent.AppSync, WlkMiCat.Error,
                        exc.ToString());
                }
                // re-add our task so it recurs
                AddTask(k, Convert.ToInt32(v));
            }
        }


        void Application_End(object sender, EventArgs e)
        {
            //  Code that runs on application shutdown
            Tracer.Log("Global.asax", WlkMiEvent.AppDomain, WlkMiCat.Info, "Stopping WebApplication");
        }

        void Application_Error(object sender, EventArgs e)
        {
            // Code that runs when an unhandled error occurs
            Tracer.Log("Global.asax", WlkMiEvent.AppDomain, WlkMiCat.Error,
                Request.Path + " Errored With: " + Server.GetLastError().ToString());
        }

    }
}