<%@Page Inherits="CIS.conspectisLibrary" src="conspectisLibrary.cs" Language="C#" debug="true" %>
<%@Import Namespace="System.Data"%>
<%@Import Namespace="System.Xml"%>
<%@Import Namespace="System.Net"%>
<%@Import Namespace="System.IO"%>
<%@Import Namespace="System"%>

<!DOCTYPE html>
<!-- HTML5 STatus:  -->
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
}

public DataSet XMLtoDataSet(XmlDocument xmlDoc)
{
	XmlNodeReader reader = new XmlNodeReader(xmlDoc);
	DataSet dat=new DataSet();
	dat.ReadXml(reader);
	reader.Close();

	return dat;
}

public XmlDocument taddmGetXMLfromREST(string queryString, string queryOptions)
{
	string restUri="http://170.144.140.19:9430/rest/model/MQLQuery?";

	if (queryString.Contains(" "))
	{
		queryString=queryString.Replace(" ","%20");
	}
	string requestUrl=restUri+"query="+queryString+"&"+queryOptions;

    XmlDocument xmlDoc = new XmlDocument();
	xmlDoc.PreserveWhitespace=true;

    try
    {
        HttpWebRequest request = WebRequest.Create(requestUrl) as HttpWebRequest;
//		request.Credentials = new NetworkCredential(bindDN,bindPWD); //
		request.Credentials = new NetworkCredential("phe.ad.chrisknight","Oldspeed0113");
		request.Method = WebRequestMethods.Http.Get;

		// Catch the Http RESPONSE
        HttpWebResponse response = request.GetResponse() as HttpWebResponse;
        xmlDoc.Load(response.GetResponseStream());
    }
    catch (System.Exception e)
    {
		throw new System.InvalidOperationException("TADDM API Error:"+e.ToString());
        xmlDoc = null;
    }
	return xmlDoc;
}

public DataTable taddmFetchData(string query, string opt, string returnTbl)
{
	DataSet resultDat=new DataSet();
	DataTable returnTable=new DataTable();
	XmlDocument xmlDocResult = new XmlDocument();
	xmlDocResult.PreserveWhitespace=true;
	if (query=="")
	{
		throw new System.ArgumentException("Query string cannot be empty!");
	}
	if (opt=="")
	{
		throw new System.ArgumentException("Option string cannot be empty!");
	}
	if (returnTbl=="")
	{
		throw new System.ArgumentException("Desired return table int cannot be empty!");
	}
	try
	{
		xmlDocResult=taddmGetXMLfromREST(query, opt);
	}
	catch (System.Exception e)
	{
		xmlDocResult=null;
		returnTable=null;
		throw new System.InvalidOperationException(e.ToString());
	}
	if (xmlDocResult!=null)
	{
		resultDat=XMLtoDataSet(xmlDocResult);
		try
		{
			returnTable=resultDat.Tables[returnTbl];
		}
		catch (System.Exception e)
		{
			returnTable=null;
		}
	}
	else
	{
		returnTable=null;
	}
	return returnTable;
}

public DataTable taddmImportServerSerial(string hostname)
{
	string queryStr="SELECT serialNumber FROM ComputerSystem WHERE displayName starts-with '"+hostname.ToLower()+"'";
	string queryOpt="fetchSize=1&depth=1&feed=xml";
//	Response.Write("http://170.144.140.19:9430/rest/model/MQLQuery?"+"query="+queryStr+"&"+queryOpt);
	DataTable fetchTable=new DataTable();
	try
	{
		fetchTable=taddmFetchData(queryStr, queryOpt,"ModelObject");
	}
	catch (System.Exception e)
	{
		fetchTable=null;
		throw new System.InvalidOperationException(e.ToString());
	}
	DataTable returnTable = null;
	if (returnTable==null)
	{
		try
		{
			string [] column = {"SerialNumber"};
			returnTable = fetchTable.DefaultView.ToTable("taddmFetch", false, column); 		
		}
		catch (System.Exception e)
		{
			returnTable=null;
		}
	}
	return returnTable;
}

