<%@Page Inherits="CIS.conspectisLibrary" src="conspectisLibrary.cs" Language="C#" debug="true" %>
<%@Import Namespace="System.Data.OleDb"%>
<%@Import Namespace="System.Collections"%>
<%@Import Namespace="System.Data"%>
<%@Import Namespace="System.IO"%>
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
//	lockout(); 
	Page.Header.Title=shortSysName+": Prepare VMCP Export (CSV)";
	systemStatus(0); // Check to see if admin has put system is in offline mode.

//START Check if user is logged in by checking existence of cookie.
//	loggedin.InnerHtml=loggedIn();
	adminMenu.InnerHtml=isAdmin();

	DateTime dateStamp = DateTime.Now;
	string v_username, curStat="";
	string sqlPhe="", sqlPrp="", sqlQa="",status="", fileExt="";
	DataSet datPhe, datPrp, datQa;
	HtmlTableRow tr;
	HtmlTableCell td;
	bool fill=false;

	try
	{
		v_username=Request.Cookies["username"].Value;
	}
	catch (System.Exception ex)
	{
		v_username="";
	}



	titleSpan.InnerHtml="<SPAN class='heading1'>Prepare VMWare Capacity Planner Export (CSV)</SPAN>";

// Empty the Export folder of old VMCP Export Files
	DirectoryInfo diDel = new DirectoryInfo(Server.MapPath("./vmware/export/"));
	FileInfo[] filesDel = diDel.GetFiles("export_vmcp*.csv");
	foreach (FileInfo file in filesDel)
	{
		try
		{
			System.IO.File.Delete(file.FullName.ToString());
		}
		catch (System.Exception ex)
		{
		}
	}

// Build the new VMCP Export Files
	sqlPhe="SELECT * FROM (SELECT serverName, serverLanIp, serverOS FROM servers WHERE serverName LIKE '%PHE%') ORDER BY serverOS ASC, serverName ASC";

// This is a SMART way to do VMCP, but -- manament preferred to swing a massive stick ...
//	sqlPhe="SELECT * FROM (SELECT serverName, serverLanIp, serverOS FROM (SELECT * FROM servers WHERE serverName LIKE '%PHE%') WHERE serverOS IN('Windows','Linux','AIX') AND memberOfCluster IS NULL) WHERE serverLanIp<>'' AND serverLanIp IS NOT NULL ORDER BY serverOS ASC, serverName ASC, serverLanIp ASC"; 
	datPhe=readDb(sqlPhe);

	sqlPrp="SELECT * FROM (SELECT serverName, serverLanIp, serverOS FROM servers WHERE serverName LIKE '%PRP%') ORDER BY serverOS ASC, serverName ASC";
// This is a SMART way to do VMCP, but -- manament preferred to swing a massive stick ...
//	sqlPrp="SELECT * FROM (SELECT serverName, serverLanIp, serverOS FROM (SELECT * FROM servers WHERE serverName LIKE '%PRP%') WHERE serverOS IN('Windows','Linux','AIX') AND memberOfCluster IS NULL) WHERE serverLanIp<>'' AND serverLanIp IS NOT NULL ORDER BY serverOS ASC, serverName ASC, serverLanIp ASC";
	datPrp=readDb(sqlPrp);

	sqlQa="SELECT * FROM (SELECT serverName, serverLanIp, serverOS FROM servers WHERE serverName LIKE '%SLQA%' UNION SELECT serverName, serverLanIp, serverOS FROM servers WHERE serverName LIKE '%SXQA%' UNION SELECT serverName, serverLanIp, serverOS FROM servers WHERE serverName LIKE '%SVQA%' UNION SELECT serverName, serverLanIp, serverOS FROM servers WHERE serverName LIKE '%ZLQA%' UNION SELECT serverName, serverLanIp, serverOS FROM servers WHERE serverName LIKE '%ZXQA%')ORDER BY serverOS ASC, serverName ASC";
