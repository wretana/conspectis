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
//	lockout(); 
	Page.Header.Title=shortSysName+": Offline";
	string sql, curStat;
	DataSet dat=new DataSet();
	string v_userclass;
	DateTime dateStamp = DateTime.Now;

	try
	{
		v_userclass=Request.Cookies["class"].Value;
	}
	catch (System.Exception ex)
	{
		v_userclass="1";
	}

	if (v_userclass=="3" || v_userclass=="99")
	{
		sysConLink.InnerHtml="<A class='black' href='systemConsole.aspx'>Go to System Console</A>";
	}

	sql="SELECT * FROM sysStat";
	dat=readDb(sql);
	if (!emptyDataset(dat))
	{
		curStat = dat.Tables[0].Rows[0]["code"].ToString();
		if (curStat=="0") // 0 is Down, 1 is Up
		{
			statLine.InnerHtml = "<SPAN style='font-size: 130%; color: #000000;'>The "+shortSysName+" System <BR/>Is Currently </SPAN><BR/><SPAN style='font-size: 200%; color: #fc0b0a; font-weight:bold;'>Offline</SPAN><BR/>";
			dateLine.InnerHtml=dat.Tables[0].Rows[0]["dateStamp"].ToString();
			msgLine.InnerHtml=dat.Tables[0].Rows[0]["comment"].ToString();
			adminLine.InnerHtml="-- "+dat.Tables[0].Rows[0]["userid"].ToString();
		}
	}
	else
	{
			statLine.InnerHtml = "<SPAN style='font-size: 130%; color: #000000;'>The "+shortSysName+" System <BR/>Is Currently </SPAN><BR/><SPAN style='font-size: 200%; color: #fc0b0a; font-weight:bold;'>Offline</SPAN><BR/>";
			dateLine.InnerHtml=dateStamp.ToString();
			msgLine.InnerHtml="The system is offline and the database is inaccessible.";
			adminLine.InnerHtml="-- The "+shortSysName+" Admin Team";
	}
	if (IsPostBack)
	{

	}

	titleSpan.InnerHtml="Offline";
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
				<DIV id='statLine' runat='server'/><BR/>
				<BR/><BR/>
				<TABLE style='width:200px' class='center'>
					<TR class='center'>
						<TD><DIV id='dateLine' class='bold' runat='server'/></TD>
					</TR>
					<TR><TD>&#xa0;</TD></TR>
					<TR class='justify'>
						<TD><DIV id='msgLine' runat='server'/></TD>
					</TR>
					<TR class='right'>
						<TD><DIV id='adminLine' class='italic' runat='server'/></TD>
					</TR>
				</TABLE>
				<BR/><BR/>
				<DIV id='sysConLink' runat='server'/>
			</DIV>
		&nbsp;<BR/>
		</DIV>
	</DIV> <!-- End: popContent -->
<!--#include file='popup_closer.inc' -->
	</FORM>
</DIV> <!-- End: container -->
</BODY>
</HTML>