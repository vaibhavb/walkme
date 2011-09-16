<%@ WebHandler Language="C#" Class="Microsoft.Health.Applications.WalkMe.WlkMi" %>

using System;
using System.Web;
using System.IO;
using System.Xml;
using System.ServiceModel.Syndication;
using System.Collections.Generic;
using System.Drawing;

namespace Microsoft.Health.Applications.WalkMe
{
    public class WlkMi : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            int userId = 0;
            string type = "rss";
            try
            {
                if (!string.IsNullOrEmpty(context.Request.Params["user_id"]))
                {
                    Int32.TryParse(context.Request.Params["user_id"], out userId);
                }
                if (!string.IsNullOrEmpty(context.Request.Params["type"]))
                {
                    type = context.Request.Params["type"];
                }
                int? user = CheckUser(userId);
                if (user != null)
                {
                    // Output caching for this request
                    // SetCachePolicy(context);
                    if (type.ToLower().Equals("rss"))
                    {
                        ReportLast10Logs(context, WalkLogModel.GetLast10Logs(user.Value), userId);
                    }
                    if (type.ToLower().Equals("img"))
                    {
                        ReportPedometerImg(context, WalkLogModel.GetTotalSteps(user.Value), userId);
                    }
                    if (type.ToLower().Equals("outlook"))
                    {
                        ReportAsOutLookSignature(context, userId);
                    }
                    else
                    {
                        ReportPedometer(context, WalkLogModel.GetTotalSteps(user.Value), userId);
                    }
                }
                else
                {
                    AccessDenied(context);
                }
            }
            catch (Exception exc)
            {
                // Don't catch thread aborts, they are Response.End triggered
                if (exc is System.Threading.ThreadAbortException)
                {
                    throw exc;
                }

                // We want the handler to be fault-proof eat everything and log errors.
                WlkMiTracer.Instance.Log(
                    "WlkMi.ashx",
                    WlkMiEvent.Widget,
                    WlkMiCat.Error,
                    exc.ToString());
                // Finish silently
                context.Response.Clear();
                context.Response.End();
            }
        }

        private int? CheckUser(int userId)
        {
            ProfileModel User = ProfileModel.IsUserPublic(userId);
            if (User == null)
            {
                return null;
            }
            else
            {
                //Check if we need to do an offline sync.
                if ((!User.UserCtx.hv_last_sync_time.HasValue) ||
                    ((DateTime.Now - User.UserCtx.hv_last_sync_time.Value).TotalMinutes >
                    Constants.WidgetSyncIntervalInMinutes))
                {
                    WlkMiTracer.Instance.Log(
                        "WlkMi.ashx",
                        WlkMiEvent.WidgetSync,
                        WlkMiCat.Info,
                        string.Format("Start - sycing user id {0} from widget",
                        User.UserCtx.user_id));
                    HVSync.OfflineSyncUser(User);
                    WlkMiTracer.Instance.Log(
                        "WlkMi.ashx",
                        WlkMiEvent.WidgetSync,
                        WlkMiCat.Info,
                        string.Format("Done - sycing user id {0} from widget",
                        User.UserCtx.user_id));
                }
                return User.UserCtx.user_id;
            }
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }

        private void ReportPedometer(HttpContext context, long totalSteps, int userId)
        {
            string html =
                @"
<html>
<title>WalkMe widget</title>
<head>
<style type=""text/css"">

    div.widget_container #widget_message {
        border: 1px solid #ccc;
        background-color: grey;
    }
    .widget_container 
    {
        width:190px;
        text-align:center;
        font-family:tahoma;
        font-size:11px;                
    }
    .widget_dig
    {
        background-image:url(images/digitBG.gif);
        font-family:Verdana;
        font-size:14px;
        float:left;
        margin-right:1px;
        padding:5px;
        color:#40454a;
        border:1px solid #ccc;        
    }
    .widget_dig-frame
    {
        margin:auto;
        float:left;
        clear:both;
    }
    .widget-text
    {
        font-size:12px;
        font-family:Verdana;
        color:#98a4b1;
        margin-top:8px;
   }
</style>
</head>
<body>

