<%@Page Inherits="CIS.conspectisLibrary" src="conspectisLibrary.cs" Language="C#" debug="true" MaintainScrollPositionOnPostback="false"%>
<%@Import Namespace="System.Data"%>
<%@Import Namespace="System.Drawing"%>
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
/*	try
	{
		cookieVal=Request.Cookies["selectedDc"].Value;
	}
	catch (System.Exception ex)
	{
		cookieVal="";
	}	
	Response.Write(cookieVal+"<BR/>"); */
	Response.Write("<script type='text/JavaScript'>document.location.reload("+"true);<"+"/script>");
}

private void showBc()
{
	string sql,sql1;
	DataSet dat, dat1;
//	int bcLimit=16, bcNum=1, slotLimit=14, slotNum=1, curSlot=1, index=0;
	bool emptySlot=false;
	string bc;
	HtmlTableRow tr;
	HtmlTableCell td;
	bool fill;
	string v_userclass="", v_userrole="", actionString="", rackString="", dcPrefix="";
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
		bc=Request.QueryString["bc"].ToString();
	}
	catch (System.Exception ex)
	{
		bc = "";
	}	

	try
	{
		dcPrefix=Request.QueryString["dc"].ToString();
	}
	catch (System.Exception ex)
	{
		dcPrefix = "";
	}

	if (bc!="")
	{
		hrSpan.InnerHtml ="<HR class='dotted'>";

		sql="SELECT * FROM (SELECT * FROM "+dcPrefix+"rackspace WHERE bc='"+bc+"' AND slot<>'00') AS hwData WHERE model<>'ESX' AND reserved<>'1' ORDER BY slot ASC";
		dat=readDb(sql);

		ViewState["exportStr"] = "bc";
		ViewState["sqlArg"] = bc;

		//Place Export Button in Panel on Web Page
		ImageButton eb = new ImageButton();
		eb.ID = "exportButton";
		eb.ImageUrl = "./img/export.png";
		eb.Width = 110;
		eb.Height= 25;
		eb.AlternateText="Export to CSV";
		eb.BackColor=(System.Drawing.Color)colConvert.ConvertFromString("#FFFFFF");
		eb.Click += new ImageClickEventHandler(Export_Click);
		Panel1.Controls.Add(eb); 

		//Place Printable View Button in Panel on Web Page
		ImageButton pb = new ImageButton();
		pb.ID = "printableButton";
		pb.ImageUrl = "./img/print.png";
		pb.Width = 125;
		pb.Height= 25;
		pb.AlternateText="Show Printable View";
		pb.BackColor=(System.Drawing.Color)colConvert.ConvertFromString("#FFFFFF");
//		pb.Attributes.Add("language", "javascript");
		pb.Attributes.Add("OnClick", "window.open('print.aspx?bc="+bc+"&amp;dc="+dcPrefix+"','printableWin','width=600,menubar=no,status=yes,scrollbars=yes')");
		Panel1.Controls.Add(pb); 

		string sqlRack="";
		DataSet datRack=new DataSet();
		sqlRack="SELECT location, rackId FROM "+dcPrefix+"racks WHERE RackId='"+dat.Tables[0].Rows[0]["rack"].ToString()+"'";
//		Response.Write(sqlRack+"<BR/>");
		datRack=readDb(sqlRack);
		if (datRack!=null)
		{
			try
			{
				rackString=datRack.Tables[0].Rows[0]["location"].ToString()+"-R"+datRack.Tables[0].Rows[0]["rackId"].ToString().Substring(0,2)+"-C"+datRack.Tables[0].Rows[0]["rackId"].ToString().Substring(2,2);
			}
			catch (System.Exception ex)
			{
				rackString="ERR";
			}
		}
//		rackString="Cabinet: "+dat.Tables[0].Rows[0]["rack"].ToString().Substring(2,2);

		if (dat!=null)
		{
			fill=false;
			tr = new HtmlTableRow();    //Output <TR>
				tr.Attributes.Add("class","blackheading");
				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("colspan","6");
					td.InnerHtml = dcPrefix.ToUpper().Replace("_","")+" BladeCenter #"+bc+", "+rackString;
				tr.Cells.Add(td);         //Output </TD>
			svrTbl.Rows.Add(tr);           //Output </TR>
			tr = new HtmlTableRow();    //Output <TR>
				tr.Attributes.Add("class","tableheading");
				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("class","serverNameCol");
					td.InnerHtml = "HostName";
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("class","serverIpCol");
					td.InnerHtml = "Public IP";
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("class","serverOsCol");
					td.InnerHtml = "OS";
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("class","serverPurposeCol");
					td.InnerHtml = "Purpose";
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("class","serverSlotCol");
					td.InnerHtml = "Slot";
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("class","serverActionCol");
					td.InnerHtml = "Actions";
				tr.Cells.Add(td);         //Output </TD>
			svrTbl.Rows.Add(tr);           //Output </TR>	
			foreach (DataTable dtt in dat.Tables)
			{
				foreach (DataRow drr in dtt.Rows)
				{
					sql1="SELECT serverName, serverLanIP, serverOS, serverPurpose, rack, bc, slot, "+dcPrefix+"servers.rackspaceId, belongsTo, reserved FROM "+dcPrefix+"servers INNER JOIN "+dcPrefix+"rackspace ON "+dcPrefix+"servers.rackspaceId="+dcPrefix+"rackspace.rackspaceId WHERE "+dcPrefix+"servers.rackspaceId="+drr["rackspaceId"].ToString()+" AND serverOS NOT IN ('RSA2','Network')";
//					Response.Write(sql1+"<BR/>");
					dat1=readDb(sql1);
					actionString="";
					tr = new HtmlTableRow();    //Output <TR>
					if (fill) tr.Attributes.Add("class","altrow");
						td = new HtmlTableCell(); //Output <TD>
							td.Attributes.Add("class","serverName serverNameCol");
							if (v_userclass=="3" || v_userclass=="99")
							{
								if (dat1==null)
								{
									if (v_userrole.Contains("manager") || v_userclass=="99" )
									{
										td.InnerHtml = "<P class='link' onclick=\"window.open('newServer.aspx?rackspace="+drr["rackspaceId"].ToString()+"&amp;dc="+dcPrefix+"','editServerWin','width=400,height=800,menubar=no,status=yes,scrollbars=yes')\">New Server</P>";
									}
								}
								else
								{
									td.InnerHtml = "<P class='link' onclick=\"window.open('editServer.aspx?host="+dat1.Tables[0].Rows[0]["serverName"].ToString()+"&amp;dc="+dcPrefix+"','editServerWin','width=400,height=750,menubar=no,status=yes,scrollbars=yes')\">"+dat1.Tables[0].Rows[0]["serverName"].ToString()+"</P>";
								}
							}
							else
							{
								if (dat1==null)
								{
									if (v_userrole.Contains("datacenter"))
									{
										td.InnerHtml="<P class='link' onclick=\"window.open('editCabling.aspx?id="+drr["rackspaceId"].ToString()+"&amp;dc="+dcPrefix+"','editCablingWin','width=400,height=800,menubar=no,status=yes') ALT='Edit Cabling'>Edit Cabling</P>";
									}
									else
									{
										td.InnerHtml = "Unassigned";
									}
								}
								else
								{
									td.InnerHtml = "<P class='link' onclick=\"window.open('showServer.aspx?host="+dat1.Tables[0].Rows[0]["serverName"].ToString()+"&amp;dc="+dcPrefix+"','showServerWin','width=350,height=700,menubar=no,status=yes,scrollbars=yes')\">"+dat1.Tables[0].Rows[0]["serverName"].ToString()+"</A>";
								}
							}
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
							td.Attributes.Add("class","serverIp serverIpCol");
							if (dat1!=null)
							{
								if (dat1.Tables[0].Rows[0]["serverLanIp"].ToString()=="")
								{
									if (v_userrole.Contains("dns") || v_userclass=="99")
									{
										td.InnerHtml = "<P class='link' onclick=\"window.open('assnIp.aspx?host="+dat1.Tables[0].Rows[0]["serverName"].ToString()+"&amp;dc="+dcPrefix+"','assnIpWin','width=350,height=600,menubar=no,status=yes')\">Assign IP</A></DIV>";
									}
									else
									{
										td.InnerHtml = "<DIV style='text-align:center'>Undocumented</DIV>";
									}
								}
								else
								{
									td.InnerHtml = fix_ip(dat1.Tables[0].Rows[0]["serverLanIp"].ToString());
								}
							}
							else
							{
								td.InnerHtml = "&#xa0;";
							}
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
							td.Attributes.Add("class","serverOs serverOsCol");
							if (dat1==null)
							{
								td.InnerHtml = "&#xa0;";
							}
							else
							{
								td.InnerHtml = dat1.Tables[0].Rows[0]["serverOS"].ToString();
							}
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
							td.Attributes.Add("class","serverPurpose serverPurposeCol");
							if (dat1==null)
							{
								td.InnerHtml = "&#xa0;";
							}
							else
							{
								if (dat1.Tables[0].Rows[0]["serverPurpose"].ToString()!="" && dat1.Tables[0].Rows[0]["serverPurpose"].ToString()!=null)
								{
									td.InnerHtml = dat1.Tables[0].Rows[0]["serverPurpose"].ToString();
								}
								else
								{
									td.InnerHtml = "&#xa0;";
								}
							}
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
							td.Attributes.Add("class","serverSlot serverSlotCol");
							if (drr["slot"].ToString()=="")
							{
								td.InnerHtml = "&#xa0;";
							}
							else
							{
								td.InnerHtml = drr["slot"].ToString();
							}
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
							td.Attributes.Add("class","serverAction serverActionCol");
							if (dat1!=null)
							{
								if (v_userclass=="3" || v_userclass=="99")
								{
									if (v_userrole.Contains("datacenter"))
									{
										actionString=actionString+"<INPUT type='image' src='./img/cableServer.png' onclick=\"window.open('editCabling.aspx?id="+dat1.Tables[0].Rows[0]["rackspaceId"].ToString()+"&amp;dc="+dcPrefix+"','cableServerWin','width=400,height=600,menubar=no,status=yes,scrollbars=yes')\" ALT='Cable Server' />&#xa0;";
									}
									if (dat1.Tables[0].Rows[0]["bc"].ToString()!="" && dat1.Tables[0].Rows[0]["bc"].ToString()!=null)
									{
										actionString=actionString+"<INPUT type='image' src='./img/move.png' onclick=\"window.open('moveServer.aspx?host="+dat1.Tables[0].Rows[0]["rackspaceId"].ToString()+"&amp;dc="+dcPrefix+"','moveServerWin','width=350,height=350,menubar=no,status=yes,scrollbars=yes')\" ALT='Move/Swap Server' />&#xa0;";
									}
									if (dat1.Tables[0].Rows[0]["serverLanIp"].ToString()!="")
									{
										actionString = actionString+"<INPUT type='image' src='./img/recycle.png' onclick=\"window.open('recycleServer.aspx?host="+dat1.Tables[0].Rows[0]["serverName"].ToString()+"&amp;dc="+dcPrefix+"','recycleServerWin','width=350,height=750,menubar=no,status=yes,scrollbars=yes')\" ALT='Recycle Server' />&#xa0;<INPUT type='image' src='./img/delete.png' onclick=\"window.open('deleteServer.aspx?host="+dat1.Tables[0].Rows[0]["serverName"].ToString()+"&amp;dc="+dcPrefix+"','deleteServerWin','width=350,height=275,menubar=no,status=yes')\" ALT='Delete Server' />&#xa0;";
										if (dat1.Tables[0].Rows[0]["serverName"].ToString().StartsWith("SL") || dat1.Tables[0].Rows[0]["serverName"].ToString().StartsWith("ZL") || dat1.Tables[0].Rows[0]["serverName"].ToString().StartsWith("SB") || dat1.Tables[0].Rows[0]["serverName"].ToString().StartsWith("SV"))
										{
											actionString=actionString+"<INPUT type='image' src='./img/remote.png' onclick=\"runClient('NIX','"+fix_ip(dat1.Tables[0].Rows[0]["serverLanIp"].ToString())+"') \" ALT='Open Putty Session' />";
										}
										if (dat1.Tables[0].Rows[0]["serverName"].ToString().StartsWith("SX") || dat1.Tables[0].Rows[0]["serverName"].ToString().StartsWith("ZX"))
										{
											actionString=actionString+"<INPUT type='image' src='./img/remote.png' onclick=\"runClient('WIN','"+fix_ip(dat1.Tables[0].Rows[0]["serverLanIp"].ToString())+"')\" ALT='Open RDP Session' />";
										}
										if (dat1.Tables[0].Rows[0]["serverName"].ToString().StartsWith("RS") || dat1.Tables[0].Rows[0]["serverName"].ToString().StartsWith("BC"))
										{
											actionString=actionString+"<INPUT type='image' src='./img/remote.png' onclick=\"window.open('http://"+fix_ip(dat1.Tables[0].Rows[0]["serverLanIp"].ToString())+"/','rsaWin','width=800,height=600,menubar=no,status=yes,scrollbars=yes')\" ALT='Open RSA2-AMM Session' />&#xa0;";
										}
										td.InnerHtml=actionString;
									}
									else
									{
										td.InnerHtml = "<INPUT type='image' src='./img/delete.png' onclick=\"window.open('deleteServer.aspx?host="+dat1.Tables[0].Rows[0]["serverName"].ToString()+"&amp;dc="+dcPrefix+"','deleteServerWin','width=350,height=275,menubar=no,status=yes')\" ALT='Delete Server' />";
									}
								}
								else
								{
									td.InnerHtml = "&#xa0;";
								}
							}
							else
							{
								if (v_userrole.Contains("datacenter"))
								{
									actionString=actionString+"<INPUT type='image' src='./img/cableServer.png' onclick=\"window.open('editCabling.aspx?id="+drr["rackspaceId"].ToString()+"&amp;dc="+dcPrefix+"','cableServerWin','width=400,height=600,menubar=no,status=yes,scrollbars=yes')\" ALT='Cable Server' />&#xa0;";
									td.InnerHtml=actionString;
								}
								else
								{
									td.InnerHtml = "&#xa0;";
								}	
							}
						tr.Cells.Add(td);         //Output </TD> 
					svrTbl.Rows.Add(tr);           //Output </TR>
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
					td.InnerHtml = "BladeCenter #"+bc;
				tr.Cells.Add(td);         //Output </TD>
			svrTbl.Rows.Add(tr);           //Output </TR>
			tr = new HtmlTableRow();    //Output <TR>
				tr.Attributes.Add("class","tableheading");
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml = "No servers or available rackspace found.";
				tr.Cells.Add(td);         //Output </TD>
			svrTbl.Rows.Add(tr);           //Output </TR>
		}		
	}
}

private void showRack()
{
	string sql,sql1, sql2;
	
//	int bcLimit=16, bcNum=1, slotLimit=14, slotNum=1, curSlot=1, index=0;
	int rowCount=0;
//	bool emptySlot=false;
	string rack, order, notBcRacks="";
	HtmlTableRow tr;
	HtmlTableCell td;
	bool fill, mixedOrBc;
	string v_userclass="", v_userrole="", actionString="", dcPrefix="", rackString="";
	ColorConverter colConvert = new ColorConverter();
	DataSet dat = new DataSet();
	DataSet dat1 = new DataSet();
	DataSet slotBcDat = new DataSet();

	string sqlDialect=System.Configuration.ConfigurationManager.AppSettings["db_type"].ToString().ToUpper();

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
		rack=Request.QueryString["rack"].ToString();
	}
	catch (System.Exception ex)
	{
		rack = "";
	}	

	try
	{
		dcPrefix=Request.QueryString["dc"].ToString();
	}
	catch (System.Exception ex)
	{
		dcPrefix = "";
	}

	mixedOrBc=false;

//	Response.Write("Works! "+rack);
	if (rack!="")
	{
		hrSpan.InnerHtml ="<HR class='dotted'>";

		rowCount=0;
//		dat=null;
//		dat1=null;

		sql2="SELECT COUNT(*) FROM (SELECT * FROM "+dcPrefix+"rackspace WHERE rack='"+rack+"' AND bc IS NOT NULL) AS a WHERE model<>'ESX' AND reserved<>'1'";
//		Response.Write(sql2+"<BR/>");
		slotBcDat=readDb(sql2);
		if (slotBcDat!=null)
		{
			try
			{
				switch (sqlDialect)
				{
					case "MSJET":
						rowCount=Convert.ToInt32(slotBcDat.Tables[0].Rows[0]["Expr1000"].ToString());
					break;
					case "MSSQL":
						rowCount=Convert.ToInt32(slotBcDat.Tables[0].Rows[0]["Column1"].ToString());
					break;
				}
			}
			catch (System.Exception ex)
			{
				rowCount=0;
			}
			
		}
		
		if (rowCount>0)
		{
			mixedOrBc=true;
		}
		else
		{
			mixedOrBc=false;
		}

		if (mixedOrBc)
		{
			sql="SELECT * FROM (SELECT * FROM (SELECT * FROM "+dcPrefix+"rackspace WHERE rack='"+rack+"' AND slot<>'00') AS a WHERE bc IS NULL) WHERE reserved<>'1' ORDER BY slot DESC";
			sql1="SELECT * FROM (SELECT * FROM "+dcPrefix+"rackspace WHERE rack='"+rack+"' AND slot<>'00') AS a WHERE bc IS NOT NULL AND model<>'ESX' AND reserved<>'1' ORDER BY bc ASC, slot ASC";
//			Response.Write(sql+"<BR/>");
//			Response.Write(sql1+"<BR/>");
			dat=readDb(sql);
			dat1=readDb(sql1);
			if (dat!=null)
			{
				dat.Merge(dat1);
			}
			else
			{
				dat=dat1;
			}		
		}
		else
		{
			sql="SELECT * FROM (SELECT * FROM (SELECT * FROM "+dcPrefix+"rackspace WHERE rack='"+rack+"' AND slot<>'00') AS a WHERE bc IS NULL) AS b WHERE model<>'ESX' AND reserved<>'1' ORDER BY slot DESC";
//			Response.Write(sql+"<BR/>");
			dat=readDb(sql);
		}

		ViewState["exportStr"] = "rack";
		ViewState["sqlArg"] = rack;

		//Place Export Button in Panel on Web Page
		ImageButton ib = new ImageButton();
		ib.ID = "exportButton";
		ib.ImageUrl = "./img/export.png";
		ib.Width = 110;
		ib.Height= 25;
		ib.AlternateText="Export to CSV";
		ib.BackColor=(System.Drawing.Color)colConvert.ConvertFromString("#FFFFFF");
//		ib.OnClick="Export_Click";
		ib.Click += new ImageClickEventHandler(Export_Click);
		Panel1.Controls.Add(ib); 

		//Place Printable View Button in Panel on Web Page
		ImageButton pb = new ImageButton();
		pb.ID = "printableButton";
		pb.ImageUrl = "./img/print.png";
		pb.Width = 125;
		pb.Height= 25;
		pb.AlternateText="Show Printable View";
		pb.BackColor=(System.Drawing.Color)colConvert.ConvertFromString("#FFFFFF");
//		pb.Attributes.Add("language", "javascript");
		pb.Attributes.Add("OnClick", "window.open('print.aspx?rack="+rack+"&amp;dc="+dcPrefix+"','printableWin','width=600,menubar=no,status=yes,scrollbars=yes')");
		Panel1.Controls.Add(pb);  

		string sqlRack="";
		DataSet datRack=new DataSet();
		sqlRack="SELECT location, rackId FROM "+dcPrefix+"racks WHERE rackId='"+rack+"'";
//		Response.Write(sqlRack+"<BR/>");
		datRack=readDb(sqlRack);
		if (datRack!=null)
		{
			try
			{
				rackString=datRack.Tables[0].Rows[0]["location"].ToString()+"-R"+datRack.Tables[0].Rows[0]["rackId"].ToString().Substring(0,2)+"-C"+datRack.Tables[0].Rows[0]["rackId"].ToString().Substring(2,2);
			}
			catch (System.Exception ex)
			{
				rackString="ERR";
			}
		}		

//		rackString="Cabinet: "+dat.Tables[0].Rows[0]["rack"].ToString().Substring(2,2);

		if (dat!=null)
		{
			fill=false;
			tr = new HtmlTableRow();    //Output <TR>
				tr.Attributes.Add("class","blackheading");
				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("colspan","7");
					td.InnerHtml = rackString;
				tr.Cells.Add(td);         //Output </TD>
			svrTbl.Rows.Add(tr);           //Output </TR>
			tr = new HtmlTableRow();    //Output <TR>
				tr.Attributes.Add("class","tableheading");
				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("class","serverNameCol");
					td.InnerHtml = "HostName";
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("class","serverIpCol");
					td.InnerHtml = "Public IP";
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("class","serverOsCol");
					td.InnerHtml = "OS";
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("class","serverPurposeCol");
					td.InnerHtml = "Purpose";
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("class","serverBcCol");
					td.InnerHtml = "BC";
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("class","serverSlotCol");
					td.InnerHtml = "Slot";
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("class","serverActionsCol");
					td.InnerHtml = "Actions";
				tr.Cells.Add(td);         //Output </TD>
			svrTbl.Rows.Add(tr);           //Output </TR>
			foreach (DataTable dtt in dat.Tables)
			{
				foreach (DataRow drr in dtt.Rows)
				{
					sql1="SELECT serverName, serverLanIP, serverOS, serverPurpose, rack, bc, slot, "+dcPrefix+"servers.rackspaceId, belongsTo, reserved FROM "+dcPrefix+"servers INNER JOIN "+dcPrefix+"rackspace ON "+dcPrefix+"servers.rackspaceId="+dcPrefix+"rackspace.rackspaceId WHERE "+dcPrefix+"servers.rackspaceId="+drr["rackspaceId"].ToString()+" AND serverOS NOT IN ('RSA2','Network')";
//					Response.Write(sql1);
					dat1=readDb(sql1);
					actionString="";
					tr = new HtmlTableRow();    //Output <TR>
					if (fill) tr.Attributes.Add("class","altrow");
						td = new HtmlTableCell(); //Output <TD>
							td.Attributes.Add("class","serverName serverNameCol");
							if (v_userclass=="3" || v_userclass=="99")
							{
								if (dat1==null)
								{
									if (v_userrole.Contains("manager") || v_userclass=="99" )
									{
										td.InnerHtml = "<P class='link' onclick=\"window.open('newServer.aspx?rackspace="+drr["rackspaceId"].ToString()+"&amp;dc="+dcPrefix+"','editServerWin','width=400,height=800,menubar=no,status=yes,scrollbars=yes')\">New Server</P>";
									}
								}
								else
								{
									td.InnerHtml = "<P class='link' onclick=\"window.open('editServer.aspx?host="+dat1.Tables[0].Rows[0]["serverName"].ToString()+"&amp;dc="+dcPrefix+"','editServerWin','width=400,height=750,menubar=no,status=yes,scrollbars=yes')\">"+dat1.Tables[0].Rows[0]["serverName"].ToString()+"</P>";
								}
							}
							else
							{
								if (dat1==null)
								{
									if (v_userrole.Contains("datacenter"))
									{
										td.InnerHtml="<P class='link' onclick=\"window.open('editCabling.aspx?id="+drr["rackspaceId"].ToString()+"&amp;dc="+dcPrefix+"','editCablingWin','width=400,height=800,menubar=no,status=yes') ALT='Edit Cabling'>Edit Cabling</P>";
									}
									else
									{
										td.InnerHtml = "Unassigned";
									}
								}
								else
								{
									td.InnerHtml = "<P class='link' onclick=\"window.open('showServer.aspx?host="+dat1.Tables[0].Rows[0]["serverName"].ToString()+"&amp;dc="+dcPrefix+"','showServerWin','width=350,height=700,menubar=no,status=yes,scrollbars=yes')\">"+dat1.Tables[0].Rows[0]["serverName"].ToString()+"</P>";
								}
							}
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
							td.Attributes.Add("class","serverIp serverIpCol");
							if (dat1!=null)
							{
								if (dat1.Tables[0].Rows[0]["serverLanIp"].ToString()=="")
								{
									if (v_userrole.Contains("dns") || v_userrole.Contains("super"))
									{
										td.InnerHtml = "<P class='link' onclick=\"window.open('assnIp.aspx?host="+dat1.Tables[0].Rows[0]["serverName"].ToString()+"&amp;dc="+dcPrefix+"','assnIpWin','width=350,height=600,menubar=no,status=yes')\">Assign IP</P>";
									}
									else
									{
										td.InnerHtml = "<DIV style='text-align:center'>Undocumented</DIV>";
									}
								}
								else
								{
									td.InnerHtml = fix_ip(dat1.Tables[0].Rows[0]["serverLanIp"].ToString());
								}
							}
							else
							{
								td.InnerHtml = "&#xa0;";
							}
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
							td.Attributes.Add("class","serverOs serverOsCol");
							if (dat1==null)
							{
								td.InnerHtml = "&#xa0;";
							}
							else
							{
								td.InnerHtml = dat1.Tables[0].Rows[0]["serverOS"].ToString();
							}
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
							td.Attributes.Add("class","serverPurpose serverPurposeCol");
							if (dat1==null)
							{
								td.InnerHtml = "&#xa0;";
							}
							else
							{
								if (dat1.Tables[0].Rows[0]["serverPurpose"].ToString()!="" && dat1.Tables[0].Rows[0]["serverPurpose"].ToString()!=null)
								{
									td.InnerHtml = dat1.Tables[0].Rows[0]["serverPurpose"].ToString();
								}
								else
								{
									td.InnerHtml = "&#xa0;";
								}
							}
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
							td.Attributes.Add("class","serverBc serverBcCol");
							if (dat1==null)
							{
								if (drr["bc"].ToString()!="" && drr["bc"].ToString()!=null)
								{
									td.InnerHtml = drr["bc"].ToString();
								}
								else
								{
									td.InnerHtml = "&#xa0;";
								}
							}
							else
							{
								if (dat1.Tables[0].Rows[0]["bc"].ToString()!="")
								{
									td.InnerHtml = dat1.Tables[0].Rows[0]["bc"].ToString();
								}
								else
								{
									td.InnerHtml="&#xa0;";
								}
								
							}
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
							td.Attributes.Add("class","serverSlot serverSlotCol");
							if (dat1==null)
							{
								if (drr["slot"].ToString()!="" && drr["slot"].ToString()!=null)
								{
									td.InnerHtml = drr["slot"].ToString();
								}
								else
								{
									td.InnerHtml = "&#xa0;";
								}
							}
							else
							{
								td.InnerHtml = dat1.Tables[0].Rows[0]["slot"].ToString();
							}
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
							td.Attributes.Add("class","serverAction serverActionCol");
							if (dat1!=null)
							{
								if (v_userclass=="3" || v_userclass=="99")
								{
									if (v_userrole.Contains("datacenter"))
									{
										actionString=actionString+"<INPUT type='image' src='./img/cableServer.png' onclick=\"window.open('editCabling.aspx?id="+dat1.Tables[0].Rows[0]["rackspaceId"].ToString()+"&amp;dc="+dcPrefix+"','cableServerWin','width=400,height=600,menubar=no,status=yes,scrollbars=yes')\" ALT='Cable Server' />&#xa0;";
									}
									if (dat1.Tables[0].Rows[0]["bc"].ToString()!="" && dat1.Tables[0].Rows[0]["bc"].ToString()!=null)
									{
										actionString=actionString+"<INPUT type='image' src='./img/move.png' onclick=\"window.open('moveServer.aspx?host="+dat1.Tables[0].Rows[0]["rackspaceId"].ToString()+"&amp;dc="+dcPrefix+"','moveServerWin','width=350,height=350,menubar=no,status=yes,scrollbars=yes')\" ALT='Move/Swap Server' />&#xa0;";
									}
									if (dat1.Tables[0].Rows[0]["serverLanIp"].ToString()!="")
									{
										actionString = actionString+"<INPUT type='image' src='./img/recycle.png' onclick=\"window.open('recycleServer.aspx?host="+dat1.Tables[0].Rows[0]["serverName"].ToString()+"&amp;dc="+dcPrefix+"','recycleServerWin','width=350,height=750,menubar=no,status=yes,scrollbars=yes')\" ALT='Recycle Server' />&#xa0;<INPUT type='image' src='./img/delete.png' onclick=\"window.open('deleteServer.aspx?host="+dat1.Tables[0].Rows[0]["serverName"].ToString()+"&amp;dc="+dcPrefix+"','deleteServerWin','width=350,height=275,menubar=no,status=yes')\" ALT='Delete Server' />&#xa0;";
										if (dat1.Tables[0].Rows[0]["serverName"].ToString().StartsWith("SL") || dat1.Tables[0].Rows[0]["serverName"].ToString().StartsWith("ZL") || dat1.Tables[0].Rows[0]["serverName"].ToString().StartsWith("SB") || dat1.Tables[0].Rows[0]["serverName"].ToString().StartsWith("SV"))
										{
											actionString=actionString+"<INPUT type='image' src='./img/remote.png' onclick=\"runClient('NIX','"+fix_ip(dat1.Tables[0].Rows[0]["serverLanIp"].ToString())+"')\" ALT='Open Putty Session' />";
										}
										if (dat1.Tables[0].Rows[0]["serverName"].ToString().StartsWith("SX") || dat1.Tables[0].Rows[0]["serverName"].ToString().StartsWith("ZX"))
										{
											actionString=actionString+"<INPUT type='image' src='./img/remote.png' onclick=\"runClient('WIN','"+fix_ip(dat1.Tables[0].Rows[0]["serverLanIp"].ToString())+"')\" ALT='Open RDP Session' />";
										}
										if (dat1.Tables[0].Rows[0]["serverName"].ToString().StartsWith("RS") || dat1.Tables[0].Rows[0]["serverName"].ToString().StartsWith("BC"))
										{
											actionString=actionString+"<INPUT type='image' src='./img/remote.png' onclick=\"window.open('http://"+fix_ip(dat1.Tables[0].Rows[0]["serverLanIp"].ToString())+"/','rsaWin','width=800,height=600,menubar=no,status=yes,scrollbars=yes')\" ALT='Open RSA2-AMM Session' />&#xa0;";
										}
										td.InnerHtml=actionString;
									}
									else
									{
										actionString=actionString+"<INPUT type='image' src='./img/delete.png' onclick=\"window.open('deleteServer.aspx?host="+dat1.Tables[0].Rows[0]["serverName"].ToString()+"&amp;dc="+dcPrefix+"','deleteServerWin','width=350,height=275,menubar=no,status=yes')\" ALT='Delete Server' />";
									}
									td.InnerHtml=actionString;
								}
								else
								{
									td.InnerHtml = "&#xa0;";
								}
							}
							else
							{
								if (v_userrole.Contains("datacenter"))
								{
									actionString=actionString+"<INPUT type='image' src='./img/cableServer.png' onclick=\"window.open('editCabling.aspx?id="+drr["rackspaceId"].ToString()+"&amp;dc="+dcPrefix+"','cableServerWin','width=400,height=600,menubar=no,status=yes,scrollbars=yes')\" ALT='Cable Server' />&#xa0;";
									td.InnerHtml=actionString;
								}
								else
								{
									td.InnerHtml = "&#xa0;";
								}								
							}
						tr.Cells.Add(td);         //Output </TD> 
					svrTbl.Rows.Add(tr);           //Output </TR>
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
					td.InnerHtml = "Rack #"+rack;
				tr.Cells.Add(td);         //Output </TD>
			svrTbl.Rows.Add(tr);           //Output </TR>
			tr = new HtmlTableRow();    //Output <TR>
				tr.Attributes.Add("class","tableheading");
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml = "No servers or available rackspace found.";
				tr.Cells.Add(td);         //Output </TD>
			svrTbl.Rows.Add(tr);           //Output </TR>
		}
	}
}

private void showOs()
{
	string sql,sql1;
	DataSet dat, dat1;
	int bcLimit=16, bcNum=1, slotLimit=14, slotNum=1, curSlot=1, index=0;
	bool emptySlot=false;
	string os, order;
	HtmlTableRow tr;
	HtmlTableCell td;
	bool fill;
	string v_userclass="", v_userrole="", actionString="";
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
		os=Request.QueryString["os"].ToString();
	}
	catch (System.Exception ex)
	{
		os = "";
	}	

	string dcPrefix="";
	try
	{
		dcPrefix=Request.QueryString["dc"].ToString();
	}
	catch (System.Exception ex)
	{
		dcPrefix = "";
	}

	if (os!="")
	{
		hrSpan.InnerHtml ="<HR class='dotted'>";

		if (dcPrefix=="*")
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
						newSql=newSql+"SELECT serverName, serverLanIP, serverOS, serverPurpose, rack, bc, slot, dcPrefix, "+dr["dcPrefix"].ToString()+"rackspace.rackspaceId, VMId, reserved FROM "+dr["dcPrefix"].ToString()+"servers LEFT JOIN "+dr["dcPrefix"].ToString()+"rackspace ON "+dr["dcPrefix"].ToString()+"servers.rackspaceId="+dr["dcPrefix"].ToString()+"rackspace.rackspaceId WHERE serverOS='"+os+"'";
					}
				}
				sql="SELECT * FROM ("+newSql+") AS a ORDER BY servername ASC, rack ASC";
			}
		}
		else
		{
			sql = "SELECT * FROM (SELECT serverName, serverLanIP, serverOS, serverPurpose, rack, bc, slot, dcPrefix, "+dcPrefix+"rackspace.rackspaceId, VMId, reserved FROM "+dcPrefix+"servers LEFT JOIN "+dcPrefix+"rackspace ON "+dcPrefix+"servers.rackspaceId="+dcPrefix+"rackspace.rackspaceId WHERE serverOS='"+os+"') AS a ORDER BY servername ASC, rack ASC";
		}

		ViewState["exportStr"] = "os";
		ViewState["sqlArg"] = os;
		
		//Place Export Button in Panel on Web Page
		ImageButton ib = new ImageButton();
		ib.ID = "exportButton";
		ib.ImageUrl = "./img/export.png";
		ib.Width = 110;
		ib.Height= 25;
		ib.AlternateText="Export to CSV";
		ib.BackColor=(System.Drawing.Color)colConvert.ConvertFromString("#FFFFFF");