public DataTable taddmImportServerDetails(string argList)
{
	string[] args = argList.Split(',');
	string addtlCriteria="";
	if (1 > args.Length)
	{
		addtlCriteria=" and serialNumber equals '"+args[1]+"'";
	}
	string queryStr="SELECT model,memorySize,numCPUs,CPUType FROM ComputerSystem WHERE displayName starts-with '"+args[0].ToLower()+"'"+addtlCriteria;
	string queryOpt="fetchSize=1&depth=1&feed=xml";
	Response.Write("http://170.144.140.19:9430/rest/model/MQLQuery?"+"query="+queryStr+"&"+queryOpt);
	DataTable fetchTable=new DataTable();
	try
	{
		fetchTable=taddmFetchData(queryStr, queryOpt,"ModelObject");
	}
	catch (System.Exception e)
	{
		fetchTable=null;
		throw new System.InvalidOperationException(e.ToString());
	}
	DataTable returnTable = null;
	if (returnTable==null)
	{
		try
		{
			string [] column = {"model","memorySize","numCPUs","CPUType"};
			returnTable = fetchTable.DefaultView.ToTable("taddmFetch", false, column); 		
		}
		catch (System.Exception e)
		{
			returnTable=null;
		}
	}
	if (returnTable==null)
	{
		try
		{
			string [] column = {"model","memorySize","numCPUs"};
			returnTable = fetchTable.DefaultView.ToTable("taddmFetch", false, column); 		
		}
		catch (System.Exception e)
		{
			returnTable=null;
		}
	}
	if (returnTable==null)
	{
		try
		{
			string [] column = {"model","memorySize"};
			returnTable = fetchTable.DefaultView.ToTable("taddmFetch", false, column); 		
		}
		catch (System.Exception e)
		{
			returnTable=null;
		}
	}
	if (returnTable==null)
	{
		try
		{
			string [] column = {"model"};
			returnTable = fetchTable.DefaultView.ToTable("taddmFetch", false, column); 		
		}
		catch (System.Exception e)
		{
			returnTable=null;
		}
	}
	return returnTable;
//	MemorySize is returned in bytes and should be divided by 1024000000 to be compatible with ESMS
}

public DataTable taddmImportServerOs(string argList)
{
	string[] args = argList.Split(',');
	string addtlCriteria="";
	if (1 > args.Length)
	{
		addtlCriteria=" and serialNumber equals '"+args[1]+"'";
	}
	string queryStr="SELECT OSInstalled FROM ComputerSystem WHERE displayName starts-with '"+args[0].ToLower()+"'"+addtlCriteria;
	string queryOpt="fetchSize=1&depth=2&feed=xml";
	Response.Write("http://170.144.140.19:9430/rest/model/MQLQuery?"+"query="+queryStr+"&"+queryOpt);
	DataTable fetchTable=new DataTable();
	try
	{
		fetchTable=taddmFetchData(queryStr, queryOpt,"OSInstalled");
	}
	catch (System.Exception e)
	{
		fetchTable=null;
		throw new System.InvalidOperationException(e.ToString());
	}
	DataTable returnTable = null;
	if (returnTable==null)
	{
		try
		{
			string [] column = {"OSName","OSVersion","kernelVersion","kernelArchitecture","servicePack"};
			returnTable = fetchTable.DefaultView.ToTable("taddmFetch", false, column);		
		}
		catch (System.Exception e)
		{
		}
	}
	if (returnTable==null)
	{
		try
		{
			string [] column = {"OSName","OSVersion","kernelVersion","kernelArchitecture"};
			returnTable = fetchTable.DefaultView.ToTable("taddmFetch", false, column);			
		}
		catch (System.Exception e)
		{
		}
	}
	if (returnTable==null)
	{
		try
		{
			string [] column = {"OSName","OSVersion","kernelVersion"};
			returnTable = fetchTable.DefaultView.ToTable("taddmFetch", false, column);			
		}
		catch (System.Exception e)
		{
		}
	}
	if (returnTable==null)
	{
		try
		{
			string [] column = {"OSName","OSVersion"};
			returnTable = fetchTable.DefaultView.ToTable("taddmFetch", false, column);			
		}
		catch (System.Exception e)
		{
		}
	}
	return returnTable;
//  OSVersion, kernelVersion, servicePack are significant columns
}

public DataTable taddmImportServerDNSConfig(string argList)
{
	string[] args = argList.Split(',');
	string addtlCriteria="";
	if (1 > args.Length)
	{
		addtlCriteria=" and serialNumber equals '"+args[1]+"'";
	}
	string queryStr="SELECT OSRunning FROM ComputerSystem WHERE displayName starts-with '"+args[0].ToLower()+"'"+addtlCriteria;
	string queryOpt="fetchSize=1&depth=3&feed=xml";
	Response.Write("http://170.144.140.19:9430/rest/model/MQLQuery?"+"query="+queryStr+"&"+queryOpt);
	DataTable fetchTable=new DataTable();
	try
	{
		fetchTable=taddmFetchData(queryStr, queryOpt,"DNSResolveEntries");
	}
	catch (System.Exception e)
	{
		fetchTable=null;
		throw new System.InvalidOperationException(e.ToString());
	}
	DataTable returnTable = null;
	if (returnTable==null)
	{
		try
		{
			string [] column = {"serverIp","searchOrder","displayName"};
			returnTable = fetchTable.DefaultView.ToTable("taddmFetch", false, column); 	
		}
		catch (System.Exception e)
		{
			returnTable=null;
		}
	}
	return returnTable;
//  serverIp, searchOrder, displayName are significant columns
}

