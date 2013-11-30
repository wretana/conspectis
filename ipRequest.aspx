<%@Page Inherits="CIS.conspectisLibrary" src="conspectisLibrary.cs" Language="C#" debug="true" %>
<%@Import Namespace="System.Data.OleDb"%>
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
	lockout(); Page.Header.Title=shortSysName+": Request IP Assignment";
	systemStatus(1); // Check to see if admin has put system is in offline mode.

	string sql, sql1, sqlErr="";
	DataSet dat, dat1;
	string errstr="";
	string srcHost="";
	try
	{
		srcHost=Request.QueryString["host"].ToString();
	}
	catch (System.Exception ex)
	{
		srcHost="";
	}
	
	bool sendSuccess=true;

	DateTime dateStamp = DateTime.Now;
	string v_username;
	try
	{
		v_username=Request.Cookies["username"].Value;
	}
	catch (System.Exception ex)
	{
		v_username="";
	}

	queryStr.InnerHtml=srcHost;
	if (IsPostBack)
	{
		string comment = fix_txt(formComment.Value);
		try
		{
			//  sendIpRequest(srcHost, comment);
		}
		catch (System.Exception ex)
		{
			sendSuccess=false;
			errstr="An Error has occurred! "+ex.ToString();
		}
		if (sendSuccess)
		{
			sqlErr=writeChangeLog(dateStamp.ToString(), Decrypt(v_username.ToString()), "IP Request Sent: "+srcHost+","+comment);
			if (sqlErr==null || sqlErr=="")
			{
				Response.Write("<script>refreshParent("+");<"+"/script>");
			}
			else
			{
				errmsg.InnerHtml = "WARNING: "+sqlErr;
			}
		}
		else
		{
			errmsg.InnerHtml=errstr;
		}
	}
	titleSpan.InnerHtml="IP Request";
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
		<DIV class='center'>
			<SPAN id='queryStr' runat='server'/>
		</DIV><BR/>
		
		<DIV class='center paleColorFill'>
		&nbsp;<BR/>
			<DIV class='center'>
				<TABLE border='1' class='datatable center'>
					<TR>
						<TD class='center'>
							<TABLE>
								<TR>
									<TD class='whiteRowFill center'>
										Your IP request will include all of the necessary information and the following comment:<BR/>&nbsp;<BR/>
										<TEXTAREA rows='5' cols='45' id='formComment' runat='server' /><BR/>&nbsp;
									</TD>
								</TR>
							</TABLE>
						</TD>
					</TR>
				</TABLE>
				<BR/>
				<INPUT type='submit' value='&nbsp; Send &nbsp;' runat='server'>&#xa0;<INPUT type='button' value='&nbsp; Cancel &nbsp;' onclick='refreshParent()'>
			</DIV>
		&nbsp;<BR/>
		</DIV>
	</DIV> <!-- End: popContent -->
<!--#include file='popup_closer.inc' -->
	</FORM>
</DIV> <!-- End: container -->
</BODY>
</HTML>