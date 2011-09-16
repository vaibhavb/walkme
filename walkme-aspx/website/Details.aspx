<%@ Page Language="C#" MasterPageFile="~/Wlkmi.master" AutoEventWireup="True" 
Inherits="Microsoft.Health.Applications.WalkMe.Details" Title="Untitled Page" CodeFile="Details.aspx.cs" %>


<asp:Content ID="Content1" ContentPlaceHolderID="PageBody" Runat="Server">
  
    <div class="body-left" style="width:100%">
        <div class="pdng-page-top"></div>
        <div class="page-box">
            <div class="cnrs-top">
                <div class="cnr-left"></div>
                <div class="cnr-right"></div>
            </div>
            <div class="body" style="padding-top:30px;">
            
                <div class="xpadding">
                    
                    <div class="h1">Do you have a Windows Live™ ID Account?</div>
                    <div class="form-description">Information you create in WalkMe is stored in Microsoft HealthVault, a site that lets you gather your health data in one convenient place and share it with others you trust. You’ll need to create a free HealthVault account to use WalkMe.</div>
                    
                    <div style="width:750px;margin:auto">
                     <div class="body-left" style="width:250px;padding-right:40px;margin-top:20px;border-right:1px dashed #ccc">
                        <div style="font-size:16px;"><b style="font-size:24px;">Yes</b>, I have a Windows Live™ ID or a HealthVault account</div>
                        <div class="form-description">Continue signing in to your HealthVault account</div>
                        
                   
                    <a href="HVDefault.aspx"><img alt="Sign up" width="160" height="45" src="images/btn_signin2.gif" border="0" /></a>
                     </div>
                     <div class="body-right" style="width:410px;padding-left:20px;margin-top:20px;">
                        <div style="font-size:16px;"><b style="font-size:24px;">No</b>, I don't have a Windows Live™ ID account</div>
                        <div class="form-description">You can create one for free using any e-mail address. Create your free HealthVault account.  Give WalkMe permission to store and use data in your HealthVault record. 
</div>
                     
                        <a href="" runat="server" id="LinkToPassport"><img alt="Sign up" width="160" height="45" src="images/btn_signup.gif" border="0" /></a>
                     </div>
                    
                    </div>
                    <br class="clear" />
                    <br class="clear" />
                    <br class="clear" />
                </div>
            </div>
        </div>
        <div class="cnrs-bot">
            <div class="cnr-left"></div>
            <div class="cnr-right"></div>
        </div>
    </div>

   
    <br class="clear" />
</asp:Content>

