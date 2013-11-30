<%@Page Inherits="CIS.conspectisLibrary" src="conspectisLibrary.cs" Language="C#" debug="true" %>
<%@Import Namespace="System.Data"%>
<%@Import Namespace="System.Xml"%>
<%@Import Namespace="System.IO"%>
<%@Import Namespace="System"%>

<!DOCTYPE html>
<!-- HTML5 Status: VALID 2-12-13 CK -->
<!--[if lt IE 7 ]> <html lang='en' class='no-js ie6'> <![endif]-->
<!--[if IE 7 ]>    <html lang='en' class='no-js ie7'> <![endif]-->
<!--[if IE 8 ]>    <html lang='en' class='no-js ie8'> <![endif]-->
<!--[if IE 9 ]>    <html lang='en' class='no-js ie9'> <![endif]-->
<!--[if (gt IE 9)|!(IE)]><!--> <html lang='en' class='no-js'> <!--<![endif]-->

<HEAD runat="server">

<!--#include file="header.inc"-->

<SCRIPT runat="server">
void testDb(Object s, EventArgs e) 
{
	Response.Write("testDb");
}

void reviseDbFields(Object s, EventArgs e) 
{
	Response.Write("reviseDbFields");
}

void goSubmit(Object s, EventArgs e) 
{
	Response.Write("goSubmit");
}

void changeDefaultPass(Object s, EventArgs e) 
{
	Response.Write("changeDefaultPass");
}

