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
	DataSet dat=new DataSet();
	DataSet datWin=new DataSet();
	DataSet datLin=new DataSet();
	DataSet datAix=new DataSet();
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

// ------- Fetch data from cookie stored by referring page ...
	string winSql, linSql, aixSql, rptTitle, lastpage;

	try
	{
		winSql=Request.Cookies["winSql"].Value;
	}
	catch (System.Exception ex)
	{
		winSql="";
	}

	try
	{
		linSql=Request.Cookies["linSql"].Value;
	}
	catch (System.Exception ex)
	{
		linSql="";
	}

	try
	{
		aixSql=Request.Cookies["aixSql"].Value;
	}
	catch (System.Exception ex)
	{
		aixSql="";
	}

	try
	{
		rptTitle=Request.Cookies["rptTitle"].Value;
	}
	catch (System.Exception ex)
	{
		rptTitle="";
	}

	try
	{
		lastpage=Request.Cookies["lastpage"].Value;
	}
	catch (System.Exception ex)
	{
		lastpage="";
	}

// ------- Go back if the data from the source cookie has expired or unavailable ...
	if (lastpage=="" || lastpage==null)
	{
		Response.Redirect(Request.UrlReferrer.ToString());
	}

	if (IsPostBack)
	{
	}

	float winSrvChart=0, linSrvChart=0, aixSrvChart=0, totalSrvChart=0;

	sql="SELECT COUNT(*) FROM ("+winSql+")";
//	Response.Write(sql+"<BR><BR>");
	dat=readDb(sql);
	if (dat!=null)
	{
		winSrvChart=Convert.ToSingle(dat.Tables[0].Rows[0]["Expr1000"].ToString());
	}
	else
	{
		winSrvChart=0;
	} 

	sql="SELECT COUNT(*) FROM ("+linSql+")";
//	Response.Write(sql+"<BR><BR>");
	dat=readDb(sql);
	if (dat!=null)
	{
		linSrvChart=Convert.ToSingle(dat.Tables[0].Rows[0]["Expr1000"].ToString()); 
	}
		else
	{
		linSrvChart=0;
	} 

	sql="SELECT COUNT(*) FROM ("+aixSql+")";
//	Response.Write(sql+"<BR><BR>");
	dat=readDb(sql);
	if (dat!=null)
	{
		aixSrvChart=Convert.ToSingle(dat.Tables[0].Rows[0]["Expr1000"].ToString());
	}
	else
	{
		aixSrvChart=0;
	} 


	totalSrvChart=winSrvChart+linSrvChart+aixSrvChart;

	reportTitle.InnerHtml=rptTitle;

	double element1Value, element2Value, element3Value, element4Value;

	element1Value=Math.Round(((linSrvChart/totalSrvChart)*100) + 2/10.0,2);
	element2Value=Math.Round(((winSrvChart/totalSrvChart)*100) + 2/10.0,2);
	element3Value=Math.Round(((aixSrvChart/totalSrvChart)*100) + 2/10.0,2);
//	element4Value=Math.Round(((1)*100) + 2/10.0,2);

	ReportPieChart_ascx.PieChartElement myPieChartElement1 = new ReportPieChart_ascx.PieChartElement();
	ReportPieChart_ascx.PieChartElement myPieChartElement2 = new ReportPieChart_ascx.PieChartElement();
	ReportPieChart_ascx.PieChartElement myPieChartElement3 = new ReportPieChart_ascx.PieChartElement();
//	ReportPieChart_ascx.PieChartElement myPieChartElement4 = new ReportPieChart_ascx.PieChartElement();

	myPieChartElement1.Name = "Linux";
	myPieChartElement1.Percent = element1Value;
	myPieChartElement1.Color = Color.FromArgb(0, 0, 255);
	ReportPieChart.addPieChartElement(myPieChartElement1);

	myPieChartElement3.Name = "Windows";
	myPieChartElement3.Percent = element2Value;
	myPieChartElement3.Color = Color.FromArgb(255, 255, 0);
	ReportPieChart.addPieChartElement(myPieChartElement3);

	myPieChartElement2.Name = "AIX";
	myPieChartElement2.Percent = element3Value;
	myPieChartElement2.Color = Color.FromArgb(0, 255, 0);
	ReportPieChart.addPieChartElement(myPieChartElement2);

