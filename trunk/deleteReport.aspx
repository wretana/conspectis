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
	lockout(); Page.Header.Title=shortSysName+": Delete Report";
	systemStatus(1); // Check to see if admin has put system is in offline mode.

	string sql, sql1;
	DataSet dat, dat1;
	DateTime dateStamp = DateTime.Now;
	string v_username, errstr="", sqlErr="";
	string report, reportName="";
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
		report=Request.QueryString["report"].ToString();
	}
	catch (System.Exception ex)
	{
		report="";
	}
	
	if (report!="")
	{
		sql="SELECT * FROM reports WHERE reportId="+report;
		dat=readDb(sql);
		if (!emptyDataset(dat))
		{
			reportName=dat.Tables[0].Rows[0]["reportName"].ToString();
		}
	}
	

	queryStr.InnerHtml=reportName;
	if (IsPostBack)
	{
		sql = "DELETE FROM reports WHERE reportId="+report;
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
				Response.Write("<script>refreshParent("+");<"+"/script>");
			}		
		}
	}
	titleSpan.InnerHtml="Delete Report";
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
									Are you sure you wish to delete <SPAN id='queryStr' runat='server' />?
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