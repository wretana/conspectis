<%@Page Inherits="CIS.conspectisLibrary" src="conspectisLibrary.cs" Language="C#" debug="true" %>
<%@Import Namespace="System.Data.OleDb"%>
<%@Import Namespace="System.Collections"%>
<%@Import Namespace="System.Data"%>
<%@Import Namespace="System.IO"%>
<%@Import Namespace="System"%>

<!DOCTYPE html>
<!-- HTML5 Status: VALID 2-9-13 CK -->
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
	lockout(); Page.Header.Title=shortSysName+": Add Report";
	systemStatus(1); // Check to see if admin has put system is in offline mode.

	string sql,sqlErr;
	DataSet dat=new DataSet();
	HttpCookie cookie;
	bool sqlSuccess=true;
	string v_username;
	string reportPath="";
	string reportId="";

	DateTime dateStamp = DateTime.Now;

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
		reportId=Request.QueryString["report"].ToString();
	}
	catch (System.Exception ex)
	{
		reportId="";
	}

	reportPath=Server.MapPath("reports/");

	if (IsPostBack)
	{
		string v_file="";
		string v_name="";
		string v_category="";
		string v_description="";
		string status="";
		Response.Write(reportId);

		v_file=rptFiles.Value;
		v_name=rptName.Value;
		v_category=rptCat.Value;
		v_description=rptDesc.Value;

		sql="INSERT INTO reports (reportName,reportFile,addedBy,reportDesc,reportCategory) VALUES ('"+v_name+"','./reports/"+v_file+"','"+v_username+"','"+v_description+"','"+v_category+"')";
		status="added.";
		if (reportId!="")
		{
			sql="UPDATE reports SET reportName='"+v_name+"', reportFile='./reports/"+v_file+"', addedBy='"+v_username+"',reportDesc='"+v_description+"', reportCategory='"+v_category+"' WHERE reportId="+reportId;
			status="updated.";
		}
//		Response.Write(sql);
		sqlErr=writeDb(sql);
		if (sqlErr!=null && sqlErr!="")
		{
			sqlSuccess=false;
			errmsg.InnerHtml = "SQL Update Error - Add/Update Report<BR/>"+sqlErr;
		}
		else
		{	
			sqlErr="";
		}
		if (sqlSuccess) 
		{
			string statString="Report ["+v_name+"] "+status;
			sqlErr=writeChangeLog(dateStamp.ToString(), Decrypt(v_username.ToString()), statString.ToString());		
			if (sqlErr!=null && sqlErr!="")
			{
				sqlSuccess=false;
				errmsg.InnerHtml = "ChangeLog Update Error<BR/>"+sqlErr;
			}
			if (sqlErr==null || sqlErr=="")
			{
				Response.Write("<script>refreshParent("+");<"+"/script>");
			}
			else
			{
				errmsg.InnerHtml = "WARNING: "+sqlErr;
			}
		}
	}

	if (!IsPostBack)
	{
		DirectoryInfo di = new DirectoryInfo(reportPath);
		FileInfo[] files = di.GetFiles("*.aspx");
		foreach (FileInfo file in files)
		{
			rptFiles.Items.Add(new ListItem(file.Name));
		}
		rptFiles.Items.Insert(0, new ListItem("Choose...",""));
		
		
		rptCat.Items.Add(new ListItem("Capacity","capacity"));
		rptCat.Items.Add(new ListItem("Virtualization","virtualization"));
		rptCat.Items.Add(new ListItem("Projects","projects"));
		sql="SELECT DISTINCT(reportCategory) FROM reports WHERE reportCategory NOT IN ('capacity','virtualization','projects')";
		dat=readDb(sql);
		if (!emptyDataset(dat))
		{
			foreach (DataTable dt in dat.Tables)
			{
				foreach (DataRow dr in dt.Rows)
				{
					rptCat.Items.Add(new ListItem(dr["reportCategory"].ToString(),dr["reportCategory"].ToString()));
				}
			}
		}
		if (reportId!="")
		{
			sql="SELECT * FROM reports WHERE reportId="+reportId;
			dat=readDb(sql);
			if (!emptyDataset(dat))
			{
				string reportOut=dat.Tables[0].Rows[0]["reportFile"].ToString();
				string reportFix=reportOut.Replace("./reports/","");
//				Response.Write(reportOut+","+reportFix);
				rptFiles.SelectedIndex=rptFiles.Items.IndexOf(rptFiles.Items.FindByValue(reportFix));
				rptCat.SelectedIndex=rptCat.Items.IndexOf(rptCat.Items.FindByValue(dat.Tables[0].Rows[0]["reportCategory"].ToString()));
				rptName.Value=dat.Tables[0].Rows[0]["reportName"].ToString();
				rptDesc.Value=dat.Tables[0].Rows[0]["reportDesc"].ToString();
			}
		}
	}
	titleSpan.InnerHtml="Add Report";
}
</SCRIPT>
</HEAD>
<!--#include file='body.inc' -->
<DIV id='popContainer'>
<!--#include file='popup_opener.inc' -->
	<DIV id='popContent'>
		<DIV class='center altRowFill'>
			<SPAN id='titleSpan' runat='server'/>
			<DIV class='center'>
				<DIV id='errmsg' class='errorLine' runat='server'/>
			</DIV>
		</DIV>
		<DIV class='center paleColorFill'>		
			&#xa0;<BR/>
			<FORM runat='server'>
			<DIV class='center'>
				<TABLE border='1' class='datatable center'>
					<TR><TD class='center'>
						<TABLE>
							<TR><TD class='inputform'>&#xa0;</TD><TD class='whiteRowFill'>&#xa0;</TD></TR>
							<TR><TD class='inputform'>File:&#xa0;</TD><TD class='whiteRowFill'><SELECT id='rptFiles' runat='server' style='width:13em;'/></TD></TR>
							<TR><TD class='inputform'>Name:&#xa0;</TD><TD class='whiteRowFill'><INPUT type='text' id='rptName' size='25' runat='server'></TD></TR>
							<TR><TD class='inputform'>Category:&#xa0;</TD><TD class='whiteRowFill'><SELECT id='rptCat' runat='server' style='width:13em;'/></TD></TR>
							<TR><TD class='inputform'>&nbsp; Description:&#xa0;</TD><TD class='whiteRowFill'><TEXTAREA rows='5' cols='26' id='rptDesc' runat='server' /></TD></TR>					
							<TR><TD class='inputform'>&#xa0;</TD><TD class='whiteRowFill'>&#xa0;</TD></TR> 
						</TABLE>
					</TD></TR>
				</TABLE>
				<BR/>
				<INPUT type='submit' value='Save Changes' runat='server'/>&#xa0;<INPUT type='button' value='Cancel &amp; Close' onclick='refreshParent()'/>
				<BR/><BR/>
			</DIV>
			</FORM>
			&nbsp;<BR/>
		</DIV>
	</DIV> <!-- End: popContent -->
<!--#include file='popup_closer.inc' -->
</DIV> <!-- End: container -->
</BODY>
</HTML>