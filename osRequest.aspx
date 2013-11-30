<%@Page Inherits="CIS.conspectisLibrary" src="conspectisLibrary.cs" Language="C#" debug="true" %>
<%@Import Namespace="System.Data.OleDb"%>
<%@Import Namespace="System.Data"%>
<%@Import Namespace="System"%>

<!DOCTYPE html>
<!-- HTML5 Status: VALID 2-14-13 CK -->
<!--[if lt IE 7 ]> <html lang='en' class='no-js ie6'> <![endif]-->
<!--[if IE 7 ]>    <html lang='en' class='no-js ie7'> <![endif]-->
<!--[if IE 8 ]>    <html lang='en' class='no-js ie8'> <![endif]-->
<!--[if IE 9 ]>    <html lang='en' class='no-js ie9'> <![endif]-->
<!--[if (gt IE 9)|!(IE)]><!--> <html lang='en' class='no-js'> <!--<![endif]-->

<HEAD runat="server">

<!--#include file="header.inc"-->

<SCRIPT runat="server">
private void populateOsRequestDetails()
{
	string sql="";
	DataSet dat=new DataSet();
	string osType="", serverName="", dcPrefix="", serverDefault="", specString="";
	bool sqlSuccess=true;
	int diskQty=0, diskSizeGb=0;
	Single diskMod=0;

	try
	{
		osType=Request.QueryString["os"].ToString();
	}
	catch (System.Exception ex)
	{
		osType="";
	}

	try
	{
		dcPrefix=Request.QueryString["dc"].ToString();
	}
	catch (System.Exception ex)
	{
		dcPrefix="";
	}

	try
	{
		serverName=Request.QueryString["host"].ToString();
	}
	catch (System.Exception ex)
	{
		serverName="";
	}

	if (serverName!="" && dcPrefix!="")
	{
		sql="SELECT * FROM "+dcPrefix+"rackspace WHERE rackspaceId IN (SELECT rackspaceId FROM "+dcPrefix+"servers WHERE serverName='"+serverName+"')";
//		Response.Write(sql);
		dat=readDb(sql);
		if (!emptyDataset(dat))
		{
			try
			{
				diskQty=Convert.ToInt32(dat.Tables[0].Rows[0]["sys_disk_qty"].ToString());
			}
			catch (System.Exception ex)
			{
				diskQty=1;
			}
			try
			{
				diskSizeGb=Convert.ToInt32(dat.Tables[0].Rows[0]["sys_disk_size"].ToString());
			}
			catch (System.Exception ex)
			{
				diskSizeGb=1;
			}
		}
		specString=serverName+"<SPAN class='italic'>("+dcPrefix.ToUpper().Replace("_","")+")</SPAN> - ";
		specString=specString+dat.Tables[0].Rows[0]["cpu_type"].ToString()+" "+dat.Tables[0].Rows[0]["cpu_qty"].ToString()+"x"+dat.Tables[0].Rows[0]["cpu_cores"].ToString()+", "+dat.Tables[0].Rows[0]["ram"].ToString()+"Gb RAM, "+dat.Tables[0].Rows[0]["sys_disk_qty"].ToString()+"x"+dat.Tables[0].Rows[0]["sys_disk_size"].ToString()+"Gb";
		if (dat.Tables[0].Rows[0]["data_disk_qty"].ToString()!="" && dat.Tables[0].Rows[0]["data_disk_size"].ToString()!="")
		{
			specString=specString+", "+dat.Tables[0].Rows[0]["data_disk_qty"].ToString()+"x"+dat.Tables[0].Rows[0]["data_disk_size"].ToString()+"Gb";
		}
		hw_spec.InnerHtml=specString;
	}
//	Response.Write("Disks:"+diskQty+"<BR/>");
//	Response.Write("Size:"+diskSizeGb+"<BR/>");

//	diskQty=6;
	if (osType=="Linux")
	{
		if (serverName.IndexOf ("ORDB") > 0 || serverName.IndexOf ("ORGC") > 0)
		{
			sql="SELECT sfwId, sfwName FROM software WHERE sfwClass='OS' AND sfwOs='Linux' AND sfwName LIKE '%DB%' OR sfwName LIKE '%RAC%' ORDER BY sfwName ASC";
		}
		else
		{
			sql="SELECT sfwId, sfwName FROM software WHERE sfwClass='OS' AND sfwOs='Linux' ORDER BY sfwName ASC";
		}
		osRaidSelect.Visible=false;
		osRaidTag.InnerHtml=null;
		osPwRestoreSelect.Visible=false;
		osPwRestoreTag.InnerHtml=null;
		osOracleClientSelect.Visible=false;
		osOracleClientTag.InnerHtml=null;
		osCitrixSelect.Visible=false;
		osCitrixTag.InnerHtml=null;
	}
	if (osType=="Windows")
	{
		sql="SELECT sfwId, sfwName FROM software WHERE sfwClass='OS' AND sfwOs='Windows' ORDER BY sfwName ASC";

		osRaidTag.InnerHtml="System RAID Config: ";		
		osRaidSelect.Items.Add("None");
		if (diskQty>1) // At least TWO disks
		{
			osRaidSelect.Items.Add(new ListItem ("RAID-0 Stripe ("+(diskSizeGb*diskQty)+"Gb)",(diskSizeGb*diskQty).ToString()));
//			Response.Write("Mod:"+diskMod+"<BR/>");
			diskMod=diskQty%2;
			if (diskMod==0) // Divisible by two (RAID-1, RAID-5, RAID10, RAID0+1)
			{
//				Response.Write("DiskQty:"+diskQty+"<BR/>");
				if (diskQty==2) // RAID-1 only works on 2 disks ...
				{
					osRaidSelect.Items.Add(new ListItem ("RAID-1 Mirror ("+diskSizeGb+"Gb)",diskSizeGb.ToString()));
				}
				else
				{
					osRaidSelect.Items.Add(new ListItem ("RAID-5 S+P ("+((diskSizeGb*diskQty)-diskSizeGb)+"Gb)",((diskSizeGb*diskQty)-diskSizeGb).ToString()));
					osRaidSelect.Items.Add(new ListItem ("RAID-1+0 M-of-S ("+(diskSizeGb*diskQty/2)+"Gb)",(diskSizeGb*diskQty/2).ToString()));
					osRaidSelect.Items.Add(new ListItem ("RAID-0+1 S-of-M ("+(diskSizeGb*diskQty/2)+"Gb)",(diskSizeGb*diskQty/2).ToString()));
				}
			}
			else // NOT Divisible by two (RAID-5)
			{
				osRaidSelect.Items.Add(new ListItem ("RAID-5 S+P ("+((diskSizeGb*diskQty)-diskSizeGb)+"Gb)",((diskSizeGb*diskQty)-diskSizeGb).ToString()));
			}
		}

		osPwRestoreTag.InnerHtml="Citrix (50/50) Config: ";
		osPwRestoreSelect.Items.Add("Yes");
		osPwRestoreSelect.Items.Add("No");
		osOracleClientTag.InnerHtml="Install Oracle Client?: ";
		osOracleClientSelect.Items.Add(new ListItem("Yes - 11g","11G"));
		osOracleClientSelect.Items.Add(new ListItem("Yes - 10g","10G"));
		osOracleClientSelect.Items.Add(new ListItem("No","NA"));
		osCitrixTag.InnerHtml="Install Citrix Binaries?: ";
		osCitrixSelect.Items.Add("Yes");
		osCitrixSelect.Items.Add("No");
	}

	dat=readDb(sql);
	if (!emptyDataset(dat))
	{
		osBuildSelect.DataSource = dat;
		osBuildSelect.DataTextField = "sfwName";
		osBuildSelect.DataValueField = "sfwId";
		osBuildSelect.DataBind();
	}

	if (osType=="Linux")
	{
		if (serverName.IndexOf ("ORDB") > 0 || serverName.IndexOf ("ORGC") > 0)
		{
			sql="SELECT sfwId FROM software WHERE sfwClass='OS' AND sfwOS='Linux' AND flags LIKE '%DefaultORDB%'";
			dat=readDb(sql);
			if (!emptyDataset(dat))
			{
				serverDefault=dat.Tables[0].Rows[0]["sfwId"].ToString();
			}
			osBuildSelect.SelectedIndex=osBuildSelect.Items.IndexOf(osBuildSelect.Items.FindByValue(serverDefault)); 
		}
		else
		{
			sql="SELECT sfwId FROM software WHERE sfwClass='OS' AND sfwOS='Linux' AND flags LIKE '%DefaultLinux%'";
			dat=readDb(sql);
			if (!emptyDataset(dat))
			{
				serverDefault=dat.Tables[0].Rows[0]["sfwId"].ToString();
			}
			osBuildSelect.SelectedIndex=osBuildSelect.Items.IndexOf(osBuildSelect.Items.FindByValue(serverDefault)); 
		}
	}
	if (osType=="Windows")
	{
		sql="SELECT sfwId FROM software WHERE sfwClass='OS' AND sfwOS='Windows' AND flags LIKE '%DefaultWindows%'";
		dat=readDb(sql);
		if (!emptyDataset(dat))
		{
			serverDefault=dat.Tables[0].Rows[0]["sfwId"].ToString();
		}
		osBuildSelect.SelectedIndex=osBuildSelect.Items.IndexOf(osBuildSelect.Items.FindByValue(serverDefault)); 
		osPwRestoreSelect.SelectedIndex=0;
		osOracleClientSelect.SelectedIndex=0;
		osCitrixSelect.SelectedIndex=1;
		if (serverName.IndexOf ("CTX") > 0)
		{
			sql="SELECT sfwId FROM software WHERE sfwClass='OS' AND sfwOS='Windows' AND flags LIKE '%DefaultCitrix%'";
			dat=readDb(sql);
			if (!emptyDataset(dat))
			{
				serverDefault=dat.Tables[0].Rows[0]["sfwId"].ToString();
			}
			osBuildSelect.SelectedIndex=osBuildSelect.Items.IndexOf(osBuildSelect.Items.FindByValue(serverDefault));
			osCitrixSelect.SelectedIndex=0;
			osPwRestoreSelect.SelectedIndex=1;
		}
	}
}

