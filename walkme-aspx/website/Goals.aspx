<%@ Page Language="C#" MasterPageFile="~/WlkMi.master" AutoEventWireup="True" Inherits="Microsoft.Health.Applications.WalkMe.Goals" Title="Untitled Page" CodeFile="Goals.aspx.cs" %>
<%@ Register TagPrefix="WlkMi" TagName="Goal" Src="~/Controls/GoalEditor.ascx" %>
<%@ Register TagPrefix="WlkMi" TagName="HVModule" Src="~/Controls/HVModule.ascx" %>

<asp:Content ID="Content2" ContentPlaceHolderID="PageBody" Runat="Server">
     <div class="pdng-page-top"></div>
    <div class="page-head">
        <div class="cnrs-top">
            <div class="cnr-left"></div>
            <div class="cnr-right"></div>
        </div>
        <div class="body">Set your daily goals</div>
        <div class="cnrs-bot">
            <div class="cnr-left"></div>
            <div class="cnr-right"></div>
        </div>
    </div>
   <div class="pdng-page-title"></div>
    <div class="body-left" style="width:620px;">
    
    <WlkMi:Goal ID="Goal" runat="server" />
    
   </div>
   
   
    <div class="body-right">
      
         <WlkMi:HVModule ID="HVModule" runat="server" />
        
    </div>
    <br class="clear" />
</asp:Content>