<div class=""widget_container"">
    <img border=""0"" src=""https://apps.healthvault.com/app4/images/logo_widget.gif"" style=""margin:auto;margin-bottom:8px;""/>
    <table border=""0"" style=""margin:auto"">
        <tr>
            <td class=""widget_dig"">[digit6]</td>
            <td>,</td>               
            <td class=""widget_dig"">[digit5]</td>
            <td class=""widget_dig"">[digit4]</td>
            <td class=""widget_dig"">[digit3]</td>
            <td>,</td>            
            <td class=""widget_dig"">[digit2]</td>        
            <td class=""widget_dig"">[digit1]</td>                    
            <td class=""widget_dig"">[digit0]</td>                    
        </tr>
    </table>
    <div class=""widget-text"">
        <div style=""margin-bottom:5px;"">Steps walked with Friends</div>
        <a style=""color:#6da8f0"" href=""http://apps.healthvault.com/walkme"" target=""_blank"">WalkMe</a>
    </div>   
</div>
     <div>
            <img alt=""DCSIMG"" id=""DCSIMG"" width=""1"" height=""1"" src=""https://www.microsofthsg.com/dcszg2e5izkwpxgiqu5mx6ag8_4c8r/njs.gif?dcsuri=/nojavascript&amp;WT.js=No"" />
        </div>
