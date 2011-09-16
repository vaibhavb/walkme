<%@ Page Language="C#" MasterPageFile="~/Wlkmi.master" AutoEventWireup="True" 
Inherits="Microsoft.Health.Applications.WalkMe.Default" Title="WalkMe Home" CodeFile="Default.aspx.cs" %>
<asp:Content ID="Content1" ContentPlaceHolderID="PageBody" Runat="Server">
    <div class="pdng-page-top"></div>
    
    <div class="page-box">
        <div class="cnrs-top">
            <div class="cnr-left"></div>
            <div class="cnr-right"></div>
        </div>
        <div class="body" style="padding-top:30px;">
            <div class="homeTitleFrame">
                <img width="815" height="87" src="images/title.gif" alt="Get Walking and Get Fit. Tracking your steps will get you there" />
            </div>
            <div class="homeContent">
                <div class="homeLeftBox">
                    <img alt="Image: WalkMe screen shot" src="images/ss_graph.gif" />
                </div>                
                <div class="homeRightBox">
                  
                    <div style="font-weight:bold;font-size:18px;">With WalkMe, you can:</div>
                    <ul style="margin:8px 0px 15px 15px;line-height:18px;padding:0px; ">
                        <li style="margin-bottom:8px">Get a clear picture of how active you are&mdash;no guessing</li>
                        <li style="margin-bottom:8px">Remember to walk more by using a pedometer</li>
                        <li style="margin-bottom:8px">Set goals and get more exercise by tracking steps</li>
                    </ul>
                    
                    
                    <div style="margin-top:0px;font-size:12px;margin-bottom:30px;">Note: To use WalkMe, you’ll need to have a Microsoft HealthVault account.</div>
                    
                    <a href="Details.aspx"><img alt="Sign up" width="160" height="45" src="images/btn_signup.gif" border="0" /></a>
                    
                   
                </div>    
                <br class="clear" />
           
            
            <br class="clear" />
            
            <div class="body-left" style="margin-top:15px;width:515px;">
                <div class="page-box">
                    <div class="cnrs-top">
                        <div class="cnr-left"></div>
                        <div class="cnr-right"></div>
                    </div>
                    <div class="body" style="padding:15px;">
                        <div class="h2">Why track steps?</div>
                        
                        Because it works. People who start a pedometer-based walking program increase the steps they take by about 2,000 to 4,000 a day, the equivalent of an extra one to two miles. (<a href="http://health.msn.com/fitness/walking/articlepage.aspx?cp-documentid=100212026" target="_blank">Source: MSN</a>)
                    </div>
                    <div class="cnrs-bot">
                        <div class="cnr-left"></div>
                        <div class="cnr-right"></div>
                    </div>
                </div>
            </div>
        
            <div class="body-right" style="margin-top:15px;width:280px;">
                <div class="page-box">
                    <div class="cnrs-top">
                        <div class="cnr-left"></div>
                        <div class="cnr-right"></div>
                    </div>
                    <div class="body" style="padding:15px;">
                        <div class="h2">WalkMe member step totals!</div>
                        <div class="counter-frame">
                            <div class="counter"><asp:Literal ID="StepsWalked" runat="server"></asp:Literal></div>
                            steps and counting...             
                        </div>
                    </div>
                    <div class="cnrs-bot">
                        <div class="cnr-left"></div>
                        <div class="cnr-right"></div>
                    </div>
                </div>
            </div>
            
            
             </div>
            <br class="clear" />
        </div>
       <div class="cnrs-bot">
            <div class="cnr-left"></div>
            <div class="cnr-right"></div>
        </div>
    </div>
        
        
        
        
 
           
 
   
        
       
           
        
</asp:Content>

