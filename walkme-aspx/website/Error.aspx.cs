using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using Microsoft.Health.Applications.WalkMe;

namespace Microsoft.Health.Applications.WalkMe
{
    public partial class Error : WlkMiBasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected override bool LogOnRequired
        {
            get
            {
                return false;
            }
        }

        protected String DisplayError()
        {
            string error = (string)(Server.GetLastError().Message);
            Server.ClearError();
            return error;
        }
    }
}