public DataTable taddmImportServerFilesystems(string argList)
{
	string[] args = argList.Split(',');
	string addtlCriteria="";
	if (1 > args.Length)
	{
		addtlCriteria=" and serialNumber equals '"+args[1]+"'";
	}
	string queryStr="SELECT fileSystems FROM ComputerSystem.fileSystems WHERE displayName starts-with '"+args[0].ToLower()+"'"+addtlCriteria;
	string queryOpt="fetchSize=1&depth=3&feed=xml";
	Response.Write("http://170.144.140.19:9430/rest/model/MQLQuery?"+"query="+queryStr+"&"+queryOpt);
	DataTable fetchTable=new DataTable();
	try
	{
		fetchTable=taddmFetchData(queryStr, queryOpt,"fileSystems");
	}
	catch (System.Exception e)
	{
		fetchTable=null;
		throw new System.InvalidOperationException(e.ToString());
	}
	DataTable returnTable = null;
	if (returnTable==null)
	{
		try
		{
			string [] column = {"mountPoint","type","capacity","availableSpace","description","serverName"};
			returnTable = fetchTable.DefaultView.ToTable("taddmFetch", false, column); 
		}
		catch (System.Exception e)
		{
			returnTable=null;
		}
	}
	if (returnTable==null)
	{
		try
		{
			string [] column = {"mountPoint","type","capacity","availableSpace","description"};
			returnTable = fetchTable.DefaultView.ToTable("taddmFetch", false, column); 
		}
		catch (System.Exception e)
		{
			returnTable=null;
		}
	}
	return returnTable;
//  mountPoint, type, capacity, availableSpace, description, serverName are significant columns
}

public DataTable taddmImportServerNetworkConfig(string argList)
{
	string[] args = argList.Split(',');
	string addtlCriteria="";
	if (1 > args.Length)
	{
		addtlCriteria=" and serialNumber equals '"+args[1]+"'";
	}
	string queryStr="SELECT ipInterfaces FROM ComputerSystem WHERE displayName starts-with '"+args[0].ToLower()+"'"+addtlCriteria;
	string queryOpt="fetchSize=1&depth=3&feed=xml";
	Response.Write("http://170.144.140.19:9430/rest/model/MQLQuery?"+"query="+queryStr+"&"+queryOpt);
	DataTable fetchTable=new DataTable();
	try
	{
		fetchTable=taddmFetchData(queryStr, queryOpt,"ipNetwork");
	}
	catch (System.Exception e)
	{
		fetchTable=null;
		throw new System.InvalidOperationException(e.ToString());
	}
	DataTable returnTable = null;
	if (returnTable==null)
	{
		try
		{
			string [] column = {"name","netmask","subnetAddress"};
			returnTable = fetchTable.DefaultView.ToTable("taddmFetch", false, column);
		}
		catch (System.Exception e)
		{
			returnTable=null;
		}
	}
	return returnTable;
//  name, netmask are significant columns
}


public DataTable taddmImportServerEthernetAdapters(string argList)
{
	string[] args = argList.Split(',');
	string addtlCriteria="";
	if (1 > args.Length)
	{
		addtlCriteria=" and serialNumber equals '"+args[1]+"'";
	}
	string queryStr="SELECT l2Interfaces FROM ComputerSystem WHERE displayName starts-with '"+args[0].ToLower()+"'"+addtlCriteria;
	string queryOpt="fetchSize=1&depth=3&feed=xml";
	Response.Write("http://170.144.140.19:9430/rest/model/MQLQuery?"+"query="+queryStr+"&"+queryOpt);
	DataTable fetchTable=new DataTable();
	try
	{
		fetchTable=taddmFetchData(queryStr, queryOpt,"l2Interfaces");
	}
	catch (System.Exception e)
	{
		fetchTable=null;
		throw new System.InvalidOperationException(e.ToString());
	}
	DataTable returnTable = null;
	if (returnTable==null)
	{
		try
		{
			string [] column = {"name","hwAddress","description"};
			returnTable = fetchTable.DefaultView.ToTable("taddmFetch", false, column); 
		}
		catch (System.Exception e)
		{
			returnTable=null;
		}
	}
	if (returnTable==null)
	{
		try
		{
			string [] column = {"name","displayName"};
			returnTable = fetchTable.DefaultView.ToTable("taddmFetch", false, column); 
		}
		catch (System.Exception e)
		{
			returnTable=null;
		}
	}
	return returnTable;
//  name, hwAddress are significant columns
}

