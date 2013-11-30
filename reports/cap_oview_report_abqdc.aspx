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
void goVirtPheDetail(Object s, EventArgs e) 
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

void goPhysAbqdcDetail(Object s, EventArgs e) 
{
	HttpCookie cookie;
	string winSql, linSql, aixSql, rptTitle, lastpage;
	rptTitle="ABQDC Physical Servers List";
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

void goPhysPheDetail(Object s, EventArgs e) 
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

	reportTitle.InnerHtml="ABQDC Capacity Overview";

// ------ Capacity Overview Pie Chart Builder

	double overviewCapacityElement1Value, overviewCapacityElement2Value, overviewCapacityElement3Value, overviewCapacityElement4Value;

//	chartFreeBlades=Math.Round(((rackFreeBlade/rackTotal)*100) + 2/10.0,2);
	overviewCapacityElement1Value=Math.Round(((totalPhysRackspace/totalServerRackspace)*100) + 2/10.0,2);
	overviewCapacityElement2Value=Math.Round(((totalFreeRackspace/totalServerRackspace)*100) + 2/10.0,2);
	overviewCapacityElement3Value=Math.Round(((totalVirtRackspace/totalServerRackspace)*100) + 2/10.0,2);
//	overviewCapacityElement4Value=Math.Round(((1)*100) + 2/10.0,2);

	ReportPieChart_ascx.PieChartElement overviewCapacityElement1 = new ReportPieChart_ascx.PieChartElement();
	ReportPieChart_ascx.PieChartElement overviewCapacityElement2 = new ReportPieChart_ascx.PieChartElement();
	ReportPieChart_ascx.PieChartElement overviewCapacityElement3 = new ReportPieChart_ascx.PieChartElement();
//	ReportPieChart_ascx.PieChartElement overviewCapacityElement4 = new ReportPieChart_ascx.PieChartElement();

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

//	overviewCapacityElement4.Name = "Element4";
//	overviewCapacityElement4.Percent = overviewCapacityElement4Value;
//	overviewCapacityElement4.Color = Color.FromArgb(200, 30, 0);
//	OverviewCapacityPieChart.addPieChartElement(overviewCapacityElement4);
        
	OverviewCapacityPieChart.ChartTitle = "";
	OverviewCapacityPieChart.ImageAlt = "ReportChart";
	OverviewCapacityPieChart.ImageWidth = 300;
	OverviewCapacityPieChart.ImageHeight = 175;

	OverviewCapacityPieChart.generateChartImage();

	overviewCapacityMeta.InnerHtml="<B>Total Server Rackspace in ABQDC:</B> "+totalServerRackspace.ToString()+"<BR><BR><B>Physical Servers in ABQDC:</B> "+totalPhysRackspace.ToString()+"<BR>&nbsp &nbsp <B>Free Physical Rackspace in ABQDC:</B> "+totalFreeRackspace.ToString()+"<BR><BR><B>Virtual Servers in ABQDC:</B> "+totalVirtRackspace.ToString()+"<BR><BR><B><FONT size='+1'>ABQDC IS "+Math.Round(((totalVirtRackspace/totalServerRackspace)*100) + 2/10.0,2)+"% VIRTUAL</FONT</B>";

// ------ Virtual PHE Detail Pie Chart Builder

	float pheWinVirtServers, pheLinVirtServers, pheAixVirtServers, pheTotalVirtServers;

	sql="SELECT COUNT(*) FROM (SELECT * FROM rackspace INNER JOIN servers ON servers.rackspaceId=rackspace.rackspaceId WHERE serverOS='Windows' AND class='Virtual') WHERE belongsTo IN('engineering_cluster','phe_cluster','phe_bigfix_cluster','phewod_cluster')";
	dat=readDb(sql);
	if (dat!=null)
	{
		pheWinVirtServers=Convert.ToSingle(dat.Tables[0].Rows[0]["Expr1000"].ToString());
	}
	else
	{
		pheWinVirtServers=0;
	}

	sql="SELECT COUNT(*) FROM (SELECT * FROM rackspace INNER JOIN servers ON servers.rackspaceId=rackspace.rackspaceId WHERE serverOS='Linux' AND class='Virtual') WHERE belongsTo IN('engineering_cluster','phe_cluster','phe_bigfix_cluster','phewod_cluster')";
	dat=readDb(sql);
	if (dat!=null)
	{
		pheLinVirtServers=Convert.ToSingle(dat.Tables[0].Rows[0]["Expr1000"].ToString());
	}
	else
	{
		pheLinVirtServers=0;
	}

	sql="SELECT COUNT(*) FROM (SELECT * FROM rackspace INNER JOIN servers ON servers.rackspaceId=rackspace.rackspaceId WHERE serverOS='AIX' AND class='Virtual') WHERE serverName LIKE '%PHE%'";
	dat=readDb(sql);
	if (dat!=null)
	{
		pheAixVirtServers=Convert.ToSingle(dat.Tables[0].Rows[0]["Expr1000"].ToString());
	}
	else
	{
		pheAixVirtServers=0;
	}
	
	pheTotalVirtServers=pheWinVirtServers+pheLinVirtServers+pheAixVirtServers;

	double virtPheDetailElement1Value, virtPheDetailElement2Value, virtPheDetailElement3Value, virtPheDetailElement4Value;

	virtPheDetailElement1Value=Math.Round(((pheLinVirtServers/pheTotalVirtServers)*100) + 2/10.0,2);
	virtPheDetailElement2Value=Math.Round(((pheWinVirtServers/pheTotalVirtServers)*100) + 2/10.0,2);
	virtPheDetailElement3Value=Math.Round(((pheAixVirtServers/pheTotalVirtServers)*100) + 2/10.0,2);
//	virtPheDetailElement4Value=Math.Round(((1)*100) + 2/10.0,2);

	ReportPieChart_ascx.PieChartElement virtPheDetailElement1 = new ReportPieChart_ascx.PieChartElement();
	ReportPieChart_ascx.PieChartElement virtPheDetailElement2 = new ReportPieChart_ascx.PieChartElement();
	ReportPieChart_ascx.PieChartElement virtPheDetailElement3 = new ReportPieChart_ascx.PieChartElement();
//	ReportPieChart_ascx.PieChartElement virtPheDetailElement4 = new ReportPieChart_ascx.PieChartElement();

	virtPheDetailElement1.Name = "Linux";
	virtPheDetailElement1.Percent = virtPheDetailElement1Value;
	virtPheDetailElement1.Color = Color.FromArgb(255, 128, 0);
	VirtPheDetailPieChart.addPieChartElement(virtPheDetailElement1);

	virtPheDetailElement3.Name = "Windows";
	virtPheDetailElement3.Percent = virtPheDetailElement2Value;
	virtPheDetailElement3.Color = Color.FromArgb(255, 165, 075);
	VirtPheDetailPieChart.addPieChartElement(virtPheDetailElement3);

	virtPheDetailElement2.Name = "AIX";
	virtPheDetailElement2.Percent = virtPheDetailElement3Value;
	virtPheDetailElement2.Color = Color.FromArgb(255, 200, 150);
	VirtPheDetailPieChart.addPieChartElement(virtPheDetailElement2);

//	virtPheDetailElement4.Name = "Element4";
//	virtPheDetailElement4.Percent = virtPheDetailElement4Value;
//	virtPheDetailElement4.Color = Color.FromArgb(200, 30, 0);
//	VirtPheDetailPieChart.addPieChartElement(virtPheDetailElement4);
        
	VirtPheDetailPieChart.ChartTitle = "";
	VirtPheDetailPieChart.ImageAlt = "PHE Virtualization Breakdown";
	VirtPheDetailPieChart.ImageWidth = 225;
	VirtPheDetailPieChart.ImageHeight = 132;

	VirtPheDetailPieChart.BackgroundColor=0x78EDF0F3;

	VirtPheDetailPieChart.generateChartImage();

	string vmsSql="", hostsSql="", winVmsSql="", linVmsSql="", aixVmsSql="";
	string vmsCount="", hostsCount="", clusterDensity="", winVmsCount="", linVmsCount="", aixVmsCount="";
	DataSet dat1, dat2, dat3, dat4, dat5;
	DataSet clusterDat = new DataSet();


	string virtPheCluster="", virtPheClusters="", virtPheClusterVmCount="", virtPheClusterHostCount="";
	string virtPheDetailMetaString;
	virtPheDetailMetaString="<CENTER><TABLE border='0' cellspacing='0' cellpadding='0' class='CTRTABLE'><TR><TH class='UNDER'>Clusters</TH><TH class='UNDER'>VMs&nbsp</TH><TH class='UNDER'>Hosts&nbsp</TH><TH class='UNDER'>VMs / Host</TH></TR>";
	sql="SELECT DISTINCT(clusterName) FROM clusters WHERE clusterType='ESX' AND clusterName LIKE '%phe%' OR clusterName LIKE '%engineering%'";
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
				virtPheCluster=dr["clusterName"].ToString();

				vmsSql="SELECT COUNT(*) AS vmCount FROM (SELECT * FROM rackspace INNER JOIN servers ON servers.rackspaceId=rackspace.rackspaceId WHERE serverOS IN('Windows','Linux') AND class='Virtual') WHERE belongsTo='"+virtPheCluster+"'";
				hostsSql="SELECT COUNT(*) AS hostCount FROM (SELECT * FROM rackspace INNER JOIN servers ON servers.rackspaceId=rackspace.rackspaceId WHERE serverOS IN('ESX')) WHERE memberOfCluster='"+virtPheCluster+"'";
				winVmsSql="SELECT COUNT(*) AS winCount FROM (SELECT * FROM rackspace INNER JOIN servers ON servers.rackspaceId=rackspace.rackspaceId WHERE serverOS='Windows' AND class='Virtual') WHERE belongsTo='"+virtPheCluster+"'";
				linVmsSql="SELECT COUNT(*) AS linCount FROM (SELECT * FROM rackspace INNER JOIN servers ON servers.rackspaceId=rackspace.rackspaceId WHERE serverOS='Linux' AND class='Virtual') WHERE belongsTo='"+virtPheCluster+"'";
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
			
				clusterRow["Cluster"]=virtPheCluster;
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
				virtPheDetailMetaString=virtPheDetailMetaString+"<TR><TD style='text-align:left'>"+dr["Cluster"].ToString()+"</TD><TD>"+dr["VMs"].ToString()+"</TD><TD>"+dr["Hosts"].ToString()+"</TD><TD>"+dr["Density"].ToString()+"</TD></TR>";
			}
		}
	}
	virtPheDetailMetaString=virtPheDetailMetaString+"<TR><TD></TD><TD></TD><TD></TD><TD></TD></TR>";
	virtPheDetailMetaString=virtPheDetailMetaString+"<TR><TD>&nbsp</TD></TR>";
	virtPheDetailMetaString=virtPheDetailMetaString+"<TR><TH colspan='4'>Breakdown By OS</TH></TR>";
	virtPheDetailMetaString=virtPheDetailMetaString+"<TR><TH class='UNDER'>&nbsp</TH><TH class='UNDER'>Lin</TH><TH class='UNDER'>Win</TH><TH class='UNDER'>AIX</TH></TR>";
	if (clusterDat!=null)
	{
		foreach (DataTable dt in clusterDat.Tables)
		{
			foreach (DataRow dr in dt.Rows)
			{
				virtPheDetailMetaString=virtPheDetailMetaString+"<TR><TD style='text-align:left'>"+dr["Cluster"].ToString()+"</TD><TD>"+dr["Lin"].ToString()+"</TD><TD>"+dr["Win"].ToString()+"</TD><TD>&nbsp</TD></TR>";
			}
		}
	}
	virtPheDetailMetaString=virtPheDetailMetaString+"<TR><TD style='text-align:left'>MPARS/LPARS</TD><TD>&nbsp</TD><TD>&nbsp</TD><TD>"+clusterDat.Tables[0].Rows[0]["AIX"].ToString()+"</TD></TR>";
	virtPheDetailMetaString=virtPheDetailMetaString+"<TR><TD></TD><TD></TD><TD></TD><TD></TD></TR>";
	virtPheDetailMetaString=virtPheDetailMetaString+"</TABLE></CENTER>";


	virtPheDetailMeta.InnerHtml=virtPheDetailMetaString;
	clusterDat.Reset();

