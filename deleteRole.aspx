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
//UNCOMMENT this line to force login to access this page.
	lockout(); Page.Header.Title=shortSysName+": Delete Role";
	systemStatus(1); // Check to see if admin has put system is in offline mode.

	string sql, sql1;
	DataSet dat, dat1;
	DateTime dateStamp = DateTime.Now;
	string v_username, errstr="", sqlErr="", srcKey="";
	bool sqlSuccess=true;
	bool sendSuccess=true;

	try
	{
		v_username=Request.Cookies["username"].Value;
	}
	catch (System.Exception ex)
	{
		v_username="";
	}
	
	try
	{
		srcKey=Request.QueryString["key"].ToString();
	}
	catch (System.Exception ex)
	{
		srcKey="";
	}

	queryStr.InnerHtml=srcKey;
	if (IsPostBack)
	{
		sql = "DELETE FROM userRoles WHERE roleValue='"+srcKey+"'";
		sqlErr=writeDb(sql);
		if (sqlErr==null || sqlErr=="")
		{
			errmsg.InnerHtml = "Record DELETED.";
		}
		else
		{
			errmsg.InnerHtml = "SQL Update Error - "+sqlErr;
			sqlSuccess=false;
			sqlErr="";
		}
	 	if (sqlSuccess) 
		{
			sqlErr=writeChangeLog(dateStamp.ToString(), Decrypt(v_username.ToString()), sql2txt(sql).ToString());
			if (sqlErr==null || sqlErr=="")
			{
				try
				{
//					//  sendServerDeletionNotice(srcKey,v_username); // Erroring ...
				}
				catch (System.Exception ex)
				{
					sendSuccess=false;
					errstr=ex.ToString();
				}
				if (sendSuccess)
				{
					sqlErr=writeChangeLog(dateStamp.ToString(), Decrypt(v_username.ToString()), "UserRole Deletion Notice Sent: "+srcKey);
					if (sqlErr==null || sqlErr=="")
					{
						Response.Write("<script>refreshParent("+");<"+"/script>");
					}
					else
					{
						errmsg.InnerHtml = "WARNING: "+sqlErr;
					}
				}
				errmsg.InnerHtml=errstr;
			}		
		}
	}
	titleSpan.InnerHtml="Delete Role";
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
		&#xa0;<BR/>
			<TABLE border='1' class='datatable center'>
				<TR>
					<TD class='center'>
						<TABLE>
							<TR>
								<TD class='whiteRowFill center'>
									Are you sure you wish to delete role '<SPAN id='queryStr' runat='server' />'?
								</TD>
							</TR>
						</TABLE>
					</TD>
				</TR>
			</TABLE>
			<BR/>
			<INPUT type='submit' value='&nbsp; Yes &nbsp;' runat='server'>&#xa0;<INPUT type='button' value='&nbsp; No &nbsp;' onclick='refreshParent()'>
			<BR/>&nbsp;<BR/>
		</DIV>
	</DIV> <!-- End: popContent -->
<!--#include file='popup_closer.inc' -->
	</FORM>
</DIV> <!-- End: container -->
</BODY>
</HTML>