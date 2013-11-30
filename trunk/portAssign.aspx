<%@Page Inherits="ESMS.esmsLibrary" src="esmsLibrary.cs" Language="C#" debug="true" AutoEventWireup="True"%>
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
void ixconn_button(Object s, EventArgs e) 
{
	DataSet dat = new DataSet();
	string sql="", dcPrefix="";

	try
	{
		dcPrefix=Request.QueryString["dc"].ToString();
	}
	catch (System.Exception ex)
	{
		dcPrefix="";
	}

	destDropDown1.Items.Clear();
	status.InnerHtml="<SPAN class='bold'>Connection Type:</SPAN> Interconnect";
	ixConnButton.Disabled=true;
	serverButton.Disabled=false;
	destDropDown1.Disabled=false;
	destDropDown2.Disabled=false;
	destPortName.Disabled=true;
	destTitle1.InnerHtml="Switch: &#xa0;";
	destTitle2.InnerHtml="Slot / Port: &#xa0;";
	destTitle3.InnerHtml="";

	sql="SELECT description,switchName FROM "+dcPrefix+"switches ORDER BY switchName ASC";
	dat=readDb(sql);
	if (!emptyDataset(dat))
	{
		foreach(DataRow dr in dat.Tables[0].Rows)
		{
			ListItem li = new ListItem(dr["description"].ToString(), dr["switchName"].ToString());
			destDropDown1.Items.Add(li);
		}
	}
	goStat.Value="ixconn";
	
}

void server_button(Object s, EventArgs e) 
{
	DataSet dat = new DataSet();
	string sql="", dcPrefix="";

	try
	{
		dcPrefix=Request.QueryString["dc"].ToString();
	}
	catch (System.Exception ex)
	{
		dcPrefix="";
	}

	destDropDown1.Items.Clear();
	status.InnerHtml="<SPAN class='bold'>Connection Type:</SPAN> Server";
	serverButton.Disabled=true;
	ixConnButton.Disabled=false;
	destDropDown1.Disabled=false;
	destDropDown2.Disabled=false;
	destPortName.Disabled=false;
	destTitle1.InnerHtml="Rack: &#xa0;";
	destTitle2.InnerHtml="Location (Server): &#xa0;";
	destTitle3.InnerHtml="Server Port: &#xa0;";

	sql="SELECT rackId FROM "+dcPrefix+"racks ORDER BY rackId ASC";
	dat=readDb(sql);
	if (!emptyDataset(dat))
	{
		foreach(DataRow dr in dat.Tables[0].Rows)
		{
			ListItem li = new ListItem("Rack "+dr["rackId"].ToString(), dr["rackId"].ToString());
			destDropDown1.Items.Add(li);
		}
	}
	goStat.Value="server";
}

void go_button(Object s, EventArgs e) 
{
	DataSet dat = new DataSet();
	string sql="", scope="", arg1="", desc="", dcPrefix="";

	try
	{
		dcPrefix=Request.QueryString["dc"].ToString();
	}
	catch (System.Exception ex)
	{
		dcPrefix="";
	}

	destDropDown1.Disabled=false;
	destDropDown2.Disabled=false;

	scope=goStat.Value;
	arg1=destDropDown1.Value;

	if (scope=="ixconn")
	{
		sql="SELECT * FROM "+arg1+" WHERE cabledTo IS NULL AND comment IS NULL ORDER BY portId ASC";
		dat=readDb(sql);
		if (!emptyDataset(dat))
		{
			foreach(DataRow dr in dat.Tables[0].Rows)
			{
				ListItem li = new ListItem("Slot "+dr["slot"].ToString()+", Port "+dr["portNum"].ToString(), dr["portId"].ToString());
				destDropDown2.Items.Add(li);
			} 
		}
	}
	if (scope=="server")
	{
		sql="SELECT * FROM (SELECT * FROM "+dcPrefix+"rackspace WHERE rack='"+arg1+"' AND slot<>'00') AS a WHERE bc IS NOT NULL AND model<>'ESX' AND reserved<>'1' ORDER BY bc ASC, slot ASC";
		dat=readDb(sql);
		if (!emptyDataset(dat))
		{
			foreach(DataRow dr in dat.Tables[0].Rows)
			{
				if (dr["bc"].ToString()!="")
				{
					desc=dr["rack"].ToString()+" - BC: "+dr["bc"].ToString()+", Slot: "+dr["slot"].ToString();
				}
				else
				{
					desc=dr["rack"].ToString()+" - U: "+dr["slot"].ToString();
				}
				ListItem li = new ListItem(desc, dr["rackspaceId"].ToString());
				destDropDown2.Items.Add(li);
			} 
		}
	}
}