// ------ Virtual PRP Detail Pie Chart Builder

	float prpWinVirtServers, prpLinVirtServers, prpAixVirtServers, prpTotalVirtServers;

	sql="SELECT COUNT(*) FROM (SELECT * FROM rackspace INNER JOIN servers ON servers.rackspaceId=rackspace.rackspaceId WHERE serverOS='Windows' AND class='Virtual') WHERE belongsTo IN('prp_cluster','qa_cluster')";
	dat=readDb(sql);
	if (dat!=null)
	{
		prpWinVirtServers=Convert.ToSingle(dat.Tables[0].Rows[0]["Expr1000"].ToString());
	}
	else
	{
		prpWinVirtServers=0;
	}

	sql="SELECT COUNT(*) FROM (SELECT * FROM rackspace INNER JOIN servers ON servers.rackspaceId=rackspace.rackspaceId WHERE serverOS='Linux' AND class='Virtual') WHERE belongsTo IN('prp_cluster','qa_cluster')";
	dat=readDb(sql);
	if (dat!=null)
	{
		prpLinVirtServers=Convert.ToSingle(dat.Tables[0].Rows[0]["Expr1000"].ToString());
	}
	else
	{
		prpLinVirtServers=0;
	}

	sql="SELECT COUNT(*) FROM (SELECT * FROM rackspace INNER JOIN servers ON servers.rackspaceId=rackspace.rackspaceId WHERE serverOS='AIX' AND class='Virtual') WHERE serverName LIKE '%PRP%' OR serverName LIKE '%SVQA%'";
	dat=readDb(sql);
	if (dat!=null)
	{
		prpAixVirtServers=Convert.ToSingle(dat.Tables[0].Rows[0]["Expr1000"].ToString());
	}
	else
	{
		prpAixVirtServers=0;
	}
	
	prpTotalVirtServers=prpWinVirtServers+prpLinVirtServers+prpAixVirtServers;

	double virtPrpDetailElement1Value, virtPrpDetailElement2Value, virtPrpDetailElement3Value, virtPrpDetailElement4Value;

	virtPrpDetailElement1Value=Math.Round(((prpLinVirtServers/prpTotalVirtServers)*100) + 2/10.0,2);
	virtPrpDetailElement2Value=Math.Round(((prpWinVirtServers/prpTotalVirtServers)*100) + 2/10.0,2);
	virtPrpDetailElement3Value=Math.Round(((prpAixVirtServers/prpTotalVirtServers)*100) + 2/10.0,2);
//	virtPrpDetailElement4Value=Math.Round(((1)*100) + 2/10.0,2);

	ReportPieChart_ascx.PieChartElement virtPrpDetailElement1 = new ReportPieChart_ascx.PieChartElement();
	ReportPieChart_ascx.PieChartElement virtPrpDetailElement2 = new ReportPieChart_ascx.PieChartElement();
	ReportPieChart_ascx.PieChartElement virtPrpDetailElement3 = new ReportPieChart_ascx.PieChartElement();
