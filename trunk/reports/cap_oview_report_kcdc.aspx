<%@Page Inherits="ESMS.esmsLibrary" src="../esmsLibrary.cs" Language="C#" debug="true" %>
<%@Register TagPrefix="Chart" TagName="ReportPieChart" Src="./ReportPieChart.ascx" %>
<%@Import namespace="System.Drawing" %>
<%@Import Namespace="System.Data.OleDb"%>
<%@Import Namespace="System.Data"%>
<%@Import Namespace="System"%>
<HTML>
<LINK REL="SHORTCUT ICON" HREF="../img/favicon.ico" />

<TITLE>ESMS: Report</TITLE>
<META NAME="description" CONTENT=""></META>
<META NAME="keywords" CONTENT=""></META>
<META NAME="Generator" CONTENT="EditPlus">
<META NAME="Author" CONTENT="Chris Knight">
<!--#include file="./reportStyles.inc" -->

<HEAD>
<SCRIPT runat="server">
void goVirtNitcDetail(Object s, EventArgs e) 
{
	HttpCookie cookie;
	string winSql, linSql, aixSql, rptTitle, lastpage;
	rptTitle="PHE Virtual Servers List";
	lastpage="cap_oview_report.aspx";
	winSql="SELECT * FROM (SELECT * FROM rackspace INNER JOIN servers ON servers.rackspaceId=rackspace.rackspaceId WHERE serverOS='Windows' AND class='Virtual') WHERE belongsTo IN('engineering_cluster','phe_cluster','phe_bigfix_cluster','phewod_cluster')";
	linSql="SELECT * FROM (SELECT * FROM rackspace INNER JOIN servers ON servers.rackspaceId=rackspace.rackspaceId WHERE serverOS='Linux' AND class='Virtual') WHERE belongsTo IN('engineering_cluster','phe_cluster','phe_bigfix_cluster','phewod_cluster')";
	aixSql="SELECT * FROM (SELECT * FROM rackspace INNER JOIN servers ON servers.rackspaceId=rackspace.rackspaceId WHERE serverOS='AIX' AND class='Virtual') WHERE serverName LIKE '%PHE%'";
	cookie=new HttpCookie("winSql",winSql);
	cookie.Expires=DateTime.Now.AddSeconds(90);
	Response.Cookies.Add(cookie);
	cookie=new HttpCookie("linSql",linSql);
	cookie.Expires=DateTime.Now.AddSeconds(90);
	Response.Cookies.Add(cookie);
	cookie=new HttpCookie("aixSql",aixSql);
	cookie.Expires=DateTime.Now.AddSeconds(90);
	Response.Cookies.Add(cookie);
	cookie=new HttpCookie("rptTitle",rptTitle);
	cookie.Expires=DateTime.Now.AddSeconds(90);
	Response.Cookies.Add(cookie);
	cookie=new HttpCookie("lastpage",lastpage);
	cookie.Expires=DateTime.Now.AddSeconds(90);
	Response.Cookies.Add(cookie);
	Response.Redirect("report_detail.aspx");
}

void goVirtPrpDetail(Object s, EventArgs e) 
{
	HttpCookie cookie;
	string winSql, linSql, aixSql, rptTitle, lastpage;
	rptTitle="PRP+QA Virtual Servers List";
	lastpage="cap_oview_report.aspx";
	winSql="SELECT * FROM (SELECT * FROM rackspace INNER JOIN servers ON servers.rackspaceId=rackspace.rackspaceId WHERE serverOS='Windows' AND class='Virtual') WHERE belongsTo IN('prp_cluster','qa_cluster')";
	linSql="SELECT * FROM (SELECT * FROM rackspace INNER JOIN servers ON servers.rackspaceId=rackspace.rackspaceId WHERE serverOS='Linux' AND class='Virtual') WHERE belongsTo IN('prp_cluster','qa_cluster')";
	aixSql="SELECT * FROM (SELECT * FROM rackspace INNER JOIN servers ON servers.rackspaceId=rackspace.rackspaceId WHERE serverOS='AIX' AND class='Virtual') WHERE serverName LIKE '%PRP%' OR serverName LIKE '%SVQA%'";
	cookie=new HttpCookie("winSql",winSql);
	cookie.Expires=DateTime.Now.AddSeconds(90);
	Response.Cookies.Add(cookie);
	cookie=new HttpCookie("linSql",linSql);
	cookie.Expires=DateTime.Now.AddSeconds(90);
	Response.Cookies.Add(cookie);
	cookie=new HttpCookie("aixSql",aixSql);
	cookie.Expires=DateTime.Now.AddSeconds(90);
	Response.Cookies.Add(cookie);
	cookie=new HttpCookie("rptTitle",rptTitle);
	cookie.Expires=DateTime.Now.AddSeconds(90);
	Response.Cookies.Add(cookie);
	cookie=new HttpCookie("lastpage",lastpage);
	cookie.Expires=DateTime.Now.AddSeconds(90);
	Response.Cookies.Add(cookie);
	Response.Redirect("report_detail.aspx");
}

void goPhysNitcDetail(Object s, EventArgs e) 
{
	HttpCookie cookie;
	string winSql, linSql, aixSql, rptTitle, lastpage;
	rptTitle="NITC/KCDC Physical Servers List";
	lastpage="cap_oview_report.aspx";
	winSql="SELECT * FROM (SELECT * FROM (SELECT * FROM (SELECT * FROM rackspace LEFT JOIN servers on servers.rackspaceId=rackspace.rackspaceId WHERE class<>'Virtual') WHERE serverOS IS NULL UNION (SELECT * FROM rackspace LEFT JOIN servers on servers.rackspaceId=rackspace.rackspaceId WHERE class<>'Virtual' AND serverOS NOT IN('RSA2','Network'))) WHERE reserved<>'1' AND serverOS='Windows' ORDER BY serverOS ASC)";
	linSql="SELECT * FROM (SELECT * FROM (SELECT * FROM (SELECT * FROM rackspace LEFT JOIN servers on servers.rackspaceId=rackspace.rackspaceId WHERE class<>'Virtual') WHERE serverOS IS NULL UNION (SELECT * FROM rackspace LEFT JOIN servers on servers.rackspaceId=rackspace.rackspaceId WHERE class<>'Virtual' AND serverOS NOT IN('RSA2','Network'))) WHERE reserved<>'1' AND serverOS IN ('Linux','ESX') ORDER BY serverOS ASC)";
	aixSql="SELECT * FROM (SELECT * FROM (SELECT * FROM (SELECT * FROM rackspace LEFT JOIN servers on servers.rackspaceId=rackspace.rackspaceId WHERE class<>'Virtual') WHERE serverOS IS NULL UNION (SELECT * FROM rackspace LEFT JOIN servers on servers.rackspaceId=rackspace.rackspaceId WHERE class<>'Virtual' AND serverOS NOT IN('RSA2','Network'))) WHERE reserved<>'1' AND serverOS='AIX' ORDER BY serverOS ASC)";
	cookie=new HttpCookie("winSql",winSql);
	cookie.Expires=DateTime.Now.AddSeconds(90);
	Response.Cookies.Add(cookie);
	cookie=new HttpCookie("linSql",linSql);
	cookie.Expires=DateTime.Now.AddSeconds(90);
	Response.Cookies.Add(cookie);
	cookie=new HttpCookie("aixSql",aixSql);
	cookie.Expires=DateTime.Now.AddSeconds(90);
	Response.Cookies.Add(cookie);
	cookie=new HttpCookie("rptTitle",rptTitle);
	cookie.Expires=DateTime.Now.AddSeconds(90);
	Response.Cookies.Add(cookie);
	cookie=new HttpCookie("lastpage",lastpage);
	cookie.Expires=DateTime.Now.AddSeconds(90);
	Response.Cookies.Add(cookie);
	Response.Redirect("report_detail.aspx");
}

