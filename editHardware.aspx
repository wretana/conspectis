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
	lockout(); Page.Header.Title=shortSysName+": Edit Hardware";
	systemStatus(1); // Check to see if admin has put system is in offline mode.

	string sql, sqlBc, sqlRack, sqlEntities;
	DataSet dat, datBc, dat2, datRack, datEntities;
	HttpCookie cookie;
	bool sqlSuccess=true, permitted=false;
	string showHw="", dcPrefix="";
	string v_username, v_userclass="", v_userrole="",rackString="";
	bool portsFound=false;

	DateTime dateStamp = DateTime.Now;

	try
	{
		showHw=Request.QueryString["id"].ToString();
	}
	catch (System.Exception ex)
	{
		showHw="";
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
	
	if (IsPostBack)
	{
	}

	if (System.Text.RegularExpressions.Regex.IsMatch(v_userrole, "datacenter", System.Text.RegularExpressions.RegexOptions.IgnoreCase))
	{
		permitted=true;
	}
	
//	Response.Write(showHw);

//	if (!IsPostBack)
//	{
		sql="SELECT * FROM "+dcPrefix+"rackspace WHERE rackspaceId="+showHw;
//		Response.Write(sql);
		dat=readDb(sql);
		if (!emptyDataset(dat))
		{
			if (dat.Tables[0].Rows[0]["class"].ToString().Contains("BladeCenter"))
			{
				deviceName.InnerHtml=dcPrefix.ToUpper().Replace("_","")+" BladeCenter #"+dat.Tables[0].Rows[0]["bc"].ToString();
				sqlBc="SELECT * FROM (SELECT * FROM (SELECT slot,class,serial,model FROM rackspace WHERE bc='"+dat.Tables[0].Rows[0]["bc"].ToString()+"') WHERE slot<>'00') WHERE class<>'Virtual'";
				datBc=readDb(sqlBc);
				if (datBc!=null)
				{
					bool fill;
					HtmlTableRow tr;
					HtmlTableCell td;
	
					fill=false;
					tr = new HtmlTableRow();    //Output <TR>
						tr.Attributes.Add("class","blackheading");
						td = new HtmlTableCell(); //Output <TD>
							td.Attributes.Add("colspan","4");
							td.InnerHtml = "Member Blades";
						tr.Cells.Add(td);         //Output </TD>
					memberBlades.Rows.Add(tr);           //Output </TR>
					tr = new HtmlTableRow();    //Output <TR>
						tr.Attributes.Add("class","tableheading");
						td = new HtmlTableCell(); //Output <TD>
							td.InnerHtml = "Slot";
							td.Attributes.Add("style","width:10px;");
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
							td.InnerHtml = "Class";
							td.Attributes.Add("style","width:5px;");
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
							td.InnerHtml = "Model";
							td.Attributes.Add("style","width:5px;");
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
							td.InnerHtml = "Serial";
							td.Attributes.Add("style","width:5px;");
						tr.Cells.Add(td);         //Output </TD>
					memberBlades.Rows.Add(tr);           //Output </TR>
					foreach (DataTable dtt in datBc.Tables)
					{
						foreach (DataRow drr in dtt.Rows)
						{					
							tr = new HtmlTableRow();    //Output <TR>
							if (fill) tr.Attributes.Add("class","altrow");
								td = new HtmlTableCell(); //Output <TD>
									td.InnerHtml="<SPAN class='smaller'>"+drr["slot"].ToString()+"</SPAN>";
									td.Attributes.Add("class","center");
								tr.Cells.Add(td);         //Output </TD>
								td = new HtmlTableCell(); //Output <TD>
									td.InnerHtml="<SPAN class='smaller'>"+drr["class"].ToString()+"</SPAN>";
								tr.Cells.Add(td);         //Output </TD>
								td = new HtmlTableCell(); //Output <TD>
									td.InnerHtml="<SPAN class='smaller'>"+drr["model"].ToString()+"</SPAN>";
								tr.Cells.Add(td);         //Output </TD>
								td = new HtmlTableCell(); //Output <TD>
									td.InnerHtml="<SPAN class='smaller'>"+drr["serial"].ToString()+"</SPAN>";
								tr.Cells.Add(td);         //Output </TD>
							memberBlades.Rows.Add(tr);           //Output </TR>
						fill=!fill;
					}
				} 
				}
			}	
			else
			{
				deviceName.InnerHtml=dat.Tables[0].Rows[0]["class"].ToString();
//				hwBlades.InnerHtml="N/A";
			}
			hwClass.InnerHtml=dat.Tables[0].Rows[0]["class"].ToString();
			hwModel.InnerHtml=dat.Tables[0].Rows[0]["model"].ToString();
			hwSerial.InnerHtml=dat.Tables[0].Rows[0]["serial"].ToString();

			sqlRack="SELECT location, rackId FROM "+dcPrefix+"racks WHERE rackId='"+dat.Tables[0].Rows[0]["rack"].ToString()+"'";
//			Response.Write(sqlRack+"<BR/>");
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
			hwRack.InnerHtml=rackString;
			hwSlot.InnerHtml=dat.Tables[0].Rows[0]["slot"].ToString();

			if (dat.Tables[0].Rows[0]["reserved"].ToString()=="1")
			{
				hwReserved.InnerHtml="Yes";
			}
			else
			{
				hwReserved.InnerHtml="No";
			}
			if (dat.Tables[0].Rows[0]["sanAttached"].ToString()=="1")
			{
				hwSANAttach.InnerHtml="Yes";
			}
			else
			{
				hwSANAttach.InnerHtml="No";
			}
			dat2=getPorts(showHw,dcPrefix);
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
				cableMap.Rows.Add(tr);           //Output </TR>
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
				cableMap.Rows.Add(tr);           //Output </TR>
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
						cableMap.Rows.Add(tr);           //Output </TR>
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
				cableMap.Rows.Add(tr);           //Output </TR>
				tr = new HtmlTableRow();    //Output <TR>
					td = new HtmlTableCell(); //Output <TD>
						td.InnerHtml = "No Network Cabling on File!";
						td.Attributes.Add("class","errorBox center");
						td.Attributes.Add("class","width:90px;");
					tr.Cells.Add(td);         //Output </TD>
				cableMap.Rows.Add(tr);           //Output </TR>
			}
			sqlEntities="SELECT * FROM "+dcPrefix+"servers WHERE rackspaceId="+showHw;
			datEntities=readDb(sqlEntities);
			if (datEntities!=null)
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
						if (v_userclass=="3" || v_userclass=="99")
						{
							td.InnerHtml = "<INPUT type='image' src=./img/add-server-16x16.png onclick=\"window.open('newEntity.aspx?rackspace="+showHw+"&dc="+dcPrefix+"&method=admin','newEntityWin','width=400,height=750,menubar=no,scrollbars=yes,status=yes')\" ALT='New Entity' />";
						}
						else
						{
							td.InnerHtml="&#xa0;";
						}
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
								if (v_userclass=="3" || v_userclass=="99" || v_userrole.Contains("dns"))
								{
									td.InnerHtml="<INPUT type='image' src='./img/edit.png' onclick=\"window.open('editServer.aspx?host="+drr["serverName"].ToString()+"&dc="+dcPrefix+"&method=admin','editEntityWin','width=400,height=750,menubar=no,scrollbars=yes,status=yes')\" ALT='Edit Server'/>&#xa0;<INPUT type='image' src='./img/delete.png' onclick=\"window.open('deleteServer.aspx?host="+drr["serverName"].ToString()+"&dc="+dcPrefix+"','deleteServerWin','width=350,height=275,menubar=no,status=yes')\" ALT='Delete Server' />&#xa0;";
								}
								else
								{
									td.InnerHtml="<INPUT type='image' src=./img/edit.png onclick=\"window.open('showServer.aspx?host="+drr["serverName"].ToString()+"dc="+dcPrefix+"&method=admin','editEntityWin','width=400,height=750,menubar=no,scrollbars=yes,status=yes')\" ALT='Show Server' />";
								}
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
						if (v_userclass=="3" || v_userclass=="99")
						{
							td.InnerHtml = "<INPUT type='image' src=./img/add-server-16x16.png onclick=\"window.open('newEntity.aspx?rackspace="+showHw+"&dc="+dcPrefix+"&method=admin','newEntityWin','width=400,height=750,menubar=no,scrollbars=yes,status=yes')\" ALT='New Entity' />";
						}
						else
						{
							td.InnerHtml="&#xa0;";
						}
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
//	}

	if (IsPostBack)
	{
	}
	titleSpan.InnerHtml="Edit Hardware";
}
</SCRIPT>
</HEAD>
<!--#include file='body.inc' -->
<DIV id='popContainer'>
	<FORM runat='server'>
