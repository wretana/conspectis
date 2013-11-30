<%@Page Inherits="CIS.conspectisLibrary" src="conspectisLibrary.cs" Language="C#" debug="true" %>
<%@Import Namespace="System.Data.OleDb"%>
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
public void Page_Load(Object o, EventArgs e)
{
//UNCOMMENT this line to force login to access this page.
	lockout(); 
	Page.Header.Title=shortSysName+": Access Denied";
	systemStatus(1); // Check to see if admin has put system is in offline mode.

	string sql;
	DataSet dat=new DataSet();
	HttpCookie cookie;
	bool sqlSuccess=true;
	string access="", port="", v_userclass="",v_userrole="",v_username="";

	DateTime dateStamp = DateTime.Now;

	try
	{
		access=Request.QueryString["referrer"].ToString();
	}
	catch (System.Exception ex)
	{
		access="";
	}

	try
	{
		v_userclass=Request.Cookies["class"].Value;
	}
	catch (System.Exception ex)
	{
		v_userclass="1";
	}

	try
	{
		v_userrole=Request.Cookies["role"].Value;
	}
	catch (System.Exception ex)
	{
		v_userrole="";
	}

	try
	{
		v_username=Request.Cookies["username"].Value;
	}
	catch (System.Exception ex)
	{
		v_username="";
	}

	if (IsPostBack)
	{
	}
	
	errmsg.InnerHtml="You are not permitted to access the area you have attempted to access - "+access;
	titleSpan.InnerHtml="No Access";
}
</SCRIPT>
</HEAD>
<!--#include file='body.inc' -->
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
			<DIV class='center'>
<!--			<TABLE border='1' class='datatable' cellpadding='0' cellspacing='0'>
					<TR>
						<TD class='center'>
							<TABLE cellspacing='0'>
								<TR><TD class='inputform'>&#xa0;</TD><TD class='whiteRowFill left'>&#xa0;</TD></TR>
								<TR><TD class='inputform'>&#xa0;</TD><TD class='whiteRowFill left'>&#xa0;</TD></TR> 
							</TABLE>
						</TD>
					</TR>
				</TABLE> -->
				<INPUT type='button' value='Cancel &amp; Close' onclick='refreshParent()'>
			</DIV>
		&nbsp;<BR/>
		</DIV>
	</DIV> <!-- End: popContent -->
<!--#include file='popup_closer.inc' -->
	</FORM>
</DIV> <!-- End: container -->
</BODY>
</HTML>