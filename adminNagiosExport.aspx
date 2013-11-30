<%@Page Inherits="CIS.conspectisLibrary" src="conspectisLibrary.cs" Language="C#" debug="true" %>
<%@Import Namespace="System.Data"%>
<%@Import Namespace="System.IO"%>
<%@Import Namespace="System"%>
<%@Import Namespace="System.Text.RegularExpressions"%>

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

public string fixRole(string x)
{
	string good_string;
	good_string = x.Trim();
	good_string = good_string.Replace("0", "");
	good_string = good_string.Replace("1", "");
	good_string = good_string.Replace("2", "");
	good_string = good_string.Replace("3", "");
	good_string = good_string.Replace("4", "");
	good_string = good_string.Replace("5", "");
	good_string = good_string.Replace("6", "");
	good_string = good_string.Replace("7", "");
	good_string = good_string.Replace("8", "");
	good_string = good_string.Replace("9", "");
	return (good_string); 
}

public string fixBc(string x)
{
	string good_string;
	good_string = x.Trim();
	good_string = good_string.Replace("01", "1");
	good_string = good_string.Replace("02", "2");
	good_string = good_string.Replace("03", "3");
	good_string = good_string.Replace("04", "4");
	good_string = good_string.Replace("05", "5");
	good_string = good_string.Replace("06", "6");
	good_string = good_string.Replace("07", "7");
	good_string = good_string.Replace("08", "8");
	good_string = good_string.Replace("09", "9");
	return (good_string); 
}
public void Page_Load(Object o, EventArgs e)
{
//UNCOMMENT this line to force login to access this page.
	lockout(); Page.Header.Title=shortSysName+": Export to Nagios (Build a Nagios Configuration Set)";
	systemStatus(0); // Check to see if admin has put system is in offline mode.

//START Check if user is logged in by checking existence of cookie.
	loggedin.InnerHtml=loggedIn();
	adminMenu.InnerHtml=isAdmin();

	DateTime dateStamp = DateTime.Now;
	string v_username, curStat="", roleString="", curHostname="", clusterFlag="", serviceString="", imageString="", statusString="", check1="", check2="", check3="";
	int infraFlag=0, count=0, bcCount=0, count1=0;
	string sql="", sql1="", sql2="", status="", sqlErr="";
	DataSet dat, dat1, dat2;

	try
	{
		v_username=Request.Cookies["username"].Value;
	}
	catch (System.Exception ex)
	{
		v_username="";
	}

	titleSpan.InnerHtml="<SPAN class='heading1'>Nagios Host File Export</SPAN>";

	sql="SELECT serverName, serverPurpose, serverLanIp, serverOsBuild, role, infra, memberOfCluster, bc, slot FROM servers LEFT JOIN rackspace ON servers.rackspaceId=rackspace.rackspaceId WHERE role='' OR role IS NULL ORDER BY serverName ASC";
	dat=readDb(sql);

	if (!emptyDataset(dat))
	{
		string hostType, hostEnv, hostRole, exportFile, nagiosRole, managedSwBcs="";

		sql1="SELECT DISTINCT(bc) FROM bladeChassis WHERE ethernetType='managedSwitch'";
		dat1=readDb(sql1);
		bcCount=0;
		foreach (DataTable dt in dat1.Tables)
		{
			foreach (DataRow dr in dt.Rows)
			{
				if (bcCount>0)
				{
					managedSwBcs=managedSwBcs+",";
				}
				managedSwBcs=managedSwBcs+dr["bc"].ToString();
				bcCount++;
			}
		}
//		Response.Write(managedSwBcs);

		StreamWriter SW;
		exportFile="hosts"+dateStamp.Year.ToString()+dateStamp.Month.ToString().PadLeft(2,'0')+dateStamp.Day.ToString().PadLeft(2, '0')+"_"+dateStamp.Hour.ToString()+dateStamp.Minute.ToString()+".cfg";
		SW=File.CreateText(Server.MapPath("/nagios_exp/"+exportFile));
		SW.WriteLine("###############################################################################\r\n#\r\n# Hosts configuration file\r\n#\r\n# Created by: ESMS for Nagios Ver 3.x\r\n# Date:       "+dateStamp+"\r\n#\r\n#\r\n###############################################################################\r\n\r\n");

		foreach (DataTable dt in dat.Tables)
		{
			foreach (DataRow dr in dt.Rows)
			{
				roleString="";
				check1="";
				check2="";
				check3="";
				curHostname=dr["serverName"].ToString();
				infraFlag=Convert.ToInt32(dr["infra"].ToString());
				clusterFlag=dr["memberOfCluster"].ToString();

				try
				{
					hostType=curHostname.Substring(0,2);	
				}
				catch (System.Exception ex)
				{
					hostType="";
				}
				
				try
				{
					hostEnv=curHostname.Substring(2,3);
				}
				catch (System.Exception ex)
				{
					hostEnv="";
				}
				
				try
				{
					hostRole=fixRole(curHostname.Substring(5,5));
				}
				catch (System.Exception ex)
				{
					hostRole="";
				}

				switch (hostType)
				{
				case "BC":
				case "RS":
						roleString=roleString+"mgt-";
						imageString="ibm";
						check1="define service{\r\n	use			generic-service\r\n	host_name		"+curHostname+"\r\n	service_description	Web Interface \r\n	check_command		check_http!-p 80\r\n	}\r\n";
					break;
				case "NS":
						roleString=roleString+"mgt-";
						imageString="cisco";
						check1="define service{\r\n	use			generic-service\r\n	host_name		"+curHostname+"\r\n	service_description	PuTTY SSH Check\r\n	check_command		check_ssh!-t 10 -p 22\r\n	}\r\n";
					break;
				case "SL":
				case "SB":
						roleString=roleString+"server-";
						imageString="linux";
						check1="define service{\r\n	use			generic-service\r\n	host_name		"+curHostname+"\r\n	service_description	PuTTY SSH Check\r\n	check_command		check_ssh!-t 10 -p 22\r\n	}\r\n";
					break;
				case "SX":
						roleString=roleString+"server-";
						imageString="windows-server";
						check1="define service{\r\n	use			generic-service\r\n	host_name		"+curHostname+"\r\n	service_description	RDP Check\r\n	check_command		check_x224\r\n	}\r\n";
					break;
				case "SV":
						roleString=roleString+"server-";
						imageString="aix";
						check1="define service{\r\n	use			generic-service\r\n	host_name		"+curHostname+"\r\n	service_description	PuTTY SSH Check\r\n	check_command		check_ssh!-t 10 -p 22\r\n	}\r\n";
					break;
				case "PC":
						roleString=roleString+"server-";
						imageString="windows-server";
						check1="define service{\r\n	use			generic-service\r\n	host_name		"+curHostname+"\r\n	service_description	RDP Check\r\n	check_command		check_x224\r\n	}\r\n";
					break;
				case "LT":
						roleString=roleString+"server-";
						imageString="windows-server";
						check1="define service{\r\n	use			generic-service\r\n	host_name		"+curHostname+"\r\n	service_description	RDP Check\r\n	check_command		check_x224\r\n	}\r\n";
					break;
				default :
						roleString=roleString+"";
					break;
				}

				
				switch (hostEnv)
				{
				case "PRP" : 
					roleString=roleString+"prp-";
					break;
				case "PHE" : 
					roleString=roleString+"phe-";
					break;
				default :
					roleString=roleString+"abqdc-";
					break;
				}

				if (hostEnv.StartsWith("QA"))
				{
					roleString=roleString+"qa-";
				}


				switch (hostType)
				{
				case "BC":
				case "RS":
						roleString=roleString+"rsa-";
					break;
				case "SL":
						roleString=roleString+"linux-";
					break;
				case "SX":
						roleString=roleString+"windows-";
					break;
				case "SV":
						roleString=roleString+"aix-";
					break;
				case "SB":
						roleString=roleString+"esx-";
					break;
				case "CL":
				case "VS":
						roleString=roleString+"vip-";
					break;
				case "LB":
						roleString=roleString+"loadbalancer-";
					break;
				case "NS":
						roleString=roleString+"switch-";
					break;
				case "PC":
						roleString=roleString+"desktop-";
					break;
				case "LT":
						roleString=roleString+"laptop-";
					break;
				default :
						roleString=roleString+"";
					break;
				}


				switch (hostRole)
				{
				case "ORDB" : 
						roleString=roleString+"oracle-ordb";
						check2="define service{\r\n	use			generic-service\r\n	host_name		"+curHostname+"\r\n	service_description	Web Interface \r\n	check_command		check_tcp!-p 1521\r\n	}\r\n";
					break;
				case "ORAS" : 
				case "ORGC" : 
						roleString=roleString+"oracle-oras";
					break;
				case "ORINF" : 
						roleString=roleString+"oracle-orinf";
					break;
				case "SDE" : 
						roleString=roleString+"arcsde";
					break;
				case "GIS" : 
						roleString=roleString+"arcgis";
					break;
				case "APH" :  
				case "IIS" : 
				case "WEB" :
						roleString=roleString+"webserver";
						check2="define service{\r\n	use			generic-service\r\n	host_name		"+curHostname+"\r\n	service_description	Web Interface \r\n	check_command		check_http!-p 80\r\n	}\r\n";
						check3="define service{\r\n	use			generic-service\r\n	host_name		"+curHostname+"\r\n	service_description	Web Interface \r\n	check_command		check_http!-p 8080\r\n	}\r\n";
					break;
				case "SQL" : 
						roleString=roleString+"sql";
					break;
				case "IDS" : 
						roleString=roleString+"director";
					break;
				case "OSD" :
				case "TPM" :
				case "TGW" : 
				case "TEC" : 
				case "TMR" : 
				case "TMS" : 
				case "TEP" : 
						roleString=roleString+"tivoli";
					break;
				case "TSM" : 
						roleString=roleString+"tsm";
					break;
				case "VCS" : 
						roleString=roleString+"vcs";
					break;
				case "CTX" : 
						roleString=roleString+"citrix";
						imageString="citrix";
					break;
				case "OPN" : 
						roleString=roleString+"opnet";
					break;
				case "DFS" : 
						roleString=roleString+"dfs";
					break;
				case "GPFS" : 
						roleString=roleString+"gpfs";
					break;
				case "ADS" : 
				case "PKI" :
						roleString=roleString+"ads";
					break;
				case "KDC" : 
						roleString=roleString+"kdc";
					break;
				case "DNS" : 
						roleString=roleString+"dns";
					break;
				case "PRX" : 
						roleString=roleString+"proxy";
					break;
				case "ILM" : 
				case "MIIS" :
						roleString=roleString+"miis";
					break;
				case "BES" :
				case "BBR" :
						roleString=roleString+"blackberry";
					break;
				case "EFM" :
				case "EFRM" :
						roleString=roleString+"eforms";
					break;
				case "CMDB" :
				case "CCMDB" :
						roleString=roleString+"ccmdb";
					break;
				case "BNF" :
				case "BFCC" :
						roleString=roleString+"bfcc";
					break;
				case "OMS" :
				case "RMS" :
				case "ACS" :
				case "RPT" :
						roleString=roleString+"opsmgr";
					break;
				case "PRT" :
						roleString=roleString+"eps";
					break;
				case "SPM" :
				case "SLU" :
				case "SRS" :
						roleString=roleString+"sepm";
					break;
				case "IBS" :
				case "WBM" :
						roleString=roleString+"ibs";
					break;
				case "SPP" :
						roleString=roleString+"ondemand";
					break;
				case "ESX" :
						roleString=roleString+"esxhost";
					break;
				case "VM" :
				case "XP" :
						roleString=roleString+"esxvm";
					break;
				case "BC" :
				case "BCM" :
						roleString=roleString+"bladechassis";
					break;
				default :
						roleString=roleString+"misc";
					break;
				}


				switch (clusterFlag)
				{
				case "VMWare-PHE" : 
					roleString=roleString+"-phevmw";
					break;
				case "VMWare-Engineering" : 
					roleString=roleString+"-engvmw";
					break;
				case "OnDemand-PHE" : 
					roleString=roleString+"-pheodnd";
					break;
				default :
					roleString=roleString+"";
					break;
				}

				sql2="SELECT sfwName FROM software WHERE sfwId="+dr["serverOsBuild"].ToString();
				dat2=readDb(sql2);
				if (!emptyDataset(dat2))
				{
					if (Regex.IsMatch(dat2.Tables[0].Rows[0]["sfwName"].ToString(), "SUSE"))
					{
						imageString="suse";
					}
					if (Regex.IsMatch(dat2.Tables[0].Rows[0]["sfwName"].ToString(), "RHEL"))
					{
						imageString="redhat";
					}
				}


				dr["role"]=roleString;

				sql="UPDATE servers SET role='"+roleString+"' WHERE serverName='"+curHostname+"'";
				sqlErr=writeDb(sql);

				
				if (!Regex.IsMatch(dr["role"].ToString(), "-vip-") && !Regex.IsMatch(dr["role"].ToString(), "-loadbalancer-"))
				{
					count++;
					SW.WriteLine("define host{");
					SW.WriteLine("	host_name			"+dr["serverName"].ToString());
					SW.WriteLine("	alias				"+dr["serverName"].ToString());
					SW.WriteLine("	address				"+fix_ip(fix_ip(fix_ip(dr["serverLanIp"].ToString()))));
					if(Regex.IsMatch(dr["role"].ToString(), "mgt-phe-rsa"))
					{
						nagiosRole="mgt-phe-rsa";
					}
					else if(Regex.IsMatch(dr["role"].ToString(), "mgt-prp-rsa"))
					{
						nagiosRole="mgt-prp-rsa";
					}
					else if(Regex.IsMatch(dr["role"].ToString(), "windows-arcgis-phevmw"))
					{
						nagiosRole="server-phe-windows-esxvm-phevmw";
					}
					else if(Regex.IsMatch(dr["role"].ToString(), "windows-misc-phevmw"))
					{
						nagiosRole="server-phe-windows-esxvm-phevmw";
					}
					else if(Regex.IsMatch(dr["role"].ToString(), "windows-misc-engvmw"))
					{
						nagiosRole="server-phe-windows-esxvm-engvmw";
					}
					else if(Regex.IsMatch(dr["role"].ToString(), "windows-misc-pheodnd"))
					{
						nagiosRole="server-phe-windows-esxvm-pheodnd";
					}
					else if(Regex.IsMatch(dr["role"].ToString(), "server-abqdc-windows"))
					{
						nagiosRole="server-abqdc-windows-misc";
					}
					else
					{
						nagiosRole=dr["role"].ToString();
					}
					if(Regex.IsMatch(managedSwBcs, dr["bc"].ToString()) && dr["slot"].ToString()!="00" && dr["bc"].ToString()!="" && dr["bc"].ToString()!=null)
					{
						SW.WriteLine("	parents				NSPHEBC"+fixBc(dr["bc"].ToString())+"001,NSPHEBC"+fixBc(dr["bc"].ToString())+"002");
					}
					SW.WriteLine("	hostgroups			"+nagiosRole);
					SW.WriteLine("	check_command		check-host-alive");
					SW.WriteLine("	max_check_attempts		3");
					SW.WriteLine("	check_period			24x7");
					SW.WriteLine("	contact_groups			admins\r\n	notification_interval		15\r\n	notification_period		24x7_sans_holidays\r\n	notification_options		d,u,r");
					SW.WriteLine("	}");
					SW.WriteLine("define hostextinfo{");
					SW.WriteLine("	host_name	"+dr["serverName"].ToString());
					SW.WriteLine("	notes		"+dr["serverPurpose"].ToString());
					SW.WriteLine("	notes_url	"+System.Configuration.ConfigurationManager.AppSettings["sysUrl"]+"showServer.aspx?host="+dr["serverName"].ToString());
					SW.WriteLine("	icon_image	"+imageString+".png");
					SW.WriteLine("	icon_image_alt	"+imageString);
					SW.WriteLine("	vrml_image	"+imageString+".png");
					SW.WriteLine("	statusmap_image	"+imageString+".gd2");
					SW.WriteLine("   	}");
					SW.WriteLine(check1+check2+check3);
				}
			}
		}
		SW.WriteLine("\r\n###############################################################################\r\n#\r\n# Hosts configuration file\r\n#\r\n# END OF FILE\r\n#\r\n###############################################################################\r\n");
	    SW.Close();
		statusString="<BR/><BR/><A HREF='"+Server.MapPath("/nagios_exp/"+exportFile)+"' class='black'>"+exportFile+"</A>";
//		statusSpan.InnerHtml="Exported "+count.ToString()+" Records to "+exportFile+".<BR/><A HREF='./nagios_exp/"+exportFile+"' class='black'>"+exportFile+"</A>";
	}
	statusString="<BR/><BR/><BR/>Exported "+count.ToString()+" Records."+statusString;
	statusSpan.InnerHtml=statusString;
	if (IsPostBack)
	{

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
			<SPAN id="statusSpan" runat="server"/>
		</DIV>
	</DIV> <!-- End: content -->
<!--#include file="closer.inc"-->
</DIV> <!-- End: container -->
</FORM>
</BODY>
</HTML>