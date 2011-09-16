<%@ Page Language="C#" MasterPageFile="~/WlkMi.master" AutoEventWireup="True"
    Inherits="Microsoft.Health.Applications.WalkMe.WlkMiAdmin" Title="WlkMi Admin Console" CodeFile="WlkMiAdmin.aspx.cs" %>

<asp:Content ID="Content2" ContentPlaceHolderID="PageBody" runat="Server">
    <br class="clear" />
    <div class="page-head">
        <div class="cnrs-top">
            <div class="cnr-left">
            </div>
            <div class="cnr-right">
            </div>
        </div>
        <div class="body">
            WlkMi Admin Console</div>
        <div class="cnrs-bot">
            <div class="cnr-left">
            </div>
            <div class="cnr-right">
            </div>
        </div>
    </div>
    <br class="clear" />
    <br class="clear" />
    <div class="body-left">
        <table>
            <tr>
                <td>
                    <div class="tab-cnrs-top" style="width: 150px;">
                        <div class="cnr-left">
                        </div>
                        <div class="cnr-right">
                        </div>
                        <div class="body">
                            <b>Statistics</b></div>
                    </div>
                    <div class="bar-box">
                        <div class="cnrs-top">
                            <div class="cnr-right">
                            </div>
                        </div>
                        <div class="body">
                            Number of WlkMi Users:
                            <asp:Label ID="NumUsers" Text="0" runat="server" /><br />
                            Number of WlkMi Goals:<asp:Label ID="numGoals" Text="0" runat="server" /><br />
                            Number of Log entries:<asp:Label ID="numLog" Text="0" runat="server" /><br />
                            Total Widget Impressions : <asp:Label ID="numWidgetImpressions" Text="0" runat="server"></asp:Label>
                        </div>
                        <div class="cnrs-bot">
                            <div class="cnr-left">
                            </div>
                            <div class="cnr-right">
                            </div>
                        </div>
                    </div>
                </td>
                <td>
                    <div class="tab-cnrs-top" style="width: 150px;">
                        <div class="cnr-left">
                        </div>
                        <div class="cnr-right">
                        </div>
                        <div class="body">
                            <b>Admin Tasks</b></div>
                    </div>
                    <div class="bar-box">
                        <div class="cnrs-top">
                            <div class="cnr-right">
                            </div>
                        </div>
                        <div class="body">
                            <a href="ProcessWlkMi.ashx">Process an offline sync with HV</a>
                            <asp:Button ID="Button1" runat="server" Text="Start Syncing" 
                                onclick="Button1_Click" />
                        </div>
                        <div class="cnrs-bot">
                            <div class="cnr-left">
                            </div>
                            <div class="cnr-right">
                            </div>
                        </div>
                    </div>
                </td>
            </tr>
        </table>

        <asp:ObjectDataSource ID="AuditLogDAL" runat="server" 
            SelectMethod="GetLogsWithSearch" 
            TypeName="Microsoft.WlkMi.AuditLogModelSql">
            <SelectParameters>
                <asp:ControlParameter 
                    Name="WlkMiSearchString"
                    ControlID="TextBoxSearch" 
                    PropertyName="Text" />
                <asp:ControlParameter
                    Name="WlkMiCategory"
                    ControlID="LogCategories"
                    PropertyName="SelectedValue"
                    />
                <asp:ControlParameter
                    Name="WlkMiEventVar"
                    ControlID="LogEvents"
                    PropertyName="SelectedValue"
                    />
            </SelectParameters>
        </asp:ObjectDataSource>
        <h3>Logs Section</h3>
        <asp:DropDownList ID="LogEvents" 
            EnableViewState="true"
            runat="server"></asp:DropDownList>
        <asp:DropDownList ID="LogCategories" 
            EnableViewState="true"
            runat="server"></asp:DropDownList>

        <asp:TextBox ID="TextBoxSearch" runat="server" Text=""></asp:TextBox>

        <asp:Button ID="SearchButton" runat="server" Text="Search" 
            onclick="SearchButton_Click" />
        <asp:Button ID="CatEvntSearch" runat="server" Text="EventCat" 
            onclick="CatEvntButton_Click" /> 
         <asp:Button ID="ClearButton" runat="server" Text="Clear" 
            onclick="ClearButton_Click" />
        <asp:GridView ID="GridViewAuditLogs" DataSourceID="AuditLogDAL"
            AllowPaging="True" BorderWidth="1px" AllowSorting="True" runat="server">
        </asp:GridView>
        
        <h3>Worker Processes Section</h3>
        
        
        <br />
        Today is
        <asp:Label ID="CurrentTime" Text="CurrentTime" runat="server" />
    </div>
</asp:Content>