public void Page_Load(Object o, EventArgs e)
{
//UNCOMMENT this line to force login to access this page.

	Page.Header.Title=shortSysName+": Installation Configuration";


	DateTime dateStamp = DateTime.Now;
	string v_username, curStat="";
	string uri="", query="", queryOptions="", sql="";
	DataSet dat=new DataSet();
	DataSet dat1=new DataSet();

	try
	{
		v_username=Request.Cookies["username"].Value;
	}
	catch (System.Exception ex)
	{
		v_username="";
	}

	sql="SELECT * FROM sysStat WHERE id=2";
	dat=readDb(sql);
	dat=null;
	if (!emptyDataset(dat))
	{
		Response.Redirect("adminConfig.aspx");
	}

	titleSpan.InnerHtml=shortSysName+" Application Initial Configuration";
	subBtnTitle.InnerHtml="Save Settings and Continue";

	sql="SELECT comment FROM sysStat WHERE id=3 AND code='1'"; //Check VMWare Module Existence
	dat=readDb(sql);
	if (!emptyDataset(dat))
	{
		if (availModules.Contains(Decrypt(dat.Tables[0].Rows[0]["comment"].ToString())))
		{
			sql="SELECT * FROM sysStat WHERE comment LIKE 'modVmw%'";
			dat1=readDb(sql);
			if (!emptyDataset(dat1))
			{
			}
		}
	}

	sql="SELECT comment FROM sysStat WHERE id=4 AND code='1'"; //Check VirtualBox Module Existence
	dat=readDb(sql);
	if (!emptyDataset(dat))
	{
		if (availModules.Contains(Decrypt(dat.Tables[0].Rows[0]["comment"].ToString())))
		{
			sql="SELECT * FROM sysStat WHERE comment LIKE 'modVbox%'";
			dat1=readDb(sql);
			if (!emptyDataset(dat1))
			{
			}
		}
	}

	sql="SELECT comment FROM sysStat WHERE id=5 AND code='1'"; //Check TADDM Module Existence
	dat=readDb(sql);
	if (!emptyDataset(dat))
	{
		if (availModules.Contains(Decrypt(dat.Tables[0].Rows[0]["comment"].ToString())))
		{
			sql="SELECT * FROM sysStat WHERE comment LIKE 'modTadm%'";
			dat1=readDb(sql);
			if (!emptyDataset(dat1))
			{
			}
		}
	}

	sql="SELECT comment FROM sysStat WHERE id=6 AND code='1'"; //Check JIRA Module Existence
	dat=readDb(sql);
	if (!emptyDataset(dat))
	{
		if (availModules.Contains(Decrypt(dat.Tables[0].Rows[0]["comment"].ToString())))
		{
			sql="SELECT * FROM sysStat WHERE comment LIKE 'modJira%'";
			dat1=readDb(sql);
			if (!emptyDataset(dat1))
			{
			}
		}
	}

	sql="SELECT comment FROM sysStat WHERE id=7 AND code='1'"; //As Yet Undefined Module
	dat=readDb(sql);
	if (!emptyDataset(dat))
	{
		if (availModules.Contains(Decrypt(dat.Tables[0].Rows[0]["comment"].ToString())))
		{
			sql="SELECT * FROM sysStat WHERE comment LIKE 'modTBD1%'";
			dat1=readDb(sql);
			if (!emptyDataset(dat1))
			{
			}
		}
	}

	sql="SELECT comment FROM sysStat WHERE id=8 AND code='1'"; //As Yet Undefined Module
	dat=readDb(sql);
	if (!emptyDataset(dat))
	{
		if (availModules.Contains(Decrypt(dat.Tables[0].Rows[0]["comment"].ToString())))
		{
			sql="SELECT * FROM sysStat WHERE comment LIKE 'modTBD2%'";
			dat1=readDb(sql);
			if (!emptyDataset(dat1))
			{
			}
		}
	}

	sql="SELECT comment FROM sysStat WHERE id=9 AND code='1'"; //As Yet Undefined Module
	dat=readDb(sql);
	if (!emptyDataset(dat))
	{
		if (availModules.Contains(Decrypt(dat.Tables[0].Rows[0]["comment"].ToString())))
		{
			sql="SELECT * FROM sysStat WHERE comment LIKE 'modTBD3%'";
			dat1=readDb(sql);
			if (!emptyDataset(dat1))
			{
			}
		}
	}

	sql="SELECT comment FROM sysStat WHERE id=10 AND code='1'"; //As Yet Undefined Module
	dat=readDb(sql);
	if (!emptyDataset(dat))
	{
		if (availModules.Contains(Decrypt(dat.Tables[0].Rows[0]["comment"].ToString())))
		{
			sql="SELECT * FROM sysStat WHERE comment LIKE 'modTBD4%'";
			dat1=readDb(sql);
			if (!emptyDataset(dat1))
			{
			}
		}
	}

	string webconfSysName = "";
	string webconfSysShtName = "";
	string webconfSysUrl = "";
	string webconfAppVDir = "";

	string webconfDbType = "";

	string webconfOleDbProv = "";
	string webconfOleDbFile = "";
	string webconOleDbPath = "";
	string webconfOleDbOpt = "";

	string webconfSqlDbSvr = "";
	string webconfSqlDbName = "";
	string webconfSqlDbUser = "";
	string webconfSqlDbPass = "";
	string webconfSqlDbOpt = "";

	string webconfOraDbSvr = "";
	string webconfOraDbInst = "";
	string webconfOraDbSvc = "";
	string webconfOraDbUser = "";
	string webconfOraDbPass = "";
	string webconfOraDbOpt = "";

	string webconfOdbcDbDsn = "";
	string webconfOdbcDbUser = "";
	string webconfOdbcDbPass = "";
	string webconfOdbcDbOpt = "";

	string webconfEncPhrase = "";
	string webconfEncSalt = "";
	string webconfEncAlgo = "";
	string webconfEncIts = "";
	string webconfEncInitVect = "";
	string webconfEncKeySize = "";
	string webconfCipherPrefix = "";

	string webconfMailerGtwy = "";
	string webconfMailerFrom = "";
	string webconfForcedMailerTo = "";
	string webconfForcedMailerCc = "";
	string webconfForcedMailerBcc = "";
	string webconfEmailConfLDAP = "";
	string webconfEmailConfBaseDN = "";

	string webconfVicServer = "";
	string webconfVicUser = "";
	string webconfVicPass = "";
	string webconfVicDatacenter = "";
	string webconfVicCluster = "";

	string webconfAuthLDAP = "";
	string webconfAuthBaseDN = "";
	string webconfAuthUserDN = "";
	string webconfAuthBindDN = "";
	string webconfADUsersGroup = "";
	string webconfADAdminsGroup = "";
	string webconfADSuperGroup = "";
	string webconfADWoDUsersGroup = "";
	string webconfADWoDAdminsGroup = "";

	string webconfDNSSearchOrder = "";
		
	System.Configuration.Configuration rootWebConfig1 = System.Web.Configuration.WebConfigurationManager.OpenWebConfiguration(null);
	if (iisAppVdir!="")
	{
		rootWebConfig1 = System.Web.Configuration.WebConfigurationManager.OpenWebConfiguration("/"+iisAppVdir);
	}
	status.InnerHtml="/"+iisAppVdir;
//	status.InnerHtml=rootWebConfig1.ToString();
	
	if (rootWebConfig1.AppSettings.Settings.Count > 0)
	{
		System.Configuration.KeyValueConfigurationElement webconfSysNameElem = rootWebConfig1.AppSettings.Settings["systemName"];
		if (webconfSysNameElem!=null) webconfSysName = webconfSysNameElem.Value;
		System.Configuration.KeyValueConfigurationElement webconfSysShtNameElem = rootWebConfig1.AppSettings.Settings["systemShortName"];
		if (webconfSysShtNameElem!=null) webconfSysShtName = webconfSysShtNameElem.Value;
		System.Configuration.KeyValueConfigurationElement webconfSysUrlElem = rootWebConfig1.AppSettings.Settings["systemURL"];
		if (webconfSysUrlElem!=null) webconfSysUrl = webconfSysUrlElem.Value;
		System.Configuration.KeyValueConfigurationElement webconfAppVDirElem = rootWebConfig1.AppSettings.Settings["iisAppName"];
		if (webconfAppVDirElem!=null) webconfAppVDir = webconfAppVDirElem.Value;

		System.Configuration.KeyValueConfigurationElement webconfDbTypeElem = rootWebConfig1.AppSettings.Settings["db_type"];
		if (webconfDbTypeElem!=null) webconfDbType = webconfDbTypeElem.Value;

		System.Configuration.KeyValueConfigurationElement webconfOleDbProvElem = rootWebConfig1.AppSettings.Settings["db_OleDbProv"];
		if (webconfOleDbProvElem!=null) webconfOleDbProv = webconfOleDbProvElem.Value;
		System.Configuration.KeyValueConfigurationElement webconfOleDbFileElem = rootWebConfig1.AppSettings.Settings["db_OleDbFile"];
		if (webconfOleDbFileElem!=null) webconfOleDbFile = webconfOleDbFileElem.Value;
		System.Configuration.KeyValueConfigurationElement webconOleDbPathElem = rootWebConfig1.AppSettings.Settings["db_OleDbPath"];
		if (webconOleDbPathElem!=null) webconOleDbPath = webconOleDbPathElem.Value;
		System.Configuration.KeyValueConfigurationElement webconfOleDbOptElem = rootWebConfig1.AppSettings.Settings["db_OleDbOptions"];
		if (webconfOleDbOptElem!=null) webconfOleDbOpt = webconfOleDbOptElem.Value;

		System.Configuration.KeyValueConfigurationElement webconfSqlDbSvrElem = rootWebConfig1.AppSettings.Settings["db_SqlDbServer"];
		if (webconfSqlDbSvrElem!=null) webconfSqlDbSvr = webconfSqlDbSvrElem.Value;
		System.Configuration.KeyValueConfigurationElement webconfSqlDbNameElem = rootWebConfig1.AppSettings.Settings["db_SqlDbName"];
		if (webconfSqlDbNameElem!=null) webconfSqlDbName = webconfSqlDbNameElem.Value;
		System.Configuration.KeyValueConfigurationElement webconfSqlDbUserElem = rootWebConfig1.AppSettings.Settings["db_SqlDbUser"];
		if (webconfSqlDbUserElem!=null) webconfSqlDbUser = webconfSqlDbUserElem.Value;
		System.Configuration.KeyValueConfigurationElement webconfSqlDbPassElem = rootWebConfig1.AppSettings.Settings["db_SqlDbPass"];
		if (webconfSqlDbPassElem!=null) webconfSqlDbPass = webconfSqlDbPassElem.Value;
		System.Configuration.KeyValueConfigurationElement webconfSqlDbOptElem = rootWebConfig1.AppSettings.Settings["db_SqlDbOptions"];
		if (webconfSqlDbOptElem!=null) webconfSqlDbOpt = webconfSqlDbOptElem.Value;
	
		System.Configuration.KeyValueConfigurationElement webconfOraDbSvrElem = rootWebConfig1.AppSettings.Settings["db_OracleDbServer"];
		if (webconfOraDbSvrElem!=null) webconfOraDbSvr = webconfOraDbSvrElem.Value;
		System.Configuration.KeyValueConfigurationElement webconfOraDbInstElem = rootWebConfig1.AppSettings.Settings["db_OracleDbInstance"];
		if (webconfOraDbInstElem!=null) webconfOraDbInst = webconfOraDbInstElem.Value;
		System.Configuration.KeyValueConfigurationElement webconfOraDbSvcElem = rootWebConfig1.AppSettings.Settings["db_OracleDbService"];
		if (webconfOraDbSvcElem!=null) webconfOraDbSvc = webconfOraDbSvcElem.Value;
		System.Configuration.KeyValueConfigurationElement webconfOraDbUserElem = rootWebConfig1.AppSettings.Settings["db_OracleDbUser"];
		if (webconfOraDbUserElem!=null) webconfOraDbUser = webconfOraDbUserElem.Value;
		System.Configuration.KeyValueConfigurationElement webconfOraDbPassElem = rootWebConfig1.AppSettings.Settings["db_OracleDbPass"];
		if (webconfOraDbPassElem!=null) webconfOraDbPass = webconfOraDbPassElem.Value;
		System.Configuration.KeyValueConfigurationElement webconfOraDbOptElem = rootWebConfig1.AppSettings.Settings["db_OracleDbOptions"];
		if (webconfOraDbOptElem!=null) webconfOraDbOpt = webconfOraDbOptElem.Value;

		System.Configuration.KeyValueConfigurationElement webconfOdbcDbDsnElem = rootWebConfig1.AppSettings.Settings["db_OdbcDbDsn"];
		if (webconfOdbcDbDsnElem!=null) webconfOdbcDbDsn = webconfOdbcDbDsnElem.Value;
		System.Configuration.KeyValueConfigurationElement webconfOdbcDbUserElem = rootWebConfig1.AppSettings.Settings["db_OdbcDbUser"];
		if (webconfOdbcDbUserElem!=null) webconfOdbcDbUser = webconfOdbcDbUserElem.Value;
		System.Configuration.KeyValueConfigurationElement webconfOdbcDbPassElem = rootWebConfig1.AppSettings.Settings["db_OdbcDbPass"];
		if (webconfOdbcDbPassElem!=null) webconfOdbcDbPass = webconfOdbcDbPassElem.Value;
		System.Configuration.KeyValueConfigurationElement webconfOdbcDbOptElem = rootWebConfig1.AppSettings.Settings["db_OdbcDbOptions"];
		if (webconfOdbcDbOptElem!=null) webconfOdbcDbOpt = webconfOdbcDbOptElem.Value;

		System.Configuration.KeyValueConfigurationElement webconfEncPhraseElem = rootWebConfig1.AppSettings.Settings["encryptPhrase"];
		if (webconfEncPhraseElem!=null) webconfEncPhrase = webconfEncPhraseElem.Value;
		System.Configuration.KeyValueConfigurationElement webconfEncSaltElem = rootWebConfig1.AppSettings.Settings["encryptSalt"];
		if (webconfEncSaltElem!=null) webconfEncSalt = webconfEncSaltElem.Value;
		System.Configuration.KeyValueConfigurationElement webconfEncAlgoElem = rootWebConfig1.AppSettings.Settings["encryptAlgorithm"];
		if (webconfEncAlgoElem!=null) webconfEncAlgo = webconfEncAlgoElem.Value;
		System.Configuration.KeyValueConfigurationElement webconfEncItsElem = rootWebConfig1.AppSettings.Settings["encryptIterations"];
		if (webconfEncItsElem!=null) webconfEncIts = webconfEncItsElem.Value;
		System.Configuration.KeyValueConfigurationElement webconfEncInitVectElem = rootWebConfig1.AppSettings.Settings["encryptInitVector"];
		if (webconfEncInitVectElem!=null) webconfEncInitVect = webconfEncInitVectElem.Value;
		System.Configuration.KeyValueConfigurationElement webconfEncKeySizeElem = rootWebConfig1.AppSettings.Settings["encryptKeySize"];
		if (webconfEncKeySizeElem!=null) webconfEncKeySize = webconfEncKeySizeElem.Value;
		System.Configuration.KeyValueConfigurationElement webconfCipherPrefixElem = rootWebConfig1.AppSettings.Settings["cipherPrefix"];
		if (webconfCipherPrefixElem!=null) webconfCipherPrefix = webconfCipherPrefixElem.Value;

		System.Configuration.KeyValueConfigurationElement webconfMailerGtwyElem = rootWebConfig1.AppSettings.Settings["mailerGateway"];
		if (webconfMailerGtwyElem!=null) webconfMailerGtwy = webconfMailerGtwyElem.Value;
		System.Configuration.KeyValueConfigurationElement webconfMailerFromElem = rootWebConfig1.AppSettings.Settings["mailerFrom"];
		if (webconfMailerFromElem!=null) webconfMailerFrom = webconfMailerFromElem.Value;
		System.Configuration.KeyValueConfigurationElement webconfForcedMailerToElem = rootWebConfig1.AppSettings.Settings["forcedMailerTo"];
		if (webconfForcedMailerToElem!=null) webconfForcedMailerTo = webconfForcedMailerToElem.Value;
		System.Configuration.KeyValueConfigurationElement webconfForcedMailerCcElem = rootWebConfig1.AppSettings.Settings["forcedMailerCc"];
		if (webconfForcedMailerCcElem!=null) webconfForcedMailerCc = webconfForcedMailerCcElem.Value;
		System.Configuration.KeyValueConfigurationElement webconfForcedMailerBccElem = rootWebConfig1.AppSettings.Settings["forcedMailerBcc"];
		if (webconfForcedMailerBccElem!=null) webconfForcedMailerBcc = webconfForcedMailerBccElem.Value;
		System.Configuration.KeyValueConfigurationElement webconfEmailConfLDAPElem = rootWebConfig1.AppSettings.Settings["emailConfirmLDAP"];
		if (webconfEmailConfLDAPElem!=null) webconfEmailConfLDAP = webconfEmailConfLDAPElem.Value;
		System.Configuration.KeyValueConfigurationElement webconfEmailConfBaseDNElem = rootWebConfig1.AppSettings.Settings["emailConfirmBaseDN"];
		if (webconfEmailConfBaseDNElem!=null) webconfEmailConfBaseDN = webconfEmailConfBaseDNElem.Value;

		System.Configuration.KeyValueConfigurationElement webconfVicServerElem = rootWebConfig1.AppSettings.Settings["vic_server"];
		if (webconfVicServerElem!=null) webconfVicServer = webconfVicServerElem.Value;
		System.Configuration.KeyValueConfigurationElement webconfVicUserElem = rootWebConfig1.AppSettings.Settings["vic_user"];
		if (webconfVicUserElem!=null) webconfVicUser = webconfVicUserElem.Value;
		System.Configuration.KeyValueConfigurationElement webconfVicPassElem = rootWebConfig1.AppSettings.Settings["vic_pass"];
		if (webconfVicPassElem!=null) webconfVicPass = webconfVicPassElem.Value;
		System.Configuration.KeyValueConfigurationElement webconfVicDatacenterElem = rootWebConfig1.AppSettings.Settings["vic_datacenter"];
		if (webconfVicDatacenterElem!=null) webconfVicDatacenter = webconfVicDatacenterElem.Value;
		System.Configuration.KeyValueConfigurationElement webconfVicClusterElem = rootWebConfig1.AppSettings.Settings["vic_cluster"];
		if (webconfVicClusterElem!=null) webconfVicCluster = webconfVicClusterElem.Value;

		System.Configuration.KeyValueConfigurationElement webconfAuthLDAPElem = rootWebConfig1.AppSettings.Settings["authLDAP"];
		if (webconfAuthLDAPElem!=null) webconfAuthLDAP = webconfAuthLDAPElem.Value;
		System.Configuration.KeyValueConfigurationElement webconfAuthBaseDNElem = rootWebConfig1.AppSettings.Settings["authBaseDN"];
		if (webconfAuthBaseDNElem!=null) webconfAuthBaseDN = webconfAuthBaseDNElem.Value;
		System.Configuration.KeyValueConfigurationElement webconfAuthUserDNElem = rootWebConfig1.AppSettings.Settings["authUserDN"];
		if (webconfAuthUserDNElem!=null) webconfAuthUserDN = webconfAuthUserDNElem.Value;
		System.Configuration.KeyValueConfigurationElement webconfAuthBindDNElem = rootWebConfig1.AppSettings.Settings["authBindDN"];
		if (webconfAuthBindDNElem!=null) webconfAuthBindDN = webconfAuthBindDNElem.Value;
		System.Configuration.KeyValueConfigurationElement webconfADUsersGroupElem = rootWebConfig1.AppSettings.Settings["ADUsersGroup"];
		if (webconfADUsersGroupElem!=null) webconfADUsersGroup = webconfADUsersGroupElem.Value;
		System.Configuration.KeyValueConfigurationElement webconfADAdminsGroupElem = rootWebConfig1.AppSettings.Settings["ADAdminsGroup"];
		if (webconfADAdminsGroupElem!=null) webconfADAdminsGroup = webconfADAdminsGroupElem.Value;
		System.Configuration.KeyValueConfigurationElement webconfADSuperGroupElem = rootWebConfig1.AppSettings.Settings["ADSuperGroup"];
		if (webconfADSuperGroupElem!=null) webconfADSuperGroup = webconfADSuperGroupElem.Value;
		System.Configuration.KeyValueConfigurationElement webconfADWoDUsersGroupElem = rootWebConfig1.AppSettings.Settings["ADWoDUsersGroup"];
		if (webconfADWoDUsersGroupElem!=null) webconfADWoDUsersGroup = webconfADWoDUsersGroupElem.Value;
		System.Configuration.KeyValueConfigurationElement webconfADWoDAdminsGroupElem = rootWebConfig1.AppSettings.Settings["ADWoDAdminsGroup"];
		if (webconfADWoDAdminsGroupElem!=null) webconfADWoDAdminsGroup = webconfADWoDAdminsGroupElem.Value;

		System.Configuration.KeyValueConfigurationElement webconfDNSSearchOrderElem = rootWebConfig1.AppSettings.Settings["DNSSearchOrder"];
		if (webconfDNSSearchOrderElem!=null) webconfDNSSearchOrder = webconfDNSSearchOrderElem.Value;
	}

	formLongSysName.Value=webconfSysName.Trim();
	formShortSysName.Value=webconfSysShtName.Trim();
	formSysUrl.Value=webconfSysUrl.Trim();
	formAppVDir.Value=webconfAppVDir.Trim();

	formEncPhrase.Value=webconfEncPhrase.Trim();
	formEncSalt.Value=webconfEncSalt.Trim();
	formEncAlgo.Value=webconfEncAlgo.Trim();
	formEncIts.Value=webconfEncIts.Trim();
	formEncInit.Value=webconfEncInitVect.Trim();
	formEncKeySz.Value=webconfEncKeySize.Trim();
	formEncPrefix.Value=webconfCipherPrefix.Trim();

	formMailGateway.Value=webconfMailerGtwy.Trim();
	formMailFrom.Value=webconfMailerFrom.Trim();
	formMailForceTo.Value=webconfForcedMailerTo.Trim();
	formMailForceCc.Value=webconfForcedMailerCc.Trim();
	formMailForceBcc.Value=webconfForcedMailerBcc.Trim();
	formMailLDAPSrv.Value=webconfEmailConfLDAP.Trim();
	formMailLDAPDn.Value=webconfEmailConfBaseDN.Trim();

	formAuthLDAPSrv.Value=webconfAuthLDAP.Trim();
	formAuthLDAPDn.Value=webconfAuthBaseDN.Trim();
	formAuthLDAPUser.Value=webconfAuthUserDN.Trim();
	formAuthLDAPPass.Value=webconfAuthBindDN.Trim();
	formAuthUserGrp.Value=webconfADUsersGroup.Trim();
	formAuthAdminGrp.Value=webconfADAdminsGroup.Trim();
	formAuthSuperGrp.Value=webconfADSuperGroup.Trim();

//	Response.Write(webconfDbType.Trim();

	formDbType.Value=webconfDbType.Trim();

	switch (webconfDbType)
	{
	case "msJet":
		dbArg1.InnerHtml="OLEDB Provider";
		formDbArg1.Value=webconfOleDbProv.Trim();
		dbArg2.InnerHtml="MDB File Name";
		formDbArg2.Value=webconfOleDbFile.Trim();
		dbArg3.InnerHtml="MDB File Path";
		formDbArg3.Value=webconOleDbPath.Trim();
		dbArg4.InnerHtml="OLEDB Options";
		formDbArg4.Value=webconfOleDbOpt.Trim(); 
		dbArg5.InnerHtml="";
		formDbArg5.Style.Add("visibility", "hidden");
		dbArg6.InnerHtml="";
		formDbArg6.Style.Add("visibility", "hidden");
		break;
	case "MsSql":
		dbArg1.InnerHtml="MSSQL DB Server FQDN";
		formDbArg1.Value=webconfSqlDbSvr.Trim();
		dbArg2.InnerHtml="MSSQL DB / Schema Name";
		formDbArg2.Value=webconfSqlDbName.Trim();
		dbArg3.InnerHtml="MSSQL User";
		formDbArg3.Value=webconfSqlDbUser.Trim();
		dbArg4.InnerHtml="MSSQL Password";
		formDbArg4.Value=webconfSqlDbPass.Trim();
		dbArg5.InnerHtml="MSSQL Options";
		formDbArg5.Value=webconfSqlDbOpt.Trim(); 
		dbArg6.InnerHtml="";
		formDbArg6.Style.Add("visibility", "hidden");
		break;
	case "Oracle":
		dbArg1.InnerHtml="Oracle DB Server FQDN";
		formDbArg1.Value=webconfOraDbSvr.Trim();
		dbArg2.InnerHtml="Oracle DB Instance";
		formDbArg2.Value=webconfOraDbInst.Trim();
		dbArg3.InnerHtml="Oracle DB Service";
		formDbArg3.Value=webconfOraDbSvc.Trim();
		dbArg4.InnerHtml="Oracle DB User";
		formDbArg4.Value=webconfOraDbUser.Trim();
		dbArg5.InnerHtml="Oracle DB Password";
		formDbArg5.Value=webconfOraDbPass.Trim();
		dbArg6.InnerHtml="Oracle DB Options";
		formDbArg6.Value=webconfOraDbOpt.Trim(); 
		break;
	case "ODBC":
		dbArg1.InnerHtml="ODBC DSN";
		formDbArg1.Value=webconfOdbcDbDsn.Trim();
		dbArg2.InnerHtml="ODBC User";
		formDbArg2.Value=webconfOdbcDbUser.Trim();
		dbArg3.InnerHtml="ODBC Password";
		formDbArg3.Value=webconfOdbcDbPass.Trim();
		dbArg4.InnerHtml="ODBC Options";
		formDbArg4.Value=webconfOdbcDbOpt.Trim(); 
		dbArg5.InnerHtml="";
		formDbArg5.Style.Add("visibility", "hidden");
		dbArg6.InnerHtml="";
		formDbArg6.Style.Add("visibility", "hidden");
		break;
	}

/*	Response.Write(webconfVicServer.Trim();
	Response.Write(webconfVicUser.Trim();
	Response.Write(webconfVicPass.Trim();
	Response.Write(webconfVicDatacenter.Trim();
	Response.Write(webconfVicCluster.Trim();
	Response.Write(webconfADWoDUsersGroup.Trim();
	Response.Write(webconfADWoDAdminsGroup.Trim();

	Response.Write(webconfDNSSearchOrder.Trim(); */
}
</SCRIPT>
</HEAD>
<!--#include file="body.inc" -->
<FORM id='form1' runat='server'>
<DIV id='popContainer'>
<!--#include file="banner.inc" -->
	<DIV id='popContent'>
		<DIV class='center altRowFill'>
			<SPAN id='titleSpan' runat='server'/>
			<DIV id='errmsg' class='errorLine' runat='server'/><BR/>
			<DIV id='status' class='statusLine' runat='server'/>
			&#xa0;<BR/>
			<DIV class='center'>
				<TABLE border='1' class='datatable center'>
					<TR><TD class='center'>
						<TABLE>
							<TR><TD class='whiteRowFill left' colspan=2>&#xa0;</TD></TR>
							<TR><TD class='whiteRowFill bold left' colspan=2>Basic App Settings</TD></TR>
							<TR><TD class='paleColorFill left'>Verbose System Name</TD><TD class='whiteRowFill left'><INPUT type='text' size='50' id='formLongSysName' runat='server'/></TD></TR>
							<TR><TD class='paleColorFill left'>Short System Name</TD><TD class='whiteRowFill left'><INPUT type='text' size='50' id='formShortSysName' runat='server'/></TD></TR>
							<TR><TD class='paleColorFill left'>System URL</TD><TD class='whiteRowFill left'><INPUT type='text' size='50' id='formSysUrl' runat='server'/></TD></TR>
							<TR><TD class='paleColorFill left'>IIS App. / VirtualDir Name</TD><TD class='whiteRowFill left'><INPUT type='text' size='50' id='formAppVDir' runat='server'/></TD></TR>
							<TR><TD class='paleColorFill left'>Default Sysadmin Account</TD><TD class='whiteRowFill left'><INPUT type='text' size='50' id='formDefaultUserName' runat='server'/></TD></TR>
							<TR><TD class='paleColorFill left'>Sysadmin Acct. Password</TD><TD class='whiteRowFill left'><INPUT type='text' size='20' id='formDefaultUserPass' runat='server'/></TD></TR>
							<TR><TD class='paleColorFill left'>Confirm Password</TD><TD class='whiteRowFill left'><INPUT type='text' size='20' id='formDefaultUserConfirm' runat='server'/>&nbsp;<INPUT type='button' id='chgDefPassButton' value='Change Password' OnServerClick='changeDefaultPass' runat='server' /></TD></TR>
							<TR><TD class='whiteRowFill left' colspan=2>&#xa0;</TD></TR>
							<TR><TD class='whiteRowFill bold left' colspan=2>Encryption Settings</TD></TR>
							<TR><TD class='paleColorFill left'>Passphrase</TD><TD class='whiteRowFill left'><INPUT type='text' size='50' id='formEncPhrase' runat='server'/></TD></TR>
							<TR><TD class='paleColorFill left'>Salt Value</TD><TD class='whiteRowFill left'><INPUT type='text' size='50' id='formEncSalt' runat='server'/></TD></TR>
							<TR><TD class='paleColorFill left'>Algorithm</TD><TD class='whiteRowFill left'>
								<SELECT id='formEncAlgo' runat='server'>
									<OPTION value='SHA1'>SHA1</OPTION>
									<OPTION value='MD5'>MD5</OPTION>
								</SELECT>
							</TD></TR>
							<TR><TD class='paleColorFill left'>Iterations</TD><TD class='whiteRowFill left'>
								<SELECT id='formEncIts' runat='server'>
									<OPTION value='1'>1</OPTION>
									<OPTION value='2'>2</OPTION>
									<OPTION value='3'>3</OPTION>
									<OPTION value='4'>4</OPTION>
									<OPTION value='5'>5</OPTION>
									<OPTION value='6'>6</OPTION>
									<OPTION value='7'>7</OPTION>
									<OPTION value='8'>8</OPTION>
									<OPTION value='9'>9</OPTION>
								</SELECT>
							</TD></TR>
							<TR><TD class='paleColorFill left'>Init. Vector</TD><TD class='whiteRowFill left'><INPUT type='text' size='50' id='formEncInit' runat='server'/></TD></TR>
							<TR><TD class='paleColorFill left'>Key Size</TD><TD class='whiteRowFill left'>
								<SELECT id='formEncKeySz' runat='server'>
									<OPTION value='128'>128-bit</OPTION>
									<OPTION value='192'>192-bit</OPTION>
									<OPTION value='256'>256-bit</OPTION>
								</SELECT>
							</TD></TR>
							<TR><TD class='paleColorFill left'>Cipher Prefix</TD><TD class='whiteRowFill left'><INPUT type='text' size='50' id='formEncPrefix' runat='server'/></TD></TR>
							<TR><TD class='whiteRowFill left' colspan=2>&#xa0;</TD></TR>
							<TR><TD class='whiteRowFill bold left' colspan=2>Email &amp; Notification Settings</TD></TR>
							<TR><TD class='paleColorFill left'>SMTP Gateway</TD><TD class='whiteRowFill left'><INPUT type='text' size='50' id='formMailGateway' runat='server'/></TD></TR>
							<TR><TD class='paleColorFill left'>System From Address</TD><TD class='whiteRowFill left'><INPUT type='text' size='50' id='formMailFrom' runat='server'/></TD></TR>
							<TR><TD class='paleColorFill left'>Forced To</TD><TD class='whiteRowFill left'><INPUT type='text' size='50' id='formMailForceTo' runat='server'/></TD></TR>
							<TR><TD class='paleColorFill left'>Forced Cc</TD><TD class='whiteRowFill left'><INPUT type='text' size='50' id='formMailForceCc' runat='server'/></TD></TR>
							<TR><TD class='paleColorFill left'>Forced Bcc</TD><TD class='whiteRowFill left'><INPUT type='text' size='50' id='formMailForceBcc' runat='server'/></TD></TR>
							<TR><TD class='paleColorFill left'>E-Mail LDAP Server</TD><TD class='whiteRowFill left'><INPUT type='text' size='50' id='formMailLDAPSrv' runat='server'/></TD></TR>
							<TR><TD class='paleColorFill left'>E-Mail LDAP Base DN</TD><TD class='whiteRowFill left'><INPUT type='text' size='50' id='formMailLDAPDn' runat='server'/></TD></TR>
							<TR><TD class='whiteRowFill left' colspan=2>&#xa0;</TD></TR>
							<TR><TD class='whiteRowFill bold left' colspan=2>LDAP &amp; AD Authentication Settings</TD></TR>
							<TR><TD class='paleColorFill left'>Auth. LDAP Server</TD><TD class='whiteRowFill left'><INPUT type='text' size='50' id='formAuthLDAPSrv' runat='server'/></TD></TR>
							<TR><TD class='paleColorFill left'>Auth. LDAP Base DN</TD><TD class='whiteRowFill left'><INPUT type='text' size='50' id='formAuthLDAPDn' runat='server'/></TD></TR>
							<TR><TD class='paleColorFill left'>Auth. Service User</TD><TD class='whiteRowFill left'><INPUT type='text' size='50' id='formAuthLDAPUser' runat='server'/></TD></TR>
							<TR><TD class='paleColorFill left'>Auth. Service Password</TD><TD class='whiteRowFill left'><INPUT type='text' size='50' id='formAuthLDAPPass' runat='server'/></TD></TR>
							<TR><TD class='paleColorFill left'>User Rights Group</TD><TD class='whiteRowFill left'><INPUT type='text' size='50' id='formAuthUserGrp' runat='server'/></TD></TR>
							<TR><TD class='paleColorFill left'>Admin Rights Group</TD><TD class='whiteRowFill left'><INPUT type='text' size='50' id='formAuthAdminGrp' runat='server'/></TD></TR>
							<TR><TD class='paleColorFill left'>&Uuml;ber Rights Group</TD><TD class='whiteRowFill left'><INPUT type='text' size='50' id='formAuthSuperGrp' runat='server'/></TD></TR>
							<TR><TD class='whiteRowFill left' colspan=2>&#xa0;</TD></TR>
							<TR><TD class='whiteRowFill bold left' colspan=2>Database Settings</TD></TR>
							<TR><TD class='paleColorFill left'>Database Type</TD><TD class='whiteRowFill left'>
								<SELECT id='formDbType' runat='server'>
									<OPTION value='msJet'>MS Access (local MDB)</OPTION>
									<OPTION value='MsSql'>MS-SQL</OPTION>
									<OPTION value='Oracle'>Oracle</OPTION>
									<OPTION value='ODBC'>ODBC</OPTION>
								</SELECT>
								<INPUT type='button' id='reviseDbButton' value='Revise Fields' OnServerClick='reviseDbFields' runat='server' />
							</TD></TR>
							<TR><TD class='paleColorFill left'><DIV id='dbArg1' runat='server'/></TD><TD class='whiteRowFill left'><INPUT type='text' size='50' id='formDbArg1' runat='server'/></TD></TR>
							<TR><TD class='paleColorFill left'><DIV id='dbArg2' runat='server'/></TD><TD class='whiteRowFill left'><INPUT type='text' size='50' id='formDbArg2' runat='server'/></TD></TR>
							<TR><TD class='paleColorFill left'><DIV id='dbArg3' runat='server'/></TD><TD class='whiteRowFill left'><INPUT type='text' size='50' id='formDbArg3' runat='server'/></TD></TR>
							<TR><TD class='paleColorFill left'><DIV id='dbArg4' runat='server'/></TD><TD class='whiteRowFill left'><INPUT type='text' size='50' id='formDbArg4' runat='server'/></TD></TR>
							<TR><TD class='paleColorFill left'><DIV id='dbArg5' runat='server'/></TD><TD class='whiteRowFill left'><INPUT type='text' size='50' id='formDbArg5' runat='server'/></TD></TR>
							<TR><TD class='paleColorFill left'><DIV id='dbArg6' runat='server'/></TD><TD class='whiteRowFill left'><INPUT type='text' size='50' id='formDbArg6' runat='server'/></TD></TR>
							<TR><TD class='paleColorFill left'>&#xa0;</TD><TD class='whiteRowFill left'><DIV id='dbTestResult' class='errorLine' runat='server'/></TD></TR>
							<TR><TD class='paleColorFill left'>&#xa0;</TD><TD class='whiteRowFill left'><INPUT type='button' id='testDbButton' value='Test Database Settings' OnServerClick='testDb' runat='server' /></TD></TR>
							<TR><TD class='whiteRowFill left' colspan=2>&#xa0;</TD></TR>
							<TR><TD class='whiteRowFill bold left' colspan=2><DIV id='mod1_title' runat='server'/></TD></TR>
							<TR><TD class='paleColorFill left'><DIV id='mod1_setting1' runat='server'/></TD><TD class='whiteRowFill left'><INPUT type='text' size='50' id='formM1S1' runat='server'/></TD></TR>
							<TR><TD class='paleColorFill left'><DIV id='mod1_setting2' runat='server'/></TD><TD class='whiteRowFill left'><INPUT type='text' size='50' id='formM1S2' runat='server'/></TD></TR>
							<TR><TD class='paleColorFill left'><DIV id='mod1_setting3' runat='server'/></TD><TD class='whiteRowFill left'><INPUT type='text' size='50' id='formM1S3' runat='server'/></TD></TR>
							<TR><TD class='paleColorFill left'><DIV id='mod1_setting4' runat='server'/></TD><TD class='whiteRowFill left'><INPUT type='text' size='50' id='formM1S4' runat='server'/></TD></TR>
							<TR><TD class='paleColorFill left'><DIV id='mod1_setting5' runat='server'/></TD><TD class='whiteRowFill left'><INPUT type='text' size='50' id='formM1S5' runat='server'/></TD></TR>
							<TR><TD class='paleColorFill left'><DIV id='mod1_setting6' runat='server'/></TD><TD class='whiteRowFill left'><INPUT type='text' size='50' id='formM1S6' runat='server'/></TD></TR>
							<TR><TD class='paleColorFill left'><DIV id='mod1_setting7' runat='server'/></TD><TD class='whiteRowFill left'><INPUT type='text' size='50' id='formM1S7' runat='server'/></TD></TR>
							<TR><TD class='whiteRowFill left' colspan=2>&#xa0;</TD></TR>
						</TABLE>
					</TD></TR>
				</TABLE>
				<BUTTON id='submitButton' name='goButton' OnServerClick='goSubmit' runat='server'><SPAN id='subBtnTitle' runat='server'/></BUTTON>
			</DIV>
		</DIV>
	</DIV> <!-- End: content -->
<!--#include file='closer.inc'-->
</DIV> <!-- End: container -->
</FORM>
</BODY>
</HTML>