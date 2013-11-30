<%@Page Inherits="CIS.conspectisLibrary" src="conspectisLibrary.cs" Language="C#" debug="true" %>
<%@Import Namespace="System.Data"%>
<%@Import Namespace="System.Drawing"%>
<%@Import Namespace="System"%>
<%@Import Namespace="System.IO"%>
<%@Import Namespace="iTextSharp.text.pdf"%> 

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
	lockout(); Page.Header.Title=shortSysName+": Migrate ESMS Single Instance Data";
	systemStatus(0); // Check to see if admin has put system is in offline mode.

//START Check if user is logged in by checking existence of cookie.
	loggedin.InnerHtml=loggedIn();
	adminMenu.InnerHtml=isAdmin();

	string sqlDialect=System.Configuration.ConfigurationManager.AppSettings["db_type"].ToString().ToUpper();

	string sql, v_username, sqlErr="";
	DataSet dat = new DataSet();

	sql="SELECT * FROM datacenters ORDER BY dcDesc ASC";
	dat=readDb(sql);

	string optionDesc="", optionVal="";
	if (!emptyDataset(dat))
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

	bool sqlSuccess=false;
	DateTime dateStamp = DateTime.Now;
	ColorConverter colConvert = new ColorConverter();

	try
	{
		v_username=Request.Cookies["username"].Value;
	}
	catch (System.Exception ex)
	{
		v_username="";
	}

	sqlResult.DataSource=null;
	sqlResult.DataBind();

	titleSpan.InnerHtml="<SPAN class='heading1'>Import Single-Instance (v2.0) Data</SPAN>";

	if (IsPostBack)
	{
		string url=formInstURL.Value; // http://sxpheiis003.phe.fs.fed.us/esms-abqdc/
		DataSet apiDat = new DataSet();
		apiDat.ReadXml(url+"xmlApi.aspx?mode=DUMP&fetch=servers");

		sqlResult.DataSource=apiDat;
		sqlResult.DataBind();
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
			<DIV id="errmsg" class="errorLine" runat="server"/>
			<DIV id="status" class="statusLine" runat="server"/>
		</DIV>
		<SPAN class='heading2'></SPAN>

		Enter the FULL URL to the single-instance to migrate:<BR/>
		<INPUT type="text" id="formInstURL" size="45" runat="server">xmlApi.aspx<BR/><BR/>
		Enter a short name for this Instance (Datacenter):<BR/>
		<INPUT type="text" id="formInstName" size="45" runat="server"><SPAN class='italic'>ex: ABQDC / KCDC</SPAN><BR/><BR/>
		Enter a description for this Instance (Datacenter):<BR/>
		<INPUT type="text" id="formInstDesc" size="45" runat="server"><SPAN class='italic'>ex: Albuquerque Data Center</SPAN><BR/>
		<INPUT type="submit" value="Execute" runat="server"/><BR/>
		<BR/>
		<asp:Panel id="Panel1" runat="server" Height="25px" HorizontalAlign="right" BackColor="#ffffff" />
		<BR/><BR/>
		<asp:datagrid id="sqlResult" runat="server" BackColor="White" HorizontalAlign="Center" Font-Size="8pt" CellPadding="2" BorderColor="#336633" BorderStyle="Solid" BorderWidth="2px">
			<HeaderStyle BackColor="#336633" ForeColor="White" Font-Bold="True" HorizontalAlign="Center" />
			<AlternatingItemStyle BackColor="#edf0f3" />
		</asp:datagrid>
	</DIV> <!-- End: content -->
<!--#include file="closer.inc"-->
</DIV> <!-- End: container -->
</FORM>
</BODY>
</HTML>