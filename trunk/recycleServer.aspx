<%@Page Inherits="CIS.conspectisLibrary" src="conspectisLibrary.cs" Language="C#" debug="true" %>
<%@Import Namespace="System.Data.OleDb"%>
<%@Import Namespace="System.Data"%>
<%@Import Namespace="System"%>

<!DOCTYPE html>
<!-- HTML5 Status: VALID 2-15-13 CK -->
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
	lockout(); 
	Page.Header.Title=shortSysName+": Recycle \\ Reprovision a Server";
	systemStatus(1); // Check to see if admin has put system is in offline mode.



	string sql="",sql1="",sql2="",sql3="",sqlNet="";
	DataSet dat=null,dat1,dat2=null,dat3=null, datNet=null;
	string v_username, v_userrole="", sqlErr="", errStr="";
	string srcHost="", srcRackspace="", dcPrefix="";

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

	string v_serverName="";
	string v_rsaIp="";
	string v_svcIp="";
	string v_os="";
	string v_purpose="";
	string v_svrRack="";
	string v_svrBc="";
	string v_svrSlot="";
	string v_svrClass="";
	string v_svrSerial="";
	string v_svrModel="";
	string v_svrSAN="";
	string v_comment="";

	string v_vlan="";
	string v_svrLanIp="";
	string specString="";

	if (srcHost!="")
	{
		sql="SELECT * FROM "+dcPrefix+"servers WHERE serverName='"+srcHost+"'";
		dat=readDb(sql);
		if (!emptyDataset(dat))
		{
			ViewState["recycleLanIp"] = fix_ip(dat.Tables[0].Rows[0]["serverLanIp"].ToString());
			ViewState["recyclePubVlan"] = dat.Tables[0].Rows[0]["serverPubVlan"].ToString();
			ViewState["recycleRackspace"] = dat.Tables[0].Rows[0]["rackspaceId"].ToString();
			ViewState["recycleHost"] = srcHost;
		}
	}

	
	if (!IsPostBack)
	{
		srcRackspace=(string)ViewState["recycleRackspace"];
		if (srcRackspace!="")
		{
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
			sql="SELECT * FROM "+dcPrefix+"rackspace LEFT JOIN "+dcPrefix+"servers ON "+dcPrefix+"rackspace.rackspaceId="+dcPrefix+"servers.rackspaceId WHERE "+dcPrefix+"rackspace.rackspaceId="+srcRackspace;
			dat=readDb(sql);
			if (!emptyDataset(dat))
			{
				v_svrRack = dat.Tables[0].Rows[0]["rack"].ToString();
				v_svrBc = dat.Tables[0].Rows[0]["bc"].ToString();
				v_svrSlot = dat.Tables[0].Rows[0]["slot"].ToString();
				v_svrClass = dat.Tables[0].Rows[0]["class"].ToString();
				v_svrSerial = dat.Tables[0].Rows[0]["serial"].ToString();
				v_svrModel = dat.Tables[0].Rows[0]["model"].ToString();
				v_svrSAN = dat.Tables[0].Rows[0]["sanAttached"].ToString();
				if (v_svrSAN=="1")
				{
					formSvrSAN.Checked = true;
				}
				string rackString="",sqlRack="";
				DataSet datCabinet=new DataSet();
				sqlRack="SELECT location, rackId FROM "+dcPrefix+"racks WHERE rackId='"+v_svrRack+"'";
				datCabinet=readDb(sqlRack);
				if (datCabinet!=null)
				{
					try
					{
						rackString=datCabinet.Tables[0].Rows[0]["location"].ToString()+"-R"+datCabinet.Tables[0].Rows[0]["rackId"].ToString().Substring(0,2)+"-C"+datCabinet.Tables[0].Rows[0]["rackId"].ToString().Substring(2,2)+" ("+dcPrefix.ToUpper().Replace("_","")+")";
					}
					catch (System.Exception ex)
					{
						rackString="ERR";
					}
				}
				formSvrRack.Value=rackString;
				formSvrBc.Value=v_svrBc;
				formSvrSlot.Value=v_svrSlot;
				formSvrClass.SelectedIndex=formSvrClass.Items.IndexOf(formSvrClass.Items.FindByValue(v_svrClass));
				formSvrSerial.Value=v_svrSerial;
				formSvrModel.Value=v_svrModel;

				specString=dat.Tables[0].Rows[0]["cpu_type"].ToString()+" "+dat.Tables[0].Rows[0]["cpu_qty"].ToString()+"x"+dat.Tables[0].Rows[0]["cpu_cores"].ToString()+", "+dat.Tables[0].Rows[0]["ram"].ToString()+"Gb RAM, "+dat.Tables[0].Rows[0]["sys_disk_qty"].ToString()+"x"+dat.Tables[0].Rows[0]["sys_disk_size"].ToString()+"Gb"+"<BR/>"+rackString;
				if (dat.Tables[0].Rows[0]["data_disk_qty"].ToString()!="" && dat.Tables[0].Rows[0]["data_disk_size"].ToString()!="")
				{
					specString=specString+", "+dat.Tables[0].Rows[0]["data_disk_qty"].ToString()+"x"+dat.Tables[0].Rows[0]["data_disk_size"].ToString()+"Gb";
				}
				hw_spec.InnerHtml=specString;
				if (v_svrBc!="")
				{
					sql1="SELECT serverLanIp FROM "+dcPrefix+"servers LEFT JOIN "+dcPrefix+"rackspace ON "+dcPrefix+"servers.rackspaceId="+dcPrefix+"rackspace.rackspaceId WHERE bc='"+v_svrBc+"' AND slot='00' AND serverOs='RSA2'";
					dat1=readDb(sql1);
					if (!emptyDataset(dat1))
					{
						v_rsaIp = dat1.Tables[0].Rows[0]["serverLanIp"].ToString();
					}
				}
				else
				{
					sql1="SELECT serverLanIp FROM "+dcPrefix+"servers LEFT JOIN "+dcPrefix+"rackspace ON "+dcPrefix+"servers.rackspaceId="+dcPrefix+"rackspace.rackspaceId WHERE rack='"+v_svrRack+"' AND slot='"+v_svrSlot+"' AND serverOs='RSA2'";
					dat1=readDb(sql1);
					if (!emptyDataset(dat1))
					{
						v_rsaIp = dat1.Tables[0].Rows[0]["serverLanIp"].ToString();
					}
				}
				formMgtIp.Value = v_rsaIp;
				formPubIp.Value = (string)ViewState["recycleLanIp"];
				v_vlan = (string)ViewState["recyclePubVlan"];

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
					}
					else
					{
						formPubVlan.SelectedIndex=formPubVlan.Items.IndexOf(formPubVlan.Items.FindByValue(v_vlan));
					}
				}
				formSvrRack.Attributes.Add("disabled","disabled");
				formSvrBc.Attributes.Add("disabled","disabled");
				formSvrSlot.Attributes.Add("disabled","disabled");
				formSvrClass.Attributes.Add("disabled","disabled");
				formSvrSerial.Attributes.Add("disabled","disabled");
				formSvrModel.Attributes.Add("disabled","disabled");
				formPubIp.Attributes.Add("disabled","disabled");
				formPubVlan.Attributes.Add("disabled","disabled");
			}

			int rackspace=0;
			try
			{
				rackspace=Convert.ToInt32(v_svrRack);
			}
			catch (System.Exception ex)
			{
				rackspace=0;
			}
			
			if (v_svrBc!="")
			{
				if (v_svrBc=="14" || v_svrBc=="15")
				{
					sql1="SELECT rackspaceId FROM "+dcPrefix+"rackspace WHERE rack='"+v_svrRack+"' AND	bc='"+v_svrBc+"' AND slot IN('"+v_svrSlot+"','00') AND class<>'Virtual'";
				}
				else
				{
					sql1="SELECT rackspaceId FROM "+dcPrefix+"rackspace WHERE rack='"+v_svrRack+"' AND bc='"+v_svrBc+"' AND slot='00' AND class<>'Virtual'";
				}			
			}
			else
			{
				sql1="SELECT rackspaceId FROM "+dcPrefix+"rackspace WHERE rack='"+v_svrRack+"' AND slot='"+v_svrSlot+"' AND class<>'Virtual'";
			}

			string targetRackspace="";
			string cableSrc="";

			dat1=readDb(sql1);
			if (!emptyDataset(dat1))
			{
				if (v_svrBc=="14" || v_svrBc=="15")
				{
					string list="";
					foreach (DataTable dtt in dat1.Tables)
					{
						foreach (DataRow drr in dtt.Rows)
						{
							list=list+drr["rackspaceId"].ToString()+",";
						}
					}
					cableSrc="cabledTo IN("+list+"00)";
				}
				else
				{
					cableSrc="cabledTo="+dat1.Tables[0].Rows[0]["rackspaceId"].ToString()+"";
				}
				targetRackspace=dat1.Tables[0].Rows[0]["rackspaceId"].ToString();
			}

			bool portsFound=false;
			dat2=getPorts(targetRackspace,dcPrefix);
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
					td.Attributes.Add("style","width:40");
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
						td.Attributes.Add("class","errorBox center");
						td.Attributes.Add("style","width:90px");
					tr.Cells.Add(td);         //Output </TD>
				cableMap1.Rows.Add(tr);           //Output </TR>
			}
		}
	}