//		ib.OnClick="Export_Click";
		ib.Click += new ImageClickEventHandler(Export_Click);
		Panel1.Controls.Add(ib); 

		//Place Printable View Button in Panel on Web Page
		ImageButton pb = new ImageButton();
		pb.ID = "printableButton";
		pb.ImageUrl = "./img/print.png";
		pb.Width = 125;
		pb.Height= 25;
		pb.AlternateText="Show Printable View";
		pb.BackColor=(System.Drawing.Color)colConvert.ConvertFromString("#FFFFFF");
//		pb.Attributes.Add("language", "javascript");
		pb.Attributes.Add("OnClick", "window.open('print.aspx?os="+os+"&amp;dc="+dcPrefix+"','printableWin','width=600,menubar=no,status=yes,scrollbars=yes')");
		Panel1.Controls.Add(pb); 
		
		dat=readDb(sql);
//		dat1=readDb(sql1);

		if (dat!=null)
		{
			fill=false;
			tr = new HtmlTableRow();    //Output <TR>
				tr.Attributes.Add("class","blackheading");
				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("colspan","8");
					td.InnerHtml = dcPrefix.ToUpper().Replace("*","").Replace("_","")+" "+os+" Servers";
				tr.Cells.Add(td);         //Output </TD>
			svrTbl.Rows.Add(tr);           //Output </TR>
			tr = new HtmlTableRow();    //Output <TR>
				tr.Attributes.Add("class","tableheading");
				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("class","serverNameCol");
					td.InnerHtml = "HostName";
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("class","serverIpCol");
					td.InnerHtml = "Public IP";
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("class","serverOsCol");
					td.InnerHtml = "OS";
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("class","serverPurposeCol");
					td.InnerHtml = "Purpose";
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("class","serverRackCol");
					td.InnerHtml = "Row/Cabinet";
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("class","serverBcCol");
					td.InnerHtml = "BC";
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("class","serverSlotCol");
					td.InnerHtml = "Slot";
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("class","serverActionCol");
					td.InnerHtml = "Actions";
				tr.Cells.Add(td);         //Output </TD>
			svrTbl.Rows.Add(tr);           //Output </TR>
			foreach (DataTable dtt in dat.Tables)
			{
				foreach (DataRow drr in dtt.Rows)
				{
					actionString="";
					tr = new HtmlTableRow();    //Output <TR>
					if (fill) tr.Attributes.Add("class","altrow");
						td = new HtmlTableCell(); //Output <TD>
							td.Attributes.Add("class","serverName serverNameCol");
							if (v_userclass=="3" || v_userclass=="99")
							{
								td.InnerHtml = "<P class='link' onclick=\"window.open('editServer.aspx?host="+drr["serverName"].ToString()+"&amp;dc="+dcPrefix+"','editServerWin','width=400,height=750,menubar=no,status=yes,scrollbars=yes')\">"+drr["serverName"].ToString()+"</P>";
							}
							else
							{
								td.InnerHtml = "<P class='link' onclick=\"window.open('showServer.aspx?host="+drr["serverName"].ToString()+"&amp;dc="+dcPrefix+"','showServerWin','width=350,height=700,menubar=no,status=yes,scrollbars=yes')\">"+drr["serverName"].ToString()+"</P>";
							}
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
							td.Attributes.Add("class","serverIp serverIpCol");
							if (fix_ip(drr["serverLanIp"].ToString())=="")
								{
									if (v_userrole.Contains("dns") || v_userrole.Contains("super"))
									{
										td.InnerHtml = "<P class='link' onclick=\"window.open('assnIp.aspx?host="+drr["serverName"].ToString()+"&amp;dc="+dcPrefix+"','assnIpWin','width=350,height=600,menubar=no,status=yes')\">Assign IP</P>";
									}
									else
									{
										td.InnerHtml = "<DIV style='text-align:center'>Undocumented</DIV>";
									}
								}
							else
							{
								td.InnerHtml = fix_ip(drr["serverLanIp"].ToString());
							}
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
							td.Attributes.Add("class","serverOs serverOsCol");
							if (drr["serverOS"].ToString()=="")
							{
								td.InnerHtml = "&#xa0;";
							}
							else
							{
								td.InnerHtml = drr["serverOS"].ToString();
							}
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
							td.Attributes.Add("class","serverPurpose serverPurposeCol");
							if (drr["serverPurpose"].ToString()=="")
							{
								td.InnerHtml = "&#xa0;";
							}
							else
							{
								td.InnerHtml = drr["serverPurpose"].ToString();
							}
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
							td.Attributes.Add("class","serverRack serverRackCol");
							if (drr["rack"].ToString()=="")
							{
								td.InnerHtml = "&#xa0;";
							}
							else
							{
								string rackString="";
								string sqlRack="";
								DataSet datCabinet=new DataSet();
								sqlRack="SELECT location, rackId FROM "+drr["dcPrefix"].ToString()+"racks WHERE rackId='"+drr["rack"].ToString()+"'";
//								Response.Write(sqlRack+"<BR/>");
								datCabinet=readDb(sqlRack);
								if (datCabinet!=null)
								{
									try
									{
										if (dcPrefix=="*")
										{
											rackString="("+drr["dcPrefix"].ToString().ToUpper().Replace("_","")+") ";
										}
										rackString=rackString+datCabinet.Tables[0].Rows[0]["location"].ToString()+"-R"+datCabinet.Tables[0].Rows[0]["rackId"].ToString().Substring(0,2)+"-C"+datCabinet.Tables[0].Rows[0]["rackId"].ToString().Substring(2,2);
									}
									catch (System.Exception ex)
									{
										rackString="ERR";
									}
								}
								td.InnerHtml = rackString;
//								td.InnerHtml = "R:"+drr["rack"].ToString().Substring(0,2)+", C:"+drr["rack"].ToString().Substring(2,2);
							}
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
							td.Attributes.Add("class","serverBc serverBcCol");
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
							td.Attributes.Add("class","serverSlot serverSlotCol");
							if (drr["slot"].ToString()=="")
							{
								td.InnerHtml = "&#xa0;";
							}
							else
							{
								td.InnerHtml = drr["slot"].ToString();
							}
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
							td.Attributes.Add("class","serverAction serverActionCol");
							if (drr["VMId"].ToString()=="")
							{
								if (v_userclass=="3" || v_userclass=="99")
								{
									if (v_userrole.Contains("datacenter"))
									{
										actionString=actionString+"<INPUT type='image' src='./img/cableServer.png' onclick=\"window.open('editCabling.aspx?id="+drr["rackspaceId"].ToString()+"&amp;dc="+dcPrefix+"','cableServerWin','width=400,height=600,menubar=no,status=yes,scrollbars=yes')\" ALT='Cable Server' />&#xa0;";
									}
									if (drr["bc"].ToString()!="" && drr["bc"].ToString()!=null)
									{
										actionString=actionString+"<INPUT type='image' src='./img/move.png' onclick=\"window.open('moveServer.aspx?host="+drr["rackspaceId"].ToString()+"&amp;dc="+dcPrefix+"','moveServerWin','width=350,height=350,menubar=no,status=yes,scrollbars=yes')\" ALT='Move/Swap Server' />&#xa0;";
									}
									if (fix_ip(drr["serverLanIp"].ToString())!="")
									{
										actionString = actionString+"<INPUT type='image' src='./img/recycle.png' onclick=\"window.open('recycleServer.aspx?host="+drr["rackspaceId"].ToString()+"&amp;dc="+dcPrefix+"','recycleServerWin','width=350,height=750,menubar=no,status=yes,scrollbars=yes')\" ALT='Recycle Server' />&#xa0;<INPUT type='image' src='./img/delete.png' onclick=\"window.open('deleteServer.aspx?host="+drr["serverName"].ToString()+"&amp;dc="+dcPrefix+"','deleteServerWin','width=350,height=275,menubar=no,status=yes')\" ALT='Delete Server' />&#xa0;";
										if (drr["serverName"].ToString().StartsWith("SL") || drr["serverName"].ToString().StartsWith("ZL") || drr["serverName"].ToString().StartsWith("SB") || drr["serverName"].ToString().StartsWith("SV"))
										{
											actionString=actionString+"<INPUT type='image' src='./img/remote.png' onclick=\"runClient('NIX','"+fix_ip(drr["serverLanIp"].ToString())+"')\" ALT='Open Putty Session' />";
										}
										if (drr["serverName"].ToString().StartsWith("SX") || drr["serverName"].ToString().StartsWith("ZX"))
										{
											actionString=actionString+"<INPUT type='image' src='./img/remote.png' onclick=\"runClient('WIN','"+fix_ip(drr["serverLanIp"].ToString())+"')\" ALT='Open RDP Session' />";
										}
										if (drr["serverName"].ToString().StartsWith("RS") || drr["serverName"].ToString().StartsWith("BC"))
										{
											actionString=actionString+"<INPUT type='image' src='./img/remote.png' onclick=\"window.open('http://"+fix_ip(drr["serverLanIp"].ToString())+"/','rsaWin','width=800,height=600,menubar=no,status=yes,scrollbars=yes')\" ALT='Open RSA2-AMM Session' />&#xa0;";
										}
									}
									else
									{
										actionString = actionString+"<INPUT type='image' src='./img/delete.png' onclick=\"window.open('deleteServer.aspx?host="+drr["serverName"].ToString()+"&amp;dc="+dcPrefix+"','deleteServerWin','width=350,height=275,menubar=no,status=yes')\" ALT='Delete Server'/>";
									}
									td.InnerHtml=actionString;
								}
								else
								{
									if (v_userrole.Contains("datacenter"))
									{
										actionString=actionString+"<INPUT type='image' src='./img/cableServer.png' onclick=\"window.open('editCabling.aspx?id="+drr["rackspaceId"].ToString()+"&amp;dc="+dcPrefix+"','cableServerWin','width=400,height=600,menubar=no,status=yes,scrollbars=yes')\" ALT='Edit Server Cabling'/>&#xa0;";
										td.InnerHtml=actionString;
									}
									else
									{
										td.InnerHtml = "&#xa0;";
									}
								}
							}
							else
							{
								td.InnerHtml = "&#xa0;";
							}
						tr.Cells.Add(td);         //Output </TD> 
					svrTbl.Rows.Add(tr);           //Output </TR>
					fill=!fill;
				}
			}
		}
	} 
}

