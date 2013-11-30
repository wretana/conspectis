<%@Page Inherits="CIS.conspectisLibrary" src="conspectisLibrary.cs" Language="C#" debug="true" %>
<%@Import Namespace="System.Data.OleDb"%>
<%@Import Namespace="System.Data"%>
<%@Import Namespace="System"%>

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
void addRoles(Object s, EventArgs e) 
{
	string addRoleString="";
	string v_username="";
	string srcKey="",sql="", sqlErr="", logErr="";
	DataSet dat = new DataSet();

	try
	{
		srcKey=Request.QueryString["uid"].ToString();
	}
	catch (System.Exception ex)
	{
		srcKey="";
	}

	DateTime dateStamp = DateTime.Now;

	try
	{
		v_username=Request.Cookies["username"].Value;
	}
	catch (System.Exception ex)
	{
		v_username="";
	}

	foreach (string key in Page.Request.Form.AllKeys)
	{
		if (key.Contains("addRole"))
		{
			addRoleString=addRoleString+Page.Request.Form[key]+" ";
		}
	}

	sql="SELECT * FROM users WHERE userId='"+Encrypt(srcKey)+"'";
	dat=readDb(sql);
	if (emptyDataset(dat))
	{
		sql="INSERT INTO users(userId, userRole) VALUES ('"+Encrypt(srcKey)+"','"+addRoleString.Trim()+"')";
//		Response.Write(sql);
		sqlErr=writeDb(sql);
		if (sqlErr=="")
		{
			logErr=writeChangeLog(dateStamp.ToString(), Decrypt(v_username.ToString()), "Role(s) '"+addRoleString.Trim()+"' added to user '"+srcKey+"'");
			Response.Write("<script>refreshParent("+");<"+"/script>");
		}
		else
		{
			errmsg.InnerHtml="Couldn't add role - "+sqlErr;
		}
	}
	else
	{
		sql="UPDATE users SET userRole='"+addRoleString.Trim()+"' WHERE userId='"+Encrypt(srcKey)+"'";
//		Response.Write(sql);
		sqlErr=writeDb(sql);
		if (sqlErr=="")
		{
			logErr=writeChangeLog(dateStamp.ToString(), Decrypt(v_username.ToString()), "Role(s) '"+addRoleString.Trim()+"' added to user '"+srcKey+"'");
			Response.Write("<script>refreshParent("+");<"+"/script>");
		}
		else
		{
			errmsg.InnerHtml="Couldn't add role - "+sqlErr;
		}
	}
}

