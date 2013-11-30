<%@Page Inherits="ESMS.esmsLibrary" src="esmsLibrary.cs" Language="C#" debug="true" AutoEventWireup="True" EnableEventValidation="false" %>
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
protected void formPubVlan_SelectedIndexChanged(object sender, EventArgs e)
{
	string sql, vlan="";
	DataSet dat=new DataSet();
	vlan=formPubVlan.SelectedValue;
	sql="SELECT ipAddr FROM (SELECT * FROM "+vlan+" LEFT JOIN servers ON servers.serverLanIp="+vlan+".ipAddr WHERE servers.serverLanIp is Null) WHERE reserved=0";
	dat=readDb(sql);
	formPubIp.DataSource = dat;
	formPubIp.DataTextField = "ipAddr";
	formPubIp.DataValueField = "ipAddr";
	formPubIp.DataBind();
}

public void Page_Load(Object o, EventArgs e)
{
//UNCOMMENT this line to force login to access this page.
	lockout(); Page.Header.Title=shortSysName+": Add new VIP / Virtual Server / CNAME";
	systemStatus(1); // Check to see if admin has put system is in offline mode.



	string sql;
	DataSet dat=new DataSet();
	string v_username, sqlErr="", errstr="";
	string v_serverName, v_vlan, v_purpose, v_pubIp;
	bool sqlSuccess=false, sendSuccess=true;
	DateTime dateStamp = DateTime.Now;
	string v_userclass="", v_userrole="";

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

	string dcArg="";
	try
	{
		dcArg=Request.QueryString["dc"].ToString();
	}
	catch (System.Exception ex)
	{
		dcArg= "";
	}

	if (v_userclass!="99" && v_userclass!="3")
	{
		Response.Write("<script language='javascript'>refreshParent();//-->"+"<"+"/script>");
	}
	
	titleSpan.InnerHtml=dcArg.ToUpper().Replace("_","");

	if (!IsPostBack)
	{
		sql = "SELECT * FROM "+dcArg+"subnets WHERE [desc] NOT LIKE '%Service%' ORDER BY [desc] ASC";
		dat = readDb(sql);
		if (!emptyDataset(dat))
		{
			foreach(DataRow dr in dat.Tables[0].Rows)
			{
				ListItem li = new ListItem(dr["desc"].ToString(), dr["name"].ToString());
				formPubVlan.Items.Add(li);
			}
		}
		sql="SELECT ipAddr FROM (SELECT * FROM "+dcArg+"subnetPheRes132 LEFT JOIN "+dcArg+"servers ON "+dcArg+"servers.serverLanIp="+dcArg+"subnetPheRes132.ipAddr WHERE "+dcArg+"servers.serverLanIp is Null) AS a WHERE reserved=0";
		dat=readDb(sql);
		formPubIp.DataSource = dat;
		formPubIp.DataTextField = "ipAddr";
		formPubIp.DataValueField = "ipAddr";
		formPubIp.DataBind();
 	}

	if (IsPostBack)
	{
		formSvrName.Style ["background"]="White";
		formSvrPurpose.Style ["background"]="White";
//		formPubIp.Style ["background"]="White";
		errmsg.InnerHtml = "";

		v_serverName = fix_hostname(fix_txt(formSvrName.Value)).ToUpper();	 	 
		v_pubIp = fix_txt(formPubIp.SelectedValue);
		v_purpose = fix_txt(formSvrPurpose.Value);
		v_vlan="";



		v_vlan=formPubVlan.SelectedValue;

		sql = "SELECT serverName FROM "+dcArg+"servers WHERE serverName='" +v_serverName+ "'";
		dat=readDb(sql);
		if (emptyDataset(dat))
		{
			if (v_serverName!="" && v_vlan!="" && v_pubIp!="")
			{	
				sql = "INSERT INTO "+dcArg+"servers(serverName,serverLanIp,serverOS,serverPurpose,serverPubVlan) VALUES("
								+"'" +v_serverName+ "',"
								+"'" +v_pubIp+		"',"
								+"'Network',"
								+"'" +v_purpose+    "',"
								+"'" +v_vlan+       "')";

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
						sqlErr=createTicket("0",v_serverName,"0",dateStamp.ToString(),"datacenter",v_username,"Server Creation","","0","3");
						if (sqlErr=="" || sqlErr==null)
						{
//							Response.Write("<script>window.close("+");<"+"/script>");
						}
						else
						{
							errmsg.InnerHtml=sqlErr;
						}
						sqlErr=createTicket("0",v_serverName,"0",dateStamp.ToString(),"dns",v_username,"VIP Assignment Request","","0","3");
						if (sqlErr=="" || sqlErr==null)
						{
//							Response.Write("<script>window.close("+");<"+"/script>");
						}
						else
						{
							errmsg.InnerHtml=sqlErr;
						}						
						sqlErr=writeChangeLog(dateStamp.ToString(), Decrypt(v_username.ToString()), "VIP Created:"+v_serverName);
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
				if (v_pubIp == "") formPubIp.Style ["background"]="yellow";
				if (v_vlan == "") formPubVlan.Style ["background"]="yellow";
				string errStr = "Please enter valid data in all required fields!";
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
	
	titleSpan.InnerHtml="New Virtual IP";
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
				<DIV id='hostname' class='bold' runat='server'/><BR/>
					<TABLE class='datatable center'>
						<TR>
							<TD class='center'>
								<TABLE>
									<TR>
										<TD class='inputform bold'>Public VLAN:&#xa0;</TD>
										<TD class='whiteRowFill left'>
											<ASP:DropDownList id='formPubVlan' style='width:131px;' runat='server' OnSelectedIndexChanged='formPubVlan_SelectedIndexChanged' AutoPostBack='true' />
										</TD>
									</TR>
									<TR>
										<TD class='inputform bold'>Host Name:&#xa0;</TD>
										<TD class='whiteRowFill left'>
											<INPUT type='text' id='formSvrName' runat='server' />
										</TD>
									</TR>
									<TR>
										<TD class='inputform bold'>Public IP:&#xa0;</TD>
										<TD class='whiteRowFill left'>
											<ASP:DropDownList id='formPubIp' style='width:131px;' AutoPostBack='true' runat='server'/>
										</TD>
									</TR>
									<TR>
										<TD class='inputform bold'>Purpose:&#xa0;</TD>
										<TD class='whiteRowFill left'>
											<INPUT type='text' id='formSvrPurpose' runat='server' />
										</TD>
									</TR>
									<TR><TD class='inputform'>&#xa0;</TD><TD class='whiteRowFill left'>&#xa0;</TD></TR>
									<TR>
										<TD class='inputform'>&#xa0;</TD>
										<TD class='whiteRowFill center'>
											<TABLE id='cableMap1' class='datatable' runat='server' />
											<BR/>
											<TABLE id='cableMap2' class='datatable' runat='server' />
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