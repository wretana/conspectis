<%@Page Inherits="ESMS.esmsLibrary" src="../esmsLibrary.cs" Language="C#" debug="true" %>
<%@Import namespace="System.Drawing" %>
<%@Import Namespace="System.Data.OleDb"%>
<%@Import Namespace="System.Data"%>
<%@Import Namespace="System"%>
<HTML>
<LINK REL="SHORTCUT ICON" HREF="../img/favicon.ico" />

<TITLE>ESMS: SR Footprint Report</TITLE>
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
	DataSet dat, dat1, dat2;
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

	reportTitle.InnerHtml="SR Footprint Report";
/*
	double element1Value, element2Value, element3Value, element4Value;

	element1Value=Math.Round(((1)*100) + 2/10.0,2);
	element2Value=Math.Round(((1)*100) + 2/10.0,2);
	element3Value=Math.Round(((1)*100) + 2/10.0,2);
	element4Value=Math.Round(((1)*100) + 2/10.0,2);

	PrintablePieChart_ascx.PieChartElement myPieChartElement1 = new PrintablePieChart_ascx.PieChartElement();
	PrintablePieChart_ascx.PieChartElement myPieChartElement2 = new PrintablePieChart_ascx.PieChartElement();
	PrintablePieChart_ascx.PieChartElement myPieChartElement3 = new PrintablePieChart_ascx.PieChartElement();
	PrintablePieChart_ascx.PieChartElement myPieChartElement4 = new PrintablePieChart_ascx.PieChartElement();

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
*/
	reportMeta.InnerHtml="";

	sql="SELECT DISTINCT(Expr1000) FROM (SELECT LEFT(serverPurpose,INSTR(serverPurpose,' ')) FROM servers WHERE serverPurpose LIKE 'SR%')";
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
				td.InnerHtml = "SR#";
			tr.Cells.Add(td);         //Output </TD>
			td = new HtmlTableCell(); //Output <TD>
				td.InnerHtml = "# in PHE";
			tr.Cells.Add(td);         //Output </TD>
			td = new HtmlTableCell(); //Output <TD>
				td.InnerHtml = "Servers in PHE";
			tr.Cells.Add(td);         //Output </TD>
			td = new HtmlTableCell(); //Output <TD>
				td.InnerHtml = "# in PRP";
			tr.Cells.Add(td);         //Output </TD>
			td = new HtmlTableCell(); //Output <TD>
				td.InnerHtml = "Servers in PRP";
			tr.Cells.Add(td);         //Output </TD>
			td = new HtmlTableCell(); //Output <TD>
				td.InnerHtml = "# in QA";
			tr.Cells.Add(td);         //Output </TD>
			td = new HtmlTableCell(); //Output <TD>
				td.InnerHtml = "Servers in QA";
			tr.Cells.Add(td);         //Output </TD>
		svrTbl.Rows.Add(tr);           //Output </TR>	
		string pheSRCount="", prpSRCount="", qaSRCount="";
		string pheSRList="", prpSRList="", qaSRList="";
		foreach (DataTable dtt in dat.Tables)
		{
			foreach (DataRow drr in dtt.Rows)
			{
				if (drr["Expr1000"].ToString()!="")
				{
					pheSRList="";
					prpSRList="";
					qaSRList="";

					sql="SELECT * FROM(SELECT * FROM rackspace LEFT JOIN servers ON rackspace.rackspaceId=servers.rackspaceId WHERE servername LIKE '%PHE%') WHERE serverPurpose LIKE '%"+drr["Expr1000"].ToString()+"%' ORDER BY servername ASC";
					dat1=readDb(sql);
					if (dat1!=null)
					{
						foreach (DataTable dtt1 in dat1.Tables)
						{
							foreach (DataRow drr1 in dtt1.Rows)
							{
								pheSRList=pheSRList+"<A class='black' href='javascript:{}' onclick=javascript:window.open('../showServer.aspx?host="+drr1["serverName"].ToString()+"','showServerWin','width=350,height=700,menubar=no,status=yes,scrollbars=yes') class='black'>"+drr1["serverName"].ToString()+" - "+drr1["class"].ToString()+"</A><BR>";
							}
						}
					}
					sql="SELECT COUNT(*) FROM(SELECT * FROM rackspace LEFT JOIN servers ON rackspace.rackspaceId=servers.rackspaceId WHERE servername LIKE '%PHE%') WHERE serverPurpose LIKE '%"+drr["Expr1000"].ToString()+"%'";
					dat2=readDb(sql);
					if (dat2!=null)
					{
						pheSRCount=dat2.Tables[0].Rows[0]["Expr1000"].ToString();
					}


					sql="SELECT * FROM(SELECT * FROM rackspace LEFT JOIN servers ON rackspace.rackspaceId=servers.rackspaceId WHERE servername LIKE '%PRP%') WHERE serverPurpose LIKE '%"+drr["Expr1000"].ToString()+"%' ORDER BY servername ASC";
					dat1=readDb(sql);
					if (dat1!=null)
					{
						foreach (DataTable dtt1 in dat1.Tables)
						{
							foreach (DataRow drr1 in dtt1.Rows)
							{
								prpSRList=prpSRList+"<A class='black' href='javascript:{}' onclick=javascript:window.open('../showServer.aspx?host="+drr1["serverName"].ToString()+"','showServerWin','width=350,height=700,menubar=no,status=yes,scrollbars=yes') class='black'>"+drr1["serverName"].ToString()+" - "+drr1["class"].ToString()+"</A><BR>";
							}
						}
					}
					sql="SELECT COUNT(*) FROM(SELECT * FROM rackspace LEFT JOIN servers ON rackspace.rackspaceId=servers.rackspaceId WHERE servername LIKE '%PRP%') WHERE serverPurpose LIKE '%"+drr["Expr1000"].ToString()+"%'";
					dat2=readDb(sql);
					if (dat2!=null)
					{
						prpSRCount=dat2.Tables[0].Rows[0]["Expr1000"].ToString();
					}


					sql="SELECT * FROM(SELECT * FROM rackspace LEFT JOIN servers ON rackspace.rackspaceId=servers.rackspaceId WHERE servername LIKE '%QA%') WHERE serverPurpose LIKE '%"+drr["Expr1000"].ToString()+"%' ORDER BY servername ASC";
					dat1=readDb(sql);
					if (dat1!=null)
					{
						foreach (DataTable dtt1 in dat1.Tables)
						{
							foreach (DataRow drr1 in dtt1.Rows)
							{
								qaSRList=pheSRList+"<A class='black' href='javascript:{}' onclick=javascript:window.open('../showServer.aspx?host="+drr1["serverName"].ToString()+"','showServerWin','width=350,height=700,menubar=no,status=yes,scrollbars=yes') class='black'>"+drr1["serverName"].ToString()+" - "+drr1["class"].ToString()+"</A><BR>";
							}
						}
					}
					sql="SELECT COUNT(*) FROM(SELECT * FROM rackspace LEFT JOIN servers ON rackspace.rackspaceId=servers.rackspaceId WHERE servername LIKE '%QA%') WHERE serverPurpose LIKE '%"+drr["Expr1000"].ToString()+"%'";
					dat2=readDb(sql);
					if (dat2!=null)
					{
						qaSRCount=dat2.Tables[0].Rows[0]["Expr1000"].ToString();
					}
					tr = new HtmlTableRow();    //Output <TR>
					if (fill) tr.BgColor="#edf0f3";
						td = new HtmlTableCell(); //Output <TD>
							td.InnerHtml=drr["Expr1000"].ToString();
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
							td.InnerHtml=pheSRCount.ToString();
							td.Attributes.Add("align","center");
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
							td.InnerHtml=pheSRList.ToString();
							td.Attributes.Add("style","font-size:7pt;");
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
							td.InnerHtml=prpSRCount.ToString();
							td.Attributes.Add("align","center");
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
							td.InnerHtml=prpSRList.ToString();
							td.Attributes.Add("style","font-size:7pt;");
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
							td.InnerHtml=qaSRCount.ToString();
							td.Attributes.Add("align","center");
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
							td.InnerHtml=qaSRList.ToString();
							td.Attributes.Add("style","font-size:7pt;");
						tr.Cells.Add(td);         //Output </TD>
					svrTbl.Rows.Add(tr);           //Output </TR>
					fill=!fill;
				}
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