void gophysNitcDetail(Object s, EventArgs e) 
{
	HttpCookie cookie;
	string winSql, linSql, aixSql, rptTitle, lastpage;
	rptTitle="PHE Physical Servers List";
	lastpage="cap_oview_report.aspx";
	winSql="SELECT * FROM(SELECT * FROM (SELECT * FROM (SELECT * FROM (SELECT * FROM rackspace LEFT JOIN servers on servers.rackspaceId=rackspace.rackspaceId WHERE class<>'Virtual') WHERE serverOS IS NULL UNION (SELECT * FROM rackspace LEFT JOIN servers on servers.rackspaceId=rackspace.rackspaceId WHERE class<>'Virtual' AND serverOS NOT IN('RSA2','Network'))) WHERE reserved<>'1' AND serverOS='Windows' ORDER BY serverOS ASC) WHERE serverName LIKE '%PHE%')";
	linSql="SELECT * FROM(SELECT * FROM (SELECT * FROM (SELECT * FROM (SELECT * FROM rackspace LEFT JOIN servers on servers.rackspaceId=rackspace.rackspaceId WHERE class<>'Virtual') WHERE serverOS IS NULL UNION (SELECT * FROM rackspace LEFT JOIN servers on servers.rackspaceId=rackspace.rackspaceId WHERE class<>'Virtual' AND serverOS NOT IN('RSA2','Network'))) WHERE reserved<>'1' AND serverOS IN ('Linux','ESX') ORDER BY serverOS ASC) WHERE serverName LIKE '%PHE%')";
	aixSql="SELECT * FROM(SELECT * FROM (SELECT * FROM (SELECT * FROM (SELECT * FROM rackspace LEFT JOIN servers on servers.rackspaceId=rackspace.rackspaceId WHERE class<>'Virtual') WHERE serverOS IS NULL UNION (SELECT * FROM rackspace LEFT JOIN servers on servers.rackspaceId=rackspace.rackspaceId WHERE class<>'Virtual' AND serverOS NOT IN('RSA2','Network'))) WHERE reserved<>'1' AND serverOS='AIX' ORDER BY serverOS ASC) WHERE serverName LIKE '%PHE%')";
	cookie=new HttpCookie("winSql",winSql);
	cookie.Expires=DateTime.Now.AddSeconds(90);
	Response.Cookies.Add(cookie);
	cookie=new HttpCookie("linSql",linSql);
	cookie.Expires=DateTime.Now.AddSeconds(90);
	Response.Cookies.Add(cookie);
	cookie=new HttpCookie("aixSql",aixSql);
	cookie.Expires=DateTime.Now.AddSeconds(90);
	Response.Cookies.Add(cookie);
	cookie=new HttpCookie("rptTitle",rptTitle);
	cookie.Expires=DateTime.Now.AddSeconds(90);
	Response.Cookies.Add(cookie);
	cookie=new HttpCookie("lastpage",lastpage);
	cookie.Expires=DateTime.Now.AddSeconds(90);
	Response.Cookies.Add(cookie);
	Response.Redirect("report_detail.aspx");
}

void goPhysPrpDetail(Object s, EventArgs e) 
{
	HttpCookie cookie;
	string winSql, linSql, aixSql, rptTitle, lastpage;
	rptTitle="PRP Physical Servers List";
	lastpage="cap_oview_report.aspx";
	winSql="SELECT * FROM(SELECT * FROM (SELECT * FROM (SELECT * FROM (SELECT * FROM rackspace LEFT JOIN servers on servers.rackspaceId=rackspace.rackspaceId WHERE class<>'Virtual') WHERE serverOS IS NULL UNION (SELECT * FROM rackspace LEFT JOIN servers on servers.rackspaceId=rackspace.rackspaceId WHERE class<>'Virtual' AND serverOS NOT IN('RSA2','Network'))) WHERE reserved<>'1' AND serverOS='Windows' ORDER BY serverOS ASC) WHERE serverName LIKE '%PRP%')";
	linSql="SELECT * FROM(SELECT * FROM (SELECT * FROM (SELECT * FROM (SELECT * FROM rackspace LEFT JOIN servers on servers.rackspaceId=rackspace.rackspaceId WHERE class<>'Virtual') WHERE serverOS IS NULL UNION (SELECT * FROM rackspace LEFT JOIN servers on servers.rackspaceId=rackspace.rackspaceId WHERE class<>'Virtual' AND serverOS NOT IN('RSA2','Network'))) WHERE reserved<>'1' AND serverOS IN ('Linux','ESX') ORDER BY serverOS ASC) WHERE serverName LIKE '%PRP%')";
	aixSql="SELECT * FROM(SELECT * FROM (SELECT * FROM (SELECT * FROM (SELECT * FROM rackspace LEFT JOIN servers on servers.rackspaceId=rackspace.rackspaceId WHERE class<>'Virtual') WHERE serverOS IS NULL UNION (SELECT * FROM rackspace LEFT JOIN servers on servers.rackspaceId=rackspace.rackspaceId WHERE class<>'Virtual' AND serverOS NOT IN('RSA2','Network'))) WHERE reserved<>'1' AND serverOS='AIX' ORDER BY serverOS ASC) WHERE serverName LIKE '%PRP%')";
	cookie=new HttpCookie("winSql",winSql);
	cookie.Expires=DateTime.Now.AddSeconds(90);
	Response.Cookies.Add(cookie);
	cookie=new HttpCookie("linSql",linSql);
	cookie.Expires=DateTime.Now.AddSeconds(90);
	Response.Cookies.Add(cookie);
	cookie=new HttpCookie("aixSql",aixSql);
	cookie.Expires=DateTime.Now.AddSeconds(90);
	Response.Cookies.Add(cookie);
	cookie=new HttpCookie("rptTitle",rptTitle);
	cookie.Expires=DateTime.Now.AddSeconds(90);
	Response.Cookies.Add(cookie);
	cookie=new HttpCookie("lastpage",lastpage);
	cookie.Expires=DateTime.Now.AddSeconds(90);
	Response.Cookies.Add(cookie);
	Response.Redirect("report_detail.aspx");
}

