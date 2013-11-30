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
public void Page_Load(Object o, EventArgs e)
{
//UNCOMMENT this line to force login to access this page.
	lockout(); Page.Header.Title=shortSysName+": Edit Rack";
	systemStatus(1); // Check to see if admin has put system is in offline mode.

	string sql, sqlErr;
	DataSet dat=new DataSet();
	HttpCookie cookie;
	bool sqlSuccess=true;
	string rack="", v_topU, v_botU, v_loc, dcPre="";
	string v_username;

	DateTime dateStamp = DateTime.Now;

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
		rack=Request.QueryString["rackId"].ToString();
	}
	catch (System.Exception ex)
	{
		rack="";
	}

	try
	{
		dcPre=Request.QueryString["dc"].ToString();
	}
	catch (System.Exception ex)
	{
		dcPre="";
	}

	if (rack!="" || rack!=null)
	{
		titleSpan.InnerHtml="Edit Rack #"+rack+"";
	}
	else
	{
		titleSpan.InnerHtml="Edit Rack";
	}
	
	if (!IsPostBack)
	{
		sql="SELECT * FROM "+dcPre+"racks WHERE rackId='"+rack+"'";
		dat=readDb(sql);
		if (!emptyDataset(dat))
		{
			formRackBotU.Value=dat.Tables[0].Rows[0]["uMin"].ToString();
			formRackTopU.Value=dat.Tables[0].Rows[0]["uMax"].ToString();
			formRackLoc.Value=dat.Tables[0].Rows[0]["location"].ToString();

			titleSpan.InnerHtml="Edit Rack: "+dat.Tables[0].Rows[0]["location"].ToString()+"-R"+dat.Tables[0].Rows[0]["rackId"].ToString().Substring(0,2)+"-C"+dat.Tables[0].Rows[0]["rackId"].ToString().Substring(2,2)+"";
		}
	}


	if (IsPostBack)
	{
		v_topU=fix_txt(formRackTopU.Value.ToString()); 
		v_botU=fix_txt(formRackBotU.Value.ToString());
		v_loc=fix_txt(formRackLoc.Value.ToString());
		bool checkState=false;

		if (rack!="" && rack!=null && v_topU!="" && v_topU!=null && v_botU!="" && v_botU!=null)
		{
			checkState=true;
		}

		if (checkState)
		{
			sql="UPDATE "+dcPre+"racks SET "	+"uMax='"     +v_topU+"',"
						+"uMin='"     +v_botU+"',"
						+"location='" +v_loc+ "' WHERE rackId='"+rack+"'";
			sqlErr=writeDb(sql);
			if (sqlErr==null || sqlErr=="")
			{
				errmsg.InnerHtml = "Rack Record Updated.";
				sqlSuccess=true;
			}
			else
			{
				errmsg.InnerHtml = "SQL Update Error - Racks<BR/>"+sqlErr;
				sqlErr="";
			}
			if (sqlSuccess) 
			{
				sqlErr=writeChangeLog(dateStamp.ToString(), Decrypt(v_username.ToString()), "Rack #"+rack+" properties change.");
				if (sqlErr==null || sqlErr=="")
				{
//					Response.Write(sql);
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
			if (v_topU == "") formRackTopU.Style["background"]="yellow";
			if (v_botU == "") formRackBotU.Style["background"]="yellow";
			if (v_loc == "") formRackLoc.Style["background"]="yellow";
			string errStr = "Please enter valid data in all required fields!";
			errmsg.InnerHtml=errStr;
		}
	}
}
</SCRIPT>
</HEAD>
<!--#include file='body.inc' -->
<DIV id='popContainer'>
	<FORM id='popupform' runat='server'>
<!--#include file='popup_opener.inc' -->
	<DIV id='popContent'>
		<DIV class='center altRowFill'>
			<SPAN id='titleSpan' runat='server'/>
			<DIV id='errmsg' class='errorLine' runat='server'/>
		</DIV>
		<DIV class='center paleColorFill'>
		&nbsp;<BR/>
			<DIV class='center'>
				<TABLE border='1' class='datatable center'>
					<TR><TD class='center'>
						<TABLE>
							<TR>
								<TD class='inputform'>&#xa0;</TD>
								<TD class='whiteRowFill'>&#xa0;</TD>
							</TR>
							<TR>
								<TD class='inputform'><SPAN class='bold'>Bottom 'U':&#xa0;</SPAN></TD>
								<TD class='whiteRowFill'><INPUT type='text' id='formRackBotU' runat='server'></TD>
							</TR>
							<TR>
								<TD class='inputform'><SPAN class='bold'>Top 'U':&#xa0;</SPAN></TD>
								<TD class='whiteRowFill'><INPUT type='text' id='formRackTopU' runat='server'></TD>
							</TR>
							<TR>
								<TD class='inputform'><SPAN class='bold'>Location:&#xa0;</SPAN></TD>
								<TD class='whiteRowFill'><INPUT type='text' id='formRackLoc' runat='server'></TD>
							</TR>
							<TR>
								<TD class='inputform'>&#xa0;</TD>
								<TD class='whiteRowFill'>&#xa0;</TD>
							</TR> 
						</TABLE>
					</TD></TR>
				</TABLE><BR/>
				<INPUT type='submit' value='Save Changes' runat='server'>&#xa0;<INPUT type='button' value='Cancel &amp; Close' onclick='refreshParent()'>
			</DIV>
		&nbsp;<BR/>
		</DIV>
	</DIV> <!-- End: popContent -->
<!--#include file='popup_closer.inc' -->
	</FORM>
</DIV> <!-- End: container -->
</BODY>
</HTML>