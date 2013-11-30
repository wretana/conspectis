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
	lockout(); Page.Header.Title=shortSysName+": Edit Dependency";
	systemStatus(1); // Check to see if admin has put system is in offline mode.

	string sql, sqlErr="", errstr="";
	DataSet dat=new DataSet();
	HttpCookie cookie;
	bool sqlSuccess=false, sendSuccess=true;
	string serverIn="", v_hostname="", v_username="", v_dependsOn="", dcPrefix="";

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
		serverIn=Request.QueryString["id"].ToString();
	}
	catch (System.Exception ex)
	{
		serverIn="";
	}
	
	try
	{
		dcPrefix=Request.QueryString["dc"].ToString();
	}
	catch (System.Exception ex)
	{
		dcPrefix="";
	}


	
	if (!IsPostBack)
	{
		sql="SELECT serverName,dependsOn FROM "+dcPrefix+"servers WHERE rackspaceId="+serverIn+" AND serverOs<>'RSA2'";
		dat=readDb(sql);
		if (!emptyDataset(dat))
		{
			v_hostname=dat.Tables[0].Rows[0]["serverName"].ToString();
			v_dependsOn=dat.Tables[0].Rows[0]["dependsOn"].ToString();
		}
		if (v_dependsOn=="")
		{
			formComment.Value="Comma-Separated List of Servers ...";
		}
		else
		{
			formComment.Value=v_dependsOn.Trim().Replace(" ", ", ");
		}
		showHostname.InnerHtml=v_hostname+" <SPAN class='italic'>("+dcPrefix.ToUpper().Replace("_","")+")</SPAN>";
	}
	
	
	if (IsPostBack)
	{
		string curServer="", curDependsOn="";
		string v_formComment="";
		v_formComment=formComment.Value;
		if (formComment.Value=="Comma-Separated List of Servers ...")
		{
			v_formComment="";
		}
		if (v_formComment!="")
		{
			string[] servers = v_formComment.Split(',');
			foreach (string server in servers)
			{
				curServer=fix_txt(server).ToUpper();
				sql="SELECT * FROM "+dcPrefix+"servers WHERE serverName='"+curServer+"'";
//				Response.Write("<BR/>"+sql);
				dat=readDb(sql);
				if (!emptyDataset(dat))
				{
					curDependsOn=dat.Tables[0].Rows[0]["dependsOn"].ToString()+" "+curServer;
					sql="UPDATE "+dcPrefix+"servers SET dependsOn='"+curDependsOn.Trim()+"' WHERE rackspaceId="+serverIn+" AND serverOs<>'RSA2'";
//					Response.Write("<BR/>"+sql);
					sqlErr=writeDb(sql);
					if (sqlErr==null || sqlErr=="")
					{
						errmsg.InnerHtml = "Server Dependency Updated.";
						sqlSuccess=true;
					}
					else
					{
						errmsg.InnerHtml = "SQL Update Error - "+sql+"<BR/>" +sqlErr;
						sqlErr="";
					}
					if (sqlSuccess) 
					{
						sqlErr=writeChangeLog(dateStamp.ToString(), Decrypt(v_username.ToString()), sql2txt(sql).ToString());
						if (sqlErr==null || sqlErr=="")
						{
							Response.Write("<script>refreshParent("+");<"+"/script>");
						}
					}			
				}
				else
				{
					errstr=errstr+"Could not find server matching '"+curServer+"'<BR/>";
				}
			}
		}
		else
		{
			errmsg.InnerHtml="Please type a comma-separated list of servers in the textbox.";
		}

	}
	titleSpan.InnerHtml="Edit Server Dependencies";
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
				<DIV id='showHostname' class='bold' runat='server'/>
				<BR/>
				<TABLE border='1' class='datatable center'>
					<TR>
						<TD class='center'>
							<TABLE>
								<TR><TD class='inputform'>&#xa0;</TD><TD class='whiteRowFill'>&#xa0;</TD></TR>
								<TR>
									<TD class='inputform'><SPAN class='bold'>This Server &#xa0;<BR/>Depends On:&#xa0;</SPAN></TD>
									<TD class='whiteRowFill'>
										<TEXTAREA rows='5' cols='20' id='formComment' runat='server' />
									</TD>
								</TR>
								<TR><TD class='inputform'>&#xa0;</TD><TD class='whiteRowFill'>&#xa0;</TD></TR> 
							</TABLE>
						</TD>
					</TR>
				</TABLE>
				<BR/>&nbsp;
				<INPUT type='submit' value='Save Changes' runat='server'/>&#xa0;<INPUT type='button' value='Cancel &amp; Close' onclick='refreshParent()'/>
			</DIV>
			&nbsp;
		</DIV>
	</DIV> <!-- End: popContent -->
<!--#include file='popup_closer.inc' -->
	</FORM>
</DIV> <!-- End: container -->
</BODY>
</HTML>