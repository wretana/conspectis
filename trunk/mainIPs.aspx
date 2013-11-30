<%@Page Inherits="CIS.conspectisLibrary" src="conspectisLibrary.cs" Language="C#" debug="true" %>
<%@Register TagPrefix="Chart" TagName="PieChart" Src="PieChart.ascx" %>
<%@Import namespace="System.Drawing" %>
<%@Import Namespace="System.Data"%>
<%@Import Namespace="System"%>

<!DOCTYPE html>
<!-- HTML5 STatus: VALID 2-6-13 CK -->
<!--[if lt IE 7 ]> <html lang='en' class='no-js ie6'> <![endif]-->
<!--[if IE 7 ]>    <html lang='en' class='no-js ie7'> <![endif]-->
<!--[if IE 8 ]>    <html lang='en' class='no-js ie8'> <![endif]-->
<!--[if IE 9 ]>    <html lang='en' class='no-js ie9'> <![endif]-->
<!--[if (gt IE 9)|!(IE)]><!--> <html lang='en' class='no-js'> <!--<![endif]-->

<HEAD runat="server">

<!--#include file="header.inc"-->

<SCRIPT runat="server">
public void storeDC(object sender, EventArgs e)
{
	string code="", sql="", cookieVal="";
	code=dcSelector.Value;

//	Fetch cookie to determine if it needs to be set anew, or just updated ...
	try
	{
		cookieVal=Request.Cookies["selectedDc"].Value;
	}
	catch (System.Exception ex)
	{
		cookieVal="";
	}
	if (cookieVal=="") // Set new cookie ...
	{
		HttpCookie cookie=new HttpCookie("selectedDc",code);
		cookie.Expires=DateTime.Now.AddDays(3);
		Response.Cookies.Add(cookie);
	}
	else // Update existing coolie ...
	{
		HttpCookie cookie=Request.Cookies["selectedDc"];
		cookie.Value=code;
		Response.Cookies.Add(cookie);
	}

	//Now Fetch cookie to display its value ...
	Response.Write("<script type='text/JavaScript'>document.location.reload("+"true);<"+"/script>");
}

