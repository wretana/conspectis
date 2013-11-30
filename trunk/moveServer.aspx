<%@Page Inherits="CIS.conspectisLibrary" src="conspectisLibrary.cs" Language="C#" debug="true" %>
<%@Import Namespace="System.Data.OleDb"%>
<%@Import Namespace="System.Data"%>
<%@Import Namespace="System"%>

<!DOCTYPE html>
<!-- HTML5 Status: VALID 2-12-13 CK -->
<!--[if lt IE 7 ]> <html lang='en' class='no-js ie6'> <![endif]-->
<!--[if IE 7 ]>    <html lang='en' class='no-js ie7'> <![endif]-->
<!--[if IE 8 ]>    <html lang='en' class='no-js ie8'> <![endif]-->
<!--[if IE 9 ]>    <html lang='en' class='no-js ie9'> <![endif]-->
<!--[if (gt IE 9)|!(IE)]><!--> <html lang='en' class='no-js'> <!--<![endif]-->

<HEAD runat="server">

<!--#include file="header.inc"-->

<SCRIPT runat="server">
void popInfo(Object s, EventArgs e) 
{
	string sql="";
	DataSet dat=new DataSet();
	string serverB="";
	string serverB_hostname="";
	string serverB_rackspaceId="";
	string serverB_serial="";
	string serverB_bc="";
	string serverB_slot="";
	string confirmString="";
	string dcPrefix="";
	
	serverB=formNewLoc.Value;

	try
	{
		dcPrefix=Request.QueryString["dc"].ToString();
	}
	catch (System.Exception ex)
	{
		dcPrefix="";
	}

	sql="SELECT serverName, "+dcPrefix+"servers.rackspaceId, serial, bc, slot FROM "+dcPrefix+"servers INNER JOIN "+dcPrefix+"rackspace ON "+dcPrefix+"servers.rackspaceId="+dcPrefix+"rackspace.rackspaceId WHERE "+dcPrefix+"servers.rackspaceId="+serverB;
	dat=readDb(sql);
	if (!emptyDataset(dat))
	{
		serverB_hostname=dat.Tables[0].Rows[0]["serverName"].ToString();
		serverB_rackspaceId=dat.Tables[0].Rows[0]["rackspaceId"].ToString();
		serverB_serial=dat.Tables[0].Rows[0]["serial"].ToString();
		serverB_bc=dat.Tables[0].Rows[0]["bc"].ToString();
		serverB_slot=dat.Tables[0].Rows[0]["slot"].ToString();
	}

	if (serverB_hostname!="" & serverB_hostname!=null)
	{
		confirmString="<BR/><SPAN class='bold'>CONFIRM:</SPAN><BR/> Are you sure you want to swap this server with "+serverB_hostname+"("+serverB_serial+") at BC"+serverB_bc+", Slot:"+serverB_slot+" ?";
	}
	else
	{
		confirmString="<BR/><SPAN class='bold'>CONFIRM:</SPAN><BR/> Are you sure you want to swap this blade with "+serverB_serial+" at BC"+serverB_bc+", Slot:"+serverB_slot+" ?";
	}

	confirmMove.InnerHtml=confirmString;
}

