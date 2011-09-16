<%@ Page Language="C#" MasterPageFile="~/WlkMi.master" AutoEventWireup="True" 
    Inherits="Microsoft.Health.Applications.WalkMe.Share" Title="Untitled Page" CodeFile="Share.aspx.cs" %>
<%@ Register TagPrefix="WlkMi" TagName="Share" Src="~/Controls/Sharing.ascx" %>
<%@ Register TagPrefix="WlkMi" TagName="Links" Src="~/Controls/Links.ascx" %>


<asp:Content ID="Content2" ContentPlaceHolderID="PageBody" Runat="Server">    
    <div class="pdng-page-top"></div>
    <div class="page-head">
        <div class="cnrs-top">
            <div class="cnr-left"></div>
            <div class="cnr-right"></div>
        </div>
        <div class="body">Share with friends</div>
        <div class="cnrs-bot">
            <div class="cnr-left"></div>
            <div class="cnr-right"></div>
        </div>
    </div>
    
    <div class="pdng-page-title"></div>
    <div class="body-left" style="width:620px;">
        
        <div id="Container">
               <WlkMi:Share ID="share" runat="server" />
        </div>
    </div>
    <div class="body-right">
        
      <WlkMi:Links ID="Links" runat="server" />
     
    
    </div>
    <br class="clear" />
</asp:Content>
