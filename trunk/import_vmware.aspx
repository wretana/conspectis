<%@Page Inherits="CIS.conspectisLibrary" src="conspectisLibrary.cs" Language="C#" debug="true" %>
<%@Import Namespace="System.Globalization"%>
<%@Import Namespace="System.Data"%>
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

	public string CleanLogs(string logPath)
	{
		//declare variables
		int days;
		System.DateTime date;
		System.DateTime keepdate;
		string result="";

		//Number of days/(files if created daily) to keep 
		days = 9;

		//declare the current date/time
		date = (DateTime.Now);

		//this is just a check to make sure the path and keep days are correct
		result="<SPAN class='heading2'>Log File Cleanup</SPAN>";
		result+="<P>";
		result+="Path:"+logPath+"<BR/>";
		result+="DaysToKeep:"+days+"<BR/>";

		//this is a check of the current business date
		result+="Today:"+date+"<BR/>";

		//calculate the current date - the number of keep days
		keepdate = date.AddDays(-days);

		//display the date minus the keep days
		result+="KeepDate:"+keepdate+"<BR/><BR/>";

		//this is where it gets the directory and looks at
		//the files in the directory to compare the last write time
		//against the keepdate variable.
		DirectoryInfo fileListing = new DirectoryInfo(@logPath);
		foreach (System.IO.FileInfo f in fileListing.GetFiles())
		{
			if (f.LastWriteTime <= keepdate) 
			{
				f.Delete();
				result+="DELETED "+f.FullName.ToString()+" : Older than "+days+" days.<BR/>";
			}
			else
			{
				result+=f.FullName.ToString()+" : Skipping, not older than "+days+" days.<BR/>";
			}
		}
		result+="</P>";
		return result;
	}

