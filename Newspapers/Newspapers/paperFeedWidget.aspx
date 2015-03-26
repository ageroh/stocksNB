<%@ Page Language="c#" Debug="true" %>
<%@ import Namespace="System.Text" %>
<%@ import Namespace="System" %>
<%@ import Namespace="System.Net" %>

<script runat="server">
    
    protected void Page_Load (object sender, System.EventArgs e)
    {
        string codesWidget = string.Empty;
        string height = string.Empty;
        int width=500;
		int.TryParse(Request.QueryString["w"],out width);
        string vPage = string.Empty;
	    string h=Request.QueryString["h"];
        if (Request.QueryString["h"]!="")
            codesWidget = "/?hash="+Request.QueryString["h"];
    
        if(width==300)
            {
                vPage="widget-share";
                height = "635";
            }
        else            
            {
                vPage="widget-share-200";
                height = "500";
            }
        
        width = width + 5;
        
        Response.Write("document.write(\"<iframe scrolling='no' height='"+ height +"' frameborder='0' width='"+ width.ToString() +"' allowtransparency='' marginheight='0' marginwidth='0' src='http://" + Request.ServerVariables["SERVER_NAME"] + "/newspapers/"+ vPage +"" + codesWidget + "'/></iframe>\")");
       
    } 

   
</script>