void goSubmit(Object s, EventArgs e) 
{
	string scope="";
	string sql="", sql1="", sqlErr="", logErr="";
	string srcSwitch="", srcPrt="", srcRackId="", srcComment="";
	string destSwitch="", destPrt="", destRackId="", destComment="", v_username="", dcPrefix="";
	DataSet dat = new DataSet();
	bool dbResult=false;

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
		dcPrefix=Request.QueryString["dc"].ToString();
	}
	catch (System.Exception ex)
	{
		dcPrefix="";
	}
	
	scope=goStat.Value;
	srcSwitch=srcSw.Value;
	srcPrt=srcPort.Value;
	destSwitch=destDropDown1.Value;
	destPrt=destDropDown2.Value;
	destComment=destPortName.Value;

	sql="SELECT rackspaceId FROM "+dcPrefix+"switches WHERE switchName='"+srcSwitch+"'";
	dat=readDb(sql);
	if (!emptyDataset(dat))
	{
		srcRackId=dat.Tables[0].Rows[0]["rackspaceId"].ToString();
	}

	sql="SELECT rackspaceId FROM "+dcPrefix+"switches WHERE switchName='"+destSwitch+"'";
	dat=readDb(sql);
	if (!emptyDataset(dat))
	{
		destRackId=dat.Tables[0].Rows[0]["rackspaceId"].ToString();
	}

	sql="SELECT slot, portNum FROM "+srcSwitch+" WHERE portId="+srcPrt;
	dat=readDb(sql);
	if (!emptyDataset(dat))
	{
		destComment="Slot"+dat.Tables[0].Rows[0]["slot"].ToString()+", Port "+dat.Tables[0].Rows[0]["portNum"].ToString();
	}

	sql="SELECT slot, PortNum FROM "+destSwitch+" WHERE portId="+destPrt;
	dat=readDb(sql);
	if (!emptyDataset(dat))
	{
		srcComment="Slot"+dat.Tables[0].Rows[0]["slot"].ToString()+", Port "+dat.Tables[0].Rows[0]["portNum"].ToString();
	}

	if (scope=="ixconn")
	{
		sql="UPDATE "+srcSwitch+" SET cabledTo="+destRackId+", comment='"+srcComment+"' WHERE portId="+srcPrt;
		sql1="UPDATE "+destSwitch+" SET cabledTo="+srcRackId+", comment='"+destComment+"' WHERE portId="+destPrt;
		sqlErr=writeDb(sql);
		if (sqlErr=="")
		{
			dbResult=true;
		}
		else
		{
			dbResult=false;
			errmsg.InnerHtml="Error Updating Switch ("+sql+"): "+sqlErr;
			logErr=writeChangeLog(dateStamp.ToString(), Decrypt(v_username.ToString()), "Error Updating Switch ("+sql+"): "+sqlErr);
		}
		if (dbResult=true)
		{
			sqlErr=writeDb(sql1);
			logErr=writeChangeLog(dateStamp.ToString(), Decrypt(v_username.ToString()), "Interconnect added between "+srcSwitch+":"+srcPrt+" and "+destSwitch+":"+destPrt+".");
			if (sqlErr=="")
			{
				Response.Write("<script>refreshParent("+");<"+"/script>");
			}
		}
		else
		{
			dbResult=false;
			errmsg.InnerHtml="Error Updating Switch ("+sql1+"): "+sqlErr;
			logErr=writeChangeLog(dateStamp.ToString(), Decrypt(v_username.ToString()), "Error Updating Switch ("+sql1+"): "+sqlErr);
		}
	}


	if (scope=="server")
	{
		destComment=destPortName.Value;
		sql="UPDATE "+srcSwitch+" SET cabledTo="+destPrt+", comment='"+destComment+"' WHERE portId="+srcPrt;
		sqlErr=writeDb(sql);
		if (sqlErr=="")
		{
			logErr=writeChangeLog(dateStamp.ToString(), Decrypt(v_username.ToString()), "Cable added between "+srcSwitch+":"+srcPrt+" and Rackspace ID "+destPrt+".");
			Response.Write("<script>refreshParent("+");<"+"/script>");
		}
		else
		{
			errmsg.InnerHtml="Error Updating Switch ("+sql+"): "+sqlErr;
			logErr=writeChangeLog(dateStamp.ToString(), Decrypt(v_username.ToString()), "Error Updating Switch ("+sql+"): "+sqlErr);
		}
	}
	
	
}

