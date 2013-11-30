<%@Page Inherits="CIS.conspectisLibrary" src="conspectisLibrary.cs" Language="C#" debug="true" %>
<%@Import Namespace="System.Data.OleDb"%>
<%@Import Namespace="System.Data"%>
<%@Import Namespace="System.Drawing"%>
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
	lockout(); Page.Header.Title=shortSysName+": Manage Users, Groups & Roles";
	systemStatus(0); // Check to see if admin has put system is in offline mode.

	//START Check if user is logged in by checking existence of cookie.
	loggedin.InnerHtml = loggedIn();
	adminMenu.InnerHtml = isAdmin();

	string sqlDialect=System.Configuration.ConfigurationManager.AppSettings["db_type"].ToString().ToUpper();

	string sql="", defaultDc="", sqlTablePrefix="";
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

	string v_userclass;
	string v_passResetFlag;
	string v_username;
	DateTime dateStamp = DateTime.Now;

	try
	{
		v_username = Request.Cookies["username"].Value;
	}
	catch (System.Exception ex)
	{
		v_username = "";
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

	titleSpan.InnerHtml="<SPAN class='heading1'>Manage Users, Groups & Roles</SPAN>";


	HtmlTableRow tr;
	HtmlTableCell td;
	bool fill;

	DataSet datUsers = new DataSet();
	DataSet datAdmins = new DataSet();
	DataSet datSuper = new DataSet();
	DataSet datWoDUsers = new DataSet();
	DataSet datWoDAdmins = new DataSet();

	if (v_userclass=="3" || v_userclass=="99")
	{
		manageRoles.InnerHtml = @"<BUTTON  onclick=""window.open('adminRoles.aspx','adminRolesWin','width=650,height=700,menubar=no,status=yes,scrollbars=yes')""><IMG src='./img/roles.png' alt=''/>&nbsp; Manage Roles &nbsp;</BUTTON>";
	}

	//Populate AD Group DataSets
	try
	{
		datUsers=getADUsersinGroup(ADUsersGroup);
	}
	catch (System.Exception ex)
	{			
		Response.Write("No AD search results found for '"+ADUsersGroup+"' group!<BR/>"+ex.ToString());
	}

	try
	{
		datAdmins=getADUsersinGroup(ADAdminsGroup);
	}
	catch (System.Exception ex)
	{			
		Response.Write("No AD search results found for '"+ADAdminsGroup+"' group!<BR/>"+ex.ToString());
	}

	try
	{
		datSuper=getADUsersinGroup(ADSuperGroup);	
	}
	catch (System.Exception ex)
	{			
		Response.Write("No AD search results found for '"+ADSuperGroup+"' group!<BR/>"+ex.ToString());
	}

	try
	{
		datWoDUsers=getADUsersinGroup(ADWoDUsersGroup);			
	}
	catch (System.Exception ex)
	{			
		Response.Write("No AD search results found for '"+ADWoDUsersGroup+"' group!<BR/>"+ex.ToString());
	}

	try
	{
		datWoDAdmins=getADUsersinGroup(ADWoDAdminsGroup);		
	}
	catch (System.Exception ex)
	{			
		Response.Write("No AD search results found for '"+ADWoDAdminsGroup+"' group!<BR/>"+ex.ToString());
	}

	//Populate Users tables with dataset content
	if (datUsers!=null)
	{
		fill=false;
		tr = new HtmlTableRow();    //Output <TR>
			tr.Attributes.Add("class","blackheading");
			td = new HtmlTableCell(); //Output <TD>
				td.Attributes.Add("colspan","6");
				td.InnerHtml = "Users ("+ADUsersGroup+")";
			tr.Cells.Add(td);         //Output </TD>
		usersTbl.Rows.Add(tr);           //Output </TR>
		tr = new HtmlTableRow();    //Output <TR>
			tr.Attributes.Add("class","tableheading");
			td = new HtmlTableCell(); //Output <TD>
				td.Attributes.Add("style","width:130px;");
				td.InnerHtml = "Username";
			tr.Cells.Add(td);         //Output </TD>
			td = new HtmlTableCell(); //Output <TD>
				td.Attributes.Add("style","width:75px;");
				td.InnerHtml = "First";
			tr.Cells.Add(td);         //Output </TD>
			td = new HtmlTableCell(); //Output <TD>
				td.Attributes.Add("style","width:75px;");
				td.InnerHtml = "Last";
			tr.Cells.Add(td);         //Output </TD>
			td = new HtmlTableCell(); //Output <TD>
				td.Attributes.Add("style","width:105px;");
				td.InnerHtml = "E-Mail";
			tr.Cells.Add(td);         //Output </TD>
			td = new HtmlTableCell(); //Output <TD>
				td.Attributes.Add("style","width:100px;");
				td.InnerHtml = "Phone";
			tr.Cells.Add(td);         //Output </TD>
			td = new HtmlTableCell(); //Output <TD>
				td.InnerHtml = "Actions";
			tr.Cells.Add(td);         //Output </TD>
		usersTbl.Rows.Add(tr);           //Output </TR>	
		foreach (DataTable dt in datUsers.Tables)
		{
			foreach (DataRow dr in dt.Rows)
			{
				tr = new HtmlTableRow();    //Output <TR>
				if (fill) tr.Attributes.Add("class","altrow");
					td = new HtmlTableCell(); //Output <TD>
						td.Attributes.Add("class","data");
						td.InnerHtml = dr["UserName"].ToString();
					tr.Cells.Add(td);         //Output </TD>
				sql="SELECT * FROM users WHERE userId='"+dr["UserName"].ToString()+"'";
				dat=readDb(sql);
				if (dat!=null)
				{
					td = new HtmlTableCell(); //Output <TD>
						td.Attributes.Add("class","data");
						td.InnerHtml = Decrypt(dat.Tables[0].Rows[0]["userFirstName"].ToString());
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						td.Attributes.Add("class","data");
						td.InnerHtml = Decrypt(dat.Tables[0].Rows[0]["userLastName"].ToString());
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						td.Attributes.Add("class","data");
						td.InnerHtml = Decrypt(dat.Tables[0].Rows[0]["email"].ToString());
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						td.Attributes.Add("class","data");
						td.InnerHtml = Decrypt(dat.Tables[0].Rows[0]["userOfficePhone"].ToString());
					tr.Cells.Add(td);         //Output </TD>
				}
				else
				{
					td = new HtmlTableCell(); //Output <TD>
						td.Attributes.Add("class","data");
						if (dr["First"].ToString()!="")
						{
							td.InnerHtml=dr["First"].ToString();
						}
						else
						{
							td.InnerHtml = "&#xa0;";
						}
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						td.Attributes.Add("class","data");
						if (dr["Last"].ToString()!="")
						{
							td.InnerHtml=dr["Last"].ToString();
						}
						else
						{
							td.InnerHtml = "&#xa0;";
						}
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						td.Attributes.Add("class","data");
						if (dr["EMailAddress"].ToString()!="")
						{
							td.InnerHtml=dr["EMailAddress"].ToString();
						}
						else
						{
							td.InnerHtml = "&#xa0;";
						}
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						td.Attributes.Add("class","data");
						if (dr["Phone"].ToString()!="")
						{
							td.InnerHtml=dr["Phone"].ToString();
						}
						else
						{
							td.InnerHtml = "&#xa0;";
						}
					tr.Cells.Add(td);         //Output </TD>
				}
  				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("class","data");
					if (v_userclass=="3" || v_userclass=="99")
					{
						td.InnerHtml = "<INPUT type='image' src='./img/roles.png' onclick=\"window.open('editRoles.aspx?uid="+dr["UserName"].ToString()+"','editRolesWin','width=350,height=600,menubar=no,status=yes')\" ALT='Edit Roles' />";
					}
					else
					{
						td.InnerHtml = "&#xa0;";
					}
				tr.Cells.Add(td);         //Output </TD>
				usersTbl.Rows.Add(tr);           //Output </TR>
				fill=!fill;
			}
		}
	}
	//END Populate User Table

	//Populate Admins table with dataset content
	if (datAdmins!=null)
	{
		fill=false;
		tr = new HtmlTableRow();    //Output <TR>
			tr.Attributes.Add("class","blackheading");
			td = new HtmlTableCell(); //Output <TD>
				td.Attributes.Add("colspan","6");
				td.InnerHtml = "Admins ("+ADAdminsGroup+")";
			tr.Cells.Add(td);         //Output </TD>
		adminsTbl.Rows.Add(tr);           //Output </TR>
		tr = new HtmlTableRow();    //Output <TR>
			tr.Attributes.Add("class","tableheading");
			td = new HtmlTableCell(); //Output <TD>
				td.Attributes.Add("style","width:130px;");
				td.InnerHtml = "Username";
			tr.Cells.Add(td);         //Output </TD>
			td = new HtmlTableCell(); //Output <TD>
				td.Attributes.Add("style","width:75px;");
				td.InnerHtml = "First";
			tr.Cells.Add(td);         //Output </TD>
			td = new HtmlTableCell(); //Output <TD>
				td.Attributes.Add("style","width:75px;");
				td.InnerHtml = "Last";
			tr.Cells.Add(td);         //Output </TD>
			td = new HtmlTableCell(); //Output <TD>
				td.Attributes.Add("style","width:105px;");
				td.InnerHtml = "E-Mail";
			tr.Cells.Add(td);         //Output </TD>
			td = new HtmlTableCell(); //Output <TD>
				td.Attributes.Add("style","width:100px;");
				td.InnerHtml = "Phone";
			tr.Cells.Add(td);         //Output </TD>
			td = new HtmlTableCell(); //Output <TD>
				td.InnerHtml = "Actions";
			tr.Cells.Add(td);         //Output </TD>
		adminsTbl.Rows.Add(tr);           //Output </TR>	
		foreach (DataTable dt in datAdmins.Tables)
		{
			foreach (DataRow dr in dt.Rows)
			{
				tr = new HtmlTableRow();    //Output <TR>
				if (fill) tr.Attributes.Add("class","altrow");
					td = new HtmlTableCell(); //Output <TD>
						td.Attributes.Add("class","data");
						td.InnerHtml = dr["UserName"].ToString();
					tr.Cells.Add(td);         //Output </TD>
				sql="SELECT * FROM users WHERE userId='"+dr["UserName"].ToString()+"'";
				dat=readDb(sql);
				if (dat!=null)
				{
					td = new HtmlTableCell(); //Output <TD>
						td.Attributes.Add("class","data");
						td.InnerHtml = Decrypt(dat.Tables[0].Rows[0]["userFirstName"].ToString());
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						td.Attributes.Add("class","data");
						td.InnerHtml = Decrypt(dat.Tables[0].Rows[0]["userLastName"].ToString());
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						td.Attributes.Add("class","data");
						td.InnerHtml = Decrypt(dat.Tables[0].Rows[0]["email"].ToString());
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						td.Attributes.Add("class","data");
						td.InnerHtml = Decrypt(dat.Tables[0].Rows[0]["userOfficePhone"].ToString());
					tr.Cells.Add(td);         //Output </TD>
				}
				else
				{
					td = new HtmlTableCell(); //Output <TD>
						td.Attributes.Add("class","data");
						if (dr["First"].ToString()!="")
						{
							td.InnerHtml=dr["First"].ToString();
						}
						else
						{
							td.InnerHtml = "&#xa0;";
						}
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						td.Attributes.Add("class","data");
						if (dr["Last"].ToString()!="")
						{
							td.InnerHtml=dr["Last"].ToString();
						}
						else
						{
							td.InnerHtml = "&#xa0;";
						}
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						td.Attributes.Add("class","data");
						if (dr["EMailAddress"].ToString()!="")
						{
							td.InnerHtml=dr["EMailAddress"].ToString();
						}
						else
						{
							td.InnerHtml = "&#xa0;";
						}
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						td.Attributes.Add("class","data");
						if (dr["Phone"].ToString()!="")
						{
							td.InnerHtml=dr["Phone"].ToString();
						}
						else
						{
							td.InnerHtml = "&#xa0;";
						}
					tr.Cells.Add(td);         //Output </TD>
				}
  				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("class","data");
					if (v_userclass=="3" || v_userclass=="99")
					{
						td.InnerHtml = "<INPUT type='image' src='./img/roles.png' onclick=\"window.open('editRoles.aspx?uid="+dr["UserName"].ToString()+"','editRolesWin','width=350,height=600,menubar=no,status=yes')\" ALT='Edit Roles' />";
					}
					else
					{
						td.InnerHtml = "&#xa0;";
					}
				tr.Cells.Add(td);         //Output </TD>
				adminsTbl.Rows.Add(tr);           //Output </TR>
				fill=!fill;
			}
		}
	}
	//END Populate Admins Table

	//Populate supers table with dataset content
	if (datSuper!=null)
	{
		fill=false;
		tr = new HtmlTableRow();    //Output <TR>
			tr.Attributes.Add("class","blackheading");
			td = new HtmlTableCell(); //Output <TD>
				td.Attributes.Add("colspan","6");
				td.InnerHtml = "Super / Dev ("+ADSuperGroup+")";
			tr.Cells.Add(td);         //Output </TD>
		superTbl.Rows.Add(tr);           //Output </TR>
		tr = new HtmlTableRow();    //Output <TR>
			tr.Attributes.Add("class","tableheading");
			td = new HtmlTableCell(); //Output <TD>
				td.Attributes.Add("style","width:130px;");
				td.InnerHtml = "Username";
			tr.Cells.Add(td);         //Output </TD>
			td = new HtmlTableCell(); //Output <TD>
				td.Attributes.Add("style","width:75px;");
				td.InnerHtml = "First";
			tr.Cells.Add(td);         //Output </TD>
			td = new HtmlTableCell(); //Output <TD>
				td.Attributes.Add("style","width:75px;");
				td.InnerHtml = "Last";
			tr.Cells.Add(td);         //Output </TD>
			td = new HtmlTableCell(); //Output <TD>
				td.Attributes.Add("style","width:105px;");
				td.InnerHtml = "E-Mail";
			tr.Cells.Add(td);         //Output </TD>
			td = new HtmlTableCell(); //Output <TD>
				td.Attributes.Add("style","width:100px;");
				td.InnerHtml = "Phone";
			tr.Cells.Add(td);         //Output </TD>
			td = new HtmlTableCell(); //Output <TD>
				td.InnerHtml = "Actions";
			tr.Cells.Add(td);         //Output </TD>
		superTbl.Rows.Add(tr);           //Output </TR>	
		foreach (DataTable dt in datSuper.Tables)
		{
			foreach (DataRow dr in dt.Rows)
			{
				tr = new HtmlTableRow();    //Output <TR>
				if (fill) tr.Attributes.Add("class","altrow");
					td = new HtmlTableCell(); //Output <TD>
						td.Attributes.Add("class","data");
						td.InnerHtml = dr["UserName"].ToString();
					tr.Cells.Add(td);         //Output </TD>
				sql="SELECT * FROM users WHERE userId='"+dr["UserName"].ToString()+"'";
				dat=readDb(sql);
				if (dat!=null)
				{
					td = new HtmlTableCell(); //Output <TD>
						td.Attributes.Add("class","data");
						td.InnerHtml = Decrypt(dat.Tables[0].Rows[0]["userFirstName"].ToString());
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						td.Attributes.Add("class","data");
						td.InnerHtml = Decrypt(dat.Tables[0].Rows[0]["userLastName"].ToString());
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						td.Attributes.Add("class","data");
						td.InnerHtml = Decrypt(dat.Tables[0].Rows[0]["email"].ToString());
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						td.Attributes.Add("class","data");
						td.InnerHtml = Decrypt(dat.Tables[0].Rows[0]["userOfficePhone"].ToString());
					tr.Cells.Add(td);         //Output </TD>
				}
				else
				{
					td = new HtmlTableCell(); //Output <TD>
						td.Attributes.Add("class","data");
						if (dr["First"].ToString()!="")
						{
							td.InnerHtml=dr["First"].ToString();
						}
						else
						{
							td.InnerHtml = "&#xa0;";
						}
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						td.Attributes.Add("class","data");
						if (dr["Last"].ToString()!="")
						{
							td.InnerHtml=dr["Last"].ToString();
						}
						else
						{
							td.InnerHtml = "&#xa0;";
						}
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						td.Attributes.Add("class","data");
						if (dr["EMailAddress"].ToString()!="")
						{
							td.InnerHtml=dr["EMailAddress"].ToString();
						}
						else
						{
							td.InnerHtml = "&#xa0;";
						}
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						td.Attributes.Add("class","data");
						if (dr["Phone"].ToString()!="")
						{
							td.InnerHtml=dr["Phone"].ToString();
						}
						else
						{
							td.InnerHtml = "&#xa0;";
						}
					tr.Cells.Add(td);         //Output </TD>
				}
  				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("class","data");
					if (v_userclass=="3" || v_userclass=="99")
					{
						td.InnerHtml = "<INPUT type='image' src='./img/roles.png' onclick=\"window.open('editRoles.aspx?uid="+dr["UserName"].ToString()+"','editRolesWin','width=350,height=600,menubar=no,status=yes')\" ALT='Edit Roles' />";
					}
					else
					{
						td.InnerHtml = "&#xa0;";
					}
				tr.Cells.Add(td);         //Output </TD>
				superTbl.Rows.Add(tr);           //Output </TR>
				fill=!fill;
			}
		}
	}
	//END Populate Supers Table

	//Populate WoDUsers table with dataset content
	if (datWoDUsers!=null)
	{
		fill=false;
		tr = new HtmlTableRow();    //Output <TR>
			tr.Attributes.Add("class","blackheading");
			td = new HtmlTableCell(); //Output <TD>
				td.Attributes.Add("colspan","6");
				td.InnerHtml = "WoD Users ("+ADWoDUsersGroup+")";
			tr.Cells.Add(td);         //Output </TD>
		wodUsersTbl.Rows.Add(tr);           //Output </TR>
		tr = new HtmlTableRow();    //Output <TR>
			tr.Attributes.Add("class","tableheading");
			td = new HtmlTableCell(); //Output <TD>
				td.Attributes.Add("style","width:130;");
				td.InnerHtml = "Username";
			tr.Cells.Add(td);         //Output </TD>
			td = new HtmlTableCell(); //Output <TD>
				td.Attributes.Add("style","width:75;");
				td.InnerHtml = "First";
			tr.Cells.Add(td);         //Output </TD>
			td = new HtmlTableCell(); //Output <TD>
				td.Attributes.Add("style","width:75;");
				td.InnerHtml = "Last";
			tr.Cells.Add(td);         //Output </TD>
			td = new HtmlTableCell(); //Output <TD>
				td.Attributes.Add("style","width:105;");
				td.InnerHtml = "E-Mail";
			tr.Cells.Add(td);         //Output </TD>
			td = new HtmlTableCell(); //Output <TD>
				td.Attributes.Add("style","width:100;");
				td.InnerHtml = "Phone";
			tr.Cells.Add(td);         //Output </TD>
			td = new HtmlTableCell(); //Output <TD>
				td.InnerHtml = "Actions";
			tr.Cells.Add(td);         //Output </TD>
		wodUsersTbl.Rows.Add(tr);           //Output </TR>	
		foreach (DataTable dt in datWoDUsers.Tables)
		{
			foreach (DataRow dr in dt.Rows)
			{
				tr = new HtmlTableRow();    //Output <TR>
				if (fill) tr.Attributes.Add("class","altrow");
					td = new HtmlTableCell(); //Output <TD>
						td.Attributes.Add("class","data");
						td.InnerHtml = dr["UserName"].ToString();
					tr.Cells.Add(td);         //Output </TD>
				sql="SELECT * FROM users WHERE userId='"+dr["UserName"].ToString()+"'";
				dat=readDb(sql);
				if (dat!=null)
				{
					td = new HtmlTableCell(); //Output <TD>
						td.Attributes.Add("class","data");
						td.InnerHtml = Decrypt(dat.Tables[0].Rows[0]["userFirstName"].ToString());
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						td.Attributes.Add("class","data");
						td.InnerHtml = Decrypt(dat.Tables[0].Rows[0]["userLastName"].ToString());
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						td.Attributes.Add("class","data");
						td.InnerHtml = Decrypt(dat.Tables[0].Rows[0]["email"].ToString());
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						td.Attributes.Add("class","data");
						td.InnerHtml = Decrypt(dat.Tables[0].Rows[0]["userOfficePhone"].ToString());
					tr.Cells.Add(td);         //Output </TD>
				}
				else
				{
					td = new HtmlTableCell(); //Output <TD>
						td.Attributes.Add("class","data");
						if (dr["First"].ToString()!="")
						{
							td.InnerHtml=dr["First"].ToString();
						}
						else
						{
							td.InnerHtml = "&#xa0;";
						}
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						td.Attributes.Add("class","data");
						if (dr["Last"].ToString()!="")
						{
							td.InnerHtml=dr["Last"].ToString();
						}
						else
						{
							td.InnerHtml = "&#xa0;";
						}
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						td.Attributes.Add("class","data");
						if (dr["EMailAddress"].ToString()!="")
						{
							td.InnerHtml=dr["EMailAddress"].ToString();
						}
						else
						{
							td.InnerHtml = "&#xa0;";
						}
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						td.Attributes.Add("class","data");
						if (dr["Phone"].ToString()!="")
						{
							td.InnerHtml=dr["Phone"].ToString();
						}
						else
						{
							td.InnerHtml = "&#xa0;";
						}
					tr.Cells.Add(td);         //Output </TD>
				}
  				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("class","data");
					if (v_userclass=="3" || v_userclass=="99")
					{
						td.InnerHtml = "<INPUT type='image' src='./img/roles.png' onclick=\"window.open('editRoles.aspx?uid="+dr["UserName"].ToString()+"','editRolesWin','width=350,height=600,menubar=no,status=yes')\" ALT='Edit Roles' />";
					}
					else
					{
						td.InnerHtml = "&#xa0;";
					}
				tr.Cells.Add(td);         //Output </TD>
				wodUsersTbl.Rows.Add(tr);           //Output </TR>
				fill=!fill;
			}
		}
	}
	//END Populate WoDUsers Table

	//Populate WoDAdmins table with dataset content
	if (datWoDAdmins!=null)
	{
		fill=false;
		tr = new HtmlTableRow();    //Output <TR>
			tr.Attributes.Add("class","blackheading");
			td = new HtmlTableCell(); //Output <TD>
				td.Attributes.Add("colspan","6");
				td.InnerHtml = "WoD Admins ("+ADWoDAdminsGroup+")";
			tr.Cells.Add(td);         //Output </TD>
		wodAdminsTbl.Rows.Add(tr);           //Output </TR>
		tr = new HtmlTableRow();    //Output <TR>
			tr.Attributes.Add("class","tableheading");
			td = new HtmlTableCell(); //Output <TD>
				td.Attributes.Add("style","width:130;");
				td.InnerHtml = "Username";
			tr.Cells.Add(td);         //Output </TD>
			td = new HtmlTableCell(); //Output <TD>
				td.Attributes.Add("style","width:75;");
				td.InnerHtml = "First";
			tr.Cells.Add(td);         //Output </TD>
			td = new HtmlTableCell(); //Output <TD>
				td.Attributes.Add("style","width:75;");
				td.InnerHtml = "Last";
			tr.Cells.Add(td);         //Output </TD>
			td = new HtmlTableCell(); //Output <TD>
				td.Attributes.Add("style","width:105;");
				td.InnerHtml = "E-Mail";
			tr.Cells.Add(td);         //Output </TD>
			td = new HtmlTableCell(); //Output <TD>
				td.Attributes.Add("style","width:100;");
				td.InnerHtml = "Phone";
			tr.Cells.Add(td);         //Output </TD>
			td = new HtmlTableCell(); //Output <TD>
				td.InnerHtml = "Actions";
			tr.Cells.Add(td);         //Output </TD>
		wodAdminsTbl.Rows.Add(tr);           //Output </TR>	
		foreach (DataTable dt in datWoDAdmins.Tables)
		{
			foreach (DataRow dr in dt.Rows)
			{
				tr = new HtmlTableRow();    //Output <TR>
				if (fill) tr.Attributes.Add("class","altrow"); 
					td = new HtmlTableCell(); //Output <TD>
						td.Attributes.Add("class","data");
						td.InnerHtml = dr["UserName"].ToString();
					tr.Cells.Add(td);         //Output </TD>
				sql="SELECT * FROM users WHERE userId='"+dr["UserName"].ToString()+"'";
				dat=readDb(sql);
				if (dat!=null)
				{
					td = new HtmlTableCell(); //Output <TD>
						td.Attributes.Add("class","data");
						td.InnerHtml = Decrypt(dat.Tables[0].Rows[0]["userFirstName"].ToString());
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						td.Attributes.Add("class","data");
						td.InnerHtml = Decrypt(dat.Tables[0].Rows[0]["userLastName"].ToString());
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						td.Attributes.Add("class","data");
						td.InnerHtml = Decrypt(dat.Tables[0].Rows[0]["email"].ToString());
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						td.Attributes.Add("class","data");
						td.InnerHtml = Decrypt(dat.Tables[0].Rows[0]["userOfficePhone"].ToString());
					tr.Cells.Add(td);         //Output </TD>
				}
				else
				{
					td = new HtmlTableCell(); //Output <TD>
						td.Attributes.Add("class","data");
						if (dr["First"].ToString()!="")
						{
							td.InnerHtml=dr["First"].ToString();
						}
						else
						{
							td.InnerHtml = "&#xa0;";
						}
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						td.Attributes.Add("class","data");
						if (dr["Last"].ToString()!="")
						{
							td.InnerHtml=dr["Last"].ToString();
						}
						else
						{
							td.InnerHtml = "&#xa0;";
						}
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						td.Attributes.Add("class","data");
						if (dr["EMailAddress"].ToString()!="")
						{
							td.InnerHtml=dr["EMailAddress"].ToString();
						}
						else
						{
							td.InnerHtml = "&#xa0;";
						}
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						td.Attributes.Add("class","data");
						if (dr["Phone"].ToString()!="")
						{
							td.InnerHtml=dr["Phone"].ToString();
						}
						else
						{
							td.InnerHtml = "&#xa0;";
						}
					tr.Cells.Add(td);         //Output </TD>
				}
  				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("class","data");
					if (v_userclass=="3" || v_userclass=="99")
					{
						td.InnerHtml = "<INPUT type='image' src='./img/roles.png' onclick=\"window.open('editRoles.aspx?uid="+dr["UserName"].ToString()+"','editRolesWin','width=350,height=600,menubar=no,status=yes')\" ALT='Edit Roles' />";
					}
					else
					{
						td.InnerHtml = "&#xa0;";
					}
				tr.Cells.Add(td);         //Output </TD>
				wodAdminsTbl.Rows.Add(tr);           //Output </TR>
				fill=!fill;
			}
		}
	}
	//END Populate WoDAdmins Table

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

//	Response.Write(ADUsersGroup);
	if (IsPostBack)
	{
		//  		username.Style["background"]="white";
		//	    	pass.Style["background"]="white";
		//		    errmsg.InnerHtml="";
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
				<DIV id='manageRoles' class='imgAlignMiddleCenter' runat='server'/>
			<BR/>
		</DIV>
		<DIV class='heading2'>&nbsp; Core System</DIV>
		<A class='gray' HREF='#coreUsers'>&nbsp; Users</A> &#8226; <A class='gray' HREF='#coreAdmins'>Admins</A> &#8226; <A class='gray' HREF='#coreSuper'>Super</A>
		<DIV class='center'>
			<A NAME='coreUsers'>/&nbsp;</A>
			<TABLE id='usersTbl' runat='server' class='datatable center' />
			<A NAME='coreAdmins'>/&nbsp;</A>
			<TABLE id='adminsTbl' runat='server' class='datatable center' />
			<A NAME='coreSuper'>/&nbsp;</A>
			<TABLE id='superTbl' runat='server' class='datatable center' />
		</DIV>
		<BR/>

		<DIV class='heading2'>Workspace-On-Demand Module</DIV>
		<A class='gray' HREF='#wodUsers'>Users</A> &#8226; <A class='gray' HREF='#wodAdmins'>Admins</A>
		<DIV class='center padded'>
			<A NAME='wodUsers'>/&nbsp;</A>
			<TABLE id='wodUsersTbl' runat='server' class='datatable center' />
			<A NAME='wodAdmins'>/&nbsp;</A>
			<TABLE id='wodAdminsTbl' runat='server' class='datatable center' />
		</DIV>
	</DIV> <!-- End: content -->

<!--#include file="closer.inc"-->

</DIV> <!-- End: container -->
</FORM>
</BODY>
</HTML>