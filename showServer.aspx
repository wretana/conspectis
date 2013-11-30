<%@Page Inherits="CIS.conspectisLibrary" src="conspectisLibrary.cs" Language="C#" debug="true" %>
<%@Import Namespace="System.Data.OleDb"%>
<%@Import Namespace="System.Data"%>
<%@Import Namespace="System"%>

<!DOCTYPE html>
<!-- HTML5 Status: VALID 2-16-13 CK -->
<!--[if lt IE 7 ]> <html lang='en' class='no-js ie6'> <![endif]-->
<!--[if IE 7 ]>    <html lang='en' class='no-js ie7'> <![endif]-->
<!--[if IE 8 ]>    <html lang='en' class='no-js ie8'> <![endif]-->
<!--[if IE 9 ]>    <html lang='en' class='no-js ie9'> <![endif]-->
<!--[if (gt IE 9)|!(IE)]><!--> <html lang='en' class='no-js'> <!--<![endif]-->

<HEAD runat="server">

<!--#include file="header.inc"-->

<SCRIPT runat="server">
/* public void vlans(Object o, ImageClickEventArgs e) 
{
	string sql, sql1;
	DataSet dat, dat1;
	string vlan=formPubVlan.Value;
	string hostOs=formSvrOs.Value;
	sql="SELECT ipAddr FROM (SELECT * FROM "+vlan+" LEFT JOIN servers ON servers.serverLanIp="+vlan+".ipAddr WHERE servers.serverLanIp is Null) WHERE reserved=0";
	sql1="SELECT ipAddr FROM "+hostOs+" LEFT JOIN servers ON servers.serverSvcIp="+hostOs+".ipAddr WHERE servers.serverSvcIp is Null";
	dat=readDb(sql);
	dat1=readDb(sql1);
    formPubIp.DataSource = dat;
    formPubIp.DataTextField = "ipAddr";
    formPubIp.DataValueField = "ipAddr";
    formPubIp.DataBind();
    formSvcIp.DataSource = dat1;
    formSvcIp.DataTextField = "ipAddr";
    formSvcIp.DataValueField = "ipAddr";
    formSvcIp.DataBind();
 } */