public DataTable taddmImportServerFiberPorts(string argList)
{
	string[] args = argList.Split(',');
	string addtlCriteria="";
	if (1 > args.Length)
	{
		addtlCriteria=" and serialNumber equals '"+args[1]+"'";
	}
	string queryStr="SELECT * FROM ComputerSystem.FCPorts WHERE displayName starts-with '"+args[0].ToLower()+"'"+addtlCriteria;
	string queryOpt="fetchSize=1&depth=2&feed=xml";
	Response.Write("http://170.144.140.19:9430/rest/model/MQLQuery?"+"query="+queryStr+"&"+queryOpt);
	DataTable fetchTable=new DataTable();
	try
	{
		fetchTable=taddmFetchData(queryStr, queryOpt,"FCPorts");
	}
	catch (System.Exception e)
	{
		fetchTable=null;
		throw new System.InvalidOperationException(e.ToString());
	}
	DataTable returnTable = null;
	if (returnTable==null)
	{
		try
		{
			string [] column = {"deviceID","portType"};
			returnTable = fetchTable.DefaultView.ToTable("taddmFetch", false, column); 
		}
		catch (System.Exception e)
		{
			returnTable=null;
		}
	}
	return returnTable;
//  name, netmask are significant columns
}

public DataTable taddmImportServerSoftware(string argList)
{
	string[] args = argList.Split(',');
	string addtlCriteria="";
	if (1 > args.Length)
	{
		addtlCriteria=" and serialNumber equals '"+args[1]+"'";
	}
	string queryStr="SELECT OSRunning FROM ComputerSystem WHERE displayName starts-with '"+args[0].ToLower()+"'"+addtlCriteria;
	string queryOpt="fetchSize=1&depth=3&feed=xml";
	Response.Write("http://170.144.140.19:9430/rest/model/MQLQuery?"+"query="+queryStr+"&"+queryOpt);
	DataTable fetchTable=new DataTable();
	try
	{
		fetchTable=taddmFetchData(queryStr, queryOpt,"softwareComponents");
	}
	catch (System.Exception e)
	{
		fetchTable=null;
		throw new System.InvalidOperationException(e.ToString());
	}
	DataTable returnTable = null;
	if (returnTable==null)
	{
		try
		{
			string [] column = {"description","softwareVersion","publisher","name"};
			returnTable = fetchTable.DefaultView.ToTable("taddmFetch", false, column); 
		}
		catch (System.Exception e)
		{
			returnTable=null;
		}
	}
	if (returnTable==null)
	{
		try
		{
			string [] column = {"description","softwareVersion","name"};
			returnTable = fetchTable.DefaultView.ToTable("taddmFetch", false, column); 
		}
		catch (System.Exception e)
		{
			returnTable=null;
		}
	}
	if (returnTable==null)
	{
		try
		{
			string [] column = {"name"};
			returnTable = fetchTable.DefaultView.ToTable("taddmFetch", false, column); 
		}
		catch (System.Exception e)
		{
			returnTable=null;
		}
	}
	return returnTable;
//  description, softwareVersion, publisher, name are significant columns
}

public DataTable taddmFetchServerWindowsServices(string argList) //This should NOT Be used to import to ESMS, but to query from TADDM on-demand!
{
	string[] args = argList.Split(',');
	string addtlCriteria="";
	if (1 > args.Length)
	{
		addtlCriteria=" and serialNumber equals '"+args[1]+"'";
	}
	string queryStr="SELECT OSRunning FROM ComputerSystem WHERE displayName starts-with '"+args[0].ToLower()+"'"+addtlCriteria;
	string queryOpt="fetchSize=1&depth=3&feed=xml";
	Response.Write("http://170.144.140.19:9430/rest/model/MQLQuery?"+"query="+queryStr+"&"+queryOpt);
	DataTable fetchTable=new DataTable();
	try
	{
		fetchTable=taddmFetchData(queryStr, queryOpt,"installedServices");
	}
	catch (System.Exception e)
	{
		fetchTable=null;
		throw new System.InvalidOperationException(e.ToString());
	}
	DataTable returnTable = null;
	if (returnTable==null)
	{
		try
		{
			string [] column = {"displayName","serviceName","operatingState","startMode","account"};
			returnTable = fetchTable.DefaultView.ToTable("taddmFetch", false, column); 
		}
		catch (System.Exception e)
		{
			returnTable=null;
		}
	}
	return returnTable;
//  displayName, serviceName, operatingState, startMode, account, are significant columns
}