void goPhysQaDetail(Object s, EventArgs e) 
{
	HttpCookie cookie;
	string winSql, linSql, aixSql, rptTitle, lastpage;
	rptTitle="QA Physical Servers List";
	lastpage="cap_oview_report.aspx";
	winSql="SELECT * FROM(SELECT * FROM (SELECT * FROM (SELECT * FROM (SELECT * FROM rackspace LEFT JOIN servers on servers.rackspaceId=rackspace.rackspaceId WHERE class<>'Virtual') WHERE serverOS IS NULL UNION (SELECT * FROM rackspace LEFT JOIN servers on servers.rackspaceId=rackspace.rackspaceId WHERE class<>'Virtual' AND serverOS NOT IN('RSA2','Network'))) WHERE reserved<>'1' AND serverOS='Windows' ORDER BY serverOS ASC) WHERE serverName LIKE '%SXQA%')";
	linSql="SELECT * FROM(SELECT * FROM (SELECT * FROM (SELECT * FROM (SELECT * FROM rackspace LEFT JOIN servers on servers.rackspaceId=rackspace.rackspaceId WHERE class<>'Virtual') WHERE serverOS IS NULL UNION (SELECT * FROM rackspace LEFT JOIN servers on servers.rackspaceId=rackspace.rackspaceId WHERE class<>'Virtual' AND serverOS NOT IN('RSA2','Network'))) WHERE reserved<>'1' AND serverOS IN ('Linux','ESX') ORDER BY serverOS ASC) WHERE serverName LIKE '%SLQA%')";
	aixSql="SELECT * FROM(SELECT * FROM (SELECT * FROM (SELECT * FROM (SELECT * FROM rackspace LEFT JOIN servers on servers.rackspaceId=rackspace.rackspaceId WHERE class<>'Virtual') WHERE serverOS IS NULL UNION (SELECT * FROM rackspace LEFT JOIN servers on servers.rackspaceId=rackspace.rackspaceId WHERE class<>'Virtual' AND serverOS NOT IN('RSA2','Network'))) WHERE reserved<>'1' AND serverOS='AIX' ORDER BY serverOS ASC) WHERE serverName LIKE '%SVQA%')";
	cookie=new HttpCookie("winSql",winSql);
	cookie.Expires=DateTime.Now.AddSeconds(90);
	Response.Cookies.Add(cookie);
	cookie=new HttpCookie("linSql",linSql);
	cookie.Expires=DateTime.Now.AddSeconds(90);
	Response.Cookies.Add(cookie);
	cookie=new HttpCookie("aixSql",aixSql);
	cookie.Expires=DateTime.Now.AddSeconds(90);
	Response.Cookies.Add(cookie);
	cookie=new HttpCookie("rptTitle",rptTitle);
	cookie.Expires=DateTime.Now.AddSeconds(90);
	Response.Cookies.Add(cookie);
	cookie=new HttpCookie("lastpage",lastpage);
	cookie.Expires=DateTime.Now.AddSeconds(90);
	Response.Cookies.Add(cookie);
	Response.Redirect("report_detail.aspx");
}

public void Page_Load(Object o, EventArgs e)
{
	systemStatus(0); // Check to see if admin has put system is in offline mode.

	Response.Write("<script language='JavaScript'>function printWin() {window.print();} function refreshParent() { window.opener.location.href = window.opener.location.href; if (window.opener.progressWindow) { window.opener.progressWindow.close()  }  window.close();}//-->"+"<"+"/script>");

	string sql;
	DataSet dat;
	HttpCookie cookie;
	bool sqlSuccess=true;
	HtmlTableRow tr;
	HtmlTableCell td;
	bool fill;
	string bc, rack, os, env, srch;
	string v_userclass, v_hostname, v_ip, v_desc;

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
		v_hostname=Request.Cookies["hostname"].Value;
	}
	catch (System.Exception ex)
	{
		v_hostname="";
	}

	try
	{
		v_ip=Request.Cookies["ip"].Value;
	}
	catch (System.Exception ex)
	{
		v_ip="";
	}

	if (IsPostBack)
	{
	}

// WIDE USAGE QUERIES

// List of valid VM Clusters
// --------------------------------------------------------------
//	sql="SELECT DISTINCT(clusterName) FROM clusters WHERE clusterType='ESX'";

// List of Powered off VM's
// --------------------------------------------------------------
//	sql="SELECT * FROM servers WHERE VMPowerState='PoweredOff' ORDER BY memberOfCluster DESC";

// List of Physical rackspace and servers in ABQDC 
// --------------------------------------------------------------
//	sql="SELECT * FROM (SELECT * FROM (SELECT * FROM rackspace LEFT JOIN servers on servers.rackspaceId=rackspace.rackspaceId WHERE class<>'Virtual') WHERE serverOS IS NULL UNION (SELECT * FROM rackspace LEFT JOIN servers on servers.rackspaceId=rackspace.rackspaceId WHERE class<>'Virtual' AND serverOS NOT IN('RSA2','Network'))) WHERE reserved<>'1'" ORDER BY serverOS ASC";

// List of Virtual rackspace and servers in ABQDC
// --------------------------------------------------------------
//	sql="SELECT * FROM (SELECT * FROM (SELECT * FROM rackspace LEFT JOIN servers on servers.rackspaceId=rackspace.rackspaceId WHERE class='Virtual') WHERE serverOS IS NULL UNION (SELECT * FROM rackspace LEFT JOIN servers on servers.rackspaceId=rackspace.rackspaceId WHERE class='Virtual' AND serverOS NOT IN('RSA2','Network'))) WHERE reserved<>'1' ORDER BY serverOS ASC";

// List of basic server OS classes in use
// --------------------------------------------------------------
//	sql="SELECT DISTINCT(serverOs) FROM servers";
//
// Currently:
// AIX
// ESX
// Linux
// Network
// RSA2
// Windows

// List of servers for a given OS
// --------------------------------------------------------------
//	sql="SELECT * FROM servers WHERE serverOS='<OS>'";
//
// Currently:
// Linux - 556 (300)
// Windows - 443 (147)
// Network - 288
// RSA2 - 146 
// AIX - 83 (61)
// ESX - 44

// List of virtual servers for a given OS
// --------------------------------------------------------------
//	sql="SELECT * FROM rackspace INNER JOIN servers ON servers.rackspaceId=rackspace.rackspaceId WHERE serverOS='<OS>' AND class='Virtual'";
//
// Currently:
// Linux - 300
// Windows - 147
// AIX - 61

// Query Description
// --------------------------------------------------------------
//	sql="";

// Query Description
// --------------------------------------------------------------
//	sql="";





// VIRTUALIZATION CAPACITY REPORT QUERIES

// Number of Physical CPU's in a specified cluster
// --------------------------------------------------------------
//	sql="SELECT SUM(cpu_qty * cpu_cores) FROM rackspace LEFT JOIN servers ON rackspace.rackspaceId=servers.rackspaceId WHERE memberOfCluster='<CLUSTER NAME>' AND serverOs='ESX'";


// Amount of Physical RAM(in GB) in a specified cluster
// --------------------------------------------------------------
//  sql="SELECT SUM(ram) FROM rackspace LEFT JOIN servers ON rackspace.rackspaceId=servers.rackspaceId WHERE memberOfCluster='<CLUSTER NAME>' AND serverOs='ESX'";


// Amount of Virtual RAM assigned(in GB) in a specified cluster
// --------------------------------------------------------------
//  sql="SELECT SUM(ram) FROM rackspace LEFT JOIN servers ON rackspace.rackspaceId=servers.rackspaceId WHERE memberOfCluster='<CLUSTER NAME>' AND serverOs<>'ESX'";


// Get valid physical CPU Types in a cluster
// --------------------------------------------------------------
//  sql="SELECT DISTINCT(cpu_type) FROM rackspace LEFT JOIN servers ON rackspace.rackspaceId=servers.rackspaceId WHERE memberOfCluster='<CLUSTER NAME>' AND serverOs='ESX'";


