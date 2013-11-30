<%@Page Inherits="CIS.conspectisLibrary" src="conspectisLibrary.cs" Language="C#" debug="true" %>
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
}

public void Page_Load(Object o, EventArgs e)
{
//UNCOMMENT this line to force login to access this page.
	lockout(); Page.Header.Title=shortSysName+": Report - Data Center Inventory";
	systemStatus(0); // Check to see if admin has put system is in offline mode.

//START Check if user is logged in by checking existence of cookie.
	loggedin.InnerHtml=loggedIn();
	adminMenu.InnerHtml=isAdmin();

	DateTime dateStamp = DateTime.Now;
	string v_username, curStat="";
	string sql="", sql2="", status="";
	bool fill;
	HtmlTableRow tr;
	HtmlTableCell td;
	DataSet dat, dat2, dat3, portDat=new DataSet();

	try
	{
		v_username=Request.Cookies["username"].Value;
	}
	catch (System.Exception ex)
	{
		v_username="";
	}

	titleSpan.InnerHtml="<SPAN class='heading1'>Data Center Inventory</SPAN>";

	sql= "SELECT rackspaceId, rack, bc, slot, class, serial, model, sanAttached FROM rackspace WHERE class NOT IN ('Virtual','') ORDER BY class ASC, bc ASC, rack ASC, slot ASC";
	dat=readDb(sql);
	if (!emptyDataset(dat))
	{
		fill=false;
		tr = new HtmlTableRow();    //Output <TR>
			tr.Attributes.Add("class","blackheading");
			td = new HtmlTableCell(); //Output <TD>
				td.Attributes.Add("colspan","9");
				td.InnerHtml = "Inventory";
			tr.Cells.Add(td);         //Output </TD>
		svrTbl.Rows.Add(tr);           //Output </TR>
		tr = new HtmlTableRow();    //Output <TR>
			tr.Attributes.Add("class","tableheading");
			td = new HtmlTableCell(); //Output <TD>
				td.InnerHtml = "Row/Cabinet";
			tr.Cells.Add(td);         //Output </TD>
			td = new HtmlTableCell(); //Output <TD>
				td.InnerHtml = "BC";
			tr.Cells.Add(td);         //Output </TD>
			td = new HtmlTableCell(); //Output <TD>
				td.InnerHtml = "Slot";
			tr.Cells.Add(td);         //Output </TD>
			td = new HtmlTableCell(); //Output <TD>
				td.InnerHtml = "Hardware Class";
			tr.Cells.Add(td);         //Output </TD>
			td = new HtmlTableCell(); //Output <TD>
				td.InnerHtml = "Serial";
			tr.Cells.Add(td);         //Output </TD>
			td = new HtmlTableCell(); //Output <TD>
				td.InnerHtml = "Model";
			tr.Cells.Add(td);         //Output </TD>
			td = new HtmlTableCell(); //Output <TD>
				td.InnerHtml = "Servers Hosted";
			tr.Cells.Add(td);         //Output </TD>
			td = new HtmlTableCell(); //Output <TD>
				td.InnerHtml = "Ethernet Connections";
			tr.Cells.Add(td);         //Output </TD>
			td = new HtmlTableCell(); //Output <TD>
				td.InnerHtml = "SAN Attached?";
			tr.Cells.Add(td);         //Output </TD>
		svrTbl.Rows.Add(tr);           //Output </TR>
		foreach (DataTable dt in dat.Tables)
		{
			foreach (DataRow dr in dt.Rows)
			{
				tr = new HtmlTableRow();    //Output <TR>
				if (fill) tr.Attributes.Add("class","altrow");
					td = new HtmlTableCell(); //Output <TD>
						if (dr["rack"].ToString()=="")
						{
							td.InnerHtml = "&#xa0;";
						}
						else
						{
							td.InnerHtml = "Row:"+dr["rack"].ToString().Substring(0,2)+", Cabinet:"+dr["rack"].ToString().Substring(2,2);
						}
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						if (dr["bc"].ToString()=="")
						{
							td.InnerHtml = "&#xa0;";
						}
						else
						{
							td.InnerHtml = dr["bc"].ToString();
						}
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						if (dr["slot"].ToString()=="")
						{
							td.InnerHtml = "&#xa0;";
						}
						else
						{
							td.InnerHtml = dr["slot"].ToString();
						}
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						if (dr["class"].ToString()=="")
						{
							td.InnerHtml = "&#xa0;";
						}
						else
						{
							td.InnerHtml = dr["class"].ToString();
						}
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						if (dr["serial"].ToString()=="")
						{
							td.InnerHtml = "&#xa0;";
						}
						else
						{
							td.InnerHtml = dr["serial"].ToString();
						}
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						if (dr["model"].ToString()=="")
						{
							td.InnerHtml = "&#xa0;";
						}
						else
						{
							td.InnerHtml = dr["model"].ToString();
						}
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						td.Style.Add("font-size","8pt");
						sql = "SELECT serverName, serverLanIp FROM servers WHERE rackspaceId="+dr["rackspaceId"].ToString();
						dat2=readDb(sql);
						string serverString="";
						if (!emptyDataset(dat2))
						{
							foreach (DataTable dtt in dat2.Tables)
							{
								foreach (DataRow drr in dtt.Rows)
								{
									serverString = serverString+drr["serverName"].ToString()+" - "+fix_ip(fix_ip(drr["serverLanIp"].ToString()))+"<BR/>";
								}
							}
							td.InnerHtml = serverString;
						}
						else
						{
							td.InnerHtml = "&#xa0;";
						}
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						td.Style.Add("font-size","8pt");
						sql="SELECT switchName FROM switches WHERE switchName LIKE 'access%' ORDER BY switchName ASC";
						dat2=readDb(sql);
						string portString="";
						if (!emptyDataset(dat2))
						{
							foreach (DataTable dtt in dat2.Tables)
							{
								foreach (DataRow drr in dtt.Rows)
								{
									sql2="SELECT switchId, slot, portNum, comment FROM "+drr["switchName"].ToString()+" WHERE cabledTo="+dr["rackspaceId"].ToString()+" ORDER BY comment ASC";
									dat3=readDb(sql2);
									if (dat3!=null)
									{
										portDat.Merge(dat3);
									}
								}
							}
							portDat.Tables[0].DefaultView.Sort="comment ASC";
							if (portDat!=null)
							{
								foreach (DataTable dttt in portDat.Tables)
								{
									foreach (DataRow drrr in dttt.Rows)
									{
										portString = portString+drrr["comment"].ToString()+": "+drrr["switchId"].ToString()+", Slot "+drrr["slot"].ToString()+", Port "+drrr["portNum"].ToString()+"<BR/>";
									}
								}
								td.InnerHtml = portString;
							}
							portDat.Clear();							
						}
						else
						{
							td.InnerHtml = "&#xa0;";
						}
						if ((dr["class"].ToString()=="HS21" || dr["class"].ToString()=="JS22") && portString=="")
						{
							td.InnerHtml="Managed Switch, BC"+dr["bc"].ToString();
						}
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						string sanStat="No";
						if (dr["sanAttached"].ToString()=="1")
						{
							sanStat="Yes";
						}
						td.InnerHtml = sanStat;
					tr.Cells.Add(td);         //Output </TD>
				svrTbl.Rows.Add(tr);           //Output </TR>
				fill=!fill;
			}
		}
	}

	if (IsPostBack)
	{

	}
}
</SCRIPT>
</HEAD>

<!--#include file='body.inc' -->
<FORM id='form1' runat='server'>
<DIV id='container'>
<!--#include file='banner.inc' -->
<!--#include file='menu.inc' -->
	<DIV id='content'>
		<SPAN id='titleSpan' runat='server'/>
		<DIV class='center'>
			<TABLE id='svrTbl' runat='server' class='datatable center' />
		</DIV>
		&nbsp;<BR/>
	</DIV> <!-- End: content -->
<!--#include file='closer.inc'-->
</DIV> <!-- End: container -->
</FORM>
</BODY>
</HTML>