</body>
</html>";

            int[] digits = new int[7];
            int num = (int)totalSteps; int i = 0;
            while (num != 0)
            {
                digits[i] = num % 10;
                num = num / 10;
                i++;
            }
            for (int j = 0; j < digits.Length; j++)
            {
                html = html.Replace(string.Format("[digit{0}]", j), digits[j].ToString());
            }
            html = html.Replace("{user}", userId.ToString());

            WlkMiTracer.Instance.Log(
                "WlkMi.ashx",
                WlkMiEvent.Widget,
                WlkMiCat.Info,
                string.Format("Showing widget for user id: {0}",
                userId));

            context.Response.Buffer = false;
            context.Response.Clear();
            context.Response.ContentType = "text/html";
            context.Response.Write(html.ToString());
            context.Response.End();
        }

        private void ReportPedometerImg(HttpContext context, long totalSteps, int userId)
        {
            string steps = totalSteps.ToString("###,###,###");
            string s = string.Format("I Walked {0} Steps & Counting...", steps);
            context.Response.Buffer = false;
            context.Response.Clear();
            context.Response.ContentType = "image/gif";
            using (Bitmap image = new Bitmap(1, 1))
            {
                using (Graphics graphics = Graphics.FromImage(image))
                {
                    Font f = new Font("Tahoma", 10);
                    int width = (int)graphics.MeasureString(s, f).Width;
                    int height = (int)graphics.MeasureString(s, f).Height;
                    using (Bitmap modifiedImage =
                            new Bitmap(image, new Size(width, height)))
                    {
                        using (Graphics mgraph = Graphics.FromImage(modifiedImage))
                        {
                            mgraph.Clear(Color.White);
                            mgraph.DrawString(
                                s,
                                f,
                                new SolidBrush(Color.Black),
                                0, 0);

                            graphics.Flush();

                            using (MemoryStream ms = new MemoryStream())
                            {
                                modifiedImage.Save(ms, System.Drawing.Imaging.ImageFormat.Gif);
                                ms.WriteTo(context.Response.OutputStream);
                            }
                        }
                    }
                }
            }

            WlkMiTracer.Instance.Log(
                    "WlkMi.ashx",
                    WlkMiEvent.WidgetImg,
                    WlkMiCat.Info,
                    string.Format("Showing widget for user id: {0}",
                    userId));
            context.Response.End();
        }

        private void ReportLast10Logs(HttpContext context, List<WalkLogModel> logs, int userId)
        {
            context.Response.Buffer = false;
            context.Response.Clear();
            context.Response.ContentType = "application/xml";
            // Create an XmlWriter to write the feed into it
            using (XmlWriter writer = XmlWriter.Create(context.Response.OutputStream))
            {
                SyndicationFeed feed = new SyndicationFeed(
                    "WalkMe Feed",
                    "The WalkMe FeedBot",
                    new Uri("http://apps.healthvault.com/walkme"));

                // Add post items
                List<SyndicationItem> items = new List<SyndicationItem>();
                foreach (WalkLogModel walklog in logs)
                {
                    SyndicationItem item = new SyndicationItem();
                    item.Id = walklog.data.log_id.ToString();
                    item.Title = TextSyndicationContent.CreatePlaintextContent
                        (string.Format("Walked {0} step(s) on {1}", walklog.data.log_steps, walklog.data.log_date.ToString("D")));
                    item.PublishDate = walklog.data.log_date;
                    item.Content = SyndicationContent.CreatePlaintextContent
                        (@"<a href='http://apps.healthvault.com/walkme'>WalkMe</a>");
                    items.Add(item);
                }
                feed.Items = items;

                //Write the Feed
                Rss20FeedFormatter rssFormatter = new Rss20FeedFormatter
                (feed);
                rssFormatter.WriteTo(writer);
                writer.Flush();
            }

            WlkMiTracer.Instance.Log(
                "WlkMi.ashx",
                WlkMiEvent.WidgetRss,
                WlkMiCat.Info,
                string.Format("Showing widget for user id: {0}",
                    userId));

            context.Response.End();
        }

        private void AccessDenied(HttpContext context)
        {
            context.Response.Buffer = false;
            context.Response.Clear();
            context.Response.ContentType = "application/xml";
            // Create an XmlWriter to write the feed into it
            using (XmlWriter writer = XmlWriter.Create(context.Response.OutputStream))
            {
                SyndicationFeed feed = new SyndicationFeed(
                    "WalkMe Feed",
                    "The WalkMe FeedBot",
                    new Uri("http://apps.healthvault.com/walkme"));

                feed.Description = TextSyndicationContent.CreatePlaintextContent
                    ("No feed is available as the user has set their profile to be private");
                //Write the Feed
                Rss20FeedFormatter rssFormatter = new Rss20FeedFormatter
                (feed);
                rssFormatter.WriteTo(writer);
                writer.Flush();
            }
            context.Response.End();
        }

        private void ReportAsOutLookSignature(HttpContext context, int userId)
        {
            string html =
                @"
<html xmlns:o=""urn:schemas-microsoft-com:office:office""
xmlns:w=""urn:schemas-microsoft-com:office:word""
xmlns:m=""http://schemas.microsoft.com/office/2004/12/omml""
xmlns=""http://www.w3.org/TR/REC-html40"">

<head>
<meta http-equiv=Content-Type content=""text/html; charset=windows-1252"">
<meta name=ProgId content=Word.Document>
<meta name=Generator content=""Microsoft Word 12"">
<meta name=Originator content=""Microsoft Word 12"">

<!--[if gte mso 9]><xml>
 <o:DocumentProperties>
  <o:Template>NormalEmail</o:Template>
  <o:Revision>0</o:Revision>
  <o:TotalTime>0</o:TotalTime>
  <o:Pages>1</o:Pages>
  <o:Company>Microsoft</o:Company>
  <o:Lines>1</o:Lines>
  <o:Paragraphs>1</o:Paragraphs>
  <o:Version>12.00</o:Version>
 </o:DocumentProperties>
 <o:OfficeDocumentSettings>
  <o:AllowPNG/>
 </o:OfficeDocumentSettings>
</xml><![endif]-->

<!--[if gte mso 9]><xml>
 <w:WordDocument>
  <w:View>Normal</w:View>
  <w:Zoom>0</w:Zoom>
  <w:TrackMoves/>
  <w:TrackFormatting/>
  <w:PunctuationKerning/>
  <w:ValidateAgainstSchemas/>
  <w:SaveIfXMLInvalid>false</w:SaveIfXMLInvalid>
  <w:IgnoreMixedContent>false</w:IgnoreMixedContent>
  <w:AlwaysShowPlaceholderText>false</w:AlwaysShowPlaceholderText>
  <w:DoNotPromoteQF/>
  <w:LidThemeOther>EN-US</w:LidThemeOther>
  <w:LidThemeAsian>X-NONE</w:LidThemeAsian>
  <w:LidThemeComplexScript>X-NONE</w:LidThemeComplexScript>
  <w:Compatibility>
   <w:BreakWrappedTables/>
   <w:SnapToGridInCell/>
   <w:WrapTextWithPunct/>
   <w:UseAsianBreakRules/>
   <w:DontGrowAutofit/>
   <w:SplitPgBreakAndParaMark/>
   <w:DontVertAlignCellWithSp/>
   <w:DontBreakConstrainedForcedTables/>
   <w:DontVertAlignInTxbx/>
   <w:Word11KerningPairs/>
   <w:CachedColBalance/>
   <w:UseFELayout/>
  </w:Compatibility>
  <m:mathPr>
   <m:mathFont m:val=""Cambria Math""/>
   <m:brkBin m:val=""before""/>
   <m:brkBinSub m:val=""&#45;-""/>
   <m:smallFrac m:val=""off""/>
   <m:dispDef/>
   <m:lMargin m:val=""0""/>
   <m:rMargin m:val=""0""/>
   <m:defJc m:val=""centerGroup""/>
   <m:wrapIndent m:val=""1440""/>
   <m:intLim m:val=""subSup""/>
   <m:naryLim m:val=""undOvr""/>
  </m:mathPr></w:WordDocument>
</xml><![endif]--><!--[if gte mso 9]><xml>
 <w:LatentStyles DefLockedState=""false"" DefUnhideWhenUsed=""true""
  DefSemiHidden=""true"" DefQFormat=""false"" DefPriority=""99""
  LatentStyleCount=""267"">
  <w:LsdException Locked=""false"" Priority=""0"" SemiHidden=""false""
   UnhideWhenUsed=""false"" QFormat=""true"" Name=""Normal""/>
  <w:LsdException Locked=""false"" Priority=""9"" SemiHidden=""false""
   UnhideWhenUsed=""false"" QFormat=""true"" Name=""heading 1""/>
  <w:LsdException Locked=""false"" Priority=""9"" QFormat=""true"" Name=""heading 2""/>
  <w:LsdException Locked=""false"" Priority=""9"" QFormat=""true"" Name=""heading 3""/>
  <w:LsdException Locked=""false"" Priority=""9"" QFormat=""true"" Name=""heading 4""/>
  <w:LsdException Locked=""false"" Priority=""9"" QFormat=""true"" Name=""heading 5""/>
  <w:LsdException Locked=""false"" Priority=""9"" QFormat=""true"" Name=""heading 6""/>
  <w:LsdException Locked=""false"" Priority=""9"" QFormat=""true"" Name=""heading 7""/>
  <w:LsdException Locked=""false"" Priority=""9"" QFormat=""true"" Name=""heading 8""/>
  <w:LsdException Locked=""false"" Priority=""9"" QFormat=""true"" Name=""heading 9""/>
  <w:LsdException Locked=""false"" Priority=""39"" Name=""toc 1""/>
  <w:LsdException Locked=""false"" Priority=""39"" Name=""toc 2""/>
  <w:LsdException Locked=""false"" Priority=""39"" Name=""toc 3""/>
  <w:LsdException Locked=""false"" Priority=""39"" Name=""toc 4""/>
  <w:LsdException Locked=""false"" Priority=""39"" Name=""toc 5""/>
  <w:LsdException Locked=""false"" Priority=""39"" Name=""toc 6""/>
  <w:LsdException Locked=""false"" Priority=""39"" Name=""toc 7""/>
  <w:LsdException Locked=""false"" Priority=""39"" Name=""toc 8""/>
  <w:LsdException Locked=""false"" Priority=""39"" Name=""toc 9""/>
  <w:LsdException Locked=""false"" Priority=""35"" QFormat=""true"" Name=""caption""/>
  <w:LsdException Locked=""false"" Priority=""10"" SemiHidden=""false""
   UnhideWhenUsed=""false"" QFormat=""true"" Name=""Title""/>
  <w:LsdException Locked=""false"" Priority=""1"" Name=""Default Paragraph Font""/>
  <w:LsdException Locked=""false"" Priority=""11"" SemiHidden=""false""
   UnhideWhenUsed=""false"" QFormat=""true"" Name=""Subtitle""/>
  <w:LsdException Locked=""false"" Priority=""22"" SemiHidden=""false""
   UnhideWhenUsed=""false"" QFormat=""true"" Name=""Strong""/>
  <w:LsdException Locked=""false"" Priority=""20"" SemiHidden=""false""
   UnhideWhenUsed=""false"" QFormat=""true"" Name=""Emphasis""/>
  <w:LsdException Locked=""false"" Priority=""59"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Table Grid""/>
  <w:LsdException Locked=""false"" UnhideWhenUsed=""false"" Name=""Placeholder Text""/>
  <w:LsdException Locked=""false"" Priority=""1"" SemiHidden=""false""
   UnhideWhenUsed=""false"" QFormat=""true"" Name=""No Spacing""/>
  <w:LsdException Locked=""false"" Priority=""60"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Light Shading""/>
  <w:LsdException Locked=""false"" Priority=""61"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Light List""/>
  <w:LsdException Locked=""false"" Priority=""62"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Light Grid""/>
  <w:LsdException Locked=""false"" Priority=""63"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Medium Shading 1""/>
  <w:LsdException Locked=""false"" Priority=""64"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Medium Shading 2""/>
  <w:LsdException Locked=""false"" Priority=""65"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Medium List 1""/>
  <w:LsdException Locked=""false"" Priority=""66"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Medium List 2""/>
  <w:LsdException Locked=""false"" Priority=""67"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Medium Grid 1""/>
  <w:LsdException Locked=""false"" Priority=""68"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Medium Grid 2""/>
  <w:LsdException Locked=""false"" Priority=""69"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Medium Grid 3""/>
  <w:LsdException Locked=""false"" Priority=""70"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Dark List""/>
  <w:LsdException Locked=""false"" Priority=""71"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Colorful Shading""/>
  <w:LsdException Locked=""false"" Priority=""72"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Colorful List""/>
  <w:LsdException Locked=""false"" Priority=""73"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Colorful Grid""/>
  <w:LsdException Locked=""false"" Priority=""60"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Light Shading Accent 1""/>
  <w:LsdException Locked=""false"" Priority=""61"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Light List Accent 1""/>
  <w:LsdException Locked=""false"" Priority=""62"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Light Grid Accent 1""/>
  <w:LsdException Locked=""false"" Priority=""63"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Medium Shading 1 Accent 1""/>
  <w:LsdException Locked=""false"" Priority=""64"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Medium Shading 2 Accent 1""/>
  <w:LsdException Locked=""false"" Priority=""65"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Medium List 1 Accent 1""/>
  <w:LsdException Locked=""false"" UnhideWhenUsed=""false"" Name=""Revision""/>
  <w:LsdException Locked=""false"" Priority=""34"" SemiHidden=""false""
   UnhideWhenUsed=""false"" QFormat=""true"" Name=""List Paragraph""/>
  <w:LsdException Locked=""false"" Priority=""29"" SemiHidden=""false""
   UnhideWhenUsed=""false"" QFormat=""true"" Name=""Quote""/>
  <w:LsdException Locked=""false"" Priority=""30"" SemiHidden=""false""
   UnhideWhenUsed=""false"" QFormat=""true"" Name=""Intense Quote""/>
  <w:LsdException Locked=""false"" Priority=""66"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Medium List 2 Accent 1""/>
  <w:LsdException Locked=""false"" Priority=""67"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Medium Grid 1 Accent 1""/>
  <w:LsdException Locked=""false"" Priority=""68"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Medium Grid 2 Accent 1""/>
  <w:LsdException Locked=""false"" Priority=""69"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Medium Grid 3 Accent 1""/>
  <w:LsdException Locked=""false"" Priority=""70"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Dark List Accent 1""/>
  <w:LsdException Locked=""false"" Priority=""71"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Colorful Shading Accent 1""/>
  <w:LsdException Locked=""false"" Priority=""72"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Colorful List Accent 1""/>
  <w:LsdException Locked=""false"" Priority=""73"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Colorful Grid Accent 1""/>
  <w:LsdException Locked=""false"" Priority=""60"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Light Shading Accent 2""/>
  <w:LsdException Locked=""false"" Priority=""61"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Light List Accent 2""/>
  <w:LsdException Locked=""false"" Priority=""62"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Light Grid Accent 2""/>
  <w:LsdException Locked=""false"" Priority=""63"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Medium Shading 1 Accent 2""/>
  <w:LsdException Locked=""false"" Priority=""64"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Medium Shading 2 Accent 2""/>
  <w:LsdException Locked=""false"" Priority=""65"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Medium List 1 Accent 2""/>
  <w:LsdException Locked=""false"" Priority=""66"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Medium List 2 Accent 2""/>
  <w:LsdException Locked=""false"" Priority=""67"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Medium Grid 1 Accent 2""/>
  <w:LsdException Locked=""false"" Priority=""68"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Medium Grid 2 Accent 2""/>
  <w:LsdException Locked=""false"" Priority=""69"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Medium Grid 3 Accent 2""/>
  <w:LsdException Locked=""false"" Priority=""70"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Dark List Accent 2""/>
  <w:LsdException Locked=""false"" Priority=""71"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Colorful Shading Accent 2""/>
  <w:LsdException Locked=""false"" Priority=""72"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Colorful List Accent 2""/>
  <w:LsdException Locked=""false"" Priority=""73"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Colorful Grid Accent 2""/>
  <w:LsdException Locked=""false"" Priority=""60"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Light Shading Accent 3""/>
  <w:LsdException Locked=""false"" Priority=""61"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Light List Accent 3""/>
  <w:LsdException Locked=""false"" Priority=""62"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Light Grid Accent 3""/>
  <w:LsdException Locked=""false"" Priority=""63"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Medium Shading 1 Accent 3""/>
  <w:LsdException Locked=""false"" Priority=""64"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Medium Shading 2 Accent 3""/>
  <w:LsdException Locked=""false"" Priority=""65"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Medium List 1 Accent 3""/>
  <w:LsdException Locked=""false"" Priority=""66"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Medium List 2 Accent 3""/>
  <w:LsdException Locked=""false"" Priority=""67"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Medium Grid 1 Accent 3""/>
  <w:LsdException Locked=""false"" Priority=""68"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Medium Grid 2 Accent 3""/>
  <w:LsdException Locked=""false"" Priority=""69"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Medium Grid 3 Accent 3""/>
  <w:LsdException Locked=""false"" Priority=""70"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Dark List Accent 3""/>
  <w:LsdException Locked=""false"" Priority=""71"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Colorful Shading Accent 3""/>
  <w:LsdException Locked=""false"" Priority=""72"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Colorful List Accent 3""/>
  <w:LsdException Locked=""false"" Priority=""73"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Colorful Grid Accent 3""/>
  <w:LsdException Locked=""false"" Priority=""60"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Light Shading Accent 4""/>
  <w:LsdException Locked=""false"" Priority=""61"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Light List Accent 4""/>
  <w:LsdException Locked=""false"" Priority=""62"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Light Grid Accent 4""/>
  <w:LsdException Locked=""false"" Priority=""63"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Medium Shading 1 Accent 4""/>
  <w:LsdException Locked=""false"" Priority=""64"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Medium Shading 2 Accent 4""/>
  <w:LsdException Locked=""false"" Priority=""65"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Medium List 1 Accent 4""/>
  <w:LsdException Locked=""false"" Priority=""66"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Medium List 2 Accent 4""/>
  <w:LsdException Locked=""false"" Priority=""67"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Medium Grid 1 Accent 4""/>
  <w:LsdException Locked=""false"" Priority=""68"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Medium Grid 2 Accent 4""/>
  <w:LsdException Locked=""false"" Priority=""69"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Medium Grid 3 Accent 4""/>
  <w:LsdException Locked=""false"" Priority=""70"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Dark List Accent 4""/>
  <w:LsdException Locked=""false"" Priority=""71"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Colorful Shading Accent 4""/>
  <w:LsdException Locked=""false"" Priority=""72"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Colorful List Accent 4""/>
  <w:LsdException Locked=""false"" Priority=""73"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Colorful Grid Accent 4""/>
  <w:LsdException Locked=""false"" Priority=""60"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Light Shading Accent 5""/>
  <w:LsdException Locked=""false"" Priority=""61"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Light List Accent 5""/>
  <w:LsdException Locked=""false"" Priority=""62"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Light Grid Accent 5""/>
  <w:LsdException Locked=""false"" Priority=""63"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Medium Shading 1 Accent 5""/>
  <w:LsdException Locked=""false"" Priority=""64"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Medium Shading 2 Accent 5""/>
  <w:LsdException Locked=""false"" Priority=""65"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Medium List 1 Accent 5""/>
  <w:LsdException Locked=""false"" Priority=""66"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Medium List 2 Accent 5""/>
  <w:LsdException Locked=""false"" Priority=""67"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Medium Grid 1 Accent 5""/>
  <w:LsdException Locked=""false"" Priority=""68"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Medium Grid 2 Accent 5""/>
  <w:LsdException Locked=""false"" Priority=""69"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Medium Grid 3 Accent 5""/>
  <w:LsdException Locked=""false"" Priority=""70"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Dark List Accent 5""/>
  <w:LsdException Locked=""false"" Priority=""71"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Colorful Shading Accent 5""/>
  <w:LsdException Locked=""false"" Priority=""72"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Colorful List Accent 5""/>
  <w:LsdException Locked=""false"" Priority=""73"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Colorful Grid Accent 5""/>
  <w:LsdException Locked=""false"" Priority=""60"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Light Shading Accent 6""/>
  <w:LsdException Locked=""false"" Priority=""61"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Light List Accent 6""/>
  <w:LsdException Locked=""false"" Priority=""62"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Light Grid Accent 6""/>
  <w:LsdException Locked=""false"" Priority=""63"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Medium Shading 1 Accent 6""/>
  <w:LsdException Locked=""false"" Priority=""64"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Medium Shading 2 Accent 6""/>
  <w:LsdException Locked=""false"" Priority=""65"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Medium List 1 Accent 6""/>
  <w:LsdException Locked=""false"" Priority=""66"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Medium List 2 Accent 6""/>
  <w:LsdException Locked=""false"" Priority=""67"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Medium Grid 1 Accent 6""/>
  <w:LsdException Locked=""false"" Priority=""68"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Medium Grid 2 Accent 6""/>
  <w:LsdException Locked=""false"" Priority=""69"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Medium Grid 3 Accent 6""/>
  <w:LsdException Locked=""false"" Priority=""70"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Dark List Accent 6""/>
  <w:LsdException Locked=""false"" Priority=""71"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Colorful Shading Accent 6""/>
  <w:LsdException Locked=""false"" Priority=""72"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Colorful List Accent 6""/>
  <w:LsdException Locked=""false"" Priority=""73"" SemiHidden=""false""
   UnhideWhenUsed=""false"" Name=""Colorful Grid Accent 6""/>
  <w:LsdException Locked=""false"" Priority=""19"" SemiHidden=""false""
   UnhideWhenUsed=""false"" QFormat=""true"" Name=""Subtle Emphasis""/>
  <w:LsdException Locked=""false"" Priority=""21"" SemiHidden=""false""
   UnhideWhenUsed=""false"" QFormat=""true"" Name=""Intense Emphasis""/>
  <w:LsdException Locked=""false"" Priority=""31"" SemiHidden=""false""
   UnhideWhenUsed=""false"" QFormat=""true"" Name=""Subtle Reference""/>
  <w:LsdException Locked=""false"" Priority=""32"" SemiHidden=""false""
   UnhideWhenUsed=""false"" QFormat=""true"" Name=""Intense Reference""/>
  <w:LsdException Locked=""false"" Priority=""33"" SemiHidden=""false""
   UnhideWhenUsed=""false"" QFormat=""true"" Name=""Book Title""/>
  <w:LsdException Locked=""false"" Priority=""37"" Name=""Bibliography""/>
  <w:LsdException Locked=""false"" Priority=""39"" QFormat=""true"" Name=""TOC Heading""/>
 </w:LatentStyles>
</xml><![endif]-->
<style>
<!--
 /* Font Definitions */
 @font-face
	{font-family:""Cambria Math"";
	panose-1:2 4 5 3 5 4 6 3 2 4;
	mso-font-charset:1;
	mso-generic-font-family:roman;
	mso-font-format:other;
	mso-font-pitch:variable;
	mso-font-signature:0 0 0 0 0 0;}
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;
	mso-font-charset:0;
	mso-generic-font-family:swiss;
	mso-font-pitch:variable;
	mso-font-signature:-1610611985 1073750139 0 0 159 0;}
 /* Style Definitions */
 p.MsoNormal, li.MsoNormal, div.MsoNormal
	{mso-style-unhide:no;
	mso-style-qformat:yes;
	mso-style-parent:"""";
	margin:0in;
	margin-bottom:.0001pt;
	mso-pagination:widow-orphan;
	font-size:11.0pt;
	font-family:""Calibri"",""sans-serif"";
	mso-ascii-font-family:Calibri;
	mso-ascii-theme-font:minor-latin;
	mso-fareast-font-family:""Times New Roman"";
	mso-fareast-theme-font:minor-fareast;
	mso-hansi-font-family:Calibri;
	mso-hansi-theme-font:minor-latin;
	mso-bidi-font-family:""Times New Roman"";
	mso-bidi-theme-font:minor-bidi;}
p.MsoAutoSig, li.MsoAutoSig, div.MsoAutoSig
	{mso-style-priority:99;
	mso-style-link:""E-mail Signature Char"";
	margin:0in;
	margin-bottom:.0001pt;
	mso-pagination:widow-orphan;
	font-size:11.0pt;
	font-family:""Calibri"",""sans-serif"";
	mso-ascii-font-family:Calibri;
	mso-ascii-theme-font:minor-latin;
	mso-fareast-font-family:""Times New Roman"";
	mso-fareast-theme-font:minor-fareast;
	mso-hansi-font-family:Calibri;
	mso-hansi-theme-font:minor-latin;
	mso-bidi-font-family:""Times New Roman"";
	mso-bidi-theme-font:minor-bidi;}
span.E-mailSignatureChar
	{mso-style-name:""E-mail Signature Char"";
	mso-style-priority:99;
	mso-style-unhide:no;
	mso-style-locked:yes;
	mso-style-link:""E-mail Signature"";}
.MsoChpDefault
	{mso-style-type:export-only;
	mso-default-props:yes;
	mso-ascii-font-family:Calibri;
	mso-ascii-theme-font:minor-latin;
	mso-fareast-font-family:""Times New Roman"";
	mso-fareast-theme-font:minor-fareast;
	mso-hansi-font-family:Calibri;
	mso-hansi-theme-font:minor-latin;
	mso-bidi-font-family:""Times New Roman"";
	mso-bidi-theme-font:minor-bidi;}
@page Section1
	{size:8.5in 11.0in;
	margin:1.0in 1.0in 1.0in 1.0in;
	mso-header-margin:.5in;
	mso-footer-margin:.5in;
	mso-paper-source:0;}
div.Section1
	{page:Section1;}
-->
</style>
<!--[if gte mso 10]>
<style>
 /* Style Definitions */
 table.MsoNormalTable
	{mso-style-name:""Table Normal"";
	mso-tstyle-rowband-size:0;
	mso-tstyle-colband-size:0;
	mso-style-noshow:yes;
	mso-style-priority:99;
	mso-style-qformat:yes;
	mso-style-parent:"""";
	mso-padding-alt:0in 5.4pt 0in 5.4pt;
	mso-para-margin:0in;
	mso-para-margin-bottom:.0001pt;
	mso-pagination:widow-orphan;
	font-size:11.0pt;
	font-family:""Calibri"",""sans-serif"";
	mso-ascii-font-family:Calibri;
	mso-ascii-theme-font:minor-latin;
	mso-hansi-font-family:Calibri;
	mso-hansi-theme-font:minor-latin;}