// Count of vCPU's in a given cluster
// --------------------------------------------------------------
// sql="SELECT SUM(cpu_qty * cpu_cores) FROM rackspace LEFT JOIN servers ON rackspace.rackspaceId=servers.rackspaceId WHERE memberOfCluster='<CLUSTER NAME>' AND serverOs<>'ESX'";


// Datastore Capacity metrics
// --------------------------------------------------------------
// sql="SELECT * FROM datastores ORDER BY name ASC";







// VMWARE TOOLS REPORT QUERIES

// Virtual Servers definetly without VMWare Tools (powered on and VmTools not running)
// --------------------------------------------------------------
//  sql="SELECT serverName, serverLanIp, VMToolsState, VMPowerState FROM (SELECT * FROM rackspace LEFT JOIN servers ON rackspace.rackspaceId=servers.rackspaceId WHERE memberOfCluster='<CLUSTER NAME>' AND serverOs<>'ESX') WHERE VMPowerState='PoweredOn' AND VMToolsState<>'Running'";


// Virtual Servers possibly without VMWare Tools (powered off and VmTools not running)
// --------------------------------------------------------------
//  sql="SELECT serverName, serverLanIp, VMToolsState, VMPowerState FROM (SELECT * FROM rackspace LEFT JOIN servers ON rackspace.rackspaceId=servers.rackspaceId WHERE memberOfCluster='<CLUSTER NAME>' AND serverOs<>'ESX') WHERE VMPowerState<>'PoweredOn' AND VMToolsState<>'Running'";


// Virtual Servers not reporting VMWare Tools Version correctly (PoweredOn, Running, yet no Version)
// --------------------------------------------------------------
//  sql="SELECT serverName, serverLanIp, VMToolsState, VMPowerState FROM (SELECT * FROM rackspace LEFT JOIN servers ON rackspace.rackspaceId=servers.rackspaceId WHERE memberOfCluster='<CLUSTER NAME>' AND serverOs<>'ESX') WHERE VMPowerState='PoweredOn' AND VMToolsState='Running' AND VMToolsVer IS NULL";


// Get Current VMWare Tools Version for Linux
// --------------------------------------------------------------
//  sql="SELECT MAX(VMToolsVersion) FROM (SELECT * FROM servers WHERE serverName LIKE 'SLPHEVM%' ORDER BY VMToolsVersion DESC)";

// Get Current VMWare Tools Version for Windows
// --------------------------------------------------------------
//  sql="SELECT MAX(VMToolsVersion) FROM (SELECT * FROM servers WHERE serverName LIKE 'SXPHEVM%' ORDER BY VMToolsVersion DESC)";

// Get Current VMWare Tools Version for Windows
// --------------------------------------------------------------
//  sql="SELECT * FROM (SELECT (VMSysDiskFreeMB / VMSysDiskCapMB AS FreeCap) FROM (SELECT serverName, serverLanIp, VMSysDiskCapMB, VMSysDiskFreeMB FROM servers WHERE VMSysDiskCapMB IS NOT NULL AND VMSysDiskFreeMB IS NOT NULL AND VMSysDiskCapMB<>0 AND VMSysDiskFreeMB<>0)) WHERE FreeCap>.20";



//
//
	float totalServerRackspace, totalVirtRackspace, totalPhysRackspace, totalFreeRackspace;

	sql="SELECT COUNT(*) FROM (SELECT * FROM (SELECT * FROM (SELECT * FROM rackspace LEFT JOIN servers on servers.rackspaceId=rackspace.rackspaceId WHERE class<>'Virtual') WHERE serverOS IS NULL UNION (SELECT * FROM rackspace LEFT JOIN servers on servers.rackspaceId=rackspace.rackspaceId WHERE class<>'Virtual' AND serverOS NOT IN('RSA2','Network'))) WHERE reserved<>'1' ORDER BY serverOS ASC) WHERE servers.rackspaceId IS NULL";
	dat=readDb(sql);
	if (dat!=null)
	{
		totalFreeRackspace=Convert.ToSingle(dat.Tables[0].Rows[0]["Expr1000"].ToString());
	}
	else
	{
		totalFreeRackspace=0;
	}

	sql="SELECT COUNT(*) FROM (SELECT * FROM (SELECT * FROM (SELECT * FROM rackspace LEFT JOIN servers on servers.rackspaceId=rackspace.rackspaceId WHERE class<>'Virtual') WHERE serverOS IS NULL UNION (SELECT * FROM rackspace LEFT JOIN servers on servers.rackspaceId=rackspace.rackspaceId WHERE class<>'Virtual' AND serverOS NOT IN('RSA2','Network'))) WHERE reserved<>'1' ORDER BY serverOS ASC)";
	dat=readDb(sql);
	if (dat!=null)
	{
		totalPhysRackspace=Convert.ToSingle(dat.Tables[0].Rows[0]["Expr1000"].ToString())-totalFreeRackspace; 
	}
		else
	{
		totalPhysRackspace=0;
	}

	sql="SELECT COUNT(*) FROM (SELECT * FROM (SELECT * FROM (SELECT * FROM rackspace LEFT JOIN servers on servers.rackspaceId=rackspace.rackspaceId WHERE class='Virtual') WHERE serverOS IS NULL UNION (SELECT * FROM rackspace LEFT JOIN servers on servers.rackspaceId=rackspace.rackspaceId WHERE class='Virtual' AND serverOS NOT IN('RSA2','Network'))) WHERE reserved<>'1' ORDER BY serverOS ASC)";
	dat=readDb(sql);
	if (dat!=null)
	{
		totalVirtRackspace=Convert.ToSingle(dat.Tables[0].Rows[0]["Expr1000"].ToString());
	}
	else
	{
		totalVirtRackspace=0;
	}


	totalServerRackspace=totalPhysRackspace+totalFreeRackspace+totalVirtRackspace;

	reportTitle.InnerHtml="NITC/KCDC Capacity Overview";