private void showEnv()
{
	string sql,sql1;
	DataSet dat=new DataSet();
	int bcLimit=16, bcNum=1, slotLimit=14, slotNum=1, curSlot=1, index=0;
	bool emptySlot=false;
	string env, order;
	HtmlTableRow tr;
	HtmlTableCell td;
	bool fill;
	string v_userclass="", v_userrole="", actionString="";
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
		env=Request.QueryString["env"].ToString();
	}
	catch (System.Exception ex)
	{
		env = "";
	}	

	string dcPrefix="";
	try
	{
		dcPrefix=Request.QueryString["dc"].ToString();
	}
	catch (System.Exception ex)
	{
		dcPrefix = "";
	}

/*--- MODIFY THE RACKS TABLES
	CREATE TABLE abqdc_enviro (Id NVARCHAR(4) PRIMARY KEY, description NVARCHAR(15), dcPrefix NVARCHAR(10) DEFAULT 'abqdc_')
	CREATE TABLE kcdc_enviro (Id NVARCHAR(4) PRIMARY KEY, description NVARCHAR(15), dcPrefix NVARCHAR(10) DEFAULT 'kcdc_')
*/
	if (env!="")
	{
		hrSpan.InnerHtml ="<HR class='dotted'>";
//		Response.Write(env);
		
		sql="";

        sql = "SELECT serverName, serverLanIP, serverOS, serverPurpose, rack, bc, slot, dcPrefix,"+dcPrefix+"rackspace.rackspaceId, VMId, reserved FROM "+dcPrefix+"servers LEFT JOIN "+dcPrefix+"rackspace ON "+dcPrefix+"servers.rackspaceId="+dcPrefix+"rackspace.rackspaceId WHERE SUBSTRING(serverName,3,"+env.Length.ToString()+")='"+env+"' ORDER BY serverName ASC";

//		Response.Write(sql);
		ViewState["exportStr"] = "env";
		ViewState["sqlArg"] = env;

		//Place Export Button in Panel on Web Page
		ImageButton ib = new ImageButton();
		ib.ID = "exportButton";
		ib.ImageUrl = "./img/export.png";
		ib.Width = 110;
		ib.Height= 25;
		ib.AlternateText="Export to CSV";
		ib.BackColor=(System.Drawing.Color)colConvert.ConvertFromString("#FFFFFF");
//		ib.OnClick="Export_Click";
		ib.Click += new ImageClickEventHandler(Export_Click);
		Panel1.Controls.Add(ib); 

		//Place Printable View Button in Panel on Web Page
		ImageButton pb = new ImageButton();
		pb.ID = "printableButton";
		pb.ImageUrl = "./img/print.png";
		pb.Width = 125;
		pb.Height= 25;
		pb.AlternateText="Show Printable View";
		pb.BackColor=(System.Drawing.Color)colConvert.ConvertFromString("#FFFFFF");
//		pb.Attributes.Add("language", "javascript");
		pb.Attributes.Add("OnClick", "window.open('print.aspx?env="+env+"&amp;dc="+dcPrefix+"','printableWin','width=600,menubar=no,status=yes,scrollbars=yes')");
		Panel1.Controls.Add(pb); 

		dat=readDb(sql);

		if (dat!=null)
		{
				fill=false;
				tr = new HtmlTableRow();    //Output <TR>
					tr.Attributes.Add("class","blackheading");
					td = new HtmlTableCell(); //Output <TD>
						td.Attributes.Add("colspan","8");
						td.InnerHtml = env+" Servers";
					tr.Cells.Add(td);         //Output </TD>
				svrTbl.Rows.Add(tr);           //Output </TR>
				tr = new HtmlTableRow();    //Output <TR>
					tr.Attributes.Add("class","tableheading");
					td = new HtmlTableCell(); //Output <TD>
						td.Attributes.Add("class","serverNameCol");
						td.InnerHtml = "HostName";
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						td.Attributes.Add("class","serverIpCol");
						td.InnerHtml = "Public IP";
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						td.Attributes.Add("class","serverOsCol");
						td.InnerHtml = "OS";
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						td.Attributes.Add("class","serverPurposeCol");
						td.InnerHtml = "Purpose";
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						td.Attributes.Add("class","serverRackCol");
						td.InnerHtml = "Row/Cabinet";
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						td.Attributes.Add("class","serverBcCol");
						td.InnerHtml = "BC";
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						td.Attributes.Add("class","serverSlotCol");
						td.InnerHtml = "Slot";
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						td.Attributes.Add("class","serverActionCol");
						td.InnerHtml = "Actions";
					tr.Cells.Add(td);         //Output </TD>
				svrTbl.Rows.Add(tr);           //Output </TR>
				foreach (DataTable dtt in dat.Tables)
				{
					foreach (DataRow drr in dtt.Rows)
					{
						actionString="";
						tr = new HtmlTableRow();    //Output <TR>
						if (fill) tr.Attributes.Add("class","altrow");
							td = new HtmlTableCell(); //Output <TD>
								td.Attributes.Add("class","serverName serverNameCol");
								if (v_userclass=="3" || v_userclass=="99")
								{
									td.InnerHtml = "<P class='link' onclick=\"window.open('editServer.aspx?host="+drr["serverName"].ToString()+"&amp;dc="+drr["dcPrefix"].ToString()+"','editServerWin','width=400,height=750,menubar=no,status=yes,scrollbars=yes')\">"+drr["serverName"].ToString()+"</P>";
								}
								else
								{
									td.InnerHtml = "<P class='link' onclick=\"window.open('showServer.aspx?host="+drr["serverName"].ToString()+"&amp;dc="+drr["dcPrefix"].ToString()+"','showServerWin','width=350,height=700,menubar=no,status=yes,scrollbars=yes')\">"+drr["serverName"].ToString()+"</P>";
								}
							tr.Cells.Add(td);         //Output </TD>
							td = new HtmlTableCell(); //Output <TD>
								td.Attributes.Add("class","serverIp serverIpCol");
								if (fix_ip(drr["serverLanIp"].ToString())=="")
									{
										if (v_userrole.Contains("dns") || v_userrole.Contains("super"))
										{
											td.InnerHtml = "<P class='link' onclick=\"window.open('assnIp.aspx?host="+drr["serverName"].ToString()+"&amp;dc="+drr["dcPrefix"].ToString()+"','assnIpWin','width=350,height=600,menubar=no,status=yes')\">Assign IP</P>";
										}
										else
										{
											td.InnerHtml = "<DIV style='text-align:center'>Undocumented</DIV>";
										}
									}
								else
								{
									td.InnerHtml = fix_ip(drr["serverLanIp"].ToString());
								}
							tr.Cells.Add(td);         //Output </TD>
							td = new HtmlTableCell(); //Output <TD>
								td.Attributes.Add("class","serverOs serverOsCol");
								if (drr["serverOS"].ToString()=="")
								{
									td.InnerHtml = "&#xa0;";
								}
								else
								{
									td.InnerHtml = drr["serverOS"].ToString();
								}
							tr.Cells.Add(td);         //Output </TD>
							td = new HtmlTableCell(); //Output <TD>
								td.Attributes.Add("class","serverPurpose serverPurposeCol");
								if (drr["serverPurpose"].ToString()=="")
								{
									td.InnerHtml = "&#xa0;";
								}
								else
								{
									td.InnerHtml = drr["serverPurpose"].ToString();
								}
							tr.Cells.Add(td);         //Output </TD>
							td = new HtmlTableCell(); //Output <TD>
								td.Attributes.Add("class","serverRack serverRackCol");
								if (drr["rack"].ToString()=="")
								{
									td.InnerHtml = "&#xa0;";
								}
								else
								{
									string rackString="";
									string sqlRack="";
									DataSet datCabinet=new DataSet();
									sqlRack="SELECT location, rackId FROM "+drr["dcPrefix"].ToString()+"racks WHERE		rackId='"+drr["rack"].ToString()+"'";
//									Response.Write(sqlRack+"<BR/>");
									datCabinet=readDb(sqlRack);
									if (datCabinet!=null)
									{
										try
										{
											if (dcPrefix=="*")
											{
												rackString="("+drr["dcPrefix"].ToString().ToUpper().Replace("_","")+") ";
											}
											rackString=rackString+datCabinet.Tables[0].Rows[0]["location"].ToString()+"-R"+datCabinet.Tables[0].Rows[0]["rackId"].ToString().Substring(0,2)+"-C"+datCabinet.Tables[0].Rows[0]["rackId"].ToString().Substring(2,2);
										}
										catch (System.Exception ex)
										{
											rackString="ERR";
										}
									}
									td.InnerHtml = rackString;
								}
							tr.Cells.Add(td);         //Output </TD>
							td = new HtmlTableCell(); //Output <TD>
								td.Attributes.Add("class","serverBc serverBcCol");
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
								td.Attributes.Add("class","serverSlot serverSlotCol");
								if (drr["slot"].ToString()=="")
								{
									td.InnerHtml = "&#xa0;";
								}
								else
								{
									td.InnerHtml = drr["slot"].ToString();
								}
							tr.Cells.Add(td);         //Output </TD>
							td = new HtmlTableCell(); //Output <TD>
								td.Attributes.Add("class","serverAction serverActionCol");
								if (drr["VMId"].ToString()=="")
								{
									if (v_userclass=="3" || v_userclass=="99")
									{
										if (v_userrole.Contains("datacenter") && drr["serverOS"].ToString()!="Network")
										{
											actionString=actionString+"<INPUT type='image' src='./img/cableServer.png' onclick=\"window.open('editCabling.aspx?id="+drr["rackspaceId"].ToString()+"&amp;dc="+drr["dcPrefix"].ToString()+"','cableServerWin','width=400,height=600,menubar=no,status=yes,scrollbars=yes')\" alt='Edit Server Cabling'/>&#xa0;";
										}
										if (drr["bc"].ToString()!="" && drr["bc"].ToString()!=null)
										{
											actionString=actionString+"<INPUT type='image' src='./img/move.png' onclick=\"window.open('moveServer.aspx?host="+drr["rackspaceId"].ToString()+"&amp;dc="+drr["dcPrefix"].ToString()+"','moveServerWin','width=350,height=350,menubar=no,status=yes,scrollbars=yes')\" alt='Move Server'/>&#xa0;";
										}
										if (fix_ip(drr["serverLanIp"].ToString())!="" && drr["serverOS"].ToString()!="Network")
										{
											actionString = actionString+"<INPUT type='image' src='./img/recycle.png' onclick=\"window.open('recycleServer.aspx?host="+drr["rackspaceId"].ToString()+"&amp;dc="+drr["dcPrefix"].ToString()+"','recycleServerWin','width=350,height=750,menubar=no,status=yes,scrollbars=yes')\" alt='Recycle Server'/>&#xa0;<INPUT type='image' src='./img/delete.png' onclick=\"window.open('deleteServer.aspx?host="+drr["serverName"].ToString()+"&amp;dc="+drr["dcPrefix"].ToString()+"','deleteServerWin','width=350,height=275,menubar=no,status=yes')\" alt='Delete Server'/>&#xa0;";
											if (drr["serverName"].ToString().StartsWith("SL") || drr["serverName"].ToString().StartsWith("ZL") || drr["serverName"].ToString().StartsWith("SB") || drr["serverName"].ToString().StartsWith("SV"))
											{
												actionString=actionString+"<INPUT type='image' src='./img/remote.png' onclick=\"runClient('NIX','"+fix_ip(drr["serverLanIp"].ToString())+"')\" alt='Open SSH Session'/>";
											}
											if (drr["serverName"].ToString().StartsWith("SX") || drr["serverName"].ToString().StartsWith("ZX"))
											{
												actionString=actionString+"<INPUT type='image' src='./img/remote.png' onclick=\"runClient('WIN','"+fix_ip(drr["serverLanIp"].ToString())+"')\" alt='Open RDP Session'/>";
											}
											if (drr["serverName"].ToString().StartsWith("RS") || drr["serverName"].ToString().StartsWith("BC"))
											{
												actionString=actionString+"<INPUT type='image' src='./img/remote.png' onclick=\"window.open('http://"+fix_ip(drr["serverLanIp"].ToString())+"/','rsaWin','width=800,height=600,menubar=no,status=yes,scrollbars=yes')\" ALT='Open RSA2-AMM Session'/>&#xa0;";
											}									
										}
										else
										{
											actionString = actionString+"<INPUT type='image' src='./img/delete.png' onclick=\"window.open('deleteServer.aspx?host="+drr["serverName"].ToString()+"&amp;dc="+drr["dcPrefix"].ToString()+"','deleteServerWin','width=350,height=275,menubar=no,status=yes')\" ALT='Open RSA2-AMM Session'/>";
										}
										td.InnerHtml=actionString;
									}
									else
									{
										if (v_userrole.Contains("datacenter"))
										{
											actionString=actionString+"<INPUT type='image' src='./img/cableServer.png' onclick=\"window.open('editCabling.aspx?id="+drr["rackspaceId"].ToString()+"&amp;dc="+drr["dcPrefix"].ToString()+"','cableServerWin','width=400,height=600,menubar=no,status=yes,scrollbars=yes')\" ALT='Edit Server Cabling'/>&#xa0;";
											td.InnerHtml=actionString;
										}
										else
										{
											td.InnerHtml = "&#xa0;";
										}
									}
								}
								else
								{
									td.InnerHtml = "&#xa0;";
								}
							tr.Cells.Add(td);         //Output </TD> 
						svrTbl.Rows.Add(tr);           //Output </TR>
						fill=!fill;
					}
				}				
		}
	} 
}