void goSubmit(Object s, EventArgs e)
{
	string sql="";
	string sqlErr="", sqlErr1="", v_username="";
	bool successServerA=false, successServerB=false;
	DataSet datA, datB;
	string dcPrefix="";
	
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
		dcPrefix=Request.QueryString["dc"].ToString();
	}
	catch (System.Exception ex)
	{
		dcPrefix="";
	}

	DateTime dateStamp = DateTime.Now;

	string serverA="";
	string serverA_hostname="";
	string serverA_rackspaceId=serverA;
	string serverA_class="";
	string serverA_serial="";
	string serverA_model="";
	string serverA_cpuQty="";
	string serverA_cpuCores="";
	string serverA_cpuType="";
	string serverA_ram="";
	string serverA_sysDiskQty="";
	string serverA_sysDiskSize="";
	string serverA_dataDiskQty="";
	string serverA_dataDiskSize="";
	string serverA_eth0mac="";
	string serverA_eth1mac="";
	string serverA_hba0wwn="";
	string serverA_hba1wwn="";
	string serverA_sanAttached="";

	try
	{
		serverA=Request.QueryString["host"].ToString();
	}
	catch (System.Exception ex)
	{
		serverA="";
	}

	string serverB="";
	string serverB_hostname="";
	string serverB_rackspaceId="";
	string serverB_class="";
	string serverB_serial="";
	string serverB_model="";
	string serverB_cpuQty="";
	string serverB_cpuCores="";
	string serverB_cpuType="";
	string serverB_ram="";
	string serverB_sysDiskQty="";
	string serverB_sysDiskSize="";
	string serverB_dataDiskQty="";
	string serverB_dataDiskSize="";
	string serverB_eth0mac="";
	string serverB_eth1mac="";
	string serverB_hba0wwn="";
	string serverB_hba1wwn="";
	string serverB_sanAttached="";
	
	serverB=formNewLoc.Value;

	sql="SELECT * FROM "+dcPrefix+"servers INNER JOIN "+dcPrefix+"rackspace ON "+dcPrefix+"servers.rackspaceId="+dcPrefix+"rackspace.rackspaceId WHERE "+dcPrefix+"servers.rackspaceId="+serverA;
	datA=readDb(sql);
	if (datA!=null)
	{
		serverA_hostname=datA.Tables[0].Rows[0]["serverName"].ToString();
		serverA_rackspaceId=datA.Tables[0].Rows[0]["servers.rackspaceId"].ToString();
		serverA_class=datA.Tables[0].Rows[0]["class"].ToString();
		serverA_serial=datA.Tables[0].Rows[0]["serial"].ToString();
		serverA_model=datA.Tables[0].Rows[0]["model"].ToString();
		serverA_cpuQty=datA.Tables[0].Rows[0]["cpu_qty"].ToString();
		serverA_cpuCores=datA.Tables[0].Rows[0]["cpu_cores"].ToString();
		serverA_cpuType=datA.Tables[0].Rows[0]["cpu_type"].ToString();
		serverA_ram=datA.Tables[0].Rows[0]["ram"].ToString();
		serverA_sysDiskQty=datA.Tables[0].Rows[0]["sys_disk_qty"].ToString();
		serverA_sysDiskSize=datA.Tables[0].Rows[0]["sys_disk_size"].ToString();
		serverA_dataDiskQty=datA.Tables[0].Rows[0]["data_disk_qty"].ToString();
		serverA_dataDiskSize=datA.Tables[0].Rows[0]["data_disk_size"].ToString();
		serverA_eth0mac=datA.Tables[0].Rows[0]["eth0mac"].ToString();
		serverA_eth1mac=datA.Tables[0].Rows[0]["eth1mac"].ToString();
		serverA_hba0wwn=datA.Tables[0].Rows[0]["hba0wwn"].ToString();
		serverA_hba1wwn=datA.Tables[0].Rows[0]["hba1wwn"].ToString();
		serverA_sanAttached=datA.Tables[0].Rows[0]["sanAttached"].ToString();
	}
	
	if (serverA_cpuQty=="") serverA_cpuQty="NULL";
	if (serverA_cpuCores=="") serverA_cpuCores="NULL";
	if (serverA_ram=="") serverA_ram="NULL";
	if (serverA_sysDiskQty=="") serverA_sysDiskQty="NULL";
	if (serverA_sysDiskSize=="") serverA_sysDiskSize="NULL";
	if (serverA_dataDiskQty=="") serverA_dataDiskQty="NULL";
	if (serverA_dataDiskSize=="") serverA_dataDiskSize="NULL";

	sql="SELECT * FROM "+dcPrefix+"servers INNER JOIN "+dcPrefix+"rackspace ON "+dcPrefix+"servers.rackspaceId="+dcPrefix+"rackspace.rackspaceId WHERE "+dcPrefix+"servers.rackspaceId="+serverB;
	datB=readDb(sql);
	if (datB!=null)
	{
		serverB_hostname=datB.Tables[0].Rows[0]["serverName"].ToString();
		serverB_rackspaceId=datB.Tables[0].Rows[0]["servers.rackspaceId"].ToString();
		serverB_class=datB.Tables[0].Rows[0]["class"].ToString();
		serverB_serial=datB.Tables[0].Rows[0]["serial"].ToString();
		serverB_model=datB.Tables[0].Rows[0]["model"].ToString();
		serverB_cpuQty=datB.Tables[0].Rows[0]["cpu_qty"].ToString();
		serverB_cpuCores=datB.Tables[0].Rows[0]["cpu_cores"].ToString();
		serverB_cpuType=datB.Tables[0].Rows[0]["cpu_type"].ToString();
		serverB_ram=datB.Tables[0].Rows[0]["ram"].ToString();
		serverB_sysDiskQty=datB.Tables[0].Rows[0]["sys_disk_qty"].ToString();
		serverB_sysDiskSize=datB.Tables[0].Rows[0]["sys_disk_size"].ToString();
		serverB_dataDiskQty=datB.Tables[0].Rows[0]["data_disk_qty"].ToString();
		serverB_dataDiskSize=datB.Tables[0].Rows[0]["data_disk_size"].ToString();
		serverB_eth0mac=datB.Tables[0].Rows[0]["eth0mac"].ToString();
		serverB_eth1mac=datB.Tables[0].Rows[0]["eth1mac"].ToString();
		serverB_hba0wwn=datB.Tables[0].Rows[0]["hba0wwn"].ToString();
		serverB_hba1wwn=datB.Tables[0].Rows[0]["hba1wwn"].ToString();
		serverB_sanAttached=datB.Tables[0].Rows[0]["sanAttached"].ToString();
	}	

	if (serverB_cpuQty=="") serverB_cpuQty="NULL";
	if (serverB_cpuCores=="") serverB_cpuCores="NULL";
	if (serverB_ram=="") serverB_ram="NULL";
	if (serverB_sysDiskQty=="") serverB_sysDiskQty="NULL";
	if (serverB_sysDiskSize=="") serverB_sysDiskSize="NULL";
	if (serverB_dataDiskQty=="") serverB_dataDiskQty="NULL";
	if (serverB_dataDiskSize=="") serverB_dataDiskSize="NULL";