// ------ Capacity Overview Pie Chart Builder

	double overviewCapacityElement1Value, overviewCapacityElement2Value, overviewCapacityElement3Value, overviewCapacityElement4Value;

	overviewCapacityElement1Value=Math.Round(((totalPhysRackspace/totalServerRackspace)*100) + 2/10.0,2);
	overviewCapacityElement2Value=Math.Round(((totalFreeRackspace/totalServerRackspace)*100) + 2/10.0,2);
	overviewCapacityElement3Value=Math.Round(((totalVirtRackspace/totalServerRackspace)*100) + 2/10.0,2);

	ReportPieChart_ascx.PieChartElement overviewCapacityElement1 = new ReportPieChart_ascx.PieChartElement();
	ReportPieChart_ascx.PieChartElement overviewCapacityElement2 = new ReportPieChart_ascx.PieChartElement();
	ReportPieChart_ascx.PieChartElement overviewCapacityElement3 = new ReportPieChart_ascx.PieChartElement();

	overviewCapacityElement1.Name = "Physical";
	overviewCapacityElement1.Percent = overviewCapacityElement1Value;
	overviewCapacityElement1.Color = Color.FromArgb(0, 0, 255);
	OverviewCapacityPieChart.addPieChartElement(overviewCapacityElement1);

	overviewCapacityElement3.Name = "Physical(Free)";
	overviewCapacityElement3.Percent = overviewCapacityElement2Value;
	overviewCapacityElement3.Color = Color.FromArgb(255, 0, 0);
	OverviewCapacityPieChart.addPieChartElement(overviewCapacityElement3);

	overviewCapacityElement2.Name = "Virtual";
	overviewCapacityElement2.Percent = overviewCapacityElement3Value;
	overviewCapacityElement2.Color = Color.FromArgb(0, 255, 0);
	OverviewCapacityPieChart.addPieChartElement(overviewCapacityElement2);
        
	OverviewCapacityPieChart.ChartTitle = "";
	OverviewCapacityPieChart.ImageAlt = "ReportChart";
	OverviewCapacityPieChart.ImageWidth = 300;
	OverviewCapacityPieChart.ImageHeight = 175;

	OverviewCapacityPieChart.generateChartImage();

	overviewCapacityMeta.InnerHtml="<B>Total Server Rackspace in NITC/KCDC:</B> "+totalServerRackspace.ToString()+"<BR><BR><B>Physical Servers in NITC/KCDC:</B> "+totalPhysRackspace.ToString()+"<BR>&nbsp &nbsp <B>Free Physical Rackspace in NITC/KCDC:</B> "+totalFreeRackspace.ToString()+"<BR><BR><B>Virtual Servers in NITC/KCDC:</B> "+totalVirtRackspace.ToString()+"<BR><BR><B><FONT size='+1'>NITC/KCDC IS "+Math.Round(((totalVirtRackspace/totalServerRackspace)*100) + 2/10.0,2)+"% VIRTUAL</FONT</B>";