private void showCluster()
{
	string sql,sql1;
	DataSet dat=new DataSet();
	int bcLimit=16, bcNum=1, slotLimit=14, slotNum=1, curSlot=1, index=0;
	bool emptySlot=false;
	string cluster, order;
	HtmlTableRow tr;
	HtmlTableCell td;
	bool fill;
	string v_userclass="", v_userrole="";
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
		cluster=Request.QueryString["clstr"].ToString();
	}
	catch (System.Exception ex)
	{
		cluster = "";
	}

	string dcPrefix="";
	try
	{
		dcPrefix=Request.QueryString["dc"].ToString();
	}
	catch (System.Exception ex)
	{
		dcPrefix = "";
	}

	if (cluster!="")
	{
		hrSpan.InnerHtml ="<HR class='dotted'>";
//		Response.Write(cluster);

		sql = "SELECT  * FROM (SELECT serverName, serverLanIP, serverOS, serverPurpose, rack, bc, slot, "+dcPrefix+"rackspace.rackspaceId, belongsTo, reserved, VMId FROM "+dcPrefix+"rackspace LEFT JOIN "+dcPrefix+"servers ON "+dcPrefix+"rackspace.rackspaceId="+dcPrefix+"servers.rackspaceId WHERE belongsTo='"+cluster+"') AS a WHERE reserved='0' ORDER BY serverPurpose DESC, serverLanIP DESC";

		ViewState["exportStr"] = "clstr";
		ViewState["sqlArg"] = cluster;

		//Place Export Button in Panel on Web Page
		ImageButton ib = new ImageButton();
		ib.ID = "exportButton";
		ib.ImageUrl = "./img/export.png";
		ib.Width = 110;
		ib.Height= 25;
		ib.AlternateText="Export to CSV";
		ib.BackColor=(System.Drawing.Color)colConvert.ConvertFromString("#FFFFFF");
//		ib.OnClick="Export_Click";
		ib.Click += new ImageClickEventHandler(Export_Click);
		Panel1.Controls.Add(ib); 

		//Place Printable View Button in Panel on Web Page
		ImageButton pb = new ImageButton();
		pb.ID = "printableButton";
		pb.ImageUrl = "./img/print.png";
		pb.Width = 125;
		pb.Height= 25;
		pb.AlternateText="Show Printable View";
		pb.BackColor=(System.Drawing.Color)colConvert.ConvertFromString("#FFFFFF");
//		pb.Attributes.Add("language", "javascript");
		pb.Attributes.Add("OnClick", "window.open('print.aspx?clstr="+cluster+"&amp;dc="+dcPrefix+"','printableWin','width=600,menubar=no,status=yes,scrollbars=yes')");
		Panel1.Controls.Add(pb); 

		dat=readDb(sql);

		if (dat!=null)
		{
			fill=false;
			tr = new HtmlTableRow();    //Output <TR>
				tr.Attributes.Add("class","blackheading");
				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("colspan","5");
					td.InnerHtml = "ESX Cluster - "+cluster;
				tr.Cells.Add(td);         //Output </TD>
			svrTbl.Rows.Add(tr);           //Output </TR>
			tr = new HtmlTableRow();    //Output <TR>
				tr.Attributes.Add("class","tableheading");
				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("class"," serverNameCol");
					td.InnerHtml = "HostName";
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("class","serverIpCol");
					td.InnerHtml = "Public IP";
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("class","serverOsCol");
					td.InnerHtml = "OS";
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("class","serverPurposeCol");
					td.InnerHtml = "Purpose";
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("class","serverActionCol");
					td.InnerHtml = "Actions";
				tr.Cells.Add(td);         //Output </TD>
			svrTbl.Rows.Add(tr);           //Output </TR>	
			foreach (DataTable dtt in dat.Tables)
			{
				foreach (DataRow drr in dtt.Rows)
				{
					tr = new HtmlTableRow();    //Output <TR>
					if (fill) tr.Attributes.Add("class","altrow");
						td = new HtmlTableCell(); //Output <TD>
							td.Attributes.Add("class","serverName serverNameCol");
							if (v_userrole.Contains("vmware") || v_userrole.Contains("super"))
							{
								if (drr["serverName"].ToString()=="")
								{
									int at=0;
									int len=0;
									string shortVmId=drr["VMId"].ToString();
									len=shortVmId.Length;
//									Response.Write("at="+at+"<BR/>");
//									Response.Write("len="+len+"<BR/>");
//									Response.Write("shortVmId="+shortVmId+"<BR/>");
									td.InnerHtml = "<P class='link' onclick=\"window.open('showServer.aspx?rackspace="+drr["rackspaceId"].ToString()+"&amp;dc="+dcPrefix+"','showServerWin','width=500,height=700,menubar=no,status=yes,scrollbars=yes')\">"+drr["VMId"].ToString()+"</P>";
								}
								else
								{
									td.InnerHtml = "<P class='link' onclick=\"window.open('showServer.aspx?host="+drr["serverName"].ToString()+"&amp;dc="+dcPrefix+"','showServerWin','width=500,height=700,menubar=no,status=yes,scrollbars=yes')\">"+drr["serverName"].ToString()+"</P>";
								}
							}
							else
							{
								if (drr["serverName"].ToString()=="")
								{
									td.InnerHtml = "Unassigned";
								}
								else
								{
									td.InnerHtml = "<P class='link' onclick=\"window.open('showServer.aspx?host="+drr["serverName"].ToString()+"&amp;dc="+dcPrefix+"','showServerWin','width=500,height=700,menubar=no,status=yes,scrollbars=yes')\">"+drr["serverName"].ToString()+"</P>";
								}
							}
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
							td.Attributes.Add("class","serverIp serverIpCol");
							if (drr["serverName"].ToString()!="")
							{
								if (fix_ip(drr["serverLanIp"].ToString())=="")
								{
									if (v_userrole.Contains("vmware") || v_userrole.Contains("super") || v_userrole.Contains("dns")) 
									{
										td.InnerHtml = "<P class='blackLink center' onclick=\"window.open('assnIp.aspx?host="+drr["serverName"].ToString()+"&amp;dc="+dcPrefix+"','assnIpWin','width=350,height=600,menubar=no,status=yes')\">Assign IP</P>";
									}
									else
									{
										td.InnerHtml = "<DIV class='center'>Undocumented</DIV>";
									}
								}
								else
								{
									td.InnerHtml = fix_ip(drr["serverLanIp"].ToString());
								}
							}
							else
							{
								td.InnerHtml = "&#xa0;";
							}
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
							td.Attributes.Add("class","serverOs serverOsCol");
							if (drr["serverOS"].ToString()=="")
							{
								td.InnerHtml = "&#xa0;";
							}
							else
							{
								td.InnerHtml = drr["serverOS"].ToString();
							}
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
							td.Attributes.Add("class","serverPurpose serverPurposeCol");
							if (drr["serverPurpose"].ToString()=="")
							{
								td.InnerHtml = "&#xa0;";
							}
							else
							{
								td.InnerHtml = drr["serverPurpose"].ToString();
							}
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
							td.Attributes.Add("class","serverAction serverActionCol");
							if (drr["serverName"].ToString()!="")
							{
								if (v_userrole.Contains("vmware") || v_userclass=="99")
								{
									if (fix_ip(drr["serverLanIp"].ToString())!="")
									{
										string actionString="";
										if (drr["serverName"].ToString().StartsWith("SL") || drr["serverName"].ToString().StartsWith("ZL") || drr["serverName"].ToString().StartsWith("SB") || drr["serverName"].ToString().StartsWith("SV"))
										{
											actionString=actionString+"<INPUT type='image' src='./img/remote.png' onclick=\"runClient('NIX','"+fix_ip(drr["serverLanIp"].ToString())+"')\" ALT='Open Putty Session'/>";
										}
										if (drr["serverName"].ToString().StartsWith("SX") || drr["serverName"].ToString().StartsWith("ZX"))
										{
											actionString=actionString+"<INPUT type='image' src='./img/remote.png' onclick=\"runClient('WIN','"+fix_ip(drr["serverLanIp"].ToString())+"')\" ALT='Open RDP Session'/>";
										}
										if (drr["serverName"].ToString().StartsWith("RS") || drr["serverName"].ToString().StartsWith("BC"))
										{
											actionString=actionString+"<INPUT type='image' src='./img/remote.png' onclick=\"window.open('http://"+fix_ip(drr["serverLanIp"].ToString())+"/','rsaWin','width=800,height=600,menubar=no,status=yes,scrollbars=yes')\" ALT='Open RSA2-AMM Session'/>&#xa0;";
										}
										td.InnerHtml=actionString;
									}
									else
									{
										td.InnerHtml = "&#xa0;";
									}
								}
								else
								{
									td.InnerHtml = "&#xa0;";
								}
							}
							else
							{
								td.InnerHtml = "&#xa0;";
							}
						tr.Cells.Add(td);         //Output </TD> 
					svrTbl.Rows.Add(tr);           //Output </TR>
					fill=!fill;
				}
			}
		}
		else
		{
			tr = new HtmlTableRow();    //Output <TR>
				tr.Attributes.Add("class","blackheading");
				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("colspan","8");
					td.InnerHtml = "ESX Cluster - "+cluster;
				tr.Cells.Add(td);         //Output </TD>
			svrTbl.Rows.Add(tr);           //Output </TR>
			tr = new HtmlTableRow();    //Output <TR>
				tr.Attributes.Add("class","tableheading");
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml = "No servers or available rackspace found.";
				tr.Cells.Add(td);         //Output </TD>
			svrTbl.Rows.Add(tr);           //Output </TR>
		}	
	}
}


