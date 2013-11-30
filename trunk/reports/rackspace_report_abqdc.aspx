<%@Page Inherits="ESMS.esmsLibrary" src="../esmsLibrary.cs" Language="C#" debug="true" %>
<%@Register TagPrefix="Chart" TagName="ReportPieChart" Src="./ReportPieChart.ascx" %>
<%@Import namespace="System.Drawing" %>
<%@Import Namespace="System.Data.OleDb"%>
<%@Import Namespace="System.Data"%>
<%@Import Namespace="System"%>
<HTML>
<LINK REL="SHORTCUT ICON" HREF="../img/favicon.ico" />

<TITLE>ESMS: Rackspace Report</TITLE>
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

	reportTitle.InnerHtml="Rackspace Availability Report";

	float rackTotal, rackFreeBlade, rackFreeXseries, rackFreePseries, rackOccupied, rackAvailable;
	string rackTotalSql = "SELECT count(*) FROM (SELECT * from rackspace where reserved='0'  AND class<>'Virtual' order by rack asc, bc asc, slot asc)";
	dat=readDb(rackTotalSql);
	if (dat!=null)
	{
		rackTotal=Convert.ToSingle(dat.Tables[0].Rows[0]["Expr1000"].ToString());
	}
	else
	{
		rackTotal=0;
	}
//	Response.Write("RackTotal: "+rackTotal+"<BR>");
	string rackFreeBladeSql = "SELECT COUNT(*) FROM (SELECT * FROM (SELECT * FROM (rackspace LEFT JOIN [SELECT * from servers where serverOS<>'RSA2']. AS E1 ON rackspace.rackspaceId = E1.rackspaceId)) WHERE reserved<>'1' AND class<>'Virtual' AND serverName is Null ORDER BY rack ASC, bc ASC, slot ASC) WHERE class IN (SELECT distinct(hwClassName) FROM hwTypes WHERE hwType='Blade')";
	dat=readDb(rackFreeBladeSql);
	if (dat!=null)
	{
		rackFreeBlade=Convert.ToSingle(dat.Tables[0].Rows[0]["Expr1000"].ToString());
	}
	else
	{
		rackFreeBlade=0;
	}
//	Response.Write("RackFreeBlade: "+rackFreeBlade+"<BR>");
	string rackFreeXseriesSql = "SELECT COUNT(*) FROM (SELECT * FROM (SELECT * FROM (rackspace LEFT JOIN [SELECT * from servers where serverOS<>'RSA2']. AS E1 ON rackspace.rackspaceId = E1.rackspaceId)) WHERE reserved<>'1' AND class<>'Virtual' AND serverName is Null ORDER BY rack ASC, bc ASC, slot ASC) WHERE class IN (SELECT distinct(hwClassName) FROM hwTypes WHERE hwType='Server' AND hwClassName<>'Virtual' AND hwClassName<>'B50' AND hwClassName NOT LIKE 'RSA%' AND hwClassName NOT LIKE 'P%')";
	dat=readDb(rackFreeXseriesSql);
	if (dat!=null)
	{
		rackFreeXseries=Convert.ToSingle(dat.Tables[0].Rows[0]["Expr1000"].ToString());
	}
	else
	{
		rackFreeXseries=0;
	}
//	Response.Write("RackFreeXseries: "+rackFreeXseries+"<BR>");
	string rackFreePseriesSql = "SELECT count(*) FROM (SELECT * FROM (SELECT * FROM (rackspace LEFT JOIN [SELECT * from servers where serverOS<>'RSA2']. AS E1 ON rackspace.rackspaceId = E1.rackspaceId)) WHERE reserved<>'1' AND serverName is Null ORDER BY rack ASC, bc ASC, slot ASC) WHERE class IN (SELECT distinct(hwClassName) FROM hwTypes WHERE hwType='Server' AND hwClassName<>'B50' AND hwClassName NOT LIKE 'RSA%' AND hwClassName LIKE 'P%') OR model LIKE 'P%Virtual'";
	dat=readDb(rackFreePseriesSql);
	if (dat!=null)
	{
		rackFreePseries=Convert.ToSingle(dat.Tables[0].Rows[0]["Expr1000"].ToString());
	}
	else
	{
		rackFreePseries=0;
	}
