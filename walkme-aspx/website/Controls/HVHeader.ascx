<%@ Control Language="C#" AutoEventWireup="True" Inherits="Microsoft.Health.Applications.WalkMe.Controls_HVHeader" CodeFile="HVHeader.ascx.cs" %>

<div class="header">
    <asp:HyperLink runat="server" ID="lnk_logo"><img class="logo" src="images/logo_wlkmi.gif" alt="WalkMe - Walk with your friends"  /></asp:HyperLink>
    <div class="login">
        <asp:PlaceHolder runat="server" ID="plh_signedIn" Visible="false">
            <div class="btn-wrapper-signout" onclick="targetURL('SignOut.aspx')" onmouseover="changeCssClass(this,'btn-wrapper-signout-hvr');" onmouseout="changeCssClass(this,'btn-wrapper-signout');" onmousedown="changeCssClass(this,'btn-wrapper-signout-clk')" onmouseup="changeCssClass(this,'btn-wrapper-signout-hvr')">Sign out</div>
            <div class="btn-spacer">|</div>
            <div class="user-info">
                    <div class="welcome">Welcome <%= UserName %> | &nbsp;&nbsp;<a id="A1" href="~/pickrecord.aspx" runat="server">Change</a>&nbsp;&nbsp; </div>
                    <div class="totalSteps"><%= TotalSteps %> total steps taken!</div>
            </div>
            
        </asp:PlaceHolder>
        <asp:PlaceHolder runat="server" ID="plh_signedOut" Visible="false">
            <div class="btn-wrapper-signin" onclick="targetURL('hvdefault.aspx')" onmouseover="changeCssClass(this,'btn-wrapper-signin-hvr');" onmouseout="changeCssClass(this,'btn-wrapper-signin');" onmousedown="changeCssClass(this,'btn-wrapper-signin-clk')" onmouseup="changeCssClass(this,'btn-wrapper-signin-hvr')">Sign in</div>
        </asp:PlaceHolder>
    </div>
    <div class="info">
        <img src="images/logo_hvlabs.gif" width="233" height="21" class="logo-labs" alt="Sand Box for Microsoft HealthVault" />
    </div>
</div>

<asp:PlaceHolder runat="server" ID="plh_navigation" Visible="false">        
    <div class="nav">
        <div class="nav-body">
                <div class="nav-item-strt" runat="server" ID="div_home" onclick="targetURL('hvdefault.aspx')" title="Wlkmi Home"  onmouseover="doStrtNavMousover(this);" onmouseout="doStrtNavMousout(this);">
                    <div class="nav-spacer-l"></div>
                    <div class="nav-link"><div class="nav-home">&nbsp;</div></div>
                    <div class="nav-spacer-r"></div>
                </div>
                <div class="nav-item" runat="server" ID="div_charts" onclick="targetURL('history.aspx')" onmouseover="doNavMousover(this);" onmouseout="doNavMousout(this);">
                    <div class="nav-spacer-l"></div>
                    <div class="nav-link">View Charts</div>
                    <div class="nav-spacer-r"></div>
                </div>
                <div class="nav-item" runat="server" ID="div_groups" onclick="targetURL('groups.aspx')" onmouseover="doNavMousover(this);" onmouseout="doNavMousout(this);">
                    <div class="nav-spacer-l"></div>
                    <div class="nav-link">Groups</div>
                    <div class="nav-spacer-r"></div>
                </div>
                
                <div class="nav-item" runat="server" ID="div_goals" onclick="targetURL('goals.aspx')" onmouseover="doNavMousover(this);" onmouseout="doNavMousout(this);">
                    <div class="nav-spacer-l"></div>
                    <div class="nav-link">Set Goals</div>
                    <div class="nav-spacer-r"></div>
                </div>
                <div class="nav-item" runat="server" ID="div_share" onclick="targetURL('share.aspx')" onmouseover="doNavMousover(this);" onmouseout="doNavMousout(this);">
                    <div class="nav-spacer-l"></div>
                    <div class="nav-link">Share</div>
                    <div class="nav-spacer-r"></div>
                </div>
                
                
                <div style="position:absolute;right:0px;width:204px;">
                    <div class="nav-item">
                        <div class="nav-spacer-r"></div>
                    </div>
                    <div class="nav-item" runat="server" ID="div_devices" onclick="targetURL('device.aspx')" onmouseover="doNavMousover(this);" onmouseout="doNavMousout(this);">
                        <div class="nav-spacer-l"></div>
                        <div class="nav-link">Pedometers</div>
                        <div class="nav-spacer-r"></div>
                    </div>
                    <div class="nav-item-end" runat="server" ID="div_profile" onclick="targetURL('profile.aspx')" onmouseover="doEndNavMousover(this);" onmouseout="doEndNavMousout(this);">
                        <div class="nav-spacer-l"></div>
                        <div class="nav-link">Profile</div>
                        <div class="nav-spacer-r"></div>
                    </div>
                </div>
        </div>
        
    </div>
</asp:PlaceHolder>