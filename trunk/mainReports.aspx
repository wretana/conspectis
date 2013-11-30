<%@Page Inherits="CIS.conspectisLibrary" src="conspectisLibrary.cs" Language="C#" debug="true" %>
<%@Import Namespace="System.Data"%>
<%@Import Namespace="System"%>

<!DOCTYPE html>
<!-- HTML5 Status: VALID 2-7-13 CK -->
<!--[if lt IE 7 ]> <html lang='en' class='no-js ie6'> <![endif]-->
<!--[if IE 7 ]>    <html lang='en' class='no-js ie7'> <![endif]-->
<!--[if IE 8 ]>    <html lang='en' class='no-js ie8'> <![endif]-->
<!--[if IE 9 ]>    <html lang='en' class='no-js ie9'> <![endif]-->
<!--[if (gt IE 9)|!(IE)]><!--> <html lang='en' class='no-js'> <!--<![endif]-->

<HEAD runat="server">

<!--#include file="header.inc"-->

<SCRIPT runat="server">
public void storeDC(object sender, EventArgs e)
{
	string code="", sql="", cookieVal="";
	code=dcSelector.Value;

//	Fetch cookie to determine if it needs to be set anew, or just updated ...
	try
	{
		cookieVal=Request.Cookies["selectedDc"].Value;
	}
	catch (System.Exception ex)
	{
		cookieVal="";
	}
	if (cookieVal=="") // Set new cookie ...
	{
		HttpCookie cookie=new HttpCookie("selectedDc",code);
		cookie.Expires=DateTime.Now.AddDays(3);
		Response.Cookies.Add(cookie);
	}
	else // Update existing coolie ...
	{
		HttpCookie cookie=Request.Cookies["selectedDc"];
		cookie.Value=code;
		Response.Cookies.Add(cookie);
	}

	//Now Fetch cookie to display its value ...
/*	try
	{
		cookieVal=Request.Cookies["selectedDc"].Value;
	}
	catch (System.Exception ex)
	{
		cookieVal="";
	}	
	Response.Write(cookieVal+"<BR/>"); */
	Response.Write("<script type='text/JavaScript'>document.location.reload("+"true);<"+"/script>");
}

public void Page_Load(Object o, EventArgs e)
{
//UNCOMMENT this line to force login to access this page.
	lockout(); Page.Header.Title=shortSysName+": Manage Reports";
	systemStatus(0); // Check to see if admin has put system is in offline mode.

//START Check if user is logged in by checking existence of cookie.
	loggedin.InnerHtml=loggedIn();
	adminMenu.InnerHtml=isAdmin();

	string sqlDialect=System.Configuration.ConfigurationManager.AppSettings["db_type"].ToString().ToUpper();

	DateTime dateStamp = DateTime.Now;
	string v_username, v_userclass, v_userrole, curStat="";
	string sql="", status="", color="", defaultDc="", sqlTablePrefix="";
	DataSet dat1;
	DataSet dat = new DataSet();

	sql="SELECT * FROM datacenters ORDER BY dcDesc ASC";
	dat=readDb(sql);
	string optionDesc="", optionVal="";
	if (dat!=null)
	{
		foreach(DataRow dr in dat.Tables[0].Rows)
		{
			if (dr["dcDesc"].ToString().Length>24)
			{
				optionDesc=dr["dcDesc"].ToString().Substring(0,20)+"...";
			}
			else
			{
				optionDesc=dr["dcDesc"].ToString();
			}
			optionVal=dr["dcPrefix"].ToString();
			ListItem lfind = null;
			lfind = dcSelector.Items.FindByValue(dr["dcPrefix"].ToString());
			if (lfind==null)
			{
				ListItem ladd = new ListItem(optionDesc, optionVal);
				dcSelector.Items.Add(ladd);
			}
		}	
	}
	bool fill;

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
		defaultDc = Request.Cookies["selectedDc"].Value;
	}
	catch (System.Exception ex)
	{
		defaultDc = "";
	}
	if (defaultDc=="*" || defaultDc=="")
	{
		sqlTablePrefix="*";
	}
	else
	{
		sqlTablePrefix=defaultDc;
	}

	titleSpan.InnerHtml="<SPAN class='heading1'>Reports</SPAN>";

	sql= "";