public void showSubnet(string vlan, string dcPrefix)
{
	string sql,sql1;
	DataSet dat=new DataSet();
	int bcLimit=16, bcNum=1, slotLimit=14, slotNum=1, curSlot=1, index=0;
	bool emptySlot=false;
	string order;
	HtmlTableRow tr;
	HtmlTableCell td;
	bool fill;
	string vlanId="";
	string v_userclass="", v_userrole="", pingContent="", dnsContent="";
	
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

	hrSpan.InnerHtml ="<HR class='dotted'>";

	if (vlan!="")
	{
		Single subnetTotalIps=0, subnetFreeIps=0, subnetReservedIps=0, subnetUsedIps=0;
		string subnetTotalIpSql = "SELECT COUNT(*) FROM "+dcPrefix+vlan;
		dat=readDb(subnetTotalIpSql);
		if (dat!=null)
		{
			switch (System.Configuration.ConfigurationManager.AppSettings["db_type"].ToString().ToUpper())
			{
			case "MSJET":
				try
				{
					subnetTotalIps=Convert.ToSingle(dat.Tables[0].Rows[0]["Expr1000"].ToString());
				}
				catch (System.Exception ex)
				{
					subnetTotalIps=0;
				}
				break;
			case "MSSQL":
				try
				{
					subnetTotalIps=Convert.ToSingle(dat.Tables[0].Rows[0]["Column1"].ToString());
				}
				catch (System.Exception ex)
				{
					subnetTotalIps=0;
				}
				break;
			}
		}
		else
		{
			subnetTotalIps=0;
		}
		string subnetReservedIpSql = "SELECT COUNT(*) FROM "+dcPrefix+vlan+" WHERE reserved=1";
		dat=readDb(subnetReservedIpSql);
		if (dat!=null)
		{
			switch (System.Configuration.ConfigurationManager.AppSettings["db_type"].ToString().ToUpper())
			{
			case "MSJET":
				try
				{
					subnetReservedIps=Convert.ToSingle(dat.Tables[0].Rows[0]["Expr1000"].ToString());
				}
				catch (System.Exception ex)
				{
					subnetReservedIps=0;
				}
				break;
			case "MSSQL":
				try
				{
					subnetReservedIps=Convert.ToSingle(dat.Tables[0].Rows[0]["Column1"].ToString());
				}
				catch (System.Exception ex)
				{
					subnetReservedIps=0;
				}
				break;
			}
		}
		else
		{
			subnetReservedIps=0;
		}
		string subnetFreeIpSql = "SELECT COUNT(*) FROM (SELECT ipAddr FROM (SELECT * FROM "+dcPrefix+vlan+" LEFT JOIN "+dcPrefix+"servers ON "+dcPrefix+"servers.serverLanIp="+dcPrefix+vlan+".ipAddr WHERE "+dcPrefix+"servers.serverLanIp is Null) WHERE reserved=0)";
		dat=readDb(subnetFreeIpSql);
		if (dat!=null)
		{
			switch (System.Configuration.ConfigurationManager.AppSettings["db_type"].ToString().ToUpper())
			{
			case "MSJET":
				try
				{
					subnetFreeIps=Convert.ToSingle(dat.Tables[0].Rows[0]["Expr1000"].ToString());
				}
				catch (System.Exception ex)
				{
					subnetFreeIps=0;
				}
				break;
			case "MSSQL":
				try
				{
					subnetFreeIps=Convert.ToSingle(dat.Tables[0].Rows[0]["Column1"].ToString());
				}
				catch (System.Exception ex)
				{
					subnetFreeIps=0;
				}
				break;
			}
		}
		else
		{
			subnetFreeIps=0;
		}

		subnetUsedIps=subnetTotalIps-subnetReservedIps-subnetFreeIps;

		double chartOccupied, chartReserved, chartFree;

		chartOccupied=Math.Round(((subnetUsedIps/subnetTotalIps)*100) + 2/10.0,2);
		chartReserved=Math.Round(((subnetReservedIps/subnetTotalIps)*100) + 2/10.0,2);
		chartFree=Math.Round(((subnetFreeIps/subnetTotalIps)*100) + 2/10.0,2);

	        PieChart_ascx.PieChartElement myPieChartElement1 = new PieChart_ascx.PieChartElement();
		PieChart_ascx.PieChartElement myPieChartElement2 = new PieChart_ascx.PieChartElement();
		PieChart_ascx.PieChartElement myPieChartElement3 = new PieChart_ascx.PieChartElement();

	        myPieChartElement1.Name = "Occupied";
		myPieChartElement1.Percent = chartOccupied;
	        myPieChartElement1.Color = Color.FromArgb(200, 30, 0);
		IPCapacityPieChart.addPieChartElement(myPieChartElement1);

		myPieChartElement3.Name = "Reserved";
		myPieChartElement3.Percent = chartReserved;
	        myPieChartElement3.Color = Color.FromArgb(255, 255, 0);
		IPCapacityPieChart.addPieChartElement(myPieChartElement3);

	        myPieChartElement2.Name = "Free";
		myPieChartElement2.Percent = chartFree;
	        myPieChartElement2.Color = Color.FromArgb(0, 255, 0);
		IPCapacityPieChart.addPieChartElement(myPieChartElement2);
        
		IPCapacityPieChart.ChartTitle = "IP Availability - "+vlan;
		IPCapacityPieChart.ImageAlt = "IP Availability Chart";
	        IPCapacityPieChart.ImageWidth = 325;
		IPCapacityPieChart.ImageHeight = 180;

	        IPCapacityPieChart.generateChartImage();		

		sql = "SELECT * FROM "+dcPrefix+vlan+" LEFT JOIN "+dcPrefix+"servers ON "+dcPrefix+vlan+".ipAddr = "+dcPrefix+"servers.serverLanIp ORDER BY ipAddr";
		dat=readDb(sql);
		if (dat!=null)
		{
			fill=false;
			tr = new HtmlTableRow();    //Output <TR>
				tr.Attributes.Add("class","blackheading");
				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("colspan","4");
					td.InnerHtml = vlan+" VLAN " +vlanId;
				tr.Cells.Add(td);         //Output </TD>
			vlanTbl.Rows.Add(tr);           //Output </TR>
			tr = new HtmlTableRow();    //Output <TR>
				tr.Attributes.Add("class","tableheading");
				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("class","ipAddrAddressCol");
					td.InnerHtml = "Address";
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("class","ipAddrHostnameCol");
					td.InnerHtml = "Hostname";
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("class","ipAddrStatusCol");
					td.InnerHtml = "Status";
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("class","ipAddrActionCol");
					td.InnerHtml = "&#xa0; Actions &#xa0;";
				tr.Cells.Add(td);         //Output </TD>
			vlanTbl.Rows.Add(tr);           //Output </TR>
			foreach (DataTable dtt in dat.Tables)
			{
				foreach (DataRow drr in dtt.Rows)
				{
					tr = new HtmlTableRow();    //Output <TR>
					if (fill) tr.Attributes.Add("class","altrow");
						td = new HtmlTableCell(); //Output <TD>
							td.Attributes.Add("class","ipAddrAddressCol ipAddr");
							td.InnerHtml = drr["ipAddr"].ToString();
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
							td.Attributes.Add("class","ipAddrHostnameCol ipAddr");
							if (drr["serverName"].ToString()=="")
							{
								if (drr["reserved"].ToString()=="1")
								{
									td.InnerHtml = "RESERVED";
								}
								else
								{
									td.InnerHtml = "&#xa0;";
								}
							}
							else
							{	
								td.InnerHtml = drr["serverName"].ToString();
							}
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
							td.Attributes.Add("class","ipAddrStatusCol ipAddr");
							if (drr["pingStatus"].ToString()=="1")
							{ //Pinging..
								pingContent="<IMG SRC='./img/ping-ok.png' alt='PING OK - "+drr["comment"].ToString()+"' title='PING OK - "+drr["comment"].ToString()+"'/>";
							}
							else
							{ //Not Pinging or Error ...
								pingContent="<IMG SRC='./img/ping-fail.png' alt='NO PING - "+drr["comment"].ToString()+"' title='NO PING - "+drr["comment"].ToString()+"'/>";
							}
							if (drr["dnsStatus"].ToString()=="0")
							{ //No DNS Resolution..
								dnsContent="<IMG SRC='./img/dns-fail.png' alt='NO DNS RESOLUTION - "+drr["comment"].ToString()+"' title='NO DNS RESOLUTION - "+drr["comment"].ToString()+"'/>";
							}
							else if (drr["dnsStatus"].ToString()=="1")
							{ //DNS Lookup OK..
								dnsContent="<IMG SRC='./img/dns-ok.png' alt='DNS LOOKUP OK - "+drr["comment"].ToString()+"' title='DNS LOOKUP OK - "+drr["comment"].ToString()+"'/>";
							}
							else if (drr["dnsStatus"].ToString()=="2")
							{ //DNS Lookup Error ...
								dnsContent="<IMG SRC='./img/dns-err.png' alt='DNS ERROR - "+drr["comment"].ToString()+"' title='DNS ERROR - "+drr["comment"].ToString()+"'/>";
							}
							td.InnerHtml="&#xa0;"+pingContent+"&#xa0;"+dnsContent;
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
							td.Attributes.Add("class","ipAddrActionCol ipAddr");
							if (drr["reserved"].ToString()=="1")
							{
								if (drr["serverName"].ToString()=="" /*&& v_userclass=="3"*/)
								{
									if (v_userclass=="3" || v_userclass=="99")
									{
										td.InnerHtml = "<INPUT type='image' src='./img/unlock.png'  title='"+drr["comment"]+"' onclick=\"window.open('reserveIp.aspx?ip="+drr["ipAddr"].ToString()+"&amp;vlan="+vlan+"&amp;dc="+dcPrefix+"','reserveIpWin','width=300,height=400,menubar=no,status=yes')\" ALT='Remove Reservation' />";
									}
									else
									{
										td.InnerHtml = "&#xa0;";
									}

								}
							}
							else
							{
								if (drr["serverName"].ToString()=="" /*&& v_userclass=="3"*/)
								{
									if (v_userclass=="3" || v_userclass=="99")
									{
										td.InnerHtml = "<INPUT type='image' src='./img/reserve.png'  onclick=\"window.open('reserveIp.aspx?ip="+drr["ipAddr"].ToString()+"&amp;vlan="+vlan+"&amp;dc="+dcPrefix+"','reserveIpWin','width=300,height=400,menubar=no,status=yes')\" ALT='Reserve IP' />";
									}
									else
									{
										td.InnerHtml = "&#xa0;";
									}
								}
								else
								{
									if (v_userclass=="3" || v_userclass=="99")
									{
										td.InnerHtml = "<INPUT type='image' src='./img/svrDetail.png'  onclick=\"window.open('editServer.aspx?host="+drr["serverName"].ToString()+"','editServerWin','width=315,height=750,menubar=no,status=yes,scrollbars=yes')\" class='black' ALT='Server Detail' />&#xa0;<INPUT type='image' src='./img/delete.png' onclick=\"window.open('deleteServer.aspx?host="+drr["serverName"].ToString()+"','deleteServerWin','width=315,height=275,menubar=no,status=yes')\" ALT='Delete Server' />";
									}
									else
									{
										td.InnerHtml = "<INPUT type='image' src='./img/svrDetail.png'  onclick=\"window.open('showServer.aspx?host="+drr["serverName"].ToString()+"','editServerWin','width=315,height=750,menubar=no,status=yes,scrollbars=yes')\" class='black' ALT='Server Detail' />";
									}

								}
							}
						tr.Cells.Add(td);         //Output </TD>
					vlanTbl.Rows.Add(tr);           //Output </TR>
					fill=!fill;
				}
			}

		}
	} 
}