public void Page_Load(Object o, EventArgs e)
{
//UNCOMMENT this line to force login to access this page.
	lockout(); 
	Page.Header.Title=shortSysName+": Manage Roles";
	systemStatus(1); // Check to see if admin has put system is in offline mode.

	string sql, sqlErr="";
	DataSet dat=new DataSet();
	HttpCookie cookie;
	bool sqlSuccess=true;
	string newRoleName="", newRoleGroup="", newRoleKey="", foundRoles="";
	string v_username="", v_userrole="", srcKey="";

	HtmlTableRow tr;
	HtmlTableCell td;
	bool fill;
	int i=0;

	DateTime dateStamp = DateTime.Now;

	StringCollection userGroups = new StringCollection();

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
		v_userrole=Request.Cookies["role"].Value;
	}
	catch (System.Exception ex)
	{
		v_userrole="";
	}

	try
	{
		srcKey=Request.QueryString["uid"].ToString();
	}
	catch (System.Exception ex)
	{
		srcKey="";
	}

	// Fetch roles defined for user by AD ...
	try
	{
		userGroups=getADUserGroups(srcKey);
	}
	catch (Exception ex)
	{
		errmsg.InnerHtml="Error fetching Groups: "+ex;
	}

	sql="SELECT userRole FROM users WHERE userId='"+Encrypt(srcKey)+"'";
	dat=readDb(sql);
	if (!emptyDataset(dat))
	{
		foundRoles=dat.Tables[0].Rows[0]["userRole"].ToString();
	}
	fill=false;
	if (userGroups!=null)
	{
		sql = "SELECT roleGroup, roleName, roleValue FROM userRoles WHERE roleGroup IS NOT NULL";
		dat=readDb(sql);
		if (!emptyDataset(dat))
		{		
			tr = new HtmlTableRow();    //Output <TR>
				tr.Attributes.Add("class","blackheading");
				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("colspan","1");
					td.InnerHtml = srcKey+"'s Current Roles";
				tr.Cells.Add(td);         //Output </TD>
			foundRolesTbl.Rows.Add(tr);           //Output </TR>
			foreach (DataTable dt in dat.Tables)
			{
				foreach (DataRow dr in dt.Rows)
				{
					if (userGroups.Contains("CN="+dr["roleGroup"]))
					{
						tr = new HtmlTableRow();    //Output <TR>
						if (fill) tr.Attributes.Add("class","altrow");
							td = new HtmlTableCell(); //Output <TD>
								td.InnerHtml = dr["roleName"].ToString()+" (<SPAN class='italic'>"+dr["roleGroup"].ToString()+"</SPAN>)";
							tr.Cells.Add(td);         //Output </TD>
						foundRolesTbl.Rows.Add(tr);           //Output </TR>
						fill=!fill;
					}
				}
			}
		}
	}

	// Fetch selectable local roles
	sql="SELECT * FROM userRoles WHERE roleGroup='' ORDER BY roleGroup ASC";
	dat=readDb(sql);
	if (!emptyDataset(dat))
	{
		tr = new HtmlTableRow();    //Output <TR>
			tr.Attributes.Add("class","blackheading");
			td = new HtmlTableCell(); //Output <TD>
				td.Attributes.Add("colspan","2");
				td.InnerHtml = "Available Local Roles";
			tr.Cells.Add(td);         //Output </TD>
		addRolesTbl.Rows.Add(tr);           //Output </TR>
		foreach (DataTable dt in dat.Tables)
		{
			foreach (DataRow dr in dt.Rows)
			{
				if (foundRoles.Contains(dr["roleValue"].ToString()))
				{
					tr = new HtmlTableRow();    //Output <TR>
					if (fill) tr.Attributes.Add("class","altrow");
						td = new HtmlTableCell(); //Output <TD>
							td.InnerHtml = dr["roleName"].ToString();
						tr.Cells.Add(td);         //Output </TD>
					foundRolesTbl.Rows.Add(tr);           //Output </TR>
					fill=!fill;
				}
				else
				{
					tr = new HtmlTableRow();    //Output <TR>
					if (fill) tr.Attributes.Add("class","altrow");
						td = new HtmlTableCell(); //Output <TD>
							td.InnerHtml = dr["roleName"].ToString();
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
							td.InnerHtml = "<INPUT type='checkbox' name='addRole"+i+"' value='"+dr["roleValue"].ToString()+"'/>";
						tr.Cells.Add(td);         //Output </TD>
					addRolesTbl.Rows.Add(tr);           //Output </TR>
					fill=!fill;
					i++;
				}
			}
		}
	}
	

	if (IsPostBack)
	{
	}

	titleSpan.InnerHtml="Manage Roles";
}
</SCRIPT>
</HEAD>
<!--#include file='body.inc' -->
<DIV id='popContainer'>
	<FORM runat='server'>
<!--#include file='popup_opener.inc' -->
	<DIV id='popContent'>
		<DIV class='center altRowFill'>
			<SPAN id='titleSpan' runat='server'/>
			<DIV id='errmsg' class='errorLine' runat='server'/>
		</DIV>
		
		<DIV class='center paleColorFill'>
		&nbsp;<BR/>
			<DIV class='center'>
				<TABLE id='foundRolesTbl' runat='server' class='datatable center' />
				<BR/>
				<TABLE id='addRolesTbl' runat='server' class='datatable center' />
				<BR/>
				<INPUT type='button' id='addRoleButton' value='Add Selected' OnServerClick='addRoles' runat='server' />
				<INPUT type='button' value='Cancel &amp; Close' onclick='refreshParent()'/>
			</DIV>
		&nbsp;<BR/>
		</DIV>
	</DIV> <!-- End: popContent -->
<!--#include file='popup_closer.inc' -->
	</FORM>
</DIV> <!-- End: container -->
</BODY>
</HTML>