private void goSearch(Object s, EventArgs e) 
{
	hrSpan.InnerHtml ="<HR class='dotted'>";
	string sql="";
	string v_searchWord = fix_txt(searchWord.Value);
	string v_searchFrom = fix_txt(searchFrom.Value);
	string v_userclass, v_userrole, v_username,actionString="";
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

	string defaultDc="";
	string sqlTablePrefix="";
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
	
	if (v_searchFrom=="serverLanIp")
	{
		v_searchWord=break_ip(v_searchWord);
	}
	if (v_searchWord!="") 
	{	
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
						newSql=newSql+"SELECT serverName, serverLanIP, serverOS, serverPurpose, rack, bc, slot, dcPrefix, "+dr["dcPrefix"].ToString()+"rackspace.rackspaceId, serial, reserved FROM "+dr["dcPrefix"].ToString()+"servers LEFT JOIN "+dr["dcPrefix"].ToString()+"rackspace ON "+dr["dcPrefix"].ToString()+"servers.rackspaceId="+dr["dcPrefix"].ToString()+"rackspace.rackspaceId WHERE "+v_searchFrom+" LIKE '%"+v_searchWord+"%'";
					}
				}
//				Response.Write(newSql+"<BR/>");
				sql="SELECT * FROM ("+newSql+") AS a ORDER BY serverName ASC";
			}
		}
		else
		{
			sql="SELECT serverName, serverLanIP, serverOS, serverPurpose, rack, bc, slot, dcPrefix, "+sqlTablePrefix+"rackspace.rackspaceId, serial, reserved FROM "+sqlTablePrefix+"servers LEFT JOIN "+sqlTablePrefix+"rackspace ON "+sqlTablePrefix+"servers.rackspaceId="+sqlTablePrefix+"rackspace.rackspaceId WHERE "+v_searchFrom+" LIKE '%"+v_searchWord+"%' ORDER BY serverName ASC";
		}
	}