public DataTable taddmFetchServerNixKernelModules(string argList) //This should NOT Be used to import to ESMS, but to query from TADDM on-demand!
{
	string[] args = argList.Split(',');
	string addtlCriteria="";
	if (1 > args.Length)
	{
		addtlCriteria=" and serialNumber equals '"+args[1]+"'";
	}
	string queryStr="SELECT OSRunning FROM ComputerSystem WHERE displayName starts-with '"+args[0].ToLower()+"'"+addtlCriteria;
	string queryOpt="fetchSize=1&depth=3&feed=xml";
	Response.Write("http://170.144.140.19:9430/rest/model/MQLQuery?"+"query="+queryStr+"&"+queryOpt);
	DataTable fetchTable=new DataTable();
	try
	{
		fetchTable=taddmFetchData(queryStr, queryOpt,"kernelModulesRawData");
	}
	catch (System.Exception e)
	{
		fetchTable=null;
		throw new System.InvalidOperationException(e.ToString());
	}
	DataTable returnTable = null;
	if (returnTable==null)
	{
		try
		{
			string [] column = {"fixedPath","content"};
			returnTable = fetchTable.DefaultView.ToTable("taddmFetch", false, column); 
		}
		catch (System.Exception e)
		{
			returnTable=null;
		}
	}
	return returnTable;
//  fixedPath, content are significant columns
}

public DataTable taddmFetchServerNixPatchesInstalled(string argList) //This should NOT Be used to import to ESMS, but to query from TADDM on-demand!
{
	string[] args = argList.Split(',');
	string addtlCriteria="";
	if (1 > args.Length)
	{
		addtlCriteria=" and serialNumber equals '"+args[1]+"'";
	}
	string queryStr="SELECT OSRunning FROM ComputerSystem WHERE displayName starts-with '"+args[0].ToLower()+"'"+addtlCriteria;
	string queryOpt="fetchSize=1&depth=3&feed=xml";
	Response.Write("http://170.144.140.19:9430/rest/model/MQLQuery?"+"query="+queryStr+"&"+queryOpt);
	DataTable fetchTable=new DataTable();
	try
	{
		fetchTable=taddmFetchData(queryStr, queryOpt,"patchesInstalledRawData");
	}
	catch (System.Exception e)
	{
		fetchTable=null;
		throw new System.InvalidOperationException(e.ToString());
	}
	DataTable returnTable = null;
	if (returnTable==null)
	{
		try
		{
			string [] column = {"fixedPath","content"};
			returnTable = fetchTable.DefaultView.ToTable("taddmFetch", false, column); 
		}
		catch (System.Exception e)
		{
			returnTable=null;
		}
	}
	return returnTable;
//  fixedPath, content are significant columns
}

public DataTable taddmFetchServerNixUsersGroups(string argList) //This should NOT Be used to import to ESMS, but to query from TADDM on-demand!
{
	string[] args = argList.Split(',');
	string addtlCriteria="";
	if (1 > args.Length)
	{
		addtlCriteria=" and serialNumber equals '"+args[1]+"'";
	}
	string queryStr="SELECT OSInstalled FROM ComputerSystem.OSRunning WHERE displayName starts-with '"+args[0].ToLower()+"'"+addtlCriteria;
	string queryOpt="fetchSize=1&depth=3&feed=xml";
	Response.Write("http://170.144.140.19:9430/rest/model/MQLQuery?"+"query="+queryStr+"&"+queryOpt);
	DataTable fetchTable=new DataTable();
	try
	{
		fetchTable=taddmFetchData(queryStr, queryOpt,"configContents");
	}
	catch (System.Exception e)
	{
		fetchTable=null;
		throw new System.InvalidOperationException(e.ToString());
	}
	DataTable returnTable = null;
	if (returnTable==null)
	{
		try
		{
			string [] column = {"fixedPath","content"};
			returnTable = fetchTable.DefaultView.ToTable("taddmFetch", false, column); 
		}
		catch (System.Exception e)
		{
			returnTable=null;
		}
	}
	return returnTable;
// fixedPath, content are significant columns
}