//	ReportPieChart_ascx.PieChartElement virtPrpDetailElement4 = new ReportPieChart_ascx.PieChartElement();

	virtPrpDetailElement1.Name = "Linux";
	virtPrpDetailElement1.Percent = virtPrpDetailElement1Value;
	virtPrpDetailElement1.Color = Color.FromArgb(0, 128, 0);
	VirtPrpDetailPieChart.addPieChartElement(virtPrpDetailElement1);

	virtPrpDetailElement3.Name = "Windows";
	virtPrpDetailElement3.Percent = virtPrpDetailElement2Value;
	virtPrpDetailElement3.Color = Color.FromArgb(80, 240, 80);
	VirtPrpDetailPieChart.addPieChartElement(virtPrpDetailElement3);

	virtPrpDetailElement2.Name = "AIX";
	virtPrpDetailElement2.Percent = virtPrpDetailElement3Value;
	virtPrpDetailElement2.Color = Color.FromArgb(150, 255, 150);
	VirtPrpDetailPieChart.addPieChartElement(virtPrpDetailElement2);

//	virtPrpDetailElement4.Name = "Element4";
//	virtPrpDetailElement4.Percent = virtPrpDetailElement4Value;
//	virtPrpDetailElement4.Color = Color.FromArgb(200, 30, 0);
//	VirtPrpDetailPieChart.addPieChartElement(virtPrpDetailElement4);
        
	VirtPrpDetailPieChart.ChartTitle = "";
	VirtPrpDetailPieChart.ImageAlt = "PRP+QA Virtualization Breakdown";
	VirtPrpDetailPieChart.ImageWidth = 225;
	VirtPrpDetailPieChart.ImageHeight = 132;

	VirtPrpDetailPieChart.generateChartImage();

	string virtPrpCluster="", virtPrpClusters="", virtPrpClusterVmCount="", virtPrpClusterHostCount="";
	string virtPrpDetailMetaString;
	virtPrpDetailMetaString="<CENTER><TABLE border='0' cellspacing='0' cellpadding='0' class='CTRTABLE'><TR><TH class='UNDER'>Clusters</TH><TH class='UNDER'>VMs&nbsp</TH><TH class='UNDER'>Hosts&nbsp</TH><TH class='UNDER'>VMs / Host</TH></TR>";
	sql="SELECT DISTINCT(clusterName) FROM clusters WHERE clusterType='ESX' AND clusterName LIKE '%prp%' OR clusterName LIKE '%qa%'";
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
				virtPrpCluster=dr["clusterName"].ToString();

				vmsSql="SELECT COUNT(*) AS vmCount FROM (SELECT * FROM rackspace INNER JOIN servers ON servers.rackspaceId=rackspace.rackspaceId WHERE serverOS IN('Windows','Linux') AND class='Virtual') WHERE belongsTo='"+virtPrpCluster+"'";
				hostsSql="SELECT COUNT(*) AS hostCount FROM (SELECT * FROM rackspace INNER JOIN servers ON servers.rackspaceId=rackspace.rackspaceId WHERE serverOS IN('ESX')) WHERE memberOfCluster='"+virtPrpCluster+"'";
				winVmsSql="SELECT COUNT(*) AS winCount FROM (SELECT * FROM rackspace INNER JOIN servers ON servers.rackspaceId=rackspace.rackspaceId WHERE serverOS IN('Windows') AND class='Virtual') WHERE belongsTo='"+virtPrpCluster+"'";
				linVmsSql="SELECT COUNT(*) AS linCount FROM (SELECT * FROM rackspace INNER JOIN servers ON servers.rackspaceId=rackspace.rackspaceId WHERE serverOS IN('Linux') AND class='Virtual') WHERE belongsTo='"+virtPrpCluster+"'";
				aixVmsSql="SELECT COUNT(*) AS aixCount FROM (SELECT * FROM rackspace INNER JOIN servers ON servers.rackspaceId=rackspace.rackspaceId WHERE serverOS='AIX' AND class='Virtual') WHERE serverName LIKE '%PRP%' OR serverName LIKE '%SVQA%'";

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
			
				clusterRow["Cluster"]=virtPrpCluster;
				clusterRow["VMs"]=vmsCount;
				clusterRow["Hosts"]=hostsCount;
				if (Convert.ToInt32(hostsCount)>0)
				{
					clusterRow["Density"]=(Convert.ToInt32(vmsCount)/Convert.ToInt32(hostsCount)).ToString();
				}
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
				virtPrpDetailMetaString=virtPrpDetailMetaString+"<TR><TD style='text-align:left'>"+dr["Cluster"].ToString()+"</TD><TD>"+dr["VMs"].ToString()+"</TD><TD>"+dr["Hosts"].ToString()+"</TD><TD>"+dr["Density"].ToString()+"</TD></TR>";
			}
		}
	}
	virtPrpDetailMetaString=virtPrpDetailMetaString+"<TR><TD></TD><TD></TD><TD></TD><TD></TD></TR>";
	virtPrpDetailMetaString=virtPrpDetailMetaString+"<TR><TD>&nbsp</TD></TR>";
	virtPrpDetailMetaString=virtPrpDetailMetaString+"<TR><TH colspan='4'>Breakdown By OS</TH></TR>";
	virtPrpDetailMetaString=virtPrpDetailMetaString+"<TR><TH class='UNDER'>&nbsp</TH><TH class='UNDER'>Lin</TH><TH class='UNDER'>Win</TH><TH class='UNDER'>AIX</TH></TR>";
	if (clusterDat!=null)
	{
		foreach (DataTable dt in clusterDat.Tables)
		{
			foreach (DataRow dr in dt.Rows)
			{
				virtPrpDetailMetaString=virtPrpDetailMetaString+"<TR><TD style='text-align:left'>"+dr["Cluster"].ToString()+"</TD><TD>"+dr["Lin"].ToString()+"</TD><TD>"+dr["Win"].ToString()+"</TD><TD>&nbsp</TD></TR>";
			}
		}
	}
	virtPrpDetailMetaString=virtPrpDetailMetaString+"<TR><TD style='text-align:left'>MPARS/LPARS</TD><TD>&nbsp</TD><TD>&nbsp</TD><TD>"+clusterDat.Tables[0].Rows[0]["AIX"].ToString()+"</TD></TR>";
	virtPrpDetailMetaString=virtPrpDetailMetaString+"<TR><TD></TD><TD></TD><TD></TD><TD></TD></TR>";
	virtPrpDetailMetaString=virtPrpDetailMetaString+"</TABLE></CENTER>";


	virtPrpDetailMeta.InnerHtml=virtPrpDetailMetaString;
	clusterDat.Reset();


