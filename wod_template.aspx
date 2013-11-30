<%@Page Inherits="ESMS.wodLibrary" src="esmsLibrary.cs" Language="C#" debug="true" %>
<%@Import Namespace="System.Data"%>
<%@Import Namespace="System"%>

<!DOCTYPE html>
<!-- HTML5 Status: VALID 2-14-13 CK -->
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
	lockout(); Page.Header.Title=shortSysName+": WoD Module Template";
	systemStatus(0); // Check to see if admin has put system is in offline mode.

//START Check if user is logged in by checking existence of cookie.
	loggedin.InnerHtml=loggedIn();
//	adminMenu.InnerHtml=isAdmin();

	DateTime dateStamp = DateTime.Now;
	string v_username, curStat="";
	string sql="", status="";
	string wodInitErr="", wodErr="", wodResult="", wodTime="", vmString="";
	DataSet dat=new DataSet();

//	string server = wodServer;
//	string user = wodUser;
//	string pass = wodPass;

//	wodDatResult.DataSource=null;
//	wodDatResult.DataBind();

	try
	{
		v_username=Request.Cookies["username"].Value;
	}
	catch (System.Exception ex)
	{
		v_username="";
	}

	titleSpan.InnerHtml="Workspace-On-Demand Template";

/*	System.Net.ServicePointManager.ServerCertificateValidationCallback = wodLibrary.TrustAllCertificateCallback;
	wodInitErr=wodInit();
	if (wodInitErr=="0")
	{
		wodResult="VimAPI Intialized: <SPAN class='bold'>OK!</SPAN><BR/>VimAPI Connected: <SPAN class='bold'>OK!</SPAN><BR/>";
		wodTime=wodGetCurTime().ToString();
		
		if (wodTime!="")
		{
			wodResult=wodResult+"Time on vCenter Server:"+wodTime+"<BR/>";
		}
		else
		{
			wodResult=wodResult+"Fetch Time on vCenter Server: <SPAN class='bold'>FAILED</SPAN><BR/>";
		}
//		vmString=getVMInfo();
//		dat=getVMInfo();
//		if (!emptyDataset(dat))
//		{
//			wodDatResult.DataSource=dat;
//			wodDatResult.DataBind();
//		}
		wodErr=wodDisconnect();
		if (wodErr=="0")
		{
			wodResult=wodResult+"Disconnect VimAPI: <SPAN class='bold'>OK!</SPAN><BR/>";
		}
		else
		{
			wodResult=wodResult+"Disconnect VimAPI: <SPAN class='bold'>"+wodErr+"</SPAN><BR/>";
		}

	}
	else
	{
		wodResult=wodInitErr;
	}

	wodStatus.InnerHtml=wodResult; */

	

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
		<SPAN id='wodStatus' runat='server'/>
		<BR/><BR/>
		<ASP:datagrid id='wodDatResult' runat='server' BackColor='White' HorizontalAlign='Center' Font-Size='8pt' CellPadding='2' BorderColor='#336633' BorderStyle='Solid' BorderWidth='2px'>
			<HeaderStyle BackColor='#336633' ForeColor='White' Font-Bold='True' HorizontalAlign='Center' />
			<AlternatingItemStyle BackColor='#edf0f3' />
		</ASP:datagrid>
	</DIV> <!-- End: content -->
<!--#include file='closer.inc'-->
</DIV> <!-- End: container -->
</FORM>
</BODY>
</HTML>