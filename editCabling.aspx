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
void popInfo(Object s, EventArgs e) 
{
	string v_switch, sql, dcPrefix="";
	DataSet dat=new DataSet();
	v_switch=formAccessSw.Value;

	try
	{
		dcPrefix=Request.QueryString["dc"].ToString();
	}
	catch (System.Exception ex)
	{
		dcPrefix="";
	}
	sql="SELECT * FROM "+v_switch+" WHERE cabledTo IS NULL AND comment IS NULL ORDER BY portId ASC";
//	Response.Write(sql);
	dat=readDb(sql);
	if (!emptyDataset(dat))
	{
		foreach(DataRow dr in dat.Tables[0].Rows)
		{
			ListItem li = new ListItem("Slot "+dr["slot"].ToString()+", Port "+dr["portNum"].ToString(), dr["portId"].ToString());
			formSlotPortDrop.Items.Add(li);
		} 
//		formSlotPortDrop.SelectedIndex=SupvDropDown.Items.IndexOf(formSlotPortDrop.Items.FindByValue(dat.Tables[0].Rows[0]["userSupervisor"].ToString());
	}
}

void goSubmit(Object s, EventArgs e)
{
		string v_comment=fix_txt(formPortName.Value);
		string v_switchId=formAccessSw.Value;
		string v_portNum=formSlotPortDrop.Value;
		string sql, errStr="", sqlErr="";
		string v_username="", v_userrole="", rackspaceId="", dcPrefix="";
		DataSet dat=new DataSet();
		bool sqlSuccess=false;

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

	try
	{
		rackspaceId=Request.QueryString["id"].ToString();
	}
	catch (System.Exception ex)
	{
		rackspaceId="";
	}

	try
	{
		dcPrefix=Request.QueryString["dc"].ToString();
	}
	catch (System.Exception ex)
	{
		dcPrefix="";
	}
		
	if (v_comment!=null && v_switchId!=null && v_portNum!=null)
	{
		sql="UPDATE "+dcPrefix+v_switchId+" SET comment='"+v_comment+"', cabledTo="+rackspaceId+" WHERE portId="+v_portNum;
//		Response.Write(sql);
		sqlErr=writeDb(sql);
		if (sqlErr==null || sqlErr=="")
		{
			errStr = "Cable Porting Record Updated.";
			sqlSuccess=true;
			errmsg.InnerHtml=errStr;
		}
		else
		{
			errmsg.InnerHtml = errStr+" SQL Update Error - Cabling  - "+sqlErr;
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
		if (v_switchId == "") formSlotPortDrop.Style	["background"]="yellow";
		if (v_portNum == "") formAccessSw.Style ["background"]="yellow";
		if (v_comment == "") formPortName.Style ["background"]="yellow";
		errStr = "Please enter valid data in all required fields!";
		errmsg.InnerHtml = errStr;
	}
}

public void Page_Load(Object o, EventArgs e)
{
//UNCOMMENT this line to force login to access this page.
	lockout(); Page.Header.Title=shortSysName+": Edit Cabling";
	systemStatus(1); // Check to see if admin has put system is in offline mode.

	string sql, sql1="", sql2="";
	string sqlSwitch;
	DataSet dat, dat1, dat2;
	DataSet datSwitch;
	string v_username, sqlErr="", v_userrole;
	HttpCookie cookie;
	bool sqlSuccess=true, portsFound=false;
	string rackspaceId="", dcPrefix="";
	int i, rowCount;

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

	try
	{
		rackspaceId=Request.QueryString["id"].ToString();
	}
	catch (System.Exception ex)
	{
		rackspaceId="";
	}

	try
	{
		dcPrefix=Request.QueryString["dc"].ToString();
	}
	catch (System.Exception ex)
	{
		dcPrefix="";
	}
	
	formSlotPortDrop.Style	["background"]="white";
	formAccessSw.Style ["background"]="white";
	formPortName.Style ["background"]="white";
	string errStr = "";

	string cableSrc="";

	sql="SELECT serverName, rack, bc, slot FROM "+dcPrefix+"servers INNER JOIN "+dcPrefix+"rackspace ON "+dcPrefix+"servers.rackspaceId="+dcPrefix+"rackspace.rackspaceId WHERE "+dcPrefix+"servers.rackspaceId="+rackspaceId;
	dat=readDb(sql);
	if (!emptyDataset(dat))
	{
		string sqlRack="", rackString="";
		DataSet datRack=new DataSet();
		sqlRack="SELECT location, rackId FROM "+dcPrefix+"racks WHERE rackId='"+dat.Tables[0].Rows[0]["rack"].ToString()+"'";
//		Response.Write(sqlRack+"<BR/>");
		datRack=readDb(sqlRack);
		if (datRack!=null)
		{
			try
			{
				rackString="("+dcPrefix.ToUpper().Replace("_","")+") "+datRack.Tables[0].Rows[0]["location"].ToString()+"-R"+datRack.Tables[0].Rows[0]["rackId"].ToString().Substring(0,2)+"-C"+datRack.Tables[0].Rows[0]["rackId"].ToString().Substring(2,2);
			}
			catch (System.Exception ex)
			{
				rackString="ERR";
			}
		}
		hostname.InnerHtml="<SPAN class='bold'>"+dat.Tables[0].Rows[0]["serverName"].ToString()+"</SPAN><BR/><SPAN class='italic'>"+rackString+" BC:"+dat.Tables[0].Rows[0]["bc"].ToString()+" Slot:"+dat.Tables[0].Rows[0]["slot"].ToString()+"</SPAN>";
	}
	dat2=getPorts(rackspaceId,dcPrefix);
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
				td.InnerHtml = "Porting";
			tr.Cells.Add(td);         //Output </TD>
		cableMap1.Rows.Add(tr);           //Output </TR>
		tr = new HtmlTableRow();    //Output <TR>
			tr.Attributes.Add("class","tableheading");
			td = new HtmlTableCell(); //Output <TD>
				td.InnerHtml = "Desc";
			td.Attributes.Add("style","width:45px;");
			tr.Cells.Add(td);         //Output </TD>
			td = new HtmlTableCell(); //Output <TD>
				td.InnerHtml = "Switch";
			td.Attributes.Add("style","width:10px;");
			tr.Cells.Add(td);         //Output </TD>
			td = new HtmlTableCell(); //Output <TD>
				td.InnerHtml = "Slot";
				td.Attributes.Add("style","width:5px;");
			tr.Cells.Add(td);         //Output </TD>
			td = new HtmlTableCell(); //Output <TD>
				td.InnerHtml = "Port";
				td.Attributes.Add("style","width:5px;");
			tr.Cells.Add(td);         //Output </TD>
			td = new HtmlTableCell(); //Output <TD>
				td.InnerHtml = "Actions";
				td.Attributes.Add("style","width:5px;");
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
						td.InnerHtml="<SPAN class='smaller center'>"+drr["slot"].ToString()+"</SPAN>";
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						td.InnerHtml="<SPAN class='smaller center'>"+drr["portNum"].ToString()+"</SPAN>";
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						td.InnerHtml="<INPUT type='image' src='./img/delete.png' onclick=\"window.open('deleteCabling.aspx?sw="+drr["switchId"].ToString()+"&port="+drr["portId"].ToString()+"&dc="+dcPrefix+"','deleteCablingWin','width=315,height=275,menubar=no,status=yes')\" ALT='Delete Cabling' />";
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

	if (!IsPostBack)
	{
		sql="SELECT description,switchName FROM "+dcPrefix+"switches ORDER BY switchName ASC";
		dat=readDb(sql);
		if (!emptyDataset(dat))
		{
			foreach(DataRow dr in dat.Tables[0].Rows)
			{
				ListItem li = new ListItem(dr["description"].ToString(), dr["switchName"].ToString());
				formAccessSw.Items.Add(li);
			}
//			formAccessSw.SelectedIndex=formAccessSw.Items.IndexOf(formAccessSw.Items.FindByValue(dat.Tables[0].Rows[0]["userSupervisor"].ToString());
		}
	}
	
	if (IsPostBack)
	{
	
	}
	
//	Response.Write("RackspaceId: "+rackspaceId);
	titleSpan.InnerHtml="Edit Cabling";
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
		&#xa0;<BR/>
			<DIV class='center'>
				<TABLE class='whiteRowFill datatable center'>
					<TR><TD class='center' colspan='6'><DIV id='hostname' runat='server'/></TD></TR>
					<TR><TD class='center' colspan='6'>&#xa0;</TD></TR>
					<TR><TD class='center' colspan='6'>
						<TABLE id='cableMap1' class='datatable center' runat='server'></TABLE><BR/>
						<TABLE id='cableMap2' class='datatable center' runat='server'></TABLE>
						<TABLE id='cableMap3' class='datatable center' runat='server'></TABLE>
					</TD></TR>
					<TR><TD class='center' colspan='6'>&#xa0;</TD></TR>
					<TR>
						<TD class='center' colspan='6'><SPAN class='bold'>New Cabling / Porting</SPAN></TD>						
					</TR>
					<TR>
  					    <TD class='center'>&#xa0; &#xa0;</TD>
						<TD class='center' style='border-bottom:1px solid #005000'>Server NIC</TD>
						<TD class='center' style='border-bottom:1px solid #005000'>Switch</TD>
						<TD class='center' style='border-bottom:1px solid #005000'>Slot/Port</TD>
						<TD class='center'>&#xa0; &#xa0;</TD>
						<TD class='center'>&#xa0; &#xa0;</TD>
					</TR>
					<TR><TD class='center' colspan='6'>&#xa0;</TD></TR>
					<TR>
						<TD class='center'>&#xa0; &#xa0;</TD>
						<TD class='center'><INPUT type='text' id='formPortName' size='5' runat='server' />&#xa0;</TD>
						<TD class='center'>
							<SELECT id='formAccessSw' runat='server'>
								<OPTION value='' selected='true'>Select...</OPTION>
							</SELECT>
							<INPUT type='button' id='populateButton' value='Populate' OnServerClick='popInfo' runat='server' />&#xa0; 
						</TD>
						<TD class='center'>
							<SELECT id='formSlotPortDrop' runat='server'>
   								<OPTION value='' selected='true'>Select...</OPTION>
							</SELECT>
						</TD>
						<TD class='center'>&#xa0; &#xa0;</TD>
						<TD class='center'>&#xa0; &#xa0;</TD>
					</TR>
					<TR><TD class='center' colspan='6'>&#xa0;</TD></TR>
					<TR>
						<TD class='center' colspan='6'>
							<INPUT type='button' id='submitButton' value='Save Changes' OnServerClick='goSubmit' runat='server' />
							<INPUT type='button' value='Cancel &amp; Close' onclick='refreshParent()' />
						</TD>
					</TR>
					<TR><TD class='center' colspan='6'>&#xa0;</TD></TR>
				</TABLE>
				<BR/>&#xa0;
			</DIV>
		</DIV>
	</DIV> <!-- End: popContent -->
<!--#include file='popup_closer.inc' -->
	</FORM>
</DIV> <!-- End: container -->
</BODY>
</HTML>