//	Response.Write("ServerA:"+serverA+"<BR/>");
//	Response.Write("ServerB:"+serverB);

	sql="UPDATE "+dcPrefix+"servers SET rackspaceId="+serverB+" WHERE serverName='"+serverA_hostname+"'";
//	Response.Write(sql+"<BR/>");
	sqlErr=writeDb(sql);
	if (sqlErr==null || sqlErr=="")
	{
		sqlErr=writeChangeLog(dateStamp.ToString(), Decrypt(v_username.ToString()), sql2txt(sql).ToString());
		sql="UPDATE "+dcPrefix+"rackspace SET class='"+serverA_class+"', serial='"+serverA_serial+"', model='"+serverA_model+"', cpu_qty="+serverA_cpuQty+", cpu_cores="+serverA_cpuCores+", cpu_type='"+serverA_cpuType+"', ram="+serverA_ram+", sys_disk_qty="+serverA_sysDiskQty+", sys_disk_size="+serverA_sysDiskSize+", data_disk_qty="+serverA_dataDiskQty+", data_disk_size="+serverA_dataDiskSize+", eth0mac='"+serverA_eth0mac+"', eth1mac='"+serverA_eth1mac+"', hba0wwn='"+serverA_hba0wwn+"', hba1wwn='"+serverA_hba1wwn+"', sanAttached="+serverA_sanAttached+" WHERE rackspaceId="+serverB;
//		Response.Write(sql+"<BR/>");
		sqlErr1=writeDb(sql);
		if (sqlErr1==null || sqlErr1=="")
		{
			sqlErr=writeChangeLog(dateStamp.ToString(), Decrypt(v_username.ToString()), sql2txt(sql).ToString());
			successServerA=true;
		}
		else
		{
			errmsg.InnerHtml="Error updating rackspace table for "+serverA_hostname+" at "+serverB+". "+sqlErr1;
		}

	}
	else
	{
		errmsg.InnerHtml="Error updating servers table for "+serverA_hostname;
	}

	sql="UPDATE "+dcPrefix+"servers SET rackspaceId="+serverA+" WHERE serverName='"+serverB_hostname+"'";
//	Response.Write(sql+"<BR/>");
	sqlErr=writeDb(sql);
	if (sqlErr==null || sqlErr=="")
	{
		sqlErr=writeChangeLog(dateStamp.ToString(), Decrypt(v_username.ToString()), sql2txt(sql).ToString());
		sql="UPDATE "+dcPrefix+"rackspace SET class='"+serverB_class+"', serial='"+serverB_serial+"', model='"+serverB_model+"', cpu_qty="+serverB_cpuQty+", cpu_cores="+serverB_cpuCores+", cpu_type='"+serverB_cpuType+"', ram="+serverB_ram+", sys_disk_qty="+serverB_sysDiskQty+", sys_disk_size="+serverB_sysDiskSize+", data_disk_qty="+serverB_dataDiskQty+", data_disk_size="+serverB_dataDiskSize+", eth0mac='"+serverB_eth0mac+"', eth1mac='"+serverB_eth1mac+"', hba0wwn='"+serverB_hba0wwn+"', hba1wwn='"+serverB_hba1wwn+"', sanAttached="+serverB_sanAttached+" WHERE rackspaceId="+serverA;
//		Response.Write(sql+"<BR/>");
		sqlErr1=writeDb(sql);
		if (sqlErr1==null || sqlErr1=="")
		{
			sqlErr=writeChangeLog(dateStamp.ToString(), Decrypt(v_username.ToString()), sql2txt(sql).ToString());
			successServerB=true;
		}
		else
		{
			errmsg.InnerHtml="Error updating rackspace table for "+serverB_hostname+" at "+serverA+". "+sqlErr1;
		}

	}
	else
	{
		errmsg.InnerHtml="Error updating servers table for "+serverB_hostname;
	}

	if (successServerB && successServerA)
	{
		errmsg.InnerHtml="SUCCESS!!";
		Response.Write("<script>refreshParent("+");<"+"/script>");
	}
}

