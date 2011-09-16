using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml.Linq;
using System.Runtime.Serialization;
using System.Xml.Serialization;
using System.IO;
using System.Text;

namespace Microsoft.Health.Applications.WalkMe
{
    public partial class Controls_RockyCharts : System.Web.UI.UserControl
    {
        public GraphingLayer lineGraph;

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            if (lineGraph != null)
            {
                PlaceHolder1.Controls.Add
                    (new LiteralControl(lineGraph.GetGraphObject()));

                PlaceHolder1.Visible = true;
                NoData.Visible = false;
            }
            else
            {
                PlaceHolder1.Visible = false;
                NoData.Visible = true;
            }
        }

    }
}



