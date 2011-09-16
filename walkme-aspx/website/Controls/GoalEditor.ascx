<%@ Control Language="C#" AutoEventWireup="True" Inherits="Microsoft.Health.Applications.WalkMe.Controls_GoalEditor" CodeFile="GoalEditor.ascx.cs" %>
   <div id="hvmdl_popup" class="hvmdl-popup" >
                    <img class="pntr" id="hvmdl_pntr" src="images/popup_hvmdl_arrw.gif" />
                    <div class="shdw">
                        <div class="frm">
                            <div class="cntnt" id="popup_cntnt">
                               
                            </div>
                        </div>
                    </div>
                </div>
    <div class="page-box">
        <div class="cnrs-top">
            <div class="cnr-left"></div>
            <div class="cnr-right"></div>
        </div>
        <div class="body">
               
               <div class="xpadding">
            <div class="h1">Stay on track with fitness goals</div>
            <div class="form-description">
                It’s more fun to walk when you’ve got something to shoot for. Update your goals as your fitness improves. 
            </div> 
            
           <div style="margin-top:0px;margin-bottom:30px;">Note: Daily goals will be converted to weekly figures to make charting your progress easier. </div>
           
           <table cellpadding="0" cellspacing="0" class="tbl-form" style="position:relative;">
              
                <tr>
                    <td class="form-label">
                        Steps<br />
                        
                         <asp:CustomValidator HighlightTarget="tr" ValidationGroup="firsttime" runat="server" ID="CustomValidator4" AllowNull="false" ValidationExpression="^\d*$" ClientValidationFunction="valRegexForm" ValidateEmptyText="true" ControlToValidate="Steps">
                            <div type="null" class="error-tbl">Steps cannot be empty</div> 
                            <div type="regex" class="error-tbl">Invalid Steps</div>    
                        </asp:CustomValidator>
                        
                    </td>
                    <td>
                        <asp:TextBox onfocus="showPopup(this,event,'Enter how many steps you would like to take today')" ID="Steps" runat="server"></asp:TextBox><br />
                       
                        
                    </td>
                    
                </tr>
                <tr>
                    <td class="form-label">Distance in Miles<br />
                        
                         <asp:CustomValidator HighlightTarget="tr" ValidationGroup="firsttime" runat="server" ID="CustomValidator5" AllowNull="true" ValidationExpression="^\d*\.?\d*$" ClientValidationFunction="valRegexForm" ValidateEmptyText="true" ControlToValidate="Distance">
                            <div type="null" class="error-tbl">Steps cannot be empty</div> 
                            <div type="regex" class="error-tbl">Invalid Steps</div>    
                        </asp:CustomValidator>
                     
                    
                    </td>
                    <td>
                        <asp:TextBox onfocus="showPopup(this,event,'Enter miles you would like to walk')" ID="Distance" runat="server"></asp:TextBox><br />
                       
                    </td>
                    
                </tr>
                <tr>
                    <td class="form-label">Calories<br />
                    
                      <asp:CustomValidator HighlightTarget="tr" ValidationGroup="firsttime" runat="server" ID="CustomValidator1" AllowNull="true" ValidationExpression="^\d*\.?\d*$" ClientValidationFunction="valRegexForm" ValidateEmptyText="true" ControlToValidate="Calories">
                            <div type="null" class="error-tbl">Steps cannot be empty</div> 
                            <div type="regex" class="error-tbl">Invalid Steps</div>    
                        </asp:CustomValidator>
                        
                  
                    
                    </td>
                    <td>
                        <asp:TextBox onfocus="showPopup(this,event,'Enter calorie goal')" ID="Calories" runat="server" MaxLength="12"></asp:TextBox><br />
                        
                        
                    </td>
                </tr>
                <tr>
                    <td class="form-label">Aerobic Steps<br />
                    
                    <script language="javascript" type="text/javascript">
                        var arrAerobicStepsHelp= new Array();
                        arrAerobicStepsHelp.push("<b>What are aerobic steps?</b><br>");
                        arrAerobicStepsHelp.push("Aerobic steps occur when you meet two conditions:");
                        arrAerobicStepsHelp.push("<ol><li>Walk more than 60 steps per minute</li>");
                        arrAerobicStepsHelp.push("<li>Walk for more than 10 minutes continuously</li></ol>");

                    </script>
                     
                     
                      <asp:CustomValidator HighlightTarget="tr" ValidationGroup="firsttime" runat="server" ID="CustomValidator2" AllowNull="true" ValidationExpression="^\d*$" ClientValidationFunction="valRegexForm" ValidateEmptyText="true" ControlToValidate="AerobicSteps">
                            <div type="null" class="error-tbl">Steps cannot be empty</div> 
                            <div type="regex" class="error-tbl">Invalid Steps</div>    
                        </asp:CustomValidator>
                        
                        
                    </td>
                    <td>
                        <asp:TextBox onfocus="showPopup(this,event,arrAerobicStepsHelp.join(''))" ID="AerobicSteps" runat="server"></asp:TextBox><br />
                        
                       
                    
                    </td>
                </tr>
               <tr>
                <td colspan="2">
                    <div class="buttons-frame" style="padding-right:35px;">
                        <asp:Label CssClass="h4 save" runat="server" ID="lbl_saved" Visible="false">Your updates were saved.</asp:Label>
                
                            <asp:ImageButton runat="server" ID="Button1" ImageUrl="~/images/btn_save.gif" onclick="DoSubmit" ValidationGroup="firsttime"/>
            
    
                         </div>
                </td>
               </tr>
            </table>
            
           
            
        </div>
        </div>
        
       

        <div class="cnrs-bot">
            <div class="cnr-left"></div>
            <div class="cnr-right"></div>
        </div>
        
    </div>


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

    delayHide('<%=lbl_saved.ClientID %>');
</script>