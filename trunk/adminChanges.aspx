<%@Page Inherits="CIS.conspectisLibrary" src="conspectisLibrary.cs" Language="C#" debug="true" %>
<%@Import Namespace="System.Collections"%>
<%@Import Namespace="System.Data"%>
<%@Import Namespace="System.IO"%>
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
	lockout(); Page.Header.Title=shortSysName+": Manage Change Log";
	systemStatus(0); // Check to see if admin has put system is in offline mode.

//START Check if user is logged in by checking existence of cookie.
	loggedin.InnerHtml=loggedIn();
	adminMenu.InnerHtml=isAdmin();

	string sqlDialect=System.Configuration.ConfigurationManager.AppSettings["db_type"].ToString().ToUpper();
	
	string sql="", defaultDc="", sqlTablePrefix="";
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
	DateTime dateStamp = DateTime.Now;
	string v_username, source="";
	bool sqlSuccess=true;
	HtmlTableRow tr;
	HtmlTableCell td;
	bool fill;

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
	titleSpan.InnerHtml="<SPAN class='heading1'>Change Log</SPAN>";

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

		DirectoryInfo di = new DirectoryInfo(Server.MapPath("log_archive/"));
		FileInfo[] files = di.GetFiles("*.xml");
		foreach (FileInfo file in files)
		{
			logfileList.Items.Add(new ListItem(file.Name));
		}
		logfileList.Items.Insert(0, new ListItem("Choose...",""));

		dat=sortDS(readChangeLog(shortSysName),"TimeGenerated DESC, Index","DESC");
		if (!emptyDataset(dat))
		{
			try
			{
				source=dat.Tables[0].Rows[0]["Source"].ToString();
			}
			catch (System.Exception ex)
			{
			}
			fill=false;
			tr = new HtmlTableRow();    //Output <TR>
				tr.Attributes.Add("class","blackheading");
				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("colspan","4");
					td.InnerHtml = "Current Transaction Log for "+source;
				tr.Cells.Add(td);         //Output </TD>
			logTbl.Rows.Add(tr);           //Output </TR>
			tr = new HtmlTableRow();    //Output <TR>
				tr.Attributes.Add("class","tableheading");
				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("style","width:6%;");
					td.InnerHtml = "ID#";
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("style","width:10%;");
					td.InnerHtml = "Date / Time";
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("style","width:12%;");
					td.InnerHtml = "Source";
				tr.Cells.Add(td);         //Output </TD>
				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("style","width:60%;");
					td.InnerHtml = "Use Case";
				tr.Cells.Add(td);         //Output </TD>
			logTbl.Rows.Add(tr);           //Output </TR>
			foreach (DataTable dtt in dat.Tables)
			{
				foreach (DataRow drr in dtt.Rows)
				{
					tr = new HtmlTableRow();    //Output <TR>
					if (fill) tr.Attributes.Add("class","altrow");
						td = new HtmlTableCell(); //Output <TD>
							td.Attributes.Add("class","change");
							td.InnerHtml = drr["Index"].ToString();
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
							td.Attributes.Add("class","change");
							td.InnerHtml = drr["TimeGenerated"].ToString();
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
							td.Attributes.Add("class","change");
							td.InnerHtml = drr["Source"].ToString();
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
							if (drr["Message"].ToString().Length>125)
							{
								td.InnerHtml = "<P class='changeLink' onclick=\"window.open('eventDetail.aspx?index="+drr["Index"].ToString()+"','eventDetailWin','width=800,height=400,menubar=no,status=yes,scrollbars=yes')\">"+drr["Message"].ToString().Substring(0,122)+"...</P>";
							}
							else
							{
								td.InnerHtml = "<P class='changeLink' onclick=\"window.open('eventDetail.aspx?index="+drr["Index"].ToString()+"','eventDetailWin','width=800,height=400,menubar=no,status=yes,scrollbars=yes')\">"+drr["Message"].ToString()+"</P>";
							}
						tr.Cells.Add(td);         //Output </TD>
					logTbl.Rows.Add(tr);           //Output </TR>
					fill=!fill;
				}
			} 
		}
	}


	if (IsPostBack)
	{
		if (logfileList.Value!="" && logfileList!=null)
		{
		    string myXMLfile = Server.MapPath("log_archive/"+logfileList.Value);
			DataSet ds = new DataSet();
    //		Create new FileStream with which to read the schema.
		    System.IO.FileStream fsReadXml = new System.IO.FileStream(myXMLfile, System.IO.FileMode.Open);
		    try
			{
				ds.ReadXml(fsReadXml);
			}
			catch (Exception ex)
		    {
		    }
			finally
			{
				fsReadXml.Close();
		    }
			dat=sortDS(ds,"TimeGenerated DESC, Index","DESC");
			if (!emptyDataset(dat))
			{
				try
				{
					source=dat.Tables[0].Rows[0]["Source"].ToString();
				}
				catch (System.Exception ex)
				{
				}
				fill=false;
				tr = new HtmlTableRow();    //Output <TR>
					tr.Attributes.Add("class","blackheading");
					td = new HtmlTableCell(); //Output <TD>
						td.Attributes.Add("colspan","4");
						td.InnerHtml = "Archive Transaction Log: "+logfileList.Value;
					tr.Cells.Add(td);         //Output </TD>
				logTbl.Rows.Add(tr);           //Output </TR>
				tr = new HtmlTableRow();    //Output <TR>
					tr.Attributes.Add("class","tableheading");
					td = new HtmlTableCell(); //Output <TD>
						td.Attributes.Add("style","width:6%;");
						td.InnerHtml = "ID#";
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						td.Attributes.Add("style","width:10%;");
						td.InnerHtml = "Date / Time";
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						td.Attributes.Add("style","width:12%;");
						td.InnerHtml = "Source";
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						td.Attributes.Add("style","width:60%;");
						td.InnerHtml = "Use Case";
					tr.Cells.Add(td);         //Output </TD>
				logTbl.Rows.Add(tr);           //Output </TR>
				foreach (DataTable dtt in dat.Tables)
				{
					foreach (DataRow drr in dtt.Rows)
					{
						tr = new HtmlTableRow();    //Output <TR>
						if (fill) tr.Attributes.Add("class","altrow");
							td = new HtmlTableCell(); //Output <TD>
								td.Attributes.Add("class","change");
								td.InnerHtml = drr["Index"].ToString();
							tr.Cells.Add(td);         //Output </TD>
							td = new HtmlTableCell(); //Output <TD>
								td.Attributes.Add("class","change");
								td.InnerHtml = drr["TimeGenerated"].ToString();
							tr.Cells.Add(td);         //Output </TD>
							td = new HtmlTableCell(); //Output <TD>
								td.Attributes.Add("class","change");
								td.InnerHtml = drr["Source"].ToString();
							tr.Cells.Add(td);         //Output </TD>
							td = new HtmlTableCell(); //Output <TD>
								if (drr["Message"].ToString().Length>125)
								{
									td.InnerHtml = "<P class='changeLink' onclick=\"window.open('eventDetail.aspx?index="+drr["Index"].ToString()+"','eventDetailWin','width=80,height=400,menubar=no,status=yes,scrollbars=yes')\">"+drr["Message"].ToString().Substring(0,122)+"...</P>";
								}
								else
								{
									td.InnerHtml = "<P class='changeLink' onclick=\"window.open('eventDetail.aspx?index="+drr["Index"].ToString()+"','eventDetailWin','width=800,height=400,menubar=no,status=yes,scrollbars=yes')\">"+drr["Message"].ToString()+"</P>";
								}
							tr.Cells.Add(td);         //Output </TD>
						logTbl.Rows.Add(tr);           //Output </TR>
						fill=!fill;
					}
				} 
			}
		}
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
		<SPAN id="titleSpan" runat="server"/>
		<DIV class="center">
			<DIV id="errmsg" class="errorLine" runat="server"/>
			<DIV id="status" class="statusLine" runat="server"/><BR/>
		</DIV>
		<TABLE class='datatable center'>
			<TR>
				<TD class='center'>
					<TABLE>
						<TR>
							<TD style='color: #ffffff; background-color:#336633; font-weight:bold; text-align:center'>Archived Logfiles</TD>
						</TR>
						<TR>
							<TD>
								<SELECT id='logfileList' runat='server' />
							</TD>
						</TR>
					</TABLE>
					<INPUT type='submit' value='Open' runat='server'/>
				</TD>
			</TR>
		</TABLE>
		<SPAN class='heading2'></SPAN>
		<BR/><BR/><BR/>
		<DIV class='center'>
			<TABLE id='logTbl' style='padding:0px; width:80%;' runat='server' class='datatable center' />
		</DIV>
	</DIV> <!-- End: content -->
<!--#include file="closer.inc"-->
</DIV> <!-- End: container -->
</FORM>
</BODY>
</HTML>
