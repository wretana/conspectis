<%@Page Inherits="CIS.conspectisLibrary" src="conspectisLibrary.cs" Language="C#" debug="true" %>
<%@Import Namespace="System.Data.OleDb"%>
<%@Import Namespace="System.Collections"%>
<%@Import Namespace="System.Data"%>
<%@Import Namespace="System.IO"%>
<%@Import Namespace="System"%>

<!DOCTYPE html>
<!-- HTML5 Status: VALID 2-7-13 CK -->
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

public void Page_Load(Object o, EventArgs e)
{
//UNCOMMENT this line to force login to access this page.
	lockout(); 
	Page.Header.Title=shortSysName+": Template";
	systemStatus(0); // Check to see if admin has put system is in offline mode.

//START Check if user is logged in by checking existence of cookie.
//	loggedin.InnerHtml=loggedIn();
	adminMenu.InnerHtml=isAdmin();

	string sqlDialect=System.Configuration.ConfigurationManager.AppSettings["db_type"].ToString().ToUpper();

	DateTime dateStamp = DateTime.Now;
	string v_username, curStat="";
	string sql="", status="", filePath="", fileExt="", fileImg="", fileOnclick="", defaultDc="", sqlTablePrefix="";
	HtmlTableRow tr;
	HtmlTableCell td;
	bool fill;
	DataSet dat = new DataSet();

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
	}

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

	titleSpan.InnerHtml="<SPAN class='heading1'>User Guides</SPAN>";

	filePath=Server.MapPath("manual/");

	sql= "";
//	dat=readDb(sql);

	if (IsPostBack)
	{

	}

	DirectoryInfo di = new DirectoryInfo(filePath);
	FileInfo[] files = di.GetFiles("*.*");

	if (files!=null)
	{
		fill=false;
		tr = new HtmlTableRow();    //Output <TR>
			tr.Attributes.Add("class","blackheading");
			td = new HtmlTableCell(); //Output <TD>
				td.Attributes.Add("colspan","4");
				td.InnerHtml = "Guides & Documentation";
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
					td.InnerHtml = "<A class='black' href='./manual/"+file.Name+"'>"+file.Name+"</A>";
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					fileExt=file.Name.ToString().Substring(file.Name.ToString().IndexOf('.')+1).ToUpper();
					switch (fileExt)
					{
					case "VSD":
						fileImg="visio.jpg";
						fileOnclick="\"window.open('http://www.microsoft.com/en-us/download/details.aspx?id=21701',GetViewer)\"";
						break;
					case "DOC":
					case "DOCX":
						fileImg="word.gif";
						fileOnclick="\"window.open('http://www.microsoft.com/en-us/download/details.aspx?id=4',GetViewer)\"";
						break;
					case "XLS":
					case "XLSX":
						fileImg="excel.gif";
						fileOnclick="\"window.open('http://www.microsoft.com/en-us/download/details.aspx?id=10',GetViewer)\"";
						break;
					case "PDF":
						fileImg="acrobat.gif";
						fileOnclick="\"window.open('http://get.adobe.com/reader/',GetViewer)\"";
						break;					
					case "TXT":
						fileImg="text.gif";
						fileOnclick="";
						break;
					default:
						fileImg="genericFile.gif";
						fileOnclick="";
						break;
					}
					td.InnerHtml="<INPUT type='image' src='./img/"+fileImg+"' onclick="+fileOnclick+" ALT='File Type Icon' />";
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

<!--#include file="body.inc" -->
<FORM id='form1' runat='server'>
<DIV id='container'>
<!--#include file="banner.inc" -->
<!--#include file="menu.inc" -->
	<DIV id='content'>
		<SPAN id='titleSpan' runat='server'/>
		<BR/><BR/><BR/>
		<DIV class='center'>
			<DIV>
				<TABLE id="filesTbl" runat="server" class="datatable center"></TABLE>
			</DIV>
		</DIV>
	</DIV> <!-- End: content -->

<!--#include file="closer.inc"-->

</DIV> <!-- End: container -->
</FORM>
</BODY>
</HTML>