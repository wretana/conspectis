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

	string sql = "";
	DataSet dat = new DataSet();
	DataSet dat1 = new DataSet();
	HttpCookie cookie;
	bool sqlSuccess=true;
	HtmlTableRow tr;
	HtmlTableCell td;
	bool fill;
	string spec, maxVer, os, env, srch;
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

	try
	{
		spec=Request.QueryString["spec"].ToString();
	}
	catch (System.Exception ex)
	{
		spec = "";
	}	

	try
	{
		maxVer=Request.QueryString["maxVer"].ToString();
	}
	catch (System.Exception ex)
	{
		maxVer = "";
	}

	if (IsPostBack)
	{
	}

	reportTitle.InnerHtml="VM Tools Detail Report";

	string[] tableHeads = new string[7];
	string[] datHeads = new string[8];
	string tableTitle="";

	switch (spec)
	{
		case "crit":
			sql="SELECT serverName, serverLanIp, serverOS, serverPurpose, memberOfCluster, serverRsaIp, VMToolsState, VMPowerState, VMToolsVersion FROM (SELECT * FROM servers WHERE memberOfCluster IS NOT NULL ORDER BY memberOfCluster ASC) WHERE VMPowerState='PoweredOn' AND VMToolsState='NotRunning'";
			tableHeads[0] = "VM";
			tableHeads[1] = "IP Address";
			tableHeads[2] = "OS";
			tableHeads[3] = "Purpose";
			tableHeads[4] = "Cluster";
			tableHeads[5] = "VM Power";
			tableHeads[6] = "VM Tools";
			datHeads[0] = "serverName";
			datHeads[1] = "serverLanIp";
			datHeads[2] = "serverOS";
			datHeads[3] = "serverPurpose";
			datHeads[4] = "memberOfCluster";
			datHeads[5] = "serverRsaIp";
			datHeads[6] = "VMPowerState";
			datHeads[7] = "VMToolsState";
			tableTitle="VM's Needing VMTools Install/Reinstall";
		break;
		case "prob":
			sql="SELECT serverName, serverLanIp, serverOS, serverPurpose, memberOfCluster, serverRsaIp, VMToolsState, VMPowerState, VMToolsVersion FROM (SELECT * FROM servers WHERE memberOfCluster IS NOT NULL ORDER BY memberOfCluster ASC) WHERE VMPowerState='PoweredOff' AND VMToolsState='NotRunning'";
			tableHeads[0] = "VM";
			tableHeads[1] = "IP Address";
			tableHeads[2] = "OS";
			tableHeads[3] = "Purpose";
			tableHeads[4] = "Cluster";
			tableHeads[5] = "VM Power";
			tableHeads[6] = "VM Tools";
			datHeads[0] = "serverName";
			datHeads[1] = "serverLanIp";
			datHeads[2] = "serverOS";
			datHeads[3] = "serverPurpose";
			datHeads[4] = "memberOfCluster";
			datHeads[5] = "serverRsaIp";
			datHeads[6] = "VMPowerState";
			datHeads[7] = "VMToolsState";
			tableTitle="VM's Probably Needing VMTools Install/Reinstall";
		break;
		case "winUpd":
			sql="SELECT serverName, serverLanIp, serverOS, serverPurpose, memberOfCluster, serverRsaIp, VMToolsState, VMPowerState, VMToolsVersion FROM (SELECT * FROM servers WHERE memberOfCluster IS NOT NULL ORDER BY memberOfCluster ASC, serverOS ASC) WHERE VMToolsState='Running' AND serverOS='Windows' AND VMToolsVersion<>(SELECT MAX(VMToolsVersion) FROM servers WHERE serverOS='Windows')";
			tableHeads[0] = "VM";
			tableHeads[1] = "IP Address";
			tableHeads[2] = "OS";
			tableHeads[3] = "Purpose";
			tableHeads[4] = "Cluster";
			tableHeads[5] = "VM Power";
			tableHeads[6] = "Tools Build";
			datHeads[0] = "serverName";
			datHeads[1] = "serverLanIp";
			datHeads[2] = "serverOS";
			datHeads[3] = "serverPurpose";
			datHeads[4] = "memberOfCluster";
			datHeads[5] = "serverRsaIp";
			datHeads[6] = "VMPowerState";
			datHeads[7] = "VMToolsVersion";
			tableTitle="Windows VM's Needing VMTools Update to Build #"+maxVer;
		break;
		case "linUpd":
			sql="SELECT serverName, serverLanIp, serverOS, serverPurpose, memberOfCluster, serverRsaIp, VMToolsState, VMPowerState, VMToolsVersion FROM (SELECT * FROM servers WHERE memberOfCluster IS NOT NULL ORDER BY memberOfCluster ASC, serverOS ASC) WHERE VMToolsState='Running' AND serverOS='Linux' AND VMToolsVersion<>(SELECT MAX(VMToolsVersion) FROM servers WHERE serverOS='Linux')";
			tableHeads[0] = "VM";
			tableHeads[1] = "IP Address";
			tableHeads[2] = "OS";
			tableHeads[3] = "Purpose";
			tableHeads[4] = "Cluster";
			tableHeads[5] = "VM Power";
			tableHeads[6] = "Tools Build";
			datHeads[0] = "serverName";
			datHeads[1] = "serverLanIp";
			datHeads[2] = "serverOS";
			datHeads[3] = "serverPurpose";
			datHeads[4] = "memberOfCluster";
			datHeads[5] = "serverRsaIp";
			datHeads[6] = "VMPowerState";
			datHeads[7] = "VMToolsVersion";
			tableTitle="Linux VM's Needing VMTools Update to Build #"+maxVer;
		break;
	}

	dat=readDb(sql);
	if (dat!=null)
	{
		fill=false;
		tr = new HtmlTableRow();    //Output <TR>
			tr.Attributes.Add("class","blackheading");
			td = new HtmlTableCell(); //Output <TD>
				td.Attributes.Add("colspan","7");
				td.Attributes.Add("style","width: 625px;");
				td.InnerHtml = tableTitle;
			tr.Cells.Add(td);         //Output </TD>
		svrTbl.Rows.Add(tr);           //Output </TR>
		tr = new HtmlTableRow();    //Output <TR>
			tr.Attributes.Add("class","tableheading");
			td = new HtmlTableCell(); //Output <TD>
				td.InnerHtml = tableHeads[0];
			tr.Cells.Add(td);         //Output </TD>
			td = new HtmlTableCell(); //Output <TD>
				td.InnerHtml = tableHeads[1];
			tr.Cells.Add(td);         //Output </TD>
			td = new HtmlTableCell(); //Output <TD>
				td.InnerHtml = tableHeads[2];
			tr.Cells.Add(td);         //Output </TD>
			td = new HtmlTableCell(); //Output <TD>
				td.InnerHtml = tableHeads[3];
			tr.Cells.Add(td);         //Output </TD>
			td = new HtmlTableCell(); //Output <TD>
				td.InnerHtml = tableHeads[4];
			tr.Cells.Add(td);         //Output </TD>
			td = new HtmlTableCell(); //Output <TD>
				td.InnerHtml = tableHeads[5];
			tr.Cells.Add(td);         //Output </TD>
			td = new HtmlTableCell(); //Output <TD>
				td.InnerHtml = tableHeads[6];
			tr.Cells.Add(td);         //Output </TD>
		svrTbl.Rows.Add(tr);           //Output </TR>	
		foreach (DataTable dt in dat.Tables)
		{
			foreach (DataRow dr in dt.Rows)
			{
				tr = new HtmlTableRow();    //Output <TR>
				if (fill) tr.BgColor="#edf0f3";
					td = new HtmlTableCell(); //Output <TD>
						if (dr[datHeads[0]].ToString()!="")
						{
							td.InnerHtml=dr[datHeads[0]].ToString();
						}
						else
						{
							td.InnerHtml="&nbsp";
						}
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						if (dr[datHeads[1]].ToString()!="")
						{
							td.InnerHtml=fix_ip(dr[datHeads[1]].ToString());
						}
						else
						{
							td.InnerHtml="&nbsp";
						}
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						if (dr[datHeads[2]].ToString()!="")
						{
							td.InnerHtml=dr[datHeads[2]].ToString();
						}
						else
						{
							td.InnerHtml="&nbsp";
						}
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						if (dr[datHeads[3]].ToString()!="")
						{
							if (dr[datHeads[3]].ToString().Length>35)
							{
								td.InnerHtml=dr[datHeads[3]].ToString().Substring(0,35)+"...";
							}
							else
							{
								td.InnerHtml=dr[datHeads[3]].ToString();
							}
						}
						else
						{
							td.InnerHtml="&nbsp";
						}
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						td.Attributes.Add("align","center");
						if (dr[datHeads[4]].ToString()!="")
						{
							if (dr[datHeads[5]].ToString()!="")
							{
								td.InnerHtml="<A HREF='javascript:{}' onclick=javascript:window.open('http://"+fix_ip(dr[datHeads[5]].ToString())+"/','VmVicWin','width=800,height=750,menubar=no,status=yes,scrollbars=yes') ALT='Open VIC Web Access'  class='black'>"+dr[datHeads[4]].ToString()+"</A>";
							}
							else
							{
								td.InnerHtml=dr[datHeads[4]].ToString();
							}
						}
						else
						{
							td.InnerHtml="&nbsp";
						}
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						if (dr[datHeads[6]].ToString()!="")
						{
							td.InnerHtml=dr[datHeads[6]].ToString();
						}
						else
						{
							td.InnerHtml="&nbsp";
						}
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						if (dr[datHeads[7]].ToString()!="")
						{
							td.InnerHtml=dr[datHeads[7]].ToString();
						}
						else
						{
							td.InnerHtml="&nbsp";
						}
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
		<TABLE id="svrTbl" runat="server" class="datatable" cellspacing="0" cellpadding="2" border="1"></TABLE>
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