// ------ Physical ABQDC Detail Pie Chart Builder

	float abqdcWinPhysServers, abqdcLinPhysServers, abqdcAixPhysServers;

	sql="SELECT COUNT(*) FROM (SELECT * FROM (SELECT * FROM (SELECT * FROM rackspace LEFT JOIN servers on servers.rackspaceId=rackspace.rackspaceId WHERE class<>'Virtual') WHERE serverOS IS NULL UNION (SELECT * FROM rackspace LEFT JOIN servers on servers.rackspaceId=rackspace.rackspaceId WHERE class<>'Virtual' AND serverOS NOT IN('RSA2','Network'))) WHERE reserved<>'1' AND serverOS='Windows' ORDER BY serverOS ASC)";
	dat=readDb(sql);
	if (dat!=null)
	{
		abqdcWinPhysServers=Convert.ToSingle(dat.Tables[0].Rows[0]["Expr1000"].ToString());
	}
	else
	{
		abqdcWinPhysServers=0;
	}

	sql="SELECT COUNT(*) FROM (SELECT * FROM (SELECT * FROM (SELECT * FROM rackspace LEFT JOIN servers on servers.rackspaceId=rackspace.rackspaceId WHERE class<>'Virtual') WHERE serverOS IS NULL UNION (SELECT * FROM rackspace LEFT JOIN servers on servers.rackspaceId=rackspace.rackspaceId WHERE class<>'Virtual' AND serverOS NOT IN('RSA2','Network'))) WHERE reserved<>'1' AND serverOS IN ('Linux','ESX') ORDER BY serverOS ASC)";
	dat=readDb(sql);
	if (dat!=null)
	{
		abqdcLinPhysServers=Convert.ToSingle(dat.Tables[0].Rows[0]["Expr1000"].ToString());
	}
	else
	{
		abqdcLinPhysServers=0;
	}

	sql="SELECT COUNT(*) FROM (SELECT * FROM (SELECT * FROM (SELECT * FROM rackspace LEFT JOIN servers on servers.rackspaceId=rackspace.rackspaceId WHERE class<>'Virtual') WHERE serverOS IS NULL UNION (SELECT * FROM rackspace LEFT JOIN servers on servers.rackspaceId=rackspace.rackspaceId WHERE class<>'Virtual' AND serverOS NOT IN('RSA2','Network'))) WHERE reserved<>'1' AND serverOS='AIX' ORDER BY serverOS ASC)";
	dat=readDb(sql);
	if (dat!=null)
	{
		abqdcAixPhysServers=Convert.ToSingle(dat.Tables[0].Rows[0]["Expr1000"].ToString());
	}
	else
	{
		abqdcAixPhysServers=0;
	}
	
	double physAbqdcDetailElement1Value, physAbqdcDetailElement2Value, physAbqdcDetailElement3Value, physAbqdcDetailElement4Value;

	physAbqdcDetailElement1Value=Math.Round(((abqdcLinPhysServers/totalPhysRackspace)*100) + 2/10.0,2);
	physAbqdcDetailElement2Value=Math.Round(((abqdcWinPhysServers/totalPhysRackspace)*100) + 2/10.0,2);
	physAbqdcDetailElement3Value=Math.Round(((abqdcAixPhysServers/totalPhysRackspace)*100) + 2/10.0,2);
//	physAbqdcDetailElement4Value=Math.Round(((1)*100) + 2/10.0,2);

	ReportPieChart_ascx.PieChartElement physAbqdcDetailElement1 = new ReportPieChart_ascx.PieChartElement();
	ReportPieChart_ascx.PieChartElement physAbqdcDetailElement2 = new ReportPieChart_ascx.PieChartElement();
	ReportPieChart_ascx.PieChartElement physAbqdcDetailElement3 = new ReportPieChart_ascx.PieChartElement();
//	ReportPieChart_ascx.PieChartElement physAbqdcDetailElement4 = new ReportPieChart_ascx.PieChartElement();

	physAbqdcDetailElement1.Name = "Linux";
	physAbqdcDetailElement1.Percent = physAbqdcDetailElement1Value;
	physAbqdcDetailElement1.Color = Color.FromArgb(0, 128, 255);
	PhysAbqdcDetailPieChart.addPieChartElement(physAbqdcDetailElement1);

	physAbqdcDetailElement3.Name = "Windows";
	physAbqdcDetailElement3.Percent = physAbqdcDetailElement2Value;
	physAbqdcDetailElement3.Color = Color.FromArgb(90, 175, 255);
	PhysAbqdcDetailPieChart.addPieChartElement(physAbqdcDetailElement3);

	physAbqdcDetailElement2.Name = "AIX";
	physAbqdcDetailElement2.Percent = physAbqdcDetailElement3Value;
	physAbqdcDetailElement2.Color = Color.FromArgb(165, 210, 255);
	PhysAbqdcDetailPieChart.addPieChartElement(physAbqdcDetailElement2);

//	physAbqdcDetailElement4.Name = "Element4";
//	physAbqdcDetailElement4.Percent = physAbqdcDetailElement4Value;
//	physAbqdcDetailElement4.Color = Color.FromArgb(200, 30, 0);
//	PhysAbqdcDetailPieChart.addPieChartElement(physAbqdcDetailElement4);
        
	PhysAbqdcDetailPieChart.ChartTitle = "";
	PhysAbqdcDetailPieChart.ImageAlt = "ABQDC Physical Breakdown";
	PhysAbqdcDetailPieChart.ImageWidth = 225;
	PhysAbqdcDetailPieChart.ImageHeight = 132;

	PhysAbqdcDetailPieChart.generateChartImage();

	string winSrvSql="", linSrvSql="", aixSrvSql="";
	string winSrvCount="", linSrvCount="", aixSrvCount="";
	DataSet srvDat = new DataSet();

	string physAbqdcDetailMetaString;

	physAbqdcDetailMetaString="<CENTER><TABLE border='0' cellspacing='0' cellpadding='0' class='CTRTABLE'>";
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

	physAbqdcDetailMetaString=physAbqdcDetailMetaString+"<TR><TH colspan='4'>Breakdown By OS&nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp</TH></TR>";
	physAbqdcDetailMetaString=physAbqdcDetailMetaString+"<TR><TH class='UNDER'>&nbsp</TH><TH class='UNDER'>Lin&nbsp &nbsp</TH><TH class='UNDER'>Win&nbsp &nbsp</TH><TH class='UNDER'>AIX&nbsp &nbsp</TH></TR>";
	physAbqdcDetailMetaString=physAbqdcDetailMetaString+"<TR><TD style='text-align:left'>ABQDC Phys. Servers</TD><TD>"+srvDat.Tables[0].Rows[0]["Win"].ToString()+"</TD><TD>"+srvDat.Tables[0].Rows[0]["Lin"].ToString()+"</TD><TD>"+srvDat.Tables[0].Rows[0]["AIX"].ToString()+"</TD></TR>";
	physAbqdcDetailMetaString=physAbqdcDetailMetaString+"<TR><TD></TD><TD></TD><TD></TD><TD></TD></TR>";
	physAbqdcDetailMetaString=physAbqdcDetailMetaString+"</TABLE></CENTER>";


	PhysAbqdcDetailMeta.InnerHtml=physAbqdcDetailMetaString;
	srvDat.Reset();

// ------ Physical PHE Detail Pie Chart Builder

	float pheWinPhysServers, pheLinPhysServers, pheAixPhysServers, pheTotalPhysServers;

	sql="SELECT COUNT(*) FROM(SELECT * FROM (SELECT * FROM (SELECT * FROM (SELECT * FROM rackspace LEFT JOIN servers on servers.rackspaceId=rackspace.rackspaceId WHERE class<>'Virtual') WHERE serverOS IS NULL UNION (SELECT * FROM rackspace LEFT JOIN servers on servers.rackspaceId=rackspace.rackspaceId WHERE class<>'Virtual' AND serverOS NOT IN('RSA2','Network'))) WHERE reserved<>'1' AND serverOS='Windows' ORDER BY serverOS ASC) WHERE serverName LIKE '%PHE%')";
	dat=readDb(sql);
	if (dat!=null)
	{
		pheWinPhysServers=Convert.ToSingle(dat.Tables[0].Rows[0]["Expr1000"].ToString());
	}
	else
	{
		pheWinPhysServers=0;
	}

	sql="SELECT COUNT(*) FROM(SELECT * FROM (SELECT * FROM (SELECT * FROM (SELECT * FROM rackspace LEFT JOIN servers on servers.rackspaceId=rackspace.rackspaceId WHERE class<>'Virtual') WHERE serverOS IS NULL UNION (SELECT * FROM rackspace LEFT JOIN servers on servers.rackspaceId=rackspace.rackspaceId WHERE class<>'Virtual' AND serverOS NOT IN('RSA2','Network'))) WHERE reserved<>'1' AND serverOS IN ('Linux','ESX') ORDER BY serverOS ASC) WHERE serverName LIKE '%PHE%')";
	dat=readDb(sql);
	if (dat!=null)
	{
		pheLinPhysServers=Convert.ToSingle(dat.Tables[0].Rows[0]["Expr1000"].ToString());
	}
	else
	{
		pheLinPhysServers=0;
	}

	sql="SELECT COUNT(*) FROM(SELECT * FROM (SELECT * FROM (SELECT * FROM (SELECT * FROM rackspace LEFT JOIN servers on servers.rackspaceId=rackspace.rackspaceId WHERE class<>'Virtual') WHERE serverOS IS NULL UNION (SELECT * FROM rackspace LEFT JOIN servers on servers.rackspaceId=rackspace.rackspaceId WHERE class<>'Virtual' AND serverOS NOT IN('RSA2','Network'))) WHERE reserved<>'1' AND serverOS='AIX' ORDER BY serverOS ASC) WHERE serverName LIKE '%PHE%')";
	dat=readDb(sql);
	if (dat!=null)
	{
		pheAixPhysServers=Convert.ToSingle(dat.Tables[0].Rows[0]["Expr1000"].ToString());
	}
	else
	{
		pheAixPhysServers=0;
	}

	pheTotalPhysServers=pheWinPhysServers+pheLinPhysServers+pheAixPhysServers;

	double physPheDetailElement1Value, physPheDetailElement2Value, physPheDetailElement3Value, physPheDetailElement4Value;

	physPheDetailElement1Value=Math.Round(((pheLinPhysServers/pheTotalPhysServers)*100) + 2/10.0,2);
	physPheDetailElement2Value=Math.Round(((pheWinPhysServers/pheTotalPhysServers)*100) + 2/10.0,2);
	physPheDetailElement3Value=Math.Round(((pheAixPhysServers/pheTotalPhysServers)*100) + 2/10.0,2);
