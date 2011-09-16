<%@ Page Language="C#" MasterPageFile="~/WlkMi.master" AutoEventWireup="True" Inherits="Microsoft.Health.Applications.WalkMe.MemberProfile" Title="Untitled Page" CodeFile="Profile.aspx.cs" %>
<%@ Register TagPrefix="WlkMi" TagName="UserProfile" Src="~/Controls/UserProfile.ascx" %>
<%@ Register TagPrefix="WlkMi" TagName="Links" Src="~/Controls/HVModule.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="PageBody" Runat="Server">
   <div class="pdng-page-top"></div>
    <div class="page-head">
        <div class="cnrs-top">
            <div class="cnr-left"></div>
            <div class="cnr-right"></div>
        </div>
        <div class="body">WalkMe Profile</div>
        <div class="cnrs-bot">
            <div class="cnr-left"></div>
            <div class="cnr-right"></div>
        </div>
    </div>
    <div class="pdng-page-title"></div>
    <div class="body-left" style="width:620px;">
       
        <WlkMi:UserProfile ID="UserProfile" runat="server" />
    </div>

    <div class="body-right" style="">
       
       <div style="position:relative;z-index:99"><WlkMi:Links ID="Links" runat="server" /></div>
      
      
      
      <div class="pdg-rightbar"></div>
      
      
    <div class="page-box width-rightbar" style="position:relative;z-index:0">
       <div class="cnrs-top-brn">
        <div class="cnr-left"></div>
        <div class="cnr-right"></div>
    </div>
        <div class="sec-header"><span class="h6">Getting started is simple</span></div>
        
         
            <div class="body" style="line-height:16px;">
               <ol style="padding:0px;margin:0px 0px 0px 25px;">
                    <li style="margin-bottom:8px;"><a href="device.aspx">Get a pedometer</a>. Any pedometer will do, but you can streamline step entry by getting one that’s HealthVault-compatible. </li>
                    <li style="margin-bottom:8px;">Track your steps for a week. Don’t change your routine, just get a baseline.</li>
                    <li>Set some goals. Chart your progress. And keep on walking!</li>
               </ol>
            </div>
            <div class="cnrs-bot">
                <div class="cnr-left"></div>
                <div class="cnr-right"></div>
            </div>
        </div>
        <div class="pdg-rightbar"></div>
       
         <div class="bar-box">
            <div class="cnrs-top">
                <div class="cnr-left"></div>
                <div class="cnr-right"></div>
            </div>
            <div class="body" style="line-height:16px;">
               Don’t see your latest information? Copy your most recent data from HealthVault now.<br />
              <asp:Label runat="server" ID="ph_sync" Visible="false">
                    <div class="confirm-save">
                     Your information has been synced with HealthVault.
                     </div>
                </asp:Label>
               <div style="margin-top:8px;margin-bottom:10px;"><img src="images/icn_lnkArrow.gif" style="vertical-align:middle;margin-right:3px;" /><a href="javascript:confirmation('Profile.aspx?cr=true&dr=true&sync=true','Are you sure you want to resync with HealthVault. Some data could be lost in this process.');">Resync with HealthVault</a></div>
                
            </div>
            <div class="cnrs-bot">
                <div class="cnr-left"></div>
                <div class="cnr-right"></div>
            </div>
        </div>
      

    </div>
    
    <br class="clear" />
    
    <script language="javascript" type="text/javascript">
    var g_delayTimer1 = null;
    function delayHide1(objId)
    {
        if (document.getElementById(objId))
            g_delayTimer1 = setTimeout(function(){hideObj1(document.getElementById(objId))},3000);
    }
    function hideObj1(obj)
    {
        obj.style.display = "none";
        clearTimeout(g_delayTimer1);
    }

    delayHide('<%=ph_sync.ClientID %>');
</script>
</asp:Content>

