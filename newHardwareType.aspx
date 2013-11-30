<%@Page Inherits="CIS.conspectisLibrary" src="conspectisLibrary.cs" Language="C#" debug="true" %>
<%@Import Namespace="System.Data.OleDb"%>
<%@Import Namespace="System.Data"%>
<%@Import Namespace="System"%>

<!DOCTYPE html>
<!-- HTML5 Status: VALID 2-13-13 CK -->
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
	lockout(); Page.Header.Title=shortSysName+": Add New Hardware Type / Class";
	systemStatus(1); // Check to see if admin has put system is in offline mode.



	string sql, sqlErr;
	DataSet dat, hwdd;
	HttpCookie cookie;
	bool sqlSuccess=true, permitted=false;
	string access="", port="";
	string v_username, v_userclass="", v_userrole="";

	DateTime dateStamp = DateTime.Now;

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

	try
	{
		v_username=Request.Cookies["username"].Value;
	}
	catch (System.Exception ex)
	{
		v_username="";
	}

	if (System.Text.RegularExpressions.Regex.IsMatch(v_userrole, "datacenter", System.Text.RegularExpressions.RegexOptions.IgnoreCase))
	{
		permitted=true;
	}

	if (!permitted)
	{
		Response.Write("<script>window.location.href='noAccess.aspx?referrer=newHardwareType';<"+"/script>");
	}

	if (!IsPostBack)
	{
		sql="SELECT DISTINCT hwType FROM hwTypes ORDER BY hwType ASC";
		hwdd=readDb(sql);
		if (hwdd!=null)
		{
			foreach(DataRow dr in hwdd.Tables[0].Rows)
			{
				ListItem li = new ListItem(dr["hwType"].ToString(), dr["hwType"].ToString());
				formHwTypeDd.Items.Add(li);
			}
//			formExistType.SelectedIndex=formExistType.Items.IndexOf(formExistType.Items.FindByValue("BladeCenter H"));
		}	
	}

	if (IsPostBack)
	{
		string v_class=formHwTypeClass.Value, v_Usize=formHwTypeHeight.Value, v_ddType=formHwTypeDd.Value, v_type="";
		if (v_ddType=="other")
		{
			v_type=fix_txt(formHwTypeOther.Value);
		}
		else
		{
			v_type=fix_txt(formHwTypeDd.Value);	
		}
//		Response.Write("Class:"+v_class+"<BR/>");
//		Response.Write("Type:"+v_type+"<BR/>");
//		Response.Write("USize:"+v_Usize);

		sql= "SELECT * FROM hwTypes WHERE hwClassName='"+v_class+"'";
		dat=readDb(sql);
		if (emptyDataset(dat))
		{
			sql= "INSERT INTO hwTypes(hwClassName,hwType,hwUSize) VALUES("
							+"'" +v_class+ "',"
							+"'" +v_type+ "',"
							+"'" +v_Usize+   "')";
//			Response.Write(sql);
			sqlErr=writeDb(sql);
			if (sqlErr!=null && sqlErr!="")
			{
				sqlSuccess=false;
				errmsg.InnerHtml = "SQL Update Error - New Hardware Type<BR/>"+sqlErr;
			}
			else
			{	
				sqlErr="";
			}
			if (sqlSuccess) 
			{
				string statString="New Hardware Type ["+v_class+"] Added.";
				sqlErr=writeChangeLog(dateStamp.ToString(), Decrypt(v_username.ToString()), sql2txt(sql).ToString());
				if (sqlErr==null || sqlErr=="")
				{
					Response.Write("<script>refreshParent("+");<"+"/script>");
				}	
				else
				{
					errmsg.InnerHtml = "WARNING: "+sqlErr;
				}
			}
		}
		else
		{
			errmsg.InnerHtml=v_class+" - A Duplicate Record already exists.";
		}
	}
	titleSpan.InnerHtml="Add New Hardware Type";
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
				<TABLE class='datatable center'>
					<TR>
						<TD class='center'>
							<TABLE>
								<TR>
									<TD class='inputform'>&#xa0;</TD>
									<TD class='whiteRowFill left'>&#xa0;</TD>
								</TR>
								<TR>
									<TD class='inputform'>Hardware Name:</TD>
									<TD class='whiteRowFill left'>
										<INPUT type='text' id='formHwTypeClass' runat='server'>
									</TD>
								</TR>
								<TR>
									<TD class='inputform'>Hardware Type:</TD>
									<TD class='whiteRowFill left'>
										<SELECT id='formHwTypeDd' runat='server'>
											<OPTION value='other'>Other...</OPTION>
										</SELECT>
									</TD>
								</TR>
								<TR>
									<TD class='inputform'>
										<DIV id='otherType' runat='server'/>
									</TD>
									<TD class='whiteRowFill left'>
										&#xa0; &#xa0;
										<INPUT type='text' size='18' id='formHwTypeOther' runat='server'>
									</TD>
								</TR>
								<TR>
									<TD class='inputform'>'U' Height:</TD>
									<TD class='whiteRowFill left'>
										<INPUT type='text' id='formHwTypeHeight' runat='server'>
									</TD>
								</TR>
								<TR><TD class='inputform'>&#xa0;</TD><TD class='whiteRowFill left'>&#xa0;</TD></TR> 
							</TABLE>
						</TD>
					</TR>
			</TABLE><BR/>
			<INPUT type='submit' value='Save Changes' runat='server'/>&#xa0;<INPUT type='button' value='Cancel &amp; Close' onclick='refreshParent()'>
			</DIV>
		&nbsp;<BR/>
		</DIV>
	</DIV> <!-- End: popContent -->
<!--#include file='popup_closer.inc' -->
	</FORM>
</DIV> <!-- End: container -->
</BODY>
</HTML>