public void Page_Load(Object o, EventArgs e)
{
//UNCOMMENT this line to force login to access this page.
	lockout(); Page.Header.Title=shortSysName+": Move Server";
	systemStatus(1); // Check to see if admin has put system is in offline mode.



	string sql;
	DataSet dat=new DataSet();
	HttpCookie cookie;
	bool sqlSuccess=true;
	string serverA="", serverB="";
	string dcPrefix="";
	try
	{
		dcPrefix=Request.QueryString["dc"].ToString();
	}
	catch (System.Exception ex)
	{
		dcPrefix="";
	}

	DateTime dateStamp = DateTime.Now;

	try
	{
		serverA=Request.QueryString["host"].ToString();
	}
	catch (System.Exception ex)
	{
		serverA="";
	}

	string serverA_hostname="";
	string serverA_rackspaceId=serverA;
	string serverA_serial="";
	string serverA_bc="";
	string serverA_slot="";

	sql="SELECT * FROM "+dcPrefix+"servers INNER JOIN "+dcPrefix+"rackspace ON "+dcPrefix+"servers.rackspaceId="+dcPrefix+"rackspace.rackspaceId WHERE "+dcPrefix+"servers.rackspaceId="+serverA;
//	Response.Write(sql);
	dat=readDb(sql);
	if (!emptyDataset(dat))
	{
		serverA_hostname=dat.Tables[0].Rows[0]["serverName"].ToString();
		serverA_rackspaceId=dat.Tables[0].Rows[0]["rackspaceId"].ToString();
		serverA_serial=dat.Tables[0].Rows[0]["serial"].ToString();
		serverA_bc=dat.Tables[0].Rows[0]["bc"].ToString();
		serverA_slot=dat.Tables[0].Rows[0]["slot"].ToString();

	}	

	confirmInfo.InnerHtml="Move "+serverA_hostname+"("+serverA_serial+") from <BR/>BC"+serverA_bc+", Slot:"+serverA_slot+" to...";

	if(!IsPostBack)
	{
		string ddString="";
		sql = "SELECT rackspaceId, bc, slot FROM "+dcPrefix+"rackspace WHERE rackspaceId<>"+serverA+" AND bc<>'' AND slot NOT LIKE '%LPAR%' AND slot<>'00' ORDER BY bc ASC, slot ASC";
//		Response.Write(sql);
		dat = readDb(sql);
		if (!emptyDataset(dat))
		{
			foreach(DataRow dr in dat.Tables[0].Rows)
			{
				ddString="BC:"+dr["bc"].ToString()+", Slot:"+dr["slot"].ToString();
//				Response.Write(ddString);
				ListItem li = new ListItem(ddString, dr["rackspaceId"].ToString());
				formNewLoc.Items.Add(li);
			}
		}
	}

	if (IsPostBack)
	{
	}
	
//Response.Write(serverA);

	titleSpan.InnerHtml="Move / Swap Blade Server";
}
</SCRIPT>
</HEAD>
<!--#include file='body.inc' -->
<DIV id='popContainer'>
	<FORM runat='server'>
<!--#include file='popup_opener.inc' -->
	<DIV id='popContent'>
		<DIV class='center altRowFill'>
			<SPAN id='titleSpan' runat='server'/>
			<DIV id='errmsg' class='errorLine' runat='server'/>
		</DIV>
		
		<DIV class='center paleColorFill'>
		&nbsp;<BR/>
			<DIV class='center'>
				<DIV id='confirmInfo' runat='server'/><BR/><BR/>
					<SELECT id='formNewLoc' style='width:120px;' onchange='javascript:form1.submit();' OnServerChange='popInfo' runat='server'></SELECT>
		<!--		<TABLE border='1' class='datatable' cellpadding='0' cellspacing='0'>
						<TR><TD align='center'>
							<TABLE cellspacing='0'>
								<TR><TD class='inputform'>&#xa0;</TD><TD class='whiteRowFill left'>&#xa0;</TD></TR>
								<TR><TD class='inputform'>&#xa0;</TD><TD class='whiteRowFill left'>&#xa0;</TD></TR> 
							</TABLE>
					</TABLE> -->
				<BR/>
				<DIV id='confirmMove' runat='server'/><BR/><BR/>
				<INPUT type='button' id='submitButton' name='goButton' value='Commit Move' OnServerClick='goSubmit' runat='server' />&#xa0;<INPUT type='button' value='Cancel &amp; Close' onclick='refreshParent()' />
			</DIV>
		&nbsp;
		</DIV>
	</DIV> <!-- End: popContent -->
<!--#include file='popup_closer.inc' -->
	</FORM>
</DIV> <!-- End: container -->
</BODY>
</HTML>