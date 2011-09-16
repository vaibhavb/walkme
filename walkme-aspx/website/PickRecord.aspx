<%@ Page Title="" Language="C#" MasterPageFile="~/WlkMi.master" AutoEventWireup="true" CodeFile="PickRecord.aspx.cs" Inherits="Microsoft.Health.Applications.WalkMe.PickRecord" %>
<%@ Register TagPrefix="WlkMi" TagName="Links" Src="~/Controls/HVModule.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="PageBody" Runat="Server">
    
    <div class="pdng-page-top"></div>
   
   
    <div class="page-head">
        <div class="cnrs-top">
            <div class="cnr-left"></div>
            <div class="cnr-right"></div>
        </div>
        <div class="body">Record Selector</div>
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
                <div class="h1">
                Which HealthVault record do you want to make active?
                </div>
                <div class="form-description"  style="line-height:16px;">
                Changing which record is active determines whose health and fitness information you will see while using this site. This list shows all records to your account can access.
            </div>
           <style>
            .activeRecord
            {
            	background:#effcff;
            	border:1px solid #00b0d8;
            	padding:15px;
            	margin-right:10px;
            	margin-top:10px;
            	width:250px;
            	line-height:16px;
            }
            .inActiveRecord
            {
            	background:#fff;
            	border:1px dashed #ccc;
            	padding:15px;
            	margin-right:10px;
            	margin-top:10px;
            	width:250px;
            	line-height:16px;
            }
           </style>
           
           
           <div style="font-weight:bold;margin-bottom:8px;margin-top:10px;">Records:</div>
           
           
            <asp:DataList id="datalistRecords" runat="server"
        RepeatColumns="2" RepeatDirection="Horizontal" CssClass="listRecords">
        <ItemTemplate>
        
             <%# (((Microsoft.Health.Web.HealthServicePage)Page).PersonInfo.SelectedRecord != null && ((Microsoft.Health.HealthRecordInfo)Container.DataItem).Id == ((Microsoft.Health.Web.HealthServicePage)Page).PersonInfo.SelectedRecord.Id ? "<div class='activeRecord'>" : "<div class='inActiveRecord'>") %>
                
                <div style="font-size:16px;"><%# ((Microsoft.Health.HealthRecordInfo)Container.DataItem).Name %> <span class="informationalText">(<%# ((Microsoft.Health.HealthRecordInfo)Container.DataItem).RelationshipName %>)</span></div>
                
                
                
                <br/>

                <%# (((Microsoft.Health.Web.HealthServicePage)Page).PersonInfo.SelectedRecord != null &&((Microsoft.Health.HealthRecordInfo)Container.DataItem).Id == ((Microsoft.Health.Web.HealthServicePage)Page).PersonInfo.SelectedRecord.Id ? "<b class='h4'>Active record</b><br/>" : "<img src=\"images/icn_lnkArrow.gif\" style=\"vertical-align:middle;margin-right:3px;\" /><a href=\"pickrecord.aspx?id="
                    +((Microsoft.Health.HealthRecordInfo)Container.DataItem).Id.ToString() + "\">Make this the active record</a><br />") %>
                <span class="informationalText"><%# (((Microsoft.Health.HealthRecordInfo)Container.DataItem).IsCustodian ? "You are a custodian of this record.<br/>" : "") %></span>

        </div>
    </ItemTemplate>
    </asp:DataList><br/>
    
    
   
    
           
            </div>
            <div class="cnrs-bot">
                <div class="cnr-left"></div>
                <div class="cnr-right"></div>
            </div>
        </div>
             
    
    </div>
    <div class="body-right">
        <div style="position:relative;z-index:99"><WlkMi:Links ID="Links" runat="server" /></div>
        <div class="pdg-rightbar"></div>
       
       
     <div class="page-box width-rightbar" style="position:relative;z-index:0">
       <div class="cnrs-top-brn">
        <div class="cnr-left"></div>
        <div class="cnr-right"></div>
        </div>
        <div class="sec-header"><span class="h6">Add a new Record</span></div>
        
         
            <div class="body" style="line-height:16px;">
                <span class="h6"></span><br />
               To authorize another record, or to change the default record you log in with, click and select the appropriate record.
               <div style="margin-top:10px;">
    <img src="images/icn_lnkArrow.gif" style="vertical-align:middle;margin-right:3px;" /><asp:LinkButton ID="LinkButtonAuthNewRecord" runat="server" OnClick="LinkButtonAuthNewRecord_Click">Add new record</asp:LinkButton>
    </div>
                
            </div>
            <div class="cnrs-bot">
                <div class="cnr-left"></div>
                <div class="cnr-right"></div>
            </div>
        </div>
        
    
       
  
      
         
    </div>
    <br class="clear" />    
    
    
    


</asp:Content>

