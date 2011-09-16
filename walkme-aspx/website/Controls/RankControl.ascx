<%@ Control Language="C#" AutoEventWireup="true" CodeFile="RankControl.ascx.cs" Inherits="Microsoft.Health.Applications.WalkMe.Controls_RankControl" %>
<div class="page-box community width-rightbar" style="margin-right:10px">
    <div class="cnrs-top-brn">
        <div class="cnr-left"></div>
        <div class="cnr-right"></div>
    </div>
    <div class="sec-header"><span class="h6">Location Group</span></div>
    <div class="body">
       <div class="com-subtitle"><asp:Label id="NumLocation" Text="1" runat="server"/>  <asp:Label runat="server" ID="lbl_location_people"></asp:Label></div>
       
       <asp:PlaceHolder runat="server" ID="plh_location_data" Visible="true">
           <table>
                <tr>
                    <td class="com-rank">
                        <asp:Label id="LocationRank" Text="1" runat="server"/>
                    </td>
                    <td class="com-text">
                        <div>Around the area of <a href="profile.aspx"><asp:Label runat="server" ID="lbl_location"></asp:Label></a></div>
       
                        <asp:Label id="StepsBehindLoc" Text="0" runat="server"/> steps behind the next person.
                    </td>
                </tr>
           </table>
           
           
       </asp:PlaceHolder>
       <asp:PlaceHolder runat="server" ID="plh_location_NoData" Visible="false">
        <div class="no-data">
            Start walking to see where you rank within your area
        </div>
       </asp:PlaceHolder>
        
       
    </div>
    <div class="cnrs-bot">
        <div class="cnr-left"></div>
        <div class="cnr-right"></div>
    </div>
</div>


<div class="page-box community width-rightbar" style="margin-right:10px">
    <div class="cnrs-top-brn">
        <div class="cnr-left"></div>
        <div class="cnr-right"></div>
    </div>
    <div class="sec-header"><span class="h6">Age Group</span></div>
       
    <div class="body">
       
       <div class="com-subtitle"><asp:Label id="NumAge" Text="1" runat="server"/>  <asp:Label runat="server" ID="lbl_age_people"></asp:Label></div>
       
       
       <asp:PlaceHolder runat="server" ID="plh_age_data" Visible="true">
           <table>
            <tr>
                <td class="com-rank">
                    <asp:Label id="AgeRank" Text="1" runat="server"/>
                </td>
                <td class="com-text">
                    <div>Age range: <a href="profile.aspx"><asp:Label runat="server" ID="lbl_age"></asp:Label> yrs old</a></div>
                    <asp:Label id="StepsBehindAge" Text="1" runat="server"/> steps behind the next person.
                </td>
            </tr>
           </table>
           
       </asp:PlaceHolder>
       <asp:PlaceHolder runat="server" ID="plh_age_noData" Visible="false">
            <div class="no-data">
             Start walking to see where you rank within your age group
            </div>
       </asp:PlaceHolder>

    </div>
    <div class="cnrs-bot">
        <div class="cnr-left"></div>
        <div class="cnr-right"></div>
    </div>
</div>



<div class="page-box community width-rightbar">
    <div class="cnrs-top-brn">
        <div class="cnr-left"></div>
        <div class="cnr-right"></div>
    </div>
    <div class="sec-header"><span class="h6">BMI Group</span></div>
    <div class="body">
       
       
       <div class="com-subtitle"><asp:Label id="NumBMI" Text="1" runat="server"/> <asp:Label runat="server" ID="lbl_bmi_people"></asp:Label></div>
       
       <asp:PlaceHolder runat="server" ID="plh_bmi_data" Visible="true">
           <table>
            <tr>
                <td class="com-rank">
                   <asp:Label id="BMIRank" Text="1" runat="server"/>
                </td>
                <td class="com-text">
                    <div>BMI range: <a href="profile.aspx"><asp:Label runat="server" ID="lbl_bmi"></asp:Label></a></div>
                    <asp:Label id="StepsBehindBMI" Text="1" runat="server"/> steps behind the next person.
                </td>
            </tr>
           </table>
        </asp:PlaceHolder>
       <asp:PlaceHolder runat="server" ID="plh_bmi_noData" Visible="false">
         <div class="no-data">
            Start walking to see where you rank within your BMI
         </div>
       </asp:PlaceHolder>
      
    </div>
    <div class="cnrs-bot">
        <div class="cnr-left"></div>
        <div class="cnr-right"></div>
    </div>
</div>
        