//	formSvrRack.Value=rackString;
	formSvrBc.Value=v_svrBc;
	formSvrSlot.Value=v_svrSlot;
	formSvrClass.SelectedIndex=formSvrClass.Items.IndexOf(formSvrClass.Items.FindByValue(v_svrClass));
	formSvrSerial.Value=v_svrSerial;
	formSvrModel.Value=v_svrModel;  

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
//		formPubIp.Style ["background"]="White";
		formSvcIp.Style ["background"]="White";
		formMgtIp.Style["background"]="White";
		errmsg.InnerHtml = "";

		v_serverName = fix_txt(formSvrName.Value).ToUpper();	 
		v_rsaIp = fix_txt(formMgtIp.Value);
		v_os=fix_txt(formSvrOs.Value);
		v_purpose = fix_txt(formSvrPurpose.Value);
		v_svcIp = fix_txt(formSvcIp.Value);
		srcHost = (string)ViewState["recycleHost"];
		v_vlan = (string)ViewState["recyclePubVlan"];
		v_svrLanIp = (string)ViewState["recycleLanIp"];
		srcRackspace = (string)ViewState["recycleRackspace"];

		bool sqlSuccess=false, sendSuccess=true;

		sql = "SELECT serverName FROM "+dcPrefix+"servers WHERE serverName='" +v_serverName+ "'";
		dat=readDb(sql);
		if (emptyDataset(dat))
		{
			if (v_serverName!="" && v_os!="" && v_vlan!="" && v_svrLanIp!="" && srcRackspace!="")
			{	
				sql = "DELETE FROM "+dcPrefix+"servers WHERE serverName='"+srcHost+"'";
				sqlErr=writeDb(sql);
				if (sqlErr==null || sqlErr=="")
				{
					errmsg.InnerHtml = "Record DELETED.";
					sqlSuccess=true;
				}
				else
				{
					errmsg.InnerHtml = "SQL Update Error - "+sqlErr;
					sqlSuccess=false;
					sqlErr="";
				}
				if (sqlSuccess) 
				{
					sqlErr=writeChangeLog(dateStamp.ToString(), Decrypt(v_username.ToString()), sql2txt(sql).ToString());
					if (sqlErr==null || sqlErr=="")
					{
						try
						{
							//  sendServerDeletionNotice(srcHost,v_username);
						}
						catch (System.Exception ex)
						{
							sendSuccess=false;
							errStr=ex.ToString();
						}
						if (sendSuccess)
						{
							sqlErr=writeChangeLog(dateStamp.ToString(), Decrypt(v_username.ToString()), "Server Deletion Notice Sent: "+srcHost);
						}
						errmsg.InnerHtml=errStr;
					}
					sql = "INSERT INTO "+dcPrefix+"servers(serverName,serverRsaIp,serverLanIp,serverSvcIp,serverOS,serverPurpose,serverPubVlan,rackspaceId) VALUES("
								+"'" +v_serverName+ "',"
								+"'" +v_rsaIp+      "',"
								+"'" +v_svrLanIp+   "',"
								+"'" +v_svcIp+      "',"
								+"'" +v_os+         "',"
								+"'" +v_purpose+    "',"
								+"'" +v_vlan+       "',"
								+"" +srcRackspace+ ")";

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
						Response.Write(sqlErr);
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
								sqlErr=writeChangeLog(dateStamp.ToString(), Decrypt(v_username.ToString()), "Server Provision Notice Sent: "+v_serverName);
							}	
							Response.Write(v_os+","+v_serverName);
							if (v_os=="Linux" || v_os=="Windows")
							{
								Response.Write("<script>window.open('osRequest.aspx?os="+v_os+"&host="+v_serverName+"&amp;dc="+dcPrefix+"','osRequestWin','width=500,height=750,menubar=no,status=yes,scrollbars=yes');refreshParent("+");<"+"/script>");
							}
							else
							{
								Response.Write("<script>refreshParent("+");<"+"/script>");
							}
						}
					}		
				}
			}
			else 
			{
				if (v_serverName == "") formSvrName.Style	["background"]="yellow";
				if (v_os == "") formSvrOs.Style ["background"]="yellow";
				if (v_vlan == "") formPubVlan.Style ["background"]="yellow";
				errStr = "Please enter valid data in all required fields!";
				errmsg.InnerHtml = errStr;
			}	
		}
		else
		{
			errmsg.InnerHtml = "Duplicate Record Found!";
			formSvrName.Style	["background"]="yellow";
//			formPubIp.Style ["background"]="yellow";
		}
	} //if IsPostBack */
	titleSpan.InnerHtml="Recycle Server";
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
			<TABLE border='1' class='datatable center'>
				<TR>
					<TD class='center'>
						<TABLE>
							<TR><TD class='inputform'>&#xa0;</TD><TD class='whiteRowFill center'>&#xa0;</TD></TR>
							<TR>
								<TD class='inputform bold'>Host Name:&#xa0;</TD>
								<TD class='whiteRowFill left'>
									<INPUT type='text' id='formSvrName' size='30' runat='server' />
								</TD>
							</TR>
							<TR>
								<TD class='inputform bold'>OS:&#xa0;</TD>
								<TD class='whiteRowFill left'>
									<SELECT id='formSvrOs' style='width:182px;' runat='server' />
								</TD>
							</TR>
							<TR>
								<TD class='inputform bold'>Purpose:&#xa0;</TD>
								<TD class='whiteRowFill left'>
									<INPUT type='text' id='formSvrPurpose' size='30' runat='server' />
								</TD>
							</TR>
							<TR>
								<TD class='inputform bold'>Server Class:&#xa0;</TD>
								<TD class='whiteRowFill left'>
									<SELECT id='formSvrClass' style='width:182px;' runat='server' />
								</TD>
							</TR>
							<TR>
								<TD class='inputform bold'>Server Model:&#xa0;</TD>
								<TD class='whiteRowFill left'>
									<INPUT type='text' id='formSvrModel' size='30' runat='server' />
								</TD>
							</TR>
							<TR>
								<TD class='inputform bold'>Server Serial:&#xa0;</TD>
								<TD class='whiteRowFill left'>
									<INPUT type='text' id='formSvrSerial' size='30' runat='server' />
								</TD>
							</TR>
							<TR>
								<TD class='inputform bold'>Rack:&#xa0;</TD>
								<TD class='whiteRowFill left'>
									<INPUT type='text' id='formSvrRack' size='30' runat='server' />
								</TD>
							</TR>
							<TR>
								<TD class='inputform bold'>BC:&#xa0;</TD>
								<TD class='whiteRowFill left'>
									<INPUT type='text' id='formSvrBc' size='30' runat='server' />
								</TD>
							</TR>
							<TR>
								<TD class='inputform bold'>Slot:&#xa0;</TD>
								<TD class='whiteRowFill left'>
									<INPUT type='text' id='formSvrSlot' size='30' runat='server' />
								</TD>
							</TR>
							<TR>
								<TD class='inputform'>Public VLAN:&#xa0;</TD>
								<TD class='whiteRowFill left'>
									<SELECT id='formPubVlan' style='width:182px;' runat='server'/>
								</TD>
							</TR>
							<TR>
								<TD class='inputform bold'>SAN Attached:&#xa0;</TD>
								<TD class='whiteRowFill left'>
									<INPUT type='checkbox' id='formSvrSAN' runat='server'>
								</TD>
							</TR>
							<TR><TD class='inputform'>&#xa0;</TD><TD class='whiteRowFill center'>&#xa0;</TD></TR>
							<TR>
								<TD class='inputform bold'>Public IP:&#xa0;</TD>
								<TD class='whiteRowFill left'>
									<INPUT type='text' id='formPubIp' size='30' runat='server' />
								</TD>
							</TR>
							<TR>
								<TD class='inputform'>Service IP:&#xa0;</TD>
								<TD class='whiteRowFill left'>
									<INPUT type='text' id='formSvcIp' size='30' runat='server' />
								</TD>
							</TR>
							<TR>
								<TD class='inputform'>Mgt IP: (RSA/MM)&#xa0;</TD>
								<TD class='whiteRowFill left'>
									<INPUT type='text' id='formMgtIp' size='30' runat='server'>
								</TD>
							</TR>
							<TR><TD class='inputform'>&#xa0;</TD><TD class='whiteRowFill center'>&#xa0;</TD></TR>
							<TR>
								<TD class='inputform'>&#xa0;</TD>
								<TD class='whiteRowFill center'>
									<TABLE id='cableMap1' class='datatable center' runat='server' />
								</TD>
							</TR>
							<TR><TD class='inputform'>&#xa0;</TD><TD class='whiteRowFill center'>&#xa0;</TD></TR>
						</TABLE>
					</TD>
				</TR>
			</TABLE>
			<BR/>
			<INPUT type='submit' value='Save Changes' runat='server'/>&#xa0;<INPUT type='button' value='Cancel &amp; Close' onclick='refreshParent()'/>
		&nbsp;<BR/>
		</DIV>
	</DIV> <!-- End: popContent -->
<!--#include file='popup_closer.inc' -->
	</FORM>
</DIV> <!-- End: container -->
</BODY>
</HTML>