<%@Page Inherits="CIS.conspectisLibrary" src="conspectisLibrary.cs" Language="C#" debug="true" %>
<%@Import Namespace="System.Data"%>
<%@Import Namespace="System"%>

<!DOCTYPE html>
<!-- HTML5 Status: VALID 1-30-13 CK -->
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
//	lockout(); 
	Page.Header.Title=shortSysName+": Offline";
//	systemStatus(); // Check to see if admin has put system is in offline mode.

//START Check if user is logged in by checking existence of cookie.
//	loggedin.InnerHtml=loggedIn();
//	adminMenu.InnerHtml=isAdmin();

	string curStat="";
	string sql="", defaultDc="", sqlTablePrefix="";
	DataSet dat=new DataSet();
	string v_userclass="", v_userrole="", v_username="";
	DateTime dateStamp = DateTime.Now;

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

	if (v_userclass=="3" || v_userclass=="99")
	{
		sysConLink.InnerHtml="<A class='black' href='systemConsole.aspx'>Go to System Console</A>";
	}

	sql="SELECT * FROM datacenters ORDER BY dcDesc ASC";
	dat=readDb(sql);
	string optionDesc="", optionVal="", contentStr="";
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

	sql="SELECT * FROM sysStat";
	dat=readDb(sql);
	if (dat!=null)
	{
		curStat = dat.Tables[0].Rows[0]["code"].ToString();
		if (curStat=="0") // 0 is Down, 1 is Up
		{
			statLine.InnerHtml = "<BR/><IMG src='./img/statusDown.png' alt='Down'><BR/><SPAN style='font-size:130%; color:#000000;'>The "+shortSysName+" System <BR/>Is Currently </SPAN><BR/><SPAN style='font-size:200%; color:#fc0b0a; font-weight:bold;'>Offline</SPAN><BR/><BR/><BR/>";
			dateLine.InnerHtml=dat.Tables[0].Rows[0]["dateStamp"].ToString();
			msgLine.InnerHtml=dat.Tables[0].Rows[0]["comment"].ToString();
			adminLine.InnerHtml="-- "+Decrypt(dat.Tables[0].Rows[0]["userid"].ToString());
		}
		else
		{
			statLine.InnerHtml = "<BR/><IMG src='./img/statusUp.png' alt='Up'><BR/><SPAN style='font-size:130%; color:#000000;'>The "+shortSysName+" System <BR/>Is Currently </SPAN><BR/><SPAN style='font-size:200%; color:#fc0b0a; font-weight:bold;'>Online</SPAN><BR/><BR/><BR/>";
			dateLine.InnerHtml=dat.Tables[0].Rows[0]["dateStamp"].ToString();
			msgLine.InnerHtml=dat.Tables[0].Rows[0]["comment"].ToString();
			adminLine.InnerHtml="-- "+Decrypt(dat.Tables[0].Rows[0]["userid"].ToString());
		}
	}
	else
	{
			statLine.InnerHtml = "<BR/><IMG src='./img/statusDown.png' alt='Down'><BR/><SPAN style='font-size:130%; color:#000000;'>The "+shortSysName+" System <BR/>Is Currently </SPAN><BR/><SPAN style='font-size:200%; color:#fc0b0a; font-weight:bold;'>Offline</SPAN><BR/><BR/><BR/>";
			dateLine.InnerHtml=dateStamp.ToString();
			msgLine.InnerHtml="The system is offline and the database is inaccessible.";
			adminLine.InnerHtml="-- The "+shortSysName+" Admin Team";
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

	if (IsPostBack)
	{

	}
}
</SCRIPT>
</HEAD>

<!--#include file="body.inc" -->
<FORM id="form1" runat="server">
<DIV id="container">
<!--#include file="banner.inc" -->
<!--#include file="menu.inc" -->

	<DIV id="content">
		<DIV class='txtAlignMiddleCenter imgAlignMiddleCenter'>
			<DIV id="statLine" runat="server"/>
			<BR/><BR/><BR/>
			<DIV style='width:200px;'>
				<SPAN id="dateLine" class="bold" runat="server"/><BR/>
				&#xa0;<BR/>
				<SPAN id="msgLine" runat="server"/><BR/>
				<SPAN id="adminLine" class="italic" runat="server"/><BR/>
			</DIV>
			<DIV id="sysConLink" runat="server"/>
		</DIV>
	</DIV> <!-- End: content -->

<!--#include file="closer.inc"-->

</DIV> <!-- End: container -->
</FORM>
</BODY>
</HTML>