// ------ Virtual NITC Detail Pie Chart Builder

	float nitcWinVirtServers, nitcLinVirtServers, nitcAixVirtServers, nitcTotalVirtServers;

	sql="SELECT COUNT(*) FROM (SELECT * FROM rackspace INNER JOIN servers ON servers.rackspaceId=rackspace.rackspaceId WHERE serverOS='Windows' AND class='Virtual') WHERE belongsTo IN('MCI_Cluster')";
	dat=readDb(sql);
	if (dat!=null)
	{
		nitcWinVirtServers=Convert.ToSingle(dat.Tables[0].Rows[0]["Expr1000"].ToString());
	}
	else
	{
		nitcWinVirtServers=0;
	}

	sql="SELECT COUNT(*) FROM (SELECT * FROM rackspace INNER JOIN servers ON servers.rackspaceId=rackspace.rackspaceId WHERE serverOS='Linux' AND class='Virtual') WHERE belongsTo IN('MCI_Cluster')";
	dat=readDb(sql);
	if (dat!=null)
	{
		nitcLinVirtServers=Convert.ToSingle(dat.Tables[0].Rows[0]["Expr1000"].ToString());
	}
	else
	{
		nitcLinVirtServers=0;
	}

	sql="SELECT COUNT(*) FROM (SELECT * FROM rackspace INNER JOIN servers ON servers.rackspaceId=rackspace.rackspaceId WHERE serverOS='AIX' AND class='Virtual')";
	dat=readDb(sql);
	if (dat!=null)
	{
		nitcAixVirtServers=Convert.ToSingle(dat.Tables[0].Rows[0]["Expr1000"].ToString());
	}
	else
	{
		nitcAixVirtServers=0;
	}
	
	nitcTotalVirtServers=nitcWinVirtServers+nitcLinVirtServers+nitcAixVirtServers;

	double virtNitcDetailElement1Value, virtNitcDetailElement2Value, virtNitcDetailElement3Value, virtNitcDetailElement4Value;

	virtNitcDetailElement1Value=Math.Round(((nitcLinVirtServers/nitcTotalVirtServers)*100) + 2/10.0,2);
	virtNitcDetailElement2Value=Math.Round(((nitcWinVirtServers/nitcTotalVirtServers)*100) + 2/10.0,2);
	virtNitcDetailElement3Value=Math.Round(((nitcAixVirtServers/nitcTotalVirtServers)*100) + 2/10.0,2);

	ReportPieChart_ascx.PieChartElement virtNitcDetailElement1 = new ReportPieChart_ascx.PieChartElement();
	ReportPieChart_ascx.PieChartElement virtNitcDetailElement2 = new ReportPieChart_ascx.PieChartElement();
	ReportPieChart_ascx.PieChartElement virtNitcDetailElement3 = new ReportPieChart_ascx.PieChartElement();

	virtNitcDetailElement1.Name = "Linux";
	virtNitcDetailElement1.Percent = virtNitcDetailElement1Value;
	virtNitcDetailElement1.Color = Color.FromArgb(255, 128, 0);
	VirtNitcDetailPieChart.addPieChartElement(virtNitcDetailElement1);

	virtNitcDetailElement3.Name = "Windows";
	virtNitcDetailElement3.Percent = virtNitcDetailElement2Value;
	virtNitcDetailElement3.Color = Color.FromArgb(255, 165, 075);
	VirtNitcDetailPieChart.addPieChartElement(virtNitcDetailElement3);

	virtNitcDetailElement2.Name = "AIX";
	virtNitcDetailElement2.Percent = virtNitcDetailElement3Value;
	virtNitcDetailElement2.Color = Color.FromArgb(255, 200, 150);
	VirtNitcDetailPieChart.addPieChartElement(virtNitcDetailElement2);
       
	VirtNitcDetailPieChart.ChartTitle = "";
	VirtNitcDetailPieChart.ImageAlt = "NITC Virtualization Breakdown";
	VirtNitcDetailPieChart.ImageWidth = 225;
	VirtNitcDetailPieChart.ImageHeight = 132;

	VirtNitcDetailPieChart.BackgroundColor=0x78EDF0F3;

	VirtNitcDetailPieChart.generateChartImage();

	string vmsSql="", hostsSql="", winVmsSql="", linVmsSql="", aixVmsSql="";
	string vmsCount="", hostsCount="", clusterDensity="", winVmsCount="", linVmsCount="", aixVmsCount="";
	DataSet dat1, dat2, dat3, dat4, dat5;
	DataSet clusterDat = new DataSet();


	string virtNitcCluster="", virtNitcClusters="", virtNitcClusterVmCount="", virtNitcClusterHostCount="";
	string virtNitcDetailMetaString;
	virtNitcDetailMetaString="<CENTER><TABLE border='0' cellspacing='0' cellpadding='0' class='CTRTABLE'><TR><TH class='UNDER'>Clusters</TH><TH class='UNDER'>VMs&nbsp</TH><TH class='UNDER'>Hosts&nbsp</TH><TH class='UNDER'>VMs / Host</TH></TR>";
	sql="SELECT DISTINCT(clusterName) FROM clusters WHERE clusterType='ESX' AND clusterName LIKE '%MCI%'";
	dat=readDb(sql);
	if (dat!=null)
	{
		foreach (DataTable dt in dat.Tables)
		{

			clusterDat.Tables.Add("Clusters");
			clusterDat.Tables["Clusters"].Columns.Add("Cluster", typeof(string));
			clusterDat.Tables["Clusters"].Columns.Add("VMs", typeof(string));
			clusterDat.Tables["Clusters"].Columns.Add("Hosts", typeof(string));
			clusterDat.Tables["Clusters"].Columns.Add("Density", typeof(string));
			clusterDat.Tables["Clusters"].Columns.Add("Win", typeof(string));
			clusterDat.Tables["Clusters"].Columns.Add("Lin", typeof(string));
			clusterDat.Tables["Clusters"].Columns.Add("AIX", typeof(string));

			foreach (DataRow dr in dt.Rows)
			{
				DataRow clusterRow = clusterDat.Tables["Clusters"].NewRow();
				virtNitcCluster=dr["clusterName"].ToString();

				vmsSql="SELECT COUNT(*) AS vmCount FROM (SELECT * FROM rackspace INNER JOIN servers ON servers.rackspaceId=rackspace.rackspaceId WHERE serverOS IN('Windows','Linux') AND class='Virtual') WHERE belongsTo='"+virtNitcCluster+"'";
				hostsSql="SELECT COUNT(*) AS hostCount FROM (SELECT * FROM rackspace INNER JOIN servers ON servers.rackspaceId=rackspace.rackspaceId WHERE serverOS IN('ESX')) WHERE memberOfCluster='"+virtNitcCluster+"'";
				winVmsSql="SELECT COUNT(*) AS winCount FROM (SELECT * FROM rackspace INNER JOIN servers ON servers.rackspaceId=rackspace.rackspaceId WHERE serverOS='Windows' AND class='Virtual') WHERE belongsTo='"+virtNitcCluster+"'";
				linVmsSql="SELECT COUNT(*) AS linCount FROM (SELECT * FROM rackspace INNER JOIN servers ON servers.rackspaceId=rackspace.rackspaceId WHERE serverOS='Linux' AND class='Virtual') WHERE belongsTo='"+virtNitcCluster+"'";
				aixVmsSql="SELECT COUNT(*) AS aixCount FROM (SELECT * FROM rackspace INNER JOIN servers ON servers.rackspaceId=rackspace.rackspaceId WHERE serverOS='AIX' AND class='Virtual') WHERE serverName LIKE '%PHE%'";

				dat1=readDb(vmsSql);
				dat2=readDb(hostsSql);
				dat3=readDb(winVmsSql);
				dat4=readDb(linVmsSql);
				dat5=readDb(aixVmsSql);

				if (dat1!=null)
				{
					vmsCount=dat1.Tables[0].Rows[0]["vmCount"].ToString();
				}
				else
				{
					vmsCount="0";
				}
				if (dat2!=null)
				{
					hostsCount=dat2.Tables[0].Rows[0]["hostCount"].ToString();
				}
				else
				{
					hostsCount="0";
				}
				if (dat3!=null)
				{
					winVmsCount=dat3.Tables[0].Rows[0]["winCount"].ToString();
				}
				else
				{
					winVmsCount="0";
				}
				if (dat4!=null)
				{
					linVmsCount=dat4.Tables[0].Rows[0]["linCount"].ToString();
				}
				else
				{
					linVmsCount="0";
				}
				if (dat5!=null)
				{
					aixVmsCount=dat5.Tables[0].Rows[0]["aixCount"].ToString();
				}
				else
				{
					aixVmsCount="0";
				}
			
				clusterRow["Cluster"]=virtNitcCluster;
				clusterRow["VMs"]=vmsCount;
				clusterRow["Hosts"]=hostsCount;
				clusterRow["Density"]=(Convert.ToInt32(vmsCount)/Convert.ToInt32(hostsCount)).ToString();
				clusterRow["Win"]=winVmsCount;
				clusterRow["Lin"]=linVmsCount;
				clusterRow["AIX"]=aixVmsCount;

				clusterDat.Tables["Clusters"].Rows.Add(clusterRow);
			}
		}
	}
	if (clusterDat!=null)
	{
		foreach (DataTable dt in clusterDat.Tables)
		{
			foreach (DataRow dr in dt.Rows)
			{
				virtNitcDetailMetaString=virtNitcDetailMetaString+"<TR><TD style='text-align:left'>"+dr["Cluster"].ToString()+"</TD><TD>"+dr["VMs"].ToString()+"</TD><TD>"+dr["Hosts"].ToString()+"</TD><TD>"+dr["Density"].ToString()+"</TD></TR>";
			}
		}
	}
	virtNitcDetailMetaString=virtNitcDetailMetaString+"<TR><TD></TD><TD></TD><TD></TD><TD></TD></TR>";
	virtNitcDetailMetaString=virtNitcDetailMetaString+"<TR><TD>&nbsp</TD></TR>";
	virtNitcDetailMetaString=virtNitcDetailMetaString+"<TR><TH colspan='4'>Breakdown By OS</TH></TR>";
	virtNitcDetailMetaString=virtNitcDetailMetaString+"<TR><TH class='UNDER'>&nbsp</TH><TH class='UNDER'>Lin</TH><TH class='UNDER'>Win</TH><TH class='UNDER'>AIX</TH></TR>";
	if (clusterDat!=null)
	{
		foreach (DataTable dt in clusterDat.Tables)
		{
			foreach (DataRow dr in dt.Rows)
			{
				virtNitcDetailMetaString=virtNitcDetailMetaString+"<TR><TD style='text-align:left'>"+dr["Cluster"].ToString()+"</TD><TD>"+dr["Lin"].ToString()+"</TD><TD>"+dr["Win"].ToString()+"</TD><TD>&nbsp</TD></TR>";
			}
		}
	}
	virtNitcDetailMetaString=virtNitcDetailMetaString+"<TR><TD style='text-align:left'>MPARS/LPARS</TD><TD>&nbsp</TD><TD>&nbsp</TD><TD>"+clusterDat.Tables[0].Rows[0]["AIX"].ToString()+"</TD></TR>";
	virtNitcDetailMetaString=virtNitcDetailMetaString+"<TR><TD></TD><TD></TD><TD></TD><TD></TD></TR>";
	virtNitcDetailMetaString=virtNitcDetailMetaString+"</TABLE></CENTER>";


	virtNitcDetailMeta.InnerHtml=virtNitcDetailMetaString;
	clusterDat.Reset();


