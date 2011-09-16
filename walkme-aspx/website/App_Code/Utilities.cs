using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

using Microsoft.Security.Application;

namespace Microsoft.Health.Applications.WalkMe
{
    /// <summary>
    /// Configuration constants for WlkMi
    /// </summary>
    public static class Constants
    {
        public static Guid AdminGuid = new Guid("33796d3b-aca4-4493-8efa-da08aea0c663");

        // TODO: Investigate adding output cache duration through a static variable
        // We can actually put the this OutputCachePolicy in web.config
        public static int OutputCachingDuration = 3600;

        public static int OutputCacheForMonth = 60 * 60 * 24 * 30;

        // Sync with HV every three hours
        public static int HealthVaultSyncInterval = 3600 * 3;

        // 5 minutes timeout for widgets
        public static long WidgetCacheTimeout = 5 * 60;

        public static string HealthVaultSyncName = "SyncWlkMiWithHealthVault";

        public static string ConnectionString =
            System.Configuration.ConfigurationManager.
                ConnectionStrings["WalkMeConnectionString"].ConnectionString;

        public static string UserSyncCookieName = "WlkMi-UserSync";
        public static string UserSyncCookieValue = "sync";
        public static string UserSyncCookieId = "Id";
        public static string UserSyncCookieDone = "1";
        public static string UserSyncCookieNotDone = "0";
        public static int UserSyncIntervalInSeconds = 10;
        public static int MinutesUserSyncCookieIsValid = 20;
        public static int WidgetSyncIntervalInMinutes = 6 * 60;

        public static Guid AppSyncRowKey = new Guid("501da65c-90de-475d-b449-947e0191bff9");
        public static int SyncNotStarted = 0;
        public static int SyncStarted = 1;
        public static int SyncFinished = 2;
        public static int SyncFrequency
        {
            get
            {
                try
                {
                    return int.Parse(System.Configuration.
                        ConfigurationManager.AppSettings["WlkMiAppSyncFrequencyInHours"]);
                }
                catch
                {
                    return 6;
                }
            }
        }

    }

    /// <summary>
    /// This class encapsulates all the data checks 
    /// </summary>
    public static class DataChecks
    {
        public static bool CheckValidZip(int zip)
        {
            if ((zip < 600) || (zip > 99950))
            {
                return false;
            }
            return true;
        }

        public static void AssertValidZip(int zip)
        {
            if (!CheckValidZip(zip))
            {
                throw new WlkMiException("Zip must be between 00600 and 99950");
            }
        }

        public static bool CheckValidAge(int year)
        {
            if ((year < 1901) || (year > 2009))
            {
                return false;
            }
            return true;
        }

        public static void AssertValidAge(int year)
        {
            if (!CheckValidAge(year))
            {
                throw new WlkMiException("Birthyear must be between 1901 and 2009");
            }
        }

        public static bool CheckValidHeight(int height)
        {
            if ((height < 24) || (height > 96))
            {
                return false;
            }
            return true;
        }

        public static void AssertValidStride(int stride)
        {
            if (!CheckValidStride(stride))
            {
                throw new WlkMiException("Stride must be between 12 and 72 inches");
            }
        }

        public static bool CheckValidStride(int stride)
        {
            if ((stride < 12) || (stride > 72))
            {
                return false;
            }
            return true;
        }

        public static void AssertValidHeight(int height)
        {
            if (!CheckValidHeight(height))
            {
                throw new WlkMiException("Height must be between 24 and 96 inches");
            }
        }
        public static bool CheckValidWeight(int weight)
        {
            if ((weight < 8) || (weight > 1200))
            {
                return false;
            }
            return true;
        }

        public static void AssertValidWeight(int weight)
        {
            if (!CheckValidWeight(weight))
            {
                throw new WlkMiException("Weight must be between 8 and 1200 lbs");
            }
        }

        public static void AssertValidSteps(int steps)
        {
            if (!CheckValidSteps(steps))
            {
                throw new WlkMiException("Steps must be greater than zero and less than 500,000 steps");
            }
        }

        public static bool CheckValidSteps(int steps)
        {
            if ((steps < 0) || (steps > 500000))
            {
                return false;
            }
            return true;
        }

        public static void AssertValidCalDistance(double c)
        {
            if (!CheckValidCalDistance(c))
            {
                throw new WlkMiException("Distance must be greater than zero and less than 200 miles");
            }
        }

