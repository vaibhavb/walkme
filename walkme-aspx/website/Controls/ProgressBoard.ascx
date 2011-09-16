<%@ Control Language="C#" AutoEventWireup="True" Inherits="Microsoft.Health.Applications.WalkMe.Controls_ProgressBoard" CodeFile="ProgressBoard.ascx.cs" %>

    <div class="page-box width-rightbar">
       <div class="cnrs-top-brn">
        <div class="cnr-left"></div>
        <div class="cnr-right"></div>
    </div>
        <div class="sec-header"><span class="h6">Progress Board</span></div>
            <div class="body">
                
              
                 <div class="bar-subhead">Against goals</div>
                 <table cellpadding="0" cellspacing="0" class="tbl-progress" >
                	<tr>
                	    <td nowrap="nowrap">Steps:</td>
                	    <td align="right" style="width:100%"><span class="progressBar" id="element0"><%= stepsPercent%></span></td>
                    </tr>
					<tr>
					    <td nowrap="nowrap">Distance:</td>
					    <td align="right"><span class="progressBar" id="element3"><%= distancePercent %></span></td>
                    </tr>
					<tr>
					    <td nowrap="nowrap">Calories Burned:</td>
					    <td align="right"><span class="progressBar" id="element4"><%=caloriesPercent %></span></td>
                    </tr>
                   
    			</table>
    			
    			<div class="bar-subhead" style="margin-top:15px;">Weekly totals</div>
    			<table cellpadding="0" cellspacing="0" class="tbl-progress">
               <tr>
                        <td>Steps:</td>
                        <td align="right"><asp:Label id="WeeklySteps" Text="123" runat="server"/></td>
                    </tr>
                     <tr>
                        <td>Distance:</td>
                        <td align="right"><asp:Label id="WeeklyDistance" Text="123" runat="server"/></td>
                    </tr>
                    <tr>
                        <td>Calories burned:</td>
                        <td align="right"><asp:Label id="WeeklyCalories" Text="123" runat="server"/></td>
                    </tr>
                   
                    </table>
                
                <div style="margin-top:20px;">
                   Don’t see your latest information? Copy your most recent data from HealthVault now.<br />
                   <div style="margin-top:5px;margin-bottom:0px;"><img src="images/icn_lnkArrow.gif" style="vertical-align:middle;margin-right:3px;" /><a href="HVDefault.aspx?cr=true">Refresh data</a></div>
                </div>
                
                <script type="text/javascript" src="js/prototype.js"></script>
                <script type="text/javascript" src="js/jsProgressBarHandler.js"></script>
               
            </div>
            <div class="cnrs-bot">
                <div class="cnr-left"></div>
                <div class="cnr-right"></div>
            </div>
        </div>
        
    
       
  