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
void popInfo(Object s, EventArgs e) 
{
	string v_type, sql;
	DataSet dat=new DataSet();
	v_type=formExistType.Value;
	if (v_type=="BladeCenter H")
	{
		Response.Write("<script>window.location.href='newBladeCenter.aspx?redir=1';<"+"/script>");
	}
	if (v_type.StartsWith("P"))
	{
		Response.Write("<script>window.location.href='newPseries.aspx?type="+v_type+"';<"+"/script>");
	}
	if (v_type=="new")
	{
		formHwClass.Value="";
		formHwModel.Value="";
		formHwSerial.Value="";
		formHwRack.Value="";
		formHwBotU.Value="";
		formHwTopU.Value="";
		formHwServer.Value="";
		formHwSanAttach.Value="";

		formHwClass.Attributes.Add("disabled","true");
		formHwModel.Attributes.Add("disabled","true");
		formHwSerial.Attributes.Add("disabled","true");
		formHwRack.Attributes.Add("disabled","true");
		formHwBotU.Attributes.Add("disabled","true");
		formHwTopU.Attributes.Add("disabled","true");
		formHwServer.Attributes.Add("disabled","true");
		formHwSanAttach.Attributes.Add("disabled","true");		
		Response.Write("<script>window.open('newHardwareType.aspx','newHardwareTypeWin','width=400,height=325,menubar=no,status=yes,scrollbars=yes')<"+"/script>");
	}
	else
	{
		formHwClass.Attributes.Remove("disabled");
		formHwModel.Attributes.Remove("disabled");
		formHwSerial.Attributes.Remove("disabled");
		formHwRack.Attributes.Remove("disabled");
		formHwBotU.Attributes.Remove("disabled");
		formHwTopU.Attributes.Remove("disabled");
		formHwServer.Attributes.Remove("disabled");
		formHwSanAttach.Attributes.Remove("disabled");
		formHwClass.Value=v_type;
		sql="SELECT * from hwTypes WHERE hwClassName='"+v_type+"'";
		dat=readDb(sql);
		if (!emptyDataset(dat))
		{
			foreach(DataRow dr in dat.Tables[0].Rows)
			{
				formCheckHi.Value=dr["hwUSize"].ToString();
				if(dr["hwType"].ToString()=="Server" || dr["hwType"].ToString()=="HMC")
				{
					formHwServer.SelectedIndex=formHwServer.Items.IndexOf(formHwServer.Items.FindByValue("0"));
				}
				else
				{
					formHwServer.SelectedIndex=formHwServer.Items.IndexOf(formHwServer.Items.FindByValue("1"));
				}			
			}
		}
		if (v_type=="Catalyst 6509 Switch")
		{
			modelName.InnerHtml="Name:";
		}
		else
		{
			modelName.InnerHtml="Model:";
		}
		sql="SELECT hwType FROM hwTypes WHERE hwClassName='"+v_type+"'";
		dat=readDb(sql);
		if (!emptyDataset(dat))
		{
			formCheckType.Value=dat.Tables[0].Rows[0]["hwType"].ToString();
		}
	}
}

