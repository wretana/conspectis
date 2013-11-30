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
public void Page_Load(Object o, EventArgs e)
{
//UNCOMMENT this line to force login to access this page.
	lockout(); Page.Header.Title=shortSysName+": Add New Server";
	systemStatus(1); // Check to see if admin has put system is in offline mode.



	string sql,sql1,sql2,sqlNet, sqlSwitch;
	DataSet dat,dat1,dat2=null,datNet, datSwitch;
	string v_username, sqlErr="", v_userrole;
	string srcRackspace="", cluster="", dcPrefix="";
	bool portsFound=false;
	string specString="", buttonstring="";

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

	if (dcPrefix!="")
	{
		titleSpan.InnerHtml=dcPrefix.ToUpper().Replace("_","");
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
	string v_svrSAN="";
	string v_usingSAN="0";
	string v_comment="";

	sql="SELECT * FROM hwTypes WHERE hwType IN ('Server','Blade')";
	dat=readDb(sql);
	if (!emptyDataset(dat))
	{
		foreach(DataRow dr in dat.Tables[0].Rows)
		{
			ListItem li = new ListItem(dr["hwClassName"].ToString(), dr["hwClassName"].ToString());
			formSvrClass.Items.Add(li);
		}		
	}

	sql="SELECT DISTINCT sfwOS FROM software";
	dat=readDb(sql);
	if (!emptyDataset(dat))
	{
		foreach(DataRow dr in dat.Tables[0].Rows)
		{
			ListItem li = new ListItem(dr["sfwOS"].ToString(), dr["sfwOS"].ToString());
			formSvrOs.Items.Add(li);
		}		
	}


	
	if (!IsPostBack)
	{
		if (srcRackspace!="")
		{
			sql="SELECT * FROM "+dcPrefix+"rackspace LEFT JOIN "+dcPrefix+"servers ON "+dcPrefix+"rackspace.rackspaceId="+dcPrefix+"servers.rackspaceId WHERE "+dcPrefix+"rackspace.rackspaceId="+srcRackspace;
			dat=readDb(sql);
			if (!emptyDataset(dat))
			{
				v_svrRack = dat.Tables[0].Rows[0]["rack"].ToString();

				string sqlRack="", rackString="";
				DataSet datRack=new DataSet();
				sqlRack="SELECT location, rackId FROM "+dcPrefix+"racks WHERE rackId='"+v_svrRack+"'";
//				Response.Write(sqlRack+"<BR/>");
				datRack=readDb(sqlRack);
				if (datRack!=null)
				{
					try
					{
						rackString=" &#xa0; "+datRack.Tables[0].Rows[0]["location"].ToString()+"-R"+datRack.Tables[0].Rows[0]["rackId"].ToString().Substring(0,2)+"-C"+datRack.Tables[0].Rows[0]["rackId"].ToString().Substring(2,2)+" ("+dcPrefix.ToUpper().Replace("_","")+")";
					}
					catch (System.Exception ex)
					{
							rackString="ERR";
					}
				}
				rackText.InnerHtml=rackString;
	
//				rackText.InnerHtml="Row:"+dat.Tables[0].Rows[0]["rack"].ToString().Substring(0,2)+", Cabinet:"+dat.Tables[0].Rows[0]["rack"].ToString().Substring(2,2);

				v_svrBc = dat.Tables[0].Rows[0]["bc"].ToString();
				v_svrSlot = dat.Tables[0].Rows[0]["slot"].ToString();
				v_svrClass = dat.Tables[0].Rows[0]["class"].ToString();
				v_svrSerial = dat.Tables[0].Rows[0]["serial"].ToString();
				v_svrModel = dat.Tables[0].Rows[0]["model"].ToString();
				v_svrSAN = dat.Tables[0].Rows[0]["sanAttached"].ToString();
				specString=dat.Tables[0].Rows[0]["cpu_type"].ToString()+" "+dat.Tables[0].Rows[0]["cpu_qty"].ToString()+"x"+dat.Tables[0].Rows[0]["cpu_cores"].ToString()+", "+dat.Tables[0].Rows[0]["ram"].ToString()+"Gb RAM, "+dat.Tables[0].Rows[0]["sys_disk_qty"].ToString()+"x"+dat.Tables[0].Rows[0]["sys_disk_size"].ToString()+"Gb";
				if (dat.Tables[0].Rows[0]["data_disk_qty"].ToString()!="" && dat.Tables[0].Rows[0]["data_disk_size"].ToString()!="")
				{
					specString=specString+", "+dat.Tables[0].Rows[0]["data_disk_qty"].ToString()+"x"+dat.Tables[0].Rows[0]["data_disk_size"].ToString()+"Gb";
				}
				hw_spec.InnerHtml=specString;
				if (v_svrSAN=="1")
				{
					formSvrSAN.Checked = true;
				}
				if (v_usingSAN=="1")
				{
					formUsingSAN.Checked = true;
				}
				formSvrRack.Value=v_svrRack;
				formSvrBc.Value=v_svrBc;
				formSvrSlot.Value=v_svrSlot;
				formSvrClass.SelectedIndex=formSvrClass.Items.IndexOf(formSvrClass.Items.FindByValue(v_svrClass));
//				formSvrClass.Value=v_svrClass;
				formSvrSerial.Value=v_svrSerial;
				formSvrModel.Value=v_svrModel;

				if (v_svrBc!="")
				{
					sql1="SELECT serverLanIp FROM "+dcPrefix+"servers LEFT JOIN "+dcPrefix+"rackspace ON "+dcPrefix+"servers.rackspaceId="+dcPrefix+"rackspace.rackspaceId WHERE bc='"+v_svrBc+"' AND slot='00' AND serverOs='RSA2'";
					dat1=readDb(sql1);
					if (!emptyDataset(dat1))
					{
						v_rsaIp = dat1.Tables[0].Rows[0]["serverLanIp"].ToString();
					}
					sql1="SELECT COUNT(serverName) FROM (SELECT serverName, bc FROM "+dcPrefix+"rackspace LEFT JOIN "+dcPrefix+"servers ON "+dcPrefix+"rackspace.rackspaceId="+dcPrefix+"servers.rackspaceId WHERE bc='"+v_svrBc+"' AND serverName LIKE '%SL%')";
					dat1=readDb(sql1);
					if (!emptyDataset(dat1))
					{
						if (Convert.ToInt32(dat1.Tables[0].Rows[0]["Expr1000"])<8)
						{
							formSvrOs.SelectedIndex=formSvrOs.Items.IndexOf(formSvrOs.Items.FindByValue("Windows"));
						}
						else
						{
							formSvrOs.SelectedIndex=formSvrOs.Items.IndexOf(formSvrOs.Items.FindByValue("Linux"));
						}
					}
				}
				else
				{
					sql1="SELECT serverLanIp FROM "+dcPrefix+"servers LEFT JOIN "+dcPrefix+"rackspace ON "+dcPrefix+"servers.rackspaceId="+dcPrefix+"rackspace.rackspaceId WHERE rack='"+v_svrBc+"' AND slot='"+v_svrSlot+"' AND serverOs='RSA2'";
					dat1=readDb(sql1);
					if (!emptyDataset(dat1))
					{
						v_rsaIp = dat1.Tables[0].Rows[0]["serverLanIp"].ToString();
					}
				}
				formMgtIp.Value = v_rsaIp;
				sqlNet = "SELECT * FROM "+dcPrefix+"subnets WHERE [desc] NOT LIKE '%Service%'";
				datNet = readDb(sqlNet);
				if (datNet!=null)
				{
					foreach(DataRow dr in datNet.Tables[0].Rows)
					{
						ListItem li = new ListItem(dr["desc"].ToString(), dr["name"].ToString());
						formPubVlan.Items.Add(li);
					}
					if (v_svrModel=="ESX")
					{
						formPubVlan.SelectedIndex=formPubVlan.Items.IndexOf(formPubVlan.Items.FindByValue("subnetPheVmw140"));
						if (cluster!=null)
						{
							sql1="SELECT * FROM "+dcPrefix+"clusters WHERE clusterType='ESX'";
							dat1=readDb(sql1);
							if (!emptyDataset(dat1))
							{
								foreach (DataTable dt in dat1.Tables)
								{
									foreach (DataRow dr in dt.Rows)
									{
										if (cluster==dr["clusterName"].ToString())
										{
											formMgtIp.Value=dr["clusterLanIp"].ToString();
										}
									}
								}
							}
						}
					}
					else
					{
						formPubVlan.SelectedIndex=formPubVlan.Items.IndexOf(formPubVlan.Items.FindByValue("subnetPheRes132"));
					}
				}
				
				formSvrRack.Attributes.Add("disabled","disabled");
				formSvrBc.Attributes.Add("disabled","disabled");
				formSvrSlot.Attributes.Add("disabled","disabled");
				formSvrClass.Attributes.Add("disabled","disabled");
				formSvrSerial.Attributes.Add("disabled","disabled");
				formSvrModel.Attributes.Add("disabled","disabled");

			}

			try
			{
				int rackspace=Convert.ToInt32(v_svrRack);
			}
			catch (System.Exception ex)
			{
			}
			
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
									td.InnerHtml="<INPUT type='image' src='./img/delete_sm.png' onclick=\"window.open('deleteCabling.aspx?sw="+drr["switchId"].ToString()+"&port="+drr["portId"].ToString()+"dc="+dcPrefix+"','deleteCablingWin','width=315,height=275,menubar=no,status=yes')\" ALT='Delete Cabling' />";
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
						td.Attributes.Add("style","width:90px;");
					tr.Cells.Add(td);         //Output </TD>
				cableMap1.Rows.Add(tr);           //Output </TR>
			}
			if (v_userrole.Contains("datacenter"))
			{
				buttonstring="<INPUT type='image' src='./img/cablingbar.png' onclick=\"window.open('editCabling.aspx?id="+srcRackspace+"&dc="+dcPrefix+"','editCablingWin','width=400,height=800,menubar=no,status=yes')\" ALT='Edit Cabling' />";
				
			}
			cablebutton.InnerHtml=buttonstring;
		}
	}

	if (IsPostBack)
	{
		formSvrName.Style ["background"]="White";
		formSvrOs.Style ["background"]="White";
		formSvrPurpose.Style ["background"]="White";
		formSvrClass.Style ["background"]="White";
		formSvrModel.Style ["background"]="White";
		formSvrSerial.Style["background"]="White";
		formSvrRack.Style["background"]="White";
		formSvrBc.Style["background"]="White";
		formSvrSlot.Style ["background"]="White";
		formSvcIp.Style ["background"]="White";
		formMgtIp.Style["background"]="White";
		errmsg.InnerHtml = "";

		v_serverName = fix_hostname(fix_txt(formSvrName.Value)).ToUpper();	 
		v_rsaIp = fix_txt(formMgtIp.Value);
		v_os=formSvrOs.Value;

		if (formUsingSAN.Checked)
		{
			 v_usingSAN="1";
		}
		v_purpose = fix_txt(formSvrPurpose.Value);
		v_vlan = formPubVlan.Value;
		v_svcIp = fix_txt(formSvcIp.Value);
		v_comment = fix_txt(formComment.Value);

		bool sqlSuccess=false, sendSuccess=true;

		sql = "SELECT serverName FROM "+dcPrefix+"servers WHERE serverName='" +v_serverName+ "'";
		dat=readDb(sql);
		if (emptyDataset(dat))
		{
			if (cluster!=null && cluster!="")
			{
				if (v_serverName!="" && v_os!="" && v_vlan!="" && srcRackspace!="")
				{	
					sql = "INSERT INTO "+dcPrefix+"servers(serverName,serverRsaIp,serverSvcIp,serverOS,serverPurpose,serverPubVlan,rackspaceId,usingSAN,memberOfCluster) VALUES("
									+"'" +v_serverName+ "',"
									+"'" +v_rsaIp+      "',"
									+"'" +v_svcIp+      "',"
									+"'" +v_os+         "',"
									+"'" +v_purpose+    "',"
									+"'" +v_vlan+       "',"
									+""  +srcRackspace+ ","
									+""  +v_usingSAN+  ","
									+"'" +cluster+ "')";
//					Response.Write(cluster+"<BR/>"+sql);
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
//								//  sendServerNotice (v_serverName,v_username);
							}
							catch (System.Exception ex)
							{
								sendSuccess=false;
							}
							if (sendSuccess)
							{
								sqlErr=writeChangeLog(dateStamp.ToString(), Decrypt(v_username.ToString()), "Server Provision Notice Sent:"+v_serverName);
/*								traceSql="INSERT INTO changelog(dateStamp, changedBy, useCase) VALUES("
													+"'" +dateStamp+ "',"
													+"'" +v_username+     "',"
													+"'Server Provision Notice Sent: "+v_serverName+"')";
								sqlErr=writeDb(traceSql); */
							}	
							try
							{
//								//  sendIpRequest(v_serverName,"Initial Automated IP Request -  "+v_comment,v_username);
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
								Response.Write("<script>window.open('osRequest.aspx?os="+v_os+"&host="+v_serverName+"','osRequestWin','width=500,height=550,menubar=no,status=yes,scrollbars=yes');refreshParent("+");<"+"/script>");
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
				if (v_serverName!="" && v_os!="" && v_vlan!="" && srcRackspace!="")
				{	
					sql = "INSERT INTO "+dcPrefix+"servers(serverName,serverRsaIp,serverSvcIp,serverOS,serverPurpose,serverPubVlan,usingSAN,rackspaceId) VALUES("
									+"'" +v_serverName+ "',"
									+"'" +v_rsaIp+      "',"
									+"'" +v_svcIp+      "',"
									+"'" +v_os+         "',"
									+"'" +v_purpose+    "',"
									+"'" +v_vlan+       "',"
									+"" +v_usingSAN+   ","
									+"" +srcRackspace+ ")";
//					Response.Write(sql);
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
						sqlErr=writeChangeLog(dateStamp.ToString(), Decrypt(v_username.ToString()), sql2txt(sql).ToString());
						if (sqlErr==null || sqlErr=="")
						{
							try
							{
//								//  sendServerNotice (v_serverName,v_username);
							}
							catch (System.Exception ex)
							{
								sendSuccess=false;
							}
							if (sendSuccess)
							{
								sqlErr=writeChangeLog(dateStamp.ToString(), Decrypt(v_username.ToString()), "Server Provision Notice Sent: "+v_serverName);
							}	
							try
							{
//								//  sendIpRequest(v_serverName,"Initial Automated IP Request -  "+v_comment,v_username);
							}
							catch (System.Exception ex)
							{
								sendSuccess=false;
							}
							if (sendSuccess)
							{
								sqlErr=writeChangeLog(dateStamp.ToString(), Decrypt(v_username.ToString()), "IP Request Sent: "+v_serverName+", Initial Automated IP Request.");
							}
							if (v_os=="Linux" || v_os=="Windows")
							{
								Response.Write("<script>window.open('osRequest.aspx?os="+v_os+"&host="+v_serverName+"&dc="+dcPrefix+"','osRequestWin','width=500,height=550,menubar=no,status=yes,scrollbars=yes');refreshParent("+");<"+"/script>");
							}
							if (sqlErr==null || sqlErr=="")
							{
								Response.Write("<script>refreshParent("+");<"+"/script>");
							}
							else
							{
								errmsg.InnerHtml = "WARNING: "+sqlErr;
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
	
		}
		else
		{
			errmsg.InnerHtml = "Duplicate Record Found!";
			formSvrName.Style	["background"]="yellow";
//			formPubIp.Style ["background"]="yellow";
		}
	} //if IsPostBack */
	titleSpan.InnerHtml="Create New Server";
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
		<DIV class='center'>
			<DIV id='hw_spec' runat='server'/>
		</DIV>
		<BR/>
		<DIV class='center paleColorFill'>
			&nbsp;<BR/>
			<DIV class='center'>
				<TABLE class='datatable center'>
					<TR>
						<TD class='center'>
							<TABLE>
								<TR><TD class='inputform'>&#xa0;</TD><TD class='whiteRowFill left'>&#xa0;</TD></TR>
								<TR>
									<TD class='inputform bold'>Host Name:&#xa0;</TD>
									<TD class='whiteRowFill left'>
										<INPUT type='text' id='formSvrName' size='35' runat='server' />
									</TD>
								</TR>
								<TR>
									<TD class='inputform bold'>OS:&#xa0;</TD>
									<TD class='whiteRowFill left'>
										<SELECT id='formSvrOs' style='width:205px;' runat='server' />
									</TD>
								</TR>
								<TR>
									<TD class='inputform bold'>Purpose:&#xa0;</TD>
									<TD class='whiteRowFill left'>
										<INPUT type='text' id='formSvrPurpose' size='35' runat='server' />
									</TD>
								</TR>
								<TR>
									<TD class='inputform bold'>Server Class:&#xa0;</TD>
									<TD class='whiteRowFill left'>
										<SELECT id='formSvrClass' style='width:205px;' runat='server' />
									</TD>
								</TR>
								<TR>
									<TD class='inputform bold'>Server Model:&#xa0;</TD>
									<TD class='whiteRowFill left'>
										<INPUT type='text' size='35' id='formSvrModel' runat='server' />
									</TD>
								</TR>
								<TR>
									<TD class='inputform bold'>Server Serial:&#xa0;</TD>
									<TD class='whiteRowFill left'>
										<INPUT type='text' size='35' id='formSvrSerial' runat='server' />
									</TD>
								</TR>
								<TR>
									<TD class='inputform bold'>Cabinet:&#xa0;</TD>
									<TD class='whiteRowFill left'>
										<DIV id='rackText' runat='server'/>
										<INPUT type='hidden' id='formSvrRack' runat='server' />
									</TD>
								</TR>
								<TR>	
									<TD class='inputform bold'>BC:&#xa0;</TD>
									<TD class='whiteRowFill left'>
										<INPUT type='text' id='formSvrBc' size='35' runat='server' />
									</TD>
								</TR>
								<TR>
									<TD class='inputform bold'>Slot:&#xa0;</TD>
									<TD class='whiteRowFill left'>
										<INPUT type='text' id='formSvrSlot' size='35' runat='server' />
									</TD>
								</TR>
								<TR>
									<TD class='inputform bold'>Public VLAN:&#xa0;</TD>
									<TD class='whiteRowFill left'>
										<SELECT id='formPubVlan' name='formPubVlan' style='width:205px;' runat='server' />
									</TD>
								</TR>
								<TR><TD class='inputform'>&#xa0;</TD><TD class='whiteRowFill left'>&#xa0;</TD></TR>
								<TR>
									<TD class='inputform bold'>SAN Attached:&#xa0;</TD>
									<TD class='whiteRowFill left'>
										<INPUT type='checkbox' id='formSvrSAN' runat='server' />
									</TD>
								</TR>
								<TR>
									<TD class='inputform bold'>Using SAN?:&#xa0;</TD>
									<TD class='whiteRowFill left'>
										<INPUT type='checkbox' id='formUsingSAN' runat='server'>
									</TD>
								</TR>
								<TR><TD class='inputform'>&#xa0;</TD><TD class='whiteRowFill left'>&#xa0;</TD></TR>
<!--							<TR>
									<TD class='inputform bold'>IP Request Comment:&#xa0;</TD>
									<TD class='whiteRowFill left'>
										<TEXTAREA rows='2' cols='17' id='formComment' runat='server' />
									</TD>
								</TR> -->
								<TR>
									<TD class='inputform bold'>Service IP:&#xa0;</TD>
									<TD class='whiteRowFill left'>
										<INPUT type='text' id='formSvcIp' size='35' runat='server' />
									</TD>
								</TR>
								<TR>
									<TD class='inputform bold'>Mgt IP: (RSA/MM)&#xa0;</TD>
									<TD class='whiteRowFill left'>
										<INPUT type='text' id='formMgtIp' size='35' runat='server'>
									</TD>
								</TR>
								<TR><TD class='inputform'>&#xa0;</TD><TD class='whiteRowFill left'>&#xa0;</TD></TR>
								<TR>
									<TD class='inputform'>&#xa0;</TD>
									<TD class='whiteRowFill center'>
										<TABLE id='cableMap1' class='datatable' border='1' runat='server' />
										<BR/>
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
				<INPUT type='submit' value='Save Changes' runat='server'/>&#xa0;<INPUT type='button' value='Cancel &amp; Close' onclick='refreshParent()'/>
				<BR/>&nbsp;
			</DIV>
		</DIV>
	</DIV> <!-- End: popContent -->
<!--#include file='popup_closer.inc' -->
	</FORM>
</DIV> <!-- End: container -->
</BODY>
</HTML>