void goMql(Object s, EventArgs e)
{
	string query="", queryOptions="";
	XmlDocument xmlDocResult = new XmlDocument();
	xmlDocResult.PreserveWhitespace=true;
	DataSet dat=new DataSet();
	int i = 0;
	HtmlTableRow tr;
	HtmlTableCell td;

	query=mqlCommand.Value.ToString();
	query=query.Trim();
	query=query.Replace("  "," ");
	query=query.Replace("   "," ");
	query=query.Replace("    "," ");
	queryOptions="fetchSize="+mqlSize.Value.ToString()+"&depth="+mqlDepth.Value.ToString()+"&feed=xml";
	if (query!="")
	{
		xmlDocResult=taddmGetXMLfromREST(query, queryOptions);
		if (xmlDocResult!=null)
		{
			dat=XMLtoDataSet(xmlDocResult);
			if (!emptyDataset(dat))
			{
				tr = new HtmlTableRow();    //Output <TR>
					tr.Attributes.Add("class","blackheading");
					td = new HtmlTableCell(); //Output <TD>
						td.Attributes.Add("colspan","2");
						td.InnerHtml = "Tables in MQL Query";
					tr.Cells.Add(td);         //Output </TD>
				restTableList.Rows.Add(tr);           //Output </TR>
				tr = new HtmlTableRow();    //Output <TR>
					tr.Attributes.Add("class","tableheading");
					td = new HtmlTableCell(); //Output <TD>
						td.InnerHtml = "Index";
					tr.Cells.Add(td);         //Output </TD>
					td = new HtmlTableCell(); //Output <TD>
						td.InnerHtml = "Table Name";
					tr.Cells.Add(td);         //Output </TD>
				restTableList.Rows.Add(tr);           //Output </TR>
				DataTableCollection datTables = dat.Tables;
				foreach (DataTable tbl in datTables)
				{
					tr = new HtmlTableRow();    //Output <TR>
						td = new HtmlTableCell(); //Output <TD>
							td.InnerHtml = i.ToString();
						tr.Cells.Add(td);         //Output </TD>
						td = new HtmlTableCell(); //Output <TD>
							td.InnerHtml = tbl.TableName.ToString();
						tr.Cells.Add(td);         //Output </TD>
					restTableList.Rows.Add(tr);           //Output </TR>
					i++;
				}
				try
				{
					restResult.DataSource=dat.Tables[Convert.ToInt32(mqlTable.Value)];
				}
				catch (System.Exception ex)
				{
					errmsg.InnerHtml="None Found.";
					restResult.DataSource=null;
				}
				restResult.DataBind();
			}
			status.InnerHtml="http://170.144.140.19:9430/rest/model/MQLQuery?query="+query.Replace(" ","%20")+"&"+queryOptions+"";
			resultString.InnerHtml="";
		}
		else
		{
			errmsg.InnerHtml="No Matching Results Found.";
		} 
	}
}

void goPreMql(Object s, EventArgs e)
{
	string queryFunc=cannedQuery.Value;
	string queryArg=cannedQueryArg.Value;
	DataTable taddmDat=new DataTable();

	restResult.DataSource=null;
	restResult.DataBind();

	switch (queryFunc)
	{
	case "taddmImportServerSerial" :
			taddmDat=taddmImportServerSerial(queryArg.ToString());
			if (taddmDat!=null)
			{
				restResult.DataSource=taddmDat;
				restResult.DataBind();
			}
			else
			{
				status.InnerHtml="None Found.";
			}
		break;
	case "taddmImportServerDetails" :
			taddmDat=taddmImportServerDetails(queryArg.ToString());
			if (taddmDat!=null)
			{
				restResult.DataSource=taddmDat;
				restResult.DataBind();
			}
			else
			{
				status.InnerHtml="None Found.";
			}
		break;
	case "taddmImportServerOs" :
			taddmDat=taddmImportServerOs(queryArg.ToString());
			if (taddmDat!=null)
			{
				restResult.DataSource=taddmDat;
				restResult.DataBind();
			}
			else
			{
				status.InnerHtml="None Found.";
			}
		break;
	case "taddmImportServerDNSConfig" :
			taddmDat=taddmImportServerDNSConfig(queryArg.ToString());
			if (taddmDat!=null)
			{
				restResult.DataSource=taddmDat;
				restResult.DataBind();
			}
			else
			{
				status.InnerHtml="None Found.";
			}
		break;
	case "taddmImportServerFilesystems" :
			taddmDat=taddmImportServerFilesystems(queryArg.ToString());
			if (taddmDat!=null)
			{
				restResult.DataSource=taddmDat;
				restResult.DataBind();
			}
			else
			{
				status.InnerHtml="None Found.";
			}
		break;
	case "taddmImportServerEthernetAdapters" :
			taddmDat=taddmImportServerEthernetAdapters(queryArg.ToString());
			if (taddmDat!=null)
			{
				restResult.DataSource=taddmDat;
				restResult.DataBind();
			}
			else
			{
				status.InnerHtml="None Found.";
			}
		break;
	case "taddmImportServerNetworkConfig" :
			taddmDat=taddmImportServerNetworkConfig(queryArg.ToString());
			if (taddmDat!=null)
			{
				restResult.DataSource=taddmDat;
				restResult.DataBind();
			}
			else
			{
				status.InnerHtml="None Found.";
			}
		break;
	case "taddmImportServerFiberPorts" :
			taddmDat=taddmImportServerFiberPorts(queryArg.ToString());
			if (taddmDat!=null)
			{
				restResult.DataSource=taddmDat;
				restResult.DataBind();
			}
			else
			{
				status.InnerHtml="None Found.";
			}
		break;
	case "taddmImportServerSoftware" :
			taddmDat=taddmImportServerSoftware(queryArg.ToString());
			if (taddmDat!=null)
			{
				restResult.DataSource=taddmDat;
				restResult.DataBind();
			}
			else
			{
				status.InnerHtml="None Found.";
			}
		break;
	case "taddmFetchServerWindowsServices" :
			taddmDat=taddmFetchServerWindowsServices(queryArg.ToString());
			if (taddmDat!=null)
			{
				restResult.DataSource=taddmDat;
				restResult.DataBind();
			}
			else
			{
				status.InnerHtml="None Found.";
			}
		break;
	case "taddmFetchServerNixKernelModules" :
			taddmDat=taddmFetchServerNixKernelModules(queryArg.ToString());
			if (taddmDat!=null)
			{
				restResult.DataSource=taddmDat;
				restResult.DataBind();
			}
			else
			{
				status.InnerHtml="None Found.";
			}
		break;
	case "taddmFetchServerNixPatchesInstalled" :
			taddmDat=taddmFetchServerNixPatchesInstalled(queryArg.ToString());
			if (taddmDat!=null)
			{
				restResult.DataSource=taddmDat;
				restResult.DataBind();
			}
			else
			{
				status.InnerHtml="None Found.";
			}
		break;
	case "taddmFetchServerNixUsersGroups" :
			taddmDat=taddmFetchServerNixUsersGroups(queryArg.ToString());
			if (taddmDat!=null)
			{
				restResult.DataSource=taddmDat;
				restResult.DataBind();
			}
			else
			{
				status.InnerHtml="None Found.";
			}
		break;
	default :
			restResult.DataSource=null;
			restResult.DataBind();
		break;
	}
}

