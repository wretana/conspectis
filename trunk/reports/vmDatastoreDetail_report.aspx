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
	string v_userclass, v_hostname, v_desc;
	int v_clusId;

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
		v_clusId=Convert.ToInt32(Request.QueryString["cluster"].ToString());
	}
	catch (System.Exception ex)
	{
		v_clusId=0;
	}

	if (IsPostBack)
	{
	}

	reportTitle.InnerHtml="VM Datastore Detail Report";

	

	StringCollection datastoreClusters = new StringCollection();
	string drVal="", drFree="", drCap="";

	sql="SELECT name FROM datastores WHERE name LIKE '%_datastore%' ORDER BY name";
	dat=readDb(sql);
	if (dat!=null)
	{
		foreach (DataTable dt in dat.Tables)
		{
			foreach (DataRow dr in dt.Rows)
			{
				drVal=dr["name"].ToString();
				if (!datastoreClusters.Contains(drVal.Substring(0,drVal.IndexOf("_datastore"))))
				{
					datastoreClusters.Add(drVal.Substring(0,drVal.IndexOf("_datastore")));
				}
			}
		}
	}

	clusName=datastoreClusters[v_clusId]+"_datastore";

	if (clusName!="")
	{
		sql="SELECT * FROM datastores WHERE name LIKE '%"+clusName+"%' ORDER BY name";
		dat=readDb(sql);

		if (dat!=null)
		{
			fill=false;
			tr = new HtmlTableRow();    //Output <TR>
				tr.Attributes.Add("class","blackheading");
				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("colspan","10");
					td.Attributes.Add("style","width: 625px;");
					td.InnerHtml = "Datastores in "+datastoreClusters[v_clusId];
				tr.Cells.Add(td);         //Output </TD>
			svrTbl.Rows.Add(tr);           //Output </TR>
			tr = new HtmlTableRow();    //Output <TR>
				tr.Attributes.Add("class","tableheading");
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml = "Name";
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml = "Total Size";
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml = "Free Space";
				tr.Cells.Add(td);         //Output </TD>
			svrTbl.Rows.Add(tr);           //Output </TR>	
			foreach (DataTable dt in dat.Tables)
			{
				foreach (DataRow dr in dt.Rows)
				{
					tr = new HtmlTableRow();    //Output <TR>
					if (fill) tr.BgColor="#edf0f3";
						td = new HtmlTableCell(); //Output <TD>
//						td.Attributes.Add("align","center");
							if (dr["name"].ToString()!="")
							{
								td.InnerHtml= dr["name"].ToString();
							}
							else
							{
								td.InnerHtml="&nbsp";
							}
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
						td.Attributes.Add("align","center");
							if (dr["capacityMB"].ToString()!="")
							{
								td.InnerHtml= Math.Round(Convert.ToDouble(dr["capacityMB"].ToString())/1000000,2).ToString()+"Tb";
							}
							else
							{
								td.InnerHtml="err";
							}
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
						td.Attributes.Add("align","center");
							if (dr["freespaceMB"].ToString()!="")
							{
								if (Math.Round(Convert.ToDouble(dr["freespaceMB"].ToString())/1000000,2)/Math.Round(Convert.ToDouble(dr["capacityMB"].ToString())/1000000,2)<.20)
								{
									td.Attributes.Add("style","color: Red;");
									if (Math.Round(Convert.ToDouble(dr["freespaceMB"].ToString())/1000000,2)/Math.Round(Convert.ToDouble(dr["capacityMB"].ToString())/1000000,2)<.10)
									{
										td.Attributes.Add("style","color: Red;font-weight: bold;");
										if (Math.Round(Convert.ToDouble(dr["freespaceMB"].ToString())/1000000,2)/Math.Round(Convert.ToDouble(dr["capacityMB"].ToString())/1000000,2)<.05)
										{
											td.Attributes.Add("style","color: Red;font-weight: bold;font-size: 150%;");
										}
									}
								}

								td.InnerHtml= Math.Round(Convert.ToDouble(dr["freespaceMB"].ToString())/1000000,2).ToString()+"Tb <SPAN style='font-size:80%;vertical-align:text-top'>("+Math.Round(Math.Round(Convert.ToDouble(dr["freespaceMB"].ToString())/1000000,2)/Math.Round(Convert.ToDouble(dr["capacityMB"].ToString())/1000000,2),2)*100+"%)</SPAN>";
							}
							else
							{
								td.InnerHtml="err";
							}
						tr.Cells.Add(td);         //Output </TD>
					svrTbl.Rows.Add(tr);           //Output </TR>
					fill=!fill;
				}
			}
			sql="SELECT SUM(capacityMB), SUM(freespaceMB) FROM datastores WHERE name LIKE '%"+clusName+"%'";
			dat=readDb(sql);
			if (dat!=null)
			{
				drFree=dat.Tables[0].Rows[0]["Expr1001"].ToString();
				drCap=dat.Tables[0].Rows[0]["Expr1000"].ToString();	
			}
			if (drFree!="" && drCap!="")
			{
				tr = new HtmlTableRow();    //Output <TR>
					tr.Attributes.Add("style","background-color:#669966;font-size:200%;font-weight:bold;");
					td = new HtmlTableCell(); //Output <TD>
						td.InnerHtml="TOTALS";
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("align","center");
						td.InnerHtml= Math.Round(Convert.ToDouble(drCap)/1000000,2).ToString()+"Tb";;
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("align","center");
						if (Math.Round(Convert.ToDouble(drFree)/1000000,2)/Math.Round(Convert.ToDouble(drCap)/1000000,2)<.20)
						{
							td.Attributes.Add("style","color: FireBrick;");
							if (Math.Round(Convert.ToDouble(drFree)/1000000,2)/Math.Round(Convert.ToDouble(drCap)/1000000,2)<.10)
							{
								td.Attributes.Add("style","color: FireBrick;font-weight: bold;");
								if (Math.Round(Convert.ToDouble(drFree)/1000000,2)/Math.Round(Convert.ToDouble(drCap)/1000000,2)<.05)
								{
									td.Attributes.Add("style","color: FireBrick;font-weight: bold;font-size: 150%;");
								}
							}
						}
						td.InnerHtml= Math.Round(Convert.ToDouble(drFree)/1000000,2).ToString()+"Tb <SPAN style='font-size: 80%;vertical-align: text-top'>("+Math.Round(Math.Round(Convert.ToDouble(drFree)/1000000,2)/Math.Round(Convert.ToDouble(drCap)/1000000,2),2)*100+"%)</SPAN>";
					tr.Cells.Add(td);         //Output </TD>				
				svrTbl.Rows.Add(tr);           //Output </TR>
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
				<CENTER>
					<TABLE id="svrTbl" runat="server" class="datatable" cellspacing="0" cellpadding="2" border="1"></TABLE>
				</CENTER>
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