public static void InitLog(string heading, TextWriter w)
{
	w.Write("<!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.01 Transitional//EN' 'http://www.w3.org/TR/html4/loose.dtd'><!DOCTYPE html>
<!-- HTML5 STatus:  -->
<!--[if lt IE 7 ]> <html lang='en' class='no-js ie6'> <![endif]-->
<!--[if IE 7 ]>    <html lang='en' class='no-js ie7'> <![endif]-->
<!--[if IE 8 ]>    <html lang='en' class='no-js ie8'> <![endif]-->
<!--[if IE 9 ]>    <html lang='en' class='no-js ie9'> <![endif]-->
<!--[if (gt IE 9)|!(IE)]><!--> <html lang='en' class='no-js'> <!--<![endif]--><HEAD>"+heading+"</HEAD><!--#include file="body.inc" -->");
//	w.Flush();
}

public static void CloseLog(TextWriter w)
{
	w.Write("</BODY></HEAD>");
//	w.Flush();
}

public static void Log(TextWriter w, string logMessage)
{
	w.WriteLine (logMessage);
	// Update the underlying file.
//	w.Flush();
}

/*protected override void Render(HtmlTextWriter writer)
{
 using (StringWriter stringWriter = new StringWriter(new StringBuilder(), CultureInfo.InvariantCulture))
 {
  DateTime dateStamp = DateTime.Now;
  string path=Server.MapPath("./vmware/import/");
  string importLog = path+"..\\logs\\vicImport_"+dateStamp.Month+dateStamp.Day+dateStamp.Year+"-"+dateStamp.Hour+dateStamp.Minute+dateStamp.Second+".htm";
  HtmlTextWriter htmlTextWriter = new HtmlTextWriter(stringWriter);
  base.Render(htmlTextWriter);
  File.AppendAllText(importLog, stringWriter.ToString());

  writeChangeLog(dateStamp.ToString(), shortSysName+"-VICImport", "VICImport Completed - Logfile: "+importLog, "I", 4444);
 }
}
*/


public void Page_Load(Object o, EventArgs e)
{
//UNCOMMENT this line to force login to access this page.
//	lockout(); 
	Page.Header.Title=shortSysName+": Import VC-CSV (VirtualCenter Import)";
	systemStatus(0); // Check to see if admin has put system is in offline mode.

//START Check if user is logged in by checking existence of cookie.
//	loggedin.InnerHtml=loggedIn();
//	adminMenu.InnerHtml=isAdmin();

	string v_username, curStat="";
	string sql="", status="", path="", sqlErr="", sqlName="", sqlIp="", relative="", logFile="";
	DataSet clusterDat = new DataSet();
	DataSet datastoreDat = new DataSet();
	DataSet vmDat = new DataSet();
	DataSet snapDat = new DataSet();
	DataSet rackDat = new DataSet();
	DataSet vlanDat = new DataSet();
	DataSet hostDat = new DataSet();
	DataSet vmtoolsDat = new DataSet();
	DataSet datName = new DataSet();
	DataSet datIp = new DataSet();
	DataSet dat = new DataSet();
	bool sqlSuccess=false;
	string clusterResult="", vmResult="", snapResult="";

	try
	{
		v_username=Request.Cookies["username"].Value;
	}
	catch (System.Exception ex)
	{
		v_username="";
	}


	DateTime dateStamp = DateTime.Now;
	path=Server.MapPath("./vmware/import/");
	relative="..\\logs\\";
	logFile="vicImport_"+dateStamp.Month+dateStamp.Day+dateStamp.Year+"-"+dateStamp.Hour+dateStamp.Minute+dateStamp.Second+".htm";
	string importLog = path+relative+logFile;
	StreamWriter w = new StreamWriter(importLog);
	InitLog("<SPAN class='heading1'>"+importLog+"</SPAN>",w);
//	w.Write("<!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.01 Transitional//EN' 'http://www.w3.org/TR/html4/loose.dtd'><!DOCTYPE html>
<!-- HTML5 STatus:  -->
<!--[if lt IE 7 ]> <html lang='en' class='no-js ie6'> <![endif]-->
<!--[if IE 7 ]>    <html lang='en' class='no-js ie7'> <![endif]-->
<!--[if IE 8 ]>    <html lang='en' class='no-js ie8'> <![endif]-->
<!--[if IE 9 ]>    <html lang='en' class='no-js ie9'> <![endif]-->
<!--[if (gt IE 9)|!(IE)]><!--> <html lang='en' class='no-js'> <!--<![endif]--><HEAD><SPAN class='heading1'>"+importLog+"</SPAN></HEAD><!--#include file="body.inc" -->");	
//	Log(w,path);
/*
	 Do all this to prepare ESMS for automated VM Exports
    ------------------------------------------------------------------------------------------------------------------
		DELETE FROM servers WHERE memberOfCluster='VMWare-PHE' AND serverOs<>'ESX'
		DELETE FROM servers WHERE memberOfCluster='VMWare-Engineering' AND serverOs<>'ESX'
		DELETE FROM rackspace WHERE class='virtual' AND model='ESX'
		DELETE FROM clusters WHERE clusterType='ESX'
		ALTER TABLE rackspace DROP VMId
		ALTER TABLE servers ADD VMId text
		ALTER TABLE rackspace ADD VMDatastore text
		ALTER TABLE rackspace ADD VMHost text
		ALTER TABLE servers ADD VMToolsState text
		ALTER TABLE servers ADD VMPowerState text
		 ALTER TABLE servers ALTER COLUMN VMToolsVersion integer
		 ALTER TABLE servers ADD VMToolsVersion text
		 ALTER TABLE servers ADD VMSysDiskPath text
		 ALTER TABLE servers ADD VMDataDiskPath text
		 ALTER TABLE servers ADD VMSysDiskCapMB single
		 ALTER TABLE servers ADD VMDataDiskCapMB single
		 ALTER TABLE servers ADD VMSysDiskFreeMB single
		 ALTER TABLE servers ADD VMDataDiskFreeMB single
		 ALTER TABLE servers ADD dependsOn text
		 ALTER TABLE servers ADD isDependedOnBy text
		ALTER TABLE rackspace ALTER COLUMN ram single
		CREATE TABLE snapshots (Id COUNTER PRIMARY KEY, snapId text, vmName text, snapDesc text, created text, sizeOnDisk text)
		INSERT INTO software (sfwName, sfwClass, sfwOS) VALUES ('RHEL Linux 4 (Point Solution Build)', 'OS', 'Linux')
		INSERT INTO software (sfwName, sfwClass, sfwOS) VALUES ('RHEL Linux 5.3g', 'OS', 'Linux')
		INSERT INTO software (sfwName, sfwClass, sfwOS) VALUES ('Microsoft Windows XP Professional', 'OS', 'Windows')
		CREATE TABLE datastores (Id COUNTER PRIMARY KEY, name text, capacityMB long, freespaceMB long, inUse integer)
*/

	Log(w,"");

    if (!IsPostBack)
    {

// --Clear existing VMs from Database-----------------------------------------------------------------------------------------------------------
		Log(w,"<SPAN class='heading2'>Delete old VM Data</SPAN>");
		sql="DELETE * FROM clusters WHERE clusterType='ESX'";
		Log(w,sql);
		sqlErr=writeDb(sql);
		if (sqlErr==null || sqlErr=="")
		{
			Log(w,"<SPAN class='italic'> - VM Cleanup: ESX Clusters cleared from clusters table.<BR/></SPAN>");
			sqlSuccess=true;
		}
		else
		{
			Log(w,"<FONT color='red'><SPAN class='italic'> - ESX Clusters Cleanup ERROR:"+sqlErr+"</SPAN></SPAN><BR/>");
			writeChangeLog(dateStamp.ToString(), shortSysName+"-VICImport", "ESX Clusters Cleanup ERROR:"+sqlErr+"("+sql+")", "E", 4444);
		}	
		if (sqlSuccess) 
		{
			if (sqlErr==null || sqlErr=="")
			{
			}
			else
			{
			}
		}	
		sql="DELETE * FROM rackspace WHERE serial LIKE '%VirtualMachine-vm-%'";
		Log(w,sql);
		sqlErr=writeDb(sql);
		if (sqlErr==null || sqlErr=="")
		{
			Log(w,"<SPAN class='italic'> - VM Cleanup: VMs deleted from rackspace table.<BR/></SPAN>");
			sqlSuccess=true;
		}
		else
		{
			Log(w,"<FONT color='red'><SPAN class='italic'> - VM Rackspace Cleanup ERROR:"+sqlErr+"</SPAN></SPAN><BR/>");
			writeChangeLog(dateStamp.ToString(), shortSysName+"-VICImport", "VM Rackspace Cleanup ERROR:"+sqlErr+"("+sql+")", "E", 4444);
		}	
		if (sqlSuccess) 
		{
			if (sqlErr==null || sqlErr=="")
			{
			}
			else
			{
			}
		}	

		sql="DELETE * FROM servers WHERE VMId LIKE '%VirtualMachine-vm-%'";
		Log(w,sql);
		sqlErr=writeDb(sql);
		if (sqlErr==null || sqlErr=="")
		{
			Log(w,"<SPAN class='italic'> - VM Cleanup: VMs deleted from servers table.<BR/></SPAN>");
			sqlSuccess=true;
		}
		else
		{
			Log(w,"<FONT color='red'><SPAN class='italic'> - VM Server Cleanup ERROR:"+sqlErr+"</SPAN></SPAN><BR/>");
			writeChangeLog(dateStamp.ToString(), shortSysName+"-VICImport", "VM Server Cleanup ERROR:"+sqlErr+"("+sql+")", "E", 4444);
		}	
		if (sqlSuccess) 
		{
			if (sqlErr==null || sqlErr=="")
			{
			}
			else
			{
			}
		}

		sql="DELETE * FROM datastores";
		Log(w,sql);
		sqlErr=writeDb(sql);
		if (sqlErr==null || sqlErr=="")
		{
			Log(w,"<SPAN class='italic'> - Datastore Cleanup: Datastoress deleted from rackspace table.<BR/></SPAN>");
			sqlSuccess=true;
		}
		else
		{
			Log(w,"<FONT color='red'><SPAN class='italic'> - Datastore Cleanup ERROR:"+sqlErr+"</SPAN></SPAN><BR/>");
			writeChangeLog(dateStamp.ToString(), shortSysName+"-VICImport", "Datastore Cleanup ERROR:"+sqlErr+"("+sql+")", "E", 4444);
		}	
		if (sqlSuccess) 
		{
			if (sqlErr==null || sqlErr=="")
			{
			}
			else
			{
			}
		}

		sql="DELETE * FROM snapshots WHERE snapId LIKE '%VirtualMachineSnapshot-snapshot-%'";
		Log(w,sql);
		sqlErr=writeDb(sql);
		if (sqlErr==null || sqlErr=="")
		{
			Log(w,"<SPAN class='italic'> - VM Cleanup: Snapshots deleted.<BR/></SPAN>");
			sqlSuccess=true;
		}
		else
		{
			Log(w,"<FONT color='red'><SPAN class='italic'> - Snapshot Cleanup ERROR:"+sqlErr+"</SPAN></SPAN><BR/>");
			writeChangeLog(dateStamp.ToString(), shortSysName+"-VICImport", "Snapshot Cleanup ERROR:"+sqlErr+"("+sql+")", "E", 4444);
		}	
		if (sqlSuccess) 
		{
			if (sqlErr==null || sqlErr=="")
			{
			}
			else
			{
			}
		}


// --Cluster &amp; Datastore Import-----------------------------------------------------------------------------------------------------------------
		DirectoryInfo clusters = new DirectoryInfo(@path);
		FileInfo[] clusterFiles = clusters.GetFiles("*_cluster*");
		Log(w,"<SPAN class='heading2'>Cluster Data File Import</SPAN>");
	    foreach (FileInfo clusterFile in clusterFiles)
		{
			clusterResult="";
			sqlErr="";
			dat=null;
			sqlSuccess=false;
			string infile = "";
			string[] infileArr = null;
			string sourceVic = "";
			string clusterIp = "";
			infile = Convert.ToString(clusterFile);
			Log(w,"<SPAN class='bold'>"+infile+"</SPAN><BR/>");
			clusterDat=readFile(path+infile,infile.Substring(infile.IndexOf("-")),"~");
//			clusterDat=readFile(path+infile,infile.Substring(12,infile.Length-16),"~");
			if (clusterDat!=null)
			{
				infileArr = infile.Split('-');
				sourceVic = infileArr[0].ToString();
				clusterIp = simpleDnsLookup(sourceVic);
				if (clusterIp.Contains("ERROR:"))
				{
					clusterIp="";
					Log(w,clusterIp+"<BR/>");
				}
				else
				{
					clusterIp=break_ip(clusterIp);
				}
//				Log(w,sourceVic+"<BR/>");
			}
			sql="SELECT * FROM clusters WHERE clusterName='"+infile.Substring(infile.IndexOf("-")+1,infile.IndexOf(".")-infile.IndexOf("-")-1)+"'";
//			sql="SELECT * FROM clusters WHERE clusterName='"+infile.Substring(12,infile.Length-16)+"'";
//			Log(w,sql+"<BR/>");
			dat=readDb(sql);
			if (emptyDataset(dat))
			{
				Log(w,"<SPAN class='italic'>Cluster Not Found, Adding...</SPAN><BR/>");
				sql="INSERT INTO clusters(clusterName, clusterType, clusterPurpose, clusterLanIp) VALUES("		
								+"'"+infile.Substring(infile.IndexOf("-")+1,infile.IndexOf(".")-infile.IndexOf("-")-1)+"',"
//								+"'"+infile.Substring(12,infile.Length-16)+ "',"
								+"'ESX',"
								+"'Virtual Servers',"
								+"'" +clusterIp+   "')";
				Log(w,sql);
				sqlErr=writeDb(sql);
				if (sqlErr==null || sqlErr=="")
				{
					Log(w,"<SPAN class='italic'> - Cluster Import: Cluster Table Updated.<BR/><BR/></SPAN>");
					sqlSuccess=true;
				}
				else
				{
					Log(w,"<FONT color='red'><SPAN class='italic'> - Cluster Table Record Update ERROR:"+sqlErr+"</SPAN></SPAN><BR/>");
					writeChangeLog(dateStamp.ToString(), shortSysName+"-VICImport", "Cluster Table Record Update ERROR:"+sqlErr+"("+sql+")", "E", 4444);
				}	
				if (sqlSuccess) 
				{
					if (sqlErr==null || sqlErr=="")
					{
					}
					else
					{
					}
				}	
			}
			else
			{
				Log(w,"<SPAN class='italic'>Cluster Record exists...</SPAN><BR/>");
			//sql="UPDATE clusters SET clusterType='ESX', clusterPurpose='Virtual Servers', clusterLanIp='"+clusterIp+"' WHERE clusterName='"+infile.Substring(12,infile.Length-16)+"'";
			sql="UPDATE clusters SET clusterType='ESX', clusterPurpose='Virtual Servers', clusterLanIp='"+clusterIp+"' WHERE clusterName='"+infile.Substring(infile.IndexOf("-")+1,infile.IndexOf(".")-infile.IndexOf("-")-1)+"'";
				Log(w,sql);
				sqlErr=writeDb(sql);
				if (sqlErr==null || sqlErr=="")
				{
					Log(w,"<SPAN class='italic'> - Cluster Import: Cluster Table Updated.<BR/><BR/></SPAN>");
					sqlSuccess=true;
				}
				else
				{
					Log(w,"<FONT color='red'><SPAN class='italic'> - Cluster Table Record Update ERROR:"+sqlErr+"</SPAN></SPAN><BR/>");
					writeChangeLog(dateStamp.ToString(), shortSysName+"-VICImport", "Cluster Table Record Update ERROR:"+sqlErr+"("+sql+")", "E", 4444);
				}	
				if (sqlSuccess) 
				{
					if (sqlErr==null || sqlErr=="")
					{
					}
					else
					{
					}
				}	
			}
			foreach (DataTable cdt in clusterDat.Tables)
			{
				foreach (DataRow cdr in cdt.Rows)
				{
					sql="";
					dat=null;
					sql="SELECT * FROM rackspace WHERE serial='"+sourceVic+fix_csv(cdr["\"VMId\""].ToString())+"'";
					dat=readDb(sql);
					if (emptyDataset(dat))
					{
						if (fix_csv(cdr["\"VMId\""].ToString())!=null && fix_csv(cdr["\"VMId\""].ToString())!="")
						{
							sql="INSERT INTO rackspace(reserved, class, belongsTo, serial, model, VMDatastore) VALUES("					
											+"0,"
											+"'Virtual',"
											+"'"+fix_csv(cdr["\"Cluster\""].ToString())+ "',"
											+"'"+sourceVic+"-"+fix_csv(cdr["\"VMId\""].ToString())+"',"
											+"'ESX Virtual Machine',"
											+"'"+fix_csv(cdr["\"Datastore\""].ToString())+   "')";
							Log(w,sql);
							sqlErr=writeDb(sql);
							if (sqlErr==null || sqlErr=="")
							{
								Log(w,"<SPAN class='italic'> - Cluster Import: Rackspace record added.<BR/></SPAN>");
								sqlSuccess=true;
							}
							else
							{
								Log(w,"<FONT color='red'><SPAN class='italic'> - Cluster Rackspace Record Addition ERROR:"+sqlErr+"</SPAN></SPAN><BR/>");
								writeChangeLog(dateStamp.ToString(), shortSysName+"-VICImport", "Cluster Rackspace Record Addition ERROR:"+sqlErr+"("+sql+")", "E", 4444);
							}	
							if (sqlSuccess) 
							{
								if (sqlErr==null || sqlErr=="")
								{
								}
								else
								{
								}
							}
						}
					}
					else
					{
						if (fix_csv(cdr["\"VMId\""].ToString())!=null && fix_csv(cdr["\"VMId\""].ToString())!="")
						{
							sql="UPDATE rackspace SET belongsTo='"+fix_csv(cdr["\"Cluster\""].ToString())+"', VMDatastore='"+fix_csv(cdr["\"Datastore\""].ToString())+"' WHERE serial='"+sourceVic+"-"+fix_csv(cdr["\"VMId\""].ToString())+"'";
							Log(w,sql);
							sqlErr=writeDb(sql);
							if (sqlErr==null || sqlErr=="")
							{
								Log(w,"<SPAN class='italic'> - Cluster Import: Rackspace record updated.<BR/></SPAN>");
								sqlSuccess=true;
							}
							else
							{
								Log(w,"<FONT color='red'><SPAN class='italic'> - Cluster Rackspace Record Update ERROR:"+sqlErr+"</SPAN></SPAN><BR/>");
								writeChangeLog(dateStamp.ToString(), shortSysName+"-VICImport", "Cluster Rackspace Record Update ERROR:"+sqlErr+"("+sql+")", "E", 4444);
							}	
							if (sqlSuccess) 
							{
								if (sqlErr==null || sqlErr=="")
								{
								}
								else
								{
								}
							}
						}
					}
	
				}
				Log(w,"<BR/>");
			}
	    }
		Log(w,"<BR/>");

// --Datastore Details-----------------------------------------------------------------------------------------------------------------
		DirectoryInfo datastores = new DirectoryInfo(@path);
		FileInfo[] datastoreFiles = datastores.GetFiles("*-datastores*");
		Log(w,"<SPAN class='heading2'>Datastore Details File Import</SPAN>");
	    foreach (FileInfo datastoreFile in datastoreFiles)
		{
//			datastoreResult="";
			sqlErr="";
			dat=null;
			sqlSuccess=false;
			string infile = "0";
			string[] infileArr = null;
			string sourceVic = "";
			string storeInUse = "";
			string clusterIp = "";
			bool backupStore = false;
			infile = Convert.ToString(datastoreFile);
			Log(w,"<SPAN class='bold'>"+infile+"</SPAN><BR/>");
			datastoreDat=readFile(path+infile,infile.Substring(infile.IndexOf("-")),"~");
//			datastoreDat=readFile(path+infile,infile.Substring(12,infile.Length-16),"~");
			if (datastoreDat!=null)
			{
				infileArr = infile.Split('-');
				sourceVic = infileArr[0].ToString();
				clusterIp = simpleDnsLookup(sourceVic);
				if (clusterIp.Contains("ERROR:"))
				{
					clusterIp="";
					Log(w,clusterIp+"<BR/>");
				}
				else
				{
					clusterIp=break_ip(clusterIp);
				}
				foreach (DataTable dsdt in datastoreDat.Tables)
				{
					foreach (DataRow dsdr in dsdt.Rows)
					{
						sql="";
						dat=null;
						if (fix_csv(dsdr["\"Name\""].ToString()).Contains("backupstore01"))
						{
							backupStore=true;
							Log(w,"<BR/><SPAN class='italic'>Backup Datastore '"+fix_csv(dsdr["\"Name\""].ToString())+"' Skipped by rule...</SPAN><BR/>");
						}
						if (fix_csv(dsdr["\"Name\""].ToString())!=null && fix_csv(dsdr["\"Name\""].ToString())!="" && !backupStore)
						{
							storeInUse="0";
							sql="SELECT * FROM rackspace WHERE VMDatastore='"+fix_fqdn(fix_csv(dsdr["\"Name\""].ToString()))+"'";
							dat=readDb(sql);
							if (!emptyDataset(dat))
							{
								storeInUse="1";
							}
//							sql="SELECT * FROM datastores WHERE name='"+fix_fqdn(fix_csv(dsdr["\"Name\""].ToString()))+"'";
							sql="SELECT * FROM datastores WHERE name='"+fix_csv(dsdr["\"Name\""].ToString())+"'";
							Log(w,sql+"<BR/>");
							dat=readDb(sql);
							if (emptyDataset(dat))
							{
								Log(w,"<SPAN class='italic'>Datastore Not Found, Adding...</SPAN><BR/>");
								sql="INSERT INTO datastores(name,capacityMB,freespaceMB,inUse) VALUES ('"+fix_csv(dsdr["\"Name\""].ToString())+"',"+fix_csv(dsdr["\"CapacityMB\""].ToString())+","+fix_csv(dsdr["\"FreeSpaceMB\""].ToString())+",'"+storeInUse+"')";			
								Log(w,sql);
								sqlErr=writeDb(sql);
								if (sqlErr==null || sqlErr=="")
								{
									Log(w,"<SPAN class='italic'> - VM Datastore Import: Datastore record updated.<BR/></SPAN>");
									sqlSuccess=true;
								}
								else
								{
									Log(w,"<FONT color='red'><SPAN class='italic'> - VM Datastore Import ERROR:"+sqlErr+"</SPAN></SPAN><BR/>");
									writeChangeLog(dateStamp.ToString(), shortSysName+"-VICImport", "VM Datastore Import ERROR:"+sqlErr+"("+sql+")", "E", 4444);
								}	
								if (sqlSuccess) 
								{
									if (sqlErr==null || sqlErr=="")
									{
									}
									else
									{
									}
								}
							}
							else
							{
								Log(w,"<SPAN class='italic'>Updating Datastore ...</SPAN><BR/>");
								sql="UPDATE datastores SET capacityMB="+fix_csv(dsdr["\"CapacityMB\""].ToString())+",freespaceMB="+fix_csv(dsdr["\"FreeSpaceMB\""].ToString())+",inUse='"+storeInUse+"' WHERE name='"+fix_csv(dsdr["\"Name\""].ToString())+"'";		
								Log(w,sql);
								sqlErr=writeDb(sql);
								if (sqlErr==null || sqlErr=="")
								{
									Log(w,"<SPAN class='italic'> - VM Datastore Import: Datastore record updated.<BR/></SPAN>");
									sqlSuccess=true;
								}
								else
								{
									Log(w,"<FONT color='red'><SPAN class='italic'> - VM Datastore Import ERROR:"+sqlErr+"</SPAN></SPAN><BR/>");
										writeChangeLog(dateStamp.ToString(), shortSysName+"-VICImport", "VM Datastore Import ERROR:"+sqlErr+"("+sql+")", "E", 4444);
								}	
								if (sqlSuccess) 
								{
									if (sqlErr==null || sqlErr=="")
									{
									}
									else
									{
									}
								}
							}
						}
					}
					Log(w,"<BR/>");
				}
			}
	    }
		Log(w,"<BR/>");

		
// --Host Import-----------------------------------------------------------------------------------------------------------------
		DirectoryInfo hosts = new DirectoryInfo(@path);
		FileInfo[] hostFiles = hosts.GetFiles("*-hosts*");
		Log(w,"<SPAN class='heading2'>Host Data File Import</SPAN>");
	    foreach (FileInfo hostFile in hostFiles)
		{
//			hostResult="";
			sqlErr="";
			dat=null;
			sqlSuccess=false;
			string infile = "";
			string[] infileArr = null;
			string sourceVic = "";
			string clusterIp = "";
			infile = Convert.ToString(hostFile);
			Log(w,"<SPAN class='bold'>"+infile+"</SPAN><BR/>");
			hostDat=readFile(path+infile,infile.Substring(infile.IndexOf("-")),"~");
//			hostDat=readFile(path+infile,infile.Substring(12,infile.Length-16),"~");
			if (hostDat!=null)
			{
				infileArr = infile.Split('-');
				sourceVic = infileArr[0].ToString();
				clusterIp = simpleDnsLookup(sourceVic);
				if (clusterIp.Contains("ERROR:"))
				{
					clusterIp="";
					Log(w,clusterIp+"<BR/>");
				}
				else
				{
					clusterIp=break_ip(clusterIp);
				}
				foreach (DataTable hdt in hostDat.Tables)
				{
					foreach (DataRow hdr in hdt.Rows)
					{
						sql="";
						dat=null;
						sql="SELECT * FROM servers WHERE serverName='"+fix_fqdn(fix_csv(hdr["\"Name\""].ToString())).ToUpper()+"'";
						dat=readDb(sql);
						if (!emptyDataset(dat))
						{
							if (fix_fqdn(fix_csv(hdr["\"Name\""].ToString())).ToUpper()!=null && fix_fqdn(fix_csv(hdr["\"Name\""].ToString())).ToUpper()!="")
							{
								sql="UPDATE servers SET serverSvcIp='"+clusterIp+"', serverOs='ESX', serverOsBuild=36, serverPurpose='ESX Hypervisor - "+fix_csv(hdr["\"Cluster\""].ToString())+"', memberOfCluster='"+fix_csv(hdr["\"Cluster\""].ToString())+"'  WHERE serverName='"+fix_fqdn(fix_csv(hdr["\"Name\""].ToString())).ToUpper()+"'";				
								Log(w,sql);
								sqlErr=writeDb(sql);
								if (sqlErr==null || sqlErr=="")
								{
									Log(w,"<SPAN class='italic'> - VM Host Import: Server record updated.<BR/></SPAN>");
									sqlSuccess=true;
								}
								else
								{
									Log(w,"<FONT color='red'><SPAN class='italic'> - VMHost Server Record Update ERROR:"+sqlErr+"</SPAN></SPAN><BR/>");
									writeChangeLog(dateStamp.ToString(), shortSysName+"-VICImport", "VMHost Server Record Update ERROR:"+sqlErr+"("+sql+")", "E", 4444);
								}	
								if (sqlSuccess) 
								{
									if (sqlErr==null || sqlErr=="")
									{
									}
									else
									{
									}
								}
							}
							else
							{
							}
						}
					}
					Log(w,"<BR/>");
				}
			}
	    }
		Log(w,"<BR/>");

// --Virtual Server Import----------------------------------------------------------------------------------------------------------------------
		DirectoryInfo vms = new DirectoryInfo(@path);
		FileInfo[] vmFiles = vms.GetFiles("*-vms*");
		Log(w,"<SPAN class='heading2'>VM data file Import</SPAN>");
	    foreach (FileInfo vmFile in vmFiles)
		{
			vmResult="";
			sqlErr="";
			sqlSuccess=false;
			string infile = "";
			string[] infileArr = null;
			string sourceVic = "";
			string mgtIp = "", rackId="";
			infile = Convert.ToString(vmFile);
			Log(w,"<SPAN class='bold'>"+infile+"</SPAN><BR/>");
			vmDat=readFile(path+infile,infile.Substring(infile.IndexOf("-")),"~");
//			vmDat=readFile(path+infile,infile.Substring(12,infile.Length-16),"~");
			if (vmDat!=null)
			{
				infileArr = infile.Split('-');
				sourceVic = infileArr[0].ToString();
				mgtIp = simpleDnsLookup(sourceVic);
				if (mgtIp.Contains("ERROR:"))
				{
					mgtIp="";
					Log(w,mgtIp+"<BR/>");
				}
				else
				{
					mgtIp=break_ip(mgtIp);
				}
				sourceVic=infile.Substring(0,infile.IndexOf("-")+1);
//				sourceVic=infile.Substring(0,12);
				foreach (DataTable vdt in vmDat.Tables)
				{
					foreach (DataRow vdr in vdt.Rows)
					{
						rackId="";
						sql="SELECT rackspaceId, belongsTo FROM rackspace WHERE serial='"+sourceVic+fix_csv(vdr["\"Id\""].ToString())+"'";
						Log(w,sql+"<BR/>");
						rackDat=readDb(sql);
						if (rackDat!=null)
						{
							Log(w,"<SPAN class='italic'> - VM Import: Rackspace Record found for "+sourceVic+fix_csv(vdr["\"Id\""].ToString())+"<BR/></SPAN>");
							try
							{
								rackId=rackDat.Tables[0].Rows[0]["rackspaceId"].ToString();
							}
							catch (System.Exception ex)
							{
								rackId="rackspace.rackspaceId";
							}
							string v_serverName="",v_serverRsaIp="",v_serverLanIp="", v_serverOs="", v_serverOsBuild="", v_serverPurpose="", v_serverPubVlan="", v_rackspaceId="", v_memberOfCluster="", v_role="",v_VMId="", v_VMToolsState="", v_VMPowerState="";
							try
							{
								v_memberOfCluster=rackDat.Tables[0].Rows[0]["belongsTo"].ToString();
							}
							catch (System.Exception ex)
							{
								v_memberOfCluster="rackspace.belongsTo";
							}	
							v_serverName=fix_hostname(fix_csv(vdr["\"Name\""].ToString()));
							if (fix_csv(vdr["\"Hostname\""].ToString())!=null && fix_csv(vdr["\"Hostname\""].ToString())!="")
							{
								int strCompare=fix_fqdn(fix_csv(vdr["\"Hostname\""].ToString())).CompareTo(fix_hostname(fix_csv(vdr["\"Name\""].ToString())));
								Log(w,"strCompare="+strCompare.ToString()+"<BR/>");
								if (strCompare < 0) 
								{
									v_serverName=fix_hostname(fix_csv(vdr["\"Name\""].ToString()));
								}
								else
								{
									v_serverName=fix_fqdn(fix_csv(vdr["\"Hostname\""].ToString()));	
								}							
							}		
							v_serverName=v_serverName.ToUpper();
							
							v_serverRsaIp=mgtIp;
							v_serverLanIp=break_ip(fix_csv(vdr["\"IP Address\""].ToString()));
							if (v_serverLanIp==null || v_serverLanIp=="" || v_serverLanIp.Contains("169.254"))
							{
								if (v_serverName!=null && v_serverName!="")
								{
									try
									{
										v_serverLanIp = simpleDnsLookup(v_serverName);
										if (mgtIp.Contains("ERROR:"))
										{
											v_serverLanIp="";
											Log(w,v_serverLanIp+"<BR/>");
										}
										else
										{
											v_serverLanIp=break_ip(v_serverLanIp);
										}																			
									}
									catch (System.Exception ex)
									{
										Log(w,"ServerName="+v_serverName+"<BR/>");
										Log(w,"ServerLanIp="+v_serverLanIp+"<BR/>");
									}
								}
							}
							else
							{
								if (v_serverLanIp=="0.0.0.0")
								{
									v_serverLanIp="";
								}
							}
							if (v_serverName.Substring(0,2).Contains("SX") || v_serverName.Substring(0,2).Contains("ZX"))
							{
								v_serverOs="Windows";
							}
							else
							{
								v_serverOs="Linux";
							}
							v_serverOsBuild=fix_os(fix_csv(vdr["\"OSFullName\""].ToString()));
							Log(w,"ImportedOsBuild-"+v_serverOsBuild+"[ "+fix_csv(vdr["\"OSFullName\""].ToString())+" ]<BR/>");


							v_serverPurpose=fix_txt(vdr["\"Project\""].ToString());
							if (fix_txt(vdr["\"Function/Role\""].ToString())!=null && fix_txt(vdr["\"Function/Role\""].ToString())!="")
							{
								v_serverPurpose=v_serverPurpose+" "+fix_txt(vdr["\"Function/Role\""].ToString());
							}
							if (fix_txt(vdr["\"Owner\""].ToString())!=null && fix_txt(vdr["\"Owner\""].ToString())!="")
							{
								v_serverPurpose=v_serverPurpose+"("+fix_txt(vdr["\"Owner\""].ToString())+")";
							}
							if (v_serverLanIp!=null && v_serverLanIp!="" && v_serverLanIp.Length>12)
							{
								sql="SELECT name FROM subnets WHERE vlanId='"+v_serverLanIp.Substring(8,3)+"'";
								Log(w,sql+"<BR/>");
								vlanDat=readDb(sql);
								if (vlanDat!=null)
								{
									Log(w,"<SPAN class='italic'> - VM Import: Subnet found for "+v_serverLanIp.Substring(8,3)+"<BR/></SPAN>");
									try
									{
										v_serverPubVlan=vlanDat.Tables[0].Rows[0]["name"].ToString();
									}
									catch (System.Exception ex)
									{
										v_serverPubVlan="subnets.name";
									}							
								}
							}

					// comment following line once Vlan lookup is fixed!
//							v_serverPubVlan="subnetVmware236"; //FOR NITC IMPORT ONLY!!

							v_rackspaceId=rackId;
						
							v_VMId=sourceVic+fix_csv(vdr["\"Id\""].ToString());
							v_role=fix_txt(vdr["\"Function/Role\""].ToString());
							v_VMToolsState=fix_csv(vdr["\"VMToolsState\""].ToString());
							v_VMPowerState=fix_csv(vdr["\"PowerState\""].ToString());
//							sql="SELECT * FROM servers WHERE rackspaceId='"+v_rackspaceId+"'";
							sql="SELECT * FROM servers WHERE serverName='"+v_serverName.ToUpper()+"'";
							Log(w,sql+"<BR/>");
							dat=readDb(sql);
							if (emptyDataset(dat))
							{
								sqlIp="SELECT * FROM servers WHERE serverLanIp='"+v_serverLanIp+"'";
								datIp=readDb(sqlIp);
								Log(w,sqlIp+"<BR/>");
								if (v_serverLanIp=="" || v_serverLanIp==null)
								{
									v_serverLanIp="NULL";
								}
								else
								{
									v_serverLanIp="'"+v_serverLanIp+"'";
								}
								if (datIp!=null)
								{
									Log(w,"DUPLICATE IP<BR/>");
									sql="INSERT INTO servers(serverName, serverRsaIp, serverOs, serverOsBuild, serverPurpose, serverPubVlan, rackspaceId, memberOfCluster, role, VMToolsState, VMPowerState, VMId, VMName) VALUES("			
											+"'"+v_serverName.ToUpper()+ "',"
											+"'"+v_serverRsaIp+"',"
											+"'"+v_serverOs+"',"
											+""+v_serverOsBuild+ ","
											+"'"+v_serverPurpose+"',"
											+"'"+v_serverPubVlan+ "',"
											+""+v_rackspaceId+","
											+"'"+v_memberOfCluster+ "',"
											+"'"+v_role+"',"
											+"'"+v_VMToolsState+ "',"
											+"'"+v_VMPowerState+ "',"
											+"'"+v_VMId+   "',"
											+"'"+fix_csv(vdr["\"Name\""].ToString())+"')";
								}
								else
								{
									sql="INSERT INTO servers(serverName, serverRsaIp, serverLanIp, serverOs, serverOsBuild, serverPurpose, serverPubVlan, rackspaceId, memberOfCluster, role, VMToolsState, VMPowerState, VMId,VMName) VALUES("			
											+"'"+v_serverName.ToUpper()+ "',"
											+"'"+v_serverRsaIp+"',"
											+""+v_serverLanIp+","
											+"'"+v_serverOs+"',"
											+""+v_serverOsBuild+ ","
											+"'"+v_serverPurpose+"',"
											+"'"+v_serverPubVlan+ "',"
											+""+v_rackspaceId+","
											+"'"+v_memberOfCluster+ "',"
											+"'"+v_role+"',"
											+"'"+v_VMToolsState+ "',"
											+"'"+v_VMPowerState+ "',"
											+"'"+v_VMId+   "',"
											+"'"+fix_csv(vdr["\"Name\""].ToString())+"')";
								}							
								
								if (v_serverName!=null && v_serverName!="")
								{
//									dat=readDb("SELECT * FROM servers WHERE ;
//									if (dat=null) // No Existing server by the given name exists ...
//									{
										Log(w,sql+"<BR/>");
										sqlErr=writeDb(sql);
										if (sqlErr==null || sqlErr=="")
										{
											Log(w,"<SPAN class='italic'> - VM Import: Server record added.<BR/></SPAN>");
											sqlSuccess=true;
										}
										else
										{
											Log(w,"<FONT color='red'><SPAN class='italic'> - VM Server Record Addition ERROR:"+sqlErr+"</SPAN></SPAN><BR/>");
											writeChangeLog(dateStamp.ToString(), shortSysName+"-VICImport", "VM Server Record Addition	ERROR:"+sqlErr+"("+sql+")", "E", 4444);
										}	
										if (sqlSuccess) 
										{
											sqlErr="";
											sql="SELECT * FROM "+v_serverPubVlan+" WHERE ipAddr='"+v_serverLanIp+"'";
											Log(w,sql+"<BR/>");
											dat=readDb(sql);
											if (!emptyDataset(dat))
											{
												int isReserved=0;
												isReserved=Convert.ToInt32(dat.Tables[0].Rows[0]["reserved"]);
												if (isReserved==1)
												{
													sql="UPDATE "+v_serverPubVlan+" SET reserved=0, comment='Reservation Cleared by ESMS-VIC Import "+dateStamp.ToString()+"'";
													sqlErr=writeDb(sql);
													Log(w,sql+"<BR/>");
													Log(w,"<SPAN class='italic'> - VM Addition: IP Reservation cleared.<BR/></SPAN>");
												}
											}
											if (sqlErr==null || sqlErr=="")
											{
											}
											else
											{
												Log(w,"<FONT color='red'><SPAN class='italic'> - VM Addition IP Reservation Removal ERROR:"+sqlErr+"</SPAN></SPAN><BR/>");
												writeChangeLog(dateStamp.ToString(), shortSysName+"-VICImport", "VM Addition IP Reservation Removal ERROR:"+sqlErr+"("+sql+")", "E", 4444);
											}
										}
//									}
								}
							}
							else // A VM is already parked on that rackspaceId ...
							{
//								dat=readDb("SELECT * FROM servers WHERE serverName='"+v_serverName.ToUpper()+"'");
								if (v_serverName!=null && v_serverName!="")
								{
									if (v_serverLanIp=="" || v_serverLanIp==null)
									{
										v_serverLanIp="NULL";
									}
									else
									{
										v_serverLanIp="'"+v_serverLanIp+"'";
									}
									sql="UPDATE servers SET serverName='"+v_serverName.ToUpper()+"', serverRsaIp='"+v_serverRsaIp+"', serverLanIp="+v_serverLanIp+", serverOs='"+v_serverOs+"', serverOsBuild="+v_serverOsBuild+", serverPurpose='"+v_serverPurpose+"', serverPubVlan='"+v_serverPubVlan+"',  memberOfCluster='"+v_memberOfCluster+"', role='"+v_role+"', VMToolsState='"+v_VMToolsState+"', VMPowerState='"+v_VMPowerState+"', VMId ='"+fix_csv(vdr["\"Id\""].ToString())+"',VMName='"+fix_csv(vdr["\"Name\""].ToString())+"' WHERE rackspaceId="+v_rackspaceId;
									Log(w,sql);
									sqlErr=writeDb(sql);
									if (sqlErr==null || sqlErr=="")
									{
										Log(w,"<SPAN class='italic'> - VM Import: Server record updated.<BR/></SPAN>");
										sqlSuccess=true;
									}
									else
									{
										Log(w,"<FONT color='red'><SPAN class='italic'> - VM Server Record Update ERROR:"+sqlErr+"</SPAN></SPAN><BR/>");
										writeChangeLog(dateStamp.ToString(), shortSysName+"-VICImport", "VM Server Record Update ERROR:"+sqlErr+"("+sql+")", "E", 4444);
									}	
									if (sqlSuccess) 
									{
										sqlErr="";
										sql="SELECT * FROM "+v_serverPubVlan+" WHERE ipAddr='"+v_serverLanIp+"'";
										Log(w,sql+"<BR/>");
										dat=readDb(sql);
										if (!emptyDataset(dat))
										{
											int isReserved=0;
											isReserved=Convert.ToInt32(dat.Tables[0].Rows[0]["reserved"]);
											if (isReserved==1)
											{
												sql="UPDATE "+v_serverPubVlan+" SET reserved=0, comment=''";
												sqlErr=writeDb(sql);
												Log(w,sql+"<BR/>");
												Log(w,"<SPAN class='italic'> - VM Update: IP Reservation cleared.<BR/></SPAN>");
											}
										}
										if (sqlErr==null || sqlErr=="")
										{
										}
										else
										{
											Log(w,"<FONT color='red'><SPAN class='italic'> - VM Update IP Reservation Removal ERROR:"+sqlErr+"</SPAN></SPAN><BR/>");
											writeChangeLog(dateStamp.ToString(), shortSysName+"-VICImport", "VM Update IP Reservation Removal ERROR:"+sqlErr+"("+sql+")", "E", 4444);
										}
									}
								}
							}
						}
						string v_vmhost="", v_sysdiskqty="", v_sysdisksize="", v_datadiskqty="", v_datadisksize="", v_eth0mac="", v_ram="", v_cpuqty="";

						v_vmhost=fix_fqdn(fix_csv(vdr["\"VMHost\""].ToString()));
						v_sysdisksize=fix_diskSize(fix_csv(vdr["\"SysDiskSize\""].ToString())); 
						v_datadisksize=fix_diskSize(fix_csv(vdr["\"DataDiskSize\""].ToString())); 
						v_ram=fix_ram(fix_csv(vdr["\"MemoryMB\""].ToString()));
						
						if (v_sysdisksize!=null && v_sysdisksize!="" && v_sysdisksize!="NULL")
						{
							v_sysdiskqty="1";
						}
						if (v_sysdisksize=="NULL")
						{
							v_sysdiskqty="NULL";
						}
						if (v_datadisksize!=null && v_datadisksize!="" && v_sysdisksize!="NULL")
						{
							v_datadiskqty="1";
						}
						if (v_datadisksize=="NULL")
						{
							v_datadiskqty="NULL";
						}						
						v_eth0mac=fix_csv(vdr["\"Eth0Mac\""].ToString()); 
						
						v_cpuqty=fix_csv(vdr["\"NumCPU\""].ToString());

						if (fix_csv(vdr["\"Id\""].ToString())!=null && fix_csv(vdr["\"Id\""].ToString())!="")
						{
							sql="UPDATE rackspace SET VMHost='"+v_vmhost+"', sys_disk_qty="+v_sysdiskqty+", sys_disk_size="+v_sysdisksize+", data_disk_qty="+v_datadiskqty+", data_disk_size="+v_datadisksize+", eth0mac='"+v_eth0mac+"', ram="+v_ram+", cpu_cores='1', cpu_type='ESX vCPU', cpu_qty="+v_cpuqty+" WHERE serial='"+sourceVic+fix_csv(vdr["\"Id\""].ToString())+"'";					
							Log(w,sql);
							sqlErr=writeDb(sql);
							if (sqlErr==null || sqlErr=="")
							{
								Log(w,"<SPAN class='italic'> - VM Import: Rackspace Table Updated.<BR/></SPAN>");
								sqlSuccess=true;
							}
							else
							{
								Log(w,"<FONT color='red'><SPAN class='italic'> - VM Rackspace Update ERROR:"+sqlErr+"</SPAN></SPAN><BR/>");
								writeChangeLog(dateStamp.ToString(), shortSysName+"-VICImport", "VM Rackspace Update ERROR:"+sqlErr+"("+sql+")", "E", 4444);
							}	
							if (sqlSuccess) 
							{
								if (sqlErr==null || sqlErr=="")
								{
								}
								else
								{
								}
							}
						}	
						Log(w,"<BR/>");
					}
					Log(w,"<BR/>");
				}
			}
	    }
		Log(w,"<BR/>");



// --VMTools and Disk Usage Import--------------------------------------------------------------------------------------------------------------
		DirectoryInfo vmtools = new DirectoryInfo(@path);
		FileInfo[] vmtoolsFiles = vmtools.GetFiles("*-vmtools*");
		Log(w,"<SPAN class='heading2'>VMTools and Disk Usage Data File Import</SPAN>");
	    foreach (FileInfo vmtoolsFile in vmtoolsFiles)
		{
//			hostResult="";
			sqlErr="";
			dat=null;
			sqlSuccess=false;
			string infile = "";
			string[] infileArr = null;
			string sourceVic = "";
			string clusterIp = "";
			string destRackId ="";
			 
			infile = Convert.ToString(vmtoolsFile);
			Log(w,"<SPAN class='bold'>"+infile+"</SPAN><BR/>");
			vmtoolsDat=readFile(path+infile,infile.Substring(infile.IndexOf("-")),"~");
//			vmtoolsDat=readFile(path+infile,infile.Substring(12,infile.Length-16),"~");
			if (vmtoolsDat!=null)
			{
				string v_serverName="", v_toolsVer="", v_sysDiskPath="", v_dataDiskPath="", v_sysDiskCap="", v_dataDiskCap="", v_sysDiskFree="", v_dataDiskFree="";
				infileArr = infile.Split('-');
				sourceVic = infileArr[0].ToString();
				clusterIp = simpleDnsLookup(sourceVic);
				if (clusterIp.Contains("ERROR:"))
				{
					clusterIp="";
					Log(w,clusterIp+"<BR/>");
				}
				else
				{
					clusterIp=break_ip(clusterIp);
				}
				sourceVic=infile.Substring(0,infile.IndexOf("-")+1);
//				sourceVic=infile.Substring(0,12);
				foreach (DataTable vmtdt in vmtoolsDat.Tables)
				{
					foreach (DataRow vmtdr in vmtdt.Rows)
					{
						v_serverName=fix_hostname(fix_csv(vmtdr["\"Name\""].ToString()));
						if (fix_csv(vmtdr["\"FQDN\""].ToString())!=null && fix_csv(vmtdr["\"FQDN\""].ToString())!="")
						{
							int strCompare=fix_fqdn(fix_csv(vmtdr["\"FQDN\""].ToString())).CompareTo(fix_hostname(fix_csv(vmtdr["\"Name\""].ToString())));
//							Log(w,"strCompare="+strCompare.ToString()+"<BR/>");
							if (strCompare < 0) 
							{
								v_serverName=fix_hostname(fix_csv(vmtdr["\"Name\""].ToString()));
							}
							else
							{
								v_serverName=fix_fqdn(fix_csv(vmtdr["\"FQDN\""].ToString()));	
							}							
						}	
						v_toolsVer=fix_csv(vmtdr["\"ToolsVer\""].ToString());
						v_sysDiskPath=fix_csv(vmtdr["\"Disk0path\""].ToString());
						try
						{
							v_dataDiskPath=fix_csv(vmtdr["\"Disk1path\""].ToString());
						}
						catch (System.Exception ex)
						{
							v_dataDiskPath="";
						}
						
						v_sysDiskCap=fix_csv(vmtdr["\"Disk0Capacity(MB)\""].ToString());
						try
						{
							v_dataDiskCap=fix_csv(vmtdr["\"Disk1Capacity(MB)\""].ToString());
						}
						catch (System.Exception ex)
						{
							v_dataDiskCap="";
						}

						v_sysDiskFree=fix_csv(vmtdr["\"Disk0FreeSpace(MB)\""].ToString());
						try
						{
							v_dataDiskFree=fix_csv(vmtdr["\"Disk1FreeSpace(MB)\""].ToString());
						}
						catch (System.Exception ex)
						{
							v_dataDiskFree="";
						}

						if (v_toolsVer=="")
						{
							v_toolsVer="0";
						}
						if (v_sysDiskCap=="")
						{
							v_sysDiskCap="0";
						}
						if (v_dataDiskCap=="")
						{
							v_dataDiskCap="0";
						}
						if (v_sysDiskFree=="")
						{
							v_sysDiskFree="0";
						}
						if (v_dataDiskFree=="")
						{
							v_dataDiskFree="0";
						}


						sql="";
						dat=null;
						Log(w,v_serverName.ToUpper()+"("+fix_csv(vmtdr["\"Name\""].ToString())+")<BR/>");
						sql="SELECT * FROM servers WHERE serverName='"+v_serverName.ToUpper()+"'";
						Log(w,sql+"<BR/>");
						dat=readDb(sql);
						if (!emptyDataset(dat))
						{
							destRackId=dat.Tables[0].Rows[0]["rackspaceId"].ToString();
							if (destRackId!=null && destRackId!="")
							{
								sql="UPDATE servers SET VMToolsVersion="+v_toolsVer+", VMSysDiskPath='"+v_sysDiskPath+"', VMDataDiskPath='"+v_dataDiskPath+"', VMSysDiskCapMB="+v_sysDiskCap+", VMDataDiskCapMB="+v_dataDiskCap+", VMSysDiskFreeMB="+v_sysDiskFree+", VMDataDiskFreeMB="+v_dataDiskFree+" WHERE rackspaceId="+destRackId;				
								Log(w,sql);
								sqlErr=writeDb(sql);
								if (sqlErr==null || sqlErr=="")
								{
									Log(w,"<SPAN class='italic'> - VMTools Import: Server record updated.<BR/><BR/></SPAN>");
									sqlSuccess=true;
								}
								else
								{
									Log(w,"<FONT color='red'><SPAN class='italic'> - VMTools Server Record Update ERROR:"+sqlErr+"</SPAN></SPAN><BR/>");
									writeChangeLog(dateStamp.ToString(), shortSysName+"-VICImport", "VMTools Server Record Update ERROR:"+sqlErr+"("+sql+")", "E", 4444);
								}	
								if (sqlSuccess) 
								{
									if (sqlErr==null || sqlErr=="")
									{
									}
									else
									{
									}
								}
							}
							else
							{
								Log(w,"<FONT color='red'><SPAN class='italic'> - VMTools Server Record Update ERROR: Could not find "+v_serverName.ToUpper()+"</SPAN></SPAN><BR/>");
								writeChangeLog(dateStamp.ToString(), shortSysName+"-VICImport", "VMTools Server Record Update ERROR: Could not find "+v_serverName.ToUpper(), "E", 4444);
							}
						}
					}
					Log(w,"<BR/>");
				}
			}
	    }
		Log(w,"<BR/>");


// --Snapshots Import----------------------------------------------------------------------------------------------------------------------
		DirectoryInfo snaps = new DirectoryInfo(@path);
		FileInfo[] snapFiles = snaps.GetFiles("*-snaps*");
		Log(w,"<SPAN class='heading2'>Snapshot data file Import</SPAN>");
	    foreach (FileInfo snapFile in snapFiles)
		{
//			Import the snapshot information - Convert.ToString(file)
			snapResult="";
			sqlErr="";
			sqlSuccess=false;
			string infile = "";
			string sourceVic = "";
			infile = Convert.ToString(snapFile);
			Log(w,"<SPAN class='bold'>"+infile+"</SPAN><BR/>");
			snapDat=readFile(path+infile,infile.Substring(infile.IndexOf("-")),"~");	
//			snapDat=readFile(path+infile,infile.Substring(12,infile.Length-16),"~");
			if (snapDat!=null)
			{
				sourceVic=infile.Substring(0,infile.IndexOf("-")+1);
//				sourceVic=infile.Substring(0,12);
				foreach (DataTable sdt in snapDat.Tables)
				{
					foreach (DataRow sdr in sdt.Rows)
					{
						sql="SELECT * from snapshots WHERE snapId='"+fix_csv(sdr["\"Id\""].ToString())+"'";
						dat=readDb(sql);
						if (emptyDataset(dat))
						{
							if (fix_csv(sdr["\"Id\""].ToString())!=null && fix_csv(sdr["\"Id\""].ToString())!="")
							{
								sql="INSERT INTO snapshots(snapId, vmName, snapDesc, created) VALUES("							
										+"'"+sourceVic+fix_csv(sdr["\"Id\""].ToString())+ "',"
										+"'"+fix_csv(sdr["\"VM\""].ToString())+"',"
										+"'"+fix_csv(sdr["\"Name\""].ToString())+"',"
										+"'"+fix_csv(sdr["\"Created\""].ToString())+"')";
								Log(w,sql);
								sqlErr=writeDb(sql);
								if (sqlErr==null || sqlErr=="")
								{
									Log(w,"<SPAN class='italic'> - Snapshot Import: Snapshot record added.<BR/></SPAN>");
									sqlSuccess=true;
								}
								else
								{
									Log(w,"<FONT color='red'><SPAN class='italic'> - Snapshot Record Addition ERROR:"+sqlErr+"</SPAN></SPAN><BR/>");
									writeChangeLog(dateStamp.ToString(), shortSysName+"-VICImport", "Snapshot Record Addition ERROR:"+sqlErr+"("+sql+")", "E", 4444);
								}	
								if (sqlSuccess) 
								{
									if (sqlErr==null || sqlErr=="")
									{
									}
									else
									{
									}
								}
							}
						}
						else
						{
							if (fix_csv(sdr["\"Id\""].ToString())!=null && fix_csv(sdr["\"Id\""].ToString())!="" && fix_csv(sdr["\"Name\""].ToString())!=null && fix_csv(sdr["\"Name\""].ToString())!="")
							{
								sql="UPDATE snapshots SET snapId='"+infile.Substring(0,infile.IndexOf("-"))+fix_csv(sdr["\"Id\""].ToString())+"', vmName='"+fix_csv(sdr["\"VM\""].ToString())+"', snapDesc='"+fix_csv(sdr["\"Name\""].ToString())+"', created='"+fix_csv(sdr["\"Created\""].ToString())+"', WHERE snapId='"+infile.Substring(0,infile.IndexOf("-"))+fix_csv(sdr["\"Id\""].ToString())+"' AND snapDesc='"+fix_csv(sdr["\"Name\""].ToString())+"'";
//								sql="UPDATE snapshots SET snapId='"+infile.Substring(0,12)+fix_csv(sdr["\"Id\""].ToString())+"', vmName='"+fix_csv(sdr["\"VM\""].ToString())+"', snapDesc='"+fix_csv(sdr["\"Name\""].ToString())+"', created='"+fix_csv(sdr["\"Created\""].ToString())+"', WHERE snapId='"+infile.Substring(0,12)+fix_csv(sdr["\"Id\""].ToString())+"' AND snapDesc='"+fix_csv(sdr["\"Name\""].ToString())+"'";
								Log(w,sql);
								sqlErr=writeDb(sql);
								if (sqlErr==null || sqlErr=="")
								{
									Log(w,"<SPAN class='italic'> - Snapshot Import: Snapshot record updated.<BR/></SPAN>");
									sqlSuccess=true;
								}
								else
								{
									Log(w,"<FONT color='red'><SPAN class='italic'> - Snapshot Record Update ERROR:"+sqlErr+"</SPAN></SPAN><BR/>");
									writeChangeLog(dateStamp.ToString(), shortSysName+"-VICImport", "Snapshot Record Update ERROR:"+sqlErr+"("+sql+")", "E", 4444);
								}	
								if (sqlSuccess) 
								{
									if (sqlErr==null || sqlErr=="")
									{
									}
									else
									{										
									}
								}
							}
						}
						Log(w,"<BR/>");
					}
				}
			}
	    }


// --Snapshots SizeMB Import----------------------------------------------------------------------------------------------------------------------
		DirectoryInfo snapDisks = new DirectoryInfo(@path);
		FileInfo[] snapDiskFiles = snapDisks.GetFiles("*-snapFileSize*");
		Log(w,"<SPAN class='heading2'>Snapshot File Size Import</SPAN>");
	    foreach (FileInfo snapDisk in snapDiskFiles)
		{
//			ALTER TABLE snapshots ALTER COLUMN sizeOnDisk single
//			Import the snapshot disk size information - Convert.ToString(file)
			snapResult="";
			sqlErr="";
			sqlSuccess=false;
			string infile = "";
			string sourceVic = "";
			infile = Convert.ToString(snapDisk);
			Log(w,"<SPAN class='bold'>"+infile+"</SPAN><BR/>");
			snapDat=readFile(path+infile,infile.Substring(infile.IndexOf("-")),"~");
//			snapDat=readFile(path+infile,infile.Substring(12,infile.Length-16),"~");
			Log(w,path+infile+","+infile.Substring(infile.IndexOf("-"))+"<BR/>");
			if (snapDat!=null)
			{
				sourceVic=infile.Substring(0,infile.IndexOf("-")+1);
//				sourceVic=infile.Substring(0,12);
				foreach (DataTable sdt in snapDat.Tables)
				{
					foreach (DataRow sdr in sdt.Rows)
					{
						sql="SELECT * FROM snapshots WHERE snapId='"+infile.Substring(0,infile.IndexOf("-")+1)+fix_csv(sdr["\"Id\""].ToString())+"'";
//						sql="SELECT * from snapshots WHERE snapId='"+infile.Substring(0,12)+fix_csv(sdr["\"Id\""].ToString())+"'";
						Log(w,sql+"<BR/>");
						dat=readDb(sql);
						if (!emptyDataset(dat))
						{
							if (fix_csv(sdr["\"Id\""].ToString())!=null && fix_csv(sdr["\"Id\""].ToString())!="")
							{
								sql="UPDATE snapshots SET sizeOnDisk="+fix_csv(sdr["\"SizeMB\""].ToString())+" WHERE snapId='"+infile.Substring(0,infile.IndexOf("-")+1)+fix_csv(sdr["\"Id\""].ToString())+"'";
//								sql="UPDATE snapshots SET sizeOnDisk="+fix_csv(sdr["\"SizeMB\""].ToString())+" WHERE snapId='"+infile.Substring(0,12)+fix_csv(sdr["\"Id\""].ToString())+"'";
								Log(w,sql);
								sqlErr=writeDb(sql);
								if (sqlErr==null || sqlErr=="")
								{
									Log(w,"<SPAN class='italic'> - Snapshot Import: Snapshot record 'sizeOnDisk' Update.<BR/></SPAN>");
									sqlSuccess=true;
								}
								else
								{
									Log(w,"<FONT color='red'><SPAN class='italic'> - Snapshot Record Update (sizeOnDisk) ERROR:"+sqlErr+"</SPAN></SPAN><BR/>");
									writeChangeLog(dateStamp.ToString(), shortSysName+"-VICImport", "Snapshot Record Update (sizeOnDisk) ERROR:"+sqlErr+"("+sql+")", "E", 4444);
								}	
								if (sqlSuccess) 
								{
									if (sqlErr==null || sqlErr=="")
									{
									}
									else
									{
									}
								}
							}
						}
						Log(w,"<BR/>");
					}
				}
			}
	    }

// --Compact &amp; Finish----------------------------------------------------------------------------------------------------------------------
		sqlErr=compactDB();
		Log(w,"Compact and Repair Result:"+sqlErr); 
		Log(w,CleanLogs(path+relative));
    }


	if (IsPostBack)
	{
	}

	CloseLog(w);
	w.Close();
	Response.Write("Import COMPLETED!  Logfile is at "+path+relative+logFile);
//	Server.MapPath("./vmware/logs/"+logFile);
//	Response.Redirect(path+relative+logFile);
}


</SCRIPT>
</HEAD>

<!--#include file="body.inc" -->



</BODY>
</HTML>