//	myPieChartElement4.Name = "Element4";
//	myPieChartElement4.Percent = element4Value;
//	myPieChartElement4.Color = Color.FromArgb(200, 30, 0);
//	ReportPieChart.addPieChartElement(myPieChartElement4);
        
	ReportPieChart.ChartTitle = "";
	ReportPieChart.ImageAlt = rptTitle+" Chart";
	ReportPieChart.ImageWidth = 300;
	ReportPieChart.ImageHeight = 175;

	ReportPieChart.generateChartImage();

	reportMeta.InnerHtml="<B>Linux Servers:</B> "+linSrvChart+"<BR><BR><B>Windows Servers:</B> "+winSrvChart+"<BR><BR><B>AIX Servers:</B> "+aixSrvChart+"<BR><BR><B>TOTAL Servers:</B> "+totalSrvChart;

//	sql=winSql+" UNION "+linSql+" UNION "+aixSql;
	sql="SELECT serverName, serverLanIp, serverPurpose, class, model, serial, belongsTo FROM ("+winSql+") ORDER BY belongsTo ASC, serverName ASC, serverPurpose DESC";
	datWin=readDb(sql);
	sql="SELECT serverName, serverLanIp, serverPurpose, class, model, serial, belongsTo FROM ("+linSql+") ORDER BY belongsTo ASC, serverName ASC, serverPurpose DESC";
	datLin=readDb(sql);
	sql="SELECT serverName, serverLanIp, serverPurpose, class, model, serial, belongsTo FROM ("+aixSql+") ORDER BY belongsTo ASC, serverName ASC, serverPurpose DESC";
	datAix=readDb(sql);
	if (datWin!=null || datLin!=null || datAix!=null)
	{
		fill=false;
		tr = new HtmlTableRow();    //Output <TR>
			tr.Attributes.Add("class","blackheading");
			td = new HtmlTableCell(); //Output <TD>
				td.Attributes.Add("colspan","7");
				td.Attributes.Add("style","width: 625px;");
				td.InnerHtml = rptTitle;
			tr.Cells.Add(td);         //Output </TD>
		svrTbl.Rows.Add(tr);           //Output </TR>
		if (datLin!=null)
		{
			tr = new HtmlTableRow();    //Output <TR>
				tr.Attributes.Add("class","tableheading");
				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("colspan","7");
					td.InnerHtml = "Linux Servers ("+linSrvChart+")";
				tr.Cells.Add(td);         //Output </TD>
			svrTbl.Rows.Add(tr);           //Output </TR>
			tr = new HtmlTableRow();    //Output <TR>
				tr.Attributes.Add("class","tableheading");
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml = "Hostname";
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml = "IP Address";
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml = "Description";
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml = "Class";
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml = "Model";
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml = "Serial";
				tr.Cells.Add(td);         //Output </TD>
			svrTbl.Rows.Add(tr);           //Output </TR>
			foreach (DataTable dtt in datLin.Tables)
			{
				foreach (DataRow drr in dtt.Rows)
				{
					tr = new HtmlTableRow();    //Output <TR>
					if (fill) tr.BgColor="#edf0f3";
						td = new HtmlTableCell(); //Output <TD>
						if (drr["serverName"].ToString()!=null || drr["serverName"].ToString()!="")
						{
							td.InnerHtml=short_hostname(drr["serverName"].ToString(),12);
						}
						else
						{
							td.InnerHtml="&nbsp";
						}
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
						if (drr["serverLanIp"].ToString()!=null && drr["serverLanIp"].ToString()!="")
						{
							td.InnerHtml= drr["serverLanIp"].ToString();
						}
						else
						{
							td.InnerHtml="&nbsp";
						}
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
						if (drr["serverPurpose"].ToString()!=null && drr["serverPurpose"].ToString()!="")
						{
							td.InnerHtml= drr["serverPurpose"].ToString();
						}
						else
						{
							td.InnerHtml="&nbsp";
						}
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
						if (drr["class"].ToString()!=null && drr["class"].ToString()!="")
						{
							td.InnerHtml= drr["class"].ToString();
						}
						else
						{
							td.InnerHtml="&nbsp";
						}
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
						if (drr["model"].ToString()!=null && drr["model"].ToString()!="")
						{
							td.InnerHtml= drr["model"].ToString();
						}
						else
						{
							td.InnerHtml="&nbsp";
						}
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
						if (drr["serial"].ToString()!=null && drr["serial"].ToString()!="")
						{
							td.InnerHtml= drr["serial"].ToString();
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
		if (datWin!=null)
		{
			tr = new HtmlTableRow();    //Output <TR>
				tr.Attributes.Add("class","tableheading");
				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("colspan","7");
					td.InnerHtml = "Windows Servers ("+winSrvChart+")";
				tr.Cells.Add(td);         //Output </TD>
			svrTbl.Rows.Add(tr);           //Output </TR>
			tr = new HtmlTableRow();    //Output <TR>
				tr.Attributes.Add("class","tableheading");
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml = "Hostname";
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml = "IP Address";
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml = "Description";
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml = "Class";
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml = "Model";
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml = "Serial";
				tr.Cells.Add(td);         //Output </TD>
			svrTbl.Rows.Add(tr);           //Output </TR>
			foreach (DataTable dtt in datWin.Tables)
			{
				foreach (DataRow drr in dtt.Rows)
				{
					tr = new HtmlTableRow();    //Output <TR>
					if (fill) tr.BgColor="#edf0f3";
						td = new HtmlTableCell(); //Output <TD>
						if (drr["serverName"].ToString()!=null || drr["serverName"].ToString()!="")
						{
							td.InnerHtml=short_hostname(drr["serverName"].ToString(),12);
						}
						else
						{
							td.InnerHtml="&nbsp";
						}
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
						if (drr["serverLanIp"].ToString()!=null && drr["serverLanIp"].ToString()!="")
						{
							td.InnerHtml= drr["serverLanIp"].ToString();
						}
						else
						{
							td.InnerHtml="&nbsp";
						}
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
						if (drr["serverPurpose"].ToString()!=null && drr["serverPurpose"].ToString()!="")
						{
							td.InnerHtml= drr["serverPurpose"].ToString();
						}
						else
						{
							td.InnerHtml="&nbsp";
						}
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
						if (drr["class"].ToString()!=null && drr["class"].ToString()!="")
						{
							td.InnerHtml= drr["class"].ToString();
						}
						else
						{
							td.InnerHtml="&nbsp";
						}
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
						if (drr["model"].ToString()!=null && drr["model"].ToString()!="")
						{
							td.InnerHtml= drr["model"].ToString();
						}
						else
						{
							td.InnerHtml="&nbsp";
						}
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
						if (drr["serial"].ToString()!=null && drr["serial"].ToString()!="")
						{
							td.InnerHtml= drr["serial"].ToString();
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
		if (datLin!=null)
		{
			tr = new HtmlTableRow();    //Output <TR>
				tr.Attributes.Add("class","tableheading");
				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("colspan","7");
					td.InnerHtml = "AIX Servers ("+aixSrvChart+")";
				tr.Cells.Add(td);         //Output </TD>
			svrTbl.Rows.Add(tr);           //Output </TR>
			tr = new HtmlTableRow();    //Output <TR>
				tr.Attributes.Add("class","tableheading");
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml = "Hostname";
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml = "IP Address";
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml = "Description";
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml = "Class";
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml = "Model";
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml = "Serial";
				tr.Cells.Add(td);         //Output </TD>
			svrTbl.Rows.Add(tr);           //Output </TR>
			foreach (DataTable dtt in datAix.Tables)
			{
				foreach (DataRow drr in dtt.Rows)
				{
					tr = new HtmlTableRow();    //Output <TR>
					if (fill) tr.BgColor="#edf0f3";
						td = new HtmlTableCell(); //Output <TD>
						if (drr["serverName"].ToString()!=null || drr["serverName"].ToString()!="")
						{
							td.InnerHtml=short_hostname(drr["serverName"].ToString(),12);
						}
						else
						{
							td.InnerHtml="&nbsp";
						}
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
						if (drr["serverLanIp"].ToString()!=null && drr["serverLanIp"].ToString()!="")
						{
							td.InnerHtml= drr["serverLanIp"].ToString();
						}
						else
						{
							td.InnerHtml="&nbsp";
						}
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
						if (drr["serverPurpose"].ToString()!=null && drr["serverPurpose"].ToString()!="")
						{
							td.InnerHtml= drr["serverPurpose"].ToString();
						}
						else
						{
							td.InnerHtml="&nbsp";
						}
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
						if (drr["class"].ToString()!=null && drr["class"].ToString()!="")
						{
							td.InnerHtml= drr["class"].ToString();
						}
						else
						{
							td.InnerHtml="&nbsp";
						}
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
						if (drr["model"].ToString()!=null && drr["model"].ToString()!="")
						{
							td.InnerHtml= drr["model"].ToString();
						}
						else
						{
							td.InnerHtml="&nbsp";
						}
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
						if (drr["serial"].ToString()!=null && drr["serial"].ToString()!="")
						{
							td.InnerHtml= drr["serial"].ToString();
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