<!--#include file='popup_opener.inc' -->
	<DIV id='popContent'>
		<DIV class='center altRowFill'>
			<SPAN id='titleSpan' runat='server'/><BR/>
			<SPAN id='deviceName' runat='server'/>
			<DIV id='errmsg' class='errorLine' runat='server'/>
		</DIV>
		
		<DIV class='center paleColorFill'>
			&nbsp;<BR/>
			<DIV class='center'>
				<TABLE border='1' class='datatable center'>
					<TR><TD class='center'>
						<TABLE>
							<TR>
								<TD class='inputform'>Device:</TD>
								<TD class='whiteRowFill'><DIV id='hwClass' runat='server'/></TD>
							</TR>
							<TR>
								<TD class='inputform'>Model:</TD>
								<TD class='whiteRowFill'><DIV id='hwModel' runat='server'/></TD>
							</TR>
							<TR>
								<TD class='inputform'>Serial:</TD>
								<TD class='whiteRowFill'><DIV id='hwSerial' runat='server'/></TD>
							</TR>
							<TR>
								<TD class='inputform'>&#xa0;</TD>
								<TD class='whiteRowFill'>&#xa0;</TD>
							</TR>
							<TR>
								<TD class='inputform'>Location Info</TD>
								<TD class='whiteRowFill'>&#xa0;</TD>
							</TR>
							<TR>
								<TD class='inputform'>&#xa0; &#xa0; Rack:</TD>
								<TD class='whiteRowFill'><DIV id='hwRack' runat='server'/></TD>
							</TR>
							<TR>
								<TD class='inputform'>&#xa0; &#xa0; BC:</TD>
								<TD class='whiteRowFill'><DIV id='hwBc' runat='server'/></TD>
							</TR>
							<TR>
								<TD class='inputform'>&#xa0; &#xa0; 'U' Slot:</TD>
								<TD class='whiteRowFill'><DIV id='hwSlot' runat='server'/></TD>
							</TR>
							<TR>
								<TD class='inputform'>&#xa0;</TD>
								<TD class='whiteRowFill'>&#xa0;</TD>
							</TR>
							<TR>
								<TD class='inputform'>Reserved?</TD>
								<TD class='whiteRowFill'><DIV id='hwReserved' runat='server'/></TD>
							</TR>
							<TR>
								<TD class='inputform'>SAN Attached?</TD>
								<TD class='whiteRowFill'><DIV id='hwSANAttach' runat='server'/></TD>
							</TR>
							<TR>
								<TD class='inputform'>&#xa0;</TD>
								<TD class='whiteRowFill'>&#xa0;</TD>
							</TR>
							<TR>
								<TD class='inputform'>&#xa0;</TD>
								<TD class='whiteRowFill center'>
									<TABLE id='memberBlades' class='datatable center' runat='server' />
								</TD>
							</TR>
							<TR>
								<TD class='inputform'>&#xa0;</TD>
								<TD class='whiteRowFill'>&#xa0;</TD>
							</TR>
							<TR>
								<TD class='inputform'>&#xa0;</TD>
								<TD class='whiteRowFill center'>
									<TABLE id='cableMap' class='datatable center' runat='server' />
								</TD>
							</TR>
							<TR>
								<TD class='inputform'>&#xa0;</TD>
								<TD class='whiteRowFill'>&#xa0;</TD>
							</TR>
							<TR>
								<TD class='inputform'>&#xa0;</TD>
								<TD class='whiteRowFill center'>
									<TABLE id='entityTable' class='datatable center' runat='server' />
								</TD>
							</TR>
						</TABLE>
					</TD></TR>
				</TABLE>
				<BR/>
				<INPUT type='submit' value='Save Changes' runat='server'/>&#xa0;<INPUT type='button' value='Cancel &amp; Close' onclick='refreshParent()'/>
			</DIV>
			&nbsp;
		</DIV>
	</DIV> <!-- End: popContent -->
<!--#include file='popup_closer.inc' -->
	</FORM>
</DIV> <!-- End: container -->
</BODY>
</HTML>