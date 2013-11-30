<%@Page Inherits="CIS.conspectisLibrary" src="conspectisLibrary.cs" Language="C#" debug="true" %>
<%@Import Namespace="System.Data"%>
<%@Import Namespace="System"%>
<%@Import Namespace="System.IO"%>

<!DOCTYPE html>
<!-- HTML5 Status: VALID 2-15-13 CK -->
<!--[if lt IE 7 ]> <html lang='en' class='no-js ie6'> <![endif]-->
<!--[if IE 7 ]>    <html lang='en' class='no-js ie7'> <![endif]-->
<!--[if IE 8 ]>    <html lang='en' class='no-js ie8'> <![endif]-->
<!--[if IE 9 ]>    <html lang='en' class='no-js ie9'> <![endif]-->
<!--[if (gt IE 9)|!(IE)]><!--> <html lang='en' class='no-js'> <!--<![endif]-->

<HEAD runat="server">

<!--#include file="header.inc"-->

<SCRIPT runat="server">
public void storeDC(object sender, EventArgs e)
{
	string code="", sql="", cookieVal="";
	code=dcSelector.Value;

//	Fetch cookie to determine if it needs to be set anew, or just updated ...
	try
	{
		cookieVal=Request.Cookies["selectedDc"].Value;
	}
	catch (System.Exception ex)
	{
		cookieVal="";
	}
	if (cookieVal=="") // Set new cookie ...
	{
		HttpCookie cookie=new HttpCookie("selectedDc",code);
		cookie.Expires=DateTime.Now.AddDays(3);
		Response.Cookies.Add(cookie);
	}
	else // Update existing coolie ...
	{
		HttpCookie cookie=Request.Cookies["selectedDc"];
		cookie.Value=code;
		Response.Cookies.Add(cookie);
	}
	Response.Write("<script type='text/JavaScript'>document.location.reload("+"true);<"+"/script>");
}


