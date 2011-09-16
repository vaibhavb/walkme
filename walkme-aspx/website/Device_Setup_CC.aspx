<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/WlkMi.master" CodeFile="Device_Setup_CC.aspx.cs" 
    Inherits="Microsoft.Health.Applications.WalkMe.Device_Setup_CC" %>
<%@ Register TagPrefix="WlkMi" TagName="Links" Src="~/Controls/HVModule.ascx" %>

<asp:Content ID="Content2" ContentPlaceHolderID="PageBody" Runat="Server">

<div class="pdng-page-top"></div>
   <div style="margin-bottom:10px;padding-left:10px;">
   <a href="Device.aspx"><< Pedometers</a></div>
    <div class="body-left" style="width:620px;line-height:16px;">
    
    
    
     <div class="page-box">
        <div class="cnrs-top">
            <div class="cnr-left"></div>
            <div class="cnr-right"></div>
        </div>
        <div class="body">
        <div class="xpadding">
        <div class="h1">Setup guide</div>
        <div class="form-description">
            Ready to use your pedometer? If you’ve already downloaded <a target="_blank" href="http://www.healthvault.com/Personal/connection-center.html?rmproc=true">HealthVault Connection Center</a>, just follow these steps to upload your data. 
        </div>   
            
           
    
    
    <table cellpadding="20">
        <tr>
            <td valign="top"><span class="step">Step</span><span class="number">1</span></td>
            <td>
                <div class="h6" style="margin-bottom:5px;">Connect your pedometer</div>
                <div class="setup-steps-description">Use the USB cable that came with your pedometer to connect it to your computer.</div>
                
            </td>
        </tr>
    </table>
                  
    <table cellpadding="20">
        <tr>
            <td valign="top"> <span class="step">Step</span><span class="number">2</span></td>
            <td>
                <div class="h6" style="margin-bottom:5px;">Make sure Connection Center is running</div>
                <div class="setup-steps-description">You should see the HealthVault icon in the taskbar at the bottom right of your screen. Double-click it to open Connection Center.</div>
                <img src="images/ss_toobar.gif" style="margin:15px 0px 15px 0px;"/>
                <div class="setup-steps-description">If you don’t see this icon, click the Start button at the bottom left of your screen, then click <b>Microsoft HealthVault Connection Center</b> in the program list.  </div>
                                    
            </td>
        </tr>
    </table>
                  
    <table cellpadding="20">
        <tr>
            <td valign="top"><span class="step">Step</span><span class="number">3</span></td>
            <td>
                <div class="h6" style="margin-bottom:5px;">Set up your pedometer to work with Connection Center</div>
                <div class="setup-steps-description">Click <b>Set up a new device</b> in the upper left of the Connection Center screen and follow the on-screen instructions.</div>
                <img src="images/ss_setupdevice.gif" style="margin:15px 0px 0px 0px;"/>
                               
            </td>
        </tr>
    </table>
                  
    <table cellpadding="20">
        <tr>
            <td valign="top"> <span class="step">Step</span><span class="number">4</span></td>
            <td>
                <div class="h6" style="margin-bottom:5px;">Upload your data</div>
                <div class="setup-steps-description">Click <b>Upload now</b> to begin uploading pedometer data to WalkMe.</div>
                <img src="images/ss_upload.gif" style="margin:15px 0px 0px 0px;"/>                     
            </td>
        </tr>
    </table>
                  
    <table cellpadding="20">
        <tr>
            <td valign="top"><span class="step">Step</span><span class="number">5</span></td>
            <td>
                <div class="h6" style="margin-bottom:5px;">View your data</div>
                <div class="setup-steps-description">Congratulations! You can now view your data on WalkMe. </div>
                <a href="hvdefault.aspx">View your data</a>
            </td>
        </tr>
    </table>
         
        </div>
        
        <div class="cnrs-bot">
            <div class="cnr-left"></div>
            <div class="cnr-right"></div>
        </div>
        </div>
    </div>
    
    
   </div>
   <div class="body-right">
     <div style="position:relative;z-index:99"><WlkMi:Links ID="Links" runat="server" /></div>
      
      
      
      <div class="pdg-rightbar"></div>
      
   
        <div class="page-box width-rightbar" style="position:relative;z-index:0">
       <div class="cnrs-top-brn">
        <div class="cnr-left"></div>
        <div class="cnr-right"></div>
    </div>
        <div class="sec-header"><span class="h6">Getting Connection Center</span></div>
        
         
            <div class="body" style="line-height:16px;">
                HealthVault Connection Center lets you use your computer to upload pedometer data to your HealthVault record, so that it can be used by WalkMe. 
                <div style="margin-top:8px;">
                <img src="images/icn_lnkArrow.gif" style="vertical-align:middle;margin-right:3px;" />
                <a href="http://www.healthvault.com/Personal/connection-center.html?rmproc=true" target="_blank">Get Connection Center</a></div>
               
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