private void goSearch(Object s, EventArgs e) 
{
	hrSpan.InnerHtml ="<HR class='dotted'>";
	string sql="";
	string v_searchWord = fix_txt(searchWord.Value);
	string v_searchFrom = fix_txt(searchFrom.Value);
	string v_userclass, v_userrole, v_username, dcPrefix="";
	DataSet dat=new DataSet();
	HtmlTableRow tr;
	HtmlTableCell td;
	bool fill;
	HttpCookie cookie;
	ColorConverter colConvert = new ColorConverter();

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
		dcPrefix=Request.QueryString["dc"].ToString();
	}
	catch (System.Exception ex)
	{
		dcPrefix = "";
	}

	if (v_searchWord!="") sql="SELECT serverName, serverLanIP, serverOS, serverPurpose, rack, bc, slot, rackspace.rackspaceId, serial, reserved FROM servers LEFT JOIN rackspace ON servers.rackspaceId=rackspace.rackspaceId WHERE "+v_searchFrom+" LIKE '%"+v_searchWord+"%' ORDER BY serverName ASC";
	if (sql!="")
	{
		ViewState["exportStr"] = "srch";
		ViewState["searchArg"] = sql;

		cookie=new HttpCookie("srchSql",sql);
		cookie.Expires=DateTime.Now.AddSeconds(45);
		Response.Cookies.Add(cookie);
		cookie=new HttpCookie("goSrch","srch");
		cookie.Expires=DateTime.Now.AddSeconds(45);
		Response.Cookies.Add(cookie);
		
		//Place Printable View Button in Panel on Web Page
		ImageButton pb = new ImageButton();
		pb.ID = "printableButton";
		pb.ImageUrl = "./img/print.png";
		pb.Width = 125;
		pb.Height= 25;
		pb.AlternateText="Show Printable View";
		pb.BackColor=(System.Drawing.Color)colConvert.ConvertFromString("#FFFFFF");
//		pb.Attributes.Add("language", "javascript");
		pb.Attributes.Add("OnClick", "window.open('print.aspx?srch=svr','printableWin','width=600,menubar=no,status=yes,scrollbars=yes')");
		Panel1.Controls.Add(pb); 
	}


