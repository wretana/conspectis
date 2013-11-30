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
 
public void Page_Load(Object o, EventArgs e)
{
	systemStatus(0); // Check to see if admin has put system is in offline mode.

	Response.Write("<script language='JavaScript'>function printWin() {window.print();} function refreshParent() { window.opener.location.href = window.opener.location.href; if (window.opener.progressWindow) { window.opener.progressWindow.close()  }  window.close();}//-->"+"<"+"/script>");

	string sql;
	DataSet dat, dat1, dat2, dat3;
	HttpCookie cookie;
	bool sqlSuccess=true;
	HtmlTableRow tr;
	HtmlTableCell td;
	bool fill;
	string bc, rack, os, env, srch, winVmtMax="", linVmtMax="", needMaint="", noMaint="";
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

	reportTitle.InnerHtml="VM Tools Report";

	reportMeta.InnerHtml="";



	sql="SELECT COUNT(serverName) FROM (SELECT DISTINCT(serverName) FROM (SELECT serverName FROM (SELECT * FROM servers WHERE memberOfCluster IS NOT NULL ORDER BY memberOfCluster ASC) WHERE VMPowerState='PoweredOn' AND VMToolsState='NotRunning' UNION SELECT serverName FROM (SELECT * FROM servers WHERE memberOfCluster IS NOT NULL ORDER BY memberOfCluster ASC) WHERE VMPowerState='PoweredOff' AND VMToolsState='NotRunning' UNION SELECT serverName FROM (SELECT * FROM servers WHERE memberOfCluster IS NOT NULL ORDER BY memberOfCluster ASC, serverOS ASC) WHERE VMToolsState='Running' AND serverOS='Windows' AND VMToolsVersion<>(SELECT MAX(VMToolsVersion) FROM servers WHERE serverOS='Windows') UNION SELECT serverName FROM (SELECT * FROM servers WHERE memberOfCluster IS NOT NULL ORDER BY memberOfCluster ASC, serverOS ASC) WHERE VMToolsState='Running' AND serverOS='Linux' AND VMToolsVersion<>(SELECT MAX(VMToolsVersion) FROM servers WHERE serverOS='Linux')))";
	dat=readDb(sql);
	if (dat!=null)
	{
		needMaint=dat.Tables[0].Rows[0]["Expr1000"].ToString();
	}

	sql="SELECT COUNT(serverName) FROM servers WHERE VMId IS NOT NULL AND serverName NOT IN (SELECT DISTINCT(serverName) FROM (SELECT serverName FROM (SELECT * FROM servers WHERE memberOfCluster IS NOT NULL ORDER BY memberOfCluster ASC) WHERE VMPowerState='PoweredOn' AND VMToolsState='NotRunning' UNION SELECT serverName FROM (SELECT * FROM servers WHERE memberOfCluster IS NOT NULL ORDER BY memberOfCluster ASC) WHERE VMPowerState='PoweredOff' AND VMToolsState='NotRunning' UNION SELECT serverName FROM (SELECT * FROM servers WHERE memberOfCluster IS NOT NULL ORDER BY memberOfCluster ASC, serverOS ASC) WHERE VMToolsState='Running' AND serverOS='Windows' AND VMToolsVersion<>(SELECT MAX(VMToolsVersion) FROM servers WHERE serverOS='Windows') UNION SELECT serverName FROM (SELECT * FROM servers WHERE memberOfCluster IS NOT NULL ORDER BY memberOfCluster ASC, serverOS ASC) WHERE VMToolsState='Running' AND serverOS='Linux' AND VMToolsVersion<>(SELECT MAX(VMToolsVersion) FROM servers WHERE serverOS='Linux')))";
	dat=readDb(sql);
	if (dat!=null)
	{
		noMaint=dat.Tables[0].Rows[0]["Expr1000"].ToString();
	}

	double element1Value, element2Value;

	element1Value=Math.Round(((Convert.ToDouble(needMaint) / (Convert.ToDouble(noMaint)+Convert.ToDouble(needMaint)))*100) + 2/10.0,2);
	element2Value=Math.Round(((Convert.ToDouble(noMaint) / (Convert.ToDouble(noMaint)+Convert.ToDouble(needMaint)))*100) + 2/10.0,2);

	ReportPieChart_ascx.PieChartElement myPieChartElement1 = new ReportPieChart_ascx.PieChartElement();
	ReportPieChart_ascx.PieChartElement myPieChartElement2 = new ReportPieChart_ascx.PieChartElement();

	myPieChartElement1.Name = "Need";
	myPieChartElement1.Percent = element1Value;
	myPieChartElement1.Color = Color.Red;
	ReportPieChart.addPieChartElement(myPieChartElement1);

	myPieChartElement2.Name = "A-OK";
	myPieChartElement2.Percent = element2Value;
	myPieChartElement2.Color = Color.DarkGreen;
	ReportPieChart.addPieChartElement(myPieChartElement2);
        
	ReportPieChart.ChartTitle = "VM Tools Maintenance Status";
	ReportPieChart.ImageAlt = "ReportChart";
	ReportPieChart.ImageWidth = 300;
	ReportPieChart.ImageHeight = 175;

	ReportPieChart.generateChartImage();

	sql="SELECT MAX(VMToolsVersion) FROM servers WHERE serverOS='Windows'";
	dat=readDb(sql);
	if (dat!=null)
	{
		winVmtMax=dat.Tables[0].Rows[0]["Expr1000"].ToString();
	}

	sql="SELECT MAX(VMToolsVersion) FROM servers WHERE serverOS='Linux'";
	dat=readDb(sql);
	if (dat!=null)
	{
		linVmtMax=dat.Tables[0].Rows[0]["Expr1000"].ToString();
	}

	sql="SELECT serverName, serverLanIp, serverOS, serverPurpose, memberOfCluster, serverRsaIp, VMToolsState, VMPowerState, VMToolsVersion FROM (SELECT * FROM servers WHERE memberOfCluster IS NOT NULL ORDER BY memberOfCluster ASC) WHERE VMPowerState='PoweredOn' AND VMToolsState='NotRunning'";
	dat=readDb(sql);

	sql="SELECT serverName, serverLanIp, serverOS, serverPurpose, memberOfCluster, serverRsaIp, VMToolsState, VMPowerState, VMToolsVersion FROM (SELECT * FROM servers WHERE memberOfCluster IS NOT NULL ORDER BY memberOfCluster ASC) WHERE VMPowerState='PoweredOff' AND VMToolsState='NotRunning'";
	dat1=readDb(sql);

	sql="SELECT serverName, serverLanIp, serverOS, serverPurpose, memberOfCluster, serverRsaIp, VMToolsState, VMPowerState, VMToolsVersion FROM (SELECT * FROM servers WHERE memberOfCluster IS NOT NULL ORDER BY memberOfCluster ASC, serverOS ASC) WHERE VMToolsState='Running' AND serverOS='Windows' AND VMToolsVersion<>(SELECT MAX(VMToolsVersion) FROM servers WHERE serverOS='Windows')";
	dat2=readDb(sql);

	sql="SELECT serverName, serverLanIp, serverOS, serverPurpose, memberOfCluster, serverRsaIp, VMToolsState, VMPowerState, VMToolsVersion FROM (SELECT * FROM servers WHERE memberOfCluster IS NOT NULL ORDER BY memberOfCluster ASC, serverOS ASC) WHERE VMToolsState='Running' AND serverOS='Linux' AND VMToolsVersion<>(SELECT MAX(VMToolsVersion) FROM servers WHERE serverOS='Linux')";
	dat3=readDb(sql);

	defTblTitle.InnerHtml="<A href='javascript:{}' onclick=javascript:window.open('vmToolsDetail_report.aspx?spec=crit','newServerWin','width=800,height=800,menubar=no,status=yes,scrollbars=yes') class='black'>CRITICAL - VM's Needing VMTools Install/Reinstall</A>";
	if (dat!=null)
	{
		fill=false;
/*		tr = new HtmlTableRow();    //Output <TR>
			tr.Attributes.Add("class","blackheading");
			td = new HtmlTableCell(); //Output <TD>
				td.Attributes.Add("colspan","5");
//				td.Attributes.Add("style","width: 625px;");
				td.InnerHtml = "";
			tr.Cells.Add(td);         //Output </TD>
		defTbl.Rows.Add(tr);           //Output </TR> */
		tr = new HtmlTableRow();    //Output <TR>
			tr.Attributes.Add("class","tableheading");
			td = new HtmlTableCell(); //Output <TD>
				td.InnerHtml = "VM";
			tr.Cells.Add(td);         //Output </TD>
			td = new HtmlTableCell(); //Output <TD>
				td.InnerHtml = "IP Address";
			tr.Cells.Add(td);         //Output </TD>
			td = new HtmlTableCell(); //Output <TD>
				td.InnerHtml = "OS";
			tr.Cells.Add(td);         //Output </TD>
			td = new HtmlTableCell(); //Output <TD>
				td.InnerHtml = "Purpose";
			tr.Cells.Add(td);         //Output </TD>
			td = new HtmlTableCell(); //Output <TD>
				td.InnerHtml = "Cluster & VIC IP";
			tr.Cells.Add(td);         //Output </TD>
		defTbl.Rows.Add(tr);           //Output </TR>	
		foreach (DataTable dt in dat.Tables)
		{
			foreach (DataRow dr in dt.Rows)
			{
				tr = new HtmlTableRow();    //Output <TR>
				if (fill) tr.BgColor="#edf0f3";
					td = new HtmlTableCell(); //Output <TD>
						if (dr["serverName"].ToString()!="")
						{
							td.InnerHtml=dr["serverName"].ToString();
						}
						else
						{
							td.InnerHtml="&nbsp";
						}
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						if (dr["serverLanIp"].ToString()!="")
						{
							td.InnerHtml=fix_ip(dr["serverlanIp"].ToString());
						}
						else
						{
							td.InnerHtml="&nbsp";
						}
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						if (dr["serverOS"].ToString()!="")
						{
							td.InnerHtml="&nbsp"+dr["serverOS"].ToString()+"&nbsp";
						}
						else
						{
							td.InnerHtml="&nbsp";
						}
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						if (dr["serverPurpose"].ToString()!="")
						{
							if (dr["serverPurpose"].ToString().Length>35)
							{
								td.InnerHtml=dr["serverPurpose"].ToString().Substring(0,35)+"...";
							}
							else
							{
								td.InnerHtml=dr["serverPurpose"].ToString();
							}
						}
						else
						{
							td.InnerHtml="&nbsp";
						}
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						td.Attributes.Add("align","center");
						if (dr["memberOfCluster"].ToString()!="")
						{
							if (dr["serverRsaIp"].ToString()!="")
							{
								td.InnerHtml="<A HREF='javascript:{}' onclick=javascript:window.open('http://"+fix_ip(dr["serverRsaIp"].ToString())+"/','VmVicWin','width=800,height=750,menubar=no,status=yes,scrollbars=yes') ALT='Open VIC Web Access'  class='black'>"+dr["memberOfCluster"].ToString()+"</A>";
							}
							else
							{
								td.InnerHtml=dr["memberOfCluster"].ToString();
							}
						}
						else
						{
							td.InnerHtml="&nbsp";
						}
					tr.Cells.Add(td);         //Output </TD>
				defTbl.Rows.Add(tr);           //Output </TR>
				fill=!fill;
			}
		}
	}

	probTblTitle.InnerHtml="<A href='javascript:{}' onclick=javascript:window.open('vmToolsDetail_report.aspx?spec=prob','newServerWin','width=800,height=800,menubar=no,status=yes,scrollbars=yes') class='black'>VM's Probably Needing VMTools Install/Reinstall</A>";
	if (dat1!=null)
	{
		fill=false;
/*		tr = new HtmlTableRow();    //Output <TR>
			tr.Attributes.Add("class","blackheading");
			td = new HtmlTableCell(); //Output <TD>
				td.Attributes.Add("colspan","5");
//				td.Attributes.Add("style","width: 625px;");
				td.InnerHtml = "";
			tr.Cells.Add(td);         //Output </TD>
		probTbl.Rows.Add(tr);           //Output </TR> */
		tr = new HtmlTableRow();    //Output <TR>
			tr.Attributes.Add("class","tableheading");
			td = new HtmlTableCell(); //Output <TD>
				td.InnerHtml = "VM";
			tr.Cells.Add(td);         //Output </TD>
			td = new HtmlTableCell(); //Output <TD>
				td.InnerHtml = "IP Address";
			tr.Cells.Add(td);         //Output </TD>
			td = new HtmlTableCell(); //Output <TD>
				td.InnerHtml = "OS";
			tr.Cells.Add(td);         //Output </TD>
			td = new HtmlTableCell(); //Output <TD>
				td.InnerHtml = "Purpose";
			tr.Cells.Add(td);         //Output </TD>
			td = new HtmlTableCell(); //Output <TD>
				td.InnerHtml = "Cluster & VIC IP";
			tr.Cells.Add(td);         //Output </TD>
		probTbl.Rows.Add(tr);           //Output </TR>	
		foreach (DataTable dt in dat1.Tables)
		{
			foreach (DataRow dr in dt.Rows)
			{
				tr = new HtmlTableRow();    //Output <TR>
				if (fill) tr.BgColor="#edf0f3";
					td = new HtmlTableCell(); //Output <TD>
						if (dr["serverName"].ToString()!="")
						{
							td.InnerHtml=dr["serverName"].ToString();
						}
						else
						{
							td.InnerHtml="&nbsp";
						}
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						if (dr["serverLanIp"].ToString()!="")
						{
							td.InnerHtml=fix_ip(dr["serverLanIp"].ToString());
						}
						else
						{
							td.InnerHtml="&nbsp";
						}
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						if (dr["serverOS"].ToString()!="")
						{
							td.InnerHtml="&nbsp"+dr["serverOS"].ToString()+"&nbsp";
						}
						else
						{
							td.InnerHtml="&nbsp";
						}
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						if (dr["serverPurpose"].ToString()!="")
						{
							if (dr["serverPurpose"].ToString().Length>35)
							{
								td.InnerHtml=dr["serverPurpose"].ToString().Substring(0,35)+"...";
							}
							else
							{
								td.InnerHtml=dr["serverPurpose"].ToString();
							}
						}
						else
						{
							td.InnerHtml="&nbsp";
						}
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						td.Attributes.Add("align","center");
						if (dr["memberOfCluster"].ToString()!="")
						{
							if (dr["serverRsaIp"].ToString()!="")
							{
								td.InnerHtml="<A HREF='javascript:{}' onclick=javascript:window.open('http://"+fix_ip(dr["serverRsaIp"].ToString())+"/','VmVicWin','width=800,height=750,menubar=no,status=yes,scrollbars=yes') ALT='Open VIC Web Access'  class='black'>"+dr["memberOfCluster"].ToString()+"</A>";
							}
							else
							{
								td.InnerHtml=dr["memberOfCluster"].ToString();
							}
						}
						else
						{
							td.InnerHtml="&nbsp";
						}
					tr.Cells.Add(td);         //Output </TD>
				probTbl.Rows.Add(tr);           //Output </TR>
				fill=!fill;
			}
		}
	}

	winUpdTblTitle.InnerHtml="<A href='javascript:{}' onclick=javascript:window.open('vmToolsDetail_report.aspx?spec=winUpd&maxVer="+winVmtMax+"','newServerWin','width=800,height=800,menubar=no,status=yes,scrollbars=yes') class='black'>Windows VM's Needing VMTools Update to Build #"+winVmtMax+"</A>";
	if (dat2!=null)
	{
		fill=false;
/*		tr = new HtmlTableRow();    //Output <TR>
			tr.Attributes.Add("class","blackheading");
			td = new HtmlTableCell(); //Output <TD>
				td.Attributes.Add("colspan","5");
//				td.Attributes.Add("style","width: 625px;");
				td.InnerHtml = "";
			tr.Cells.Add(td);         //Output </TD>
		WinUpdTbl.Rows.Add(tr);           //Output </TR> */
		tr = new HtmlTableRow();    //Output <TR>
			tr.Attributes.Add("class","tableheading");
			td = new HtmlTableCell(); //Output <TD>
				td.InnerHtml = "VM";
			tr.Cells.Add(td);         //Output </TD>
			td = new HtmlTableCell(); //Output <TD>
				td.InnerHtml = "IP Address";
			tr.Cells.Add(td);         //Output </TD>
			td = new HtmlTableCell(); //Output <TD>
				td.InnerHtml = "OS";
			tr.Cells.Add(td);         //Output </TD>
			td = new HtmlTableCell(); //Output <TD>
				td.InnerHtml = "Purpose";
			tr.Cells.Add(td);         //Output </TD>
			td = new HtmlTableCell(); //Output <TD>
				td.InnerHtml = "Cluster & VIC IP";
			tr.Cells.Add(td);         //Output </TD>
		WinUpdTbl.Rows.Add(tr);           //Output </TR>	
		foreach (DataTable dt in dat2.Tables)
		{
			foreach (DataRow dr in dt.Rows)
			{
				tr = new HtmlTableRow();    //Output <TR>
				if (fill) tr.BgColor="#edf0f3";
					td = new HtmlTableCell(); //Output <TD>
						if (dr["serverName"].ToString()!="")
						{
							td.InnerHtml=dr["serverName"].ToString();
						}
						else
						{
							td.InnerHtml="&nbsp";
						}
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						if (dr["serverLanIp"].ToString()!="")
						{
							td.InnerHtml=fix_ip(dr["serverLanIp"].ToString());
						}
						else
						{
							td.InnerHtml="&nbsp";
						}
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						if (dr["serverOS"].ToString()!="")
						{
							td.InnerHtml="&nbsp"+dr["serverOS"].ToString()+"&nbsp";
						}
						else
						{
							td.InnerHtml="&nbsp";
						}
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						if (dr["serverPurpose"].ToString()!="")
						{
							if (dr["serverPurpose"].ToString().Length>35)
							{
								td.InnerHtml=dr["serverPurpose"].ToString().Substring(0,35)+"...";
							}
							else
							{
								td.InnerHtml=dr["serverPurpose"].ToString();
							}
						}
						else
						{
							td.InnerHtml="&nbsp";
						}
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						td.Attributes.Add("align","center");
						if (dr["memberOfCluster"].ToString()!="")
						{
							if (dr["serverRsaIp"].ToString()!="")
							{
								td.InnerHtml="<A HREF='javascript:{}' onclick=javascript:window.open('http://"+fix_ip(dr["serverRsaIp"].ToString())+"/','VmVicWin','width=800,height=750,menubar=no,status=yes,scrollbars=yes') ALT='Open VIC Web Access'  class='black'>"+dr["memberOfCluster"].ToString()+"</A>";
							}
							else
							{
								td.InnerHtml=dr["memberOfCluster"].ToString();
							}
						}
						else
						{
							td.InnerHtml="&nbsp";
						}
					tr.Cells.Add(td);         //Output </TD>
				WinUpdTbl.Rows.Add(tr);           //Output </TR>
				fill=!fill;
			}
		}
	}

	linUpdTblTitle.InnerHtml="<A href='javascript:{}' onclick=javascript:window.open('vmToolsDetail_report.aspx?spec=linUpd&maxVer="+linVmtMax+"','newServerWin','width=800,height=800,menubar=no,status=yes,scrollbars=yes') class='black'>Linux VM's Needing VMTools Update to Build #"+linVmtMax+"</A>";
	if (dat3!=null)
	{
		fill=false;
/*		tr = new HtmlTableRow();    //Output <TR>
			tr.Attributes.Add("class","blackheading");
			td = new HtmlTableCell(); //Output <TD>
				td.Attributes.Add("colspan","5");
//				td.Attributes.Add("style","width: 625px;");
				td.InnerHtml = "";
			tr.Cells.Add(td);         //Output </TD>
		LinUpdTbl.Rows.Add(tr);           //Output </TR> */
		tr = new HtmlTableRow();    //Output <TR>
			tr.Attributes.Add("class","tableheading");
			td = new HtmlTableCell(); //Output <TD>
				td.InnerHtml = "VM";
			tr.Cells.Add(td);         //Output </TD>
			td = new HtmlTableCell(); //Output <TD>
				td.InnerHtml = "IP Address";
			tr.Cells.Add(td);         //Output </TD>
			td = new HtmlTableCell(); //Output <TD>
				td.InnerHtml = "OS";
			tr.Cells.Add(td);         //Output </TD>
			td = new HtmlTableCell(); //Output <TD>
				td.InnerHtml = "Purpose";
			tr.Cells.Add(td);         //Output </TD>
			td = new HtmlTableCell(); //Output <TD>
				td.InnerHtml = "Cluster & VIC IP";
			tr.Cells.Add(td);         //Output </TD>
		LinUpdTbl.Rows.Add(tr);           //Output </TR>	
		foreach (DataTable dt in dat3.Tables)
		{
			foreach (DataRow dr in dt.Rows)
			{
				tr = new HtmlTableRow();    //Output <TR>
				if (fill) tr.BgColor="#edf0f3";
					td = new HtmlTableCell(); //Output <TD>
						if (dr["serverName"].ToString()!="")
						{
							td.InnerHtml=dr["serverName"].ToString();
						}
						else
						{
							td.InnerHtml="&nbsp";
						}
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						if (dr["serverLanIp"].ToString()!="")
						{
							td.InnerHtml=fix_ip(dr["serverLanIp"].ToString());
						}
						else
						{
							td.InnerHtml="&nbsp";
						}
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						if (dr["serverOS"].ToString()!="")
						{
							td.InnerHtml="&nbsp"+dr["serverOS"].ToString()+"&nbsp";
						}
						else
						{
							td.InnerHtml="&nbsp";
						}
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						if (dr["serverPurpose"].ToString()!="")
						{
							if (dr["serverPurpose"].ToString().Length>35)
							{
								td.InnerHtml=dr["serverPurpose"].ToString().Substring(0,35)+"...";
							}
							else
							{
								td.InnerHtml=dr["serverPurpose"].ToString();
							}
						}
						else
						{
							td.InnerHtml="&nbsp";
						}
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						td.Attributes.Add("align","center");
						if (dr["memberOfCluster"].ToString()!="")
						{
							if (dr["serverRsaIp"].ToString()!="")
							{
								td.InnerHtml="<A HREF='javascript:{}' onclick=javascript:window.open('http://"+fix_ip(dr["serverRsaIp"].ToString())+"/','VmVicWin','width=800,height=750,menubar=no,status=yes,scrollbars=yes') ALT='Open VIC Web Access'  class='black'>"+dr["memberOfCluster"].ToString()+"</A>";
							}
							else
							{
								td.InnerHtml=dr["memberOfCluster"].ToString();
							}
						}
						else
						{
							td.InnerHtml="&nbsp";
						}
					tr.Cells.Add(td);         //Output </TD>
				LinUpdTbl.Rows.Add(tr);           //Output </TR>
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
					<CENTER>
						<A NAME='top'/>
						<Chart:ReportPieChart id="ReportPieChart" runat="server" />
						<BR>
						<TABLE class="datatable" cellspacing="0" cellpadding="2" border="1">
						  <TR class='tableheading'>
						    <TD align='center'>
							  <A HREF='#crit' class='nodec'>Critical</A>
							</TD>
							<TD align='center'>
							  <A HREF='#prob' class='nodec'>Probable</A>
							</TD>
						  </TR>
						  <TR class='tableheading'>
						    <TD align='center'>
							  <A HREF='#winUpd' class='nodec'>Need Update (Win)</A>
							</TD>
							<TD align='center'>
							  <A HREF='#linUpd' class='nodec'>Need Update (Lin)</A>
							</TD>
						  </TR>
						</TABLE>
					</CENTER>
				</TD>
				<TD style="width: 5px;"> </TD>
				<TD><DIV id="reportMeta" runat="server"/> &nbsp &nbsp &nbsp &nbsp </TD>
				
			</TR>
				<TD colspan="3">
					<BR><BR><BR><BR>
					<A NAME="crit" />
					<H2><DIV id="defTblTitle" runat="server"/> </H2>
					<TABLE id="defTbl" runat="server" class="datatable" cellspacing="0" cellpadding="2" border="1"></TABLE>
					<BR><BR>
					<A NAME="prob" />
					<CENTER><A HREF='#top' class='black'>TOP</A></CENTER>
					<H2><DIV id="probTblTitle" runat="server"/></H2>
					<TABLE id="probTbl" runat="server" class="datatable" cellspacing="0" cellpadding="2" border="1"></TABLE>
					<BR><BR>
					<A NAME="winUpd" />
					<CENTER><A HREF='#top' class='black'>TOP</A></CENTER>
					<H2><DIV id="winUpdTblTitle" runat="server"/></H2>
					<TABLE id="WinUpdTbl" runat="server" class="datatable" cellspacing="0" cellpadding="2" border="1"></TABLE>
					<BR><BR>
					<A NAME="linUpd" />
					<CENTER><A HREF='#top' class='black'>TOP</A></CENTER>
					<H2><DIV id="linUpdTblTitle" runat="server"/></H2>
					<TABLE id="LinUpdTbl" runat="server" class="datatable" cellspacing="0" cellpadding="2" border="1"></TABLE>
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