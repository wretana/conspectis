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

	reportTitle.InnerHtml=" Report";

	double element1Value, element2Value, element3Value, element4Value;

	element1Value=Math.Round(((1)*100) + 2/10.0,2);
	element2Value=Math.Round(((1)*100) + 2/10.0,2);
	element3Value=Math.Round(((1)*100) + 2/10.0,2);
	element4Value=Math.Round(((1)*100) + 2/10.0,2);

	ReportPieChart_ascx.PieChartElement myPieChartElement1 = new ReportPieChart_ascx.PieChartElement();
	ReportPieChart_ascx.PieChartElement myPieChartElement2 = new ReportPieChart_ascx.PieChartElement();
	ReportPieChart_ascx.PieChartElement myPieChartElement3 = new ReportPieChart_ascx.PieChartElement();
	ReportPieChart_ascx.PieChartElement myPieChartElement4 = new ReportPieChart_ascx.PieChartElement();

	myPieChartElement1.Name = "Element1";
	myPieChartElement1.Percent = element1Value;
	myPieChartElement1.Color = Color.FromArgb(0, 0, 255);
	ReportPieChart.addPieChartElement(myPieChartElement1);

	myPieChartElement3.Name = "Element2";
	myPieChartElement3.Percent = element2Value;
	myPieChartElement3.Color = Color.FromArgb(255, 255, 0);
	ReportPieChart.addPieChartElement(myPieChartElement3);

	myPieChartElement2.Name = "Element3";
	myPieChartElement2.Percent = element3Value;
	myPieChartElement2.Color = Color.FromArgb(0, 255, 0);
	ReportPieChart.addPieChartElement(myPieChartElement2);

	myPieChartElement4.Name = "Element4";
	myPieChartElement4.Percent = element4Value;
	myPieChartElement4.Color = Color.FromArgb(200, 30, 0);
	ReportPieChart.addPieChartElement(myPieChartElement4);
        
	ReportPieChart.ChartTitle = "";
	ReportPieChart.ImageAlt = "ReportChart";
	ReportPieChart.ImageWidth = 300;
	ReportPieChart.ImageHeight = 175;

	ReportPieChart.generateChartImage();

	reportMeta.InnerHtml="";

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
					<Chart:ReportPieChart id="ReportPieChart" runat="server" />
				</TD>
				<TD style="width: 5px;"> </TD>
				<TD><DIV id="reportMeta" runat="server"/> &nbsp &nbsp &nbsp &nbsp </TD>
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