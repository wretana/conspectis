<%@Page Inherits="CIS.conspectisLibrary" src="conspectisLibrary.cs" Language="C#" debug="true" %>
<%@Import Namespace="System.Net"%>
<%@Import Namespace="System.Data.OleDb"%>
<%@Import Namespace="System.Data"%>
<%@Import Namespace="System"%>

<!DOCTYPE html>
<!-- HTML5 Status: VALID 2-14-13 CK -->
<!--[if lt IE 7 ]> <html lang='en' class='no-js ie6'> <![endif]-->
<!--[if IE 7 ]>    <html lang='en' class='no-js ie7'> <![endif]-->
<!--[if IE 8 ]>    <html lang='en' class='no-js ie8'> <![endif]-->
<!--[if IE 9 ]>    <html lang='en' class='no-js ie9'> <![endif]-->
<!--[if (gt IE 9)|!(IE)]><!--> <html lang='en' class='no-js'> <!--<![endif]-->

<HEAD runat="server">

<!--#include file="header.inc"-->

<SCRIPT runat="server">
public static Int32 SubnetMaskToCIDR(string subnetStr)
{
	int retVal=0;
	try
	{
		IPAddress subnetAddress = IPAddress.Parse(subnetStr);
		byte[] ipParts = subnetAddress.GetAddressBytes();
		UInt32 subnet = 16777216 * Convert.ToUInt32(ipParts[0]) + 65536 * Convert.ToUInt32(ipParts[1]) + 256 *	Convert.ToUInt32(ipParts[2]) + Convert.ToUInt32(ipParts[3]);
		UInt32 mask = 0x80000000;
		UInt32 subnetConsecutiveOnes = 0;
		for (int i = 0; i < 32; i++)
		{
			if (!(mask & subnet).Equals(mask)) break;
			subnetConsecutiveOnes++;
			mask = mask >> 1;
		}
		retVal=Convert.ToInt32(subnetConsecutiveOnes);
	}
	catch (System.Exception ex)
	{
		retVal=0;
	}
	return retVal;
}

public static int NthIndexOf(string s, string match, int occurence)
{
    int i = 1;
    int index = 0;
    while (i <= occurence && (index = s.IndexOf(match, index + 1)) != -1)
    {
        if (i == occurence)
            return index;
        i++;
    }
    return -1;
}

public static string FirstUsableIp(string ipSubnet, int cidr)
{
	string retStr="";
	try
	{
//		IPAddress ip = new IPAddress(new byte[] { 192, 168, 0, 1 });
		IPAddress ip = IPAddress.Parse(ipSubnet);
		int bits = cidr;
		uint mask = ~(uint.MaxValue >> bits);

		// Convert the IP address to bytes.
		byte[] ipBytes = ip.GetAddressBytes();

		// BitConverter gives bytes in opposite order to GetAddressBytes().
		byte[] maskBytes = BitConverter.GetBytes(mask).Reverse().ToArray();
		byte[] startIPBytes = new byte[ipBytes.Length];

		// Calculate the bytes of the start and end IP addresses.
		for (int i = 0; i < ipBytes.Length; i++)
		{
			startIPBytes[i] = (byte)(ipBytes[i] & maskBytes[i]);
		}

		// Convert the bytes to IP addresses.
		IPAddress startIP = new IPAddress(startIPBytes);
		retStr=startIP.ToString();
	}
	catch (System.Exception ex)
	{
		retStr="ERR: "+ex.ToString();
	}
	return retStr;
}

public static string LastUsableIp(string ipSubnet, int cidr)
{
	string retStr="";
	try
	{
//		IPAddress ip = new IPAddress(new byte[] { 192, 168, 0, 1 });
		IPAddress ip = IPAddress.Parse(ipSubnet);
		int bits = cidr;
		uint mask = ~(uint.MaxValue >> bits);

		// Convert the IP address to bytes.
		byte[] ipBytes = ip.GetAddressBytes();

		// BitConverter gives bytes in opposite order to GetAddressBytes().
		byte[] maskBytes = BitConverter.GetBytes(mask).Reverse().ToArray();
		byte[] endIPBytes = new byte[ipBytes.Length];

		// Calculate the bytes of the start and end IP addresses.
		for (int i = 0; i < ipBytes.Length; i++)
		{
			endIPBytes[i] = (byte)(ipBytes[i] | ~maskBytes[i]);
		}

		// Convert the bytes to IP addresses.
		IPAddress endIP = new IPAddress(endIPBytes);
		retStr=endIP.ToString();		
	}
	catch (System.Exception ex)
	{
		retStr="ERR: "+ex.ToString();
	}
	return retStr;
}

