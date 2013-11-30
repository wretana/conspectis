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
	lockout(); Page.Header.Title=shortSysName+": Assign IP";
	systemStatus(1); // Check to see if admin has put system is in offline mode.

	string sql,sql1,sql2,sqlSwitch;
	DataSet dat,dat1,dat2=null,datSwitch, datBc=null;
	string v_username, sqlErr="";
	string errstr="";
	string srcHost="";
	string dcPrefix="";
	bool sendSuccess=true;
	bool portsFound=false;
	DateTime dateStamp = DateTime.Now;
	string v_userclass="", v_userrole="", v_svrModel="", v_svrVlan="", v_srcBc="", v_srcRack="", v_srcSlot="";
	hostname.InnerHtml=srcHost;
	
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

	try
	{
		srcHost=Request.QueryString["host"].ToString();
	}
	catch (System.Exception ex)
	{
		srcHost="";
	}

	try
	{
		dcPrefix=Request.QueryString["dc"].ToString();
	}
	catch (System.Exception ex)
	{
		dcPrefix="";
	}

	if (!v_userrole.Contains("vmware") && v_userclass!="99" && v_userclass!="3")
	{
		Response.Write("<script language='javascript'>refreshParent();//-->"+"<"+"/script>");
	}

	if (!IsPostBack)
	{
		sql="SELECT * FROM "+dcPrefix+"servers INNER JOIN "+dcPrefix+"rackspace ON "+dcPrefix+"servers.rackspaceId="+dcPrefix+"rackspace.rackspaceId WHERE serverName='"+srcHost+"'";
//		Response.Write(sql1);
		dat=readDb(sql);
		if (!emptyDataset(dat))
		{
			v_svrModel=dat.Tables[0].Rows[0]["model"].ToString();
			v_svrVlan=dat.Tables[0].Rows[0]["serverPubVlan"].ToString();
			v_srcBc=dat.Tables[0].Rows[0]["bc"].ToString();
			v_srcRack=dat.Tables[0].Rows[0]["rack"].ToString();
			v_srcSlot=dat.Tables[0].Rows[0]["slot"].ToString();
		}
		

		sql1="SELECT ipAddr FROM (SELECT * FROM "+dcPrefix+v_svrVlan+" LEFT JOIN "+dcPrefix+"servers ON "+dcPrefix+"servers.serverLanIp="+dcPrefix+v_svrVlan+".ipAddr WHERE "+dcPrefix+"servers.serverLanIp is Null) AS a WHERE reserved=0 ORDER BY ipAddr";
//		Response.Write(sql1);
		dat1=readDb(sql1);

		formPubIp.DataSource = dat1;
		formPubIp.DataTextField = "ipAddr";
		formPubIp.DataValueField = "ipAddr";
		formPubIp.DataBind(); 
		
		int rackspace=0;
		try
		{
			rackspace=Convert.ToInt32(v_srcRack);
		}
		catch (System.Exception ex)
		{
			rackspace=0;
		}
		
		if (v_srcBc!="")
		{
			sql="SELECT * FROM (SELECT bc FROM bladeChassis WHERE ethernetType='managedSwitch') AS a WHERE bc='"+v_srcBc+"'";
			datBc=readDb(sql);
			if (datBc!=null)
			{
				sql1="SELECT rackspaceId FROM "+dcPrefix+"rackspace WHERE rack='"+v_srcRack+"' AND bc='"+v_srcBc+"' AND slot IN('"+v_srcSlot+"','00') AND class<>'Virtual'";
				if (v_svrModel=="ESX")
				{	
					sql1="SELECT rackspaceId FROM "+dcPrefix+"rackspace WHERE rack='"+v_srcRack+"' AND bc='"+v_srcBc+"' AND slot IN('"+v_srcSlot.Substring(0,2)+"','00')";
				
				}
			}
			else
			{
				sql1="SELECT rackspaceId FROM "+dcPrefix+"rackspace WHERE rack='"+v_srcRack+"' AND bc='"+v_srcBc+"' AND slot='00' AND class<>'Virtual'";
			}			
		}
		else
		{
			sql1="SELECT rackspaceId FROM "+dcPrefix+"rackspace WHERE rack='"+v_srcRack+"' AND slot='"+v_srcSlot+"' AND class<>'Virtual'";
		}
		dat1=readDb(sql1);
//		Response.Write(sql1);
		string cableSrc="";
		if (!emptyDataset(dat1))
		{
			cableSrc="cabledTo="+dat1.Tables[0].Rows[0]["rackspaceId"].ToString()+"";
			sql2="SELECT bc FROM "+dcPrefix+"bladeChassis WHERE ethernetType='copperPassThru'";
			dat2=readDb(sql2);
			foreach (DataTable dt in dat2.Tables)
			{
				foreach (DataRow dr in dt.Rows)
				{
					if (v_srcBc==dr["bc"].ToString())
					{
						string list="";
						foreach (DataTable dtt in dat1.Tables)
						{
							foreach (DataRow drr in dtt.Rows)
							{
								list=list+drr["rackspaceId"].ToString()+",";
							}
						}
						cableSrc="cabledTo IN("+list+"00)";
					}
					
				}
			}
		}
		string indicateBc="";
		if (v_srcBc!="")
		{
			indicateBc="BC"+v_srcBc;
		}
		sqlSwitch="SELECT switchName FROM "+dcPrefix+"switches";
		datSwitch=readDb(sqlSwitch);
		if (datSwitch!=null)
		{
			
			foreach (DataTable dt in datSwitch.Tables)
			{
				foreach (DataRow dr in dt.Rows)
				{
					sql2="SELECT * FROM "+dr["switchName"].ToString()+" WHERE "+cableSrc;
//					Response.Write(sql2);
					dat2=readDb(sql2);
					if (!emptyDataset(dat2))
					{
						portsFound=true;
						bool fill;
						HtmlTableRow tr;
						HtmlTableCell td;
						fill=false;
						tr = new HtmlTableRow();    //Output <TR>
							tr.Attributes.Add("class","blackheading");
							td = new HtmlTableCell(); //Output <TD>
								td.Attributes.Add("colspan","3");
								td.InnerHtml = dr["switchName"].ToString()+" - "+indicateBc;
							tr.Cells.Add(td);         //Output </TD>
						cableMap1.Rows.Add(tr);           //Output </TR>
						tr = new HtmlTableRow();    //Output <TR>
							tr.Attributes.Add("class","tableheading");
							td = new HtmlTableCell(); //Output <TD>
								td.InnerHtml = "Desc";
							td.Attributes.Add("style","width:10em;");
							tr.Cells.Add(td);         //Output </TD>
							td = new HtmlTableCell(); //Output <TD>
								td.InnerHtml = "Slot";
								td.Attributes.Add("style","width:5em;");
							tr.Cells.Add(td);         //Output </TD>
							td = new HtmlTableCell(); //Output <TD>
								td.InnerHtml = "Port";
								td.Attributes.Add("style","width:5em;");
							tr.Cells.Add(td);         //Output </TD>
						cableMap1.Rows.Add(tr);           //Output </TR>
						foreach (DataTable dtt in dat2.Tables)
						{
							foreach (DataRow drr in dtt.Rows)
							{
								tr = new HtmlTableRow();    //Output <TR>
									if (fill) tr.Attributes.Add("class","altrow smaller");
									td = new HtmlTableCell(); //Output <TD>
										td.InnerHtml=""+drr["comment"].ToString()+"";
									tr.Cells.Add(td);         //Output </TD>
								td = new HtmlTableCell(); //Output <TD>
										td.InnerHtml=""+drr["slot"].ToString()+"";
										td.Attributes.Add("class","center smaller");
									tr.Cells.Add(td);         //Output </TD>
									td = new HtmlTableCell(); //Output <TD>
										td.InnerHtml=""+drr["portNum"].ToString()+"";
										td.Attributes.Add("class","center smaller");
									tr.Cells.Add(td);         //Output </TD>
								cableMap1.Rows.Add(tr);           //Output </TR>
								fill=!fill;
							}
						} 
					}					
				}
			}
		}		
		if (!portsFound)
		{
			bool fill;
			HtmlTableRow tr;
			HtmlTableCell td;
			
			tr = new HtmlTableRow();    //Output <TR>
				tr.Attributes.Add("class","blackheading");
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml = indicateBc;
				tr.Cells.Add(td);         //Output </TD>
			cableMap1.Rows.Add(tr);           //Output </TR>
			tr = new HtmlTableRow();    //Output <TR>
				td = new HtmlTableCell(); //Output <TD>
					td.InnerHtml = "No Network Cabling on File!";
					td.Attributes.Add("class","center errorBox");
					td.Attributes.Add("style","width:90px");
				tr.Cells.Add(td);         //Output </TD>
			cableMap1.Rows.Add(tr);           //Output </TR>
		} 
	}



	if (IsPostBack)
	{
		formPubIp.Style ["background"]="White";

		errmsg.InnerHtml = "";
		string v_pubIp = fix_txt(formPubIp.Value);
		bool sqlSuccess=false;

		sql1 = "SELECT * FROM "+dcPrefix+"servers WHERE serverLanIp='" +v_pubIp+ "'";
		dat1=readDb(sql1);

		if (emptyDataset(dat1))
		{
			if (v_pubIp!="")
			{	
				sql = "UPDATE "+dcPrefix+"servers SET serverLanIp='"+v_pubIp+"' WHERE serverName='"+srcHost+"'";
				sqlErr=writeDb(sql);
				if (sqlErr==null || sqlErr=="")
				{
					errmsg.InnerHtml = "Server Record Updated.";
					sqlSuccess=true;
				}
				else
				{
					errmsg.InnerHtml = "SQL Update Error - Server: "+sqlErr;
					sqlErr="";
				}
				string comment=fix_txt(formComment.Value);
	 			if (sqlSuccess) 
				{
					sqlErr=writeChangeLog(dateStamp.ToString(), Decrypt(v_username.ToString()), sql2txt(sql).ToString());
					if (sqlErr==null || sqlErr=="")
					{
						try
						{
//							//  sendIpProvisionNotice(srcHost, comment, v_username);
						}
						catch (System.Exception ex)
						{
							sendSuccess=false;
							errstr=ex.ToString();
						}
						if (sendSuccess)
						{
							sqlErr=writeChangeLog(dateStamp.ToString(), Decrypt(v_username.ToString()), "IP Address Assignment Notice Sent:"+v_pubIp);
							if (sqlErr!=null || sqlErr!="")
							{
								errmsg.InnerHtml=sqlErr;
								sqlErr="";
							}
						}
						try
						{
//							//  sendDNSNotice(srcHost, comment, v_username);
						}
						catch (System.Exception ex)
						{
							sendSuccess=false;
							errstr=ex.ToString();
						}
						if (sendSuccess)
						{
							sqlErr=writeChangeLog(dateStamp.ToString(), Decrypt(v_username.ToString()), "DNS Registration Notice Sent: "+srcHost+","+comment);
							if (sqlErr!=null || sqlErr!="")
							{
								errmsg.InnerHtml=sqlErr;
								sqlErr="";
							}
						}
						try
						{
//							//  sendOSInstallNotice(srcHost, comment, v_username);
						}
						catch (System.Exception ex)
						{
							sendSuccess=false;
							errstr=ex.ToString();
						}
						if (sendSuccess)
						{
							sqlErr=writeChangeLog(dateStamp.ToString(), Decrypt(v_username.ToString()), "OS Install Notice Sent: "+srcHost+","+comment);
							if (sqlErr!=null || sqlErr!="")
							{
								errmsg.InnerHtml=sqlErr;
								sqlErr="";
							}
							if (sqlErr==null || sqlErr=="")
							{
								Response.Write("<script>refreshParent("+");<"+"/script>");
							}
							else
							{
								errmsg.InnerHtml = "WARNING: "+sqlErr;
							}
						}
					errmsg.InnerHtml=errstr;
					}
				}
			}
			else 
			{
				if (v_pubIp == "") formPubIp.Style ["background"]="yellow";
				string errStr = "Please enter valid data in all required fields!";
				errmsg.InnerHtml = errStr;
			}	
		}
		else
		{
			errmsg.InnerHtml = "Duplicate Record Found!";
			formPubIp.Style ["background"]="yellow";
		}

	} //if IsPostBack */
	titleSpan.InnerHtml="Assign IP";
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
				<DIV id='hostname' class='bold' runat='server'/>
				<BR/>
				<TABLE border='1' class='datatable center'>
				<TR>
					<TD class='center'>
						<TABLE>
							<TR>
								<TD class='inputform'>
									<SPAN class='bold'>Public IP:&#xa0;</SPAN>
								</TD>
								<TD class='whiteRowFill'>
									<SELECT id='formPubIp' runat='server'></SELECT>
								</TD>
							</TR>
							<TR>
								<TD class='inputform'>
									<SPAN class='bold'>Comment:&#xa0;</SPAN>
								</TD>
								<TD class='whiteRowFill'>
									<TEXTAREA rows='5' cols='20' id='formComment' runat='server' />
								</TD>
							</TR>
							<TR>
								<TD class='inputform'>&#xa0;</TD>
								<TD class='whiteRowFill'>&#xa0;</TD>
							</TR>
							<TR>
								<TD class='inputform'>&#xa0;</TD>
								<TD class='whiteRowFill center'>
									<TABLE id='cableMap1' class='datatable' runat='server'></TABLE>
									<BR/>
									<TABLE id='cableMap2' class='datatable' runat='server'></TABLE>
								</TD>
							</TR>
							<TR>
								<TD class='inputform'>&#xa0;</TD>
								<TD class='whiteRowFill'>&#xa0;</TD>
							</TR>
						</TABLE>
					</TD>
				</TR>
			</TABLE>
			<BR/>
			<INPUT type='submit' value='Save Changes' runat='server'/>&#xa0;<INPUT type='button' value='Cancel &amp; Close' onclick='refreshParent()'/>
			</DIV>
			</FORM>
			&nbsp;<BR/>
		</DIV>
	</DIV> <!-- End: popContent -->
<!--#include file='popup_closer.inc' -->
</DIV> <!-- End: container -->
</BODY>
</HTML>