if (sql!="")
		{
			dat=readDb(sql);
			if (dat!=null)
			{
				fill=false;
				tr = new HtmlTableRow();    //Output <TR>
					tr.Attributes.Add("class","blackheading");
					td = new HtmlTableCell(); //Output <TD>
						td.Attributes.Add("colspan","7");
						td.InnerHtml = "Server(s) Found";
					tr.Cells.Add(td);         //Output </TD>
				vlanTbl.Rows.Add(tr);           //Output </TR>
				tr = new HtmlTableRow();    //Output <TR>
					tr.Attributes.Add("class","tableheading");
					td = new HtmlTableCell(); //Output <TD>
						td.InnerHtml = "Address";
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						td.InnerHtml = "Hostname";
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						td.InnerHtml = "Row/Cabinet";
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						td.InnerHtml = "BC";
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						td.InnerHtml = "Slot";
					tr.Cells.Add(td);         //Output </TD>
				vlanTbl.Rows.Add(tr);           //Output </TR>
				foreach (DataTable dtt in dat.Tables)
				{
					foreach (DataRow drr in dtt.Rows)
					{
						tr = new HtmlTableRow();    //Output <TR>
						if (fill) tr.Attributes.Add("class","altrow");
							td = new HtmlTableCell(); //Output <TD>
								if (fix_ip(fix_ip(drr["serverLanIp"].ToString()))=="")
								{
									if (v_userclass=="3" || v_userclass=="99") 
									{
										if (v_userrole.Contains("dns") || v_userrole.Contains("super"))
										{
											td.InnerHtml = "<DIV style='text-align:center'><A class='black' href='javascript:{}'	onclick=javascript:window.open('assnIp.aspx?host="+drr["serverName"].ToString()+"','assnIpWin','width=315,height=600,menubar=no,status=yes')\">Assign IP</A></DIV>";
										}
										else
										{
											td.InnerHtml = "<DIV style='text-align:center'>Undocumented</DIV>";
										}
									}
									else
									{
										td.InnerHtml = "<DIV style='text-align:center'>Undocumented</DIV>";
									}
								}
								else
								{
									td.InnerHtml = fix_ip(fix_ip(drr["serverLanIp"].ToString()));
								}
							tr.Cells.Add(td);         //Output </TD>
							td = new HtmlTableCell(); //Output <TD>
							if (v_userclass=="3" || v_userclass=="99")
							{
								td.InnerHtml = "<A class='black' href='javascript:{}' onclick=javascript:window.open('editServer.aspx?host="+drr["serverName"].ToString()+"','editServerWin','width=300,height=700,menubar=no,status=yes')\">"+drr["serverName"].ToString()+"</A>";
							}
							else
							{
								td.InnerHtml = "<A class='black' href='javascript:{}' onclick=javascript:window.open('showServer.aspx?host="+drr["serverName"].ToString()+"','showServerWin','width=300,height=550,menubar=no,status=yes')\">"+drr["serverName"].ToString()+"</A>";
							}
							tr.Cells.Add(td);         //Output </TD>
							td = new HtmlTableCell(); //Output <TD>
								if (drr["rack"].ToString()=="")
								{
									td.InnerHtml = "&#xa0;";
								}
								else
								{
									td.InnerHtml = "Row:"+drr["rack"].ToString().Substring(0,2)+", Cabinet:"+drr["rack"].ToString().Substring(2,2);
								}
							tr.Cells.Add(td);         //Output </TD>
							td = new HtmlTableCell(); //Output <TD>
								if (drr["bc"].ToString()=="")
								{
									td.InnerHtml = "&#xa0;";
								}
								else
								{
									td.InnerHtml = drr["bc"].ToString();
								}
							tr.Cells.Add(td);         //Output </TD>
							td = new HtmlTableCell(); //Output <TD>
								if (drr["slot"].ToString()=="")
								{
									td.InnerHtml = "&#xa0;";
								}
								else
								{
									td.InnerHtml = drr["slot"].ToString();
								}
							tr.Cells.Add(td);         //Output </TD>
						vlanTbl.Rows.Add(tr);           //Output </TR>
						fill=!fill;
					}
				}
			}
			else
			{
				tr = new HtmlTableRow();    //Output <TR>
					tr.Attributes.Add("class","blackheading");
					td = new HtmlTableCell(); //Output <TD>
						td.Attributes.Add("colspan","7");
						if(v_searchWord!="") td.InnerHtml = v_searchWord+" Not Found";
					tr.Cells.Add(td);         //Output </TD>
				vlanTbl.Rows.Add(tr);           //Output </TR>
			}
		}	searchWord.Value = string.Empty;
	searchFrom.SelectedIndex = -1; 
}

