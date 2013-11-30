<%@Page Inherits="CIS.conspectisLibrary" src="conspectisLibrary.cs" Language="C#" debug="true" %>
<%@Import Namespace="System.Data.OleDb"%>
<%@Import Namespace="System.Data"%>
<%@Import Namespace="System"%>

<!DOCTYPE html>
<!-- HTML5 Status: VALID 2-11-13 CK -->
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
	lockout(); Page.Header.Title=shortSysName+": Edit Server";
	systemStatus(1); // Check to see if admin has put system is in offline mode.

	string sql,sql1,sql2,sqlSwitch;
	DataSet dat,dat1,dat2=null,datSwitch;
	string v_username, sqlErr="", v_userrole, buttonstring="";
	string srcHost="",dcPrefix="";
	DateTime dateStamp = DateTime.Now;
	bool nameChanged=false, pubIpChanged=false, svcIpChanged=false;
	bool nameOk=false, pubIpOk=false, svcIpOk=false;
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

	if (dcPrefix!="")
	{
		titleSpan.InnerHtml=dcPrefix.ToUpper().Replace("_","");
	}

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
	sql="SELECT * FROM "+dcPrefix+"subnets WHERE [desc] NOT LIKE '%Service%'";
	dat=readDb(sql);
	if (!emptyDataset(dat))
	{
		foreach(DataRow dr in dat.Tables[0].Rows)
		{
			ListItem li = new ListItem(dr["desc"].ToString(), dr["name"].ToString());
			formPubVlan.Items.Add(li);
		}
	}

	string v_serverName = fix_txt(formSvrName.Value);
	string v_os=formSvrOs.Value;

	string v_purpose = fix_txt(formSvrPurpose.Value);
	string v_svrClass = fix_txt(formSvrClass.Value);
	string v_svrModel = fix_txt(formSvrModel.Value);
	string v_svrSerial = fix_txt(formSvrSerial.Value);
	string v_svrRack = fix_txt(formSvrRack.Value);
	string v_svrBc = fix_txt(formSvrBc.Value);
	string v_svrSlot = fix_txt(formSvrSlot.Value);
	string v_pubIp = fix_txt(formPubIp.Value);
	string v_svcIp = fix_txt(formSvcIp.Value);
	string v_rsaIp = fix_txt(formMgtIp.Value);
	string v_svrSAN = "0";
	string v_usingSAN = "0";
	if(formSvrSAN.Checked)
	{
		v_svrSAN = "1";
	}
	if(formUsingSAN.Checked)
	{
		v_usingSAN = "1";
	}
	bool sqlSuccess=false;

	if(!IsPostBack)
	{
		sql="SELECT * FROM "+dcPrefix+"servers INNER JOIN "+dcPrefix+"rackspace ON "+dcPrefix+"servers.rackspaceId="+dcPrefix+"rackspace.rackspaceId WHERE serverName='"+srcHost+"'";
		dat=readDb(sql);
	
		if (!emptyDataset(dat))
		{
			formSvrName.Value=srcHost;
			formSvrOs.Value=dat.Tables[0].Rows[0]["serverOS"].ToString();
			v_os=dat.Tables[0].Rows[0]["serverOS"].ToString();
			formPubVlan.Value=dat.Tables[0].Rows[0]["serverPubVlan"].ToString();
			formSvrPurpose.Value=dat.Tables[0].Rows[0]["serverPurpose"].ToString();
			formSvrClass.Value=dat.Tables[0].Rows[0]["class"].ToString();
			formSvrModel.Value=dat.Tables[0].Rows[0]["model"].ToString();
			formSvrSerial.Value=dat.Tables[0].Rows[0]["serial"].ToString();
			
			string sqlRack="", rackString="";
			DataSet datRack=new DataSet();
			sqlRack="SELECT location, rackId FROM "+dcPrefix+"racks WHERE rackId='"+dat.Tables[0].Rows[0]["rack"].ToString()+"'";
//			Response.Write(sqlRack+"<BR/>");
			datRack=readDb(sqlRack);
			if (datRack!=null)
			{
				try
				{
					rackString=datRack.Tables[0].Rows[0]["location"].ToString()+"-R"+datRack.Tables[0].Rows[0]["rackId"].ToString().Substring(0,2)+"-C"+datRack.Tables[0].Rows[0]["rackId"].ToString().Substring(2,2)+" ("+dcPrefix.ToUpper().Replace("_","")+")";
				}
				catch (System.Exception ex)
				{
					rackString="ERR";
				}
			}
			formSvrRack.Value=rackString;
			
			formSvrBc.Value=dat.Tables[0].Rows[0]["bc"].ToString();
			formSvrSlot.Value=dat.Tables[0].Rows[0]["slot"].ToString();
			formPubIp.Value=fix_ip(fix_ip(dat.Tables[0].Rows[0]["serverLanIp"].ToString()));
			formSvcIp.Value=fix_ip(dat.Tables[0].Rows[0]["serverSvcIp"].ToString());
			formMgtIp.Value=fix_ip(dat.Tables[0].Rows[0]["serverRsaIp"].ToString());
			specString=dat.Tables[0].Rows[0]["cpu_type"].ToString()+" "+dat.Tables[0].Rows[0]["cpu_qty"].ToString()+"x"+dat.Tables[0].Rows[0]["cpu_cores"].ToString()+", "+dat.Tables[0].Rows[0]["ram"].ToString()+"Gb RAM, "+dat.Tables[0].Rows[0]["sys_disk_qty"].ToString()+"x"+dat.Tables[0].Rows[0]["sys_disk_size"].ToString()+"Gb";
			if (dat.Tables[0].Rows[0]["data_disk_qty"].ToString()!="" && dat.Tables[0].Rows[0]["data_disk_size"].ToString()!="")
			{
				specString=specString+", "+dat.Tables[0].Rows[0]["data_disk_qty"].ToString()+"x"+dat.Tables[0].Rows[0]["data_disk_size"].ToString()+"Gb";
			}
			hw_spec.InnerHtml=specString;
			if (dat.Tables[0].Rows[0]["sanAttached"].ToString() == "1")
			{
				formSvrSAN.Checked=true;
			}
			if (dat.Tables[0].Rows[0]["usingSAN"].ToString() == "1")
			{
				formUsingSAN.Checked=true;
			}
			v_svrModel=formSvrModel.Value;

			try
			{
				int rackspace=Convert.ToInt32(dat.Tables[0].Rows[0]["rack"].ToString());
			}
			catch (System.Exception ex)
			{
			}

			dat2=getPorts(dat.Tables[0].Rows[0]["rackspaceId"].ToString(),dcPrefix);
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
						td.Attributes.Add("style","width:90px;");
					tr.Cells.Add(td);         //Output </TD>
				cableMap1.Rows.Add(tr);           //Output </TR>
			}
			if (v_userrole.Contains("datacenter"))
			{
				buttonstring="<INPUT type='image' src='./img/cablingbar.png' onclick=\"window.open('editCabling.aspx?id="+dat.Tables[0].Rows[0]["rackspaceId"].ToString()+"&dc="+dcPrefix+"','editCablingWin','width=400,height=800,menubar=no,status=yes')\" ALT='Edit Cabling' />";
				
			}
//			Response.Write(v_os+"<BR/>");
			if (v_os!="RSA2")
			{
				buttonstring=buttonstring+"&#xa0; <INPUT type='image' src='./img/dependencybutton.png' onclick=\"window.open('editDependency.aspx?id="+dat.Tables[0].Rows[0]["rackspaceId"].ToString()+"&dc="+dcPrefix+"','editDependencyWin','width=400,height=350,menubar=no,status=yes')\" ALT='Edit Dependency' />";
			}

			cablebutton.InnerHtml=buttonstring;
		}

