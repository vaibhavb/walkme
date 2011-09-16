<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Sharing.ascx.cs" Inherits="Microsoft.Health.Applications.WalkMe.Controls_Sharing" %>

<div class="page-box">
        <div class="cnrs-top">
            <div class="cnr-left"></div>
            <div class="cnr-right"></div>
        </div>
        <div class="body">
            <div class="xpadding">
            <div class="h1">Want to share your success? </div>
            <div class="form-description">
                Add your WalkMe info to your social network profiles to let friends see your progress.  
            </div>
           
            <div>
                <asp:CheckBox runat="server" ID="chk_share" OnCheckedChanged="Button1_Click" AutoPostBack="true" Text="Allow others to see my WalkMe data" />
                <asp:Label CssClass="confirm-save" runat="server" ID="lbl_saved" Visible="false">Your updates were saved</asp:Label>
            </div>
            
             
             
                    <asp:PlaceHolder runat="server" id="ph_share">
                    
                    <div style="margin-top:30px;font-size:14px;font-weight:bold">Sharing is turned on</div>
                    <div style="margin-top:30px;font-size:12px;">You have enabled sharing.  Because of the way widgets, RSS and web sharing works, this means it is possible for anyone to see the data that feeds your widget. </div>      
                    <table class="tbl-form" style="width:550px;" cellpadding="0" cellspacing="0" border="0">
                        <tr>
                            <td colspan="2" style="border-bottom:1px solid #eaeaea;"> <div style="margin-top:30px;font-size:12px;font-weight:bold">Share your steps as an RSS feed or Bookmark</div></td>
                        </tr>
                        
                        <tr>
                            <td valign="top" style="width:100%;border-bottom:1px solid #eaeaea;">
                                 
                                <div style="margin-bottom:8px;margin-top:10px;">Select a service below:</div>
                                <script type="text/javascript">var addthis_pub = "walkme";</script>
                                <script type="text/javascript" src="https://secure.addthis.com/js/152/addthis_widget.js"></script>
                                <a href="https://www.addthis.com/bookmark.php" onmouseover="return addthis_open(this, '', '<%= COPYWIDGETHTMLURL %>', '<%= RSSTITLE%>')" onmouseout="addthis_close()" onclick="return addthis_sendto()">                                <img src="https://secure.addthis.com/static/btn/lg-share-en.gif" width="125" height="16" border="0" alt="Bookmark and Share" style="border:0"/></a>
                                <a href="http://www.addthis.com/feed.php?pub=walkme&h1=<%= COPYRSSURLENCODED %>" title="<%= RSSTITLE %>" target="_blank">                                <img src="https://secure.addthis.com/static/btn/lg-rss-en.gif" width="125" height="16" border="0" alt="RSS" style="border:0"/></a>
                            </td>
                            <td valign="top" style="padding:10px;border-left:1px dashed #ccc;border-bottom:1px solid #eaeaea;" >
                                
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" style="border-bottom:1px solid #eaeaea;"><div style="margin-top:30px;font-size:12px;font-weight:bold">Share your steps with a WalkMe Widget</div>  </td>
                        </tr>
                        <tr>
                            <td valign="top" style="border-bottom:1px solid #eaeaea;width:100%">
                              
                                    <div style="margin-bottom:8px;margin-top:10px;">Copy and paste this HTML to your blog or Web site:</div>
                                    
                                    <textarea style="width:280px;height:100px;font-size:11px;" disabled="disabled" style="border:0px;overflow:hidden;"><%= COPYWIDGETHTML%></textarea>

                                    <div>
                                    Or use our <a href="<%= SHAREWIDGETURL %>" target="_blank">widget service</a> to easily add it to supported sites.                                    </div>                                                                      
                            </td>
                            <td valign="top" style="border-left:1px dashed #ccc;border-bottom:1px solid #eaeaea;" >
                            <div style="padding:10px;">
                            <div style="margin-bottom:8px;">Preview:</div>
                            
                                 <%= WIDGETHTML%>   
                                 
                                 
                                 </div>
                                 
                                
                            </td>
                        </tr>
                        
                         <tr>
                            <td colspan="2" style="border-bottom:1px solid #eaeaea;"> <div style="margin-top:30px;font-size:12px;font-weight:bold">Share your steps as an image</div></td>
                        </tr>
                        
                        <tr>
                            <td valign="top" style="width:100%">
                                 
                                 <div style="margin-bottom:8px;margin-top:10px;">Copy and paste this HTML to your blog or Web site:</div>
                               <textarea style="width:280px;height:50px;font-size:11px;" disabled="disabled" style="border:0px;overflow:hidden;"><a href='<%= WLKMIWEBSITE %>'><img src='<%= COPYIMAGEURL %>' alt="Walklog Image" border="0"/></a></textarea>
                               
                               <p></p>
                               <div>Or save this <a href="<%= OUTLOOKURL %>" >file</a> as your outlook signature.</div>
                            </td>
                            <td valign="top" style="padding:10px;border-left:1px dashed #ccc" >
                              
                                 <div style="margin-bottom:8px;">Preview:</div>
                                <img src='<%= IMAGEURL %>' alt="Walklog Image"/>
                                
                            </td>
                        </tr>
                    </table>
                          
               
                    </asp:PlaceHolder>            
                
                    <asp:PlaceHolder runat="server" ID="ph_noshare">
                    
                     <div style="margin-top:30px;font-size:14px;font-weight:bold">Sharing is turned off</div>
                     <div style="">
                           If you previously had shared your WalkMe data as an RSS feed, bookmark, widget, or image, it will no longer be visible. 
                        </div>
                     <div style="margin-top:15px;">
                        <div style="font-weight:bold;margin-bottom:5px;">Why share?</div>
                        Sharing your steps makes you more aware of your progress, and can create a little healthy competition with friends—and with yourself. 
                        
                        
                     </div>
                    
                    
                    </asp:PlaceHolder>
      
           
           
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