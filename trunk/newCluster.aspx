<%@Page Inherits="CIS.conspectisLibrary" src="conspectisLibrary.cs" Language="C#" debug="true" %>
<%@Import Namespace="System.Data.OleDb"%>
<%@Import Namespace="System.Data"%>
<%@Import Namespace="System"%>

<!DOCTYPE html>
<!-- HTML5 Status: VALID 2-13-13 CK -->
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
	lockout(); Page.Header.Title=shortSysName+": Add New Cluster";
	systemStatus(1); // Check to see if admin has put system is in offline mode.

	string sql;
	DataSet dat=new DataSet();
	HttpCookie cookie;
	bool sqlSuccess=true, permitted=false;
	string editHw="";
	string v_username, v_userclass="", v_userrole="";

	DateTime dateStamp = DateTime.Now;

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

	string dcArg="";
	try
	{
		dcArg=Request.QueryString["dc"].ToString();
	}
	catch (System.Exception ex)
	{
		dcArg= "";
	}
	
	titleSpan.InnerHtml=dcArg.ToUpper().Replace("_","");

	sql="SELECT * FROM "+dcArg+"clusters";
	dat=readDb(sql);
	if (!emptyDataset(dat))
	{
	}

	if (IsPostBack)
	{
	}

	if (System.Text.RegularExpressions.Regex.IsMatch(v_userrole, "datacenter", System.Text.RegularExpressions.RegexOptions.IgnoreCase))
	{
		permitted=true;
	}
	
	titleSpan.InnerHtml="Add New Cluster";

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
				<TR><TD align='center'>
					<TABLE cellspacing='0'>
						<TR><TD class='inputform'>&#xa0;</TD><TD class='whiteRowFill left'>&#xa0;</TD></TR>
						<TR><TD class='inputform'>&#xa0;</TD><TD class='whiteRowFill left'>&#xa0;</TD></TR> 
					</TABLE>
				</TABLE> -->
			</DIV>
		&nbsp;<BR/>
		</DIV>
	</DIV> <!-- End: popContent -->
<!--#include file='popup_closer.inc' -->
	</FORM>
</DIV> <!-- End: container -->
</BODY>
</HTML>