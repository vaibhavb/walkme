<%@ Page Language="C#" MasterPageFile="~/WlkMi.master" AutoEventWireup="True" Inherits="Microsoft.Health.Applications.WalkMe.GroupCreate" Title="Untitled Page" CodeFile="GroupCreate.aspx.cs" %>
<%@ Register TagPrefix="WlkMi" TagName="HVModule" Src="~/Controls/HVModule.ascx" %>
<asp:Content ID="Content2" ContentPlaceHolderID="PageBody" Runat="Server">
    <div id="hvmdl_popup" class="hvmdl-popup" >
                    <img class="pntr" id="Img1" src="images/popup_hvmdl_arrw.gif" />
                    <div class="shdw">
                        <div class="frm">
                            <div class="cntnt" id="popup_cntnt">
                               
                            </div>
                        </div>
                    </div>
                </div>

    <div class="pdng-page-top"></div>
    
    <div class="page-head">
        <div class="cnrs-top">
            <div class="cnr-left"></div>
            <div class="cnr-right"></div>
        </div>
        <div class="body">Create a WalkMe Group</div>
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
            <asp:Panel runat="server" ID="pnl_forms" Visible="true">
            <div class="h3">Please take a minute to fill in your new group information</div>
            <div class="form-description">
                Your group name will enable you to uniquely identify your group as well as allow others to find your group and join.   
            </div>
            
            
             <asp:Label CssClass="h4" runat="server" ID="lbl_saved" Visible="false">Your Group was created.</asp:Label>
            <asp:Label CssClass="h4" runat="server" ID="lbl_sync" Visible="false">Your Group was created.</asp:Label>   
            
            <table cellpadding="0" cellspacing="0" class="tbl-form">
                <tr>
                    <td class="form-label">
                        Group Name
                        <asp:RegularExpressionValidator Display="Dynamic" CssClass="form-error" runat="server" ID="rgxVal_GroupName" ControlToValidate="GroupName" ValidationExpression="[a-zA-Z0-9_\s]+" EnableClientScript="true" ErrorMessage="" ValidationGroup="groups">
                            Enter a valid name
                            <asp:CustomValidator runat="server" ID="valCstm_GroupName" ClientValidationFunction="validateForm" EnableClientScript="true" ControlToValidate="GroupName"></asp:CustomValidator>
                        </asp:RegularExpressionValidator> 
                    </td>
                    <td><asp:TextBox onfocus="showPopup(this,event,'Enter a group name')" ID="GroupName" runat="server"></asp:TextBox></td>
                    
                </tr>
                <tr>
                    <td class="form-label">Group Description<br />
                        <asp:RegularExpressionValidator Display="Dynamic" CssClass="form-error" runat="server" ID="rgxVal_GroupDesc" ControlToValidate="GroupDesc" ValidationExpression="[a-zA-Z0-9_\s]+" EnableClientScript="true" ValidationGroup="groups">
                            Enter the groups description
                            <asp:CustomValidator runat="server" ID="valCstm_GroupDesc" ClientValidationFunction="validateForm" EnableClientScript="true" ControlToValidate="GroupDesc"></asp:CustomValidator>
                        </asp:RegularExpressionValidator> 
                    
                    </td>
                    <td><asp:TextBox onfocus="showPopup(this,event,'Enter the description for this group')" ID="Groupdesc" runat="server" MaxLength="100"></asp:TextBox></td>
                </tr>
            </table>
            <div class="form-buttons">
                <asp:ImageButton AlternateText="Save Group" ID="ImageButton1" runat="server" ValidationGroup="goals" ImageUrl="~/images/btn_save.gif" OnClick="DoSubmit"/>
            </div>
            
            
            </asp:Panel>
            
            <asp:Panel runat="server" ID="pnl_results" Visible="false">
                
                <div class="h3" style="margin-bottom:15px;">You have successfully created a new group!</div>
                
                <table cellpadding="5">
                    <tr>
                        <td>Group:</td>
                        <td><asp:Label runat="server" ID="lbl_groupName" Text="Group name"></asp:Label></td>
                    </tr>
                    <tr>
                        <td>Description:</td>
                        <td><asp:Label runat="server" ID="lbl_groupDescription" Text="Group description goes here"></asp:Label></td>
                    </tr>
                    <tr>
                        <td></td>
                        <td></td>
                    </tr>
                </table>
                
                <div style="margin-top:15px;margin-bottom:8px;font-weight:bold;">Copy the following and send an email to your friends.</div>
                
                <div style="padding:10px;margin-bottom:20px;border:1px dotted #ccc;">
                To join my WalkMe group:
                <ol>
                    <li>Go to http://apps.healthvault.com/app4/groups.aspx?join=<asp:Label runat="server" ID="lbl_groupName2" Text="Group name"></asp:Label></li>
                </ol>
               
              <p>
                With WalkMe, you can:. Get a clear picture of how active you are—no guessing ... Note: To use WalkMe, you’ll need to have a Microsoft HealthVault account. ...
              </p>
                </div>
                
              

                
                
                
                <asp:ImageButton AlternateText="Done" ID="ImageButton2" runat="server" ValidationGroup="goals" ImageUrl="~/images/btn_done.gif" OnClick="DoFinish"/>
                
               
            
            </asp:Panel>
            
            
        </div>
        
       

        <div class="cnrs-bot">
            <div class="cnr-left"></div>
            <div class="cnr-right"></div>
        </div>
        
    </div>
    
    </div>
    <div class="body-right">
      
         <WlkMi:HVModule ID="HVModule" runat="server" />
        
    </div>
    <br class="clear" />
    <br class="clear" />    
</asp:Content>