//	Response.Write(sql);
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
		
//		Response.Write((string)ViewState["exportStr"]+"<BR/>");
//		Response.Write((string)ViewState["searchArg"]+"<BR/>");
//		Response.Write((string)ViewState["searchArg1"]);
//		Response.Write((string)Request.Cookies["srchSql"].Value);

/*		//Place Export Button in Panel on Web Page
		ImageButton ib = new ImageButton();
		ib.ID = "exportButton";
		ib.ImageUrl = "./img/export.png";
		ib.Width = 110;
		ib.Height= 25;
		ib.AlternateText="Export to CSV";
		ib.BackColor=(System.Drawing.Color)colConvert.ConvertFromString("#FFFFFF");
//		ib.OnClick="Export_Click";
		ib.Click += new ImageClickEventHandler(Export_Click);
		Panel1.Controls.Add(ib);  */
		
		//Place Printable View Button in Panel on Web Page
		ImageButton pb = new ImageButton();
		pb.ID = "printableButton";
		pb.ImageUrl = "./img/print.png";
		pb.Width = 125;
		pb.Height= 25;
		pb.AlternateText="Show Printable View";
		pb.BackColor=(System.Drawing.Color)colConvert.ConvertFromString("#FFFFFF");
//		pb.Attributes.Add("language", "javascript");
		pb.Attributes.Add("OnClick", "window.open('print.aspx?srch=svr&amp;dc="+sqlTablePrefix+"','printableWin','width=600,menubar=no,status=yes,scrollbars=yes')");
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
					td.Attributes.Add("colspan","8");
					td.InnerHtml = "Server(s) Found";
				tr.Cells.Add(td);         //Output </TD>
			svrTbl.Rows.Add(tr);           //Output </TR>
			tr = new HtmlTableRow();    //Output <TR>
				tr.Attributes.Add("class","tableheading");
				td = new HtmlTableCell(); //Output <TD>
				td.Attributes.Add("class","serverNameCol");
					td.InnerHtml = "HostName";
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
				td.Attributes.Add("class","serverIpCol");
					td.InnerHtml = "Public IP";
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
				td.Attributes.Add("class","serverOsCol");
					td.InnerHtml = "OS";
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
				td.Attributes.Add("class","serverPurposeCol");
					td.InnerHtml = "Purpose";
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("class"," serverRackCol");
					td.InnerHtml = "Row/Cabinet";
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("class"," serverBCCol");
					td.InnerHtml = "BC";
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("class"," serverSlotCol");
					td.InnerHtml = "Slot";
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
				td.Attributes.Add("class","serverActionCol");
					td.InnerHtml = "Actions";
				tr.Cells.Add(td);         //Output </TD>
			svrTbl.Rows.Add(tr);           //Output </TR>
			foreach (DataTable dtt in dat.Tables)
			{
				foreach (DataRow drr in dtt.Rows)
				{
					actionString="";
					tr = new HtmlTableRow();    //Output <TR>
					if (fill) tr.Attributes.Add("class","altrow");
						td = new HtmlTableCell(); //Output <TD>
							td.Attributes.Add("class","serverName serverNameCol");
							if (v_userclass=="3" || v_userclass=="99")
							{
								td.InnerHtml = "<P class='blackLink' onclick=\"window.open('editServer.aspx?host="+drr["serverName"].ToString()+"&amp;dc="+drr["dcPrefix"].ToString()+"','editServerWin','width=400,height=750,menubar=no,status=yes,scrollbars=yes')\">"+drr["serverName"].ToString()+"</A>";
							}
							else
							{
								td.InnerHtml = "<P class='blackLink' onclick=\"window.open('showServer.aspx?host="+drr["serverName"].ToString()+"&amp;dc="+drr["dcPrefix"].ToString()+"','showServerWin','width=350,height=700,menubar=no,status=yes,scrollbars=yes')\">"+drr["serverName"].ToString()+"</A>";
							}
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
							td.Attributes.Add("class","serverIp serverIpCol");
							if (fix_ip(drr["serverLanIp"].ToString())=="")
							{
								if (v_userrole.Contains("dns") || v_userrole.Contains("super"))
								{
									td.InnerHtml = "<DIV style='text-align:center'><A class='black' href='javascript:{}'	onclick=javascript:window.open('assnIp.aspx?host="+drr["serverName"].ToString()+"&amp;dc="+drr["dcPrefix"].ToString()+"','assnIpWin','width=350,height=600,menubar=no,status=yes')\">Assign IP</A></DIV>";
								}
								else
								{
									td.InnerHtml = "<DIV style='text-align:center'>Undocumented</DIV>";
								}
							}
							else
							{
								td.InnerHtml = fix_ip(drr["serverLanIp"].ToString());
							}
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
							td.Attributes.Add("class","serverOs serverOsCol");
							if (drr["serverOS"].ToString()=="")
							{
								td.InnerHtml = "&#xa0;";
							}
							else
							{
								td.InnerHtml = drr["serverOS"].ToString();
							}
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
							td.Attributes.Add("class","serverPurpose serverPurposeCol");
							if (drr["serverPurpose"].ToString()=="")
							{
								td.InnerHtml = "&#xa0;";
							}
							else
							{
								td.InnerHtml = drr["serverPurpose"].ToString();
							}
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
							td.Attributes.Add("class","serverRack serverRackCol");
							if (drr["rack"].ToString()=="")
							{
								td.InnerHtml = "&#xa0;";
							}
							else
							{
								string rackString="";
								string sqlRack="";
								DataSet datCabinet=new DataSet();
								sqlRack="SELECT location, rackId FROM "+drr["dcPrefix"].ToString()+"racks WHERE rackId='"+drr["rack"].ToString()+"'";
//								Response.Write(sqlRack+"<BR/>");
								datCabinet=readDb(sqlRack);
								if (datCabinet!=null)
								{
									try
									{
										if (sqlTablePrefix=="*")
										{
											rackString="("+drr["dcPrefix"].ToString().ToUpper().Replace("_","")+") ";
										}
										rackString=rackString+datCabinet.Tables[0].Rows[0]["location"].ToString()+"-R"+datCabinet.Tables[0].Rows[0]["rackId"].ToString().Substring(0,2)+"-C"+datCabinet.Tables[0].Rows[0]["rackId"].ToString().Substring(2,2);
									}
									catch (System.Exception ex)
									{
										rackString="ERR";
									}
								}
								td.InnerHtml = rackString;
//								td.InnerHtml = "R:"+drr["rack"].ToString().Substring(0,2)+", C:"+drr["rack"].ToString().Substring(2,2);
							}
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
							td.Attributes.Add("class","serverBc serverBcCol");
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
							td.Attributes.Add("class","serverSlot serverSlotCol");
							if (drr["slot"].ToString()=="")
							{
								td.InnerHtml = "&#xa0;";
							}
							else
							{
								td.InnerHtml = drr["slot"].ToString();
							}
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
							td.Attributes.Add("class","serverAction serverActionCol");
							if (v_userclass=="3" || v_userclass=="99")
							{
								if (v_userrole.Contains("datacenter"))
								{
									actionString=actionString+"<INPUT type='image' src='./img/cableServer.png' onclick=\"window.open('editCabling.aspx?id="+drr["rackspaceId"].ToString()+"&amp;dc="+drr["dcPrefix"].ToString()+"','cableServerWin','width=400,height=600,menubar=no,status=yes,scrollbars=yes')\" ALT='Edit Server Cabling'/>&#xa0;";
								}
								if (drr["bc"].ToString()!="" && drr["bc"].ToString()!=null)
								{
									actionString=actionString+"<INPUT type='image' src='./img/move.png' onclick=\"window.open('moveServer.aspx?host="+drr["rackspaceId"].ToString()+"&amp;dc="+drr["dcPrefix"].ToString()+"','moveServerWin','width=350,height=350,menubar=no,status=yes,scrollbars=yes')\" ALT='Move/Swap Server'/>&#xa0;";
								}
								if (fix_ip(drr["serverLanIp"].ToString())!="")
								{
									actionString = actionString+"<INPUT type='image' src='./img/recycle.png' onclick=\"window.open('recycleServer.aspx?host="+drr["serverName"].ToString()+"&amp;dc="+drr["dcPrefix"].ToString()+"','recycleServerWin','width=350,height=750,menubar=no,status=yes,scrollbars=yes')\" ALT='Recycle Server'/>&#xa0;<INPUT type='image' src='./img/delete.png' onclick=\"window.open('deleteServer.aspx?host="+drr["serverName"].ToString()+"&amp;dc="+drr["dcPrefix"].ToString()+"','deleteServerWin','width=350,height=275,menubar=no,status=yes')\" ALT='Delete Server'/>&#xa0;";
									if (drr["serverName"].ToString().StartsWith("SL") || drr["serverName"].ToString().StartsWith("ZL") || drr["serverName"].ToString().StartsWith("SB") || drr["serverName"].ToString().StartsWith("SV"))
									{
										actionString=actionString+"<INPUT type='image' src='./img/remote.png' onclick=\"runClient('NIX','"+fix_ip(drr["serverLanIp"].ToString())+"')\" ALT='Open SSH Session'/>";
									}
									if (drr["serverName"].ToString().StartsWith("SX") || drr["serverName"].ToString().StartsWith("ZX"))
									{
										actionString=actionString+"<INPUT type='image' src='./img/remote.png' onclick=\"runClient('WIN','"+fix_ip(drr["serverLanIp"].ToString())+"')\" ALT='Open RDP Session'/>";
									}
									if (drr["serverName"].ToString().StartsWith("RS") || drr["serverName"].ToString().StartsWith("BC"))
									{
										actionString=actionString+"<INPUT type='image' src='./img/remote.png' onclick=\"window.open('http://"+fix_ip(drr["serverLanIp"].ToString())+"/','rsaWin','width=800,height=600,menubar=no,status=yes,scrollbars=yes')\" ALT='Open RDP Session'/>&#xa0;";
									}
									td.InnerHtml=actionString;
								}
								else
								{
									td.InnerHtml = "<INPUT type='image' src='./img/delete.png' onclick=\"window.open('deleteServer.aspx?host="+drr["serverName"].ToString()+"&amp;dc="+drr["dcPrefix"].ToString()+"','deleteServerWin','width=350,height=275,menubar=no,status=yes')\" ALT='Delete Server'/>";
								}
							}
							else
							{
								if (v_userrole.Contains("datacenter"))
								{
									actionString=actionString+"<INPUT type='image' src='./img/cableServer.png' onclick=\"window.open('editCabling.aspx?id="+drr["rackspaceId"].ToString()+"&amp;dc="+drr["dcPrefix"].ToString()+"','cableServerWin','width=400,height=600,menubar=no,status=yes,scrollbars=yes')\" ALT='Edit Server Cabling'/>&#xa0;";
									td.InnerHtml=actionString;
								}
								else
								{
									td.InnerHtml = "&#xa0;";
								}
							}	
						tr.Cells.Add(td);         //Output </TD>
					svrTbl.Rows.Add(tr);           //Output </TR>
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
			svrTbl.Rows.Add(tr);           //Output </TR>
		}
	} 
	searchWord.Value = string.Empty;
	searchFrom.SelectedIndex = -1;
}

