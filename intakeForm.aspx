<%@Page Inherits="CIS.conspectisLibrary" src="conspectisLibrary.cs" Language="C#" debug="true" %>
<%@Import Namespace="System.Data"%>
<%@Import Namespace="System"%>

<!DOCTYPE html>
<!-- HTML5 Status: VALID 2-12-13 CK -->
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
	lockout(); Page.Header.Title=shortSysName+": Managed Intake Form";
	systemStatus(0); // Check to see if admin has put system is in offline mode.

	string sql;
	DataSet dat=new DataSet();

	sql= "";
//	dat=readDb(sql);

	if (IsPostBack)
	{

	}
	titleSpan.InnerHtml="AHS Intake Questionnaire";
}
</SCRIPT>
</HEAD>

<!--#include file="body.inc" -->
<FORM id='form1' runat='server'>
<DIV id='container'>
<!--#include file="banner.inc" -->
	<DIV id='popContent'>

		<SPAN id='titleSpan' runat='server'/>
		<BR/><BR/>
		<DIV class='center'>
			<IMG src='./img/coming-soon.gif' width='350' height='350' alt='Coming Soon!'>
		</DIV>

	</DIV> <!-- End: popContent -->
<!--#include file="closer.inc"-->
</DIV> <!-- End: container -->
</FORM>
</BODY>
</HTML>