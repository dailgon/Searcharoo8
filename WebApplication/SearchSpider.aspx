<%@ Page Language="c#" Debug="true" %>
<%@ import Namespace="System.Text" %>
<%@ import Namespace="System.Text.RegularExpressions" %>
<%@ import Namespace="System" %>
<%@ import Namespace="System.Net" %>
<%@ import Namespace="Searcharoo.Common" %>
<%@ import Namespace="Searcharoo.Indexer" %>
<script runat="server">
    /// <summary>Store the catalog while we look at it</summary>
    private Catalog _Catalog;
    /// <summary>Event level to log (to the Html output)</summary>
    private int _ProgressEventLevel = 2;
    /// <summary>
    /// This page uses the Spider class to read and catalog a website
    /// </summary>
    protected void Page_Load (object sender, System.EventArgs e)
    {
	    // Do not let Searcharoo trigger itself
        if (Request.UserAgent.ToLower().IndexOf("searcharoo") >0 ) return;
        
        // write HTML header
        Response.Write(@"<html>
        <head>
		    <meta http-equiv=""robots"" content=""noindex,nofollow"">
		    <style type='text/css'>
			    BODY { color: #000000; background-color: white; font-family: trebuchet ms, verdana, arial, sans-serif; font-size:x-small; margin-left: 0px; margin-top: 0px; }
		    </style>
		    <title>Searcharoo Website Spider 6</title>
        </head>
        <body>
        <h3><font color=darkgray>Search</font><font color=red>a</font><font color=blue>r</font><font color=green>o</font><font color=yellow>o</font> <font color=darkgray>4</font></h3>
        Generating the catalog...<p>");
        
        // Build the catalog!
        Spider cat = new Spider();
        cat.SpiderProgressEvent += new SpiderProgressEventHandler (OnProgressEvent);
        _Catalog = cat.BuildCatalog (new Uri(Preferences.StartPage));
	    Cache [Preferences.CatalogCacheKey] = _Catalog;
        
        // Check if anything was found
        if (_Catalog.Length > 0)
        {
            Response.Write ("<br>Finished - now you can search!<p>");
            Server.Transfer ("Search.aspx");
        } else {
                Response.Write ("<br><p font='color:red'>Sorry, nothing was cataloged. Check the settings in web.config.</p>");
        }
    } // Page_Load

    /// <summary>
    /// Handle events generated by the Spider (mostly reporting on success/fail of page load/index)
    /// </summary>
    public void OnProgressEvent (object source,ProgressEventArgs pea)
    {
	    //Define the actions to be performed on
	    //button click here.
	    if (pea.Level < _ProgressEventLevel)
	    {
		    Response.Write (pea.Level + " :: " + pea.Message + "<br>");
		    //Response.Flush();
	    }
    }
</script>