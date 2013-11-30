<%@Page Inherits="CIS.conspectisLibrary" src="conspectisLibrary.cs" Language="C#" debug="true" %>
<%@Import Namespace="System.Data"%>
<%@Import Namespace="System.Drawing"%>
<%@Import Namespace="System"%>

<!DOCTYPE html>
<!-- HTML5 Status: VALID 1-31-13 CK -->
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
	Response.Write("<script type='text/JavaScript'>document.location.reload("+"true);<"+"/script>");
}

public void Page_Load(Object o, EventArgs e)
{
//UNCOMMENT this line to force login to access this page.
	lockout(); Page.Header.Title=shortSysName+": Manage Hardware";
	systemStatus(0); // Check to see if admin has put system is in offline mode.

//START Check if user is logged in by checking existence of cookie.
	loggedin.InnerHtml=loggedIn();
	adminMenu.InnerHtml=isAdmin();

	string sqlDialect=System.Configuration.ConfigurationManager.AppSettings["db_type"].ToString().ToUpper();

	bool noTable=false;
	string sql="", defaultDc="", sqlTablePrefix="", sql1="";
	DataSet dat = new DataSet();

/*--- MODIFY THE RACKS TABLES
	ALTER TABLE kcdc_rackspace ADD dcPrefix NVARCHAR(10) DEFAULT 'kcdc_'
	UPDATE kcdc_rackspace SET dcPrefix='kcdc_'   
	ALTER TABLE abqdc_rackspace ADD dcPrefix NVARCHAR(10) DEFAULT 'abqdc_'
	UPDATE abqdc_rackspace SET dcPrefix='abqdc_' 
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
	string v_username, v_userclass="", v_userrole="";
//	string v_searchWord = fix_txt(searchWord.Value);
//	string v_searchFrom = fix_txt(searchFrom.Value);
	int bcLimit=16, bcNum=1, slotLimit=14, slotNum=1, curSlot=1, index=0;
	bool emptySlot=false;
	string bc="", rack="", os="", env="", cluster="";
	ColorConverter colConvert = new ColorConverter();

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

	titleSpan.InnerHtml="<SPAN class='heading1'>Manage Hardware</SPAN>";


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
	
	HtmlTableRow tr;
	HtmlTableCell td;
	bool fill, permitted=false;

	if (System.Text.RegularExpressions.Regex.IsMatch(v_userrole, "datacenter", System.Text.RegularExpressions.RegexOptions.IgnoreCase))
	{
		permitted=true;
	}

	if (permitted)
	{
		if (sqlTablePrefix!="*")
		{
			addHardware.InnerHtml="<BUTTON id='addNewHdwButn' onclick=\"window.open('newHardware.aspx?dc="+sqlTablePrefix+"','newHardwareWin','width=425,height=800,menubar=no,status=yes,scrollbars=yes')\"><IMG src='./img/addIcon16.png' alt=''/>&nbsp; Add Hardware &nbsp;</BUTTON>&nbsp; &nbsp; &nbsp;<BUTTON id='addNewEsxButn' onclick=\"window.open('newCluster.aspx?dc="+sqlTablePrefix+"','newESXWin','width=400,height=450,menubar=no,status=yes,scrollbars=yes')\"><IMG src='./img/addIcon16.png' alt=''/>&nbsp; Add ESX Cluster &nbsp;</BUTTON>";
		}
		else
		{
			addHardware.InnerHtml = "<TABLE style='width:40%;' class='datatable center'><TR class='linktable'><TD style='width:150px;'><SPAN class='italic'>NOTE: Choose a datacenter to <BR/>add hardware and clusters.</SPAN></TD></TR></TABLE>";
		}
	}
	

	string sqlBC="", sql3650="", sql3850="", sqlPseries="", sqlOther="";
	DataSet datBC, dat3650, dat3850, datPseries, datOther;
	int countBC, count3650, count3850, countPseries, countOther;

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
					newSql=newSql+"SELECT * FROM "+dr["dcPrefix"].ToString()+"rackspace WHERE slot='00'";
				}
			}
//			Response.Write(newSql+"<BR/>");
			sqlBC=newSql+" ORDER BY bc ASC";
		}
	}
	else
	{
		sqlBC = "SELECT * FROM "+sqlTablePrefix+"rackspace WHERE slot='00' ORDER BY bc ASC";
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
				td.InnerHtml = "Browse BladeCenters";
			tr.Cells.Add(td);         //Output </TD>
		bcTbl.Rows.Add(tr);           //Output </TR>
		countBC = 1;
		foreach (DataTable dtBC in datBC.Tables)
		{
			foreach (DataRow drBC in dtBC.Rows)
			{	
				if (drBC["bc"].ToString()!="")
				{
					if (countBC==1) tr = new HtmlTableRow();    //Output <TR>
					td = new HtmlTableCell(); //Output <TD>
						td.Attributes.Add("class","green");
						if (permitted)
						{
							td.InnerHtml = "<P class='blackLink' onclick=\"window.open('editHardware.aspx?id="+drBC["rackspaceId"].ToString()+"&amp;dc="+drBC["dcPrefix"].ToString()+"','editHardwareWin','width=400,height=850,menubar=no,status=yes,scrollbars=yes')\">"+drBC["dcPrefix"].ToString().ToUpper().Replace("_","")+" BladeCenter #"+drBC["bc"].ToString()+"</P>";
						}
						else
						{
							td.InnerHtml = "<P class='blackLink' onclick=\"window.open('showHardware.aspx?id="+drBC["rackspaceId"].ToString()+"&amp;dc="+drBC["dcPrefix"].ToString()+"','showHardwareWin','width=400,height=850,menubar=no,status=yes,scrollbars=yes')\">"+drBC["dcPrefix"].ToString().ToUpper().Replace("_","")+" BladeCenter #"+drBC["bc"].ToString()+"</P>";
						}
						td.Attributes.Add("style","width:125px;");
					tr.Cells.Add(td);         //Output </TD>
					if (countBC==4)
					{
						bcTbl.Rows.Add(tr);           //Output </TR>
						countBC=1;
					}
					else
					{
						countBC++;
					}	
				}
				bcTbl.Rows.Add(tr);           //Output </TR>
			}
		}
	}
	else
	{
		tr = new HtmlTableRow();    //Output <TR>
		tr.Attributes.Add("class","blackheading");
			td = new HtmlTableCell(); //Output <TD>
				td.Attributes.Add("colspan","4");
				td.Attributes.Add("style","width:500px;");
				td.InnerHtml = "BLADES: No Hardware Found";
				td.Attributes.Add("class","green");
			tr.Cells.Add(td);         //Output </TD>
		bcTbl.Rows.Add(tr);           //Output </TR>
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
					newSql=newSql+"SELECT * FROM "+dr["dcPrefix"].ToString()+"rackspace WHERE class IN(SELECT hwClassName FROM hwTypes WHERE hwType='Server' AND hwClassName NOT LIKE 'P%' AND hwClassName NOT IN ('RSA2 /Management','Virtual'))";
				}
			}
//			Response.Write(newSql+"<BR/>");
			sql3650=newSql+" ORDER BY rack ASC, slot ASC";
		}
	}
	else
	{
		sql3650 = "SELECT * FROM "+sqlTablePrefix+"rackspace WHERE class IN(SELECT hwClassName FROM hwTypes WHERE hwType='Server' AND hwClassName NOT LIKE 'P%' AND hwClassName NOT IN ('RSA2 /Management','Virtual')) ORDER BY rack ASC, slot ASC";
	}
	
	dat3650 = readDb(sql3650);
	if (dat3650!=null)
	{
		fill=false;
		tr = new HtmlTableRow();    //Output <TR>
		tr.Attributes.Add("class","blackheading");
			td = new HtmlTableCell(); //Output <TD>
				td.Attributes.Add("colspan","4");
				td.InnerHtml = "Browse xSeries";
			tr.Cells.Add(td);         //Output </TD>
		tblXSeries.Rows.Add(tr);           //Output </TR>
		count3650 = 1;
		foreach (DataTable dt3650 in dat3650.Tables)
		{
			foreach (DataRow dr3650 in dt3650.Rows)
			{	
				if (dr3650["slot"].ToString()!="")
				{
					string sqlRack="", rackString="";
					DataSet datRack=new DataSet();
					sqlRack="SELECT location, rackId FROM "+dr3650["dcPrefix"].ToString()+"racks WHERE rackId='"+dr3650["rack"].ToString()+"'";
//					Response.Write(sqlRack+"<BR/>");
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
					if (count3650==1) tr = new HtmlTableRow();    //Output <TR>
					td = new HtmlTableCell(); //Output <TD>
						td.Attributes.Add("class","green");
						if (permitted)
						{
							td.InnerHtml = "<P class='blackLink' onclick=\"window.open('editHardware.aspx?id="+dr3650["rackspaceId"].ToString()+"&amp;dc="+dr3650["dcPrefix"].ToString()+"','editHardwareWin','width=400,height=800,menubar=no,status=yes,scrollbars=yes')\">"+dr3650["dcPrefix"].ToString().ToUpper().Replace("_","")+" "+dr3650["class"].ToString()+"<BR/>"+rackString+"<BR/>Slot "+dr3650["slot"].ToString()+"</P>";
						}
						else
						{
							td.InnerHtml = "<P class='blackLink' onclick=\"window.open('showHardware.aspx?id="+dr3650["rackspaceId"].ToString()+"&amp;dc="+dr3650["dcPrefix"].ToString()+"','showHardwareWin','width=400,height=800,menubar=no,status=yes,scrollbars=yes')\">"+dr3650["dcPrefix"].ToString().ToUpper().Replace("_","")+" "+dr3650["class"].ToString()+"<BR/>"+rackString+"<BR/>Slot "+dr3650["slot"].ToString()+"</P>";
						}
						td.Attributes.Add("style","width:125px;");
					tr.Cells.Add(td);         //Output </TD>
					if (count3650==4)
					{
						tblXSeries.Rows.Add(tr);           //Output </TR>
						count3650=1;
					}
					else
					{
						count3650++;
					}	
				}
				tblXSeries.Rows.Add(tr);           //Output </TR>
			}
		}
	}
	else
	{
		tr = new HtmlTableRow();    //Output <TR>
		tr.Attributes.Add("class","blackheading");
			td = new HtmlTableCell(); //Output <TD>
				td.Attributes.Add("colspan","4");
				td.Attributes.Add("style","width:500px;");
				td.InnerHtml = "XSERIES: No Hardware Found";
				td.Attributes.Add("class","green");
			tr.Cells.Add(td);         //Output </TD>
		tblXSeries.Rows.Add(tr);           //Output </TR>
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
					newSql=newSql+"SELECT * FROM "+dr["dcPrefix"].ToString()+"rackspace WHERE class IN(SELECT hwClassName FROM hwTypes WHERE hwType='Server' AND hwClassName LIKE 'P%') ";
				}
			}
//			Response.Write(newSql+"<BR/>");
			sqlPseries=newSql+" ORDER BY rack ASC, slot ASC";
		}
	}
	else
	{
		sqlPseries = "SELECT * FROM "+sqlTablePrefix+"rackspace WHERE class IN(SELECT hwClassName FROM hwTypes WHERE hwType='Server' AND hwClassName LIKE 'P%') ORDER BY rack ASC, slot ASC";
	}
	
	datPseries = readDb(sqlPseries);
	if (datPseries!=null)
	{
		fill=false;
		tr = new HtmlTableRow();    //Output <TR>
		tr.Attributes.Add("class","blackheading");
			td = new HtmlTableCell(); //Output <TD>
				td.Attributes.Add("colspan","4");
				td.InnerHtml = "Browse P-Series";
			tr.Cells.Add(td);         //Output </TD>
		tblPseries.Rows.Add(tr);           //Output </TR>
		countPseries = 1;
		foreach (DataTable dtPseries in datPseries.Tables)
		{
			foreach (DataRow drPseries in dtPseries.Rows)
			{	
				if (drPseries["slot"].ToString()!="")
				{
					string sqlRack="", rackString="";
					DataSet datRack=new DataSet();
					sqlRack="SELECT location, rackId FROM "+drPseries["dcPrefix"].ToString()+"racks WHERE rackId='"+drPseries["rack"].ToString()+"'";
//					Response.Write(sqlRack+"<BR/>");
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
					if (countPseries==1) tr = new HtmlTableRow();    //Output <TR>
					td = new HtmlTableCell(); //Output <TD>
						td.Attributes.Add("class","green");
						if (permitted)
						{
							td.InnerHtml = "<P class='blackLink' onclick=\"window.open('editHardware.aspx?id="+drPseries["rackspaceId"].ToString()+"&amp;dc="+drPseries["dcPrefix"].ToString()+"','editHardwareWin','width=400,height=800,menubar=no,status=yes,scrollbars=yes')\">"+drPseries["dcPrefix"].ToString().ToUpper().Replace("_","")+" "+drPseries["class"].ToString()+"<BR/>"+rackString+"<BR/>Slot "+drPseries["slot"].ToString()+"</P>";
						}
						else
						{
							td.InnerHtml = "<P class='blackLink' onclick=\"window.open('showHardware.aspx?id="+drPseries["rackspaceId"].ToString()+"&amp;dc="+drPseries["dcPrefix"].ToString()+"','showHardwareWin','width=400,height=800,menubar=no,status=yes,scrollbars=yes')\">"+drPseries["dcPrefix"].ToString().ToUpper().Replace("_","")+" "+drPseries["class"].ToString()+"<BR/>"+rackString+"<BR/>Slot "+drPseries["slot"].ToString()+"</P>";
						}
						td.Attributes.Add("style","width:125px;");
					tr.Cells.Add(td);         //Output </TD>
					if (countPseries==4)
					{
						tblPseries.Rows.Add(tr);           //Output </TR>
						countPseries=1;
					}
					else
					{
						countPseries++;
					}	
				}
				tblPseries.Rows.Add(tr);           //Output </TR>
			}
		}
	}
	else
	{
		tr = new HtmlTableRow();    //Output <TR>
		tr.Attributes.Add("class","blackheading");
			td = new HtmlTableCell(); //Output <TD>
				td.Attributes.Add("colspan","4");
				td.Attributes.Add("style","width:500px;");
				td.InnerHtml = "PSERIES: No Hardware Found";
				td.Attributes.Add("class","green");
			tr.Cells.Add(td);         //Output </TD>
		tblPseries.Rows.Add(tr);           //Output </TR>
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
					newSql=newSql+"SELECT * FROM "+dr["dcPrefix"].ToString()+"rackspace WHERE class IN(SELECT hwClassName FROM hwTypes WHERE hwType NOT IN('Server','Blade','Chassis'))";
				}
			}
//			Response.Write(newSql+"<BR/>");
			sqlOther=newSql+" ORDER BY rack ASC, slot ASC";
		}
	}
	else
	{
		sqlOther = "SELECT * FROM "+sqlTablePrefix+"rackspace WHERE class IN(SELECT hwClassName FROM hwTypes WHERE hwType NOT IN('Server','Blade','Chassis')) ORDER BY rack ASC, slot ASC";
	}

	
	datOther = readDb(sqlOther);
	if (datOther!=null)
	{
		fill=false;
		tr = new HtmlTableRow();    //Output <TR>
		tr.Attributes.Add("class","blackheading");
			td = new HtmlTableCell(); //Output <TD>
				td.Attributes.Add("colspan","4");
				td.InnerHtml = "Browse Other Hardware";
			tr.Cells.Add(td);         //Output </TD>
		tblOther.Rows.Add(tr);           //Output </TR>
		countOther = 1;
		foreach (DataTable dtOther in datOther.Tables)
		{
			foreach (DataRow drOther in dtOther.Rows)
			{	
				if (drOther["slot"].ToString()!="")
				{
					string sqlRack="", rackString="";
					DataSet datRack=new DataSet();
					sqlRack="SELECT location, rackId FROM "+drOther["dcPrefix"].ToString()+"racks WHERE rackId='"+drOther["rack"].ToString()+"'";
//					Response.Write(sqlRack+"<BR/>");
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
					if (countOther==1) tr = new HtmlTableRow();    //Output <TR>
					td = new HtmlTableCell(); //Output <TD>
						td.Attributes.Add("class","green");
						if (permitted)
						{
							td.InnerHtml = "<P class='blackLink' onclick=\"window.open('editHardware.aspx?id="+drOther["rackspaceId"].ToString()+"&amp;dc="+drOther["dcPrefix"].ToString()+"','editHardwareWin','width=400,height=800,menubar=no,status=yes,scrollbars=yes')\">"+drOther["dcPrefix"].ToString().ToUpper().Replace("_","")+" "+drOther["class"].ToString()+"<BR/>"+rackString+"<BR/>Slot "+drOther["slot"].ToString()+"</P>";
						}
						else
						{
							td.InnerHtml = "<P class='blackLink' onclick=\"window.open('showHardware.aspx?id="+drOther["rackspaceId"].ToString()+"&amp;dc="+drOther["dcPrefix"].ToString()+"','editHardwareWin','width=400,height=800,menubar=no,status=yes,scrollbars=yes')\">"+drOther["dcPrefix"].ToString().ToUpper().Replace("_","")+" "+drOther["class"].ToString()+"<BR/>"+rackString+"<BR/>Slot "+drOther["slot"].ToString()+"</P>";
						}
						td.Attributes.Add("style","width:125px;");
					tr.Cells.Add(td);         //Output </TD>
					if (countOther==4)
					{
						tblOther.Rows.Add(tr);           //Output </TR>
						countOther=1;
					}
					else
					{
						countOther++;
					}	
				}
				tblOther.Rows.Add(tr);           //Output </TR>
			}
		}
	}
	else
	{
		tr = new HtmlTableRow();    //Output <TR>
		tr.Attributes.Add("class","blackheading");
			td = new HtmlTableCell(); //Output <TD>
				td.Attributes.Add("colspan","4");
				td.Attributes.Add("style","width:500px;");
				td.Attributes.Add("class","green");
				td.InnerHtml = "OTHER: No Hardware Found";
			tr.Cells.Add(td);         //Output </TD>
		tblOther.Rows.Add(tr);           //Output </TR>
	}

	if (IsPostBack)
	{

	}
}
</SCRIPT>
</HEAD>

<!--#include file="body.inc" -->
<FORM id='form1' runat='server'>
<DIV id='container'>
<!--#include file="banner.inc" -->
<!--#include file="menu.inc" -->

	<DIV id='content'>
		<SPAN id='titleSpan' runat='server'/>
		<DIV class='center'>
			<BR/><BR/>
			<DIV id='addHardware' runat='server'/>
			<BR/><BR/><BR/>
		</DIV>
		<TABLE id='tblXSeries' runat='server' class='datatable center' />
		<BR/>
		<TABLE id='bcTbl' runat='server' class='datatable center' />
		<BR/>
		<TABLE id='tblPseries' runat='server' class='datatable center' />
		<BR/>
		<TABLE id='tblOther' runat='server' class='datatable center' />
		<BR/>
	</DIV> <!-- End: content -->

<!--#include file="closer.inc"-->

</DIV> <!-- End: container -->
</FORM>
</BODY>
</HTML>