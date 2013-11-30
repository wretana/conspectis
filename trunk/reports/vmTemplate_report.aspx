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
void goVirtDetail(Object sender, EventArgs e)
{
	HtmlButton clickedButton = sender as HtmlButton;
	Response.Write(clickedButton.ID);
}

void doCharts(string[] chartData)
{
	int countY=0;
	int countX=0;

	double VirtDetailPieChart_0_element1Value, VirtDetailPieChart_0_element2Value, VirtDetailPieChart_0_element3Value, VirtDetailPieChart_0_element4Value;

	VirtDetailPieChart_0_element1Value=Math.Round(((1)*100) + 2/10.0,2);
	VirtDetailPieChart_0_element2Value=Math.Round(((1)*100) + 2/10.0,2);
	VirtDetailPieChart_0_element3Value=Math.Round(((1)*100) + 2/10.0,2);
	VirtDetailPieChart_0_element4Value=Math.Round(((1)*100) + 2/10.0,2);

	ReportPieChart_ascx.PieChartElement VirtDetailPieChart_0_Element1 = new ReportPieChart_ascx.PieChartElement();
	ReportPieChart_ascx.PieChartElement VirtDetailPieChart_0_Element2 = new ReportPieChart_ascx.PieChartElement();
	ReportPieChart_ascx.PieChartElement VirtDetailPieChart_0_Element3 = new ReportPieChart_ascx.PieChartElement();
	ReportPieChart_ascx.PieChartElement VirtDetailPieChart_0_Element4 = new ReportPieChart_ascx.PieChartElement();

	VirtDetailPieChart_0_Element1.Name = "Element1";
	VirtDetailPieChart_0_Element1.Percent = VirtDetailPieChart_0_element1Value;
	VirtDetailPieChart_0_Element1.Color = Color.FromArgb(0, 0, 255);
	VirtDetailPieChart_0.addPieChartElement(VirtDetailPieChart_0_Element1);

	VirtDetailPieChart_0_Element3.Name = "Element2";
	VirtDetailPieChart_0_Element3.Percent = VirtDetailPieChart_0_element2Value;
	VirtDetailPieChart_0_Element3.Color = Color.FromArgb(255, 255, 0);
	VirtDetailPieChart_0.addPieChartElement(VirtDetailPieChart_0_Element3);

	VirtDetailPieChart_0_Element2.Name = "Element3";
	VirtDetailPieChart_0_Element2.Percent = VirtDetailPieChart_0_element3Value;
	VirtDetailPieChart_0_Element2.Color = Color.FromArgb(0, 255, 0);
	VirtDetailPieChart_0.addPieChartElement(VirtDetailPieChart_0_Element2);

	VirtDetailPieChart_0_Element4.Name = "Element4";
	VirtDetailPieChart_0_Element4.Percent = VirtDetailPieChart_0_element4Value;
	VirtDetailPieChart_0_Element4.Color = Color.FromArgb(200, 30, 0);
	VirtDetailPieChart_0.addPieChartElement(VirtDetailPieChart_0_Element4);
        
	VirtDetailPieChart_0.ChartTitle = "";
	VirtDetailPieChart_0.ImageAlt = "ReportChart";
	VirtDetailPieChart_0.ImageWidth = 300;
	VirtDetailPieChart_0.ImageHeight = 175;

	VirtDetailPieChart_0.generateChartImage();
}

