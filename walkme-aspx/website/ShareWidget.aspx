<%@ Page Title="" Language="C#" MasterPageFile="~/WlkMi.master" AutoEventWireup="true" CodeFile="ShareWidget.aspx.cs" Inherits="Microsoft.Health.Applications.WalkMe.ShareWidget" %>
<%@ Register TagPrefix="WlkMi" TagName="Links" Src="~/Controls/Links.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="PageBody" Runat="Server">
    <div class="pdng-page-top"></div>
    <div class="page-head">
        <div class="cnrs-top">
            <div class="cnr-left"></div>
            <div class="cnr-right"></div>
        </div>
        <div class="body">Share Widget with friends</div>
        <div class="cnrs-bot">
            <div class="cnr-left"></div>
            <div class="cnr-right"></div>
        </div>
    </div>
    
    <div class="pdng-page-title"></div>
    <div class="body-left" style="width:620px;">     
        <div id="Container" style="margin-top:20px">      
<table>
<tr>
<td>
        <script type="text/javascript" src="http://widgets.clearspring.com/o/4981173cc6b18b5b/498208b07c58e31b/4981173cc6b18b5b/581cbc7/-cpid/5fa183a96fb1df0c/-DBL/0/user_id/<%= UserId %>/widget.js"></script>
       </td>
<td>
        <script type="text/javascript" src="http://cdn.clearspring.com/launchpad/v2/standalone.js"></script>        
        <script type="text/javascript">
		if (typeof $Launchpad != 'undefined')
		{
			$Launchpad.ShowMenu({ "wid":"4981173cc6b18b5b", config: {"user_id" : "<%= UserId %>"} });
		}
 	</script>
 </td>	
 	</tr>
    </table>  
        </div>
    </div>
    
    <div class="body-right">    
      <WlkMi:Links ID="Links" runat="server" />
    </div>
    <br class="clear" />
    
</asp:Content>

