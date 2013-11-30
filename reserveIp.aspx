<%@Page Inherits="CIS.conspectisLibrary" src="conspectisLibrary.cs" Language="C#" debug="true" %>
<%@Import Namespace="System.Data.OleDb"%>
<%@Import Namespace="System.Data"%>
<%@Import Namespace="System"%>

<!DOCTYPE html>
<!-- HTML5 Status: VALID 2-15-13 CK -->
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
	lockout(); Page.Header.Title=shortSysName+": Reserve an IP";
	systemStatus(1); // Check to see if admin has put system is in offline mode.

	string sql;
	DataSet dat=new DataSet();
	string errstr="", sqlErr="";
	string v_username, v_reserved, v_comment;
	string srcIp="", srcVlan="", dcPrefix="";

	bool sendSuccess=true, sqlSuccess=true;
	DateTime dateStamp = DateTime.Now;

	showIp.InnerHtml=srcIp;
	
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
		srcIp=Request.QueryString["ip"].ToString();
	}
	catch (System.Exception ex)
	{
		srcIp="";
	}
 
	try
	{
		srcVlan=Request.QueryString["vlan"].ToString();
	}
	catch (System.Exception ex)
	{
		srcVlan="";
	}
	try
	{
		dcPrefix=Request.QueryString["dc"].ToString();
	}
	catch (System.Exception ex)
	{
		dcPrefix = "";
	}

	if (!IsPostBack)
	{
		sql="SELECT * FROM "+dcPrefix+srcVlan+" WHERE ipAddr='"+srcIp+"'";
		dat=readDb(sql);
		if (!emptyDataset(dat))
		{
			reservedDropDown.SelectedIndex =	reservedDropDown.Items.IndexOf(reservedDropDown.Items.FindByValue(dat.Tables[0].Rows[0]["reserved"].ToString()));
		}
	}

	if (IsPostBack)
	{
		errmsg.InnerHtml = "";
		v_reserved=reservedDropDown.Value;
		v_comment=dateStamp+" - "+fix_txt(formComment.Value);
		sql="UPDATE "+dcPrefix+srcVlan+" SET reserved='"+v_reserved+"', comment='"+v_comment+"' WHERE ipAddr='"+srcIp+"'";
//		Response.Write(sql);
		sqlErr=writeDb(sql);
		if (sqlErr==null || sqlErr=="")
		{
			errmsg.InnerHtml = "IP Reservation Updated.";
			sqlSuccess=true;
		}
		else
		{
			errmsg.InnerHtml = "SQL Update Error - "+srcVlan+"<BR/>" +sqlErr;
			sqlErr="";
		}
		if (sqlSuccess) 
		{
			sqlErr=writeChangeLog(dateStamp.ToString(), Decrypt(v_username.ToString()), sql2txt(sql).ToString());
			try
			{
//				//  sendIpReservationNotice(srcVlan, srcIp);
			}
			catch (System.Exception ex)
			{
				sendSuccess=false;
				errstr=ex.ToString();
			}
			if (sendSuccess)
			{
				sqlErr=writeChangeLog(dateStamp.ToString(), Decrypt(v_username.ToString()), "IP Reservation Change Notice Sent: "+srcIp);
				if (sqlErr==null || sqlErr=="")
				{
					Response.Write("<script>refreshParent("+");<"+"/script>");
				}
			}
			else
			{
				errmsg.InnerHtml=errstr;
			}
		}
	} //if IsPostBack */
	titleSpan.InnerHtml="IP Reservation";
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
			<DIV class='center bold'>
				<DIV id='showIp' runat='server'/>
				<BR/>
				<TABLE border='1' class='datatable center'>
					<TR>
						<TD class='center'>
							<TABLE>
								<TR>
									<TD class='inputform bold'>Reserved?:&#xa0;</TD>
									<TD class='whiteRowFill left'>
										<SELECT id='reservedDropDown' name='reservedDropDown' runat='server'>
											<OPTION value='1'>Yes</OPTION>
											<OPTION value='0'>No</OPTION>
										</SELECT>
									</TD>
								</TR>
								<TR>
									<TD class='inputform bold'>Reason:&#xa0;</TD>
									<TD class='whiteRowFill left'>
										<TEXTAREA rows='5' cols='20' id='formComment' runat='server' />
									</TD>
								</TR>
							</TABLE>
						</TD>
					</TR>
				</TABLE>
				<BR/>
				<INPUT type='submit' value='Save Changes' runat='server'/>&#xa0;<INPUT type='button' value='Cancel &amp; Close' onclick='refreshParent()'/>
			</DIV>
			&nbsp;<BR/>
		</DIV>
	</DIV> <!-- End: popContent -->
<!--#include file='popup_closer.inc' -->
	</FORM>
</DIV> <!-- End: container -->
</BODY>
</HTML>