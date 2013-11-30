<%@Page Inherits="CIS.conspectisLibrary" src="conspectisLibrary.cs" Language="C#" debug="true" %>
<%@Import Namespace="System.Data.OleDb"%>
<%@Import Namespace="System.Data"%>
<%@Import Namespace="System"%>

<!DOCTYPE html>
<!-- HTML5 Status: VALID 2-9-13 CK -->
<!--[if lt IE 7 ]> <html lang='en' class='no-js ie6'> <![endif]-->
<!--[if IE 7 ]>    <html lang='en' class='no-js ie7'> <![endif]-->
<!--[if IE 8 ]>    <html lang='en' class='no-js ie8'> <![endif]-->
<!--[if IE 9 ]>    <html lang='en' class='no-js ie9'> <![endif]-->
<!--[if (gt IE 9)|!(IE)]><!--> <html lang='en' class='no-js'> <!--<![endif]-->

<HEAD runat="server">

<!--#include file="header.inc"-->

<SCRIPT runat="server">
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
	string newRoleName="", newRoleGroup="", newRoleKey="";
	string v_username="", v_userrole="";

	HtmlTableRow tr;
	HtmlTableCell td;
	bool fill;

	DateTime dateStamp = DateTime.Now;

	rolesTbl.Rows.Clear();

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

	sql="SELECT * FROM userRoles ORDER BY roleGroup ASC";
	dat=readDb(sql);
	if (!emptyDataset(dat))
	{
		fill=false;
		tr = new HtmlTableRow();    //Output <TR>
			tr.Attributes.Add("class","blackheading");
			td = new HtmlTableCell(); //Output <TD>
				td.Attributes.Add("colspan","4");
				td.InnerHtml = "Defined Roles";
			tr.Cells.Add(td);         //Output </TD>
		rolesTbl.Rows.Add(tr);           //Output </TR>
		foreach (DataTable dt in dat.Tables)
		{
			foreach (DataRow dr in dt.Rows)
			{
				tr = new HtmlTableRow();    //Output <TR>
				if (fill) tr.Attributes.Add("class","altrow");
					td = new HtmlTableCell(); //Output <TD>
						td.InnerHtml = dr["roleName"].ToString();
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						td.InnerHtml = dr["roleGroup"].ToString();
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						td.InnerHtml = dr["roleValue"].ToString();
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						td.InnerHtml = "<INPUT type='image' src='./img/delete.png' onclick=\"window.open('deleteRole.aspx?key="+dr["roleValue"].ToString()+"','deleteroleWin','width=350,height=275,menubar=no,status=yes')\" ALT='Delete Role' />";
					tr.Cells.Add(td);         //Output </TD>
				rolesTbl.Rows.Add(tr);           //Output </TR>
				fill=!fill;
			}
		}
	}
	
	if (IsPostBack)
	{
		newRoleName=formRoleName.Value;
		newRoleGroup=formRoleGroup.Value;
		newRoleKey=formRoleKey.Value;

		if (newRoleName!="" && newRoleKey!="")
		{
			sql="INSERT INTO userRoles(roleValue, roleName, roleGroup) VALUES('"+newRoleKey+"','"+newRoleName+"','"+newRoleGroup+"')";
			sqlErr=writeDb(sql);
			if (sqlErr=="")
			{
				sqlErr=writeChangeLog(dateStamp.ToString(), Decrypt(v_username.ToString()), "New Role Created: "+newRoleName);
			}
			else
			{
				errmsg.InnerHtml="Couldn't add role - "+sqlErr;
			}
		}

		sql="SELECT * FROM userRoles ORDER BY roleGroup ASC";
		dat=readDb(sql);
		if (!emptyDataset(dat))
		{
			fill=false;
			tr = new HtmlTableRow();    //Output <TR>
				tr.Attributes.Add("class","blackheading");
				td = new HtmlTableCell(); //Output <TD>
					td.Attributes.Add("colspan","4");
					td.InnerHtml = "Defined Roles";
				tr.Cells.Add(td);         //Output </TD>
			rolesTbl.Rows.Add(tr);           //Output </TR>
			foreach (DataTable dt in dat.Tables)
			{
				foreach (DataRow dr in dt.Rows)
				{
					tr = new HtmlTableRow();    //Output <TR>
					if (fill) tr.Attributes.Add("class","altrow");
						td = new HtmlTableCell(); //Output <TD>
							td.InnerHtml = dr["roleName"].ToString();
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
							td.InnerHtml = dr["roleGroup"].ToString();
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
							td.InnerHtml = dr["roleValue"].ToString();
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
							td.InnerHtml = "<INPUT type='image' src='./img/delete.png' onclick=\"window.open('deleteRole.aspx?key="+dr["roleValue"].ToString()+"','deleteroleWin','width=350,height=275,menubar=no,status=yes')\" ALT='Delete Role' />";
						tr.Cells.Add(td);         //Output </TD>
					rolesTbl.Rows.Add(tr);           //Output </TR>
					fill=!fill;
				}
			}
		}
	}
	titleSpan.InnerHtml="Manage Roles";
}
</SCRIPT>
</HEAD>
<!--#include file='body.inc' -->
<DIV id='popContainer'>
<!--#include file='popup_opener.inc' -->
	<DIV id='popContent'>
		<DIV class='center altRowFill'>
			<SPAN id='titleSpan' runat='server'/>
			<DIV class='center'>
				<DIV id='errmsg' class='errorLine' runat='server'/>
			</DIV>
		</DIV>
		<DIV class='center paleColorFill'>	
			&#xa0;<BR/>
			<FORM runat='server'>
			<DIV class='center'>
				<TABLE id='rolesTbl' runat='server' class='datatable center' border='1'>
					<TR class='blackheading'>
						<TD colspan='4'>New Role</TD>
					</TR>
					<TR class='tableheading'>
						<TD style='width:75px;'>Role</TD>
						<TD style='width:75px;'>AD Group</TD>
						<TD style='width:50px;'>Keyword</TD>
						<TD style='width:50px;'>Action</TD>
					</TR>
					<TR>
						<TD><INPUT type='text' id='formRoleName' size='25' runat='server'></TD>
						<TD><INPUT type='text' id='formRoleGroup' size='25' runat='server'></TD>
						<TD><INPUT type='text' id='formRoleKey' size='12' maxlength='12' runat='server'></TD>
						<TD>&#xa0;</TD>
					</TR>
					<TR>
						<TD colspan='4'>NOTE: If you wish for the new role to be governed by an AD group, please include it.<BR/>  Leaving the AD Group blank will create a role localized to this system only.</TD>
					</TR>
					<TR>
						<TD colspan='4'><INPUT type='submit' value='Add Role' runat='server'/></TD>
					</TR>
				</TABLE>
				<BR/><INPUT type='button' value='Cancel &amp; Close' onclick='refreshParent()'/>
			</DIV>
			</FORM>
			&nbsp;<BR/>
		</DIV>
	</DIV> <!-- End: popContent -->
<!--#include file='popup_closer.inc' -->
</DIV> <!-- End: container -->
</BODY>
</HTML>