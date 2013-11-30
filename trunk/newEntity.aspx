<%@Page Inherits="CIS.conspectisLibrary" src="conspectisLibrary.cs" Language="C#" debug="true" %>
<%@Import Namespace="System.Data.OleDb"%>
<%@Import Namespace="System.Data"%>
<%@Import Namespace="System"%>

<!DOCTYPE html>
<!-- HTML5 Status: VALID 2-13-13 CK -->
<!--[if lt IE 7 ]> <html lang='en' class='no-js ie6'> <![endif]-->
<!--[if IE 7 ]>    <html lang='en' class='no-js ie7'> <![endif]-->
<!--[if IE 8 ]>    <html lang='en' class='no-js ie8'> <![endif]-->
<!--[if IE 9 ]>    <html lang='en' class='no-js ie9'> <![endif]-->
<!--[if (gt IE 9)|!(IE)]><!--> <html lang='en' class='no-js'> <!--<![endif]-->

<HEAD runat="server">

<!--#include file="header.inc"-->

<SCRIPT runat="server">

public void go_button(Object s, EventArgs e)
{
	string sql="", sql1="", v_vlan="", dcPrefix="";
	DataSet dat = new DataSet();
	DataSet dat1= new DataSet();

	try
	{
		dcPrefix=Request.QueryString["dc"].ToString();
	}
	catch (System.Exception ex)
	{
		dcPrefix="";
	}

	v_vlan=formPubVlan.Value;

	sql1="SELECT ipAddr FROM (SELECT * FROM "+dcPrefix+v_vlan+" LEFT JOIN "+dcPrefix+"servers ON "+dcPrefix+"servers.serverLanIp="+dcPrefix+v_vlan+".ipAddr WHERE "+dcPrefix+"servers.serverLanIp IS NULL) AS ipPool WHERE reserved=0 ORDER BY ipAddr ASC";
//	Response.Write(sql1);
	dat1=readDb(sql1);

	formPubIp.DataSource = dat1;
	formPubIp.DataTextField = "ipAddr";
	formPubIp.DataValueField = "ipAddr";
	formPubIp.DataBind(); 

}