//	dat=readDb(sql);
	if (!IsPostBack)
	{
		string v_selectedDc="";
		try
		{
			v_selectedDc = Request.Cookies["selectedDc"].Value;
		}
		catch (System.Exception ex)
		{
			v_selectedDc = "";
		}
		dcSelector.SelectedIndex=dcSelector.Items.IndexOf(dcSelector.Items.FindByValue(v_selectedDc)); 

		if (v_userclass=="3" || v_userclass=="99")
		{
			addReport.InnerHtml = "<BUTTON id='addReportButn' onclick=\"window.open('addReport.aspx','newReportWin','width=400,height=425,menubar=no,status=yes,scrollbars=yes')\"><IMG src='./img/addIcon16.png' ALT='Add Report'/>&nbsp;Add Report &nbsp;</BUTTON>";
		}

		sql="SELECT DISTINCT(reportCategory) FROM reports";
		
		dat=readDb(sql);
		string blob;
		if (dat!=null)
		{
			blob="";
			foreach (DataTable dt in dat.Tables)
			{
				foreach (DataRow dr in dt.Rows)
				{

					blob=blob+"<SPAN class='heading2'>&#xa0; &#xa0; &#xa0; "+capitalize(dr["reportCategory"].ToString())+"</SPAN>";
					sql="SELECT * FROM reports WHERE reportCategory='"+dr["reportCategory"].ToString()+"'";
					dat1=readDb(sql);
					if (dat1!=null)
					{
						blob=blob+"<TABLE border='' style='width:95%'>";
						fill=false;
						foreach (DataTable dtt in dat1.Tables)
						{
							foreach (DataRow drr in dtt.Rows)
							{
								if (fill) { color="altRowFill";}
								else { color="whiteRowFill"; }
								blob=blob+"<TR class='lightColorFill'><TD colspan=3><A class='yellow' 	onclick=\"window.open('"+drr["reportFile"].ToString()+"','reportWin','width=650,height=800,menubar=no,status=yes,scrollbars=yes')\">&#xa0; "+drr["reportName"].ToString()+"</A></TD></TR>";
								blob=blob+"<TR class='"+color+"'><TD style='width:10%'><INPUT type='image' src='./img/reports_lg.png' onclick=\"window.open('"+drr["reportFile"].ToString()+"','reportWin','width=650,height=800,menubar=no,status=yes,scrollbars=yes')\" ALT='View Report'></TD><TD style='width:75%'>&#xa0; &#xa0; "+drr["reportDesc"].ToString()+" By: "+Decrypt(drr["addedBy"].ToString())+"</TD>";
								if (v_userclass=="3" || v_userclass=="99")
								{
									blob=blob+"<TD style='width:15%'><INPUT type='image' src='./img/edit_lg.png' onclick=\"window.open('addReport.aspx?report="+drr["reportId"].ToString()+"','editReportWin','width=400,height=400,menubar=no,status=yes,scrollbars=yes')\" ALT='Edit Report Info' /><INPUT type='image' src='./img/delete_lg.png' onclick=\"window.open('deleteReport.aspx?report="+drr["reportId"].ToString()+"','delReportWin','width=400,height=400,menubar=no,status=yes,scrollbars=yes')\" ALT='Delete Report' /></TD>";
								}
								blob=blob+"</TR>";
								fill=!fill;
							}
						}
						blob=blob+"</TABLE><BR/>"; 	
					}
				}
			}
			Place.InnerHtml=blob;
		}
	}

	if (IsPostBack)
	{

	}
}
</SCRIPT>
</HEAD>

<!--#include file="body.inc" -->
<FORM id='form1' runat='server'>
<DIV id='container'>
<!--#include file="banner.inc" -->
<!--#include file="menu.inc" -->
	<DIV id='content'>
		<SPAN id='titleSpan' runat='server'/>
		<DIV class='center'>
			<BR/><BR/>
			<SPAN id="addReport" runat="server"/>
			<BR/><BR/><BR/>
		</DIV>

		<DIV id="Place" runat="server"/>

		
	</DIV> <!-- End: content -->

<!--#include file="closer.inc"-->

</DIV> <!-- End: container -->
</FORM>
</BODY>
</HTML>