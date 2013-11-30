<%@Page Inherits="CIS.conspectisLibrary" src="conspectisLibrary.cs" Language="C#" debug="true" %>
<%@Import Namespace="System.Data"%>
<%@Import Namespace="System"%>

<!DOCTYPE html>
<!-- HTML5 Status: VALID 1-29-13 CK -->
<!--[if lt IE 7 ]> <html lang='en' class='no-js ie6'> <![endif]-->
<!--[if IE 7 ]>    <html lang='en' class='no-js ie7'> <![endif]-->
<!--[if IE 8 ]>    <html lang='en' class='no-js ie8'> <![endif]-->
<!--[if IE 9 ]>    <html lang='en' class='no-js ie9'> <![endif]-->
<!--[if (gt IE 9)|!(IE)]><!--> <html lang='en' class='no-js'> <!--<![endif]-->

<HEAD runat="server">

<!--#include file="header.inc"-->

<SCRIPT runat="server">
public void Page_Load(Object o, EventArgs e)
{
//UNCOMMENT this line to force login to access this page.
//	lockout(); 
	Page.Header.Title=sysName+" ";
	systemStatus(0); // Check to see if admin has put system is in offline mode.

//START Check if user is logged in by checking existence of cookie.
//	loggedin.InnerHtml=loggedIn();
//	adminMenu.InnerHtml=isAdmin();

	string sql;
	DataSet dat=new DataSet();
	if (IsPostBack)
	{

	}
	staticContentDiv.InnerHtml=""+
"		<DIV id='modeSelector'>"+
"			<DIV>"+
"				<SPAN class='imgBigPadded nodec'><A HREF='intakeForm.aspx'><IMG src='./img/intake.png' alt='Complete an AHS Intake Form'/></A></SPAN>"+
"				<IMG src='./img/vr.png' alt=''/>"+
"				<SPAN class='imgBigPadded nodec'><A HREF='adauth.aspx'><IMG src='./img/teamLogin.png' alt='Enter the system'/></A></SPAN>"+
"			</DIV>"+
"		</DIV> <!-- End: modeSelector --><BR/>";
}
</SCRIPT>
</HEAD>

<!--#include file="body.inc" -->
<DIV id='container'>
<!--#include file="banner.inc" -->

	<DIV id='menu'>
	</DIV> <!-- End: menu -->
	<DIV id='content' style=''>
		<SPAN id="titleSpan" runat="server"/>
		<DIV class='center'>
			<DIV id="errmsg" class="errorLine" runat="server"/>
			<DIV id="status" class="statusLine" runat="server"/><BR/>
		</DIV>
		<DIV id="staticContentDiv" runat="server"/>
	</DIV> <!-- End: content -->

<!--#include file="closer.inc"-->
	
</DIV> <!-- End: container -->
</BODY>
</HTML>