public void Page_Load(Object o, EventArgs e)
{
//UNCOMMENT this line to force login to access this page.
	lockout(); Page.Header.Title=shortSysName+": New OS / Server Build Request";
	systemStatus(1); // Check to see if admin has put system is in offline mode.



	string sql,sqlErr="";
	DataSet dat=new DataSet();
	HttpCookie cookie;
	string osType="",serverName="",v_username="",traceSql="", dcPrefix="";
	bool sqlSuccess=true;

	try
	{
		v_username=Request.Cookies["username"].Value;
	}
	catch (System.Exception ex)
	{
		v_username="";
	}

	try
	{
		osType=Request.QueryString["os"].ToString();
	}
	catch (System.Exception ex)
	{
		osType="";
	}

	try
	{
		dcPrefix=Request.QueryString["dc"].ToString();
	}
	catch (System.Exception ex)
	{
		dcPrefix="";
	}

	try
	{
		serverName=Request.QueryString["host"].ToString();
	}
	catch (System.Exception ex)
	{
		serverName="";
	}

	DateTime dateStamp = DateTime.Now;

/*  Ticket Classes:
	-----------------------
	0. IP Request
	1. Oracle VIP Request
	2. DNS Registration Request
	3. OS Installation Request
	4. Software Installation Request
	5. KDC Account Request
	6. AD Account Request
	7. NFS/EFS/DFS Mount Setup Request
	8. Hardware Setup Ticket
    9. Hardware Trouble Ticket
   10. Release-To-Client Notice    */
	
	if (!IsPostBack)
	{
		populateOsRequestDetails();
	}

	if (IsPostBack)
	{
		string v_osBuild=osBuildSelect.Value;
		string v_raidLevel=osRaidSelect.Value;
		string v_pwRestore=osPwRestoreSelect.Value;
		string v_oracleClient=osOracleClientSelect.Value;
		string v_citrixBinaries=osCitrixSelect.Value;
		string v_comment=formComment.Value;

//		Response.Write("OsBuild: "+v_osBuild);
		if (osType=="Windows")
		{
			v_comment="Comment: "+v_comment+"\r\n\r\nRAID Level:"+v_raidLevel+"\r\nPower	Restore:"+v_pwRestore+"\r\nOracle Client:"+v_oracleClient+"\r\nCitrix Binaries:"+v_citrixBinaries;
		}
		sql="UPDATE "+dcPrefix+"servers SET serverOsBuild='"+v_osBuild+"' WHERE serverName='"+serverName+"'";
//		Response.Write(sql);
		sqlErr=writeDb(sql);
		if (sqlErr=="" || sqlErr==null)
		{
			sqlErr=writeChangeLog(dateStamp.ToString(), Decrypt(v_username.ToString()), sql2txt(sql).ToString());
			if (sqlErr=="" || sqlErr==null)
			{
				sql="INSERT INTO tickets (ticketServer, ticketSfw, ticketDateTime, ticketClass, ticketEnteredBy, ticketTitle, ticketComments, ticketPriority) VALUES('"+dcPrefix+"."+serverName+"',"+v_osBuild+",'"+dateStamp+"','3','"+v_username+"','OS Installation Request','"+v_comment+"','0')";
//				Response.Write(sql);
				sqlErr=writeDb(sql);
				if (sqlErr=="" || sqlErr==null)
				{
					sqlErr=writeChangeLog(dateStamp.ToString(), Decrypt(v_username.ToString()), sql2txt(sql).ToString());
					if (sqlErr=="" || sqlErr==null)
					{
						Response.Write("<script>window.close("+");<"+"/script>");
					}
					else
					{
						errmsg.InnerHtml=sqlErr;
					}
				}
				else
				{
					errmsg.InnerHtml=sqlErr;
				}
			}
			else
			{
				errmsg.InnerHtml=sqlErr;
			}
		}
		else
		{
			errmsg.InnerHtml=sqlErr;
		}
	}
	titleSpan.InnerHtml="OS Build Details";
}
</SCRIPT>
</HEAD>
<!--#include file="body.inc" -->
<DIV id='popContainer'>
	<FORM runat='server'>
