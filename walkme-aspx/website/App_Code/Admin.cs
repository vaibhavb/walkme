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
    public class AdminModel
    {
        public user data;
        public bool IsNewUser = false;

        private AdminModel(user g, bool isNewUser)
        {
            this.data = g;
            this.IsNewUser = isNewUser;
        }

        public static int? IsUserPublic(string userName)
        {
            DataClassesDataContext db = new DataClassesDataContext();
            user t;
            var query = (from g in db.users
                         where g.user_nickname.Equals(userName) &&
                               g.user_sharing_flag == 1
                         select g);
            if (query.ToList().Count == 0)
            {
                return null;
            }
            else
            {
                t = query.First();
                return t.user_id;
            }
        }
    }
}