<%@ Page Language="C#" MasterPageFile="~/WlkMi.master" AutoEventWireup="True" Inherits="Microsoft.Health.Applications.WalkMe.Device" Title="Untitled Page" CodeFile="Device.aspx.cs" %>
<%@ Register TagPrefix="WlkMi" TagName="Links" Src="~/Controls/HVModule.ascx" %>

<asp:Content ID="Content2" ContentPlaceHolderID="PageBody" Runat="Server">
    
     <div class="pdng-page-top"></div>
    
    <div class="page-head">
        <div class="cnrs-top">
            <div class="cnr-left"></div>
            <div class="cnr-right"></div>
        </div>
        <div class="body">Using Pedometers with WalkMe</div>
        <div class="cnrs-bot">
            <div class="cnr-left"></div>
            <div class="cnr-right"></div>
        </div>
    </div>
    
    <div class="pdng-page-title"></div>
    <div class="body-left" style="width:620px;">
    
    
    <div class="page-box">
        <div class="cnrs-top">
            <div class="cnr-left"></div>
            <div class="cnr-right"></div>
        </div>
        <div class="body">
            <div class="xpadding">
            <div class="h1">Make tracking steps easy with a HealthVault-compatible device</div>
            <div class="form-description">
                Using a HealthVault-compatible pedometer with WalkMe makes adding your steps simple. Just connect it to your computer and let HealthVault Connection Center download your steps and send them to WalkMe. 
            </div>
  
       
                
                <div style="font-size:12px;font-weight:bold;margin-top:20px;">Compatible devices</div>
                <table cellpadding="10" style="margin-top:15px;">
                    <tr>
                        <td valign="top"><img src="images/pedometer.png" /></td>
                        <td valign="top" style="line-height:16px;">
                            
                            <div style="margin-bottom:5px;font-size:16px;">Omron 720 ITC pedometer</div>
                                Track days, weeks, months and years of exercise with the Omron 720 ITC pedometer. It measures steps, aerobic steps (10 minutes or more of continuous movement), calories and distance. 
                            <div style="margin-top:10px;">
                            
                            <img src="images/icn_lnkArrow.gif" style="vertical-align:middle;margin-right:3px;" />
                            <a target="_blank" href="http://www.amazon.com/gp/product/B000MN92WM?ie=UTF8&tag=00000796-20&linkCode=as2&camp=1789&creative=9325&creativeASIN=B000MN92WM">Learn More</a><img src="https://www.assoc-amazon.com/e/ir?t=00000796-20&l=as2&o=1&a=B000MN92WM" width="1" height="1" border="0" alt="" style="border:none !important; margin:0px !important;" /></div>
                            
                        </td>
                    </tr>
                </table>
    
            <div  style="margin-top:40px;border-top:1px solid #eaeaea;padding:5px;line-height:16px;">If your pedometer is NOT HealthVault-compatible, you can still use WalkMe—just enter your steps manually on the <a href="hvdefault.aspx">home page</a>.</div>
           </div>
            
        </div>
       

        <div class="cnrs-bot">
            <div class="cnr-left"></div>
            <div class="cnr-right"></div>
        </div>
        
    </div>
    
    
    
    </div>
    <div class="body-right" style="width:300px;line-height:16px;">
       
            <div style="position:relative;z-index:99"><WlkMi:Links ID="Links" runat="server" /></div>
<div class="pdg-rightbar"></div>
       
       <div class="page-box width-rightbar">
       <div class="cnrs-top-brn">
        <div class="cnr-left"></div>
        <div class="cnr-right"></div>
    </div>
        <div class="sec-header"><span class="h6">Next steps</span></div>
        
         
            <div class="body">
              <div class="h6" style="">Get HealthVault Connection Center</div>
                HealthVault Connection Center lets you use your computer to upload pedometer data to your HealthVault record, so that it can be used by WalkMe. 
                <div style="margin-top:8px;">
                <img src="images/icn_lnkArrow.gif" style="vertical-align:middle;margin-right:3px;" />
                <a href="http://www.healthvault.com/Personal/connection-center.html?rmproc=true" target="_blank">Get Connection Center</a></div>
                <div class="h6" style="margin-top:20px;">Set up your pedometer</div>
                Once you’ve installed Connection Center, this setup guide will walk you through using your pedometer with WalkMe for the first time.
                <div style="margin-top:8px;">
                <img src="images/icn_lnkArrow.gif" style="vertical-align:middle;margin-right:3px;" /><a href="Device_Setup_CC.aspx">View setup guide</a>
                </div>
     
            </div>
            <div class="cnrs-bot">
                <div class="cnr-left"></div>
                <div class="cnr-right"></div>
            </div>
        </div>
        <div class="pdg-rightbar"></div>
        
        
       
        
    </div>
    
    <br class="clear" />
    
    
    
  
    
   
</asp:Content>