//	physPheDetailElement4Value=Math.Round(((1)*100) + 2/10.0,2);

	ReportPieChart_ascx.PieChartElement physPheDetailElement1 = new ReportPieChart_ascx.PieChartElement();
	ReportPieChart_ascx.PieChartElement physPheDetailElement2 = new ReportPieChart_ascx.PieChartElement();
	ReportPieChart_ascx.PieChartElement physPheDetailElement3 = new ReportPieChart_ascx.PieChartElement();
//	ReportPieChart_ascx.PieChartElement physPheDetailElement4 = new ReportPieChart_ascx.PieChartElement();

	physPheDetailElement1.Name = "Linux";
	physPheDetailElement1.Percent = physPheDetailElement1Value;
	physPheDetailElement1.Color = Color.FromArgb(128, 0, 0);
	PhysPheDetailPieChart.addPieChartElement(physPheDetailElement1);

	physPheDetailElement3.Name = "Windows";
	physPheDetailElement3.Percent = physPheDetailElement2Value;
	physPheDetailElement3.Color = Color.FromArgb(235, 0, 0);
	PhysPheDetailPieChart.addPieChartElement(physPheDetailElement3);

	physPheDetailElement2.Name = "AIX";
	physPheDetailElement2.Percent = physPheDetailElement3Value;
	physPheDetailElement2.Color = Color.FromArgb(255, 132, 132);
	PhysPheDetailPieChart.addPieChartElement(physPheDetailElement2);

//	physPheDetailElement4.Name = "Element4";
//	physPheDetailElement4.Percent = physPheDetailElement4Value;
//	physPheDetailElement4.Color = Color.FromArgb(200, 30, 0);
//	PhysPheDetailPieChart.addPieChartElement(physPheDetailElement4);
        
	PhysPheDetailPieChart.ChartTitle = "";
	PhysPheDetailPieChart.ImageAlt = "PHE Physical Breakdown";
	PhysPheDetailPieChart.ImageWidth = 225;
	PhysPheDetailPieChart.ImageHeight = 132;

	PhysPheDetailPieChart.generateChartImage();

	string physPheDetailMetaString;

	physPheDetailMetaString="<CENTER><TABLE border='0' cellspacing='0' cellpadding='0' class='CTRTABLE'>";
	srvDat.Tables.Add("Servers");
	srvDat.Tables["Servers"].Columns.Add("Win", typeof(string));
	srvDat.Tables["Servers"].Columns.Add("Lin", typeof(string));
	srvDat.Tables["Servers"].Columns.Add("AIX", typeof(string));
	srvRow = srvDat.Tables["Servers"].NewRow();


	winSrvSql="SELECT COUNT(*) AS winCount FROM (SELECT * FROM (SELECT * FROM (SELECT * FROM (SELECT * FROM rackspace LEFT JOIN servers on servers.rackspaceId=rackspace.rackspaceId WHERE class<>'Virtual') WHERE serverOS IS NULL UNION (SELECT * FROM rackspace LEFT JOIN servers on servers.rackspaceId=rackspace.rackspaceId WHERE class<>'Virtual' AND serverOS NOT IN('RSA2','Network'))) WHERE reserved<>'1' AND serverOS='Windows' ORDER BY serverOS ASC) WHERE serverName LIKE '%PHE%')";
	linSrvSql="SELECT COUNT(*) AS linCount FROM (SELECT * FROM (SELECT * FROM (SELECT * FROM (SELECT * FROM rackspace LEFT JOIN servers on servers.rackspaceId=rackspace.rackspaceId WHERE class<>'Virtual') WHERE serverOS IS NULL UNION (SELECT * FROM rackspace LEFT JOIN servers on servers.rackspaceId=rackspace.rackspaceId WHERE class<>'Virtual' AND serverOS NOT IN('RSA2','Network'))) WHERE reserved<>'1' AND serverOS IN ('Linux','ESX') ORDER BY serverOS ASC) WHERE serverName LIKE '%PHE%')";
	aixSrvSql="SELECT COUNT(*) AS aixCount FROM (SELECT * FROM (SELECT * FROM (SELECT * FROM (SELECT * FROM rackspace LEFT JOIN servers on servers.rackspaceId=rackspace.rackspaceId WHERE class<>'Virtual') WHERE serverOS IS NULL UNION (SELECT * FROM rackspace LEFT JOIN servers on servers.rackspaceId=rackspace.rackspaceId WHERE class<>'Virtual' AND serverOS NOT IN('RSA2','Network'))) WHERE reserved<>'1' AND serverOS='AIX' ORDER BY serverOS ASC) WHERE serverName LIKE '%PHE%')";

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

	physPheDetailMetaString=physPheDetailMetaString+"<TR><TH colspan='4'>Breakdown By OS&nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp</TH></TR>";
	physPheDetailMetaString=physPheDetailMetaString+"<TR><TH class='UNDER'>&nbsp</TH><TH class='UNDER'>Lin&nbsp &nbsp</TH><TH class='UNDER'>Win&nbsp &nbsp</TH><TH class='UNDER'>AIX&nbsp &nbsp</TH></TR>";
	physPheDetailMetaString=physPheDetailMetaString+"<TR><TD style='text-align:left'>PHE Phys. Servers</TD><TD>"+srvDat.Tables[0].Rows[0]["Win"].ToString()+"</TD><TD>"+srvDat.Tables[0].Rows[0]["Lin"].ToString()+"</TD><TD>"+srvDat.Tables[0].Rows[0]["AIX"].ToString()+"</TD></TR>";
	physPheDetailMetaString=physPheDetailMetaString+"<TR><TD></TD><TD></TD><TD></TD><TD></TD></TR>";
	physPheDetailMetaString=physPheDetailMetaString+"</TABLE></CENTER>";


	PhysPheDetailMeta.InnerHtml=physPheDetailMetaString;
	srvDat.Reset();