</style>
<![endif]-->
</head>

<body lang=EN-US style='tab-interval:.5in'>

<div class=Section1>
<a href=""http://apps.healthvault.com/app4"">
<img src=""http://apps.healthvault.com/app4/images/logo_wlkmi_outlook.gif""/>
<br/>
<img src=""http://apps.healthvault.com/app4/wlkmi.ashx?type=img&user_id=#user_id#""/>
</a>
</div>
</body>
</html>";

            WlkMiTracer.Instance.Log(
                "WlkMi.ashx",
                WlkMiEvent.WidgetOutlook,
                WlkMiCat.Info,
                string.Format("Showing widget for user id: {0}",
                userId));

            html = html.Replace("#user_id#", userId.ToString());
            context.Response.Buffer = false;
            context.Response.Clear();

            context.Response.ContentType = "text/html";
            context.Response.AppendHeader("content-disposition",
                "attachment; filename=walkme.htm");

            context.Response.Write(html);
            context.Response.End();
        }


        private void SetCachePolicy(HttpContext context)
        {
            // Cache the results for WidgetCacheTimeout seconds
            context.Response.Cache.SetCacheability(HttpCacheability.Public);
            context.Response.Cache.SetExpires(DateTime.Now.AddSeconds(
                Constants.WidgetCacheTimeout));
            context.Response.Cache.VaryByParams["user_id;type"] = true;
            context.Response.Cache.SetValidUntilExpires(true);
            return;
        }

    }
}