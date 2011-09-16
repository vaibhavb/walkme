<%@ Page Title="" Language="C#" MasterPageFile="~/WlkMi.master" AutoEventWireup="true" CodeFile="FirstTime.aspx.cs" Inherits="Microsoft.Health.Applications.WalkMe.FirstTime" %>
<%@ Register TagPrefix="WlkMi" TagName="First" Src="~/Controls/firstrun.ascx" %>
<%@ Register TagPrefix="WlkMi" TagName="Links" Src="~/Controls/HVModule.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="PageBody" Runat="Server">
    <div class="pdng-page-top"></div>

    <div class="page-head">
        <div class="cnrs-top">
            <div class="cnr-left"></div>
            <div class="cnr-right"></div>
        </div>
        <div class="body">Let's get you started</div>
        <div class="cnrs-bot">
            <div class="cnr-left"></div>
            <div class="cnr-right"></div>
        </div>
    </div>
    
    <div class="pdng-page-title"></div>
    <div class="body-left" style="width:620px;">
     <WlkMi:First ID="First" runat="server" />
     </div>
     <div class="body-right">
    
     <table><tr><td valign="top" style="padding-left:20px;">
            <div class="h6 fr-title" style="font-size:16px;">Getting started is simple:</div>
            <ol style="font-size:14px;line-height:18px;margin:8px 0px 20px 25px;padding:0px;">
                <li>Get a pedometer. Any pedometer will do, but you can streamline step entry by getting one that’s <a href="device.aspx">HealthVault-compatible</a>.</li>
                <li>Track your steps for a week. Don’t change your routine, just get a baseline.</li>
                <li>Set some goals. Chart your progress. And keep on walking!.</li>
                
            </ol>
        </td></tr></table>
     </div>
    <br class="clear" />
</asp:Content>