// ------ Physical ABQDC Detail Pie Chart Builder

	float nitcWinPhysServers, nitcLinPhysServers, nitcAixPhysServers;

	sql="SELECT COUNT(*) FROM (SELECT * FROM (SELECT * FROM (SELECT * FROM rackspace LEFT JOIN servers on servers.rackspaceId=rackspace.rackspaceId WHERE class<>'Virtual') WHERE serverOS IS NULL UNION (SELECT * FROM rackspace LEFT JOIN servers on servers.rackspaceId=rackspace.rackspaceId WHERE class<>'Virtual' AND serverOS NOT IN('RSA2','Network'))) WHERE reserved<>'1' AND serverOS='Windows' ORDER BY serverOS ASC)";
	dat=readDb(sql);
	if (dat!=null)
	{
		nitcWinPhysServers=Convert.ToSingle(dat.Tables[0].Rows[0]["Expr1000"].ToString());
	}
	else
	{
		nitcWinPhysServers=0;
	}

	sql="SELECT COUNT(*) FROM (SELECT * FROM (SELECT * FROM (SELECT * FROM rackspace LEFT JOIN servers on servers.rackspaceId=rackspace.rackspaceId WHERE class<>'Virtual') WHERE serverOS IS NULL UNION (SELECT * FROM rackspace LEFT JOIN servers on servers.rackspaceId=rackspace.rackspaceId WHERE class<>'Virtual' AND serverOS NOT IN('RSA2','Network'))) WHERE reserved<>'1' AND serverOS IN ('Linux','ESX') ORDER BY serverOS ASC)";
	dat=readDb(sql);
	if (dat!=null)
	{
		nitcLinPhysServers=Convert.ToSingle(dat.Tables[0].Rows[0]["Expr1000"].ToString());
	}
	else
	{
		nitcLinPhysServers=0;
	}

	sql="SELECT COUNT(*) FROM (SELECT * FROM (SELECT * FROM (SELECT * FROM rackspace LEFT JOIN servers on servers.rackspaceId=rackspace.rackspaceId WHERE class<>'Virtual') WHERE serverOS IS NULL UNION (SELECT * FROM rackspace LEFT JOIN servers on servers.rackspaceId=rackspace.rackspaceId WHERE class<>'Virtual' AND serverOS NOT IN('RSA2','Network'))) WHERE reserved<>'1' AND serverOS='AIX' ORDER BY serverOS ASC)";
	dat=readDb(sql);
	if (dat!=null)
	{
		nitcAixPhysServers=Convert.ToSingle(dat.Tables[0].Rows[0]["Expr1000"].ToString());
	}
	else
	{
		nitcAixPhysServers=0;
	}
	
	double physNitcDetailElement1Value, physNitcDetailElement2Value, physNitcDetailElement3Value, physNitcDetailElement4Value;

	physNitcDetailElement1Value=Math.Round(((nitcLinPhysServers/totalPhysRackspace)*100) + 2/10.0,2);
	physNitcDetailElement2Value=Math.Round(((nitcWinPhysServers/totalPhysRackspace)*100) + 2/10.0,2);
	physNitcDetailElement3Value=Math.Round(((nitcAixPhysServers/totalPhysRackspace)*100) + 2/10.0,2);

	ReportPieChart_ascx.PieChartElement physNitcDetailElement1 = new ReportPieChart_ascx.PieChartElement();
	ReportPieChart_ascx.PieChartElement physNitcDetailElement2 = new ReportPieChart_ascx.PieChartElement();
	ReportPieChart_ascx.PieChartElement physNitcDetailElement3 = new ReportPieChart_ascx.PieChartElement();

	physNitcDetailElement1.Name = "Linux";
	physNitcDetailElement1.Percent = physNitcDetailElement1Value;
	physNitcDetailElement1.Color = Color.FromArgb(0, 128, 255);
	PhysNitcDetailPieChart.addPieChartElement(physNitcDetailElement1);

	physNitcDetailElement3.Name = "Windows";
	physNitcDetailElement3.Percent = physNitcDetailElement2Value;
	physNitcDetailElement3.Color = Color.FromArgb(90, 175, 255);
	PhysNitcDetailPieChart.addPieChartElement(physNitcDetailElement3);

	physNitcDetailElement2.Name = "AIX";
	physNitcDetailElement2.Percent = physNitcDetailElement3Value;
	physNitcDetailElement2.Color = Color.FromArgb(165, 210, 255);
	PhysNitcDetailPieChart.addPieChartElement(physNitcDetailElement2);
      
	PhysNitcDetailPieChart.ChartTitle = "";
	PhysNitcDetailPieChart.ImageAlt = "NITC Physical Breakdown";
	PhysNitcDetailPieChart.ImageWidth = 225;
	PhysNitcDetailPieChart.ImageHeight = 132;

	PhysNitcDetailPieChart.generateChartImage();

	string winSrvSql="", linSrvSql="", aixSrvSql="";
	string winSrvCount="", linSrvCount="", aixSrvCount="";
	DataSet srvDat = new DataSet();

	string PhysNitcDetailMetaString;

	PhysNitcDetailMetaString="<CENTER><TABLE border='0' cellspacing='0' cellpadding='0' class='CTRTABLE'>";
	srvDat.Tables.Add("Servers");
	srvDat.Tables["Servers"].Columns.Add("Win", typeof(string));
	srvDat.Tables["Servers"].Columns.Add("Lin", typeof(string));
	srvDat.Tables["Servers"].Columns.Add("AIX", typeof(string));
	DataRow srvRow = srvDat.Tables["Servers"].NewRow();


	winSrvSql="SELECT COUNT(*) AS winCount FROM (SELECT * FROM (SELECT * FROM (SELECT * FROM rackspace LEFT JOIN servers on servers.rackspaceId=rackspace.rackspaceId WHERE class<>'Virtual') WHERE serverOS IS NULL UNION (SELECT * FROM rackspace LEFT JOIN servers on servers.rackspaceId=rackspace.rackspaceId WHERE class<>'Virtual' AND serverOS NOT IN('RSA2','Network'))) WHERE reserved<>'1' AND serverOS='Windows' ORDER BY serverOS ASC)";
	linSrvSql="SELECT COUNT(*) AS linCount FROM (SELECT * FROM (SELECT * FROM (SELECT * FROM rackspace LEFT JOIN servers on servers.rackspaceId=rackspace.rackspaceId WHERE class<>'Virtual') WHERE serverOS IS NULL UNION (SELECT * FROM rackspace LEFT JOIN servers on servers.rackspaceId=rackspace.rackspaceId WHERE class<>'Virtual' AND serverOS NOT IN('RSA2','Network'))) WHERE reserved<>'1' AND serverOS IN ('Linux','ESX') ORDER BY serverOS ASC)";
	aixSrvSql="SELECT COUNT(*) AS aixCount FROM (SELECT * FROM (SELECT * FROM (SELECT * FROM rackspace LEFT JOIN servers on servers.rackspaceId=rackspace.rackspaceId WHERE class<>'Virtual') WHERE serverOS IS NULL UNION (SELECT * FROM rackspace LEFT JOIN servers on servers.rackspaceId=rackspace.rackspaceId WHERE class<>'Virtual' AND serverOS NOT IN('RSA2','Network'))) WHERE reserved<>'1' AND serverOS='AIX' ORDER BY serverOS ASC)";

	dat3=readDb(winSrvSql);
	dat4=readDb(linSrvSql);
	dat5=readDb(aixSrvSql);

	if (dat3!=null)
	{
		winSrvCount=dat3.Tables[0].Rows[0]["winCount"].ToString();
	}
	else
	{
		winSrvCount="0";
	}
	if (dat4!=null)
	{
		linSrvCount=dat4.Tables[0].Rows[0]["linCount"].ToString();
	}
	else
	{
		linSrvCount="0";
	}
	if (dat5!=null)
	{
		aixSrvCount=dat5.Tables[0].Rows[0]["aixCount"].ToString();
	}
	else
	{
		aixSrvCount="0";
	}

	srvRow["Win"]=winSrvCount;
	srvRow["Lin"]=linSrvCount;
	srvRow["AIX"]=aixSrvCount;
	srvDat.Tables["Servers"].Rows.Add(srvRow);

	PhysNitcDetailMetaString=PhysNitcDetailMetaString+"<TR><TH colspan='4'>Breakdown By OS&nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp</TH></TR>";
	PhysNitcDetailMetaString=PhysNitcDetailMetaString+"<TR><TH class='UNDER'>&nbsp</TH><TH class='UNDER'>Lin&nbsp &nbsp</TH><TH class='UNDER'>Win&nbsp &nbsp</TH><TH class='UNDER'>AIX&nbsp &nbsp</TH></TR>";
	PhysNitcDetailMetaString=PhysNitcDetailMetaString+"<TR><TD style='text-align:left'>NITC/KCDC Phys. Servers</TD><TD>"+srvDat.Tables[0].Rows[0]["Win"].ToString()+"</TD><TD>"+srvDat.Tables[0].Rows[0]["Lin"].ToString()+"</TD><TD>"+srvDat.Tables[0].Rows[0]["AIX"].ToString()+"</TD></TR>";
	PhysNitcDetailMetaString=PhysNitcDetailMetaString+"<TR><TD></TD><TD></TD><TD></TD><TD></TD></TR>";
	PhysNitcDetailMetaString=PhysNitcDetailMetaString+"</TABLE></CENTER>";


	PhysNitcDetailMeta.InnerHtml=PhysNitcDetailMetaString;
	srvDat.Reset();