        public static bool CheckValidCalDistance(double c)
        {
            if ((c < 0) || (c > 200))
            {
                return false;
            }
            return true;
        }
    }

    /// <summary>
    /// This class encapsulates all the data conversions
    /// </summary>
    public static class DataConversion
    {
        public static String AddOrdinalSuffix(int num)
        {
            //can handle negative numbers (-1st, -12th, -21st)

            int last2Digits = Math.Abs(num % 100);
            int lastDigit = last2Digits % 10;

            //the only nonconforming set is numbers ending in <...eleventh, ...twelfth, ...thirteenth> 

            return num.ToString() + "thstndrd".Substring((last2Digits > 10 && last2Digits < 14) || lastDigit > 3 ? 0 : lastDigit * 2, 2);
        }

        public static double ConvertMetersToMiles(double meters)
        {
            return (meters / 1609.344);
        }

        public static double GetStepsFromDistanceAndStride(double distance, int stride)
        {
            return (distance * 63360 / (double)stride);
        }

        public static double ConvertMilesToMeters(double distance)
        {
            return Math.Round((double)(distance) * 1609.34, 2);
        }

        // TODO: Database change make height float
        public static float GetBMI(decimal height, int weight)
        {
            return (((float)weight * 703) / (float)(height * height));
        }

        public static double ConverKgToLb(double kg)
        {
            return (kg * 2.2046226);
        }

        public static double ConvertMetersToInches(double m)
        {
            return (m * 39.3700787);
        }

        public static double GetDistanceFromSteps(int stride, long steps)
        {
            if (stride > 0)
            {
                return (Math.Round((double)
                        (steps * stride) / 63360, 2));
            }
            else
            {
                return 0;
            }
        }

        public static double?
            GetEnergyFromDistanceAndWeight(double? distance, int weight)
        {
            if (weight > 0 && distance.HasValue)
            {
                return (Math.Round((double)(
                                (weight / 2.2) * distance.Value), 2));
            }
            else
            {
                return null;
            }
        }

        public static double
            GetEnergyFromDistanceAndWeightNotNullable(double distance, int weight)
        {
            return Math.Round((double)(weight / 2.2) * distance, 2);
        }

        public static double?
            GetEnergyFromSteps(int stride, int weight, double steps)
        {
            if (stride > 0 && weight > 0)
            {
                double distance = (Math.Round((double)
                        (steps * stride) / 63360, 2));
                return (Math.Round((double)(
                                (weight / 2.2) * distance), 2));
            }
            else
            {
                return null;
            }
        }
    }


    /// <summary>
    /// This class encapsulates all the outbound data checks.
    /// Typically, all the AntiXss stuff can we put here.
    /// </summary>
    public static class DataDisplayChecks
    {

        public static string DisplayString(string outputString)
        {
            return AntiXss.HtmlEncode(outputString);
        }

        private static string DisplayDefaultAsEmpty(int w, int d)
        {
            if (w == d)
            {
                return String.Empty;
            }
            else
            {
                return DisplayString(w.ToString());
            }
        }

        private static string DisplayDefaultAsEmpty(double w, double d)
        {
            if (w == d)
            {
                return String.Empty;
            }
            else
            {
                return DisplayString(w.ToString());
            }
        }

        public static string DisplayBirthYear(int b)
        {
            return DisplayDefaultAsEmpty(b, 1900);
        }

        public static string DisplayWeight(int w)
        {
            return DisplayDefaultAsEmpty(w, 0);
        }

        public static string DisplayHeight(int h)
        {
            return DisplayDefaultAsEmpty(h, 1);
        }

        public static string DisplayStride(int s)
        {
            return DisplayDefaultAsEmpty(s, 0);
        }

        public static string DisplayZip(int z)
        {
            return DisplayDefaultAsEmpty(z, 0);
        }

        public static string DisplayInt(int? s)
        {
            if (s.HasValue)
                return DisplayDefaultAsEmpty((int)s, 0);
            else
                return DisplayDefaultAsEmpty(0, 0);
        }

        public static string DisplayDouble(double? s)
        {
            if (s.HasValue)
                return DisplayDefaultAsEmpty((double)s, 0);
            else
                return DisplayDefaultAsEmpty(0, 0);
        }

    }

    public class WlkMiException : ApplicationException
    {
        public WlkMiException(string message)
            : base(message)
        {

        }
    }
}