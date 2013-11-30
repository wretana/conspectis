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
	DataSet dat, dat1;
	HttpCookie cookie;
	bool sqlSuccess=true;
	HtmlTableRow tr;
	HtmlTableCell td;
	bool fill;
	string bc, rack, os, env, srch, clusName="";
	string v_userclass, v_hostname, v_clusId, v_desc;

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
		v_clusId=Request.QueryString["cluster"].ToString();
	}
	catch (System.Exception ex)
	{
		v_clusId="";
	}

	if (IsPostBack)
	{
	}

	reportTitle.InnerHtml="VM Snapshot Detail Report";

	sql="SELECT DISTINCT(memberOfCluster) FROM servers WHERE memberOfCluster IS NOT NULL"; //Clusters
	dat=readDb(sql);
	if (dat!=null)
	{
		try
		{
			clusName=dat.Tables[0].Rows[Convert.ToInt32(v_clusId)]["memberOfCluster"].ToString();
		}
		catch (Exception ex)
		{
			Response.Write("ERR: Could not parse cluster '"+v_clusId+"'!");
			clusName="";
		}
		
	}

	if (clusName!="")
	{
		sql="SELECT serverName, serverLanIp, serverOS, serverPurpose, VMToolsState, VMPowerState, VMSysDiskCapMB, VMDataDiskCapMB, VMName FROM servers WHERE serverName IN(SELECT DISTINCT(serverName) FROM (SELECT serverName, serverLanIp, serverOS, serverOsBuild, serverPurpose, serverPubVlan, memberOfCluster,VMToolsState, VMPowerState, VMToolsVersion, VMSysDiskPath, VMDataDiskPath, VMSysDiskCapMB, VMDataDiskCapMB, VMSysDiskFreeMB, VMDataDiskFreeMB, snapId, snapshots.VMName, snapDesc, created, sizeOnDisk FROM snapshots INNER JOIN servers ON snapshots.vmName=servers.VMName) WHERE memberOfCluster='"+clusName+"')";
//		Response.Write(sql);
		dat=readDb(sql);
		DataSet datSnaps = new DataSet("SnapshotsData");
		int i = 0;
		if (dat!=null)
		{
			foreach (DataTable dt in dat.Tables)
			{
				DataTable datSnpTbl = new DataTable();
				datSnpTbl.Columns.Add("serverName", typeof(string));
				datSnpTbl.Columns.Add("serverLanIp", typeof(string));
				datSnpTbl.Columns.Add("serverOS", typeof(string));
				datSnpTbl.Columns.Add("serverPurpose", typeof(string));
				datSnpTbl.Columns.Add("VMToolsState", typeof(string));
				datSnpTbl.Columns.Add("VMPowerState", typeof(string));
				datSnpTbl.Columns.Add("VMSysDiskCapMB", typeof(string));
				datSnpTbl.Columns.Add("VMDataDiskCapMB", typeof(string));
				datSnpTbl.Columns.Add("VMName", typeof(string));
				datSnpTbl.Columns.Add("snapsCount", typeof(Int32));
				datSnpTbl.Columns.Add("snapsTotal", typeof(Double));
				foreach (DataRow dr in dt.Rows)
				{
					DataRow datSnapTblRow = datSnpTbl.NewRow();
					datSnapTblRow["serverName"]=dr["serverName"].ToString();
					datSnapTblRow["serverLanIp"]=dr["serverLanIp"].ToString();
					datSnapTblRow["serverOS"]=dr["serverOS"].ToString();
					datSnapTblRow["serverPurpose"]=dr["serverPurpose"].ToString();
					datSnapTblRow["VMToolsState"]=dr["VMToolsState"].ToString();
					datSnapTblRow["VMPowerState"]=dr["VMPowerState"].ToString();
					datSnapTblRow["VMSysDiskCapMB"]=dr["VMSysDiskCapMB"].ToString();
					datSnapTblRow["VMDataDiskCapMB"]=dr["VMDataDiskCapMB"].ToString();
					datSnapTblRow["VMName"]=dr["VMName"].ToString();
					string sumSnaps="", countSnaps="";
					double sizeDbl=0, sumSizeDbl=0;
					sql="SELECT SUM(sizeOnDisk) FROM snapshots WHERE vmName='"+dr["VMName"].ToString()+"'";
					dat1=readDb(sql);
					if (dat1!=null)
					{
						try
						{
							sumSnaps=dat1.Tables[0].Rows[0]["Expr1000"].ToString();
						}
						catch (Exception ex)
						{
							sumSnaps="0";
						}
					}
					sql="SELECT COUNT(snapDesc) FROM snapshots WHERE vmName='"+dr["VMName"].ToString()+"'";
					dat1=readDb(sql);
					if (dat1!=null)
					{
						try
						{
							countSnaps=dat1.Tables[0].Rows[0]["Expr1000"].ToString();
						}
						catch (Exception ex)
						{
							countSnaps="0";
						}
					}
					try
					{
						sumSizeDbl=Math.Round(Convert.ToDouble(sumSnaps),2);
					}
					catch (Exception ex)
					{
						sumSizeDbl=0;
					}
					
					datSnapTblRow["snapsCount"]=Convert.ToInt32(countSnaps);
					datSnapTblRow["snapsTotal"]=sumSizeDbl;
					datSnpTbl.Rows.Add(datSnapTblRow);
				}
				datSnaps.Tables.Add(datSnpTbl);
				i++;
			}
		}

		datSnaps.Tables[0].DefaultView.Sort = "snapsTotal DESC";
		DataView view = datSnaps.Tables[0].DefaultView;

		if (datSnaps!=null)
		{
			fill=false;
			tr = new HtmlTableRow();    //Output <TR>
				tr.Attributes.Add("class","blackheading");
				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("colspan","10");
					td.Attributes.Add("style","width: 625px;");
					td.InnerHtml = "Snapshots in "+clusName;
				tr.Cells.Add(td);         //Output </TD>
			svrTbl.Rows.Add(tr);           //Output </TR>
			tr = new HtmlTableRow();    //Output <TR>
				tr.Attributes.Add("class","tableheading");
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml = "Server";
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml = "IP";
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml = "OS";
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml = "Purpose";
				tr.Cells.Add(td);         //Output </TD>
/*				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml = "VM Tools";
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml = "State";
				tr.Cells.Add(td);         //Output </TD> */
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml = "System Disk Size";
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml = "Data Disk Size";
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml = "Snaps Size-On-Disk";
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml = "Snapshots";
				tr.Cells.Add(td);         //Output </TD>
			svrTbl.Rows.Add(tr);           //Output </TR>	
			foreach (DataRowView dr in view)
			{
				tr = new HtmlTableRow();    //Output <TR>
				if (fill) tr.BgColor="#edf0f3";
					td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("style","font-family: Arial; font-size: 8pt;");
						if (dr["serverName"].ToString()!="")
						{
							td.InnerHtml= dr["serverName"].ToString();
						}
						else
						{
							td.InnerHtml="&nbsp";
						}
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("style","font-family: Arial; font-size: 8pt;");
						if (dr["serverLanIp"].ToString()!="")
						{
							td.InnerHtml= fix_ip(dr["serverLanIp"].ToString());
						}
						else
						{
							td.InnerHtml="&nbsp";
						}
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("style","font-family: Arial; font-size: 8pt;");
						if (dr["serverOS"].ToString()!="")
						{
							td.InnerHtml= dr["serverOS"].ToString();
						}
						else
						{
							td.InnerHtml="&nbsp";
						}
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("style","font-family: Arial; font-size: 8pt;");
						if (dr["serverPurpose"].ToString()!="")
						{
							td.InnerHtml= dr["serverPurpose"].ToString();
						}
						else
						{
							td.InnerHtml="&nbsp";
						}
					tr.Cells.Add(td);         //Output </TD>
/*					td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("style","font-family: Arial; font-size: 8pt;");
						if (dr["VMToolsState"].ToString()!="")
						{
							td.InnerHtml= dr["VMToolsState"].ToString();
						}
						else
						{
							td.InnerHtml="&nbsp";
						}
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("style","font-family: Arial; font-size: 8pt;");
						if (dr["VMPowerState"].ToString()!="")
						{
							td.InnerHtml= dr["VMPowerState"].ToString();
						}
						else
						{
							td.InnerHtml="&nbsp";
						}
					tr.Cells.Add(td);         //Output </TD> */
					td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("style","font-family: Arial; font-size: 8pt;");
						if (dr["VMSysDiskCapMB"].ToString()!="")
						{
							td.InnerHtml= dr["VMSysDiskCapMB"].ToString();
						}
						else
						{
							td.InnerHtml="&nbsp";
						}
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("style","font-family: Arial; font-size: 8pt;");
						if (dr["VMDataDiskCapMB"].ToString()!="")
						{
							td.InnerHtml= dr["VMDataDiskCapMB"].ToString();
						}
						else
						{
							td.InnerHtml="&nbsp";
						}
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("style","font-family: Arial; font-size: 8pt;");
						if (dr["snapsTotal"].ToString()!="" )
						{
							td.InnerHtml= dr["snapsTotal"].ToString()+"Mb / "+dr["snapsCount"].ToString();
						}
						else
						{
							td.InnerHtml="&nbsp";
						}
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("style","font-family: Arial; font-size: 7pt;");
						td.Attributes.Add("style","font-size: 4px;");
						string snapTbl="", snapDescStr="";
						double sizeDbl=0;
						sql="SELECT snapDesc, created, sizeOnDisk FROM snapshots WHERE vmName='"+dr["VMName"].ToString()+"'";
						dat1=readDb(sql);
						if (dat1!=null)
						{
							snapTbl="<TABLE border='0'>";
							foreach (DataTable dtt in dat1.Tables)
							{
								foreach (DataRow drr in dtt.Rows)
								{
									if (drr["snapDesc"].ToString().Length>38)
									{
										snapDescStr=drr["snapDesc"].ToString().Substring(0,35)+"...";
									}
									else
									{
										snapDescStr=drr["snapDesc"].ToString();
									}
									try
									{
										sizeDbl=Math.Round(Convert.ToDouble(drr["sizeOndisk"].ToString()),2);
									}
									catch (Exception ex)
									{
										sizeDbl=0;
									}
									snapTbl=snapTbl+"<TR><TD width='225' style='font-family: Arial; font-size: 7pt;'>"+snapDescStr+"</TD><TD width='10' style='font-family: Arial; font-size: 7pt;'>"+drr["created"].ToString().Substring(0,drr["created"].ToString().IndexOf(" ")+1)+"</TD><TD width='70' style='font-family: Arial; font-size: 7pt;'>"+sizeDbl.ToString()+" Mb</TD></TR>";
								}
							}
							snapTbl=snapTbl+"</TABLE>";
						}
						td.InnerHtml=snapTbl;
					tr.Cells.Add(td);         //Output </TD>
				svrTbl.Rows.Add(tr);           //Output </TR>
				fill=!fill;
			}
		}
	}
	else
	{
		Response.Write("ERR: Could not find cluster name for '"+v_clusId+"' !");
	}

	reportMeta.InnerHtml="";

	sql="";
	dat=readDb(sql);

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