public void Page_Load(Object o, EventArgs e)
{
//UNCOMMENT this line to force login to access this page.
	lockout(); Page.Header.Title=shortSysName+": Show Server";
	systemStatus(0); // Check to see if admin has put system is in offline mode.

	string sql,sql1,sql2,sqlSwitch;
	DataSet dat,dat1,dat2=null,datSwitch;
	string v_username, v_userrole, sqlErr="";
	string srcHost="", dcPrefix="";
	try
	{
		srcHost=Request.QueryString["host"].ToString();
	}
	catch (System.Exception ex)
	{
		srcHost="";
	}

	try
	{
		dcPrefix=Request.QueryString["dc"].ToString();
	}
	catch (System.Exception ex)
	{
		dcPrefix="";
	}

	string srcRackspace="";
	try
	{
		srcRackspace=Request.QueryString["rackspace"].ToString();
	}
	catch (System.Exception ex)
	{
		srcRackspace="";
	}
	
	DateTime dateStamp = DateTime.Now;
	bool portsFound=false;
	string specString="";

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
		v_userrole=Request.Cookies["role"].Value;
	}
	catch (System.Exception ex)
	{
		v_userrole="";
	}

	formHostName.InnerHtml="<SPAN class='bold'>"+srcHost+"</SPAN>";
	sql="";
	if (srcHost!="")
	{
		sql="SELECT * FROM "+dcPrefix+"servers INNER JOIN "+dcPrefix+"rackspace ON "+dcPrefix+"servers.rackspaceId="+dcPrefix+"rackspace.rackspaceId WHERE serverName='"+srcHost+"'";
	}
	if (srcRackspace!="")
	{
		sql="SELECT * FROM "+dcPrefix+"rackspace LEFT OUTER JOIN "+dcPrefix+"servers ON "+dcPrefix+"rackspace.rackspaceId="+dcPrefix+"servers.rackspaceId WHERE rackspace.rackspaceId="+srcRackspace;
	}

	dat=readDb(sql);
	if (!emptyDataset(dat))
	{
		string v_svrName="";
		string v_svrOs="";
		string v_svrPurpose="";
		string v_svrClass="";
		string v_svrModel="";
		string v_svrSerial="";
		string v_svrRack="";
		string v_svrBc="";
		string v_svrSlot="";
		string v_pubVlan="";
		string v_sanAttached="";
		string v_usingSAN="";
		string v_svrLanIp="";
		string v_svrSvcIp="";
		string v_svrMgtIp="";

		v_svrName=dat.Tables[0].Rows[0]["serverName"].ToString();
		v_svrOs=dat.Tables[0].Rows[0]["serverOS"].ToString();
		v_svrPurpose=dat.Tables[0].Rows[0]["serverPurpose"].ToString();
		v_svrClass=dat.Tables[0].Rows[0]["class"].ToString();
		v_svrModel=dat.Tables[0].Rows[0]["model"].ToString();
		v_svrSerial=dat.Tables[0].Rows[0]["serial"].ToString();
		v_svrRack=dat.Tables[0].Rows[0]["rack"].ToString();
		v_svrBc=dat.Tables[0].Rows[0]["bc"].ToString();
		v_svrSlot=dat.Tables[0].Rows[0]["slot"].ToString();
		v_pubVlan=dat.Tables[0].Rows[0]["serverPubVlan"].ToString();
		v_sanAttached=dat.Tables[0].Rows[0]["sanAttached"].ToString();
		v_usingSAN=dat.Tables[0].Rows[0]["usingSAN"].ToString();
		v_svrLanIp=dat.Tables[0].Rows[0]["serverLanIp"].ToString();
		v_svrSvcIp=dat.Tables[0].Rows[0]["serverSvcIp"].ToString();
		v_svrMgtIp=dat.Tables[0].Rows[0]["serverRsaIp"].ToString();

		formSvrName.InnerHtml=v_svrName;
		formSvrOs.InnerHtml=v_svrOs;
		formSvrPurpose.InnerHtml=v_svrPurpose;
		formSvrClass.InnerHtml=v_svrClass;
		formSvrModel.InnerHtml=v_svrModel;
		formSvrSerial.InnerHtml=v_svrSerial;

		string sqlRack="", rackString="";
		DataSet datRack=new DataSet();
		sqlRack="SELECT location, rackId FROM "+dcPrefix+"racks WHERE rackId='"+v_svrRack+"'";
//		Response.Write(sqlRack+"<BR/>");
		datRack=readDb(sqlRack);
		if (datRack!=null)
		{
			try
			{
				rackString=datRack.Tables[0].Rows[0]["location"].ToString()+"-R"+datRack.Tables[0].Rows[0]["rackId"].ToString().Substring(0,2)+"-C"+datRack.Tables[0].Rows[0]["rackId"].ToString().Substring(2,2)+" <SPAN class='italic'>("+dcPrefix.ToUpper().Replace("_","")+")</SPAN>";
			}
			catch (System.Exception ex)
			{
				rackString="ERR";
			}
		}
		formSvrRack.InnerHtml=rackString;

		formSvrBc.InnerHtml=v_svrBc;
		formSvrSlot.InnerHtml=v_svrSlot;
		formPubVlan.InnerHtml=v_pubVlan;
		specString=dat.Tables[0].Rows[0]["cpu_type"].ToString()+" "+dat.Tables[0].Rows[0]["cpu_qty"].ToString()+"x"+dat.Tables[0].Rows[0]["cpu_cores"].ToString()+", "+dat.Tables[0].Rows[0]["ram"].ToString()+"Gb RAM, "+dat.Tables[0].Rows[0]["sys_disk_qty"].ToString()+"x"+dat.Tables[0].Rows[0]["sys_disk_size"].ToString()+"Gb";
		if (dat.Tables[0].Rows[0]["data_disk_qty"].ToString()!="" && dat.Tables[0].Rows[0]["data_disk_size"].ToString()!="")
		{
			specString=specString+", "+dat.Tables[0].Rows[0]["data_disk_qty"].ToString()+"x"+dat.Tables[0].Rows[0]["data_disk_size"].ToString()+"Gb";
		}
		hw_spec.InnerHtml=specString;
		if (v_sanAttached=="1")
		{
			formSvrSAN.InnerHtml="Yes";
		}
		else
		{
			formSvrSAN.InnerHtml="No";
		}
		if (v_usingSAN=="1")
		{
			formUsingSAN.InnerHtml="Yes";
		}
		else
		{
			formUsingSAN.InnerHtml="No";
		}
		formPubIp.InnerHtml=fix_ip(v_svrLanIp);
		formSvcIp.InnerHtml=fix_ip(v_svrSvcIp);
		formMgtIp.InnerHtml=fix_ip(v_svrMgtIp);

		try
		{
			int rackspace=Convert.ToInt32(dat.Tables[0].Rows[0]["rack"].ToString());
		}
		catch (System.Exception ex)
		{
		}

		if (v_svrModel!="ESX Virtual Machine")
		{
			try
			{
				dat2=getPorts(dat.Tables[0].Rows[0]["rackspaceId"].ToString(),dcPrefix);
			}
			catch (System.Exception ex)
			{
				dat2=getPorts(srcRackspace,dcPrefix);
			}
			
			if (!emptyDataset(dat2))
			{
				portsFound=true;
				bool fill;
				HtmlTableRow tr;
				HtmlTableCell td;
				fill=false;
				tr = new HtmlTableRow();    //Output <TR>
					tr.Attributes.Add("class","blackheading");
					td = new HtmlTableCell(); //Output <TD>
						td.Attributes.Add("colspan","5");
						td.InnerHtml = "<SPAN class='smaller'>Porting</SPAN>";
					tr.Cells.Add(td);         //Output </TD>
				cableMap1.Rows.Add(tr);           //Output </TR>
				tr = new HtmlTableRow();    //Output <TR>
					tr.Attributes.Add("class","tableheading");
					td = new HtmlTableCell(); //Output <TD>
						td.InnerHtml = "<SPAN class='smaller'>Desc</SPAN>";
					td.Attributes.Add("style","width:40px;");
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						td.InnerHtml = "<SPAN class='smaller'>Switch</SPAN>";
					td.Attributes.Add("style","width:40px;");
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						td.InnerHtml = "<SPAN class='smaller'>Slot</SPAN>";
						td.Attributes.Add("style","width:10px;");
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						td.InnerHtml = "<SPAN class='smaller'>Port</SPAN>";
						td.Attributes.Add("style","width:10px;");
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						td.InnerHtml = "<SPAN class='smaller'>Actions</SPAN>";
						td.Attributes.Add("style","width:40px;");
					tr.Cells.Add(td);         //Output </TD>
				cableMap1.Rows.Add(tr);           //Output </TR>
				foreach (DataTable dtt in dat2.Tables)
				{
					foreach (DataRow drr in dtt.Rows)
					{
						tr = new HtmlTableRow();    //Output <TR>
							if (fill) tr.Attributes.Add("class","altrow");
							td = new HtmlTableCell(); //Output <TD>
								td.InnerHtml="<SPAN class='smaller'>"+drr["comment"].ToString()+"</SPAN>";
							tr.Cells.Add(td);         //Output </TD>
							td = new HtmlTableCell(); //Output <TD>
								td.InnerHtml="<SPAN class='smaller'>"+drr["switchId"].ToString()+"</SPAN>";
							tr.Cells.Add(td);         //Output </TD>
							td = new HtmlTableCell(); //Output <TD>
								td.InnerHtml="<SPAN class='smaller'>"+drr["slot"].ToString()+"</SPAN>";
								td.Attributes.Add("class","center");
							tr.Cells.Add(td);         //Output </TD>
							td = new HtmlTableCell(); //Output <TD>
								td.InnerHtml="<SPAN class='smaller'>"+drr["portNum"].ToString()+"</SPAN>";
								td.Attributes.Add("class","center");
							tr.Cells.Add(td);         //Output </TD>
							td = new HtmlTableCell(); //Output <TD>
								if (v_userrole.Contains("datacenter"))
								{
									td.InnerHtml="<INPUT type='image' src='./img/delete_sm.png' onclick=\"window.open('deleteCabling.aspx?sw="+drr["switchId"].ToString()+"&port="+drr["portId"].ToString()+"&dc="+dcPrefix+"','deleteCablingWin','width=315,height=275,menubar=no,status=yes')\" ALT='Delete Cabling' />";
								}
								else
								{
									td.InnerHtml="&#xa0;";
								}
								td.Attributes.Add("class","center");
							tr.Cells.Add(td);         //Output </TD>
						cableMap1.Rows.Add(tr);           //Output </TR>
						fill=!fill;
					}
				} 
			} 
			if (!portsFound)
			{
				bool fill;
				HtmlTableRow tr;
				HtmlTableCell td;	
				tr = new HtmlTableRow();    //Output <TR>
					tr.Attributes.Add("class","blackheading");
					td = new HtmlTableCell(); //Output <TD>
						td.InnerHtml = "Porting";
					tr.Cells.Add(td);         //Output </TD>
				cableMap1.Rows.Add(tr);           //Output </TR>
				tr = new HtmlTableRow();    //Output <TR>
					td = new HtmlTableCell(); //Output <TD>
						td.InnerHtml = "No Network Cabling on File!";
						td.Attributes.Add("class","errorBox center");
						td.Attributes.Add("style","width:90px;");
					tr.Cells.Add(td);         //Output </TD>
				cableMap1.Rows.Add(tr);           //Output </TR>
			}
			if (v_userrole.Contains("datacenter"))
			{
				cablebutton.InnerHtml="<INPUT type='image' src='./img/cablingbar.png'	onclick=\"window.open('editCabling.aspx?id="+dat.Tables[0].Rows[0]["rackspaceId"].ToString()+"&dc="+dcPrefix+"','editCablingWin','width=400,height=800,menubar=no,status=yes')\" ALT='Edit Cabling' />";
			}

		}

	}
	titleSpan.InnerHtml="Show Server Detail";
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
			<DIV id='formHostName' class='bold' runat='server'/>
		</DIV>
		<DIV class='center paleColorFill'>
		&nbsp;<BR/>
			<DIV class='center'>
				<TABLE border='1' class='datatable center' >
					<TR>
						<TD class='center'>
							<TABLE>
								<TR><TD class='inputform'>&#xa0;</TD><TD class='whiteRowFill left'>&#xa0;</TD></TR>
								<TR>
									<TD class='inputform bold'>Host Name:&#xa0;</TD>
									<TD class='whiteRowFill left'>
										<DIV id='formSvrName' runat='server' />
									</TD>
								</TR>
								<TR>
									<TD class='inputform bold'>OS:&#xa0;</TD>
									<TD class='whiteRowFill left'>
										<DIV id='formSvrOs' runat='server' />
									</TD>
								</TR>
								<TR>
									<TD class='inputform bold'>Purpose:&#xa0;</TD>
									<TD class='whiteRowFill left'>
										<DIV id='formSvrPurpose' runat='server' />
									</TD>
								</TR>
								<TR>
									<TD class='inputform bold'>Server Class:&#xa0;</TD>
									<TD class='whiteRowFill left'>
										<DIV id='formSvrClass' runat='server' />
									</TD>
								</TR>
								<TR>
									<TD class='inputform bold'>Server Model:&#xa0;</TD>
									<TD class='whiteRowFill left'>
										<DIV id='formSvrModel' runat='server' />
									</TD>
								</TR>
								<TR>
									<TD class='inputform bold'>Server Serial:&#xa0;</TD>
									<TD class='whiteRowFill left'>
										<DIV id='formSvrSerial' runat='server' />
									</TD>
								</TR>
								<TR><TD class='inputform'>&#xa0;</TD><TD class='whiteRowFill left'>&#xa0;</TD></TR>
								<TR>
									<TD class='inputform bold'>SAN Attached:&#xa0;</TD>
									<TD class='whiteRowFill left'>
										<DIV id='formSvrSAN' runat='server' />
									</TD>
								</TR>
								<TR>
									<TD class='inputform bold'>Using SAN?:&#xa0;</TD>
									<TD class='whiteRowFill left'>
										<DIV id='formUsingSAN' runat='server' />
									</TD>
								</TR>
								<TR><TD class='inputform'>&#xa0;</TD><TD class='whiteRowFill left'>&#xa0;</TD></TR>
								<TR>
									<TD class='inputform bold'>Rack:&#xa0;</TD>
									<TD class='whiteRowFill left'>
										<DIV id='formSvrRack' runat='server' />
									</TD>
								</TR>
								<TR>
									<TD class='inputform bold'>BC:&#xa0;</TD>
									<TD class='whiteRowFill left'>
										<DIV id='formSvrBc' runat='server' />
									</TD>
								</TR>
								<TR>
									<TD class='inputform bold'>Slot:&#xa0;</TD>
									<TD class='whiteRowFill left'>
										<DIV id='formSvrSlot' runat='server' />
									</TD>
								</TR>
								<TR><TD class='inputform'>&#xa0;</TD><TD class='whiteRowFill left'>&#xa0;</TD></TR>
								<TR>
									<TD class='inputform bold'>Public VLAN:&#xa0;</TD>
									<TD class='whiteRowFill left'>
										<DIV id='formPubVlan' runat='server' />
									</TD>
								</TR>
								<TR>
									<TD class='inputform bold'>Public IP:&#xa0;</TD>
									<TD class='whiteRowFill left'>
										<DIV id='formPubIp' runat='server' />
									</TD>
								</TR>
								<TR>
									<TD class='inputform bold'>Service IP:&#xa0;</TD>
									<TD class='whiteRowFill left'>
										<DIV id='formSvcIp' runat='server' />
									</TD>
								</TR>
								<TR>
									<TD class='inputform bold'>Mgt IP: (RSA/MM)&#xa0;</TD>
									<TD class='whiteRowFill left'>
										<DIV id='formMgtIp' runat='server' />
									</TD>
								</TR>
								<TR><TD class='inputform'>&#xa0;</TD><TD class='whiteRowFill left'>&#xa0;</TD></TR>
								<TR>
									<TD class='inputform'>&#xa0;</TD>
									<TD class='whiteRowFill center'>
										<TABLE id='cableMap1' class='datatable' runat='server' /><BR/>
									</TD>
								</TR>
								<TR>
									<TD class='inputform'>&#xa0;</TD>
									<TD class='whiteRowFill center'>
										<DIV id='cablebutton' runat='server'/>
									</TD>
								</TR>
								<TR><TD class='inputform'>&#xa0;</TD><TD class='whiteRowFill left'>&#xa0;</TD></TR>
							</TABLE>
						</TD>
					</TR>
				</TABLE>
				<BR/>
				<INPUT type='button' value='&#xa0; Close&#xa0; &#xa0;' onclick='refreshParent()'/>
			</DIV>
		&nbsp;<BR/>
		</DIV>
	</DIV> <!-- End: popContent -->
<!--#include file='popup_closer.inc' -->
	</FORM>
</DIV> <!-- End: container -->
</BODY>
</HTML>