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
	lockout(); Page.Header.Title=shortSysName+": Change Log - Event Detail";
	systemStatus(1); // Check to see if admin has put system is in offline mode.

	string sql;
	DataSet dat=new DataSet();
	HttpCookie cookie;
	bool sqlSuccess=true;
	string index="";

	DateTime dateStamp = DateTime.Now;

	try
	{
		index=Request.QueryString["index"].ToString();
	}
	catch (System.Exception ex)
	{
		index="";
	}


	if (IsPostBack)
	{
	}
	
//	Response.Write(index);
	dat=readChangeDetail(index);
	string v_dateTime="";
	string v_event="";
	if (!emptyDataset(dat))
	{
		v_dateTime=dat.Tables[0].Rows[0]["TimeGenerated"].ToString();
		v_event=dat.Tables[0].Rows[0]["Message"].ToString();
	}
	formDateTime.InnerHtml=v_dateTime;
	formEvent.InnerHtml="<SPAN style='font-size:8pt'>"+v_event+"</SPAN>";
	titleSpan.InnerHtml="Change Log Event Detail";
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
				<TABLE border='1' class='datatable center'>
					<TR><TD class='center'>
						<TABLE style='table-layout:fixed; width:750px;'>
							<COL style='width:75px'>
							<COL style='width:500px'>
							<TR>
								<TD class='inputform'>
									<SPAN class='bold'>Date / Time:&#xa0;</SPAN>
								</TD>
								<TD class='whiteRowFill'>
									<DIV id='formDateTime' runat='server' />
								</TD>
							</TR>
							<TR>
								<TD class='inputform'>&#xa0;</TD>
								<TD class='whiteRowFill'>&#xa0;</TD>
							</TR>
							<TR>
								<TD class='inputform'>
									<SPAN class='bold'>Detail:&#xa0;</SPAN>
								</TD>
								<TD class='whiteRowFill'>
									<DIV id='formEvent' runat='server' />
								</TD>
							</TR>
							<TR>
								<TD class='inputform'>&#xa0;</TD>
								<TD class='whiteRowFill'>&#xa0;</TD>
							</TR> 
						</TABLE>
					</TD></TR>
				</TABLE> 
				<BR/>
				<INPUT type='button' value='&#xa0; Close&#xa0; &#xa0;' onclick='refreshParent()'/>
			</DIV>
		&nbsp;
		</DIV>
	</DIV> <!-- End: popContent -->
<!--#include file='popup_closer.inc' -->
	</FORM>
</DIV> <!-- End: container -->
</BODY>
</HTML>