public void Page_Load(Object o, EventArgs e)
{
//UNCOMMENT this line to force login to access this page.
	lockout(); Page.Header.Title=shortSysName+": Manage Subnets & IPs";
	systemStatus(0); // Check to see if admin has put system is in offline mode.

//START Check if user is logged in by checking existence of cookie.
	loggedin.InnerHtml=loggedIn();
	adminMenu.InnerHtml=isAdmin();

	string sqlDialect=System.Configuration.ConfigurationManager.AppSettings["db_type"].ToString().ToUpper();

	HtmlTableRow tr;
	HtmlTableCell td;
	bool fill;

	string sqlVlan="", vlan, sql, v_userclass, v_userrole="", defaultDc="", sqlTablePrefix="";
	DataSet datVlan;
	DataSet dat = new DataSet();
	string addSvrStr="";

/*--- MODIFY THE RACKS TABLES
	ALTER TABLE kcdc_subnets ADD dcPrefix NVARCHAR(10) DEFAULT 'kcdc_'
	UPDATE kcdc_subnets SET dcPrefix='kcdc_'   
	ALTER TABLE abqdc_subnets ADD dcPrefix NVARCHAR(10) DEFAULT 'abqdc_'
	UPDATE abqdc_subnets SET dcPrefix='abqdc_' 
*/

	sql="SELECT * FROM datacenters ORDER BY dcDesc ASC";
	dat=readDb(sql);
	string optionDesc="", optionVal="", dcPrefix="";
	if (dat!=null)
	{
		foreach(DataRow dr in dat.Tables[0].Rows)
		{
			if (dr["dcDesc"].ToString().Length>24)
			{
				optionDesc=dr["dcDesc"].ToString().Substring(0,20)+"...";
			}
			else
			{
				optionDesc=dr["dcDesc"].ToString();
			}
			optionVal=dr["dcPrefix"].ToString();
			ListItem lfind = null;
			lfind = dcSelector.Items.FindByValue(dr["dcPrefix"].ToString());
			if (lfind==null)
			{
				ListItem ladd = new ListItem(optionDesc, optionVal);
				dcSelector.Items.Add(ladd);
			}
		}	
	}
	int countVlan;

	string v_hostname="";
	string v_ip="";
	
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
		defaultDc = Request.Cookies["selectedDc"].Value;
	}
	catch (System.Exception ex)
	{
		defaultDc = "";
	}

	if (defaultDc=="*" || defaultDc=="")
	{
		sqlTablePrefix="*";
	}
	else
	{
		sqlTablePrefix=defaultDc;
	}
	titleSpan.InnerHtml="<SPAN class='heading1'>Manage IP Addresses</SPAN>";

	if (v_userclass=="3" || v_userclass=="99")
	{
		if (v_userrole.Contains("dns") || v_userclass=="99" )
		{
			if (sqlTablePrefix!="*")
			{
				addSvrStr = addSvrStr+"<BUTTON id='addNewSubnetButn'  onclick=\"window.open('newSubnet.aspx?dcArg="+sqlTablePrefix+"','newSubnetWin','width=400,height=350,menubar=no,status=yes,scrollbars=yes') \"><IMG src='./img/addIcon16.png' alt=''/>&nbsp; Add New Subnet &nbsp;</BUTTON>&nbsp; &nbsp; &nbsp;<BUTTON id='addNewVipButn'  onclick=\"window.open('newVip.aspx?dc="+sqlTablePrefix+"','newVIPWin','width=400,height=450,menubar=no,status=yes,scrollbars=yes')\"><IMG src='./img/addIcon16.png' alt=''/>&nbsp; Add New VIP &nbsp;</BUTTON>";
			}
			else
			{
				addSvrStr = addSvrStr+"<TABLE style='width:40%;' class='datatable center'><TR class='linktable'><TD style='width:150px;'><SPAN class='italic'>NOTE: Choose a datacenter to <BR/>add a new subnet.</SPAN></TD></TR></TABLE>";
			}
			addSubnet.InnerHtml=addSvrStr;
		}
	}

	if (!IsPostBack)
	{
		string v_selectedDc="";
		try
		{
			v_selectedDc = Request.Cookies["selectedDc"].Value;
		}
		catch (System.Exception ex)
		{
			v_selectedDc = "";
		}
		dcSelector.SelectedIndex=dcSelector.Items.IndexOf(dcSelector.Items.FindByValue(v_selectedDc)); 

		try
		{
			vlan=Request.QueryString["vlan"].ToString();
		}
		catch (System.Exception ex)
		{
			vlan = "";
		}

		try
		{
			dcPrefix=Request.QueryString["dc"].ToString();
		}
		catch (System.Exception ex)
		{
			dcPrefix = "";
		}

		if (vlan!="")
		{
			showSubnet(vlan,dcPrefix);
		}
	}

	if (sqlTablePrefix=="*")
	{
		sql="SELECT dcPrefix FROM datacenters";
		dat=readDb(sql);
		if (dat!=null)
		{
			string newSql="";
			foreach (DataTable dt in dat.Tables)
			{
				foreach (DataRow dr in dt.Rows)
				{
					if (newSql!="")
					{
						newSql=newSql+" UNION ALL ";
					}
					newSql=newSql+"SELECT DISTINCT name, [desc], vlanId, dcPrefix FROM "+dr["dcPrefix"].ToString()+"subnets WHERE vlanId NOT LIKE '19%'";
				}
			}
//			Response.Write(newSql+"<BR/>");
			sqlVlan="SELECT * FROM ("+newSql+") AS ipPool ORDER BY [desc] DESC, vlanId DESC";
		}
	}
	else
	{
		sqlVlan = "SELECT DISTINCT name, [desc], vlanId, dcPrefix FROM "+defaultDc+"subnets WHERE vlanId NOT LIKE '19%' ORDER BY [desc] DESC, vlanId DESC";
	}
	