public void goSubmit(Object s, EventArgs e)
{
	string sql,sql1,sql2,sqlNet, sqlSwitch, sqlEntities="";
	DataSet dat,dat1,dat2=null,datNet, datSwitch, datEntities;
	string v_username="", sqlErr="", v_userrole="", v_userclass="";
	string srcRackspace, cluster, dcPrefix="";
	bool portsFound=false;
	string specString="";

	try
	{
		srcRackspace=Request.QueryString["rackspace"].ToString();	
	}
	catch (System.Exception ex)
	{
		srcRackspace="";
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
		cluster=Request.QueryString["vm"].ToString();	
	}
	catch (System.Exception ex)
	{
		cluster="";
	}

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
		v_userrole=Request.Cookies["role"].Value;
	}
	catch (System.Exception ex)
	{
		v_userrole="";
	}

	try
	{
		v_username=Request.Cookies["username"].Value;
	}
	catch (System.Exception ex)
	{
		v_username="";
	}

	string v_serverName="";
	string v_os="";
	string v_purpose="";
	string v_vlan="";
	string v_comment="";
	string v_pubIp="";

	formSvrName.Style ["background"]="White";
	formSvrPurpose.Style ["background"]="White";

	errmsg.InnerHtml = "";

	v_serverName = fix_txt(formSvrName.Value).ToUpper();	 
	v_os=formSvrOs.Value;

	v_purpose = fix_txt(formSvrPurpose.Value);
	v_vlan = formPubVlan.Value;
	v_pubIp=fix_txt(formPubIp.Value);

	bool sqlSuccess=false, sendSuccess=true;

	sql = "SELECT serverName FROM "+dcPrefix+"servers WHERE serverName='" +v_serverName+ "'";
	dat=readDb(sql);
	if (emptyDataset(dat))
	{
		if (v_os=="RSA2")
		{
			v_purpose="Remote Managment";
		}
		
		if (v_os=="Network")
		{
			if (v_serverName.Substring(0,2)=="LB")
			{
				v_purpose=v_purpose+": Load Balancer VIP";
			}
		}

		if (v_os=="DNS")
		{
			v_purpose=v_purpose+": DNS Alias / CNAME";
		}

		if (v_serverName!="" && v_os!="" && v_vlan!="" && srcRackspace!="")
		{	
			sql = "INSERT INTO "+dcPrefix+"servers(serverName,serverLanIp,serverOS,serverPurpose,serverPubVlan,rackspaceId) VALUES("
							+"'" +v_serverName+ "',"
							+"'" +v_pubIp+      "',"
							+"'" +v_os+      "',"
							+"'" +v_purpose+      "',"
							+"'" +v_vlan+         "',"
							+""  +srcRackspace+ ")";
//			Response.Write(sql);
			sqlErr=writeDb(sql);
			if (sqlErr==null || sqlErr=="")
			{			
				errmsg.InnerHtml = "Server Record Updated.";
				sqlSuccess=true;
			}
			else
			{
				errmsg.InnerHtml = "SQL Update Error - Server<BR/>"+sqlErr;
				sqlErr="";
			}
 			if (sqlSuccess) 
			{
				string traceSql;
				sqlErr=writeChangeLog( dateStamp.ToString(), Decrypt(v_username.ToString()), sql2txt(sql).ToString());
				if (sqlErr==null || sqlErr=="")
				{
					try
					{
						//  sendServerNotice (v_serverName,v_username);
					}
					catch (System.Exception ex)
					{
						sendSuccess=false;
					}
					if (sendSuccess)
					{
						sqlErr=writeChangeLog(dateStamp.ToString(), Decrypt(v_username.ToString()), "Entity Provision Notice Sent: "+v_serverName+", Entity Provision Notice");
					}	
					try
					{
//						//  sendIpRequest(v_serverName,"Initial Automated IP Request -  "+v_comment,v_username);
					}
					catch (System.Exception ex)
					{
						sendSuccess=false;
					}
					if (sendSuccess)
					{
						sqlErr=writeChangeLog(dateStamp.ToString(), Decrypt(v_username.ToString()), "IP Request Sent: "+v_serverName+", Initial Automated IP Request");
					}
					if (v_os=="Linux" || v_os=="Windows")
					{
						Response.Write("<script>window.open('osRequest.aspx?os="+v_os+"&host="+v_serverName+"&dc="+dcPrefix+"','osRequestWin','width=500,height=750,menubar=no,status=yes,scrollbars=yes');refreshParent("+");<"+"/script>");
					}
					else
					{
						Response.Write("<script>refreshParent("+");<"+"/script>");
					}
				}
			}
		}
		else 
		{
			if (v_serverName == "") formSvrName.Style	["background"]="yellow";
			if (v_os == "") formSvrOs.Style ["background"]="yellow";
			if (v_vlan == "") formPubVlan.Style ["background"]="yellow";
			string errStr = "Please enter valid data in all required fields!";
			errmsg.InnerHtml = errStr;
		}
	}
	else
	{
		errmsg.InnerHtml = "Duplicate Record Found!";
		formSvrName.Style	["background"]="yellow";
//		formPubIp.Style ["background"]="yellow";
	}
}