// ------ Server Listing


	sql="";
	dat=readDb(sql);
	if (dat!=null)
	{
		fill=false;
		tr = new HtmlTableRow();    //Output <TR>
			tr.Attributes.Add("class","blackheading");
			td = new HtmlTableCell(); //Output <TD>
				td.Attributes.Add("colspan","7");
				td.Attributes.Add("style","width: 625px;");
				td.InnerHtml = "Report Table";
			tr.Cells.Add(td);         //Output </TD>
		svrTbl.Rows.Add(tr);           //Output </TR>
		tr = new HtmlTableRow();    //Output <TR>
			tr.Attributes.Add("class","tableheading");
			td = new HtmlTableCell(); //Output <TD>
				td.InnerHtml = "Column1";
			tr.Cells.Add(td);         //Output </TD>
			td = new HtmlTableCell(); //Output <TD>
				td.InnerHtml = "Column2";
			tr.Cells.Add(td);         //Output </TD>
			td = new HtmlTableCell(); //Output <TD>
				td.InnerHtml = "Column3";
			tr.Cells.Add(td);         //Output </TD>
			td = new HtmlTableCell(); //Output <TD>
				td.InnerHtml = "Column4";
			tr.Cells.Add(td);         //Output </TD>
			td = new HtmlTableCell(); //Output <TD>
				td.InnerHtml = "Column5";
			tr.Cells.Add(td);         //Output </TD>
			td = new HtmlTableCell(); //Output <TD>
				td.InnerHtml = "Column6";
			tr.Cells.Add(td);         //Output </TD>
			td = new HtmlTableCell(); //Output <TD>
				td.InnerHtml = "Column7";
			tr.Cells.Add(td);         //Output </TD>
		svrTbl.Rows.Add(tr);           //Output </TR>	
		foreach (DataTable dtt in dat.Tables)
		{
			foreach (DataRow drr in dtt.Rows)
			{
				tr = new HtmlTableRow();    //Output <TR>
				if (fill) tr.BgColor="#edf0f3";
					td = new HtmlTableCell(); //Output <TD>
						td.InnerHtml= "Data1";
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						td.InnerHtml= "Data2";
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						td.InnerHtml= "Data3";
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						td.InnerHtml= "Data4";
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						td.InnerHtml= "Data5";
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						td.InnerHtml= "Data6";
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						td.InnerHtml= "Data7";
					tr.Cells.Add(td);         //Output </TD>
				svrTbl.Rows.Add(tr);           //Output </TR>
				fill=!fill;
			}
		}
	}
}
</SCRIPT>
</HEAD>
<BODY>
<!--#include file="./report_popup_opener.inc" -->
<CENTER>
	<TABLE border="0" width="100%">
	<TR><TD>
		<H1><DIV id="reportTitle" runat="server"/></H1>
		<CENTER><DIV id="errmsg" style="color:red" runat="server"/></TD></CENTER>
	</TD></TR>
	<TR><TD>
		&nbsp<BR>
		<FORM runat="server">

		<TABLE border=0>
			<TR>
				<TD>
					<Chart:ReportPieChart id="OverviewCapacityPieChart" runat="server" />
				</TD>
				<TD style="width: 5px;"> </TD>
				<TD><DIV id="overviewCapacityMeta" runat="server"/> &nbsp &nbsp &nbsp &nbsp </TD>
			</TR>
			<TR>
				<TD colspan=3><HR>
				</TD>
			</TR>
			<TR>
				<TD valign='top' align='center'>
					<FONT style='font-size: 120%; color: #336633; font-weight:bold; text-align:center'>Virtual Detail</FONT>
				</TD>
				<TD style="width: 5px;" rowspan=2></TD>
				<TD valign='top' align='center'>
					<FONT style='font-size: 120%; color: #336633; font-weight:bold; text-align:center'>Physical Detail</FONT><BR><BR>
				</TD>
			</TR>
			<TR>
				<TD valign=top>
					<TABLE border='0' class='altrow' style='border:1px solid #000'>
						<TR>
							<TD colspan=3 align=center>
								 <B>NITC / KCDC Virtual Servers</B>
							</TD>
						</TR>
						<TR>
							<TD>
								<Chart:ReportPieChart id="VirtNitcDetailPieChart" runat="server" />
							</TD>
							<TD style="width: 5px;"> </TD>
							<TD> &nbsp &nbsp &nbsp &nbsp<BR>
								<BUTTON id="goVirtNitcDetailButton" OnServerClick="goVirtNitcDetail" style="font-size:80%" runat="server">List Servers</BUTTON>
							</TD>
						</TR>
						<TR>
							<TD colspan=3>
								 <DIV id="virtNitcDetailMeta" runat="server"/> &nbsp &nbsp &nbsp &nbsp
							</TD>
						</TR>
					</TABLE>
					<BR>
				</TD>
<!-- -------------------------------------------------------------------------------------------------------------  -->
				<TD>
					<TABLE border='0' style='border:1px solid #000'>
						<TR>
							<TD colspan=3 align=center >
								 <B>NITC / KCDC Overall Physical Servers</B>
							</TD>
						</TR>
						<TR>
							<TD>
								<Chart:ReportPieChart id="PhysNitcDetailPieChart" runat="server" />
							</TD>
							<TD style="width: 5px;"> </TD>
							<TD><BR>
								<BUTTON id="goPhysNitcDetailButton" OnServerClick="goPhysNitcDetail" style="font-size:80%" runat="server">List Servers</BUTTON>
							</TD>
						</TR>
						<TR>
							<TD colspan=3>
								 <DIV id="PhysNitcDetailMeta" runat="server"/> &nbsp &nbsp &nbsp &nbsp
							</TD>
						</TR>
					</TABLE>
				</TD>
			</TR>
				<TD colspan="3">
					<TABLE id="svrTbl" runat="server" class="datatable" cellspacing="0" cellpadding="2" border="1"></TABLE>
				</TD>
		</TABLE>
		<CENTER>
		</CENTER>
		</FORM>
	</TD></TR>
	</TABLE>
</CENTER>
<P align="center"><INPUT type="button" value="Print" onclick="printWin()"/>&nbsp<INPUT type="button" value="Cancel & Close" onclick="refreshParent()"/></P>

<!--#include file="./report_popup_closer.inc" -->
</BODY>
</HTML>