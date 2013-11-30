<%@Page Inherits="CIS.conspectisLibrary" src="conspectisLibrary.cs" Language="C#" debug="true" %>
<%@Import Namespace="System"%>
<%@Import Namespace="System.Data"%>
<%@Import Namespace="System.Drawing"%>
<%@Import Namespace="System.IO"%>

<!DOCTYPE html>
<!-- HTML5 STatus:  -->
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
	lockout(); Page.Header.Title=shortSysName+": Show XML";
	systemStatus(0); // Check to see if admin has put system is in offline mode.

//START Check if user is logged in by checking existence of cookie.
	loggedin.InnerHtml=loggedIn();
	adminMenu.InnerHtml=isAdmin();

	string sql, v_username, sqlErr="", getFile="";
	DataSet dat=new DataSet();
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

	titleSpan.InnerHtml="<SPAN class='heading1'>XML File Operation</SPAN>";

	xmlResult.DataSource=null;
	xmlResult.DataBind();

	if (!IsPostBack)
	{
		DirectoryInfo di = new DirectoryInfo(Server.MapPath("xml_import/"));
		FileInfo[] rgFiles = di.GetFiles("*.xml");

		foreach(FileInfo fi in rgFiles)
		{
			ListItem li = new ListItem(fi.Name, fi.Name);
			pickFile.Items.Add(li);
		}
	}



	if (IsPostBack)
	{
		getFile = pickFile.Value;
		DataSet ds = new System.Data.DataSet();
		ds.ReadXml(Server.MapPath("xml_import/"+getFile).ToString());

//		this.dataGrid1.DataSource = ds;
//		this.dataGrid1.Expand(-1);
//		this.textBox1.DataBindings.Add("Text",ds.Tables[1],"username");

		xmlResult.DataSource=ds;
		xmlResult.DataBind();
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
			<DIV id='errmsg' class='errorLine' runat='server'/>
			<DIV id='status' class='statusLine' runat='server'/><BR/>
		</DIV>
		<SPAN class='heading2'>Show File:</SPAN>
		<SELECT id='pickFile' style='width: 200px' runat='server' />
		<BR/>
		<INPUT type='submit' value='Execute' runat='server'/>
		<BR/><BR/>
		<ASP:Panel id='Panel1' runat='server' Height='25px' HorizontalAlign='right' BackColor='#ffffff' />
		<BR/><BR/>
		<ASP:datagrid id='xmlResult' runat='server' BackColor='White' HorizontalAlign='Center' Font-Size='8pt' CellPadding='2' BorderColor='#336633' BorderStyle='Solid' BorderWidth='2px'>
			<HeaderStyle BackColor='#336633' ForeColor='White' Font-Bold='True' HorizontalAlign='Center' />
			<AlternatingItemStyle BackColor='#edf0f3' />
		</ASP:datagrid>
	</DIV> <!-- End: content -->
<!--#include file='closer.inc'-->
</DIV> <!-- End: container -->
</FORM>
</BODY>
</HTML>