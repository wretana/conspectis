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
	lockout(); Page.Header.Title=shortSysName+": Add Existing Switch";
	systemStatus(1); // Check to see if admin has put system is in offline mode.

	string sql;
	DataSet dat=new DataSet();
	HttpCookie cookie;
	bool sqlSuccess=true;
	string hwId="", port="", tableStr="";

	DateTime dateStamp = DateTime.Now;

	try
	{
		hwId=Request.QueryString["id"].ToString();
	}
	catch (System.Exception ex)
	{
		hwId="";
	}

	string dcArg="";
	try
	{
		dcArg=Request.QueryString["dc"].ToString();
	}
	catch (System.Exception ex)
	{
		dcArg= "";
	}

	if (IsPostBack)
	{
		string swType="",swName="", sqlErr="",swRackId="";
		swType=switchType.Value;
		swName=switchName.Value;
		swRackId=switchRackId.Value;
		confirmSpan.InnerHtml = "Building "+swType+" Switch '"+swName+"', please wait ...";
		switch (swType)
		{
			case "Catalyst 6509 Switch":
				sqlErr=buildCisco6509(swName,swRackId,dcArg);
				break;
			case "DS9509-EMC":
				sqlErr=buildDS9509(swName,swRackId,dcArg);
				break;
			case "Catalyst 3750G":
				sqlErr=buildCatalyst3750G(swName,swRackId,dcArg);
				break;
			case "Nexus 5020":
				sqlErr=buildNexus5020(swName,swRackId,dcArg);
				break;
			case "Nexus 2232PP":
				sqlErr=buildNexus2232PP(swName,swRackId,dcArg);
				break;
			case "Nexus 2248TP":
				sqlErr=buildNexus2248TP(swName,swRackId,dcArg);
				break;
			case "MDS 9120":
				sqlErr=buildMDS9120(swName,swRackId,dcArg);
				break;
			case "MDS 9020":
				sqlErr=buildMDS9020(swName,swRackId,dcArg);
				break;
			case "Nexus 7000":
				sqlErr=buildNexus7000(swName,swRackId,dcArg);
				break;
		}

		if (sqlErr==null || sqlErr=="")
		{
			Response.Write("<script>refreshParent("+");<"+"/script>");
		}

	}

	if (!IsPostBack)
	{
		idSpan.InnerHtml=hwId;
		if (hwId!="")
		{
			sql="SELECT rackspaceId, rack, slot, class, model, hwType, hwUSize FROM "+dcArg+"rackspace INNER JOIN hwTypes ON "+dcArg+"rackspace.class=hwTypes.hwClassName WHERE rackspaceId="+hwId;
			dat=readDb(sql);
			if (!emptyDataset(dat))
			{
				idSpan.InnerHtml="You have chosen to bring the following switch online.  This will allow the system to document and track cabling for this switch. <BR/><BR/><TABLE></TABLE>";
				tableStr="<TABLE style='border-collapse: collapse;'><TR><TH style='border-width: 1px; padding: 1px; border-style: inset; border-color: black; background-color: black; font-size: 70%; color: white;' align='center'><SPAN class='bold'>Switch</SPAN></TH><TH style='border-width: 1px; padding: 1px; border-style: inset; border-color: black; background-color: black; font-size: 70%; color: white;' align='center'><SPAN class='bold'>Type</SPAN></TH><TH style='border-width: 1px; padding: 1px; border-style: inset; border-color: black; background-color: black; font-size: 70%; color: white;' align='center'><SPAN class='bold'>Location</SPAN></TH><TH style='border-width: 1px; padding: 1px; border-style: inset; border-color: black; background-color: black; font-size: 70%; color: white;' align='center'>Size</TH></TR>";
				foreach(DataRow dr in dat.Tables[0].Rows)
				{
					tableStr=tableStr+"<TR><TD style='border-width: 1px; padding: 1px; border-style: solid; border-color: black;'>&#xa0; "+dr["model"].ToString()+" &#xa0;</TD><TD style='border-width: 1px; padding: 1px; border-style: solid; border-color: black;'>&#xa0; "+dr["class"].ToString()+" &#xa0;</TD><TD style='border-width: 1px; padding: 1px; border-style: solid; border-color: black;'>&#xa0; Rack:"+dr["rack"].ToString()+", U"+dr["slot"].ToString()+" &#xa0;</TD><TD style='border-width: 1px; padding: 1px; border-style: solid; border-color: black;'>&#xa0; "+dr["hwUSize"].ToString()+" &#xa0;</TD></TR>";
					switchType.Value=dr["class"].ToString();
					switchName.Value=dr["model"].ToString();
					switchRackId.Value=hwId;
				}
				tableStr=tableStr+"</TABLE>";
			}
			tableSpan.InnerHtml=tableStr;
		}
		confirmSpan.InnerHtml="Are you sure you want to do this?";
	}
	titleSpan.InnerHtml="Add Existing Switch";
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
				<DIV id='idSpan' runat='server'/>
				<DIV id='tableSpan' runat='server'/>
				<INPUT type='hidden' id='switchType' runat='server' >
				<INPUT type='hidden' id='switchName' runat='server' >
				<INPUT type='hidden' id='switchRackId' runat='server' >
			</DIV>
			<DIV id='confirmSpan' runat='server'/>
			<BR/>
			<INPUT type='submit' value='Yes' runat='server'/>&#xa0;<INPUT type='button' value='No' onclick='refreshParent()'>
			<BR/><BR/>
			</FORM>
		</DIV>
	</DIV> <!-- End: popContent -->
<!--#include file='popup_closer.inc' -->
</DIV> <!-- End: container -->
</BODY>
</HTML>