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
//	lockout(); 
	Page.Header.Title=shortSysName+": System Console";

//START Check if user is logged in by checking existence of cookie.
	loggedin.InnerHtml=loggedIn();
	adminMenu.InnerHtml=isAdmin();

	string sqlDialect=System.Configuration.ConfigurationManager.AppSettings["db_type"].ToString().ToUpper();

	DateTime dateStamp = DateTime.Now;
	string v_username, curStat="";
	string sql="", defaultDc="", sqlTablePrefix="", status="";
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
	titleSpan.InnerHtml="<SPAN class='heading1'>System Console</SPAN>";


//	if (!IsPostBack)
//	{

		sql="SELECT * FROM sysStat";
		dat=readDb(sql);
		if (!emptyDataset(dat))
		{
			curStat = dat.Tables[0].Rows[0]["code"].ToString();
			if (curStat=="0") // 0 is Down, 1 is Up
			{
				status.InnerHtml = "<BR/><IMG src='./img/statusDown.png' alt='Down'><BR/><SPAN style='font-size:130%; color:#000000;'>The "+shortSysName+" System <BR/>Is Currently </SPAN><BR/><SPAN style='font-size:200%; color:#fc0b0a; font-weight:bold;'>Offline</SPAN><BR/><BR/><BR/>";
//				formComment.Value=dat.Tables[0].Rows[0]["comment"].ToString();
			}
			else
			{
				status.InnerHtml = "<BR/><IMG src='./img/statusUp.png' alt='Up'><BR/><SPAN style='font-size:130%; color:#000000;'>The "+shortSysName+" System <BR/>Is Currently </SPAN><BR/><SPAN style='font-size:200%; color:#fc0b0a; font-weight:bold;'>Online</SPAN><BR/><BR/><BR/>";
//				formComment.Value="";
			}
//			formStatus.Value=curStat;
		}
//		Response.Write("test");
//	}

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
		string state="", traceSql="";
		switch (formStatus.SelectedIndex)
		{
		case 0:
			status="1";
			state="Online";
			break;
		case 1:
			status="0";
			state="Offline";
			break;
		}

		string comment=formComment.Value;
		string sqlErr="";
		sql = "UPDATE sysStat SET code='"+status+"', userid='"+v_username+"', dateStamp='"+dateStamp+"', comment='"+comment+"' WHERE id=1";
		sqlErr=writeDb(sql);
//		Response.Write(sql);
		if (sqlErr!="" || sqlErr!=null)
		{
			errmsg.InnerHtml=sqlErr.ToString();
			sqlErr="";
		}
		if (sqlErr=="" || sqlErr==null)
		{
			sqlErr=writeChangeLog(dateStamp.ToString(), Decrypt(v_username.ToString()), "System state changed to "+state+". "+comment);
			if (sqlErr!="" || sqlErr!=null)
			{
				errmsg.InnerHtml=sqlErr.ToString();
				sqlErr="";
			}
		}

		if (sqlErr=="")
		{
			Response.Redirect("systemConsole.aspx");
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
		<DIV class="center">
			<DIV id="errmsg" class="errorLine" runat="server"/>
			<DIV id="status" class="statusLine" runat="server"/><BR/>
		</DIV>
		
		<TABLE class='center thinBorder' style='width:40%;'>
			<TR style='color: #ffffff; font-size:10pt; font-weight:bold; text-align:center; background-color:#669966'>
				<TD colspan='2' class='center'>Toggle Online/ Offline<BR/>&#xa0;
				</TD>
			</TR>
			<TR>
				<TD colspan='2'>&#xa0;</TD>
			</TR>
			<TR>
				<TD>&#xa0; Status:</TD>
				<TD class='txtAlignMiddleLeft'>
					<SELECT id='formStatus' style='width:145px;' runat='server'>
						<OPTION value='1'>Online</OPTION>
						<OPTION value='0'>Offline</OPTION>
					</SELECT>
				</TD>
			</TR>
			<TR>
				<TD>&#xa0; Comment:&#xa0;</TD>
				<TD class='txtAlignMiddleLeft'>
					<TEXTAREA rows='4' cols='25' id='formComment' runat='server' />
				</TD>
			</TR>
			<TR>
				<TD colspan='2' class='center'>
					<INPUT type="submit" value="Toggle" runat="server"/>
				</TD>
			</TR>
		</TABLE>

	</DIV> <!-- End: content -->

<!--#include file="closer.inc"-->

</DIV> <!-- End: container -->
</FORM>
</BODY>
</HTML>