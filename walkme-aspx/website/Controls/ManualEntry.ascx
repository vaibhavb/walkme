<%@ Control Language="C#" AutoEventWireup="True" Inherits="Microsoft.Health.Applications.WalkMe.Controls_ManualEntry" CodeFile="ManualEntry.ascx.cs" %>
        
<table cellpadding="5" cellspacing="0" border="0" class="tbl_addsteps" >
    <tr>
        <td nowrap="nowrap" valign="top">
           Date:&nbsp;&nbsp;
            <asp:DropDownList runat="server" ID="dd_mm"/>
            <asp:DropDownList runat="server" ID="dd_dd"/>
            <asp:DropDownList runat="server" ID="dd_yy"/>
        </td>
        <td nowrap="nowrap" valign="top">
            Walked:&nbsp;&nbsp;
            <asp:TextBox ID="TextBox_Steps" runat="server" Width="60" MaxLength="12"></asp:TextBox>
            <asp:DropDownList runat="server" ID="dd_measure">
                <asp:ListItem Selected="True">Steps</asp:ListItem>
                <asp:ListItem>Miles</asp:ListItem>
            </asp:DropDownList>
            
            <asp:CustomValidator ValidationGroup="steps" HighlightTarget="td" runat="server" ID="CustomValidator2"  AllowNull="false" ValidationExpression="^\d*\.?\d*$" ClientValidationFunction="valRegexForm" ValidateEmptyText="true" ControlToValidate="TextBox_Steps">
                <div type="null" class="error-tbl">Walked cannot be empty</div> 
                <div type="regex" class="error-tbl">Invalid number</div>    
            </asp:CustomValidator>
            
             <div runat="server" id="tr_saved" visible="false" class="confirm-save">
            <asp:Label runat="server" ID="lbl_saved">##### steps added.</asp:Label>
        </div>
            
            
        </td>
        <td nowrap="nowrap" valign="top" style="padding-left:20px;">
            <asp:ImageButton runat="server" AlternateText="Add Steps" ImageUrl="~/images/btn_addsteps.gif" ID="Button_StoreSteps" OnClick="Button_StoreSteps_Click" ValidationGroup="steps" />
        </td>
    </tr>
    
</table>

    
<script language="javascript" type="text/javascript">
    var g_delayTimer = null;
    function delayHide(objId)
    {
        if (document.getElementById(objId))
            g_delayTimer = setTimeout(function(){hideObj(document.getElementById(objId))},3000);
    }
    function hideObj(obj)
    {
        obj.style.display = "none";
        clearTimeout(g_delayTimer);
    }

    delayHide('<%=tr_saved.ClientID %>');
</script>
        
  