//		formSvrName.Attributes.Add("disabled","disabled");
		formPubIp.Attributes.Add("disabled","disabled");
//		formSvrOs.Attributes.Add("disabled","disabled");
		formPubVlan.Attributes.Add("disabled","disabled");

//		v_serverName = dat.Tables[0].Rows[0]["serverName"].ToString();
//		v_pubIp = fix_ip(dat.Tables[0].Rows[0]["serverLanIp"].ToString());
	}

	if (IsPostBack)
	{
		string errStr="";

	
		formSvrName.Style ["background"]="White";
		formSvrOs.Style ["background"]="White";
		formSvrPurpose.Style ["background"]="White";
		formSvrClass.Style ["background"]="White";
		formSvrModel.Style ["background"]="White";
		formSvrSerial.Style["background"]="White";
		formSvrRack.Style["background"]="White";
		formSvrBc.Style["background"]="White";
		formSvrSlot.Style ["background"]="White";
		formPubIp.Style ["background"]="White";
		formSvcIp.Style ["background"]="White";
		formMgtIp.Style["background"]="White";
		errmsg.InnerHtml = "";
	 


		if (v_serverName!="" && v_os!="")
		{	
			sql = "UPDATE "+dcPrefix+"servers SET serverPurpose='"+v_purpose+    "',"
				  		+"usingSAN='"     +v_usingSAN+    "',"
						+"serverSvcIp='"  +v_svcIp+      "' WHERE serverName='"+srcHost+"'";
			errmsg.InnerHtml = sql;
			sqlErr=writeDb(sql);
			if (sqlErr==null || sqlErr=="")
			{
				errStr = "Server Record Updated.";
				sqlSuccess=true;
			}
			else
			{
				errmsg.InnerHtml = errStr+" SQL Update Error - Server  - "+sqlErr;
				sqlErr="";
			}

			if (sqlSuccess) 
			{
				sqlErr=writeChangeLog(dateStamp.ToString(), Decrypt(v_username.ToString()), sql2txt(sql).ToString());
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
		else
		{
			errStr = "Error! - ";
			if (v_serverName == "")
			{
				errStr = errStr+" 'serverName'";
			}
			if (v_os == "")
			{
				errStr = errStr+" 'serverOs'";
			}
			errmsg.InnerHtml = errStr+" blank!";
		}
	} //if IsPostBack */

	titleSpan.InnerHtml="Edit Server";
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
		</DIV><BR/>
		<DIV class='center paleColorFill'>
		&nbsp;<BR/>
			<DIV class='center'>
				<TABLE border='1' class='datatable center' >
				<TR><TD class='center'>
					<TABLE>
						<TR>
							<TD class='inputform'>&#xa0;</TD>
							<TD class='whiteRowFill'>&#xa0;</TD>
						</TR>
						<TR>
							<TD class='inputform'>
								<SPAN class='bold'>Host Name:&#xa0;</SPAN>
							</TD>
							<TD class='whiteRowFill'>
								<INPUT type='text' id='formSvrName' onchange='nameChanged=true;' size='35' runat='server' disabled='disabled' />
							</TD>
						</TR>
						<TR>
							<TD class='inputform'>
								<SPAN class='bold'>OS:&#xa0;</SPAN>
							</TD>
							<TD class='whiteRowFill'>
								<SELECT id='formSvrOs' style='width:205px;' runat='server' disabled='disabled' ></SELECT>
							</TD>
						</TR>
						<TR>
							<TD class='inputform'>
								<SPAN class='bold'>Purpose:&#xa0;</SPAN>
							</TD>
							<TD class='whiteRowFill'>
								<INPUT type='text' id='formSvrPurpose' size='35' runat='server' />
							</TD>
						</TR>
						<TR>
							<TD class='inputform'>
								<SPAN class='bold'>Server Class:&#xa0;</SPAN>
							</TD>
							<TD class='whiteRowFill'>
								<SELECT id='formSvrClass' style='width:205px;' runat='server' disabled='disabled'></SELECT>
							</TD>
						</TR>
						<TR>
							<TD class='inputform'>
								<SPAN class='bold'>Server Model:&#xa0;</SPAN>
							</TD>
							<TD class='whiteRowFill'>
								<INPUT type='text' id='formSvrModel' size='35' runat='server' disabled='disabled' />
							</TD>
						</TR>
						<TR>
							<TD class='inputform'>
								<SPAN class='bold'>Server Serial:&#xa0;</SPAN>
							</TD>
							<TD class='whiteRowFill'>
								<INPUT type='text' id='formSvrSerial' size='35' runat='server'  disabled='disabled' />
							</TD>
						</TR>
						<TR>
							<TD class='inputform'>
								<SPAN class='bold'>Cabinet:&#xa0;</SPAN>
							</TD>
							<TD class='whiteRowFill'>
								<INPUT type='text' id='formSvrRack' size='35' runat='server' disabled='disabled' />
							</TD>
						</TR>
						<TR>
							<TD class='inputform'>
								<SPAN class='bold'>BC:&#xa0;</SPAN>
							</TD>
							<TD class='whiteRowFill'>
								<INPUT type='text' id='formSvrBc' size='35' runat='server' disabled='disabled' />
							</TD>
						</TR>
						<TR>
							<TD class='inputform'>
								<SPAN class='bold'>Slot:&#xa0;</SPAN>
							</TD>
							<TD class='whiteRowFill'>
								<INPUT type='text' id='formSvrSlot' size='35' runat='server' disabled='disabled' />
							</TD>
						</TR>
						<TR>
							<TD class='inputform'>
								<SPAN class='bold'>Public VLAN:&#xa0;</SPAN>
							</TD>
							<TD class='whiteRowFill'>
								<SELECT id='formPubVlan' style='width:205px;' runat='server'></SELECT>
							</TD>
						</TR>
						<TR>
							<TD class='inputform'>&#xa0;</TD>
							<TD class='whiteRowFill'>&#xa0;</TD>
						</TR>
						<TR>
							<TD class='inputform'>
								<SPAN class='bold'>SAN Attached:&#xa0;</SPAN>
							</TD>
							<TD class='whiteRowFill left'>
								<INPUT type='checkbox' class='left middle' id='formSvrSAN' runat='server' />
							</TD>
						</TR>
						<TR>
							<TD class='inputform'>
								<SPAN class='bold'>Using SAN:&#xa0;</SPAN>
							</TD>
							<TD class='whiteRowFill left'>
								<INPUT type='checkbox' class='left middle' id='formUsingSAN' runat='server' />
							</TD>
						</TR>
						<TR>
							<TD class='inputform'>&#xa0;</TD>
							<TD class='whiteRowFill'>&#xa0;</TD>
						</TR>
<!--					<TR>
							<TD class='inputform'>&#xa0;</TD>
							<TD class='whiteRowFill center'>
								<IMG src='./img/dnArrow.png'>
								<INPUT type='image' src='./img/provIp.png' runat='server' />
								<IMG src='./img/dnArrow.png'>
							</TD>
						</TR> -->
						<TR>
							<TD class='inputform'>&#xa0;</TD>
							<TD class='whiteRowFill'>&#xa0;</TD>
						</TR>
						<TR>
							<TD class='inputform'>
								<SPAN class='bold'>Public IP:&#xa0;</SPAN>
							</TD>
							<TD class='whiteRowFill'>
								<INPUT type='text' id='formPubIp' onchange='pubIpChanged=true;' size='35' runat='server' />
							</TD>
						</TR>
						<TR>
							<TD class='inputform'>
								<SPAN class='bold'>Service IP:&#xa0;</SPAN>
							</TD>
							<TD class='whiteRowFill'>
								<INPUT type='text' id='formSvcIp' onchange='svcIpChanged=true;' size='35' runat='server' />
							</TD>
						</TR>
						<TR>
							<TD class='inputform'>
								<SPAN class='bold'>Mgt IP: (RSA/MM)&#xa0;</SPAN>
							</TD>
							<TD class='whiteRowFill'>
								<INPUT type='text' id='formMgtIp' size='35' runat='server' disabled='disabled' />
							</TD>
						</TR>
						<TR>
							<TD class='inputform'>&#xa0;</TD>
							<TD class='whiteRowFill'>&#xa0;</TD>
						</TR>
						<TR>
							<TD class='inputform'>&#xa0;</TD>
							<TD class='whiteRowFill center'>
								<TABLE id='cableMap1' class='datatable center' runat='server'></TABLE>
								<BR/>
							</TD>
						</TR>
						<TR>
							<TD class='inputform'>&#xa0;</TD>
							<TD class='whiteRowFill center'>
								<DIV id='cablebutton' runat='server'/>
							</TD>
						</TR>
						<TR>
							<TD class='inputform'>&#xa0;</TD>
							<TD class='whiteRowFill'>&#xa0;</TD>
						</TR>
					</TABLE>
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