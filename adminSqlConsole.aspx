<%@Page Inherits="CIS.conspectisLibrary" src="conspectisLibrary.cs" Language="C#" debug="true" %>
<%@Import Namespace="System.Data"%>
<%@Import Namespace="System.Drawing"%>
<%@Import Namespace="System"%>
<%@Import Namespace="System.IO"%>
<%@Import Namespace="iTextSharp.text.pdf"%> 

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
}

public void Page_Load(Object o, EventArgs e)
{
//UNCOMMENT this line to force login to access this page.
	lockout(); Page.Header.Title=shortSysName+": SQL Console";
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

	titleSpan.InnerHtml="<SPAN class='heading1'>SQL Console</SPAN>";

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
		HttpCookie cookie;
		errmsg.InnerHtml = null;
		sql = sqlCommand.Value;
		string sqlAction = sql.Substring(0,3);
		sqlAction.ToUpper();

		switch (sqlAction)
		{
			case "UPD": 
			case "INS":
			case "DEL":
			case "ALT":
			case "CRE":
				sqlErr=writeDb(sql);
				if (sqlErr==null || sqlErr=="")
				{
					status.InnerHtml="Command Completed, Database Changed.<BR/><SPAN class='italic'>"+sql+"</SPAN>";
					sqlErr=writeChangeLog(dateStamp.ToString(), Decrypt(v_username.ToString()), "SQL Console: "+sql2txt(sql).ToString());
					if (sqlErr==null || sqlErr=="")
					{
//						Response.Write("<script>refreshParent("+");<"+"/script>");
					}
					else
					{
						errmsg.InnerHtml = "WARNING: "+sqlErr;
					}
				}
				else
				{
					errmsg.InnerHtml = sqlErr;
				}
				break;
			case "SEL":
				if (sql!="")
				{
					ViewState["exportStr"] = "srch";
					ViewState["searchArg"] = sql;

					cookie=new HttpCookie("srchSql",sql);
					cookie.Expires=DateTime.Now.AddSeconds(45);
					Response.Cookies.Add(cookie);
					cookie=new HttpCookie("goSrch","srch");
					cookie.Expires=DateTime.Now.AddSeconds(45);
					Response.Cookies.Add(cookie);
//					Response.Write((string)ViewState["exportStr"]);
//					Response.Write((string)ViewState["searchArg"]);
//					Response.Write((string)ViewState["searchArg1"]);

					//Place Export Button in Panel on Web Page
					ImageButton ib = new ImageButton();
					ib.ID = "exportButton";
					ib.ImageUrl = "./img/export.png";
					ib.Width = 110;
					ib.Height= 25;
					ib.AlternateText="Export to CSV";
					ib.BackColor=(System.Drawing.Color)colConvert.ConvertFromString("#FFFFFF");
//					ib.OnClick="Export_Click";
					ib.Click += new ImageClickEventHandler(Export_Click);
					Panel1.Controls.Add(ib); 

					//Place Printable View Button in Panel on Web Page
					ImageButton pb = new ImageButton();
					pb.ID = "printableButton";
					pb.ImageUrl = "./img/print.png";
					pb.Width = 125;
					pb.Height= 25;
					pb.AlternateText="Show Printable View";
					pb.BackColor=(System.Drawing.Color)colConvert.ConvertFromString("#FFFFFF");
					pb.Attributes.Add("language", "javascript");
					pb.Attributes.Add("OnClick", "window.open('print.aspx?srch=go','printableWin','width=600,menubar=no,status=yes,scrollbars=yes')");
					Panel1.Controls.Add(pb); 
				}
				try
				{
					dat=readDb(sql);
					if (dat!=null)
					{
						sqlResult.DataSource=dat;
						sqlResult.DataBind();
					}
					else
					{
						errmsg.InnerHtml="No Matching Results Found.";
					}
					sqlSuccess=true;
				}
				catch (System.Exception ex)
				{
					errmsg.InnerHtml = ex.ToString()+"<BR/>"+sqlErr;

					sqlSuccess=false;
					sqlResult.DataSource=null;
					sqlResult.DataBind();
				}
				break;
		default :
			errmsg.InnerHtml="Syntax Error - check your command and try again.";
			sqlResult.DataSource=null;
			sqlResult.DataBind();
			break;
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
		<DIV class='center'>
			<DIV id="errmsg" class="errorLine" runat="server"/><BR/>
			<DIV id="status" class="statusLine" runat="server"/><BR/>
		</DIV>
		<DIV class='heading2'>SQL Command</DIV>
		<DIV class='center'>
			<TEXTAREA rows="8" cols="70" id="sqlCommand" style="background-color: #edf0f3" runat="server" />
			<BR/><BR/>
			<INPUT type="submit" value="Execute" runat="server"/>
		</DIV>
		<BR/>
		<BR/>
		<asp:Panel id="Panel1" runat="server" Height="25px" HorizontalAlign="right" BackColor="#ffffff"></asp:Panel>
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