<%@ Page Language="C#" MasterPageFile="~/WlkMi.master" AutoEventWireup="True" Inherits="Microsoft.Health.Applications.WalkMe.GroupsSearch" Title="Untitled Page" CodeFile="GroupSearch.aspx.cs" %>

<asp:Content ID="Content2" ContentPlaceHolderID="PageBody" Runat="Server">
    <div id="hvmdl_popup" class="hvmdl-popup" >
                    <img class="pntr" id="hvmdl_pntr" src="images/popup_hvmdl_arrw.gif" />
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
        <div class="body">Find a WalkMe group</div>
        <div class="cnrs-bot">
            <div class="cnr-left"></div>
            <div class="cnr-right"></div>
        </div>
    </div>
   
   <div class="pdng-page-title"></div>
    
    <div class="body-left" style="width:600px;">
        
        <div class="page-box">
        <div class="cnrs-top">
            <div class="cnr-left"></div>
            <div class="cnr-right"></div>
        </div>
        <div class="body">
            
            <div style="padding:0px 5px 8px 5px;border-bottom:1px dotted #ccc;margin-bottom:10px;"><a href="groups.aspx"><< Back to list</a></div>
            <div class="h3" style="margin-top:9px;margin-bottom:15px;">Group Search</div>
            <table cellpadding="0" cellspacing="0" class="tbl-form">
                
                <tr>
                    <td class="form-label" nowrap="nowrap">
                        Group Name
                        <asp:RegularExpressionValidator Display="Dynamic" CssClass="form-error" runat="server" ID="rgxVal_GroupSearch" ControlToValidate="GroupSearch" ValidationExpression="[a-zA-Z0-9_\s]+" EnableClientScript="true" ErrorMessage="" ValidationGroup="groups">
                            Enter a valid name
                            <asp:CustomValidator runat="server" ID="valCstm_GroupSearch" ClientValidationFunction="validateForm" EnableClientScript="true" ControlToValidate="GroupSearch"></asp:CustomValidator>
                        </asp:RegularExpressionValidator> 
                    </td>
                    <td><asp:TextBox onfocus="showPopup(this,event,'Enter a group search')" ID="GroupSearch" runat="server"></asp:TextBox>
                    
                    <asp:ImageButton AlternateText="Save Group" ID="ImageButton1" runat="server" ValidationGroup="goals" ImageUrl="~/images/btn_search.jpg" OnClick="DoSubmit"/>
                    </td>
                    
                </tr>
            </table>
            
            <asp:datagrid CssClass="tbl_groups" AlternatingItemStyle-CssClass="tbl-alt" BorderStyle="None" AutoGenerateColumns="false"  GridLines="None" runat="server" id="Results" >
              <Columns>
                                        
                                            <asp:TemplateColumn>
                                                <HeaderTemplate>Group Name</HeaderTemplate>
                                                <ItemTemplate><%# Convert.ToString(DataBinder.Eval(Container.DataItem, "my_groups"))%></ItemTemplate>
                                            </asp:TemplateColumn>
                                            <asp:TemplateColumn>
                                                <HeaderTemplate>Description</HeaderTemplate>
                                                <ItemTemplate><%# Convert.ToString(DataBinder.Eval(Container.DataItem, "group_description"))%></ItemTemplate>
                                            </asp:TemplateColumn>
                                            
                                         
                                            
                                    </Columns>
            
            </asp:datagrid>  
                
        </div>
        
       

        <div class="cnrs-bot">
            <div class="cnr-left"></div>
            <div class="cnr-right"></div>
        </div>
        
    </div>
    
    </div>
    
    <br class="clear" />    
</asp:Content>