//	Response.Write(sqlVlan);
	datVlan = readDb(sqlVlan);
	if (datVlan!=null)
	{
		fill=false;
		tr = new HtmlTableRow();    //Output <TR>
		tr.Attributes.Add("class","blackheading");
			td = new HtmlTableCell(); //Output <TD>
				td.Attributes.Add("colspan","4");
				td.InnerHtml = "Browse Subnets";
			tr.Cells.Add(td);         //Output </TD>
		subnetTbl.Rows.Add(tr);           //Output </TR>
		countVlan = 1;
		foreach (DataTable dtVlan in datVlan.Tables)
		{
			foreach (DataRow drVlan in dtVlan.Rows)
			{	
				if (drVlan["name"].ToString()!="")
				{
					if (countVlan==1) tr = new HtmlTableRow();    //Output <TR>
					td = new HtmlTableCell(); //Output <TD>
						td.InnerHtml = "<A HREF='adminIPs.aspx?vlan="+drVlan["name"].ToString()+"&amp;dc="+drVlan["dcPrefix"].ToString()+"' title='"+drVlan["vlanId"].ToString()+" VLAN' class='nodec'>"+drVlan["dcPrefix"].ToString().ToUpper().Replace("_","")+": "+drVlan["desc"].ToString()+"</A>";
						td.Attributes.Add("class","green");
						td.Attributes.Add("style","width:99px;");
					tr.Cells.Add(td);         //Output </TD>
					if (countVlan==4)
					{
						vlanTbl.Rows.Add(tr);           //Output </TR>
						countVlan=1;
					}
					else
					{
						countVlan++;
					}	
				}
				subnetTbl.Rows.Add(tr);           //Output </TR>
			}
		}
	}

	if (IsPostBack)
	{
		sql="";
	}
}
</SCRIPT>
</HEAD>