// ------ Physical PRP Detail Pie Chart Builder

	float prpWinPhysServers, prpLinPhysServers, prpAixPhysServers, prpTotalPhysServers;

	sql="SELECT COUNT(*) FROM(SELECT * FROM (SELECT * FROM (SELECT * FROM (SELECT * FROM rackspace LEFT JOIN servers on servers.rackspaceId=rackspace.rackspaceId WHERE class<>'Virtual') WHERE serverOS IS NULL UNION (SELECT * FROM rackspace LEFT JOIN servers on servers.rackspaceId=rackspace.rackspaceId WHERE class<>'Virtual' AND serverOS NOT IN('RSA2','Network'))) WHERE reserved<>'1' AND serverOS='Windows' ORDER BY serverOS ASC) WHERE serverName LIKE '%PRP%')";
	dat=readDb(sql);
	if (dat!=null)
	{
		prpWinPhysServers=Convert.ToSingle(dat.Tables[0].Rows[0]["Expr1000"].ToString());
	}
	else
	{
		prpWinPhysServers=0;
	}

	sql="SELECT COUNT(*) FROM(SELECT * FROM (SELECT * FROM (SELECT * FROM (SELECT * FROM rackspace LEFT JOIN servers on servers.rackspaceId=rackspace.rackspaceId WHERE class<>'Virtual') WHERE serverOS IS NULL UNION (SELECT * FROM rackspace LEFT JOIN servers on servers.rackspaceId=rackspace.rackspaceId WHERE class<>'Virtual' AND serverOS NOT IN('RSA2','Network'))) WHERE reserved<>'1' AND serverOS IN ('Linux','ESX') ORDER BY serverOS ASC) WHERE serverName LIKE '%PRP%')";
	dat=readDb(sql);
	if (dat!=null)
	{
		prpLinPhysServers=Convert.ToSingle(dat.Tables[0].Rows[0]["Expr1000"].ToString());
	}
	else
	{
		prpLinPhysServers=0;
	}

	sql="SELECT COUNT(*) FROM(SELECT * FROM (SELECT * FROM (SELECT * FROM (SELECT * FROM rackspace LEFT JOIN servers on servers.rackspaceId=rackspace.rackspaceId WHERE class<>'Virtual') WHERE serverOS IS NULL UNION (SELECT * FROM rackspace LEFT JOIN servers on servers.rackspaceId=rackspace.rackspaceId WHERE class<>'Virtual' AND serverOS NOT IN('RSA2','Network'))) WHERE reserved<>'1' AND serverOS='AIX' ORDER BY serverOS ASC) WHERE serverName LIKE '%PRP%')";
	dat=readDb(sql);
	if (dat!=null)
	{
		prpAixPhysServers=Convert.ToSingle(dat.Tables[0].Rows[0]["Expr1000"].ToString());
	}
	else
	{
		prpAixPhysServers=0;
	}

	prpTotalPhysServers=prpWinPhysServers+prpLinPhysServers+prpAixPhysServers;

	double physPrpDetailElement1Value, physPrpDetailElement2Value, physPrpDetailElement3Value, physPrpDetailElement4Value;

	physPrpDetailElement1Value=Math.Round(((prpLinPhysServers/prpTotalPhysServers)*100) + 2/10.0,2);
	physPrpDetailElement2Value=Math.Round(((prpWinPhysServers/prpTotalPhysServers)*100) + 2/10.0,2);
	physPrpDetailElement3Value=Math.Round(((prpAixPhysServers/prpTotalPhysServers)*100) + 2/10.0,2);
//	physPrpDetailElement4Value=Math.Round(((1)*100) + 2/10.0,2);

	ReportPieChart_ascx.PieChartElement physPrpDetailElement1 = new ReportPieChart_ascx.PieChartElement();
	ReportPieChart_ascx.PieChartElement physPrpDetailElement2 = new ReportPieChart_ascx.PieChartElement();
	ReportPieChart_ascx.PieChartElement physPrpDetailElement3 = new ReportPieChart_ascx.PieChartElement();
//	ReportPieChart_ascx.PieChartElement physPrpDetailElement4 = new ReportPieChart_ascx.PieChartElement();

	physPrpDetailElement1.Name = "Linux";
	physPrpDetailElement1.Percent = physPrpDetailElement1Value;
	physPrpDetailElement1.Color = Color.FromArgb(64, 0, 128);
	PhysPrpDetailPieChart.addPieChartElement(physPrpDetailElement1);

	physPrpDetailElement3.Name = "Windows";
	physPrpDetailElement3.Percent = physPrpDetailElement2Value;
	physPrpDetailElement3.Color = Color.FromArgb(135, 15, 255);
	PhysPrpDetailPieChart.addPieChartElement(physPrpDetailElement3);

	physPrpDetailElement2.Name = "AIX";
	physPrpDetailElement2.Percent = physPrpDetailElement3Value;
	physPrpDetailElement2.Color = Color.FromArgb(200, 128, 255);
	PhysPrpDetailPieChart.addPieChartElement(physPrpDetailElement2);

//	physPrpDetailElement4.Name = "Element4";
//	physPrpDetailElement4.Percent = physPrpDetailElement4Value;
//	physPrpDetailElement4.Color = Color.FromArgb(200, 30, 0);
//	PhysPrpDetailPieChart.addPieChartElement(physPrpDetailElement4);
        
	PhysPrpDetailPieChart.ChartTitle = "";
	PhysPrpDetailPieChart.ImageAlt = "PRP Physical Breakdown";
	PhysPrpDetailPieChart.ImageWidth = 225;
	PhysPrpDetailPieChart.ImageHeight = 132;

	PhysPrpDetailPieChart.generateChartImage();

	string physPrpDetailMetaString;

	physPrpDetailMetaString="<CENTER><TABLE border='0' cellspacing='0' cellpadding='0' class='CTRTABLE'>";
	srvDat.Tables.Add("Servers");
	srvDat.Tables["Servers"].Columns.Add("Win", typeof(string));
	srvDat.Tables["Servers"].Columns.Add("Lin", typeof(string));
	srvDat.Tables["Servers"].Columns.Add("AIX", typeof(string));
	srvRow = srvDat.Tables["Servers"].NewRow();


	winSrvSql="SELECT COUNT(*) AS winCount FROM (SELECT * FROM (SELECT * FROM (SELECT * FROM (SELECT * FROM rackspace LEFT JOIN servers on servers.rackspaceId=rackspace.rackspaceId WHERE class<>'Virtual') WHERE serverOS IS NULL UNION (SELECT * FROM rackspace LEFT JOIN servers on servers.rackspaceId=rackspace.rackspaceId WHERE class<>'Virtual' AND serverOS NOT IN('RSA2','Network'))) WHERE reserved<>'1' AND serverOS='Windows' ORDER BY serverOS ASC) WHERE serverName LIKE '%PRP%')";
	linSrvSql="SELECT COUNT(*) AS linCount FROM (SELECT * FROM (SELECT * FROM (SELECT * FROM (SELECT * FROM rackspace LEFT JOIN servers on servers.rackspaceId=rackspace.rackspaceId WHERE class<>'Virtual') WHERE serverOS IS NULL UNION (SELECT * FROM rackspace LEFT JOIN servers on servers.rackspaceId=rackspace.rackspaceId WHERE class<>'Virtual' AND serverOS NOT IN('RSA2','Network'))) WHERE reserved<>'1' AND serverOS IN ('Linux','ESX') ORDER BY serverOS ASC) WHERE serverName LIKE '%PRP%')";
	aixSrvSql="SELECT COUNT(*) AS aixCount FROM (SELECT * FROM (SELECT * FROM (SELECT * FROM (SELECT * FROM rackspace LEFT JOIN servers on servers.rackspaceId=rackspace.rackspaceId WHERE class<>'Virtual') WHERE serverOS IS NULL UNION (SELECT * FROM rackspace LEFT JOIN servers on servers.rackspaceId=rackspace.rackspaceId WHERE class<>'Virtual' AND serverOS NOT IN('RSA2','Network'))) WHERE reserved<>'1' AND serverOS='AIX' ORDER BY serverOS ASC) WHERE serverName LIKE '%PRP%')";

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

	physPrpDetailMetaString=physPrpDetailMetaString+"<TR><TH colspan='4'>Breakdown By OS&nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp</TH></TR>";
	physPrpDetailMetaString=physPrpDetailMetaString+"<TR><TH class='UNDER'>&nbsp</TH><TH class='UNDER'>Lin&nbsp &nbsp</TH><TH class='UNDER'>Win&nbsp &nbsp</TH><TH class='UNDER'>AIX&nbsp &nbsp</TH></TR>";
	physPrpDetailMetaString=physPrpDetailMetaString+"<TR><TD style='text-align:left'>PRP Phys. Servers</TD><TD>"+srvDat.Tables[0].Rows[0]["Win"].ToString()+"</TD><TD>"+srvDat.Tables[0].Rows[0]["Lin"].ToString()+"</TD><TD>"+srvDat.Tables[0].Rows[0]["AIX"].ToString()+"</TD></TR>";
	physPrpDetailMetaString=physPrpDetailMetaString+"<TR><TD></TD><TD></TD><TD></TD><TD></TD></TR>";
	physPrpDetailMetaString=physPrpDetailMetaString+"</TABLE></CENTER>";

	PhysPrpDetailMeta.InnerHtml=physPrpDetailMetaString;
	srvDat.Reset();


