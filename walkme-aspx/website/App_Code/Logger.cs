using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

using log4net;

namespace Microsoft.Health.Applications.WalkMe
{

    public enum WlkMiCat : ushort
    {
        Error = 0,
        Warning = 1,
        Info = 2,
    }

    public enum WlkMiEvent : ushort
    {
        AppDomain = 0,
        Widget = 1,
        WidgetRss = 2,
        UserSync = 3,
        AppSync = 4,
        UserCreated = 5,
        WidgetSync = 6,
        WidgetImg = 7,
        WidgetOutlook = 8
    }

    public class WlkMiTracer
    {
        static readonly WlkMiTracer instance = new WlkMiTracer();

        static WlkMiTracer()
        {
        }

        WlkMiTracer()
        {
            m_traceLog = log4net.LogManager.GetLogger(
                AppDomain.CurrentDomain.FriendlyName, "WalkMeEventLog");         
        }

        public static WlkMiTracer Instance
        {
            get
            {
                return instance;
            }
        }

        /// <summary>
        /// Logs the given info to the audit table in the pplog database
        /// </summary>
        public void Log(
            String executingEntity,
            WlkMiEvent eventId,
            WlkMiCat cat,
            String msg)
        {
            Log(executingEntity, eventId, cat, msg, null);
        }

        /// <summary>
        /// Logs the given info to the audit table in the log database
        /// </summary>
        public void Log(
            String executingEntity,
            WlkMiEvent eventId,
            WlkMiCat cat,
            String msg,
            Exception e)
        {
            Log(executingEntity, eventId, cat, msg, e, false);
        }

        /// <summary>
        /// Logs the given info to the audit table in the wclog database
        /// </summary>
        public void Log(
            String executingEntity,
            WlkMiEvent eventId,
            WlkMiCat cat,
            String msg,
            Exception e,
            bool forceIntoEventLog)
        {
            switch (cat)
            {
                case WlkMiCat.Error: Logger.Error(
                   executingEntity + ":" + eventId.ToString() + ":" + msg, e);
                    break;
                case WlkMiCat.Warning: Logger.Warn(
                    executingEntity + ":" + eventId.ToString() + ":" + msg, e);
                    break;
                default:
                    Logger.Info(
                        executingEntity + ":" + eventId.ToString() + ":" + msg, e);
                    break;
            }        
        }

        /// <summary>
        /// Returns an instance of TraceLog that writes to the wclog database
        /// </summary>
        private ILog m_traceLog;
        public ILog Logger
        {
            get { return m_traceLog; }
        }
    }
}