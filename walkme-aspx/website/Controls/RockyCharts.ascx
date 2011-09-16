<%@ Control Language="C#" AutoEventWireup="True" Inherits="Microsoft.Health.Applications.WalkMe.Controls_RockyCharts" CodeFile="RockyCharts.ascx.cs" %>

<asp:PlaceHolder ID="PlaceHolder1" runat="server" Visible="true">
    <div style="padding-right:15px;position:relative;">
        <table style="position:absolute;right:20px;top:0px;">
            <tr>
                <td style="width:15px;height:15px;background:#febf40;font-size:1px"></td>
                <td>Steps</td>
                <td style="width:15px;height:15px;background:#f2f2f2;font-size:1px"></td>
                <td>Goal</td>
            </tr>
        </table>
    </div>
    <div style="height:20px;"></div>

</asp:PlaceHolder>

<asp:PlaceHolder ID="NoData" runat="server" Visible="false">

<div class="xpadding">
<table style="margin-top:20px;margin-bottom:10px;">
    <tr>
        <td valign="top">
            <img src="images/img_nodata_home.gif" />        
        </td>
        <td valign="top" style="padding-left:20px;">
            <div class="h6 fr-title" style="font-size:16px;">What’s next?</div>
            <ol style="font-size:14px;line-height:18px;margin:8px 0px 20px 25px;padding:0px;">
                <li><a href="device.aspx">Get a pedometer</a>.</li>
                <li>Start walking.</li>
                <li>Come back every day to upload your data and check your progress.</li>
                
            </ol>
            
            <div>As you begin adding your steps to WalkMe, you’ll see the progress you’ve made toward your goals. </div>
        </td>
    </tr>
</table>
</div>

<div style="line-height:16px;">
    <div class="h6">How do I add steps?</div>
    If your pedometer is HealthVault-compatible, just connect it to your computer and let HealthVault Connection Center download your steps and send them to WalkMe.
    <a href="device_setup_cc.aspx">Learn how</a>
<p>
    If your pedometer is NOT HealthVault-compatible, you can manually enter your steps below. (Want to make it easier? <a href="device.aspx">Find a compatible pedometer</a>.) 
</p>
</div>
</asp:PlaceHolder>




