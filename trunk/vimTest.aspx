<%@Page Inherits="ESMS.wodLibrary" src="esmsLibrary.cs" Language="C#" debug="true" %>
<%@Import Namespace="System.Reflection"%>
<%@Import Namespace="System.Reflection.Emit"%>
<%@Import Namespace="System.Data"%>
<%@Import Namespace="System"%>
<%@Import Namespace="VMware.Vim"%>

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
private DataTable ConvertToDataTable(Object[] array)
{
PropertyInfo[] properties = array.GetType().GetElementType().GetProperties();
DataTable dt = CreateDataTable(properties);
if (array.Length != 0)
{
foreach(object o in array)
FillData(properties, dt, o);
}
return dt;
}

private DataTable CreateDataTable(PropertyInfo[] properties)

{
DataTable dt = new DataTable();
DataColumn dc = null;
foreach(PropertyInfo pi in properties)
{
dc = new DataColumn();
dc.ColumnName = pi.Name;
dc.DataType = pi.PropertyType;
dt.Columns.Add(dc);
}
return dt;
}

private void FillData(PropertyInfo[] properties, DataTable dt, Object o)
{
DataRow dr = dt.NewRow();
foreach(PropertyInfo pi in properties)
{
dr[pi.Name] = pi.GetValue(o, null);
}
dt.Rows.Add(dr);
}

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
	lockout(); Page.Header.Title=shortSysName+": VIM API Test";
	systemStatus(0); // Check to see if admin has put system is in offline mode.

//START Check if user is logged in by checking existence of cookie.
//	loggedin.InnerHtml=loggedIn();
	adminMenu.InnerHtml=isAdmin();

	DateTime dateStamp = DateTime.Now;
	string v_username, curStat="";
	string sql="", status="";
	DataSet dat=new DataSet();
	string vimUrl="https://clphevcs001.dsphe.fs.fed.us/sdk";
	string vimUser="DSPHE\\svc.on_demand";
	string vimPass="M-kcn,^Vdtq5";

	vimResult.DataSource=null;
	vimResult.DataBind();

	try
	{
		v_username=Request.Cookies["username"].Value;
	}
	catch (System.Exception ex)
	{
		v_username="";
	}

	titleSpan.InnerHtml="VimTest";

	VimClient client = new VimClient();
	try
	{
		client = wodConnect(vimUrl,vimUser,vimPass);
	}
	catch (System.Exception ex)
	{
		Response.Write(ex.ToString());
	}  
	
//	client.Connect(vimUrl);  // connect to vSphere web service
//	client.Login(vimUser, vimPass);  // Login using username/password credentials
	DiagnosticManager diagMgr = (DiagnosticManager) client.GetView(client.ServiceContent.DiagnosticManager, null);  // Get DiagnosticManager
	DiagnosticManagerLogDescriptor[] desc = diagMgr.QueryDescriptions(null);
	DataTable dtt=ConvertToDataTable(desc);
	if (dtt!=null)
	{
		vimResult.DataSource=dtt;
		vimResult.DataBind();
	}
//	for (int i=0; i<desc.Length; i++)
//	{
//	}
	if (desc!=null)
	{
		Hashtable ht = new Hashtable();
		Type t = desc[0].GetType();
		PropertyInfo[] info = t.GetProperties();
		for (int i=0; i<info.Length; i++ )
		{
			PropertyInfo blob = (PropertyInfo)info.GetValue(i);
			ht.Add(blob.Name,blob.GetValue(desc[0], new object[] {}));
		}
		foreach(string key in ht.Keys)
		{
			Response.Write(String.Format("{0}: {1}", key, ht[key])+"<BR/>");
		}
	}



//	DiagnosticManagerLogHeader log = diagMgr.BrowseDiagnosticLog(null, "vpxd:vpxd-0.log", 9999999, null);  // Obtain the last line of the logfile by setting an arbitrarily large line number as the starting point

//	int lineEnd = log.LineEnd;  // Get the last 5 lines of the log first
//	int start = lineEnd - 5;
//	log = diagMgr.BrowseDiagnosticLog(null, "vpxd:vpxd-0.log", start, null);
//	foreach (string line in log.LineText) {
//		Response.Write(line);
//		Response.Write("<BR/><BR/>");   }
	client.Disconnect();  // Logout from the vSphere server


	sql= "";
//	dat=readDb(sql);

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
		<SPAN id='wodStatus' runat='server'/>
		<BR/><BR/>
		<ASP:datagrid id='wodDatResult' runat='server' BackColor='White' HorizontalAlign='Center' Font-Size='8pt' CellPadding='2' BorderColor='#336633' BorderStyle='Solid' BorderWidth='2px'>
			<HeaderStyle BackColor='#336633' ForeColor='White' Font-Bold='True' HorizontalAlign='Center' />
			<AlternatingItemStyle BackColor='#edf0f3' />
		</ASP:datagrid>
	</DIV> <!-- End: content -->
<!--#include file='closer.inc'-->
</DIV> <!-- End: container -->
</FORM>
</BODY>
</HTML>