private void Page_Load(Object o, EventArgs e)
{
//UNCOMMENT this line to force login to access this page.
	lockout(); Page.Header.Title=shortSysName+": Manage Servers";
	systemStatus(0); // Check to see if admin has put system is in offline mode.

//START Check if user is logged in by checking existence of cookie.
	loggedin.InnerHtml=loggedIn();
	adminMenu.InnerHtml=isAdmin();

	string sqlDialect=System.Configuration.ConfigurationManager.AppSettings["db_type"].ToString().ToUpper();

	bool noTable=false;
	string sql="", defaultDc="", sqlTablePrefix="", sql1="";
	DataSet dat = new DataSet();

/*--- MODIFY THE RACKS TABLES
	ALTER TABLE kcdc_clusters ADD dcPrefix NVARCHAR(10) DEFAULT 'kcdc_'
	UPDATE kcdc_clusters SET dcPrefix='kcdc_'   
	ALTER TABLE abqdc_clusters ADD dcPrefix NVARCHAR(10) DEFAULT 'abqdc_'
	UPDATE abqdc_clusters SET dcPrefix='abqdc_' 
*/

	sql="SELECT * FROM datacenters ORDER BY dcDesc ASC";
	dat=readDb(sql);
	string optionDesc="", optionVal="";
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
	string v_username;
	int bcLimit=16, bcNum=1, slotLimit=14, slotNum=1, curSlot=1, index=0;
	bool emptySlot=false;
	string bc="", rack="", os="", env="", cluster="";
	string v_userclass="", v_userrole="";
	string v_searchWord = fix_txt(searchWord.Value);
	string v_searchFrom = fix_txt(searchFrom.Value);
	ColorConverter colConvert = new ColorConverter();
	HttpCookie cookie;
	string runClientScript="";

	runClientScript=@"<script> function runClient(type, ip) {   var runShell=new ActiveXObject('Shell.Application');   var runCmd;   var runArgs;   switch(type)   {       case ""NIX"":       runCmd=""C:\\Progra~1\\SSH_SCP\\PUTTY.EXE"";       runArgs=ip;     break;     case ""WIN"":       runCmd=""C:\\WINDOWS\\system32\\mstsc.exe"";       runArgs=""/v:""+ip;     break;   }   runShell.ShellExecute(runCmd,runArgs,'','open','1'); }<"+"/script>";

	Page.RegisterStartupScript("StartScript",runClientScript);

/*
	Acceptable values of scope:
		1  - BladeCenter #1
		2  - BladeCenter #2
		3  - BladeCenter #3
		4  - BladeCenter #4
		5  - BladeCenter #5
		6  - BladeCenter #6
		7  - BladeCenter #7
		8  - BladeCenter #8
		9  - BladeCenter #9
		10 - BladeCenter #10
		11 - BladeCenter #11
		12 - BladeCenter #12
		13 - BladeCenter #13
		14 - BladeCenter #14
		15 - BladeCenter #15
		16 - BladeCenter #16
		conv - 3850 /3650
		aix  - AIX servers
*/

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
			bc=Request.QueryString["bc"].ToString();
		}
		catch (System.Exception ex)
		{
			bc = "";
		}	

		try
		{
			rack=Request.QueryString["rack"].ToString();
		}
		catch (System.Exception ex)
		{
			rack = "";
		}

		try
		{
			os=Request.QueryString["os"].ToString();
		}
		catch (System.Exception ex)
		{
			os = "";
		}

		try
		{
			env=Request.QueryString["env"].ToString();
		}
		catch (System.Exception ex)
		{
			env = "";
		}

		try
		{
			cluster=Request.QueryString["clstr"].ToString();
		}
		catch (System.Exception ex)
		{
			cluster = "";
		}
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
	
//	Response.Write("<script language='JavaScript'>function onKey(){if (window.event.keyCode == 13){document.getElementById('searchButton').click();}} document.attachEvent('onkeydown',onKey);//-->"+"<"+"/script>");

	HtmlTableRow tr;
	HtmlTableCell td;
	bool fill;
	string addSvrStr="";

	titleSpan.InnerHtml="<SPAN class='heading1'>Manage Servers</SPAN>"; 

	if (v_userclass=="3" || v_userclass=="99")
	{
		if (v_userrole.Contains("manager"))
		{
			if (sqlTablePrefix!="*")
			{
				addSvrStr = addSvrStr+"<BUTTON id='addNewSrvButn' onclick=\"window.open('provision.aspx?dc="+sqlTablePrefix+"','newServerWin','width=400,height=750,menubar=no,status=yes,scrollbars=yes')\"><IMG src='./img/addIcon16.png' alt=''/>&nbsp; Add New Server &nbsp;</BUTTON>&nbsp; &nbsp; &nbsp;";
			}
			else
			{
				addSvrStr = addSvrStr+"<TABLE style='width:40%;' class='datatable center'><TR class='linktable'><TD style='width:150px;'><SPAN class='italic'>NOTE: Choose a datacenter to <BR/>add hardware and clusters.</SPAN></TD></TR></TABLE>";
			}
		}
		if (v_userrole.Contains("dns"))
		{
			if (sqlTablePrefix!="*")
			{
				addSvrStr = addSvrStr+"<BUTTON id='addNewVipButn'  onclick=\"window.open('newVip.aspx?dc="+sqlTablePrefix+"','newVIPWin','width=400,height=450,menubar=no,status=yes,scrollbars=yes')\"><IMG src='./img/addIcon16.png' alt=''/>&nbsp; Add New VIP &nbsp;</BUTTON>";
			}
			else
			{
				addSvrStr = addSvrStr+"<TABLE style='width:40%;' class='datatable center'><TR class='linktable'><TD style='width:150px;'><SPAN class='italic'>NOTE: Choose a datacenter to <BR/>add hardware and clusters.</SPAN></TD></TR></TABLE>";
			}
		}
		if (v_userclass=="99")
		{
			if (sqlTablePrefix!="*")
			{
				addSvrStr ="<BUTTON id='addNewSrvButn' onclick=\"window.open('provision.aspx?dc="+sqlTablePrefix+"','newServerWin','width=400,height=750,menubar=no,status=yes,scrollbars=yes')\"><IMG src='./img/addIcon16.png' alt=''/>&nbsp; Add New Server &nbsp;</BUTTON>&nbsp; &nbsp; &nbsp;<BUTTON id='addNewVipButn'  onclick=\"window.open('newVip.aspx?dc="+sqlTablePrefix+"','newVIPWin','width=400,height=450,menubar=no,status=yes,scrollbars=yes')\"><IMG src='./img/addIcon16.png' alt=''/>&nbsp; Add New VIP &nbsp;</BUTTON>";
			}
			else
			{
				addSvrStr ="<TABLE style='width:40%;' class='datatable center'><TR class='linktable'><TD style='width:150px;'><SPAN class='italic'>NOTE: Choose a datacenter to <BR/>add hardware and clusters.</SPAN></TD></TR></TABLE>";
			}

		}
		addServer.InnerHtml=addSvrStr;
	}
	

	string sqlBC="", sqlRack="", sqlOs="", sqlStage="", sqlVm="", sqlEnv="";
	DataSet datBC, datRack, datOs, datStage, datVm, datEnv;
	int countBC=0, countRack=0, countOs=0, countVm=0, countEnv=0;
	
//	Response.Write(sqlTablePrefix+"<BR/>");
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
					newSql=newSql+"SELECT DISTINCT(bc), dcPrefix FROM "+dr["dcPrefix"].ToString()+"rackspace";
				}
			}
//			Response.Write(newSql+"<BR/>");
			sqlBC="SELECT * FROM ("+newSql+") AS bcPool WHERE bc IS NOT NULL AND bc!='' ORDER BY bc";
		}
	}
	else
	{
		sqlBC = "SELECT DISTINCT(bc), dcPrefix FROM "+sqlTablePrefix+"rackspace ORDER BY bc";
	}
//	Response.Write(sqlBC+"<BR/>");
	datBC = readDb(sqlBC);
	if (datBC!=null)
	{
		fill=false;
		tr = new HtmlTableRow();    //Output <TR>
		tr.Attributes.Add("class","blackheading");
			td = new HtmlTableCell(); //Output <TD>
				td.Attributes.Add("colspan","4");
				td.InnerHtml = "Browse Blades";
			tr.Cells.Add(td);         //Output </TD>
		bladeTbl.Rows.Add(tr);           //Output </TR>
		countBC = 1;
		foreach (DataTable dtBC in datBC.Tables)
		{
			foreach (DataRow drBC in dtBC.Rows)
			{	
				if (drBC["bc"].ToString()!="")
				{
					if (countBC==1) tr = new HtmlTableRow();    //Output <TR>
					td = new HtmlTableCell(); //Output <TD>
						td.InnerHtml = "<A HREF='adminServers.aspx?bc="+drBC["bc"].ToString()+"&amp;dc="+drBC["dcPrefix"].ToString()+"' class='nodec'>"+drBC["dcPrefix"].ToString().ToUpper().Replace("_","")+"<BR/>BladeCenter #"+drBC["bc"].ToString()+"</A>";
						td.Attributes.Add("class","green");
						td.Attributes.Add("style","width:125px;");
					tr.Cells.Add(td);         //Output </TD>
					if (countBC==4)
					{
						bladeTbl.Rows.Add(tr);           //Output </TR>
						countBC=1;
					}
					else
					{
						countBC++;
					}	
				}
				bladeTbl.Rows.Add(tr);           //Output </TR>
			}
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
					newSql=newSql+"SELECT DISTINCT(rack),dcPrefix FROM "+dr["dcPrefix"].ToString()+"rackspace";
				}
			}
