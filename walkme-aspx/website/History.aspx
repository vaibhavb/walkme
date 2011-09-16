<%@ Page Title="" Language="C#" MasterPageFile="~/WlkMi.master" AutoEventWireup="true"
    CodeFile="History.aspx.cs" Inherits="Microsoft.Health.Applications.WalkMe.History" %>
<%@ Register TagPrefix="WlkMi" TagName="Links" Src="~/Controls/Links.ascx" %>

<%@ Register TagPrefix="WlkMi" TagName="ShowFlash" Src="~/Controls/RockyCharts.ascx" %>
<asp:Content ID="Content2" ContentPlaceHolderID="PageBody" runat="Server">
   <div class="pdng-page-top"></div>
   
    <div class="page-head">
        <div class="cnrs-top">
            <div class="cnr-left">
            </div>
            <div class="cnr-right">
            </div>
        </div>
        <div class="body">
            Chart your progress</div>
        <div class="cnrs-bot">
            <div class="cnr-left">
            </div>
            <div class="cnr-right">
            </div>
        </div>
    </div>
    
    <div class="pdng-page-title"></div>
    <div class="body-left" style="width:620px;">
    <div class="page-box">
        <div class="cnrs-top">
            <div class="cnr-left">
            </div>
            <div class="cnr-right">
            </div>
        </div>
        <div class="body">
            <div class="chart-nav-frame">
                <asp:HyperLink CssClass="chart-lnk" runat="server" ID="lnk_steps" Text="Steps" NavigateUrl="history.aspx?type=Steps"></asp:HyperLink>
                <asp:HyperLink CssClass="chart-lnk" runat="server" ID="lnk_aerobic" Text="Aerobic Steps"
                    NavigateUrl="history.aspx?type=AerobicSteps"></asp:HyperLink>
                <asp:HyperLink CssClass="chart-lnk" runat="server" ID="lnk_distance" Text="Distance"
                    NavigateUrl="history.aspx?type=Distance"></asp:HyperLink>
                <asp:HyperLink CssClass="chart-lnk" runat="server" ID="lnk_calories" Text="Calories"
                    NavigateUrl="history.aspx?type=Calories"></asp:HyperLink>
                <br class="clear" />
            </div>
            <br class="clear" />

            <div class="chart-nav-frame">
                <asp:HyperLink CssClass="chart-lnk" runat="server" ID="lnk_weeklyTrend" Text="Weekly Trend" 
                    NavigateUrl="history.aspx?type=Steps&duration=WeekTrend"></asp:HyperLink>
                <asp:HyperLink CssClass="chart-lnk" runat="server" ID="lnk_weekly" Text="Weekly" 
                    NavigateUrl="history.aspx?type=Steps&duration=Week"></asp:HyperLink>
                <asp:HyperLink CssClass="chart-lnk" runat="server" ID="lnk_monthly" Text="Monthly"
                    NavigateUrl="history.aspx?type=Steps&duration=Month"></asp:HyperLink>
                <asp:HyperLink CssClass="chart-lnk" runat="server" ID="lnk_yearly" Text="Yearly"
                    NavigateUrl="history.aspx?type=Steps&duration=Year"></asp:HyperLink>
                <br class="clear" />
            </div>
          <br class="clear" />


            <WlkMi:ShowFlash ID="ShowFlash" runat="server" />
            <br class="clear" />
        </div>
        <div class="cnrs-bot">
            <div class="cnr-left">
            </div>
            <div class="cnr-right">
            </div>
        </div>
    </div>
    
    </div>
    
    <div class="body-right">
    <WlkMi:Links ID="Links" runat="server" />
    </div>
    <br class="clear" />
</asp:Content>