// This is a SMART way to do VMCP, but -- manament preferred to swing a massive stick ...
//	sqlQa="SELECT * FROM (SELECT serverName, serverLanIp, serverOS FROM (SELECT * FROM servers WHERE serverName LIKE 'SXQA%' UNION SELECT * FROM servers WHERE serverName LIKE 'SLQA%' UNION SELECT * FROM servers WHERE serverName LIKE 'SVQA%') WHERE serverOS IN('Windows','Linux','AIX') AND memberOfCluster IS NULL) WHERE serverLanIp<>'' AND serverLanIp IS NOT NULL ORDER BY serverOS ASC, serverName ASC, serverLanIp ASC";
	datQa=readDb(sqlQa);

	if (datPhe!=null)
	{
		string filePath = Server.MapPath("./vmware/export/export_vmcp_phe_"+dateStamp.Hour.ToString() + dateStamp.Minute.ToString() + dateStamp.Second.ToString()+".csv");
		StreamWriter sw = new StreamWriter(filePath, false);
		sw.Write("Location,ServName,Memory,Processor,Tape Drive,Peripherals,OS,Model,TagNo,BadgeNo,ServRole,IP,IPXSegAddress,IPXIntNo,PurcDate,WarrExpDate,Location,SAN,RAID,Disk1,Disk2,Disk3");
		sw.Write(sw.NewLine);
		foreach (DataTable dt in datPhe.Tables)
		{
			foreach (DataRow dr in dt.Rows)
			{
				sw.Write("'PHE','"+dr["serverName"].ToString()+"',,,,,'"+dr["serverOs"].ToString()+"',,,,,'"+fix_ip(dr["serverLanIp"].ToString())+"',,,,,,,,,,");
				sw.Write(sw.NewLine);
			}
		}
		sw.Close();
	}

	if (datPrp!=null)
	{
		string filePath = Server.MapPath("./vmware/export/export_vmcp_prp_"+dateStamp.Hour.ToString() + dateStamp.Minute.ToString() + dateStamp.Second.ToString()+".csv");
		StreamWriter sw = new StreamWriter(filePath, false);
		sw.Write("Location,ServName,Memory,Processor,Tape Drive,Peripherals,OS,Model,TagNo,BadgeNo,ServRole,IP,IPXSegAddress,IPXIntNo,PurcDate,WarrExpDate,Location,SAN,RAID,Disk1,Disk2,Disk3");
		sw.Write(sw.NewLine);
		foreach (DataTable dt in datPrp.Tables)
		{
			foreach (DataRow dr in dt.Rows)
			{

				sw.Write("'PRP','"+dr["serverName"].ToString()+"',,,,,'"+dr["serverOs"].ToString()+"',,,,,'"+fix_ip(dr["serverLanIp"].ToString())+"',,,,,,,,,,");
				sw.Write(sw.NewLine);
			}
		}
		sw.Close();
	}

	if (datQa!=null)
	{
		string filePath = Server.MapPath("./vmware/export/export_vmcp_qa_"+dateStamp.Hour.ToString() + dateStamp.Minute.ToString() + dateStamp.Second.ToString()+".csv");
		StreamWriter sw = new StreamWriter(filePath, false);
		sw.Write("Location,ServName,Memory,Processor,Tape Drive,Peripherals,OS,Model,TagNo,BadgeNo,ServRole,IP,IPXSegAddress,IPXIntNo,PurcDate,WarrExpDate,Location,SAN,RAID,Disk1,Disk2,Disk3");
		sw.Write(sw.NewLine);
		foreach (DataTable dt in datQa.Tables)
		{
			foreach (DataRow dr in dt.Rows)
			{
				sw.Write("'QA','"+dr["serverName"].ToString()+"',,,,,'"+dr["serverOs"].ToString()+"',,,,,'"+fix_ip(dr["serverLanIp"].ToString())+"',,,,,,,,,,");
				sw.Write(sw.NewLine);
			}
		}
		sw.Close();
	}

	if (IsPostBack)
	{
	}

// Present the user with list of downloadable VMCP Export Files
	DirectoryInfo di = new DirectoryInfo(Server.MapPath("./vmware/export/"));
	FileInfo[] files = di.GetFiles("export_vmcp*.csv");
	Array.Sort(files, (x, y) => Comparer<DateTime>.Default.Compare(x.CreationTime, y.CreationTime));

	if (files!=null)
	{
		fill=false;
		tr = new HtmlTableRow();    //Output <TR>
			tr.Attributes.Add("class","blackheading");
			td = new HtmlTableCell(); //Output <TD>
				td.Attributes.Add("colspan","4");
				td.InnerHtml = "VMCP Export Files";
			tr.Cells.Add(td);         //Output </TD>
		filesTbl.Rows.Add(tr);           //Output </TR>
		tr = new HtmlTableRow();    //Output <TR>
			tr.Attributes.Add("class","tableheading");
			td = new HtmlTableCell(); //Output <TD>
				td.InnerHtml = "File";
			tr.Cells.Add(td);         //Output </TD>
			td = new HtmlTableCell(); //Output <TD>
				td.InnerHtml = "&#xa0;";
			tr.Cells.Add(td);         //Output </TD>
			td = new HtmlTableCell(); //Output <TD>
				td.InnerHtml = "Date";
			tr.Cells.Add(td);         //Output </TD>
			td = new HtmlTableCell(); //Output <TD>
				td.InnerHtml = "Size";
			tr.Cells.Add(td);         //Output </TD>
		filesTbl.Rows.Add(tr);           //Output </TR>
		foreach (FileInfo file in files)
		{
			tr = new HtmlTableRow();    //Output <TR>
			if (fill) tr.Attributes.Add("class","altrow");
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml = "<A class='black' href='./vmware/export/"+file.Name+"'>"+file.Name+"</A>";
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					fileExt=file.Name.ToString().Substring(file.Name.ToString().IndexOf('.')+1).ToUpper();
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml = file.LastWriteTime.ToString();
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml = file.Length/1000+"kb";
				tr.Cells.Add(td);         //Output </TD>
//				Response.Write(file.Name+" - "+file.LastWriteTime+" - "+file.Length/1000+"kb<BR/>");
			filesTbl.Rows.Add(tr);           //Output </TR>
			fill=!fill;
		}
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
			<DIV>
				<TABLE id='filesTbl' runat='server' class='datatable' />
			</DIV>
		</DIV>
	</DIV> <!-- End: content -->
<!--#include file='closer.inc'-->
</DIV> <!-- End: container -->
</FORM>
</BODY>
</HTML>