public void Page_Load(Object o, EventArgs e)
{
//UNCOMMENT this line to force login to access this page.
	lockout(); Page.Header.Title=shortSysName+": Add New Switch Cable";
	systemStatus(1); // Check to see if admin has put system is in offline mode.

	string sql;
	DataSet dat=new DataSet();
	HttpCookie cookie;
	bool sqlSuccess=true;
	string access="", port="", dcPrefix="";

	DateTime dateStamp = DateTime.Now;

	try
	{
		access=Request.QueryString["switch"].ToString();
	}
	catch (System.Exception ex)
	{
		access="";
	}

	try
	{
		port=Request.QueryString["portid"].ToString();
	}
	catch (System.Exception ex)
	{
		port="";
	}

	try
	{
		dcPrefix=Request.QueryString["dc"].ToString();
	}
	catch (System.Exception ex)
	{
		dcPrefix="";
	}

	if (!IsPostBack)
	{
		status.InnerHtml="<SPAN class='bold'>Choose Connection Type:</SPAN>";
	}	

	if (IsPostBack)
	{
	}
	srcLine.InnerHtml="Switch: "+access+" Port: "+port;

	destDropDown1.Disabled=true;
	destDropDown2.Disabled=true;
	destTitle1.InnerHtml="";
	destTitle2.InnerHtml="";
	srcSw.Value=access;
	srcPort.Value=port;
	
	titleSpan.InnerHtml="Cable Port";
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
				<DIV id='srcLine' runat='server'/>
			</DIV><BR/>
			<DIV id='status' runat='server'/>
			<DIV class='center'>
				<INPUT type='button' id='ixConnButton' value='Interconnect' OnServerClick='ixconn_button' runat='server' />&#xa0; 
				<INPUT type='button' value='Server' id='serverButton' OnServerClick='server_button' runat='server' />
				<BR/><BR/>
				<TABLE class='datatable center'>
					<TR>
						<TD class='center'>
							<TABLE>
								<TR><TD class='inputform'>&#xa0;</TD><TD class='whiteRowFill left'>&#xa0;</TD></TR>
								<TR><TD class='inputform'>&#xa0;</TD><TD class='whiteRowFill left'>&#xa0;</TD></TR>
								<TR>
									<TD class='inputform'><DIV id='destTitle1' runat='server'/></TD>
									<TD class='whiteRowFill left'>
										<SELECT id='destDropDown1' runat='server'>
											<OPTION value='' selected='true'>Select...</OPTION>
										</SELECT>&#xa0;
										<INPUT type='button' id='goButton' value='Go' OnServerClick='go_button' runat='server' />
									</TD>
								</TR>
								<TR>
									<TD class='inputform'><DIV id='destTitle2' runat='server'/></TD>
									<TD class='whiteRowFill left'>
										<SELECT id='destDropDown2' runat='server' >
											<OPTION value='' selected='true'>Select...</OPTION>
										</SELECT>
									</TD>
								</TR>
								<TR>
									<TD class='inputform'><DIV id='destTitle3' runat='server'/></TD>
									<TD class='whiteRowFill left'>
										<INPUT type='text' id='destPortName' size='5' runat='server' />
									</TD>
								</TR>
								<TR>
									<TD class='inputform'>&#xa0;</TD>
									<TD class='whiteRowFill left'>
										<INPUT type='hidden' id='goStat' runat='server' />
										<INPUT type='hidden' id='srcSw' runat='server' />
										<INPUT type='hidden' id='srcPort' runat='server' />
									</TD>
								</TR>
								<TR><TD class='inputform'>&#xa0;</TD><TD class='whiteRowFill left'>&#xa0;</TD></TR> 
							</TABLE>
						</TD>
					</TR>
				</TABLE>
				<BR/>&nbsp;
				<INPUT type='button' value='Save' id='submitButton' OnServerClick='goSubmit' runat='server' />&#xa0;<INPUT type='button' value='Cancel &amp; Close' onclick='refreshParent()'/>
				<BR/>&nbsp;
			</DIV>
		</DIV>
	</DIV> <!-- End: popContent -->
<!--#include file='popup_closer.inc' -->
	</FORM>
</DIV> <!-- End: container -->
</BODY>
</HTML>