// ------ Physical QA Detail Pie Chart Builder

	float qaWinPhysServers, qaLinPhysServers, qaAixPhysServers, qaTotalPhysServers;

	sql="SELECT COUNT(*) FROM(SELECT * FROM (SELECT * FROM (SELECT * FROM (SELECT * FROM rackspace LEFT JOIN servers on servers.rackspaceId=rackspace.rackspaceId WHERE class<>'Virtual') WHERE serverOS IS NULL UNION (SELECT * FROM rackspace LEFT JOIN servers on servers.rackspaceId=rackspace.rackspaceId WHERE class<>'Virtual' AND serverOS NOT IN('RSA2','Network'))) WHERE reserved<>'1' AND serverOS='Windows' ORDER BY serverOS ASC) WHERE serverName LIKE '%SXQA%')";
	dat=readDb(sql);
	if (dat!=null)
	{
		qaWinPhysServers=Convert.ToSingle(dat.Tables[0].Rows[0]["Expr1000"].ToString());
	}
	else
	{
		qaWinPhysServers=0;
	}

	sql="SELECT COUNT(*) FROM(SELECT * FROM (SELECT * FROM (SELECT * FROM (SELECT * FROM rackspace LEFT JOIN servers on servers.rackspaceId=rackspace.rackspaceId WHERE class<>'Virtual') WHERE serverOS IS NULL UNION (SELECT * FROM rackspace LEFT JOIN servers on servers.rackspaceId=rackspace.rackspaceId WHERE class<>'Virtual' AND serverOS NOT IN('RSA2','Network'))) WHERE reserved<>'1' AND serverOS IN ('Linux','ESX') ORDER BY serverOS ASC) WHERE serverName LIKE '%SLQA%')";
	dat=readDb(sql);
	if (dat!=null)
	{
		qaLinPhysServers=Convert.ToSingle(dat.Tables[0].Rows[0]["Expr1000"].ToString());
	}
	else
	{
		qaLinPhysServers=0;
	}

	sql="SELECT COUNT(*) FROM(SELECT * FROM (SELECT * FROM (SELECT * FROM (SELECT * FROM rackspace LEFT JOIN servers on servers.rackspaceId=rackspace.rackspaceId WHERE class<>'Virtual') WHERE serverOS IS NULL UNION (SELECT * FROM rackspace LEFT JOIN servers on servers.rackspaceId=rackspace.rackspaceId WHERE class<>'Virtual' AND serverOS NOT IN('RSA2','Network'))) WHERE reserved<>'1' AND serverOS='AIX' ORDER BY serverOS ASC) WHERE serverName LIKE '%SVQA%')";
	dat=readDb(sql);
	if (dat!=null)
	{
		qaAixPhysServers=Convert.ToSingle(dat.Tables[0].Rows[0]["Expr1000"].ToString());
	}
	else
	{
		qaAixPhysServers=0;
	}

	qaTotalPhysServers=qaWinPhysServers+qaLinPhysServers+qaAixPhysServers;

	double physQaDetailElement1Value, physQaDetailElement2Value, physQaDetailElement3Value, physQaDetailElement4Value;

	physQaDetailElement1Value=Math.Round(((qaLinPhysServers/qaTotalPhysServers)*100) + 2/10.0,2);
	physQaDetailElement2Value=Math.Round(((qaWinPhysServers/qaTotalPhysServers)*100) + 2/10.0,2);
	physQaDetailElement3Value=Math.Round(((qaAixPhysServers/qaTotalPhysServers)*100) + 2/10.0,2);
//	physQaDetailElement4Value=Math.Round(((qaLinPhysServers/qaTotalPhysServers)*100) + 2/10.0,2);

	ReportPieChart_ascx.PieChartElement physQaDetailElement1 = new ReportPieChart_ascx.PieChartElement();
	ReportPieChart_ascx.PieChartElement physQaDetailElement2 = new ReportPieChart_ascx.PieChartElement();
	ReportPieChart_ascx.PieChartElement physQaDetailElement3 = new ReportPieChart_ascx.PieChartElement();
//	ReportPieChart_ascx.PieChartElement physQaDetailElement4 = new ReportPieChart_ascx.PieChartElement();

	physQaDetailElement1.Name = "Linux";
	physQaDetailElement1.Percent = physQaDetailElement1Value;
	physQaDetailElement1.Color = Color.FromArgb(128, 128, 0);
	PhysQaDetailPieChart.addPieChartElement(physQaDetailElement1);

	physQaDetailElement3.Name = "Windows";
	physQaDetailElement3.Percent = physQaDetailElement2Value;
	physQaDetailElement3.Color = Color.FromArgb(255, 255, 0);
	PhysQaDetailPieChart.addPieChartElement(physQaDetailElement3);

	physQaDetailElement2.Name = "AIX";
	physQaDetailElement2.Percent = physQaDetailElement3Value;
	physQaDetailElement2.Color = Color.FromArgb(128, 64, 0);
	PhysQaDetailPieChart.addPieChartElement(physQaDetailElement2);