//	Response.Write("RackFreePseries: "+rackFreePseries+"<BR>");

	rackAvailable=rackFreeXseries+rackFreePseries+rackFreeBlade;
	rackOccupied=rackTotal-rackFreeXseries-rackFreePseries-rackFreeBlade;

//	Response.Write("RackAvailable: "+rackAvailable+"<BR>");
//	Response.Write("RackOccupied: "+rackOccupied+"<BR>");

	double chartFreeBlades, chartFreeXSeries, chartFreePSeries, chartOccupied;

	chartFreeBlades=Math.Round(((rackFreeBlade/rackTotal)*100) + 2/10.0,2);
	chartFreeXSeries=Math.Round(((rackFreeXseries/rackTotal)*100) + 2/10.0,2);
	chartFreePSeries=Math.Round(((rackFreePseries/rackTotal)*100) + 2/10.0,2);
	chartOccupied=Math.Round(((rackOccupied/rackTotal)*100) + 2/10.0,2);
	
//	Response.Write("ChartFreeBlades: "+chartFreeBlades+"<BR>");
//	Response.Write("ChartFreeXSeries: "+chartFreeXSeries+"<BR>");
//	Response.Write("ChartFreePSeries: "+chartFreePSeries+"<BR>");
//	Response.Write("ChartOccupied: "+chartOccupied+"<BR>");



	ReportPieChart_ascx.PieChartElement myPieChartElement1 = new ReportPieChart_ascx.PieChartElement();
	ReportPieChart_ascx.PieChartElement myPieChartElement2 = new ReportPieChart_ascx.PieChartElement();
	ReportPieChart_ascx.PieChartElement myPieChartElement3 = new ReportPieChart_ascx.PieChartElement();
	ReportPieChart_ascx.PieChartElement myPieChartElement4 = new ReportPieChart_ascx.PieChartElement();

	myPieChartElement1.Name = "Blades";
	myPieChartElement1.Percent = chartFreeBlades;
	myPieChartElement1.Color = Color.FromArgb(0, 0, 255);
	RackCapacityPieChart.addPieChartElement(myPieChartElement1);

	myPieChartElement3.Name = "xSeries";
	myPieChartElement3.Percent = chartFreeXSeries;
	myPieChartElement3.Color = Color.FromArgb(255, 255, 0);
	RackCapacityPieChart.addPieChartElement(myPieChartElement3);

	myPieChartElement2.Name = "pSeries";
	myPieChartElement2.Percent = chartFreePSeries;
	myPieChartElement2.Color = Color.FromArgb(0, 255, 0);
	RackCapacityPieChart.addPieChartElement(myPieChartElement2);

	myPieChartElement4.Name = "Occupied";
	myPieChartElement4.Percent = chartOccupied;
	myPieChartElement4.Color = Color.FromArgb(200, 30, 0);
	RackCapacityPieChart.addPieChartElement(myPieChartElement4);
        
	RackCapacityPieChart.ChartTitle = "";
	RackCapacityPieChart.ImageAlt = "Rackspace Availability";
	RackCapacityPieChart.ImageWidth = 300;
	RackCapacityPieChart.ImageHeight = 175;

	RackCapacityPieChart.generateChartImage();

	capacityMeta.InnerHtml="<B>Total Rackspace in ABQDC:</B> "+rackTotal.ToString()+"<BR><BR><B>Occupied Rackspace in ABQDC:</B> "+rackOccupied.ToString()+"<BR><BR><B>Available Rackspace in ABQDC:</B> "+rackAvailable.ToString()+"<BR>&nbsp &nbsp <B>Available Blades:</B> "+rackFreeBlade.ToString()+"<BR>&nbsp &nbsp <B>Available xSeries:</B> "+rackFreeXseries.ToString()+"<BR>&nbsp &nbsp <B>Available pSeries/LPARs:</B> "+rackFreePseries.ToString();

	sql="SELECT * FROM (SELECT * FROM (rackspace LEFT JOIN [SELECT * from servers where serverOS<>'RSA2']. AS E1 ON rackspace.rackspaceId = E1.rackspaceId)) WHERE reserved<>'1' AND class<>'Virtual' AND serverName is Null ORDER BY rack ASC, bc ASC, slot ASC UNION SELECT * FROM (SELECT * FROM (rackspace LEFT JOIN [SELECT * from servers where serverOS<>'RSA2']. AS E1 ON rackspace.rackspaceId = E1.rackspaceId)) WHERE reserved<>'1' AND model LIKE 'P%Virtual' AND serverName is Null ORDER BY class ASC, rack ASC, bc ASC, slot ASC";
