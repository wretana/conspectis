<%@Page Inherits="CIS.conspectisLibrary" src="conspectisLibrary.cs" Language="C#" debug="true" %>
<%@Import Namespace="System.Data.OleDb"%>
<%@Import Namespace="System.Data"%>
<%@Import Namespace="System"%>

<!DOCTYPE html>
<!-- HTML5 Status: VALID 2-11-13 CK -->
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

// MODIFIED FOR Dummy commit to verify connectivity with JIRA via PHE-1973


	systemStatus(1); // Check to see if admin has put system is in offline mode.

	string sql;
	DataSet dat=new DataSet();
	HttpCookie cookie;
	bool sqlSuccess=true;
	string access="", port="";

	DateTime dateStamp = DateTime.Now;

	try
	{
		access=Request.QueryString["switch"].ToString();
	}
	catch (System.Exception ex)
	{
		access="";
	}

	try
	{
		port=Request.QueryString["portId"].ToString();
	}
	catch (System.Exception ex)
	{
		port="";
	}
	
	if (IsPostBack)
	{
	}
	
	Response.Write(access);
	Response.Write(port);

	titleSpan.InnerHtml="Help";
}
</SCRIPT>
</HEAD>
<!--#include file="body.inc" -->
<DIV id='popContainer'>
	<FORM runat='server'>
<!--#include file='popup_opener.inc' -->
	<DIV id='popContent'>
		<DIV class='center altRowFill'>
			<SPAN id='titleSpan' runat='server'/>
			<DIV id='errmsg' class='errorLine' runat='server'/>
		</DIV>
		
		<DIV class='center paleColorFill'>
		&nbsp;<BR/>
		<TABLE border='1' class='datatable center'>
			<TR><TD class='center'>
				<TABLE>
					<TR><TD class='inputform'>&#xa0;</TD><TD class='whiteRowFill'>&#xa0;</TD></TR>

					<TR><TD class='inputform'>&#xa0;</TD><TD class='whiteRowFill'>&#xa0;</TD></TR> 
				</TABLE>
			</TD></TR>
		</TABLE>
		&nbsp;<BR/>
		</DIV>
	</DIV> <!-- End: popContent -->
<!--#include file='popup_closer.inc' -->
	</FORM>
</DIV> <!-- End: container -->
</BODY>
</HTML>