public void Page_Load(Object o, EventArgs e)
{
//UNCOMMENT this line to force login to access this page.
	lockout(); 
	Page.Header.Title=shortSysName+": New Entity";
	systemStatus(1); // Check to see if admin has put system is in offline mode.



	string sql,sql1,sql2,sqlNet, sqlSwitch, sqlEntities="";
	DataSet dat,dat1,dat2=null,datNet, datSwitch, datEntities;
	string v_username="", sqlErr="", v_userrole="", v_userclass="";
	string srcRackspace, cluster, dcPrefix="";
	bool portsFound=false;
	string specString="";

	try
	{
		srcRackspace=Request.QueryString["rackspace"].ToString();	
	}
	catch (System.Exception ex)
	{
		srcRackspace="";
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
		cluster=Request.QueryString["vm"].ToString();	
	}
	catch (System.Exception ex)
	{
		cluster="";
	}

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
		v_userrole=Request.Cookies["role"].Value;
	}
	catch (System.Exception ex)
	{
		v_userrole="";
	}

	try
	{
		v_username=Request.Cookies["username"].Value;
	}
	catch (System.Exception ex)
	{
		v_username="";
	}

	string v_serverName="";
	string v_rsaIp="";
	string v_svcIp="";
	string v_os="";
	string v_purpose="";
	string v_vlan="";
	string v_svrRack="";
	string v_svrBc="";
	string v_svrSlot="";
	string v_svrClass="";
	string v_svrSerial="";
	string v_svrModel="";
	string v_svrSAN="0";
	string v_usingSAN="0";
	string v_comment="";

	if (srcRackspace!="")
	{
		dat2=getPorts(srcRackspace,dcPrefix);
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
				td.Attributes.Add("width","40");
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml = "<SPAN class='smaller'>Switch</SPAN>";
				td.Attributes.Add("width","40");
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml = "<SPAN class='smaller'>Slot</SPAN>";
					td.Attributes.Add("width","10");
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml = "<SPAN class='smaller'>Port</SPAN>";
					td.Attributes.Add("width","10");
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml = "<SPAN class='smaller'>Actions</SPAN>";
				td.Attributes.Add("width","40");
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
								td.InnerHtml="<INPUT type='image' src='./img/delete_sm.png' onclick=\"window.open('deleteCabling.aspx?sw="+drr["switchId"].ToString()+"&port="+drr["portId"].ToString()+"&dc="+dcPrefix+"','deleteCablingWin','width=315,height=275,menubar=no,status=yes')\" ALT='Delete Cabling' /></SPAN>";
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
					td.Attributes.Add("class","center errorBox");
					td.Attributes.Add("width","90");
				tr.Cells.Add(td);         //Output </TD>
			cableMap1.Rows.Add(tr);           //Output </TR>
		}
		sqlEntities="SELECT * FROM "+dcPrefix+"servers WHERE rackspaceId="+srcRackspace;
		datEntities=readDb(sqlEntities);
		if (datEntities!=null)
		{
			HtmlTableRow tr;
			HtmlTableCell td;
			tr = new HtmlTableRow();    //Output <TR>
				tr.Attributes.Add("class","blackheading");
				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("colspan","3");
					td.InnerHtml = " Existing Entities";
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml="&#xa0;";
				tr.Cells.Add(td);         //Output </TD>
			entityTable.Rows.Add(tr);           //Output </TR>
			tr = new HtmlTableRow();    //Output <TR>
				tr.Attributes.Add("class","tableheading");
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml = "Name";
					td.Attributes.Add("style","width:10px;");
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml = "OS";
					td.Attributes.Add("style","width:5px;");
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml = "IP";
					td.Attributes.Add("style","width:5px;");
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml = "&#xa0;";
					td.Attributes.Add("style","width:5px;");
				tr.Cells.Add(td);         //Output </TD>
			entityTable.Rows.Add(tr);           //Output </TR>
			foreach (DataTable dtt in datEntities.Tables)
			{
				foreach (DataRow drr in dtt.Rows)
				{
					tr = new HtmlTableRow();    //Output <TR>
						td = new HtmlTableCell(); //Output <TD>
							td.InnerHtml="<SPAN class='smaller'>"+drr["serverName"].ToString()+"</SPAN>";
							td.Attributes.Add("class","center");
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
							td.InnerHtml="<SPAN class='smaller'>"+drr["serverOs"].ToString()+"</SPAN>";
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
							td.InnerHtml="<SPAN class='smaller'>"+fix_ip(drr["serverLanIp"].ToString())+"</SPAN>";
							td.Attributes.Add("class","center");
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
							td.InnerHtml="<INPUT type='image' src=./img/detail.png onclick=\"window.open('showServer.aspx?host="+drr["serverName"].ToString()+"&dc="+dcPrefix+"&method=admin','editServerWin','width=400,height=750,menubar=no,scrollbars=yes,status=yes')\" ALT='Show Server' />";
							td.Attributes.Add("class","center");
						tr.Cells.Add(td);         //Output </TD>
					entityTable.Rows.Add(tr);           //Output </TR>
				}
			}
		}
		else
		{
			HtmlTableRow tr;
			HtmlTableCell td;
			tr = new HtmlTableRow();    //Output <TR>
				tr.Attributes.Add("class","blackheading");
				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("colspan","3");
					td.InnerHtml = "Entities";
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml="&#xa0;";
				tr.Cells.Add(td);         //Output </TD>
			entityTable.Rows.Add(tr);           //Output </TR>
			tr = new HtmlTableRow();    //Output <TR>
				td = new HtmlTableCell(); //Output <TD>
				td.Attributes.Add("colspan","4");
					td.InnerHtml="None Found";
				tr.Cells.Add(td);         //Output </TD>
			entityTable.Rows.Add(tr);           //Output </TR>
		}
	}	


	if (!IsPostBack)
	{
		sql="SELECT DISTINCT(serverOs) FROM "+dcPrefix+"servers WHERE serverOs NOT IN('AIX','Linux','Windows','ESX') ORDER BY serverOs";
		dat=readDb(sql);
		if (!emptyDataset(dat))
		{
			foreach(DataRow dr in dat.Tables[0].Rows)
			{
				ListItem li = new ListItem(dr["serverOs"].ToString(), dr["serverOs"].ToString());
				formSvrOs.Items.Add(li);
			}		
			ListItem li2 = new ListItem("DNS A/ CNAME","DNS");
			formSvrOs.Items.Add(li2);
		}

		if (srcRackspace!="")
		{
//			Response.Write(dcPrefix);
			sql="SELECT * FROM "+dcPrefix+"rackspace LEFT JOIN "+dcPrefix+"servers ON "+dcPrefix+"rackspace.rackspaceId="+dcPrefix+"servers.rackspaceId WHERE "+dcPrefix+"rackspace.rackspaceId="+srcRackspace;
			dat=readDb(sql);
			if (!emptyDataset(dat))
			{
				if (dat.Tables[0].Rows[0]["bc"].ToString()!="")
				{
					v_svrBc=", BC "+dat.Tables[0].Rows[0]["bc"].ToString();
				}
				string sqlRack="", rackString="";
				DataSet datRack=new DataSet();
				sqlRack="SELECT location, rackId FROM "+dcPrefix+"racks WHERE rackId='"+dat.Tables[0].Rows[0]["rack"].ToString()+"'";
//				Response.Write(sqlRack+"<BR/>");
				datRack=readDb(sqlRack);
				if (datRack!=null)
				{
					try
					{
						rackString=" ("+dcPrefix.ToUpper().Replace("_","")+") "+datRack.Tables[0].Rows[0]["location"].ToString()+"-R"+datRack.Tables[0].Rows[0]["rackId"].ToString().Substring(0,2)+"-C"+datRack.Tables[0].Rows[0]["rackId"].ToString().Substring(2,2);
					}
					catch (System.Exception ex)
					{
						rackString="ERR";
					}
				}
				specString="<SPAN class='bold'>"+rackString+v_svrBc+", Slot "+dat.Tables[0].Rows[0]["slot"].ToString()+"</SPAN><BR/>"+dat.Tables[0].Rows[0]["cpu_type"].ToString()+" "+dat.Tables[0].Rows[0]["cpu_qty"].ToString()+"x"+dat.Tables[0].Rows[0]["cpu_cores"].ToString()+", "+dat.Tables[0].Rows[0]["ram"].ToString()+"Gb RAM, "+dat.Tables[0].Rows[0]["sys_disk_qty"].ToString()+"x"+dat.Tables[0].Rows[0]["sys_disk_size"].ToString()+"Gb";
				if (dat.Tables[0].Rows[0]["data_disk_qty"].ToString()!="" && dat.Tables[0].Rows[0]["data_disk_size"].ToString()!="")
				{
					specString=specString+", "+dat.Tables[0].Rows[0]["data_disk_qty"].ToString()+"x"+dat.Tables[0].Rows[0]["data_disk_size"].ToString()+"Gb";
				}
				hw_spec.InnerHtml=specString;
				sqlNet = "SELECT * FROM "+dcPrefix+"subnets WHERE [desc] NOT LIKE '%Service%'";
				datNet = readDb(sqlNet);
				if (datNet!=null)
				{
					foreach(DataRow dr in datNet.Tables[0].Rows)
					{
						ListItem li = new ListItem(dr["desc"].ToString(), dr["name"].ToString());
						formPubVlan.Items.Add(li);
					}

				}
			}

			try
			{
				int rackspace=Convert.ToInt32(v_svrRack);
			}
			catch (System.Exception ex)
			{
			}
			
		}
	}

	if (IsPostBack)
	{
	
	} //if IsPostBack */
	titleSpan.InnerHtml="Create New Entity";
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
		</DIV>
		<DIV class='center'>
			<DIV id='hw_spec' runat='server'/>
		</DIV>
		<DIV class='center paleColorFill'>
		&nbsp;<BR/>
			<TABLE class='datatable center'>
			<TR><TD class='center'>
				<TABLE>
					<TR><TD class='inputform'>&#xa0;</TD><TD class='whiteRowFill'>&#xa0;</TD></TR>
					<TR>
						<TD class='inputform bold'>
							Host Name:&#xa0;
						</TD>
						<TD class='whiteRowFill left'>
							<INPUT type='text' id='formSvrName' size='35' runat='server'>
						</TD>
					</TR>
					<TR>
						<TD class='inputform bold'>
							Type:&#xa0;
						</TD>
						<TD class='whiteRowFill left'>
							<SELECT id='formSvrOs' style='width:206px;' runat='server' />
						</TD>
					</TR>
					<TR>
						<TD class='inputform bold'>
							Project / App / SR#:&#xa0;
						</TD>
						<TD class='whiteRowFill left'>
							<INPUT type='text' id='formSvrPurpose' size='35' runat='server'>
						</TD>
					</TR>
					<TR><TD class='inputform bold'>&#xa0;</TD><TD class='whiteRowFill'>&#xa0;</TD></TR>
					<TR>
						<TD class='inputform bold'>
							Public VLAN:&#xa0;
						</TD>
						<TD class='whiteRowFill left'>
							<SELECT id='formPubVlan' name='formPubVlan' style='width:206px;' runat='server'/>&#xa0;
							<INPUT type='button' id='goButton' value='Show IPs' OnServerClick='go_button' runat='server' />
						</TD>
					</TR>
					<TR>
						<TD class='inputform'>
							<SPAN class='bold'>Public IP:&#xa0;</SPAN>
						</TD>
						<TD class='whiteRowFill left'>
							<SELECT id='formPubIp' style='width:206px;' runat='server' />
					</TD></TR>
					<TR><TD class='inputform'>&#xa0;</TD><TD class='whiteRowFill'>&#xa0;</TD></TR>
					<TR>
						<TD class='inputform'>&#xa0;</TD>
						<TD class='whiteRowFill center'>
							<TABLE id='cableMap1' class='datatable center' runat='server'></TABLE>
							<BR/>
						</TD>
					</TR>
					<TR><TD class='inputform'>&#xa0;</TD><TD class='whiteRowFill'>&#xa0;</TD></TR>
					<TR>
						<TD class='inputform'>&#xa0;</TD>
						<TD class='whiteRowFill center'>
							<TABLE id='entityTable' class='datatable center' runat='server'></TABLE>
						</TD>
					</TR>
					<TR><TD class='inputform'>&#xa0;</TD><TD class='whiteRowFill'>&#xa0;</TD></TR>
				</TABLE>
			</TABLE>
			<BR/>
			<INPUT type='button' id='submitButton' value='Save' OnServerClick='goSubmit' runat='server'/>&#xa0;<INPUT type='button' value='Cancel &amp; Close' onclick='refreshParent()'/>
			<BR/>&nbsp;
		</DIV>
	</DIV> <!-- End: popContent -->
<!--#include file='popup_closer.inc' -->
	</FORM>
</DIV> <!-- End: container -->
</BODY>
</HTML>