<%@ Control Language="C#" AutoEventWireup="True" Inherits="Microsoft.Health.Applications.WalkMe.Controls_UserProfile" CodeFile="UserProfile.ascx.cs" %>
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
            <div class="h1">Please complete your profile information</div>
            <div class="form-description">
                This information will be used to help calculate your progress, and will let you compare yourself to others in your age range, location, and BMI range.
            </div>
            
            
            <table cellpadding="0" cellspacing="0" class="tbl-form">
              
                <tr>
                    <td class="form-label">
                        Screen name
                       <asp:CustomValidator HighlightTarget="tr" ValidationGroup="firsttime" Display="Dynamic" runat="server" ID="CustomValidator6" ClientValidationFunction="valRequiredForm" ValidateEmptyText="true" ControlToValidate="NickName">
                            <div type="null" class="error-tbl-nohide">Screen name cannot be empty</div>    
                        </asp:CustomValidator>
                        
                        
                    </td>
                    <td><asp:TextBox onfocus="showPopup(this,event,'Enter a nickname')" ID="NickName" runat="server"></asp:TextBox></td>
                    
                </tr>
                <tr>
                    <td class="form-label">Birth year<br />
                         <asp:CustomValidator HighlightTarget="tr" ValidationGroup="firsttime" runat="server" ID="CustomValidator1" AllowNull="false" ValidationExpression="19[0-9]{2}|[2][0-0][0-0][0-9]" ClientValidationFunction="valRegexForm" ValidateEmptyText="true" ControlToValidate="Birthyear">
                            <div type="null" class="error-tbl">Birth Year connot be empty</div> 
                            <div type="regex" class="error-tbl">Invalid Birth Year</div>    
                        </asp:CustomValidator>
                    
                    </td>
                    <td><asp:TextBox onfocus="showPopup(this,event,'Enter your birth year (YYYY) This allows you to compare your steps with people who are in your age group')" ID="Birthyear" runat="server" MaxLength="12"></asp:TextBox></td>
                  
                </tr>
                <tr>
                    <td class="form-label">
                    Zip code<br />
                      <asp:CustomValidator HighlightTarget="tr" ValidationGroup="firsttime" runat="server" ID="CustomValidator2" AllowNull="false" ValidationExpression="^[0-9]{5}([- /]?[0-9]{4})?$" ClientValidationFunction="valRegexForm" ValidateEmptyText="true" ControlToValidate="Zip">
                            <div type="null" class="error-tbl">Zip connot be empty</div> 
                            <div type="regex" class="error-tbl">Invalid Zip</div>    
                        </asp:CustomValidator>
                    
                    </td>
                    <td><asp:TextBox onfocus="showPopup(this,event,'Enter your zip code')" ID="Zip" runat="server" MaxLength="12"></asp:TextBox></td>
               
                </tr>
                <tr>
                    <td class="form-label">Stride length (inches) <br />
                     <asp:CustomValidator HighlightTarget="tr" ValidationGroup="firsttime" runat="server" ID="CustomValidator3" AllowNull="false" ValidationExpression="^\d*$" ClientValidationFunction="valRegexForm" ValidateEmptyText="true" ControlToValidate="Stride">
                            <div type="null" class="error-tbl">Stride connot be empty</div> 
                            <div type="regex" class="error-tbl">Invalid Stride</div>    
                        </asp:CustomValidator>
                    </td>
                    <td>
                    <script language="javascript" type="text/javascript">
                        var strStrideHelp = new Array();
                        strStrideHelp.push("<b>How do I find my stride length?</b><br/>");
                        strStrideHelp.push("To determine your stride length, walk 10 steps at your normal pace, marking your start and end points. Measure the distance from start to end, then divide the total distance by 10.");
                        
                    </script>
                    <asp:TextBox onfocus="showPopup(this,event,strStrideHelp.join(''))" ID="Stride" runat="server" MaxLength="12"></asp:TextBox></td>
                </tr>
                 <tr>
                    <td class="form-label">Height
                    <br /></td>
                    <td>
                        <asp:DropDownList runat="server" ID="height_feet"/> feet
                        <asp:DropDownList runat="server" ID="height_inches"/> inches.
                    </td>   
                </tr>
                <tr>
                    <td class="form-label">Weight (lbs)
                    <br />
                        <asp:CustomValidator HighlightTarget="tr" ValidationGroup="firsttime" runat="server" ID="CustomValidator4" AllowNull="false" ValidationExpression="^\d*$" ClientValidationFunction="valRegexForm" ValidateEmptyText="true" ControlToValidate="Weight">
                            <div type="null" class="error-tbl">Weight connot be empty</div> 
                            <div type="regex" class="error-tbl">Invalid Weight</div>    
                        </asp:CustomValidator>
                    
                    </td>
                    <td><asp:TextBox onfocus="showPopup(this,event,'Enter how much you weigh, this value is used to calculate your BMI and to approximate your calories burned by walking')" ID="Weight" runat="server"></asp:TextBox></td>
                    
                </tr>
                <tr>
                    <td colspan="2">
                      <div class="buttons-frame" style="padding-right:20px;">
                        <asp:Label CssClass="h4 save" runat="server" ID="lbl_saved" Visible="false">Your updates were saved.</asp:Label>
            
            
                        <asp:ImageButton AlternateText="Save Profile" ID="ImageButton1" runat="server" ValidationGroup="firsttime" ImageUrl="~/images/btn_save.gif" OnClick="DoSubmit"/>
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