//			Response.Write(newSql+"<BR/>");
			sqlRack="SELECT * FROM ("+newSql+") AS rackPool WHERE rack IS NOT NULL AND rack!='' ORDER BY rack";
		}
	}
	else
	{
		sqlRack = "SELECT DISTINCT(rack),dcPrefix FROM "+sqlTablePrefix+"rackspace WHERE rack IS NOT NULL AND rack!='' ORDER BY rack";
	}
//	Response.Write(sqlRack+"<BR/>");
	datRack = readDb(sqlRack);
	if (datRack!=null)
	{
		fill=false;
		tr = new HtmlTableRow();    //Output <TR>
		tr.Attributes.Add("class","blackheading");
			td = new HtmlTableCell(); //Output <TD>
				td.Attributes.Add("colspan","4");
				td.InnerHtml = "Browse by Cabinet";
			tr.Cells.Add(td);         //Output </TD>
		rackTbl.Rows.Add(tr);           //Output </TR>
		countRack = 1;
		foreach (DataTable dtR in datRack.Tables)
		{
			foreach (DataRow drR in dtR.Rows)
			{	
				if (drR["rack"].ToString()!="")
				{
					string rackString="";
					DataSet datCabinet=new DataSet();
					sqlRack="SELECT location, rackId FROM "+drR["dcPrefix"].ToString()+"racks WHERE rackId='"+drR["rack"].ToString()+"'";
//					Response.Write(sqlRack+"<BR/>");
					datCabinet=readDb(sqlRack);
					if (datCabinet!=null)
					{
						try
						{
							rackString=drR["dcPrefix"].ToString().ToUpper().Replace("_","")+"<BR/> "+datCabinet.Tables[0].Rows[0]["location"].ToString()+"-R"+datCabinet.Tables[0].Rows[0]["rackId"].ToString().Substring(0,2)+"-C"+datCabinet.Tables[0].Rows[0]["rackId"].ToString().Substring(2,2);
						}
						catch (System.Exception ex)
						{
							rackString="ERR";
						}
					}
					if (countRack==1) tr = new HtmlTableRow();    //Output <TR>
					if (rackString=="") rackString="ERR";
					td = new HtmlTableCell(); //Output <TD>
						td.InnerHtml = "<A HREF='adminServers.aspx?rack="+drR["rack"].ToString()+"&amp;dc="+drR["dcPrefix"].ToString()+"' class='nodec'>"+rackString+"</A>";
						td.Attributes.Add("class","green");
						td.Attributes.Add("style","width:125px;");
					tr.Cells.Add(td);         //Output </TD>
					if (countRack==4)
					{
						rackTbl.Rows.Add(tr);           //Output </TR>
						countRack=1;
					}
					else
					{
						countRack++;
					}	
				}
				else
				{
					if (countRack==1) tr = new HtmlTableRow();    //Output <TR>
					td = new HtmlTableCell(); //Output <TD>
						td.InnerHtml = "ERR - Rack:"+drR["rack"].ToString();
						td.Attributes.Add("class","green");
						td.Attributes.Add("style","width:125px;");
					tr.Cells.Add(td);         //Output </TD>
					if (countRack==4)
					{
						rackTbl.Rows.Add(tr);           //Output </TR>
						countRack=1;
					}
					else
					{
						countRack++;
					}	
				}
				rackTbl.Rows.Add(tr);           //Output </TR>
			}
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
						newSql=newSql+" UNION ";
					}
					newSql=newSql+"SELECT DISTINCT serverOS FROM "+dr["dcPrefix"].ToString()+"servers";
				}
			}
//			Response.Write(newSql+"<BR/>");
			sqlOs=newSql+"";
		}
	}
	else
	{
		sqlOs = "SELECT DISTINCT serverOS FROM "+sqlTablePrefix+"servers";
	}
//	Response.Write(sqlOs+"<BR/>");
	datOs = readDb(sqlOs);
	if (datOs!=null)
	{
		fill=false;
		tr = new HtmlTableRow();    //Output <TR>
		tr.Attributes.Add("class","blackheading");
			td = new HtmlTableCell(); //Output <TD>
				td.Attributes.Add("colspan","3");
				td.InnerHtml = "Browse by OS";
			tr.Cells.Add(td);         //Output </TD>
		osTbl.Rows.Add(tr);           //Output </TR>
		countOs = 1;
		foreach (DataTable dtOs in datOs.Tables)
		{
			foreach (DataRow drOs in dtOs.Rows)
			{	
				if (drOs["serverOS"].ToString()!="")
				{
					if (countOs==1) tr = new HtmlTableRow();    //Output <TR>
					td = new HtmlTableCell(); //Output <TD>
						td.InnerHtml = "<A HREF='adminServers.aspx?os="+drOs["serverOS"].ToString()+"&amp;dc="+sqlTablePrefix+"' class='nodec'>"+drOs["serverOs"].ToString()+"</A>";
						td.Attributes.Add("class","green");
						td.Attributes.Add("style","width:170px;");
					tr.Cells.Add(td);         //Output </TD>
					if (countOs==3)
					{
						osTbl.Rows.Add(tr);           //Output </TR>
						countOs=1;
					}
					else
					{
						countOs++;
					}	
				}
				osTbl.Rows.Add(tr);           //Output </TR>
			}
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
						newSql=newSql+" UNION ";
					}
					newSql=newSql+"SELECT DISTINCT clusterName, dcPrefix FROM "+dr["dcPrefix"].ToString()+"clusters WHERE clusterType='ESX'";
				}
			}
//			Response.Write(newSql+"<BR/>");
			sqlVm=newSql+" ORDER BY clusterName";
		}
	}
	else
	{
		sqlVm = "SELECT DISTINCT clusterName, dcPrefix FROM "+sqlTablePrefix+"clusters WHERE clusterType='ESX' ORDER BY clusterName";
	}
//	Response.Write(sqlVm+"<BR/>");
	datVm = readDb(sqlVm);
	if (datVm!=null)
	{
		fill=false;
		tr = new HtmlTableRow();    //Output <TR>
		tr.Attributes.Add("class","blackheading");
			td = new HtmlTableCell(); //Output <TD>
				td.Attributes.Add("colspan","2");
				td.InnerHtml = "Browse VM Clusters";
			tr.Cells.Add(td);         //Output </TD>
		vmTbl.Rows.Add(tr);           //Output </TR>
		countVm = 1;
		foreach (DataTable dtVm in datVm.Tables)
		{
			foreach (DataRow drVm in dtVm.Rows)
			{	
				if (drVm["clusterName"].ToString()!="")
				{
					if (countVm==1) tr = new HtmlTableRow();    //Output <TR>
					td = new HtmlTableCell(); //Output <TD>
						td.InnerHtml = "<A HREF='adminServers.aspx?clstr="+drVm["clusterName"].ToString()+"&amp;dc="+drVm["dcPrefix"].ToString()+"' class='nodec'>"+drVm["dcPrefix"].ToString().ToUpper().Replace("_","")+": "+drVm["clusterName"].ToString()+"</A>";
						td.Attributes.Add("class","green");
						td.Attributes.Add("style","width:259px;");
					tr.Cells.Add(td);         //Output </TD>
					if (countVm==2)
					{
						vmTbl.Rows.Add(tr);           //Output </TR>
						countVm=1;
					}
					else
					{
						countVm++;
					}	
				}
				vmTbl.Rows.Add(tr);           //Output </TR>
			}
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
						newSql=newSql+" UNION ";
					}
					newSql=newSql+"SELECT * FROM "+dr["dcPrefix"].ToString()+"enviro";
				}
			}
//			Response.Write(newSql+"<BR/>");
			sqlEnv=newSql+" ORDER BY dcPrefix DESC, Id DESC";
		}
	}
	else
	{
		sqlEnv = "SELECT * FROM "+sqlTablePrefix+"enviro ORDER BY dcPrefix DESC, Id DESC";
	}
//	Response.Write(sqlVm+"<BR/>");
	datEnv = readDb(sqlEnv);
	if (datEnv!=null)
	{
		fill=false;
		tr = new HtmlTableRow();    //Output <TR>
		tr.Attributes.Add("class","blackheading");
			td = new HtmlTableCell(); //Output <TD>
				td.Attributes.Add("colspan","2");
				if (sqlTablePrefix=="*")
				{
					td.InnerHtml = "Browse ALL Environments";
				}
				else
				{
					td.InnerHtml = "Browse Environments - "+sqlTablePrefix.ToUpper().Replace("_","");
				}
			tr.Cells.Add(td);         //Output </TD>
		envTbl.Rows.Add(tr);           //Output </TR>
		countEnv = 1;
		foreach (DataTable dtEnv in datEnv.Tables)
		{
			foreach (DataRow drEnv in dtEnv.Rows)
			{	
				if (drEnv["Id"].ToString()!="")
				{
					if (countEnv==1) tr = new HtmlTableRow();    //Output <TR>
					td = new HtmlTableCell(); //Output <TD>
						td.InnerHtml = "<A HREF='adminServers.aspx?env="+drEnv["Id"].ToString()+"&amp;dc="+drEnv["dcPrefix"].ToString()+"' class='nodec'>("+drEnv["dcPrefix"].ToString().ToUpper().Replace("_","")+") "+drEnv["description"].ToString()+" - "+drEnv["Id"].ToString().ToUpper()+"</A>";
						td.Attributes.Add("class","green");
						td.Attributes.Add("style","width:259px;");
					tr.Cells.Add(td);         //Output </TD>
					if (countEnv==2)
					{
						envTbl.Rows.Add(tr);           //Output </TR>
						countEnv=1;
					}
					else
					{
						countEnv++;
					}	
				}
				envTbl.Rows.Add(tr);           //Output </TR>
			}
		}
	}


	if (bc!="" || bc!=null)
	{
		if (v_searchWord == "" && (string)ViewState["exportStr"]!="srch")
		{
			showBc();
//			ClientScript.RegisterStartupScript(this.GetType(), "hash", "location.hash = '#detail';", true);
		}

	}


	if (rack!="" || rack!=null)
	{
		if (v_searchWord == "" && (string)ViewState["exportStr"]!="srch")
		{
			showRack();
//			ClientScript.RegisterStartupScript(this.GetType(), "hash", "location.hash = '#detail';", true);
		}

	}


	if (os!="" || os!=null)
	{
		if (v_searchWord == "" && (string)ViewState["exportStr"]!="srch")
		{
			showOs();
//			ClientScript.RegisterStartupScript(this.GetType(), "hash", "location.hash = '#detail';", true);
		}

	}
	
	if (env!="" || env!=null)
	{
		if (v_searchWord == "" && (string)ViewState["exportStr"]!="srch")
		{
			showEnv();
//			ClientScript.RegisterStartupScript(this.GetType(), "hash", "location.hash = '#detail';", true);
		}

	}

	if (cluster!="" || cluster!=null)
	{
		if (v_searchWord == "" && (string)ViewState["exportStr"]!="srch")
		{
			showCluster();
//			ClientScript.RegisterStartupScript(this.GetType(), "hash", "location.hash = '#detail';", true);
		}
	}

	

	if (IsPostBack)
	{
		ClientScript.RegisterStartupScript(this.GetType(), "hash", "location.hash = '#detail';", true);
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

			<DIV class='center'>
				<BR/><BR/>
				<DIV id='addServer' runat='server'/>
				<BR/><BR/><BR/>
			</DIV>

			<TABLE id='vmTbl' runat='server' class='datatable center' />
			<BR/>
			<TABLE id='osTbl' runat='server' class='datatable center' />
			<BR/>
			<TABLE id='bladeTbl' runat='server' class='datatable center' />
			<BR/>
			<TABLE id='rackTbl' runat='server' class='datatable center' />
			<BR/>


			<TABLE id='envTbl' runat='server' class='datatable center' style='width:538px;' />
			<BR/><BR/>
			<A id='detail'>$nbsp;</A>		
			<DIV id='hrSpan' class='center' runat='server'/>
		
			<BR/>
		</DIV>

		<asp:Panel id='Panel1' runat='server' Height='25px' HorizontalAlign='right' BackColor='#ffffff'></asp:Panel>
		<BR/><BR/>
		
		<DIV style='text-align:center'>

			<TABLE id='svrTbl' runat='server' class='datatable center' />
			<BR/><BR/>
			<asp:Panel id='Panel2' runat='server' Height='25px' HorizontalAlign='right'></asp:Panel>
			<TABLE id='svrTbl1' runat='server' class='datatable center'  />

			<DIV id='errmsg' class='errorLine' runat='server'/><BR/>
		</DIV>
	</DIV> <!-- End: content -->

<!--#include file="closer.inc"-->

</DIV> <!-- End: container -->
</FORM>
</BODY>
</HTML>