void goSubmit(Object s, EventArgs e)
{
//	Response.Write("goSubmit");
	bool checkStat=true;
	bool sqlSuccess=true;
	string sql;
	DataSet dat=new DataSet();
	string errStr="", sqlErr="";
	string v_rack=fix_txt(formHwRack.Value),v_bc="",v_class=fix_txt(formHwClass.Value);
	string v_serial=fix_txt(formHwSerial.Value),v_model=fix_txt(formHwModel.Value),v_sanAtt=formHwSanAttach.Value;
	string v_topU=fix_txt(formHwTopU.Value), v_botU=fix_txt(formHwBotU.Value),v_belongsTo="",v_slot="",v_reserved=formHwServer.Value;
	int topU=0, botU=0, uDiff=0;
	int checkHi=Convert.ToInt32(formCheckHi.Value);
	string v_username;
	string v_switchName, fixed_switchName;
	errmsg.InnerHtml=errStr;

	try
	{
		v_username=Request.Cookies["username"].Value;
	}
	catch (System.Exception ex)
	{
		v_username="";
	}

	switch (v_topU)
	{
	    case "1":
		formHwTopU.Value="01";
		v_topU="01";
		break;
	    case "2":
		formHwTopU.Value="02";
		v_topU="02";
		break;
	    case "3":
		formHwTopU.Value="03";
		v_topU="03";
		break;
	    case "4":
		formHwTopU.Value="04";
		v_topU="04";
		break;
	    case "5":
		formHwTopU.Value="05";
		v_topU="05";
		break;
	    case "6":
		formHwTopU.Value="06";
		v_topU="06";
		break;
	    case "7":
		formHwTopU.Value="07";
		v_topU="07";
		break;
	    case "8":
		formHwTopU.Value="08";
		v_topU="08";
		break;
	    case "9":
		formHwTopU.Value="09";
		v_topU="09";
		break;
	    case "0":
		formHwTopU.Value="00";
		v_topU="00";
		break;
	}
	switch (v_botU)
	{
	    case "1":
		formHwBotU.Value="01";
		v_botU="01";
		break;
	    case "2":
		formHwBotU.Value="02";
		v_botU="02";
		break;
	    case "3":
		formHwBotU.Value="03";
		v_botU="03";
		break;
	    case "4":
		formHwBotU.Value="04";
		v_botU="04";
		break;
	    case "5":
		formHwBotU.Value="05";
		v_botU="05";
		break;
	    case "6":
		formHwBotU.Value="06";
		v_botU="06";
		break;
	    case "7":
		formHwBotU.Value="07";
		v_botU="07";
		break;
	    case "8":
		formHwBotU.Value="08";
		v_botU="08";
		break;
	    case "9":
		formHwBotU.Value="09";
		v_botU="09";
		break;
	    case "0":
		formHwBotU.Value="00";
		v_botU="00";
		break;
	}

	if (v_topU!="")
	{
		topU=Convert.ToInt32(v_topU);
	}

	if (v_botU!="")
	{
		botU=Convert.ToInt32(v_botU);
	}

	uDiff=topU-botU;
	uDiff++;

	DateTime dateStamp = DateTime.Now;
/*	Response.Write(",checkHi:"+checkHi);
	Response.Write(",v_slot:"+v_slot);
	Response.Write(",v_topU:"+v_topU+","+topU.ToString());
	Response.Write(",v_botU:"+v_botU+","+botU.ToString()+"<BR/>"); */
	if (checkHi!=0 && checkHi!=null && uDiff!=checkHi)
	{
		checkStat=false;
		errStr = "Error - "+v_class+" should occupy "+checkHi.ToString()+"U. ("+uDiff.ToString()+")<BR/>";
		errmsg.InnerHtml=errStr;
	}
	else
	{
		v_slot=v_botU+"-"+v_topU;
//		Response.Write(v_slot);
	}
	if (formCheckType.Value==null || formCheckType.Value=="")
	{
		sql="SELECT hwType FROM hwTypes WHERE hwClassName='"+v_class+"'";
		dat=readDb(sql);
		if (!emptyDataset(dat))
		{
			formCheckType.Value=dat.Tables[0].Rows[0]["hwType"].ToString();
			Response.Write(formCheckType.Value.ToString());
		}
	}
	if (v_rack!="" && v_slot!="" )
	{
		sql = "SELECT * FROM rackspace WHERE rack='"+v_rack+"' AND slot LIKE '%"+v_slot.Substring(0,2)+"%'";
		dat=readDb(sql);
		if (!emptyDataset(dat))
		{
			checkStat=false;
			errmsg.InnerHtml="Device already present in Rack "+v_rack+", Slot "+v_slot+" (BC"+v_bc+"): "+dat.Tables[0].Rows[0]["class"].ToString()+" ("+dat.Tables[0].Rows[0]["rackspaceId"].ToString()+")";
		}
	}

	if (checkStat && v_rack!=null && v_rack!="" && v_class!=null && v_class!="" && v_serial!=null && v_serial!="" && v_model!=null && v_model!="" && v_slot!=null && v_slot!="")
	{
//		v_reserved="1";
		sql = "INSERT INTO rackspace(rack,bc,slot,reserved,class,serial,model,sanAttached) VALUES("
						+"'" +v_rack+ "',"
						+"'" +v_bc+ "',"
						+"'" +v_slot+ "',"
						+"'" +v_reserved+ "',"
						+"'" +v_class+ "',"
						+"'" +v_serial+ "',"
						+"'" +v_model+ "',"
						+"'" +v_sanAtt+   "')";
//		Response.Write(sql);
		sqlErr=writeDb(sql);
		if (sqlErr!=null && sqlErr!="")
		{
			sqlSuccess=false;
			errmsg.InnerHtml = "SQL Update Error - Hardware-"+v_class+"<BR/>"+sqlErr;
		}
		else
		{
			
			sqlErr="";
		}
		if (sqlSuccess) 
		{
			string statString=v_class+" in Rack "+v_rack+", "+v_slot+" created.";
			sqlErr=writeChangeLog(dateStamp.ToString(), Decrypt(v_username.ToString()), statString.ToString());
			if (sqlErr!=null && sqlErr!="")
			{
				sqlSuccess=false;
				errmsg.InnerHtml = "ChangeLog Update Error - Rackspace<BR/>"+sqlErr;
			}
			else
			{
				if (formCheckType.Value=="Switch")
				{
					sql="SELECT rackspaceId FROM rackspace WHERE model='"+v_model+"'";
					dat=readDb(sql);
					string rackId="";
					if (!emptyDataset(dat))
					{
						rackId=dat.Tables[0].Rows[0]["rackspaceId"].ToString();
					}
					if (rackId!="")
					{
						v_switchName=removeSpaces(v_model);
						fixed_switchName=v_switchName.Substring(0,1).ToLower()+v_switchName.Substring(1,v_switchName.Length);
						sql="INSERT INTO switches(switchName, description, rackspaceId) VALUES('"+fixed_switchName+"','"+v_model+"','"+rackId+"')";
						Response.Write(sql);
						sqlErr=writeDb(sql);
						bool sqlSuccess2=true;
						if (sqlErr!=null && sqlErr!="")
						{
							sqlSuccess2=false;
							errmsg.InnerHtml = "SQL Update Error - Switch Hardware<BR/>"+sqlErr;
						}
						else
						{
			
							sqlErr="";
						}
						if (sqlSuccess2)
						{
							sqlErr=writeChangeLog(dateStamp.ToString(), Decrypt(v_username.ToString()), "Switch Table change for "+statString);
							if (sqlErr!=null && sqlErr!="")
							{
								sqlSuccess=false;
								errmsg.InnerHtml = "ChangeLog Update Error - Switch Hardware<BR/>"+sqlErr;
							}
						}
					}
					
				}
				sqlErr="";
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
	else 
	{
		if (v_class == "") formHwClass.Style ["background"]="yellow";
		if (v_model == "") formHwModel.Style ["background"]="yellow";
		if (v_serial == "") formHwSerial.Style ["background"]="yellow";
		if (v_rack == "") formHwRack.Style ["background"]="yellow";
		if (v_slot == "") formHwBotU.Style ["background"]="yellow";
		if (v_slot == "") formHwTopU.Style ["background"]="yellow";
		errStr = errStr+"Please enter valid data in all required fields!<BR/>";
	}
}

public void Page_Load(Object o, EventArgs e)
{
//UNCOMMENT this line to force login to access this page.
	lockout(); Page.Header.Title=shortSysName+": Add New Switch";
	systemStatus(1); // Check to see if admin has put system is in offline mode.

	string sql;
	DataSet dat, hwdd, racksdd;
	HttpCookie cookie;
	bool sqlSuccess=true, permitted=false;
	string editHw="";
	string v_username, v_userclass="", v_userrole="", mode="";

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

	try
	{
		mode=Request.QueryString["req"].ToString();
	}
	catch (System.Exception ex)
	{
		mode = "";
	}

	if (System.Text.RegularExpressions.Regex.IsMatch(v_userrole, "datacenter", System.Text.RegularExpressions.RegexOptions.IgnoreCase))
	{
		permitted=true;
	}

	if (!permitted)
	{
		Response.Write("<script>window.location.href='noAccess.aspx?referrer=newHardware';<"+"/script>");
	}

	if (!IsPostBack)
	{
		sql="SELECT * FROM hwTypes WHERE hwType NOT IN ('Blade','Virtual') ORDER BY hwClassName ASC";
		hwdd=readDb(sql);
		if (hwdd!=null)
		{
			foreach(DataRow dr in hwdd.Tables[0].Rows)
			{
				ListItem li = new ListItem(dr["hwClassName"].ToString(), dr["hwClassName"].ToString());
				formExistType.Items.Add(li);
			}
		}

		if (mode=="Switch")
		{
			sql="SELECT * FROM hwTypes WHERE hwType IN ('Switch','Router') ORDER BY hwType ASC, hwClassName ASC";
			hwdd=readDb(sql);
			if (hwdd!=null)
			{
				foreach(DataRow dr in hwdd.Tables[0].Rows)
				{
					ListItem li = new ListItem(dr["hwClassName"].ToString(), dr["hwClassName"].ToString());
					formExistType.Items.Add(li);
				}
			}
		}

		sql="SELECT rackId FROM racks ORDER BY rackId ASC";
		racksdd=readDb(sql);
		if (racksdd!=null)
		{
			foreach(DataRow dr in racksdd.Tables[0].Rows)
			{
				ListItem li = new ListItem(dr["rackId"].ToString(), dr["rackId"].ToString());
				formHwRack.Items.Add(li);
			}
		}
		modelName.InnerHtml="Model:";
		formHwClass.Attributes.Add("disabled","disabled");
		formHwModel.Attributes.Add("disabled","disabled");
		formHwSerial.Attributes.Add("disabled","disabled");
		formHwRack.Attributes.Add("disabled","disabled");
		formHwBotU.Attributes.Add("disabled","disabled");
		formHwTopU.Attributes.Add("disabled","disabled");
		formHwServer.Attributes.Add("disabled","disabled");
		formHwSanAttach.Attributes.Add("disabled","disabled");
	}

	if (IsPostBack)
	{
	}
	titleSpan.InnerHtml="Add New Hardware";
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
				<SELECT id='formExistType' runat='server'>
					<OPTION value='new' selected='true'>Add New Type ...</OPTION>
				</SELECT>
				<INPUT type='button' id='populateButton' value='Populate' OnServerClick='popInfo' runat='server'/>
				<BR/><BR/>
				<TABLE class='datatable center'>
					<TR>
						<TD class='center'>
							<TABLE>
								<TR>
									<TD class='inputform'>&#xa0;</TD>
									<TD class='whiteRowFill left'>
										<INPUT type='hidden' id='formCheckHi' runat='server' />
									</TD>
								</TR>
								<TR>
									<TD class='inputform'>Type/Class:</TD>
									<TD class='whiteRowFill left'>
										<INPUT type='text' id='formHwClass' runat='server' />
									</TD>
								</TR>
								<TR>
									<TD class='inputform'><SPAN id='modelName' runat='server'/></TD>
									<TD class='whiteRowFill left'>
										<INPUT type='text' id='formHwModel' runat='server' />
									</TD>
								</TR>
								<TR>
									<TD class='inputform'>Serial:</TD>
									<TD class='whiteRowFill left'>
										<INPUT type='text' id='formHwSerial' runat='server' />
									</TD>
								</TR>
								<TR>
									<TD class='inputform'>&#xa0;</TD>
									<TD class='whiteRowFill left'>
										<INPUT type='hidden' id='popStat' runat='server' />
									</TD>
								</TR>
								<TR>
									<TD class='inputform'>Rack:</TD>
									<TD class='whiteRowFill left'>
										<SELECT id='formHwRack' runat='server' />
									</TD>
								</TR>
								<TR>
									<TD class='inputform'>Bottom 'U':</TD>
									<TD class='whiteRowFill left'>
										<INPUT type='text' id='formHwBotU' runat='server' />
									</TD>
								</TR>
								<TR>
									<TD class='inputform'>Top 'U':</TD>
									<TD class='whiteRowFill left'>
										<INPUT type='text' id='formHwTopU' runat='server' />
									</TD>
								</TR>
								<TR><TD class='inputform'>&#xa0;</TD><TD class='whiteRowFill left'>&#xa0;</TD></TR> 
								<TR>
									<TD class='inputform'>Server?:</TD>
									<TD class='whiteRowFill left'>
										<SELECT id='formHwServer' runat='server'>
											<OPTION value='1' >No</OPTION>
											<OPTION value='0' selected='true'>Yes</OPTION>
										</SELECT>
									</TD>
								</TR>
								<TR>
									<TD class='inputform'>SAN Attached?:</TD>
									<TD class='whiteRowFill left'>
										<SELECT id='formHwSanAttach' runat='server'>
											<OPTION value='0' selected='true'>No</OPTION>
											<OPTION value='1'>Yes</OPTION>
										</SELECT>
									</TD>
								</TR>
								<TR>
									<TD class='inputform'>&#xa0;</TD>
									<TD class='whiteRowFill left'>
										<INPUT type='hidden' id='formCheckType' runat='server' />
									</TD>
								</TR>
							</TABLE>
						</TD>
					</TR>
				</TABLE><BR/>
				<INPUT type='button' id='submitButton' value='Save Changes' OnServerClick='goSubmit' runat='server' />&#xa0;<INPUT type='button' value='Cancel &amp; Close' onclick='refreshParent()' />
			</DIV>
		&nbsp;<BR/>
		</DIV>
	</DIV> <!-- End: popContent -->
<!--#include file='popup_closer.inc' -->
	</FORM>
</DIV> <!-- End: container -->
</BODY>
</HTML>