<!--#include file='popup_opener.inc' -->
	<DIV id='popContent'>
		<DIV class='center altRowFill'>
			<SPAN id='titleSpan' runat='server'/>
			<DIV id='errmsg' class='errorLine' runat='server'/>
			<DIV class='center' id='hw_spec' runat='server'/><BR/>
			<DIV class='center'>
				<TABLE class='datatable center'>
					<TR>
						<TD class='center'>
							<TABLE>
								<TR><TD class='inputform'>&#xa0;</TD><TD class='whiteRowFill left'>&#xa0;</TD></TR>
								<TR>
									<TD class='inputform'>OS Build: </TD>
									<TD class='whiteRowFill left'>
										<SELECT id='osBuildSelect' style='width:193px;' runat='server'/>
									</TD>
								</TR>
								<TR>
									<TD class='inputform'><DIV id='osRaidTag' runat='server'/></TD>
									<TD class='whiteRowFill left'>
										<SELECT id='osRaidSelect' style='width:193px;' runat='server'/>
									</TD>
								</TR>
								<TR>
									<TD class='inputform'><DIV id='osPwRestoreTag' runat='server'/></TD>
									<TD class='whiteRowFill left'>
										<SELECT id='osPwRestoreSelect' style='width:193px;' runat='server'/>
									</TD>
								</TR>
								<TR>
									<TD class='inputform'><DIV id='osOracleClientTag' runat='server'/></TD>
									<TD class='whiteRowFill left'>
										<SELECT id='osOracleClientSelect' style='width:193px;' runat='server'/>
									</TD>
								</TR>
								<TR>
									<TD class='inputform'><DIV id='osCitrixTag' runat='server'/></TD>
									<TD class='whiteRowFill left'>
										<SELECT id='osCitrixSelect' style='width:193px;' runat='server'/>
									</TD>
								</TR>
								<TR>
									<TD class='inputform'>Special Instructions: </TD>
									<TD class='whiteRowFill left'>
										<TEXTAREA rows='4' cols='34' id='formComment' runat='server' />
									</TD>
								</TR> 
								<TR><TD class='inputform'>&#xa0;</TD><TD class='whiteRowFill left'>&#xa0;</TD></TR> 
							</TABLE>
						</TD>
					</TR>
				</TABLE> 
				<BR/>
				<INPUT type='submit' value='Save Changes' runat='server'/>&#xa0;<INPUT type='button' value='Cancel &amp; Close' onclick='refreshParent()'/>
			</DIV>
		&nbsp;<BR/>
		</DIV>
	</DIV> <!-- End: popContent -->
<!--#include file='popup_closer.inc' -->
	</FORM>
</DIV> <!-- End: container -->
</BODY>
</HTML>