<!--#include file="body.inc" -->
<FORM id="form1" runat="server">
<DIV id="container">
<!--#include file="banner.inc" -->
<!--#include file="menu.inc" -->
	<DIV id='content'>
		<SPAN id='titleSpan' runat='server'/>
		<A id=top>&nbsp;</A>
		<DIV class='center'>
			<TABLE class='center thinBorder' style='width:40%;'> <!-- Begin: Search Box -->
				<TR style='color: #ffffff; font-size:10pt; font-weight:bold; text-align:center; background-color:#669966'>
					<TD class='center'>Search</TD>
				</TR>
				<TR>
					<TD>
						<SELECT id='searchFrom' runat='server'>
							<OPTION value='serverName'>Hostname</OPTION>
							<OPTION value='serverLanIp'>Public IP</OPTION>
							<OPTION value='serverPurpose'>Purpose</OPTION>
							<OPTION value='serial'>Serial #</OPTION>
						</SELECT>
						&#xa0; for &#xa0;
						<INPUT type='text' id='searchWord' runat='server'>
					</TD>
				</TR>
				<TR>
					<TD class='center'>
						<asp:Button ID='searchButton' runat='server' Text='&nbsp; Find &nbsp;' OnClick='goSearch' />
					</TD>
				</TR>
			</TABLE> <!-- End: Search -->

			<DIV class='imgAlignMiddleCenter'>
				<BR/><BR/>
				<DIV id='addSubnet' class='imgAlignMiddleCenter' runat='server'/>
				<BR/><BR/><BR/>
			</DIV>
			<TABLE id='subnetTbl' runat='server' class='datatable center'></TABLE>

			<A id='detail'>$nbsp;</A>	
			<asp:Panel id='Panel1' runat='server' Height='25px' HorizontalAlign='right' BackColor='#ffffff'></asp:Panel>

			<BR/>
			<DIV id='hrSpan' runat='server'/>
			<BR/>
			<Chart:PieChart id='IPCapacityPieChart' alt='PieChart' runat='server' /><BR/><BR/>
			<TABLE id='vlanTbl' runat='server' class='datatable center' ></TABLE>
		</DIV>
	</DIV> <!-- End: content -->

<!--#include file="closer.inc"-->

</DIV> <!-- End: container -->
</FORM>
</BODY>
</HTML>