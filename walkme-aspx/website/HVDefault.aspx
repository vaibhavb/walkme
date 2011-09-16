<%@ Page Language="C#" MasterPageFile="~/WlkMi.master" AutoEventWireup="True" Inherits="Microsoft.Health.Applications.WalkMe.HVDefault" Title="Untitled Page" CodeFile="HVDefault.aspx.cs" %>
<%@ Register TagPrefix="WlkMi" TagName="ShowFlash" Src="~/Controls/RockyCharts.ascx" %>
<%@ Register TagPrefix="WlkMi" TagName="ProgressBoard" Src="~/Controls/ProgressBoard.ascx" %>
<%@ Register TagPrefix="WlkMi" TagName="Links" Src="~/Controls/Links.ascx" %>
<%@ Register TagPrefix="WlkMi" TagName="Rank" Src="~/Controls/RankControl.ascx" %>
<%@ Register TagPrefix="WlkMi" TagName="ManualEntry" Src="~/Controls/ManualEntry.ascx" %>


<asp:Content ID="Content2" ContentPlaceHolderID="PageBody" Runat="Server">
    <div class="pdng-page-top"></div>
   
   
    <div class="page-head">
        <div class="cnrs-top">
            <div class="cnr-left"></div>
            <div class="cnr-right"></div>
        </div>
        <div class="body">Your WalkMe home</div>
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
                
                
                
               <div class="chart-cntnt">
                <asp:Panel runat="server" CssClass="" ID="pnl_firstHit" Visible="false">
                    Good job! You’ve completed your profile information. 
                </asp:Panel>
                
                <asp:Label id="WeeklyStep" CssClass="h1 dash-title" Text="0" runat="server"/> 
               </div>
               <div style="position:relative;top:-10px;margin-bottom:12px;">
                <WlkMi:ShowFlash ID="ShowFlashWeekly" runat="server" />
               </div>
               <WlkMi:ManualEntry ID="Addsteps" runat="server" />            
               
            </div>
            <div class="cnrs-bot">
                <div class="cnr-left"></div>
                <div class="cnr-right"></div>
            </div>
        </div>
             
    
    </div>
    <div class="body-right">
        
        <WlkMi:Links ID="Links" runat="server" />
        <div class="pdg-rightbar"></div>
        <div class="pdg-rightbar"></div>
        <WlkMi:ProgressBoard ID="ProgressBoard" runat="server" />
        
        <div class="pdg-rightbar"></div>
       
        
    </div>
    <br class="clear" />    
    <div class="pdg-rightbar"></div>
    <WlkMi:Rank ID="Links1" runat="server" />
    <br class="clear" />    
</asp:Content>

