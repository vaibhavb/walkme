<%@ Page Title="" Language="C#" MasterPageFile="~/WlkMi.master" AutoEventWireup="true" CodeFile="Error.aspx.cs" 
    Inherits="Microsoft.Health.Applications.WalkMe.Error" %>

<asp:Content ID="Content1" ContentPlaceHolderID="PageBody" Runat="Server">
        <div id="errorMessage">
            <p>An un-expected error happened. Details:.</p>
            <%# DisplayError() %>
            <br />
            Return to the <a href="default.aspx">WalkMe Home</a>
        </div>
</asp:Content>