public void Page_Load(Object o, EventArgs e)
{
//UNCOMMENT this line to force login to access this page.
	lockout(); Page.Header.Title=shortSysName+": Scrape SR's from PDF";
	systemStatus(0); // Check to see if admin has put system is in offline mode.

//START Check if user is logged in by checking existence of cookie.
//	loggedin.InnerHtml=loggedIn();
	adminMenu.InnerHtml=isAdmin();

	DateTime dateStamp = DateTime.Now;
	string v_username, curStat="";
	string sql="", status="";
	string siteToScrape1="",siteToScrape2="", scrapedText1="",scrapedText2="", scraped="";
	DataSet dat = new DataSet();
	int begin1, begin2, end1, end2, diff1, diff2;

	try
	{
		v_username=Request.Cookies["username"].Value;
	}
	catch (System.Exception ex)
	{
		v_username="";
	}

	scrapeResult.DataSource=null;
	scrapeResult.DataBind();

	titleSpan.InnerHtml="<SPAN class='heading1'>SR Detail PDF Page Scraped</SPAN>";

	siteToScrape1 = "http://fswebas.wo.fs.fed.us:7777/reports/rwservlet?iso_tracking&report=tr_rfc.rdf&destype=cache&desformat=pdf&p_case_number=20071820";

	scrapedText1=ExtractText(siteToScrape1);

	begin1=scrapedText1.IndexOf("Request Title")+14; //16
	end1=scrapedText1.IndexOf("Requestor Name"); //7
	diff1=end1-begin1;
	if (diff1>0)
	{
		scraped=scrapedText1.Substring(begin1,diff1);
		scraped.Trim();
	} 
/*	FETCH Requestor Name
	begin1=scrapedText1.IndexOf("Request Title")+14; //16
	end1=scrapedText1.IndexOf("Requestor Name"); //7
	diff1=end1-begin1;
	if (diff1>0)
	{
		scraped=scrapedText1.Substring(begin1,diff1);
		scraped.Trim();
	} 

	FETCH Category 
	begin1=scrapedText1.IndexOf("Resubmission Date")+17; //16
	end1=scrapedText1.IndexOf("Category"); //7
	diff1=end1-begin1;
	if (diff1>0)
	{
		scraped=scrapedText1.Substring(begin1,diff1);
		scraped.Trim();
	} */

/*	Response.Write("ScrapedText1 - Index of 'Request Title':"+begin1.ToString());
	Response.Write("<BR/>");
	Response.Write("ScrapedText1 - Index of 'Requestor Name':"+end1.ToString());
	Response.Write("<BR/>");
	Response.Write(diff1.ToString());
	Response.Write("<BR/>");
	Response.Write("Category Text Found:"+scraped);
	Response.Write("<BR/>");
	Response.Write("<BR/><BR/>"); */

	siteToScrape2 = "http://fswebas.wo.fs.fed.us:7777/reports/rwservlet?iso_tracking&report=tr_rfc.rdf&destype=cache&desformat=pdf&p_case_number=20071708";

	scrapedText2=ExtractText(siteToScrape2);
	scraped="";
	begin2=scrapedText2.IndexOf("Request Title")+14;
	end2=scrapedText2.IndexOf("Requestor Name");
	diff2=end2-begin2;
	if (diff2>0)
	{
		scraped=scrapedText2.Substring(begin2,diff2);
		scraped.Trim();
	}

/*

	Response.Write("ScrapedText2 - Index of 'Request Title':"+begin2.ToString());
	Response.Write("<BR/>");
	Response.Write("ScrapedText2 - Index of 'Requestor Name':"+end2.ToString());
	Response.Write("<BR/>");
	Response.Write(diff2.ToString());
	Response.Write("<BR/>");
	Response.Write("Category Text Found:"+scraped);
	Response.Write("<BR/>");
	Response.Write("<BR/><BR/>");

	scrapeSpan.InnerHtml=scrapedText1+"<BR/><BR/>"+scrapedText2;

//	siteToScrape = "http://sxpheesms002-dev.phe.fs.fed.us/srlist.html";
	siteToScrape = "http://fswebas.wo.fs.fed.us:7777/reports/pm_tracking/pm_rfc_status.jsp?pm_tracking";
	try
	{
		dat=getSRDataSet(siteToScrape);
		if (!emptyDataset(dat))
		{
			scrapeResult.DataSource=dat;
			scrapeResult.DataBind();
		}
	}
	catch (Exception ex)
	{
		scraped = "Cannot make a connection to " + siteToScrape + "<BR/><BR/> EXCEPTION: " + ex;
	}

	if (!emptyDataset(dat))
	{
		scrapeResult.DataSource=dat;
		scrapeResult.DataBind();
	}
*/
	sql= "";
//	dat=readDb(sql);

	if (IsPostBack)
	{
	}
}
</SCRIPT>
</HEAD>
<!--#include file='body.inc' -->
<FORM id='form1' runat='server'>
<DIV id='container'>
<!--#include file='banner.inc' -->
<!--#include file='menu.inc' -->
	<DIV id='content'>
		<SPAN id='titleSpan' runat='server'/>
		<DIV class='center'>
			<DIV>
				<SPAN id='scrapeSpan' runat='server'/>
				<ASP:datagrid id='scrapeResult' runat='server' BackColor='White' HorizontalAlign='Center' Font-Size='8pt' CellPadding='2' BorderColor='#336633' BorderStyle='Solid' BorderWidth='2px'>
					<HeaderStyle BackColor='#336633' ForeColor='White' Font-Bold='True' HorizontalAlign='Center' />
					<AlternatingItemStyle BackColor='#edf0f3' />
				</ASP:datagrid>
			</DIV>
		</DIV>
	</DIV> <!-- End: content -->
<!--#include file='closer.inc'-->
</DIV> <!-- End: container -->
</FORM>
</BODY>
</HTML>