//	physQaDetailElement4.Name = "Element4";
//	physQaDetailElement4.Percent = physQaDetailElement4Value;
//	physQaDetailElement4.Color = Color.FromArgb(200, 30, 0);
//	PhysQaDetailPieChart.addPieChartElement(physQaDetailElement4);
        
	PhysQaDetailPieChart.ChartTitle = "";
	PhysQaDetailPieChart.ImageAlt = "QA Physical Breakdown";
	PhysQaDetailPieChart.ImageWidth = 225;
	PhysQaDetailPieChart.ImageHeight = 132;

	PhysQaDetailPieChart.generateChartImage();

	string physQaDetailMetaString;

	physQaDetailMetaString="<CENTER><TABLE border='0' cellspacing='0' cellpadding='0' class='CTRTABLE'>";
	srvDat.Tables.Add("Servers");
	srvDat.Tables["Servers"].Columns.Add("Win", typeof(string));
	srvDat.Tables["Servers"].Columns.Add("Lin", typeof(string));
	srvDat.Tables["Servers"].Columns.Add("AIX", typeof(string));
	srvRow = srvDat.Tables["Servers"].NewRow();


	winSrvSql="SELECT COUNT(*) AS winCount FROM (SELECT * FROM (SELECT * FROM (SELECT * FROM (SELECT * FROM rackspace LEFT JOIN servers on servers.rackspaceId=rackspace.rackspaceId WHERE class<>'Virtual') WHERE serverOS IS NULL UNION (SELECT * FROM rackspace LEFT JOIN servers on servers.rackspaceId=rackspace.rackspaceId WHERE class<>'Virtual' AND serverOS NOT IN('RSA2','Network'))) WHERE reserved<>'1' AND serverOS='Windows' ORDER BY serverOS ASC) WHERE serverName LIKE '%SXQA%')";
	linSrvSql="SELECT COUNT(*) AS linCount FROM (SELECT * FROM (SELECT * FROM (SELECT * FROM (SELECT * FROM rackspace LEFT JOIN servers on servers.rackspaceId=rackspace.rackspaceId WHERE class<>'Virtual') WHERE serverOS IS NULL UNION (SELECT * FROM rackspace LEFT JOIN servers on servers.rackspaceId=rackspace.rackspaceId WHERE class<>'Virtual' AND serverOS NOT IN('RSA2','Network'))) WHERE reserved<>'1' AND serverOS IN ('Linux','ESX') ORDER BY serverOS ASC) WHERE serverName LIKE '%SLQA%')";
	aixSrvSql="SELECT COUNT(*) AS aixCount FROM (SELECT * FROM (SELECT * FROM (SELECT * FROM (SELECT * FROM rackspace LEFT JOIN servers on servers.rackspaceId=rackspace.rackspaceId WHERE class<>'Virtual') WHERE serverOS IS NULL UNION (SELECT * FROM rackspace LEFT JOIN servers on servers.rackspaceId=rackspace.rackspaceId WHERE class<>'Virtual' AND serverOS NOT IN('RSA2','Network'))) WHERE reserved<>'1' AND serverOS='AIX' ORDER BY serverOS ASC) WHERE serverName LIKE '%SVQA%')";

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

	physQaDetailMetaString=physQaDetailMetaString+"<TR><TH colspan='4'>Breakdown By OS&nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp</TH></TR>";
	physQaDetailMetaString=physQaDetailMetaString+"<TR><TH class='UNDER'>&nbsp</TH><TH class='UNDER'>Lin&nbsp &nbsp</TH><TH class='UNDER'>Win&nbsp &nbsp</TH><TH class='UNDER'>AIX&nbsp &nbsp</TH></TR>";
	physQaDetailMetaString=physQaDetailMetaString+"<TR><TD style='text-align:left'>QA Phys. Servers</TD><TD>"+srvDat.Tables[0].Rows[0]["Win"].ToString()+"</TD><TD>"+srvDat.Tables[0].Rows[0]["Lin"].ToString()+"</TD><TD>"+srvDat.Tables[0].Rows[0]["AIX"].ToString()+"</TD></TR>";
	physQaDetailMetaString=physQaDetailMetaString+"<TR><TD></TD><TD></TD><TD></TD><TD></TD></TR>";
	physQaDetailMetaString=physQaDetailMetaString+"</TABLE></CENTER>";

	PhysQaDetailMeta.InnerHtml=physQaDetailMetaString;
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
								 <B>PHE Virtual Servers</B>
							</TD>
						</TR>
						<TR>
							<TD>
								<Chart:ReportPieChart id="VirtPheDetailPieChart" runat="server" />
							</TD>
							<TD style="width: 5px;"> </TD>
							<TD> &nbsp &nbsp &nbsp &nbsp<BR>
								<BUTTON id="goVirtPheDetailButton" OnServerClick="goVirtPheDetail" style="font-size:80%" runat="server">List Servers</BUTTON>
							</TD>
						</TR>
						<TR>
							<TD colspan=3>
								 <DIV id="virtPheDetailMeta" runat="server"/> &nbsp &nbsp &nbsp &nbsp
							</TD>
						</TR>
					</TABLE>
					<BR>
					<TABLE border='0' style='border:1px solid #000'>
						<TR>
							<TD colspan=3 align=center>
								 <B>PRP+QA Virtual Servers</B>
							</TD>
						</TR>
						<TR>
							<TD>
								<Chart:ReportPieChart id="VirtPrpDetailPieChart" runat="server" />
							</TD>
							<TD style="width: 5px;"> </TD>
							<TD><BR>
								<BUTTON id="goVirtPrpDetailButton" OnServerClick="goVirtPrpDetail" style="font-size:80%" runat="server">List Servers</BUTTON>
							</TD>
						</TR>
						<TR>
							<TD colspan=3>
								 <DIV id="virtPrpDetailMeta" runat="server"/> &nbsp &nbsp &nbsp &nbsp
							</TD>
						</TR>
					</TABLE>
				</TD>
<!-- -------------------------------------------------------------------------------------------------------------  -->
				<TD>
					<TABLE border='0' style='border:1px solid #000'>
						<TR>
							<TD colspan=3 align=center >
								 <B>ABQDC Overall Physical Servers</B>
							</TD>
						</TR>
						<TR>
							<TD>
								<Chart:ReportPieChart id="PhysAbqdcDetailPieChart" runat="server" />
							</TD>
							<TD style="width: 5px;"> </TD>
							<TD><BR>
								<BUTTON id="goPhysAbqdcDetailButton" OnServerClick="goPhysAbqdcDetail" style="font-size:80%" runat="server">List Servers</BUTTON>
							</TD>
						</TR>
						<TR>
							<TD colspan=3>
								 <DIV id="PhysAbqdcDetailMeta" runat="server"/> &nbsp &nbsp &nbsp &nbsp
							</TD>
						</TR>
					</TABLE>
					<BR>
					<TABLE border='0' class='altrow' style='border:1px solid #000'>
						<TR>
							<TD colspan=3 align=center>
								 <B>PHE Physical Servers</B>
							</TD>
						</TR>
						<TR>
							<TD>
								<Chart:ReportPieChart id="PhysPheDetailPieChart" runat="server" />
							</TD>
							<TD style="width: 5px;"> </TD>
							<TD><BR>
								<BUTTON id="goPhysPheDetailButton" OnServerClick="goPhysPheDetail" style="font-size:80%" runat="server">List Servers</BUTTON>
							</TD>
						</TR>
						<TR>
							<TD colspan=3>
								 <DIV id="PhysPheDetailMeta" runat="server"/> &nbsp &nbsp &nbsp &nbsp
							</TD>
						</TR>
					</TABLE>
					<BR>
					<TABLE border='0' style='border:1px solid #000'>
						<TR>
							<TD colspan=3 align=center>
								 <B>PRP Physical Servers</B>
							</TD>
						</TR>
						<TR>
							<TD>
								<Chart:ReportPieChart id="PhysPrpDetailPieChart" runat="server" />
							</TD>
							<TD style="width: 5px;"> </TD>
							<TD><BR>
								<BUTTON id="goPhysPrpDetailButton" OnServerClick="goPhysPrpDetail" style="font-size:80%" runat="server">List Servers</BUTTON>
							</TD>
						</TR>
						<TR>
							<TD colspan=3>
								 <DIV id="PhysPrpDetailMeta" runat="server"/> &nbsp &nbsp &nbsp &nbsp
							</TD>
						</TR>
					</TABLE>
					<BR>
					<TABLE border='0' class='altrow' style='border:1px solid #000'>
						<TR>
							<TD colspan=3 align=center>
								 <B>QA Physical Servers</B>
							</TD>
						</TR>
						<TR>
							<TD>
								<Chart:ReportPieChart id="PhysQaDetailPieChart" runat="server" />
							</TD>
							<TD style="width: 5px;"> </TD>
							<TD>
								<BR>
								<BUTTON id="goPhysQaDetailButton" OnServerClick="goPhysQaDetail" style="font-size:80%" runat="server">List Servers</BUTTON>
							</TD>
						</TR>
						<TR>
							<TD colspan=3>
								 <DIV id="PhysQaDetailMeta" runat="server"/> &nbsp &nbsp &nbsp &nbsp
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