public void Page_Load(Object o, EventArgs e)
{
	systemStatus(0); // Check to see if admin has put system is in offline mode.

	Response.Write("<script language='JavaScript'>function printWin() {window.print();} function refreshParent() { window.opener.location.href = window.opener.location.href; if (window.opener.progressWindow) { window.opener.progressWindow.close()  }  window.close();}//-->"+"<"+"/script>");

	string sql;
	DataSet dat = new DataSet();
	DataSet dat1 = new DataSet();
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

	reportTitle.InnerHtml="VM Snapshot Report";

	string[,] snapData = new string[10,5];
	int countY=0;
	int countX=0;

	sql="SELECT DISTINCT(memberOfCluster) FROM servers WHERE memberOfCluster IS NOT NULL"; //Clusters
	dat=readDb(sql);
	if (dat!=null)
	{
		foreach (DataTable dt in dat.Tables)
		{
			foreach (DataRow dr in dt.Rows)
			{
				snapData[countY,0]=dr["memberOfCluster"].ToString();
				sql="SELECT COUNT(serverName) FROM servers WHERE memberOfCluster='"+snapData[countY,0]+"'"; //Total VM's in Cluster 'engineering_cluster'
				dat1=readDb(sql);
				if (dat1!=null)
				{
					snapData[countY,1]=dat1.Tables[0].Rows[0]["Expr1000"].ToString();
				}
				else
				{
					snapData[countY,1]="0";
				}
				sql="SELECT COUNT(*) FROM (SELECT DISTINCT(serverName) FROM (SELECT serverName, serverLanIp, serverOS, serverOsBuild, serverPurpose, serverPubVlan, memberOfCluster,VMToolsState, VMPowerState, VMToolsVersion, VMSysDiskPath, VMDataDiskPath, VMSysDiskCapMB, VMDataDiskCapMB, VMSysDiskFreeMB, VMDataDiskFreeMB, snapId, snapshots.VMName, snapDesc, created, sizeOnDisk FROM snapshots INNER JOIN servers ON snapshots.vmName=servers.VMName) WHERE memberOfCluster='"+snapData[countY,0]+"')"; // Number of VM's with Snapshots in Cluster
				dat1=readDb(sql);
				if (dat1!=null)
				{
					snapData[countY,2]=dat1.Tables[0].Rows[0]["Expr1000"].ToString();
				}
				else
				{
					snapData[countY,2]="0";
				}
				sql="SELECT COUNT(*) FROM snapshots FROM snapshots INNER JOIN servers ON snapshots.vmName=servers.VMName WHERE memberOfCluster='"+snapData[countY,0]+"'"; //Number of Snapshots in Cluster
				dat1=readDb(sql);
				if (dat1!=null)
				{
					snapData[countY,3]=dat1.Tables[0].Rows[0]["Expr1000"].ToString();
				}
				else
				{
					snapData[countY,3]="0";
				}
				sql="SELECT SUM(sizeOnDisk) FROM snapshots INNER JOIN servers ON snapshots.vmName=servers.VMName WHERE memberOfCluster='"+snapData[countY,0]+"'"; //Size-On-Disk of Snapshots in Cluster
				dat1=readDb(sql);
				if (dat1!=null)
				{
					snapData[countY,4]=dat1.Tables[0].Rows[0]["Expr1000"].ToString();
				}
				else
				{
					snapData[countY,4]="0";
				}
				sql="SELECT DISTINCT(VMName) FROM (SELECT serverName, serverLanIp, serverOS, serverOsBuild, serverPurpose, serverPubVlan, memberOfCluster,VMToolsState, VMPowerState, VMToolsVersion, VMSysDiskPath, VMDataDiskPath, VMSysDiskCapMB, VMDataDiskCapMB, VMSysDiskFreeMB, VMDataDiskFreeMB, snapId, snapshots.VMName, snapDesc, created, sizeOnDisk FROM snapshots INNER JOIN servers ON snapshots.vmName=servers.VMName) WHERE memberOfCluster='"+snapData[countY,0]+"'"; //List of VM's with Snapshots in Cluster
				dat1=readDb(sql);
				if (dat1!=null)
				{
					foreach (DataTable dtt in dat1.Tables)
					{
						foreach (DataRow drr in dtt.Rows)
						{
							sql="SELECT * FROM snapshots WHERE VMName='"+drr["VMName"].ToString()+"'";
						}
					}
				}
				else
				{
				}
				countY++;
			}
		}
	}

	sql="SELECT COUNT(*) FROM snapshots"; //Number of Snapshots
	sql="SELECT SUM(sizeOnDisk) FROM snapshots"; //

	sql="SELECT DISTINCT(serverName) FROM (SELECT serverName, serverLanIp, serverOS, serverOsBuild, serverPurpose, serverPubVlan, memberOfCluster,VMToolsState, VMPowerState, VMToolsVersion, VMSysDiskPath, VMDataDiskPath, VMSysDiskCapMB, VMDataDiskCapMB, VMSysDiskFreeMB, VMDataDiskFreeMB, snapId, snapshots.VMName, snapDesc, created, sizeOnDisk FROM snapshots INNER JOIN servers ON snapshots.vmName=servers.VMName)";
	dat=readDb(sql);

//	reportMeta.InnerHtml="";

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
				<TD valign=top>
					<TABLE border='0' class='altrow' style='border:1px solid #000'>
						<TR>
							<TD colspan=3 align=center>
								 <B><DIV id="virtDetailTitle_0" runat="server"/></B>
							</TD>
						</TR>
						<TR>
							<TD>
								<Chart:ReportPieChart id="VirtDetailPieChart_0" runat="server" />
							</TD>
							<TD style="width: 5px;"> </TD>
							<TD> &nbsp &nbsp &nbsp &nbsp<BR>
								<BUTTON id="goVirtDetailButton_0" OnServerClick="goVirtDetail" style="font-size:80%" runat="server">List Servers</BUTTON>
							</TD>
						</TR>
						<TR>
							<TD colspan=3>
								 <DIV id="virtDetailMeta_0" runat="server"/> &nbsp &nbsp &nbsp &nbsp
							</TD>
						</TR>
					</TABLE>
					<BR>
					<TABLE border='0' class='altrow' style='border:1px solid #000'>
						<TR>
							<TD colspan=3 align=center>
								 <B><DIV id="virtDetailTitle_1" runat="server"/></B>
							</TD>
						</TR>
						<TR>
							<TD>
								<Chart:ReportPieChart id="VirtDetailPieChart_1" runat="server" />
							</TD>
							<TD style="width: 5px;"> </TD>
							<TD> &nbsp &nbsp &nbsp &nbsp<BR>
								<BUTTON id="goVirtDetailButton_1" OnServerClick="goVirtDetail" style="font-size:80%" runat="server">List Servers</BUTTON>
							</TD>
						</TR>
						<TR>
							<TD colspan=3>
								 <DIV id="virtDetailMeta_1" runat="server"/> &nbsp &nbsp &nbsp &nbsp
							</TD>
						</TR>
					</TABLE>
					<BR>
					<TABLE border='0' class='altrow' style='border:1px solid #000'>
						<TR>
							<TD colspan=3 align=center>
								 <B><DIV id="virtDetailTitle_2" runat="server"/></B>
							</TD>
						</TR>
						<TR>
							<TD>
								<Chart:ReportPieChart id="VirtDetailPieChart_2" runat="server" />
							</TD>
							<TD style="width: 5px;"> </TD>
							<TD> &nbsp &nbsp &nbsp &nbsp<BR>
								<BUTTON id="goVirtDetailButton_2" OnServerClick="goVirtDetail" style="font-size:80%" runat="server">List Servers</BUTTON>
							</TD>
						</TR>
						<TR>
							<TD colspan=3>
								 <DIV id="virtDetailMeta_2" runat="server"/> &nbsp &nbsp &nbsp &nbsp
							</TD>
						</TR>
					</TABLE>
					<BR>
					<TABLE border='0' class='altrow' style='border:1px solid #000'>
						<TR>
							<TD colspan=3 align=center>
								 <B><DIV id="virtDetailTitle_3" runat="server"/></B>
							</TD>
						</TR>
						<TR>
							<TD>
								<Chart:ReportPieChart id="VirtDetailPieChart_3" runat="server" />
							</TD>
							<TD style="width: 5px;"> </TD>
							<TD> &nbsp &nbsp &nbsp &nbsp<BR>
								<BUTTON id="goVirtDetailButton_3" OnServerClick="goVirtDetail" style="font-size:80%" runat="server">List Servers</BUTTON>
							</TD>
						</TR>
						<TR>
							<TD colspan=3>
								 <DIV id="virtDetailMeta_3" runat="server"/> &nbsp &nbsp &nbsp &nbsp
							</TD>
						</TR>
					</TABLE>
					<BR>
					<TABLE border='0' class='altrow' style='border:1px solid #000'>
						<TR>
							<TD colspan=3 align=center>
								 <B><DIV id="virtDetailTitle_4" runat="server"/></B>
							</TD>
						</TR>
						<TR>
							<TD>
								<Chart:ReportPieChart id="VirtDetailPieChart_4" runat="server" />
							</TD>
							<TD style="width: 5px;"> </TD>
							<TD> &nbsp &nbsp &nbsp &nbsp<BR>
								<BUTTON id="goVirtDetailButton_4" OnServerClick="goVirtDetail" style="font-size:80%" runat="server">List Servers</BUTTON>
							</TD>
						</TR>
						<TR>
							<TD colspan=3>
								 <DIV id="virtDetailMeta_4" runat="server"/> &nbsp &nbsp &nbsp &nbsp
							</TD>
						</TR>
					</TABLE>
					<BR>
					<TABLE border='0' class='altrow' style='border:1px solid #000'>
						<TR>
							<TD colspan=3 align=center>
								 <B><DIV id="virtDetailTitle_5" runat="server"/></B>
							</TD>
						</TR>
						<TR>
							<TD>
								<Chart:ReportPieChart id="VirtDetailPieChart_5" runat="server" />
							</TD>
							<TD style="width: 5px;"> </TD>
							<TD> &nbsp &nbsp &nbsp &nbsp<BR>
								<BUTTON id="goVirtDetailButton_5" OnServerClick="goVirtDetail" style="font-size:80%" runat="server">List Servers</BUTTON>
							</TD>
						</TR>
						<TR>
							<TD colspan=3>
								 <DIV id="virtDetailMeta_5" runat="server"/> &nbsp &nbsp &nbsp &nbsp
							</TD>
						</TR>
					</TABLE>
					<BR>
					<TABLE border='0' class='altrow' style='border:1px solid #000'>
						<TR>
							<TD colspan=3 align=center>
								 <B><DIV id="virtDetailTitle_6" runat="server"/></B>
							</TD>
						</TR>
						<TR>
							<TD>
								<Chart:ReportPieChart id="VirtDetailPieChart_6" runat="server" />
							</TD>
							<TD style="width: 5px;"> </TD>
							<TD> &nbsp &nbsp &nbsp &nbsp<BR>
								<BUTTON id="goVirtDetailButton_6" OnServerClick="goVirtDetail" style="font-size:80%" runat="server">List Servers</BUTTON>
							</TD>
						</TR>
						<TR>
							<TD colspan=3>
								 <DIV id="virtDetailMeta_6" runat="server"/> &nbsp &nbsp &nbsp &nbsp
							</TD>
						</TR>
					</TABLE>
					<TABLE border='0' class='altrow' style='border:1px solid #000'>
						<TR>
							<TD colspan=3 align=center>
								 <B><DIV id="virtDetailTitle_7" runat="server"/></B>
							</TD>
						</TR>
						<TR>
							<TD>
								<Chart:ReportPieChart id="VirtDetailPieChart_7" runat="server" />
							</TD>
							<TD style="width: 5px;"> </TD>
							<TD> &nbsp &nbsp &nbsp &nbsp<BR>
								<BUTTON id="goVirtDetailButton_7" OnServerClick="goVirtDetail" style="font-size:80%" runat="server">List Servers</BUTTON>
							</TD>
						</TR>
						<TR>
							<TD colspan=3>
								 <DIV id="virtDetailMeta_7" runat="server"/> &nbsp &nbsp &nbsp &nbsp
							</TD>
						</TR>
					</TABLE>
					<BR>
					<TABLE border='0' class='altrow' style='border:1px solid #000'>
						<TR>
							<TD colspan=3 align=center>
								 <B><DIV id="virtDetailTitle_8" runat="server"/></B>
							</TD>
						</TR>
						<TR>
							<TD>
								<Chart:ReportPieChart id="VirtDetailPieChart_8" runat="server" />
							</TD>
							<TD style="width: 5px;"> </TD>
							<TD> &nbsp &nbsp &nbsp &nbsp<BR>
								<BUTTON id="goVirtDetailButton_8" OnServerClick="goVirtDetail" style="font-size:80%" runat="server">List Servers</BUTTON>
							</TD>
						</TR>
						<TR>
							<TD colspan=3>
								 <DIV id="virtDetailMeta_8" runat="server"/> &nbsp &nbsp &nbsp &nbsp
							</TD>
						</TR>
					</TABLE>
					<BR>
					<TABLE border='0' class='altrow' style='border:1px solid #000'>
						<TR>
							<TD colspan=3 align=center>
								 <B><DIV id="virtDetailTitle_9" runat="server"/></B>
							</TD>
						</TR>
						<TR>
							<TD>
								<Chart:ReportPieChart id="VirtDetailPieChart_9" runat="server" />
							</TD>
							<TD style="width: 5px;"> </TD>
							<TD> &nbsp &nbsp &nbsp &nbsp<BR>
								<BUTTON id="goVirtDetailButton_9" OnServerClick="goVirtDetail" style="font-size:80%" runat="server">List Servers</BUTTON>
							</TD>
						</TR>
						<TR>
							<TD colspan=3>
								 <DIV id="virtDetailMeta_9" runat="server"/> &nbsp &nbsp &nbsp &nbsp
							</TD>
						</TR>
					</TABLE>
					<BR>
				</TD>
		</TABLE>
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