public void Page_Load(Object o, EventArgs e)
{
//UNCOMMENT this line to force login to access this page.
//	lockout(); 
	Page.Header.Title=shortSysName+": TADDM MQL API Testing";
	systemStatus(0); // Check to see if admin has put system is in offline mode.

//START Check if user is logged in by checking existence of cookie.
//	loggedin.InnerHtml=loggedIn();
	adminMenu.InnerHtml=isAdmin();

	DateTime dateStamp = DateTime.Now;
	string v_username, curStat="";
	string uri="", query="", queryOptions="";
	DataSet dat=new DataSet();

	try
	{
		v_username=Request.Cookies["username"].Value;
	}
	catch (System.Exception ex)
	{
		v_username="";
	}

	titleSpan.InnerHtml="<SPAN class='heading1'>TADDM MQL API Testing</SPAN>";

	restResult.DataSource=null;
	restResult.DataBind();

	if (IsPostBack)
	{
		try
		{
			restResult.DataSource=taddmImportServerSerial("sxpheiis001");
		}
		catch (System.Exception ex)
		{
			restResult.DataSource=null;
			errmsg.InnerHtml=ex.ToString();
		}
		restResult.DataBind();
	}

}
</SCRIPT>
</HEAD>
 <!--#include file='body.inc' -->
