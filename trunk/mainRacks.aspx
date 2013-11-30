<%@Page Inherits="CIS.conspectisLibrary" src="conspectisLibrary.cs" Language="C#" debug="true" %>
<%@Import Namespace="System.Data"%>
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
	lockout(); Page.Header.Title=shortSysName+": Manage Racks";
	systemStatus(0); // Check to see if admin has put system is in offline mode.

//START Check if user is logged in by checking existence of cookie.
	loggedin.InnerHtml=loggedIn();
	adminMenu.InnerHtml=isAdmin();

	string sqlDialect=System.Configuration.ConfigurationManager.AppSettings["db_type"].ToString().ToUpper();

	DateTime dateStamp = DateTime.Now;
	string v_username, curStat="";
	string sql="", defaultDc="", sqlTablePrefix="", status="";
	DataSet dat = new DataSet();

/*--- MODIFY THE RACKS TABLES
	ALTER TABLE kcdc_racks ADD dcPrefix NVARCHAR(10) DEFAULT 'kcdc_'
	UPDATE kcdc_racks SET dcPrefix='kcdc_'   
	ALTER TABLE abqdc_racks ADD dcPrefix NVARCHAR(10) DEFAULT 'abqdc_'
	UPDATE abqdc_racks SET dcPrefix='abqdc_'   
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

	titleSpan.InnerHtml="<SPAN class='heading1'>Manage Cabinets & Racks</SPAN>";

	HtmlTableRow tr;
	HtmlTableCell td;
	bool fill;

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
						newSql=newSql+" UNION ";
					}
					newSql=newSql+"SELECT rackId, location, dcPrefix FROM "+dr["dcPrefix"].ToString()+"racks";
				}
			}
//			Response.Write(newSql+"<BR/>");
			sql=newSql+" ORDER BY location ASC, rackId ASC";
		}
	}
	else
	{
		sql="SELECT rackId, location, dcPrefix FROM "+sqlTablePrefix.ToString()+"racks ORDER BY rackId ASC";
	}
//	Response.Write(sql+"<BR/>");
	dat=readDb(sql);
        if (dat != null)
        {
		fill = false;
		int i=0;
		tr = new HtmlTableRow();    //Output <TR>
			tr.Attributes.Add("class","blackheading");
			td = new HtmlTableCell(); //Output <TD>
//				td.Attributes.Add("colspan","8");
				td.InnerHtml = "Cabinets & Racks";
			tr.Cells.Add(td);         //Output </TD>
		racksTbl.Rows.Add(tr);           //Output </TR>
		tr = new HtmlTableRow();    //Output <TR>
			tr.Attributes.Add("class","tableheading");
				td = new HtmlTableCell(); //Output <TD>
				td.InnerHtml = "Cabinet";
			tr.Cells.Add(td);         //Output </TD>

		racksTbl.Rows.Add(tr);           //Output </TR>
		foreach (DataTable dt in dat.Tables)
        {
			foreach (DataRow dr in dt.Rows)
			{
				tr = new HtmlTableRow();    //Output <TR>
				if (fill) tr.Attributes.Add("class","altrow");
				   td = new HtmlTableCell(); //Output <TD>
						td.Attributes.Add("class","data center");
						td.InnerHtml = "<P class='link' onclick=\"window.open('editRack.aspx?rackId="+dr["rackId"].ToString()+"&amp;dc="+dr["dcPrefix"].ToString()+"','editRackWin','width=315,height=350,menubar=no,status=yes,scrollbars=yes')\" title='Edit Rack #"+dr["rackId"].ToString()+"'>"+dr["location"].ToString()+"-R"+dr["rackId"].ToString().Substring(0,2)+"-C"+dr["rackId"].ToString().Substring(2,2)+"</P>";
				   tr.Cells.Add(td);         //Output </TD>
				racksTbl.Rows.Add(tr);           //Output </TR>
				fill = !fill;
				i++;
			}
		}
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
			<INPUT TYPE='button' VALUE='New Rack' ID='newRackButt' ONCLICK="window.open('newRack.aspx','newRackWin','width=315,height=450,menubar=no,status=yes')" />
			<BR/><BR/><BR/>
		</DIV>
		<TABLE id='racksTbl' runat='server' class='datatable center' />
		<BR/><BR/>
	</DIV> <!-- End: content -->

<!--#include file="closer.inc"-->

</DIV> <!-- End: container -->
</FORM>
</BODY>
</HTML>