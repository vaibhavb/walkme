using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Text;

/// <summary>
/// Summary description for GraphingLayer
/// </summary>
namespace Microsoft.Health.Applications.WalkMe
{
    public class GraphingLayer
    {
        Item itemType;
        Time periodSpan;
        Dictionary<string, string> XYData;
        double? goal_target;

        public GraphingLayer(string item, string period,
            Dictionary<string, string> data, double? goal)
        {
            itemType = (Item)Enum.Parse(typeof(Item), item);
            periodSpan = (Time)Enum.Parse(typeof(Time), period);
            XYData = data;
            goal_target = goal;
        }

        public string GetGraphObject()
        {
            LineGraph lineGraph = new LineGraph();
            lineGraph.Header = string.Format(
                "{0} This {1}", itemType.ToString(), periodSpan.ToString());
            lineGraph.XTitle = periodSpan.ToString();
            lineGraph.YTitle = itemType.ToString();

            lineGraph.periodSpan = periodSpan;
            lineGraph.XYData = XYData;
            lineGraph.Goal_Target = goal_target;

            return lineGraph.GetXml();
        }
    }



    public enum Item
    {
        AerobicSteps,
        Calories,
        Fat,
        Steps,
        Distance
    }

    public enum Time
    {
        WeekTrend,
        Week,
        Month,
        Year
    }


    public class LineGraph
    {
        string flashObject =
       @"<script type='text/javascript' src='js/Visifire2.js'></script>    
    <div id='#chart_id#' style='z-index:20;position:relative;' ><script language='javascript' type='text/javascript'>
        var chartXmlString = ""#xml_string#"";
        var vChart = new Visifire2('js/SL.Visifire.Charts.xap.zip',570,250);
        vChart.setDataXml(chartXmlString);
        vChart.render('#chart_id#');
    </script></div>";

        string settings = "<vc:Chart xmlns:vc='clr-namespace:Visifire.Charts;assembly=SLVisifire.Charts' Width='570' Height='250' Watermark='False' Padding='0' BorderThickness='0' Theme='Theme2'>" +


            "<vc:Chart.Titles>" +
                "<vc:Title Text=''/></vc:Chart.Titles>" +
                "<vc:Chart.AxesX>" +
                    "<vc:Axis TitleFontColor='#888' TitleFontFamily='Tahoma' TitleFontSize='12' Title='#XTitle#'>" +
                    "<vc:Axis.AxisLabels>" +
                    "<vc:AxisLabels FontColor='#333333' FontFamily='Tahoma' FontSize='11' />" +
                    "</vc:Axis.AxisLabels></vc:Axis>" +
                "</vc:Chart.AxesX>" +
                "<vc:Chart.Legends>" +
                    "<vc:Legend Enabled='False'/>" +
                "</vc:Chart.Legends>" +
                "<vc:Chart.PlotArea><vc:PlotArea LightingEnabled='False'/></vc:Chart.PlotArea>" +
                "<vc:Chart.AxesY>" +
                    "<vc:Axis TitleFontColor='#888' TitleFontFamily='Tahoma' TitleFontSize='11' Title='#YTitle#' >" +
                    "<vc:Axis.AxisLabels>" +
                    "<vc:AxisLabels FontColor='#333333' FontFamily='Tahoma' FontSize='11' />" +
                    "</vc:Axis.AxisLabels></vc:Axis>" +
                "</vc:Chart.AxesY>";



        public string Header;
        public Time periodSpan;
        public string XTitle;
        public string YTitle;
        public Dictionary<string, string> XYData;
        public double? Goal_Target;

        public string GetXml()
        {
            StringBuilder sb = new StringBuilder(
                settings);
            sb.Replace("#XTitle#", XTitle);
            sb.Replace("#YTitle#", YTitle);
            if (XYData != null && XYData.Keys != null)
            {
                sb.Append("<vc:Chart.Series>");
                sb.Append("<vc:DataSeries LightingEnabled = 'False' RenderAs='Area' Opacity='.5' Color='#febf40' LabelEnabled='False'  ZIndex='5'>");
                sb.Append("<vc:DataSeries.DataPoints>");

                foreach (string s in XYData.Keys)
                {
                    sb.Append(string.Format("<vc:DataPoint LabelFontSize='12' LabelFontColor='#333333' AxisXLabel='{0}' YValue='{1}' />", s, XYData[s]));
                }
                sb.Append("</vc:DataSeries.DataPoints>");
                sb.Append("</vc:DataSeries>");

                sb.Append("<vc:DataSeries LightingEnabled = 'False' RenderAs='Line' Color='#febf40' LabelEnabled='True'  ZIndex='10'>");

                sb.Append("<vc:DataSeries.DataPoints>");

                foreach (string s in XYData.Keys)
                {
                    sb.Append(string.Format("<vc:DataPoint LabelFontSize='13' LabelFontFamily='Tahoma' LabelFontColor='#333333' AxisXLabel='{0}' YValue='{1}' />", s, XYData[s]));
                }
                sb.Append("</vc:DataSeries.DataPoints>");
                sb.Append("</vc:DataSeries>");

                //Graphing the goals
                if (Goal_Target.HasValue)
                {
                    sb.Append("<vc:DataSeries LightingEnabled = 'False' Opacity='.7' Color='#eeeeee'  RenderAs='Area' LabelEnabled='False' ZIndex='1'>");

                    sb.Append("<vc:DataSeries.DataPoints>");

                    //goal
                    double? goal_total = 0;
                    foreach (string s in XYData.Keys)
                    {
                        goal_total += Goal_Target;
                        sb.Append(string.Format("<vc:DataPoint YValue='{0}' />", goal_total));
                    }
                    sb.Append("</vc:DataSeries.DataPoints>");
                    sb.Append("</vc:DataSeries>");
                }
                sb.Append("</vc:Chart.Series>");

            }
            sb.Append("</vc:Chart>");
            string return_string = flashObject.Replace("#chart_id#", periodSpan.ToString());
            return return_string.Replace("#xml_string#", sb.ToString());
        }
    }

}