<FORM id='form1' runat='server'>
<DIV id='container'>
<!--#include file='banner.inc' -->
<!--#include file='menu.inc' -->
	<DIV id='content'>
		<SPAN id='titleSpan' runat='server'/>
		<DIV class='center'>
			<DIV id='errmsg' class='errorLine' runat='server'/>
			<DIV id='status' class='statusLine' runat='server'/><BR/>
		</DIV>
		Choose a 'canned' TADDM API Query:<BR/>
		<SELECT id='cannedQuery' runat='server'>
			<OPTION value=''  selected='true'>No</OPTION>
			<OPTION value='taddmImportServerSerial'>taddmImportServerSerial</OPTION>
			<OPTION value='taddmImportServerDetails'>taddmImportServerDetails</OPTION>
			<OPTION value='taddmImportServerOs'>taddmImportServerOs</OPTION>
			<OPTION value='taddmImportServerDNSConfig'>taddmImportServerDNSConfig</OPTION>
			<OPTION value='taddmImportServerFilesystems'>taddmImportServerFilesystems</OPTION>
			<OPTION value='taddmImportServerEthernetAdapters'>taddmImportServerEthernetAdapters</OPTION>
			<OPTION value='taddmImportServerNetworkConfig'>taddmImportServerNetworkConfig</OPTION>
			<OPTION value='taddmImportServerFiberPorts'>taddmImportServerFiberPorts</OPTION>
			<OPTION value='taddmImportServerSoftware'>taddmImportServerSoftware</OPTION>
			<OPTION value='taddmFetchServerWindowsServices'>taddmFetchServerWindowsServices</OPTION>
			<OPTION value='taddmFetchServerNixKernelModules'>taddmFetchServerNixKernelModules</OPTION>
			<OPTION value='taddmFetchServerNixPatchesInstalled'>taddmFetchServerNixPatchesInstalled</OPTION>
			<OPTION value='taddmFetchServerNixUsersGroups'>taddmFetchServerNixUsersGroups</OPTION>
			<OPTION value=''></OPTION>
		</SELECT>
		Arg: <INPUT type='text' id='cannedQueryArg' runat='server'/>
		<INPUT type='button' id='goPreButton' value='Run Canned Query' name='goPreButton' OnServerClick='goPreMql' runat='server'>
		<BR/>-or-<BR/>
		CUSTOM TADDM API MQL Query:<BR/>
		<TEXTAREA rows='8' cols='70' id='mqlCommand' style='background-color: #edf0f3' runat='server' /><BR/>
		Query Depth: 
		<SELECT id='mqlDepth' runat='server'>
			<OPTION value='1' selected='true'>1 (Default)</OPTION>
			<OPTION value='2'>2</OPTION>
			<OPTION value='3'>3</OPTION>
			<OPTION value='4'>4</OPTION>
			<OPTION value='5'>5</OPTION>
		</SELECT>
		<BR/>Result Size: 
		<SELECT id='mqlSize' runat='server'>
			<OPTION value='1'  selected='true'>1 (Default)</OPTION>
			<OPTION value='2'>2</OPTION>
			<OPTION value='10'>10</OPTION>
			<OPTION value='25'>25</OPTION>
			<OPTION value='50'>50</OPTION>
		</SELECT>
		<BR/>Show Table: 
		<SELECT id='mqlTable' runat='server'>
			<OPTION value='0' selected='true'>0 (Default)</OPTION>
			<OPTION value='1'>1</OPTION>
			<OPTION value='2'>2</OPTION>
			<OPTION value='3'>3</OPTION>
			<OPTION value='4'>4</OPTION>
			<OPTION value='5'>5</OPTION>
			<OPTION value='6'>6</OPTION>
			<OPTION value='7'>7</OPTION>
			<OPTION value='8'>8</OPTION>
			<OPTION value='9'>9</OPTION>
			<OPTION value='10'>10</OPTION>
			<OPTION value='11'>11</OPTION>
			<OPTION value='12'>12</OPTION>
			<OPTION value='13'>13</OPTION>
			<OPTION value='14'>14</OPTION>
			<OPTION value='15'>15</OPTION>
			<OPTION value='16'>16</OPTION>
			<OPTION value='17'>17</OPTION>
			<OPTION value='18'>18</OPTION>
			<OPTION value='19'>19</OPTION>
			<OPTION value='20'>20</OPTION>
			<OPTION value='21'>21</OPTION>
			<OPTION value='22'>22</OPTION>
			<OPTION value='23'>23</OPTION>
			<OPTION value='24'>24</OPTION>
			<OPTION value='25'>25</OPTION>
			<OPTION value='26'>26</OPTION>
			<OPTION value='27'>27</OPTION>
			<OPTION value='28'>28</OPTION>
			<OPTION value='29'>29</OPTION>
			<OPTION value='30'>30</OPTION>
			<OPTION value='31'>31</OPTION>
			<OPTION value='32'>32</OPTION>
			<OPTION value='33'>33</OPTION>
			<OPTION value='34'>34</OPTION>
			<OPTION value='35'>35</OPTION>
			<OPTION value='36'>36</OPTION>
			<OPTION value='37'>37</OPTION>
			<OPTION value='38'>38</OPTION>
			<OPTION value='39'>39</OPTION>
			<OPTION value='40'>40</OPTION>
		</SELECT>
		<BR/><BR/>
		<INPUT type='button' id='mqlButton' value='Submit MQL Query' name='mqlButton' OnServerClick='goMql' runat='server' />
		<BR/><BR>
		<ASP:Panel id='Panel1' runat='server' Height='25px' HorizontalAlign='right' BackColor='#ffffff' />
		<BR/><BR/>
		<TABLE id='restTableList' border='1' class='datatable' runat='server' />
		<BR/><BR/>
		<ASP:datagrid id='restResult' runat='server' BackColor='White' HorizontalAlign='Center' Font-Size='8pt' CellPadding='2' BorderColor='#336633' BorderStyle='Solid' BorderWidth='2px'>
			<HeaderStyle BackColor='#336633' ForeColor='White' Font-Bold='True' HorizontalAlign='Center' />
			<AlternatingItemStyle BackColor='#edf0f3' />
		</ASP:datagrid>
		<DIV id='resultString' style='color:black; font-family:courier new, nimbus, courier' runat='server'/>
	</DIV> <!-- End: content -->
<!--#include file='closer.inc'-->
</DIV> <!-- End: container -->
</FORM>
</BODY>
</HTML>