<%@ Page Language="C#" MasterPageFile="~/WlkMi.master" AutoEventWireup="True" Inherits="Microsoft.Health.Applications.WalkMe.Groups"
    Title="Untitled Page" CodeFile="Groups.aspx.cs" %>
<asp:Content ID="Content2" ContentPlaceHolderID="PageBody" runat="Server">
    <div class="pdng-page-top">
    </div>
    <div class="page-head">
        <div class="cnrs-top">
            <div class="cnr-left">
            </div>
            <div class="cnr-right">
            </div>
        </div>
        <div class="body">
            WalkMe Groups</div>
        <div class="cnrs-bot">
            <div class="cnr-left">
            </div>
            <div class="cnr-right">
            </div>
        </div>
    </div>
    <asp:PlaceHolder runat="server" ID="ph_toolbar" Visible="true">
        <div style="padding:20px 10px 20px 10px;">
            
            <img style="vertical-align:middle;margin-right:5px;" src="images/group_add.jpg" /><asp:HyperLink CssClass="toolbarlnk" runat="server" ID="lnk_create" Text="Create a Group" NavigateUrl="group_create.aspx"></asp:HyperLink>&nbsp;&nbsp;|&nbsp;&nbsp;
            <img style="vertical-align:middle;margin-right:5px;" src="images/search_groups.jpg" /><asp:HyperLink CssClass="toolbarlnk" runat="server" ID="lnk_search" Text="Search for a Group" NavigateUrl="group_search.aspx"></asp:HyperLink>
            <asp:PlaceHolder ID="ph_group_actions" runat="server" Visible="false">
                &nbsp;&nbsp;|&nbsp;&nbsp;<img style="margin-right:3px;vertical-align:middle;" src="images/invite.gif" /><asp:HyperLink CssClass="toolbarlnk" runat="server" ID="lnk_invite" Text="Invite more people"></asp:HyperLink> &nbsp;&nbsp;|&nbsp;&nbsp; <img style="margin-right:3px;vertical-align:middle;" src="images/leave.gif" /><asp:Label CssClass="toolbarlnk" ID="ActionText" Text="" runat="server" />
            </asp:PlaceHolder>
            
            <br class="clear" />
        </div>
    </asp:PlaceHolder>
    
        
       
            
             
                <asp:PlaceHolder runat="server" ID="ShowGeneral" Visible="false">
                    <div class="body-left" >
                        <div class="page-box" style="width: 600px;">
                            <div class="cnrs-top">
                                <div class="cnr-left"></div>
                                <div class="cnr-right"></div>
                            </div>
                            <div class="body">
                    
                                <div style="margin-bottom:15px;">
                                    Groups are a great way to stay motivated and to share your progress with others.  Joining a group enables you to see how much your friends walk compared to you.  Once you join a group, your friends will be able to see your nickname and your total steps.

                                </div>
                                <div class="h6" style="margin-bottom:8px;">Top 5 Groups</div>
                                <asp:DataGrid BorderStyle="None"  AlternatingItemStyle-CssClass="tbl-alt" HeaderStyle-CssClass="tbl-hdrs" GridLines="None" AutoGenerateColumns="false" CssClass="tbl_groups" runat="server" ID="Top5Groups">
                                    <Columns>
                                        <asp:TemplateColumn>
                                            <ItemStyle Width="200" />
                                            <HeaderTemplate>Group Name</HeaderTemplate>
                                            <ItemTemplate><img style="vertical-align:middle;margin-right:5px;" src="images/group.jpg" /><%# Convert.ToString(DataBinder.Eval(Container.DataItem, "group_name"))%></ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn>
                                            <HeaderTemplate>Description</HeaderTemplate>
                                            <ItemTemplate><%# Convert.ToString(DataBinder.Eval(Container.DataItem, "group_description"))%></ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn>
                                            <ItemStyle HorizontalAlign="Right" />
                                            <HeaderTemplate>Users</HeaderTemplate>
                                            <ItemTemplate><%# Convert.ToString(DataBinder.Eval(Container.DataItem, "userCount"))%></ItemTemplate>
                                        </asp:TemplateColumn>
                                        
                                    </Columns>
                                </asp:DataGrid>
                    
                                <div class="h6" style="margin-bottom:8px;margin-top:30px;">My Groups</div>
                                <asp:DataGrid AlternatingItemStyle-CssClass="tbl-alt" BorderStyle="None" HeaderStyle-CssClass="tbl-hdrs" AutoGenerateColumns="false" GridLines="None" CssClass="tbl_groups" runat="server" ID="MyGroups">
                                <Columns>
                                        <asp:TemplateColumn>
                                            <ItemStyle Width="200" />
                                            <HeaderTemplate>Group Name</HeaderTemplate>
                                            <ItemTemplate><img style="vertical-align:middle;margin-right:5px;" src="images/group.jpg" /><%# Convert.ToString(DataBinder.Eval(Container.DataItem, "my_groups"))%></ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn>
                                            <HeaderTemplate>Description</HeaderTemplate>
                                            <ItemTemplate><%# Convert.ToString(DataBinder.Eval(Container.DataItem, "group_description"))%></ItemTemplate>
                                        </asp:TemplateColumn>
                                </Columns>
                                </asp:DataGrid>

                        </div>
                        <div class="cnrs-bot">
                            <div class="cnr-left"></div>
                            <div class="cnr-right"></div>
                        </div>
                    </div>
                </div>
                </asp:PlaceHolder>
                 
                
                <asp:PlaceHolder runat="server" ID="ShowMyGroupDetails" Visible="false">
                    <div class="body-left" >
                        <div class="page-box" style="width:100%" >
                            <div class="cnrs-top">
                                <div class="cnr-left"></div>
                                <div class="cnr-right"></div>
                            </div>
                            <div class="body">
                    
                                <div style="padding:0px 5px 8px 5px;border-bottom:1px dotted #ccc;margin-bottom:10px;"><a href="groups.aspx"><< Back to list</a></div>
                                <table style="width:100%;margin-bottom:10px;">
                                    <tr>
                                        <td><img style="margin-right:8px;" src="images/group.gif" /></td>
                                        <td  style="width:100%"  valign="top">
                                            <div style="margin-bottom:5px;"><asp:Label CssClass="h1" runat="server" ID="lbl_groupName"></asp:Label></div>
                                            <div style="margin-bottom:15px;"><asp:Label runat="server" ID="lbl_groupDesc"></asp:Label></div>
                                        </td>
                                      
                                    </tr>
                                </table>
                                <div class="totalSteps" style="margin-bottom:20px;"> You are ranked <asp:Label ID="GroupRank" Text="" runat="server" /> out of <asp:Label ID="GroupNumPeople" Text="" runat="server" /> people in this group</div>
                                
                                <asp:DataGrid CssClass="tbl_groups" AlternatingItemStyle-CssClass="tbl-alt" BorderStyle="None" GridLines="None" AutoGenerateColumns="false" HeaderStyle-CssClass="tbl-hdrs" runat="server" ID="GroupUserList">
                                    <Columns>
                                            <asp:TemplateColumn>
                                                <HeaderTemplate>Nickname</HeaderTemplate>
                                                <ItemTemplate><%# Convert.ToString(DataBinder.Eval(Container.DataItem, "nickname"))%></ItemTemplate>
                                            </asp:TemplateColumn>
                                            <asp:TemplateColumn>
                                                <HeaderTemplate>Weekly Steps</HeaderTemplate>
                                                <ItemTemplate><%# Convert.ToString(DataBinder.Eval(Container.DataItem, "weekly_steps"))%></ItemTemplate>
                                            </asp:TemplateColumn>
                                            <asp:TemplateColumn>
                                                <HeaderTemplate>Monthly Steps</HeaderTemplate>
                                                <ItemTemplate><%# Convert.ToString(DataBinder.Eval(Container.DataItem, "monthly_steps"))%></ItemTemplate>
                                            </asp:TemplateColumn>
                                            <asp:TemplateColumn>
                                                <HeaderTemplate>Annual Steps</HeaderTemplate>
                                                <ItemTemplate><%# Convert.ToString(DataBinder.Eval(Container.DataItem, "annual_steps"))%></ItemTemplate>
                                            </asp:TemplateColumn>
                                            <asp:TemplateColumn>
                                                <HeaderTemplate>Total Steps</HeaderTemplate>
                                                <ItemTemplate><%# Convert.ToString(DataBinder.Eval(Container.DataItem, "total_steps"))%></ItemTemplate>
                                            </asp:TemplateColumn>
                                            
                                    </Columns>
                                </asp:DataGrid>
                                <br /><br />
                            </div>
                            <div class="cnrs-bot">
                                <div class="cnr-left"></div>
                                <div class="cnr-right"></div>
                            </div>
                        </div>
                    </div>
                    <div class="body-right">
                        <div class="page-box width-rightbar">
                            <div class="cnrs-top-brn">
                                <div class="cnr-left"></div>
                                <div class="cnr-right"></div>
                            </div>
                            <div class="sec-header"><span class="h6">Group Info</span></div>
                            <div class="body">
                                            <table style="width:100%" cellpadding="4">
                                                <tr>
                                                    <td>Number of Users: </td>
                                                    <td align="right"><asp:Label ID="GroupNumUsers" Text="" runat="server" /></td>
                                                </tr>
                                                <tr>
                                                    <td>Group Weekly Steps:</td>
                                                    <td align="right"><asp:Label ID="GroupWeeklySteps" Text="" runat="server" /></td>
                                                </tr>
                                                <tr>
                                                    <td>Group Monthly Steps:</td>
                                                    <td align="right"><asp:Label ID="GroupMonthlySteps" Text="" runat="server" /></td>
                                                </tr>
                                                <tr>
                                                    <td>Group Annual Steps:</td>
                                                    <td align="right"><asp:Label ID="GroupAnnualSteps" Text="" runat="server" /></td>
                                                </tr>
                                                <tr>
                                                    <td>Group Total Steps: </td>
                                                    <td align="right"><asp:Label ID="GroupTotalSteps" Text="" runat="server" /></td>
                                                </tr>
                                              
                                            </table>
                                          
                                    
                            </div>
                            <div class="cnrs-bot">
                                <div class="cnr-left"></div>
                                <div class="cnr-right"></div>
                            </div>
                        </div>
                     </div>
                </asp:PlaceHolder>
               
               
               <asp:PlaceHolder runat="server" ID="ShowMyGroupInvite" Visible="false">
                  <br />
                  <div class="body-left" >
                        <div class="page-box" style="width:100%" >
                            <div class="cnrs-top">
                                <div class="cnr-left"></div>
                                <div class="cnr-right"></div>
                            </div>
                            <div class="body">
                    
                                <div style="margin-top:8px;margin-bottom:15px;font-weight:bold;">Copy the following and send an email to your friends.</div>
                                
                                <div style="padding:10px;margin-bottom:20px;border:1px dashed #ccc;">
                                To join my WalkMe group:
                                <ol>
                                    <li>Go to <asp:HyperLink runat="server" ID="lnk_search_url"/></li>
                                </ol>
                               
                              <p>
                                With WalkMe, you can:. Get a clear picture of how active you are—no guessing ... Note: To use WalkMe, you’ll need to have a Microsoft HealthVault account. ...
                              </p>
                            </div>
                            <asp:ImageButton AlternateText="Done" ID="ImageButton2" runat="server" ValidationGroup="goals" ImageUrl="~/images/btn_done.gif" OnClick="DoFinish"/>
                      </div>
                      <div class="cnrs-bot">
                        <div class="cnr-left"></div>
                        <div class="cnr-right"></div>
                     </div>
                    </div>
             </div>
               
               </asp:PlaceHolder>
    
    <br class="clear" />
</asp:Content>