//	Response.Write("TableSql: "+sql+"<BR>");
	dat=readDb(sql);
	if (dat!=null)
	{
		fill=false;
		tr = new HtmlTableRow();    //Output <TR>
			tr.Attributes.Add("class","blackheading");
			td = new HtmlTableCell(); //Output <TD>
				td.Attributes.Add("colspan","7");
				td.Attributes.Add("style","width: 625px;");
				td.InnerHtml = "Available Server Rackspace Detail";
			tr.Cells.Add(td);         //Output </TD>
		svrTbl.Rows.Add(tr);           //Output </TR>
		tr = new HtmlTableRow();    //Output <TR>
			tr.Attributes.Add("class","tableheading");
			td = new HtmlTableCell(); //Output <TD>
				td.InnerHtml = "Class";
			tr.Cells.Add(td);         //Output </TD>
			td = new HtmlTableCell(); //Output <TD>
				td.InnerHtml = "Model";
			tr.Cells.Add(td);         //Output </TD>
			td = new HtmlTableCell(); //Output <TD>
				td.InnerHtml = "Serial";
			tr.Cells.Add(td);         //Output </TD>
			td = new HtmlTableCell(); //Output <TD>
				td.InnerHtml = "SAN Attached?";
			tr.Cells.Add(td);         //Output </TD>
			td = new HtmlTableCell(); //Output <TD>
				td.InnerHtml = "Row/Cabinet";
			tr.Cells.Add(td);         //Output </TD>
			td = new HtmlTableCell(); //Output <TD>
				td.InnerHtml = "BC";
			tr.Cells.Add(td);         //Output </TD>
			td = new HtmlTableCell(); //Output <TD>
				td.InnerHtml = "Slot";
			tr.Cells.Add(td);         //Output </TD>
		svrTbl.Rows.Add(tr);           //Output </TR>	
		foreach (DataTable dtt in dat.Tables)
		{
			foreach (DataRow drr in dtt.Rows)
			{
				tr = new HtmlTableRow();    //Output <TR>
				if (fill) tr.BgColor="#edf0f3";
					td = new HtmlTableCell(); //Output <TD>
						if (drr["class"].ToString()=="")
						{
							td.InnerHtml= "--";
						}
						else
						{
							td.InnerHtml= drr["class"].ToString();
						}
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						if (drr["model"].ToString()=="")
						{
							td.InnerHtml= "--";
						}
						else
						{
							td.InnerHtml= drr["model"].ToString();
						}
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						if (drr["serial"].ToString()=="")
						{
							td.InnerHtml= "--";
						}
						else
						{
							td.InnerHtml= drr["serial"].ToString();
						}
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						if (drr["sanAttached"].ToString()=="")
						{
							td.InnerHtml= "--";
						}
						else
						{
							if (drr["sanAttached"].ToString()=="1")
							{
								td.InnerHtml="Yes";
							}
							else
							{
								td.InnerHtml="No";
							}
						}
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						if (drr["rack"].ToString()=="")
						{
							td.InnerHtml= "--";
						}
						else
						{
							td.InnerHtml = "R:"+drr["rack"].ToString().Substring(0,2)+", C:"+drr["rack"].ToString().Substring(2,2);
						}
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						if (drr["bc"].ToString()=="")
						{
							td.InnerHtml= "--";
						}
						else
						{
							td.InnerHtml= drr["bc"].ToString();
						}
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						if (drr["slot"].ToString()=="")
						{
							td.InnerHtml= "--";
						}
						else
						{
							td.InnerHtml= drr["slot"].ToString();
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

		<TABLE border=0>
			<TR>
				<TD>
					<Chart:ReportPieChart id="RackCapacityPieChart" runat="server" />
				</TD>
				<TD style="width: 5px;"> </TD>
				<TD><DIV id="capacityMeta" runat="server"/> &nbsp &nbsp &nbsp &nbsp </TD>
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