public void Page_Load(Object o, EventArgs e)
{
//UNCOMMENT this line to force login to access this page.
	lockout(); 
	Page.Header.Title=shortSysName+": Add New Subnet";
	systemStatus(1); // Check to see if admin has put system is in offline mode.

	string sql="", sqlErr="", logErr="";
	DataSet dat=new DataSet();
	HttpCookie cookie;
	bool sqlSuccess=true;
	string access="", port="", dcPrefix="", sqlTablePrefix="";
	int tagInt;
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

	try
	{
		dcPrefix=Request.QueryString["dcArg"].ToString();
	}
	catch (System.Exception ex)
	{
		dcPrefix = "";
	}

	if (dcPrefix!="*")
	{
		sqlTablePrefix=dcPrefix;
	}
	else
	{
		sqlTablePrefix="";
	}

	formVlanTag.Style["background"]="white";
	formSubnet.Style["background"]="white";
	formNet.Style["background"]="white";	
	formCIDR.Style["background"]="white";
	
/*	datacenterDropDown.Disabled=false;
	if (!IsPostBack)
	{
		sql="SELECT * FROM datacenters ORDER BY dcDesc ASC";
		dat=readDb(sql);
		string optionDesc="", optionVal="";
		if (!emptyDataset(dat))
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
				lfind = datacenterDropDown.Items.FindByValue(dr["dcPrefix"].ToString());
				if (lfind==null)
				{
					ListItem ladd = new ListItem(optionDesc, optionVal);
					datacenterDropDown.Items.Add(ladd);
				}
			}	
		}
		formVlanTag.Value="ex: 999";
		formSubnet.Value="ex: 192.168.1.0";
	}
	if (sqlTablePrefix!="")
	{
		datacenterDropDown.SelectedIndex=datacenterDropDown.Items.IndexOf(datacenterDropDown.Items.FindByValue(sqlTablePrefix)); 
		datacenterDropDown.Disabled=true;
	}*/

	if (IsPostBack)
	{
		string subnetTag="", subnetDesc="", subnetRange="", subnetNetwork="", curIpStr="", errStr="", afterDot="", goodRange="", fullIp="", tableName="", curWord="", resvStat="", selectedDc="";
		string[] descWords;
		bool goodInput=true;
		int count=0, ipSpot=0, cidrVal=0;

/*		selectedDc=dcPrefix;

		if (selectedDc=="")
		{
			goodInput=false;
			errStr = errStr+"Choose a subnet!<BR/>";
			datacenterDropDown.Style	["background"]="yellow";
		} */

		Response.Write(selectedDc+"<BR/>");
		
		if (formSubnetDesc.Value!="")
		{
			subnetDesc=fix_txt(formSubnetDesc.Value);
			if (subnetDesc.Length>13)
			{
				descWords=subnetDesc.Substring(0,13).Split(new Char[] {' ','.',',','(',')'});
			}
			else
			{
				descWords=subnetDesc.Substring(0,subnetDesc.Length).Split(new Char[] {' ','.',',','(',')'});
			}
		
			foreach (string word in descWords)
			{
				curWord=word.ToLower();
				if (curWord.Length>=1)
				{
					curWord=curWord.Substring(0,1).ToUpper()+curWord.Substring(1,curWord.Length-1);
				}
				tableName=tableName+curWord;
			}
			tableName=fix_access(tableName);
			tableName=fix_txt(tableName);
			tableName=tableName.Replace(" ", "");
		}
		else
		{
			goodInput=false;
			errStr = errStr+"A Subnet Description is REQUIRED!<BR/>";
			formSubnetDesc.Style	["background"]="yellow";
		}

		if (formVlanTag.Value.Contains("ex:"))
		{
			goodInput=false;
			errStr = errStr+"Invalid VLAN Tag!<BR/>";
			formVlanTag.Style	["background"]="yellow";
		}
		else
		{
			subnetTag=formVlanTag.Value;
		}

		if (formNet.Value.Contains("ex:"))
		{
			goodInput=false;
			errStr = errStr+"Invalid Network!<BR/>";
			formNet.Style	["background"]="yellow";
		}
		else
		{
			try
			{
				IPAddress checkIp = IPAddress.Parse(formNet.Value.Trim());
				subnetNetwork=checkIp.ToString();
			}
			catch (System.Exception ex)
			{
				goodInput=false;
				errStr = errStr+"Invalid Network Address!<BR/>";
				formNet.Style	["background"]="yellow";
			}
		}

		try
		{
			cidrVal=Convert.ToInt32(formCIDR.Value);
		}
		catch (System.Exception ex)
		{
			try
			{
				cidrVal=SubnetMaskToCIDR(formSubnet.Value.Trim());
			}
			catch (System.Exception ex2)
			{
				goodInput=false;
				errStr = errStr+"Invalid CIDR / Subnet Mask!<BR/>";
				formCIDR.Style["background"]="yellow";
				formSubnet.Style["background"]="yellow";
			}
		}

		if (formSubnet.Value.Contains("ex:"))
		{
			goodInput=false;
			errStr = errStr+"Invalid Subnet Mask!<BR/>";
			formSubnet.Style["background"]="yellow";
		}
		else
		{
			if (formSubnet.Value!="")
			{
				try
				{
					IPAddress checkIp = IPAddress.Parse(formSubnet.Value.Trim());
					subnetRange=checkIp.ToString();
				}
				catch (System.Exception ex)
				{
					goodInput=false;
					errStr = errStr+"Invalid Subnet Mask Address!<BR/>";
					formSubnet.Style["background"]="yellow";
				}
			}
		}

		if (formSubnet.Value!="" && !formSubnet.Value.Contains("ex:"))
		{
			if (cidrVal!=SubnetMaskToCIDR(formSubnet.Value.Trim()))
			{
				goodInput=false;
				errStr = errStr+"CIDR to Subnet Mismatch!<BR/>";
				formCIDR.Style["background"]="yellow";
				formSubnet.Style["background"]="yellow";
			}
		}

		if ((cidrVal<24) || (cidrVal>30))
		{
			goodInput=false;
			errStr = errStr+"Empty or Invalid Class-C Subnet!<BR/>";
			formCIDR.Style["background"]="yellow";
			formSubnet.Style["background"]="yellow";
		}


		int startIp=0;
		string startIpStr=FirstUsableIp(subnetNetwork,cidrVal).ToString();
		startIpStr=startIpStr.Substring(startIpStr.LastIndexOf(".")+1,startIpStr.Length-startIpStr.LastIndexOf(".")-1);
		startIp=Convert.ToInt32(startIpStr)+1;

		int ipLimit=0;
		string ipLimitStr=LastUsableIp(subnetNetwork,cidrVal).ToString();
		ipLimitStr=ipLimitStr.Substring(ipLimitStr.LastIndexOf(".")+1,ipLimitStr.Length-ipLimitStr.LastIndexOf(".")-1);
		ipLimit=Convert.ToInt32(ipLimitStr);

		errmsg.InnerHtml=errStr;

		if (goodInput)
		{
			errStr="";
			count=startIp;
			goodRange=subnetNetwork.Substring(0,subnetNetwork.LastIndexOf(".")+1);
			sql="SELECT * FROM "+selectedDc+"subnet"+tableName;
			dat=readDb(sql);
			if (emptyDataset(dat))
			{
				sql="CREATE TABLE ["+selectedDc+"subnet"+tableName+"] (ipAddr nvarchar PRIMARY KEY, reserved integer, comment nvarchar, pingStatus single DEFAULT 0, dnsStatus single DEFAULT 0)";
				sqlErr=writeDb(sql);
				if (sqlErr=="")
				{
					int resvLimit=ipLimit-startIp;
					resvLimit=Convert.ToInt32(Math.Round(resvLimit*.06))+startIp-1;
					while (count<ipLimit)
					{
						curIpStr=count.ToString();
						if (curIpStr.Length<3)
						{
							if (curIpStr.Length==1)
							{
								curIpStr="00"+curIpStr;
							}
							if (curIpStr.Length==2)
							{
								curIpStr="0"+curIpStr;
							}
						}
						if (count<=resvLimit)
						{
							resvStat="1";
						}
						else
						{
							resvStat="0";
						}
						fullIp=goodRange+curIpStr;
						sql="INSERT INTO ["+selectedDc+"subnet"+tableName+"](ipAddr, reserved) VALUES ('"+fullIp+"',"+resvStat+")";
//						Response.Write(sql+"<BR/>");
						sqlErr=writeDb(sql);
						if (sqlErr!="")
						{
							errStr=errStr+"Failed to Add row '"+fullIp+"' to table 'subnet"+tableName+"': "+sqlErr;
							errmsg.InnerHtml=errStr;
						}
						count++;
					}
					if (sqlErr=="")
					{
						sql="INSERT INTO "+selectedDc+"subnets VALUES ('subnet"+tableName+"','"+subnetDesc+"','"+subnetTag+"')";
//						Response.Write(sql+"<BR/>");
						sqlErr=writeDb(sql);
						if (sqlErr=="")
						{
							logErr=writeChangeLog(dateStamp.ToString(), Decrypt(v_username.ToString()), "Subnet 'subnet"+tableName+"' created.");
							if (logErr=="")
							{
//								Response.Write("<script>refreshParent("+");<"+"/script>");
							}
							else
							{
								errStr=errStr+"Couldn't write to changelog: "+logErr;
								errmsg.InnerHtml=errStr;								
							}
//							Response.Write("<script>refreshParent("+");<"+"/script>");
						}
						else
						{
							errStr=errStr+"Failed to Add row 'subnet"+tableName+"' to subnets table: "+sqlErr+"<BR/><BR/>"+sql;
							errmsg.InnerHtml=errStr;							
						}
					}
				}
				else
				{
					errStr=errStr+"Failed to create table 'subnet"+tableName+"': "+sqlErr;
					errmsg.InnerHtml=errStr;
				}
			}
			else
			{
				errStr=errStr+"Table '"+tableName+"' Already Exists!";
				errmsg.InnerHtml=errStr;
			}
		}
	}

	if (!IsPostBack)
	{
		formVlanTag.Value="ex: 999";
		formVlanTag.Style["background"]="white";
		formNet.Value="ex: 192.168.1.0";
		formNet.Style["background"]="white";
		formCIDR.Value="24";
		formCIDR.Style["background"]="white";
		formSubnet.Value="ex: 255.255.255.0";
		formSubnet.Style["background"]="white";
	}
	titleSpan.InnerHtml="New Subnet";
}
</SCRIPT>
</HEAD>
<!--#include file="body.inc" -->
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
								<TR><TD class='inputform'>&#xa0;</TD><TD class='whiteRowFill left'>&#xa0;</TD></TR>
								<TR>
									<TD class='inputform'>VLAN Tag</TD>
									<TD class='whiteRowFill left'>
										<INPUT type='text' id='formVlanTag' size='7' maxlength='5' runat='server'/>
									</TD>
								</TR>
								<TR>
									<TD class='inputform'>Network + CIDR</TD>
									<TD class='whiteRowFill left'>
										<INPUT type='text' id='formNet' size='18' maxlength='15' runat='server'/>&#xa0;/&#xa0;
										<INPUT type='text' id='formCIDR' size='3' maxlength='2' runat='server'/>
									</TD>
								</TR>
								<TR>
									<TD class='inputform'> -or- </TD>
									<TD class='whiteRowFill left'>&#xa0;</TD>
								</TR>
								<TR>
									<TD class='inputform'>Subnet Mask<BR/></TD>
									<TD class='whiteRowFill left'>
										<INPUT type='text' id='formSubnet' size='18' maxlength='15' runat='server'/>
									</TD>
								</TR>
								<TR>
									<TD class='inputform'>Subnet Description</TD>
									<TD class='whiteRowFill left'>
										<INPUT type='text' id='formSubnetDesc' size='35' runat='server'/>
									</TD>
								</TR>
								<TR><TD class='inputform'>&#xa0;</TD><TD class='whiteRowFill left'>&#xa0;</TD></TR> 
							</TABLE>
						</TD>
					</TR>
				</TABLE>
				<BR/>
				<INPUT type='submit' value='Create' runat='server'/>&#xa0;<INPUT type='button' value='Cancel &amp; Close' onclick='refreshParent()'>
			</DIV>
		&nbsp;<BR/>
		</DIV>
	</DIV> <!-- End: popContent -->
<!--#include file='popup_closer.inc' -->
	</FORM>
</DIV> <!-- End: container -->
</BODY>
</HTML>