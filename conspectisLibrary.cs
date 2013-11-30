// conspectisLibrary.cs
// compile with: /doc:conspectisLibrary_doc.xml 

using System;
using System.Configuration;
using System.Collections;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Data;
using System.Data.OleDb;
using System.Data.SqlClient;
using System.Data.OracleClient;
using System.Data.Odbc;
using System.Diagnostics;
using System.DirectoryServices; //Allows AD Integration
using System.Drawing;
using System.Globalization;
using System.IO;
using System.Net;
using System.Net.Security;
using System.Net.NetworkInformation;
using System.Reflection;
using System.Reflection.Emit;
using System.Security.Cryptography;
using System.Security.Cryptography.X509Certificates;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.Mail;
using System.Web.Services.Protocols;
using iTextSharp.text.pdf; // Redistributed in accordance with AGPLv3 - http://itextpdf.com/terms-of-use/agpl.php
using VMware.Vim; // Redistributed freely in accordance with VMware VI SDK Developer License Agreeement - http://communities.vmware.com/docs/DOC-7983

/// <summary>
///   Namespace 'CIS' encompasses a number of class libraries for CIS
/// </summary>
/// <seealso cref="conspectisLibrary">
///	  The <see cref="conspectisLibrary"/> class is a member of this namespace.
/// </seealso>
/// <seealso cref="wodLibrary">
///	  The <see cref="wodLibrary"/> class is a member of this namespace.
/// </seealso>
/// <remarks>  </remarks>
namespace CIS
{

/// <summary>
///   The conspectisLibrary class contains all code-behind members for the core CIS application.
/// </summary>
/// <seealso cref="VMware.Vim">
///	  The <see cref="VMware.Vim"/> namespace is accessed(required) by members of this class.
/// </seealso>
/// <seealso cref="System">
///	  The <see cref="System"/> namespace is accessed(required) by members of this class.
/// </seealso>
/// <seealso cref="System.Configuration">
///	  The <see cref="System.Configuration"/> namespace is accessed(required) by members of this class.
/// </seealso>
/// <seealso cref="System.Collections">
///	  The <see cref="System.Collections"/> namespace is accessed(required) by members of this class.
/// </seealso>
/// <seealso cref="System.Collections.Generic">
///	  The <see cref="System.Collections.Generic"/> namespace is accessed(required) by members of this class.
/// </seealso>
/// <seealso cref="System.Collections.Specialized">
///	  The <see cref="System.Collections.Specialized"/> namespace is accessed(required) by members of this class.
/// </seealso>
/// <seealso cref="System.Data">
///	  The <see cref="System.Data"/> namespace is accessed(required) by members of this class.
/// </seealso>
/// <seealso cref="System.Data.OleDb">
///	  The <see cref="System.Data.OleDb"/> namespace is accessed(required) by members of this class.
/// </seealso>
/// <seealso cref="System.Data.SqlClient">
///	  The <see cref="System.Data.SqlClient"/> namespace is accessed(required) by members of this class.
/// </seealso>
/// <seealso cref="System.Data.OracleClient">
///	  The <see cref="System.Data.OracleClient"/> namespace is accessed(required) by members of this class.
/// </seealso>
/// <seealso cref="System.Data.Odbc">
///	  The <see cref="System.Data.Odbc"/> namespace is accessed(required) by members of this class.
/// </seealso>
/// <seealso cref="System.Diagnostics">
///	  The <see cref="System.Diagnostics"/> namespace is accessed(required) by members of this class.
/// </seealso>
/// <seealso cref="System.DirectoryServices">
///	  The <see cref="System.DirectoryServices"/> namespace is accessed(required) by members of this class.
/// </seealso>
/// <seealso cref="System.Drawing">
///	  The <see cref="System.Drawing"/> namespace is accessed(required) by members of this class.
/// </seealso>
/// <seealso cref="System.Globalization">
///	  The <see cref="System.Globalization"/> namespace is accessed(required) by members of this class.
/// </seealso>
/// <seealso cref="System.IO">
///	  The <see cref="System.IO"/> namespace is accessed(required) by members of this class.
/// </seealso>
/// <seealso cref="System.Net">
///	  The <see cref="System.Net"/> namespace is accessed(required) by members of this class.
/// </seealso>
/// <seealso cref="System.Net.Security">
///	  The <see cref="System.Net.Security"/> namespace is accessed(required) by members of this class.
/// </seealso>
/// <seealso cref="System.Net.NetworkInformation">
///	  The <see cref="System.Net"/> namespace is accessed(required) by members of this class.
/// </seealso>
/// <seealso cref="System.Reflection">
///	  The <see cref="System.Reflection"/> namespace is accessed(required) by members of this class.
/// </seealso>
/// <seealso cref="System.Reflection.Emit">
///	  The <see cref="System.Reflection.Emit"/> namespace is accessed(required) by members of this class.
/// </seealso>
/// <seealso cref="System.Security.Cryptography">
///	  The <see cref="System.Security.Cryptography"/> namespace is accessed(required) by members of this class.
/// </seealso>
/// <seealso cref="System.Security.Cryptography.X509Certificates">
///	  The <see cref="System.Security.Cryptography.X509Certificates"/> namespace is accessed(required) by members of this class.
/// </seealso>
/// <seealso cref="System.Text">
///	  The <see cref="System.Text"/> namespace is accessed(required) by members of this class.
/// </seealso>
/// <seealso cref="System.Web">
///	  The <see cref="System.Web"/> namespace is accessed(required) by members of this class.
/// </seealso>
/// <seealso cref="System.Web.Security">
///	  The <see cref="System.Web.Security"/> namespace is accessed(required) by members of this class.
/// </seealso>
/// <seealso cref="System.Web.UI">
///	  The <see cref="System.Web.UI"/> namespace is accessed(required) by members of this class.
/// </seealso>
/// <seealso cref="System.Web.UI.HtmlControls">
///	  The <see cref="System.Web.UI.HtmlControls"/> namespace is accessed(required) by members of this class.
/// </seealso>
/// <seealso cref="System.Web.UI.WebControls">
///	  The <see cref="System.Web.UI.WebControls"/> namespace is accessed(required) by members of this class.
/// </seealso>
/// <seealso cref="System.Web.UI.WebControls.WebParts">
///	  The <see cref="System.Web.UI.WebControls.WebParts"/> namespace is accessed(required) by members of this class.
/// </seealso>
/// <seealso cref="System.Web.Mail">
///	  The <see cref="System.Web.Mail"/> namespace is accessed(required) by members of this class.
/// </seealso>
/// <seealso cref="System.Web.Services.Protocols">
///	  The <see cref="System.Web.Services.Protocols"/> namespace is accessed(required) by members of this class.
/// </seealso>
/// <seealso cref="iTextSharp.text.pdf">
///	  The <see cref="iTextSharp.text.pdf"/> namespace is accessed(required) by members of this class.
/// </seealso>
/// <seealso cref="System.Web.UI.Page">
///	  The <see cref="System.Web.UI.Page"/> class is inherited by this class.
/// </seealso>
/// <remarks>  </remarks>
public class conspectisLibrary : System.Web.UI.Page
{

// NON-STATIC conspectisLibrary Properties (Usable via WebUI ONLY!)
//------------------------------------------------------------------------
/// <summary>
///   The <see cref="sysName"/> non-static property defines the long-form name that the CIS application will use, default is 'Engagement Services Management System'
/// </summary>
/// <value>
///   The <see cref="sysName"/> non-static property is set by reading the value of the 'sysName' key from the IIS web.config file
/// </value>
/// <seealso cref="Method(string[])">
///	  The <see cref="sysName"/> static property is accessed(required) by the conspectisLibrary method ''
/// </seealso>
	public string	sysName         = System.Configuration.ConfigurationManager.AppSettings["systemName"].ToString();


/// <summary>
///   The <see cref="iisAppVdir"/> non-static property defines the long-form name that the CIS application will use, default is '' (Default IIS Web Site)
/// </summary>
/// <value>
///   The <see cref="iisAppVdir"/> non-static property is set by reading the value of the 'iisAppName' key from the IIS web.config file
/// </value>
/// <seealso cref="Method(string[])">
///	  The <see cref="iisAppVdir"/> static property is accessed(required) by the conspectisLibrary method ''
/// </seealso>
	public string	iisAppVdir         = System.Configuration.ConfigurationManager.AppSettings["iisAppName"].ToString();


/// <summary>
///   The <see cref="shortSysName"/> non-static property defines the short-form name that the CIS application will use, default is 'CIS'
/// </summary>
/// <value>
///   The <see cref="shortSysName"/> non-static property is set by reading the value of the 'systemShortName' key from the IIS web.config file
/// </value>
/// <seealso cref="readChangeDetail(string)">
///	  The <see cref="shortSysName"/> static property is accessed(required) by the conspectisLibrary non-static method 'readChangeDetail(string)'
/// </seealso>
/// <seealso cref="readChangeLog(string)">
///	  The <see cref="shortSysName"/> static property is accessed(required) by the conspectisLibrary non-static method 'readChangeLog(string)'
/// </seealso>
/// <seealso cref="resetChangeLog()">
///	  The <see cref="shortSysName"/> static property is accessed(required) by the conspectisLibrary non-static method 'resetChangeLog()'
/// </seealso>
/// <seealso cref="writeChangeLog(string, string, string)">
///	  The <see cref="shortSysName"/> static property is accessed(required) by the conspectisLibrary non-static method 'writeChangeLog(string, string, string)'
/// </seealso>
/// <seealso cref="writeChangeLog(string, string, string, string)">
///	  The <see cref="shortSysName"/> static property is accessed(required) by the conspectisLibrary non-static method 'writeChangeLog(string, string, string, string)'
/// </seealso>
/// <seealso cref="writeChangeLog(string, string, string, string, int)">
///	  The <see cref="shortSysName"/> static property is accessed(required) by the conspectisLibrary non-static method 'writeChangeLog(string, string, string, string, int)'
/// </seealso>
	public string	shortSysName         = System.Configuration.ConfigurationManager.AppSettings["systemShortName"].ToString();

/// <summary>
///   The <see cref="sysURL"/> non-static property defines the URL that the CIS application will use, default is 'http://localhost/conspectis/'
/// </summary>
/// <value>
///   The <see cref="sysURL"/> non-static property is set by reading the value of the 'systemURL' key from the web.config file
/// </value>
/// <seealso cref="Method(string[])">
///	  The <see cref="sysURL"/> static property is accessed(required) by the conspectisLibrary method ''
/// </seealso>
	public string	sysURL         = System.Configuration.ConfigurationManager.AppSettings["systemURL"].ToString();

/// <summary>
///   The <see cref="sysEmail"/> non-static property defines the email address that the CIS application will use, default is 'ConspectIS@fqdn'
/// </summary>
/// <value>
///   The <see cref="sysEmail"/> non-static property is set by reading the value of the 'sysAdmSupportEmail' key from the web.config file
/// </value>
	public string	sysEmail         = System.Configuration.ConfigurationManager.AppSettings["systemEmail"].ToString();

/// <summary>
///   The <see cref="mailServer"/> non-static property defines the SMTP server/hostname that the CIS application will use, default is 'localhost'
/// </summary>
/// <value>
///   The <see cref="mailServer"/> non-static property is set by reading the value of the 'mailerGateway' key from the web.config file
/// </value>
/// <seealso cref="Method(string[])">
///	  The <see cref="mailServer"/> static property is accessed(required) by the conspectisLibrary method ''
/// </seealso>
	public string	mailServer         = System.Configuration.ConfigurationManager.AppSettings["mailerGateway"].ToString();

/// <summary>
///   The <see cref="passPhrase"/> non-static property defines the passphrase for the Rinjadel (MD5/SHA1) encryption that the CIS application will use against PII & other sensitive data, default is 'CIS'
/// </summary>
/// <value>
///   The <see cref="passPhrase"/> non-static property is set by reading the value of the 'encryptPhrase' key from the web.config file
/// </value>
/// <seealso cref="Encrypt(string)">
///	  The <see cref="passPhrase"/> static property is accessed(required) by the conspectisLibrary non-static method 'Encrypt(string)'
/// </seealso>
/// <seealso cref="Decrypt(string)">
///	  The <see cref="passPhrase"/> static property is accessed(required) by the conspectisLibrary non-static method 'Decrypt(string)'
/// </seealso>
	public string	passPhrase         = System.Configuration.ConfigurationManager.AppSettings["encryptPhrase"].ToString();

/// <summary>
///   The <see cref="saltValue"/> non-static property defines the salt value for the Rinjadel (MD5/SHA1) encryption that the CIS application will use against PII & other sensitive data, default is 'CIS'
/// </summary>
/// <value>
///   The <see cref="saltValue"/> non-static property is set by reading the value of the 'encryptSalt' key from the web.config file
/// </value>
/// <seealso cref="Encrypt(string)">
///	  The <see cref="saltValue"/> static property is accessed(required) by the conspectisLibrary non-static method 'Encrypt(string)'
/// </seealso>
/// <seealso cref="Decrypt(string)">
///	  The <see cref="saltValue"/> static property is accessed(required) by the conspectisLibrary non-static method 'Decrypt(string)'
/// </seealso>
    public string	saltValue          = System.Configuration.ConfigurationManager.AppSettings["encryptSalt"].ToString();

/// <summary>
///   The <see cref="hashAlgorithm"/> non-static property defines the hash algorithm for the Rinjadel (MD5/SHA1) encryption that the CIS application will use against PII & other sensitive data, default is 'SHA1'
/// </summary>
/// <value>
///   The <see cref="hashAlgorithm"/> non-static property is set by reading the value of the 'encryptAlgorithm' key from the web.config file
/// </value>
/// <seealso cref="Encrypt(string)">
///	  The <see cref="hashAlgorithm"/> static property is accessed(required) by the conspectisLibrary non-static method 'Encrypt(string)'
/// </seealso>
/// <seealso cref="Decrypt(string)">
///	  The <see cref="hashAlgorithm"/> static property is accessed(required) by the conspectisLibrary non-static method 'Decrypt(string)'
/// </seealso>
    public string	hashAlgorithm      = System.Configuration.ConfigurationManager.AppSettings["encryptAlgorithm"].ToString();

/// <summary>
///   The <see cref="passwordIterations"/> non-static property defines the quantity of iterative password encryption passes for the Rinjadel (MD5/SHA1) encryption that the CIS application will use against PII & other sensitive data, default is '2'
/// </summary>
/// <value>
///   The <see cref="passwordIterations"/> non-static property is set by reading the value of the 'encryptIterations' key from the web.config file
/// </value>
/// <seealso cref="Encrypt(string)">
///	  The <see cref="passwordIterations"/> static property is accessed(required) by the conspectisLibrary non-static method 'Encrypt(string)'
/// </seealso>
/// <seealso cref="Decrypt(string)">
///	  The <see cref="passwordIterations"/> static property is accessed(required) by the conspectisLibrary non-static method 'Decrypt(string)'
/// </seealso>
    public int	passwordIterations = Convert.ToInt32(System.Configuration.ConfigurationManager.AppSettings["encryptIterations"]);

/// <summary>
///   The <see cref="initVector"/> non-static property defines the 16-byte init vector for the Rinjadel (MD5/SHA1) encryption that the CIS application will use against PII & other sensitive data, default is '@1B2c3D4e5F6g7H8'
/// </summary>
/// <value>
///   The <see cref="initVector"/> non-static property is set by reading the value of the 'encryptInitVector' key from the web.config file
/// </value>
/// <seealso cref="Encrypt(string)">
///	  The <see cref="initVector"/> static property is accessed(required) by the conspectisLibrary non-static method 'Encrypt(string)'
/// </seealso>
/// <seealso cref="Decrypt(string)">
///	  The <see cref="initVector"/> static property is accessed(required) by the conspectisLibrary non-static method 'Decrypt(string)'
/// </seealso>
    public string	initVector         = System.Configuration.ConfigurationManager.AppSettings["encryptInitVector"].ToString();

/// <summary>
///   The <see cref="keySize"/> non-static property defines the size(bytes) of the encryption key to use for the Rinjadel (MD5/SHA1) encryption that the CIS application will use against PII & other sensitive data, default is '256', can be 128 or 192.
/// </summary>
/// <value>
///   The <see cref="keySize"/> non-static property is set by reading the value of the 'encryptKeySize' key from the web.config file
/// </value>
/// <seealso cref="Encrypt(string)">
///	  The <see cref="keySize"/> static property is accessed(required) by the conspectisLibrary non-static method 'Encrypt(string)'
/// </seealso>
/// <seealso cref="Decrypt(string)">
///	  The <see cref="keySize"/> static property is accessed(required) by the conspectisLibrary non-static method 'Decrypt(string)'
/// </seealso>
    public int	keySize            = Convert.ToInt32(System.Configuration.ConfigurationManager.AppSettings["encryptKeySize"]);

/// <summary>
///   The <see cref="strServerName"/> non-static property defines the LDAP URL that the CIS application will use for authentication, default is 'LDAP://domain:389/'
/// </summary>
/// <value>
///   The <see cref="strServerName"/> non-static property is set by reading the value of the 'authLDAP' key from the web.config file
/// </value>
/// <seealso cref="connectToAD()">
///	  The <see cref="strServerName"/> static property is accessed(required) by the conspectisLibrary non-static method 'connectToAD()'
/// </seealso>
/// <seealso cref="connectToAD(string)">
///	  The <see cref="strServerName"/> static property is accessed(required) by the conspectisLibrary non-static method 'connectToAD(string)'
/// </seealso>
/// <seealso cref="doADAuth(string, string)">
///	  The <see cref="strServerName"/> static property is accessed(required) by the conspectisLibrary non-static method 'doADAuth(string, string)'
/// </seealso>
/// <seealso cref="getADUsersinGroup(string)">
///	  The <see cref="strServerName"/> static property is accessed(required) by the conspectisLibrary non-static method 'getADUsersinGroup(string)'
/// </seealso>
	public string	strServerName	   = System.Configuration.ConfigurationManager.AppSettings["authLDAP"].ToString();

/// <summary>
///   The <see cref="strBaseDN"/> non-static property defines the LDAP Base DN that the CIS application will use for authentication, default is 'OU=Users'
/// </summary>
/// <value>
///   The <see cref="strBaseDN"/> non-static property is set by reading the value of the 'authBaseDN' key from the web.config file
/// </value>
/// <seealso cref="connectToAD()">
///	  The <see cref="strBaseDN"/> static property is accessed(required) by the conspectisLibrary non-static method 'connectToAD()'
/// </seealso>
/// <seealso cref="doADAuth(string, string)">
///	  The <see cref="strBaseDN"/> static property is accessed(required) by the conspectisLibrary non-static method 'doADAuth(string, string)'
/// </seealso>
	public string	strBaseDN		   = System.Configuration.ConfigurationManager.AppSettings["authBaseDN"].ToString(); 
	
/// <summary>
///   The <see cref="bindDN"/> non-static property defines the LDAP Bind DN (username) the CIS application will use for authentication, default is <blank>
/// </summary>
/// <value>
///   The <see cref="bindDN"/> non-static property is set by reading the value of the 'authUserDN' key from the web.config file
/// </value>
/// <seealso cref="connectToAD()">
///	  The <see cref="bindDN"/> static property is accessed(required) by the conspectisLibrary non-static method 'connectToAD()'
/// </seealso>
/// <seealso cref="connectToAD(string)">
///	  The <see cref="bindDN"/> static property is accessed(required) by the conspectisLibrary non-static method 'connectToAD(string)'
/// </seealso>
/// <seealso cref="getADUserGroups(string)">
///	  The <see cref="bindDN"/> static property is accessed(required) by the conspectisLibrary non-static method 'getADUserGroups(string)'
/// </seealso>
/// <seealso cref="getADUsersinGroup(string)">
///	  The <see cref="bindDN"/> static property is accessed(required) by the conspectisLibrary non-static method 'getADUsersinGroup(string)'
/// </seealso>
	public string	bindDN			   = System.Configuration.ConfigurationManager.AppSettings["authUserDN"].ToString();

/// <summary>
///   The <see cref="bindPWD"/> non-static property defines the LDAP Bind DN Password the CIS application will use for authentication, default is <blank>
/// </summary>
/// <value>
///   The <see cref="bindPWD"/> non-static property is set by reading the value of the 'authBindDN' key from the web.config file
/// </value>
/// <seealso cref="connectToAD(string)">
///	  The <see cref="bindPWD"/> static property is accessed(required) by the conspectisLibrary non-static method 'connectToAD(string)'
/// </seealso>
/// <seealso cref="getADUserGroups(string)">
///	  The <see cref="bindPWD"/> static property is accessed(required) by the conspectisLibrary non-static method 'getADUserGroups(string)'
/// </seealso>
/// <seealso cref="getADUsersinGroup(string)">
///	  The <see cref="bindPWD"/> static property is accessed(required) by the conspectisLibrary non-static method 'getADUsersinGroup(string)'
/// </seealso>
	public string	bindPWD			   = System.Configuration.ConfigurationManager.AppSettings["authBindDN"].ToString();

/// <summary>
///   The <see cref="ADUsersGroup"/> non-static property defines the LDAP/Kerberos/AD Group the CIS application will use for authentication & User permissions, default is 'CISUsers'
/// </summary>
/// <value>
///   The <see cref="ADUsersGroup"/> non-static property is set by reading the value of the 'ADUsersGroup' key from the web.config file
/// </value>
/// <seealso cref="Method(string[])">
///	  The <see cref="ADUsersGroup"/> static property is accessed(required) by the conspectisLibrary method ''
/// </seealso>
	public string	ADUsersGroup	=	System.Configuration.ConfigurationManager.AppSettings["ADUsersGroup"].ToString();

/// <summary>
///   The <see cref="ADAdminsGroup"/> non-static property defines the LDAP/Kerberos/AD Group the CIS application will use for authentication & Admin permissions, default is 'CISAdmins'
/// </summary>
/// <value>
///   The <see cref="ADAdminsGroup"/> non-static property is set by reading the value of the 'ADAdminsGroup' key from the web.config file
/// </value>
/// <seealso cref="Method(string[])">
///	  The <see cref="ADAdminsGroup"/> static property is accessed(required) by the conspectisLibrary method ''
/// </seealso>
	public string	ADAdminsGroup	=	System.Configuration.ConfigurationManager.AppSettings["ADAdminsGroup"].ToString();

/// <summary>
///   The <see cref="ADSuperGroup"/> non-static property defines the LDAP/Kerberos/AD Group the CIS application will use for authentication & Super permissions, default is 'CISSupers'
/// </summary>
/// <value>
///   The <see cref="ADSuperGroup"/> non-static property is set by reading the value of the 'ADSuperGroup' key from the web.config file
/// </value>
/// <seealso cref="Method(string[])">
///	  The <see cref="ADSuperGroup"/> static property is accessed(required) by the conspectisLibrary method ''
/// </seealso>
	public string	ADSuperGroup	=	System.Configuration.ConfigurationManager.AppSettings["ADSuperGroup"].ToString();

/// <summary>
///   The <see cref="ADWoDUsersGroup"/> non-static property defines the LDAP/Kerberos/AD Group the CIS application will use for authentication & Workspace-On-Demand User permissions, default is 'CISWoDUsers'
/// </summary>
/// <value>
///   The <see cref="ADWoDUsersGroup"/> non-static property is set by reading the value of the 'ADWoDUsersGroup' key from the web.config file
/// </value>
/// <seealso cref="Method(string[])">
///	  The <see cref="ADWoDUsersGroup"/> static property is accessed(required) by the conspectisLibrary method ''
/// </seealso>
	public string	ADWoDUsersGroup	=	System.Configuration.ConfigurationManager.AppSettings["ADWoDUsersGroup"].ToString();

/// <summary>
///   The <see cref="ADWoDAdminsGroup"/> non-static property defines the LDAP/Kerberos/AD Group the CIS application will use for authentication & Workspace-On-Demand Admin permissions, default is 'CISWoDAdmins'
/// </summary>
/// <value>
///   The <see cref="ADWoDAdminsGroup"/> non-static property is set by reading the value of the 'ADWoDAdminsGroup' key from the web.config file
/// </value>
/// <seealso cref="Method(string[])">
///	  The <see cref="ADWoDAdminsGroup"/> static property is accessed(required) by the conspectisLibrary method ''
/// </seealso>
	public string	ADWoDAdminsGroup	=	System.Configuration.ConfigurationManager.AppSettings["ADWoDAdminsGroup"].ToString();

// LIKELY TO MOVE-BE DELETED!!!!!
/// <summary>
///   The <see cref="dnsSearchOrder"/> non-static property defines the DNS Search Order / Suffix Search List the CIS application will use for NSLookup operations, default is 'domain'
/// </summary>
/// <value>
///   The <see cref="dnsSearchOrder"/> non-static property is set by reading the value of the 'DNSSearchOrder' key from the web.config file
/// </value>
/// <seealso cref="dnsLookup(string)">
///	  The <see cref="dnsSearchOrder"/> static property is accessed(required) by the conspectisLibrary static method 'dnsLookup(string)'
/// </seealso>
	public string	dnsSearchOrder	=	System.Configuration.ConfigurationManager.AppSettings["DNSSearchOrder"].ToString();


// STATIC conspectisLibrary Properties (Usable via WebUI & PowerShell)
//------------------------------------------------------------------------
/// <summary>
///   The <see cref="cstr"/> static property defines the connection string the CIS application will use for database operations.
/// </summary>
/// <value>
///   The <see cref="cstr"/> static property is instantiated and its value will be defined by the class constructor, then accessed by accessor methods.
/// </value>
/// <seealso cref="conspectisLibrary()">
///	  The <see cref="cstr"/> static property is accessed(required) by the conspectisLibrary non-static constructor method 'conspectisLibrary()'
/// </seealso>
/// <seealso cref="readDbOle(string)">
///	  The <see cref="cstr' static property is accessed(required) by the conspectisLibrary non-static method 'readDbOle(string)'
/// </seealso>
/// <seealso cref="writeDbOle(string)">
///	  The <see cref="cstr"/> static property is accessed(required) by the conspectisLibrary non-static method 'writeDbOle(string)'
/// </seealso>
/// <seealso cref="readDbSql(string)">
///	  The <see cref="cstr"/> static property is accessed(required) by the conspectisLibrary non-static method 'readDbSql(string)'
/// </seealso>
/// <seealso cref="writeDbSql(string)">
///	  The <see cref="cstr"/> static property is accessed(required) by the conspectisLibrary non-static method 'writeDbSql(string)'
/// </seealso>
/// <seealso cref="readDbOracle(string)">
///	  The <see cref="cstr"/> static property is accessed(required) by the conspectisLibrary non-static method 'readDbOracle(string)'
/// </seealso>
/// <seealso cref="writeDbOracle(string)">
///	  The <see cref="cstr"/> static property is accessed(required) by the conspectisLibrary non-static method 'writeDbOracle(string)'
/// </seealso>
/// <seealso cref="readDbOdbc(string)">
///	  The <see cref="cstr"/> static property is accessed(required) by the conspectisLibrary non-static method 'readDbOdbc(string)'
/// </seealso>
/// <seealso cref="writeDbOdbc(string)">
///	  The <see cref="cstr"/> static property is accessed(required) by the conspectisLibrary non-static method 'writeDbOdbc(string)'
/// </seealso>
	public static string	cstr;

/// <summary>
///   The <see cref="lastpage"/> static property defines the last page string that selected CIS member methods access.
/// </summary>
/// <value>
///   The <see cref="lastpage"/> static property is set <blank> and it will be populated by an accessor method.
/// </value>
/// <seealso cref="lockout()">
///	  The <see cref="lastpage"/> static property is accessed(required) by the conspectisLibrary non-static void method 'lockout()'
/// </seealso>
	public static string	lastpage="";

/// <summary>
///   The <see cref="_numberOfCharsToKeep"/> static property defines the number of characters to keep, when extracting text from a PDF.
/// </summary>
/// <value>
///   The <see cref="_numberOfCharsToKeep"/> static property is set to 15.
/// </value>
/// <seealso cref="ExtractTextFromPDFBytes(byte[])">
///	  The <see cref="_numberOfCharsToKeep"/> static property is accessed(required) by the conspectisLibrary static method 'ExtractTextFromPDFBytes(byte[])'
/// </seealso>
/// <seealso cref="CheckToken(string[], char[])">
///	  The <see cref="_numberOfCharsToKeep"/> static property is accessed(required) by the conspectisLibrary static method 'CheckToken(string[], char[])'
/// </seealso>
	private static int _numberOfCharsToKeep = 15;

/// <summary>
///   The <see cref="lastpage"/> static property defines the last page string that selected CIS member methods access.
/// </summary>
/// <value>
///   The <see cref="lastpage"/> static property is set <blank> and it will be populated by an accessor method.
/// </value>
/// <seealso cref="lockout()">
///	  The <see cref="lastpage"/> static property is accessed(required) by the conspectisLibrary non-static void method 'lockout()'
/// </seealso>
	public static string[]	availModules=new String[] {"VMWare vSphere SDK","VirtualBox API","TADDM MQL API","JIRA REST API"};

// NON-STATIC conspectisLibrary Methods (Usable via WebUI ONLY!)
//------------------------------------------------------------------------
/// <summary>
///   The <see cref="conspectisLibrary()"/> constructor is called at class instantiation.
/// </summary>
/// <remarks>
///   This non-static constructor method defines the value of <paramref name="cstr"/> based on the value of the <c>db_type</c> key in the IIS web.config file.
/// </remarks>
	public conspectisLibrary()
	{
		if (System.Configuration.ConfigurationManager.AppSettings["db_type"].ToString().ToUpper()=="MSJET")
		{
			cstr="Provider="+System.Configuration.ConfigurationManager.AppSettings["db_OleDbProv"].ToString()+";Data Source="+System.Configuration.ConfigurationManager.AppSettings["db_OleDbPath"].ToString()+System.Configuration.ConfigurationManager.AppSettings["db_OleDbFile"].ToString()+";"+System.Configuration.ConfigurationManager.AppSettings["db_OleDbOptions"].ToString();
		}
		else if (System.Configuration.ConfigurationManager.AppSettings["db_type"].ToString().ToUpper()=="MSSQL")
		{
			cstr="Data Source="+System.Configuration.ConfigurationManager.AppSettings["db_SqlDbServer"].ToString()+";Initial Catalog="+System.Configuration.ConfigurationManager.AppSettings["db_SqlDbName"].ToString()+";User Id="+System.Configuration.ConfigurationManager.AppSettings["db_SqlDbUser"].ToString()+";Password="+System.Configuration.ConfigurationManager.AppSettings["db_SqlDbPass"].ToString()+";"+System.Configuration.ConfigurationManager.AppSettings["db_SqlDbOptions"].ToString();
		}
		else if (System.Configuration.ConfigurationManager.AppSettings["db_type"].ToString().ToUpper()=="ORACLE")
		{
			cstr="Data Source="+System.Configuration.ConfigurationManager.AppSettings["db_OracleDbUser"].ToString()+"/"+System.Configuration.ConfigurationManager.AppSettings["db_OracleDbPass"].ToString()+"@"+System.Configuration.ConfigurationManager.AppSettings["db_OracleDbServer"].ToString()+"/"+System.Configuration.ConfigurationManager.AppSettings["db_OracleDbService"].ToString()+"/"+System.Configuration.ConfigurationManager.AppSettings["db_OracleDbInstance"].ToString()+";"+System.Configuration.ConfigurationManager.AppSettings["db_OracleDbOptions"].ToString();
		}
		else if (System.Configuration.ConfigurationManager.AppSettings["db_type"].ToString().ToUpper()=="ODBC")
		{
			cstr="Dsn="+System.Configuration.ConfigurationManager.AppSettings["db_OdbcDbDsn"].ToString()+";Uid="+System.Configuration.ConfigurationManager.AppSettings["db_OdbcDbUser"].ToString()+";Pwd="+System.Configuration.ConfigurationManager.AppSettings["db_OdbcDbPass"].ToString()+";"+System.Configuration.ConfigurationManager.AppSettings["db_OdbcDbOptions"].ToString();
		}
	}

/// <summary>
///   The <see cref="Encrypt(string)"/> non-static method is used to apply Rinjadel (MD5/SHA1) encryption to a given string value.
/// </summary>
/// <param name="plainText">
///   A <see cref="System.String"/> containing the text to be encrypted.
/// </param>
/// <returns> 
///   A <see cref="System.String"/> containing SHA1/MD5 encrypted string value.
/// </returns>
/// <remarks>
///   Based on sample code from <see cref="!http://www.obviex.com/samples/code.aspx?source=encryptioncs&title=symmetric%20key%20encryption&lang=c%23">HERE</see> in accordance with legal requirements <see cref="http://www.obviex.com/Legal.aspx#Samples">HERE</see>.
///    THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, 
///    EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED 
///    WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE.
/// 
///    Copyright (C) 2002 Obviex(TM). All rights reserved.
/// </remarks>
    public string Encrypt(string plainText)
    {
		if (plainText!="" && plainText!=null)
		{
			string cipherCheck;
			if (plainText.Length>3)
			{
				cipherCheck=plainText.Substring(0,3);
			}
			else
			{
				cipherCheck="";
			}
			if (cipherCheck==System.Configuration.ConfigurationManager.AppSettings["cipherPrefix"].ToString())
			{
				return plainText;
			}
			else
			{
			    // Convert strings into byte arrays.
		        // Let us assume that strings only contain ASCII codes.
				// If strings include Unicode characters, use Unicode, UTF7, or UTF8 
				// encoding.
		        byte[] initVectorBytes = Encoding.ASCII.GetBytes(initVector);
				byte[] saltValueBytes  = Encoding.ASCII.GetBytes(saltValue);
			
				// Convert our plaintext into a byte array.
		        // Let us assume that plaintext contains UTF8-encoded characters.
				byte[] plainTextBytes  = Encoding.UTF8.GetBytes(plainText);
        
			    // First, we must create a password, from which the key will be derived.
				// This password will be generated from the specified passphrase and 
				// salt value. The password will be created using the specified hash 
			    // algorithm. Password creation can be done in several iterations.
			    PasswordDeriveBytes password = new PasswordDeriveBytes(
								                                passPhrase, 
							                                    saltValueBytes, 
						                                        hashAlgorithm, 
							                                    passwordIterations);
        
				// Use the password to generate pseudo-random bytes for the encryption
			    // key. Specify the size of the key in bytes (instead of bits).
			    byte[] keyBytes = password.GetBytes(keySize / 8);
        
				// Create uninitialized Rijndael encryption object.
			    RijndaelManaged symmetricKey = new RijndaelManaged();
        
		        // It is reasonable to set encryption mode to Cipher Block Chaining
				// (CBC). Use default options for other symmetric key parameters.
				symmetricKey.Mode = CipherMode.CBC;        
        
		        // Generate encryptor from the existing key bytes and initialization 
				// vector. Key size will be defined based on the number of the key 
			    // bytes.
				ICryptoTransform encryptor = symmetricKey.CreateEncryptor(
					                                             keyBytes, 
						                                         initVectorBytes);
        
		        // Define memory stream which will be used to hold encrypted data.
				MemoryStream memoryStream = new MemoryStream();        
                
			    // Define cryptographic stream (always use Write mode for encryption).
				CryptoStream cryptoStream = new CryptoStream(memoryStream, 
					                                         encryptor,
						                                     CryptoStreamMode.Write);
				// Start encrypting.
				cryptoStream.Write(plainTextBytes, 0, plainTextBytes.Length);
                
		        // Finish encrypting.
				cryptoStream.FlushFinalBlock();

			    // Convert our encrypted data from a memory stream into a byte array.
				byte[] cipherTextBytes = memoryStream.ToArray();
                
				// Close both streams.
			    memoryStream.Close();
			    cryptoStream.Close();
        
				// Convert encrypted data into a base64-encoded string.
		        string cipherText = Convert.ToBase64String(cipherTextBytes);
				cipherText=System.Configuration.ConfigurationManager.AppSettings["cipherPrefix"].ToString()+cipherText;
        
			    // Return encrypted string.
				return cipherText;
			}
		}
		else
		{
			return plainText;
		}
    }

/// <summary>
///   The <see cref="Decrypt(string)"/> non-static method is used to decrypt a Rinjadel (MD5/SHA1) encrypted string to plain text.
/// </summary>
/// <param name="cipherText">
///   A <see cref="System.String"/> containing SHA1/MD5 encrypted string value.
/// </param>
/// <returns> 
///   A <see cref="System.String"/> containing the text to be encrypted.
/// </returns>
/// <remarks>
///   Based on sample code from <see cref="!http://www.obviex.com/samples/code.aspx?source=encryptioncs&title=symmetric%20key%20encryption&lang=c%23">HERE</see> in accordance with legal requirements <see cref="http://www.obviex.com/Legal.aspx#Samples">HERE</see>.
///    THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, 
///    EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED 
///    WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE.
/// 
///    Copyright (C) 2002 Obviex(TM). All rights reserved.
/// </remarks>
    public string Decrypt(string cipherText)
    {


		if (cipherText!="" && cipherText!=null)
		{
			string cipherCheck=cipherText.Substring(0,3);
			if (cipherCheck!=System.Configuration.ConfigurationManager.AppSettings["cipherPrefix"].ToString())
			{
				return cipherText;
			}
			else
			{
				// Convert strings defining encryption key characteristics into byte
			    // arrays. Let us assume that strings only contain ASCII codes.
			    // If strings include Unicode characters, use Unicode, UTF7, or UTF8
				// encoding.
			    byte[] initVectorBytes = Encoding.ASCII.GetBytes(initVector);
		        byte[] saltValueBytes  = Encoding.ASCII.GetBytes(saltValue);
			
				// Convert our ciphertext into a byte array.
				int cipherLen = cipherText.Length - 3;
		        byte[] cipherTextBytes = Convert.FromBase64String(cipherText.Substring(3,cipherLen));
		    
				// First, we must create a password, from which the key will be 
				// derived. This password will be generated from the specified 
		        // passphrase and salt value. The password will be created using
				// the specified hash algorithm. Password creation can be done in
			    // several iterations.
				PasswordDeriveBytes password = new PasswordDeriveBytes(
								                                passPhrase, 
							                                    saltValueBytes, 
						                                        hashAlgorithm, 
					                                            passwordIterations);
			
				// Use the password to generate pseudo-random bytes for the encryption
			    // key. Specify the size of the key in bytes (instead of bits).
		        byte[] keyBytes = password.GetBytes(keySize / 8);
			
				// Create uninitialized Rijndael encryption object.
			    RijndaelManaged    symmetricKey = new RijndaelManaged();
        
		        // It is reasonable to set encryption mode to Cipher Block Chaining
				// (CBC). Use default options for other symmetric key parameters.
				symmetricKey.Mode = CipherMode.CBC;
        
		        // Generate decryptor from the existing key bytes and initialization 
				// vector. Key size will be defined based on the number of the key 
			    // bytes.
				ICryptoTransform decryptor = symmetricKey.CreateDecryptor(
				                                                 keyBytes, 
			                                                     initVectorBytes);
        
			    // Define memory stream which will be used to hold encrypted data.
				MemoryStream  memoryStream = new MemoryStream(cipherTextBytes);
                
			    // Define cryptographic stream (always use Read mode for encryption).
		        CryptoStream  cryptoStream = new CryptoStream(memoryStream, 
						                                      decryptor,
					                                          CryptoStreamMode.Read);

				// Since at this point we don't know what the size of decrypted data
			    // will be, allocate the buffer long enough to hold ciphertext;
			    // plaintext is never longer than ciphertext.
				byte[] plainTextBytes = new byte[cipherTextBytes.Length];
        
			    // Start decrypting.
		        int decryptedByteCount = cryptoStream.Read(plainTextBytes, 
						                                   0, 
					                                       plainTextBytes.Length);
                
				// Close both streams.
			    memoryStream.Close();
			    cryptoStream.Close();
        
				// Convert decrypted data into a string. 
			    // Let us assume that the original plaintext string was UTF8-encoded.
		        string plainText = Encoding.UTF8.GetString(plainTextBytes, 
					                                       0, 
				                                           decryptedByteCount);
        
			    // Return decrypted string.   
		       return plainText;
			}
		}
		else
		{
			return cipherText;
		}
    }

/// <summary>
///   The <see cref="testDb(string, string, string, string, string, string, string)"/> non-static method is used to test the connection the backend database.
/// </summary>
/// <param name="dbType">
///   A <see cref="System.String"/> containing a blurb of information to be used to build the connection string.
/// </param>
/// <param name="arg1">
///   A <see cref="System.String"/> containing a blurb of information to be used to build the connection string.
/// </param>
/// <param name="arg2">
///   A <see cref="System.String"/> containinga blurb of information to be used to build the connection string.
/// </param>
/// <param name="arg3">
///   A <see cref="System.String"/> containing a blurb of information to be used to build the connection string.
/// </param>
/// <param name="arg4">
///   A <see cref="System.String"/> containing a blurb of information to be used to build the connection string.
/// </param>
/// <param name="arg5">
///   A <see cref="System.String"/> containing a blurb of information to be used to build the connection string.
/// </param>
/// <param name="arg6">
///   A <see cref="System.String"/> containing a blurb of information to be used to build the connection string.
/// </param>
/// <returns> 
///   A <see cref="System.String"/> containing the status of the test; an string beginning with 'OK:' denotes success.
/// </returns>
/// <remarks>
///   This method does a simple test of the a database connection.
/// </remarks>
	public string testDb(string dbType, string arg1, string arg2, string arg3, string arg4, string arg5, string arg6)
	{
		string status="";
		string dbCstr="";
		switch (dbType.ToUpper())
		{
		case "MSJET":
			dbCstr="Provider="+arg1+";Data Source="+arg3+arg2+";"+arg4;
			try
			{
				using(OleDbConnection con = new OleDbConnection(dbCstr))
				{
					con.Open();
					status="OK: "+dbType+"-"+con.ServerVersion+"-"+con.State.ToString();
					con.Close();
				}
			}
			catch (System.Exception ex)
			{
				status=dbType+": "+ex.ToString();
			}
			break;
		case "MSSQL":
			dbCstr="Data Source="+arg1+";Initial Catalog="+arg2+";User Id="+arg3+";Password="+arg4+";"+arg5;
			try
			{
				using(SqlConnection con = new SqlConnection(dbCstr))
				{
					con.Open();
					status="OK: "+dbType+"-"+con.ServerVersion+"-"+con.State.ToString();
					con.Close();
				}
			}
			catch (System.Exception ex)
			{
				status=dbType+": "+ex.ToString();
			}
			break;
		case "ORACLE":
			dbCstr="Data Source="+arg4+"/"+arg5+"@"+arg1+"/"+arg3+"/"+arg2+";"+arg6;
			try
			{
				using(OracleConnection con = new OracleConnection(dbCstr))
				{
					con.Open();
					status="OK: "+dbType+"-"+con.ServerVersion+"-"+con.State.ToString();
					con.Close();
				}
			}
			catch (System.Exception ex)
			{
				status=dbType+": "+ex.ToString();
			}
			break;
		case "ODBC":
			dbCstr="Dsn="+arg1+";Uid="+arg2+";Pwd="+arg3+";"+arg4;
			try
			{
				using(OdbcConnection con = new OdbcConnection(dbCstr))
				{
					con.Open();
					status="OK: "+dbType+"-"+con.ServerVersion+"-"+con.State.ToString();
					con.Close();
				}
			}
			catch (System.Exception ex)
			{
				status=dbType+": "+ex.ToString();
			}
			break;
		}
		return status;
	}

/// <summary>
///   The <see cref="readDb(string)"/> non-static method is used to fetch data from the backend database.
/// </summary>
/// <param name="sql">
///   A <see cref="System.String"/> containing a SQL Query (SELECT, SHOW).
/// </param>
/// <returns> 
///   A <see cref="System.Data.DataSet"/> containing the table(s) containing the records returned from the database SQL query.  NOTE: The method will return null if the query succeeded but returned no records for the query.
/// </returns>
/// <exception cref="System.Exception"> 
///   Thrown when the SQL database engine encounters an error.
/// </exception>
/// <seealso cref="readDbOle(string)">
///	  This is the underlying database query method used when the <c>db_type</c> key in the IIS web.config file is set to 'MSJET' (MS-Access).
/// </seealso>
/// <seealso cref="readDbSql(string)">
///	  This is the underlying database query method used when the <c>db_type</c> key in the IIS web.config file is set to 'MSSQL' (MS SQL Server, T-SQL).
/// </seealso>
/// <seealso cref="readDbOracle(string)">
///	  This is the underlying database query method used when the <c>db_type</c> key in the IIS web.config file is set to 'ORACLE' (Oracle Server).
/// </seealso>
/// <seealso cref="readDbOdbc(string)">
///	  This is the underlying database query method used when the <c>db_type</c> key in the IIS web.config file is set to 'ODBC' (Any other ODBC-Driver based Database Connection).
/// </seealso>
/// <remarks>
///   This method is a wrapper for the 4 type-specific database read queries.  The database type is defined by the value of the <c>db_type</c> key in the IIS web.config file.   
/// </remarks>
	public DataSet readDb(string sql)
	{
		DataSet dat = new DataSet();
		switch (System.Configuration.ConfigurationManager.AppSettings["db_type"].ToString().ToUpper())
		{
		case "MSJET":
			try
			{
				dat=readDbOle(sql);
			}
			catch (System.Exception ex)
			{
				throw ex;
			}
			break;
		case "MSSQL":
			try
			{
				dat=readDbSql(sql);
			}
			catch (System.Exception ex)
			{
				throw ex;
			}
			break;
		case "ORACLE":
			try
			{
				dat=readDbOracle(sql);
			}
			catch (System.Exception ex)
			{
				throw ex;
			}
			break;
		case "ODBC":
			try
			{
				dat=readDbOdbc(sql);
			}
			catch (System.Exception ex)
			{
				throw ex;
			}
			break;
		}
		if (dat!=null && (dat.Tables.Count==0 || dat.Tables[0].Rows.Count==0)) dat=null;
		return dat;
	}

/// <summary>
///   The <see cref="writeDb(string)"/> non-static method is used to update the backend database.
/// </summary>
/// <param name="sql">
///   A <see cref="System.String"/> containing an updateable SQL Query (CREATE, ALTER, INSERT, UPDATE), Multilines will be split on the semicolon.
/// </param>
/// <returns> 
///   A <see cref="System.String"/> containing the result of the SQL update(s), a successful update returns an empty string.
/// </returns>
/// <seealso cref="writeDbOle(string)">
///	  This is the underlying database update method used when the <c>db_type</c> key in the IIS web.config file is set to 'MSJET' (MS-Access).
/// </seealso>
/// <seealso cref="writeDbSql(string)">
///	  This is the underlying database update method used when the <c>db_type</c> key in the IIS web.config file is set to 'MSSQL' (MS SQL Server, T-SQL).
/// </seealso>
/// <seealso cref="writeDbOracle(string)">
///	  This is the underlying database update method used when the <c>db_type</c> key in the IIS web.config file is set to 'ORACLE' (Oracle Server).
/// </seealso>
/// <seealso cref="writeDbOdbc(string)">
///	  This is the underlying database update method used when the <c>db_type</c> key in the IIS web.config file is set to 'ODBC' (Any other ODBC-Driver based Database Connection).
/// </seealso>
/// <remarks>
///   This method is a wrapper for the 4 type-specific database update queries.  The database type is defined by the value of the <c>db_type</c> key in the IIS web.config file.   
/// </remarks>
	public string writeDb(string sql)
	{
		string result="";
		switch (System.Configuration.ConfigurationManager.AppSettings["db_type"].ToString().ToUpper())
		{
		case "MSJET":
			try
			{
				result=writeDbOle(sql);
			}
			catch (System.Exception ex)
			{
				result=ex.ToString();
			}
			break;
		case "MSSQL":
			try
			{
				result=writeDbSql(sql);
			}
			catch (System.Exception ex)
			{
				result=ex.ToString();
			}
			break;
		case "ORACLE":
			try
			{
				result=writeDbOracle(sql);
			}
			catch (System.Exception ex)
			{
				result=ex.ToString();
			}
			break;
		case "ODBC":
			try
			{
				result=writeDbOdbc(sql);
			}
			catch (System.Exception ex)
			{
				result=ex.ToString();
			}
			break;
		}

		if (result!="")
		{
				result=System.Configuration.ConfigurationManager.AppSettings["db_type"].ToString().ToUpper()+":"+result;
		}
		return result;
	}

/// <summary>
///   The <see cref="readDbMulti(string)"/> non-static method is used to fetch data from the backend database.
/// </summary>
/// <param name="sql">
///   A <see cref="System.String"/> containing a SQL Query (SELECT, SHOW).
/// </param>
/// <returns> 
///   A <see cref="System.Data.DataSet"/> containing the table(s) containing the records returned from the database SQL query.  NOTE: The method will return null if the query succeeded but returned no records for the query.
/// </returns>
/// <exception cref="System.Exception"> 
///   Thrown when the SQL database engine encounters an error.
/// </exception>
/// <seealso cref="readDbOle(string)">
///	  This is the underlying database query method used when the <c>db_type</c> key in the IIS web.config file is set to 'MSJET' (MS-Access).
/// </seealso>
/// <seealso cref="readDbSql(string)">
///	  This is the underlying database query method used when the <c>db_type</c> key in the IIS web.config file is set to 'MSSQL' (MS SQL Server, T-SQL).
/// </seealso>
/// <seealso cref="readDbOracle(string)">
///	  This is the underlying database query method used when the <c>db_type</c> key in the IIS web.config file is set to 'ORACLE' (Oracle Server).
/// </seealso>
/// <seealso cref="readDbOdbc(string)">
///	  This is the underlying database query method used when the <c>db_type</c> key in the IIS web.config file is set to 'ODBC' (Any other ODBC-Driver based Database Connection).
/// </seealso>
/// <remarks>
///   This method is a wrapper for the 4 type-specific database read queries.  The database type is defined by the value of the <c>db_type</c> key in the IIS web.config file.   
/// </remarks>
	public DataSet readDbMulti(string sql)
	{
		DataSet dat = new DataSet();
		DataSet returnDat = new DataSet();
		int count=0;
		sql.Trim();
		if (!sql.EndsWith(";"))
		{
			sql=sql+";";
		}

		string[] sqlCmds = sql.Split(';');
		foreach (string sqlCmd in sqlCmds)
		{
			dat=null;
			if (sqlCmd!="")
			{
				switch (System.Configuration.ConfigurationManager.AppSettings["db_type"].ToString().ToUpper())
				{
				case "MSJET":
					try
					{
						dat=readDbOle(sqlCmd);
					}
					catch (System.Exception ex)
					{
						throw ex;
					}
					break;
				case "MSSQL":
					try
					{
						dat=readDbSql(sqlCmd);
					}
					catch (System.Exception ex)
					{
						throw ex;
					}
					break;
				case "ORACLE":
					try
					{
						dat=readDbOracle(sqlCmd);
					}
					catch (System.Exception ex)
					{
						throw ex;
					}
					break;
				case "ODBC":
					try
					{
						dat=readDbOdbc(sqlCmd);
					}
					catch (System.Exception ex)
					{
						throw ex;
					}
					break;
				}
			}
			if (dat!=null && dat.Tables.Count==0) returnDat.Tables.Add(dat.Tables[count]);
			count++;
		}
		if (returnDat!=null && (returnDat.Tables.Count==0 || returnDat.Tables[0].Rows.Count==0)) returnDat=null;
		return returnDat;
	}

/// <summary>
///   The <see cref="writeDbMulti(string)"/> non-static method is used to update the backend database.
/// </summary>
/// <param name="sql">
///   A <see cref="System.String"/> containing an updateable SQL Query (CREATE, ALTER, INSERT, UPDATE), Multilines will be split on the semicolon.
/// </param>
/// <returns> 
///   A <see cref="System.String"/> containing the result of the SQL update(s), a successful update returns an empty string.
/// </returns>
/// <seealso cref="writeDbOle(string)">
///	  This is the underlying database update method used when the <c>db_type</c> key in the IIS web.config file is set to 'MSJET' (MS-Access).
/// </seealso>
/// <seealso cref="writeDbSql(string)">
///	  This is the underlying database update method used when the <c>db_type</c> key in the IIS web.config file is set to 'MSSQL' (MS SQL Server, T-SQL).
/// </seealso>
/// <seealso cref="writeDbOracle(string)">
///	  This is the underlying database update method used when the <c>db_type</c> key in the IIS web.config file is set to 'ORACLE' (Oracle Server).
/// </seealso>
/// <seealso cref="writeDbOdbc(string)">
///	  This is the underlying database update method used when the <c>db_type</c> key in the IIS web.config file is set to 'ODBC' (Any other ODBC-Driver based Database Connection).
/// </seealso>
/// <remarks>
///   This method is a wrapper for the 4 type-specific database update queries.  The database type is defined by the value of the <c>db_type</c> key in the IIS web.config file.   
/// </remarks>
	public string writeDbMulti(string sql)
	{
		string result="", results="";
		int count=1;
		sql.Trim();
		if (!sql.EndsWith(";"))
		{
			sql=sql+";";
		}

		string[] sqlCmds = sql.Split(';');
		foreach (string sqlCmd in sqlCmds)
		{
			switch (System.Configuration.ConfigurationManager.AppSettings["db_type"].ToString().ToUpper())
			{
			case "MSJET":
				try
				{
					result=writeDbOle(sqlCmd);
				}
				catch (System.Exception ex)
				{
					result="<SPAN class='bold'>Error at Line "+count.ToString()+" - <SPAN class='italic'>("+sqlCmd+")</SPAN>:</SPAN> "+ex.ToString()+"<BR/><BR/>";
				}
				break;
			case "MSSQL":
				try
				{
					result=writeDbSql(sqlCmd);
				}
				catch (System.Exception ex)
				{
					result="<SPAN class='bold'>Error at Line "+count.ToString()+" - <SPAN class='italic'>("+sqlCmd+")</SPAN>:</SPAN> "+ex.ToString()+"<BR/><BR/>";
				}
				break;
			case "ORACLE":
				try
				{
					result=writeDbOracle(sqlCmd);
				}
				catch (System.Exception ex)
				{
					result="<SPAN class='bold'>Error at Line "+count.ToString()+" - <SPAN class='italic'>("+sqlCmd+")</SPAN>:</SPAN> "+ex.ToString()+"<BR/><BR/>";
				}
				break;
			case "ODBC":
				try
				{
					result=writeDbOdbc(sqlCmd);
				}
				catch (System.Exception ex)
				{
					result="<SPAN class='bold'>Error at Line "+count.ToString()+" - <SPAN class='italic'>("+sqlCmd+")</SPAN>:</SPAN> "+ex.ToString()+"<BR/><BR/>";
				}
				break;
			}
			results=results+", "+result;
			count++;
		}

		if (result!="")
		{
				results=System.Configuration.ConfigurationManager.AppSettings["db_type"].ToString().ToUpper()+":"+results;
		}
		return results;
	}

/// <summary>
///   The <see cref="readDb(string, string)"/> non-static method is used to update the backend database.
/// </summary>
/// <param name="sql">
///   A <see cref="System.String"/> containing a SQL Query (SELECT, SHOW).
/// </param>
/// <param name="dbType">
///   A <see cref="System.String"/> containing the specific type of database connection to be used ('MSJET','MSSQL','ORACLE','ODBC').
/// </param>
/// <returns> 
///   A <see cref="System.Data.DataSet"/> containing the table(s) containing the records returned from the database SQL query.  NOTE: The method will return null if the query succeeded but returned no records for the query.
/// </returns>
/// <seealso cref="readDbOle(string)">
///	  This is the underlying database query method used when the <c>db_type</c> key in the IIS web.config file is set to 'MSJET' (MS-Access).
/// </seealso>
/// <seealso cref="readDbSql(string)">
///	  This is the underlying database query method used when the <c>db_type</c> key in the IIS web.config file is set to 'MSSQL' (MS SQL Server, T-SQL).
/// </seealso>
/// <seealso cref="readDbOracle(string)">
///	  This is the underlying database query method used when the <c>db_type</c> key in the IIS web.config file is set to 'ORACLE' (Oracle Server).
/// </seealso>
/// <seealso cref="readDbOdbc(string)">
///	  This is the underlying database query method used when the <c>db_type</c> key in the IIS web.config file is set to 'ODBC' (Any other ODBC-Driver based Database Connection).
/// </seealso>
/// <remarks>
///   This method is a wrapper for the 4 type-specific database read queries.  
/// </remarks>
	public DataSet readDb(string sql,string dbType)
	{
		DataSet dat = new DataSet();
		string dbCstr="";
		switch (dbType)
		{
		case "MSJET" :
			dbCstr="Provider="+System.Configuration.ConfigurationManager.AppSettings["db_OleDbProv"].ToString()+";Data Source="+System.Configuration.ConfigurationManager.AppSettings["db_OleDbPath"].ToString()+System.Configuration.ConfigurationManager.AppSettings["db_OleDbFile"].ToString()+";"+System.Configuration.ConfigurationManager.AppSettings["db_OleDbOptions"].ToString();
			break;
		case "MSSQL" :
			dbCstr="Data Source="+System.Configuration.ConfigurationManager.AppSettings["db_SqlDbServer"].ToString()+";Initial Catalog="+System.Configuration.ConfigurationManager.AppSettings["db_SqlDbName"].ToString()+";User Id="+System.Configuration.ConfigurationManager.AppSettings["db_SqlDbUser"].ToString()+";Password="+System.Configuration.ConfigurationManager.AppSettings["db_SqlDbPass"].ToString()+";"+System.Configuration.ConfigurationManager.AppSettings["db_SqlDbOptions"].ToString();
			break;
		case "ORACLE" :
			dbCstr="Data Source="+System.Configuration.ConfigurationManager.AppSettings["db_OracleDbUser"].ToString()+"/"+System.Configuration.ConfigurationManager.AppSettings["db_OracleDbPass"].ToString()+"@"+System.Configuration.ConfigurationManager.AppSettings["db_OracleDbServer"].ToString()+"/"+System.Configuration.ConfigurationManager.AppSettings["db_OracleDbService"].ToString()+"/"+System.Configuration.ConfigurationManager.AppSettings["db_OracleDbInstance"].ToString()+";"+System.Configuration.ConfigurationManager.AppSettings["db_OracleDbOptions"].ToString();
			break;
		case "ODBC" :
			dbCstr="Dsn="+System.Configuration.ConfigurationManager.AppSettings["db_OdbcDbDsn"].ToString()+";Uid="+System.Configuration.ConfigurationManager.AppSettings["db_OdbcDbUser"].ToString()+";Pwd="+System.Configuration.ConfigurationManager.AppSettings["db_OdbcDbPass"].ToString()+";"+System.Configuration.ConfigurationManager.AppSettings["db_OdbcDbOptions"].ToString();
			break;
		}
		switch (dbType)
		{
		case "MSJET" :
			try
			{
				dat=readDbOle(sql,dbCstr);
			}
			catch (System.Exception ex)
			{
//				throw ex;
			}
			break;
		case "MSSQL" :
			try
			{
				dat=readDbSql(sql,dbCstr);
			}
			catch (System.Exception ex)
			{
//				throw ex;
			}
			break;
		case "ORACLE" :
			try
			{
				dat=readDbOracle(sql,dbCstr);
			}
			catch (System.Exception ex)
			{
//				throw ex;
			}
			break;
		case "ODBC" :
			try
			{
				dat=readDbOdbc(sql,dbCstr);
			}
			catch (System.Exception ex)
			{
//				throw ex;
			}
			break;
		}
		if (dat!=null && (dat.Tables.Count==0 || dat.Tables[0].Rows.Count==0)) dat=null;
		return dat;
	}

/// <summary>
///   The <see cref="writeDb(string, string)"/> non-static method is used to update the backend database.
/// </summary>
/// <param name="sql">
///   A <see cref="System.String"/> containing an updateable SQL Query (CREATE, ALTER, INSERT, UPDATE).
/// </param>
/// <param name="dbType">
///   A <see cref="System.String"/> containing the specific type of database connection to be used ('MSJET','MSSQL','ORACLE','ODBC').
/// </param>
/// <returns> 
///   A <see cref="System.String"/> containing the result of the SQL update, a successful update returns an empty string.
/// </returns>
/// <seealso cref="writeDbOle(string)">
///	  This is the underlying database update method used when the <c>db_type</c> key in the IIS web.config file is set to 'MSJET' (MS-Access).
/// </seealso>
/// <seealso cref="writeDbSql(string)">
///	  This is the underlying database update method used when the <c>db_type</c> key in the IIS web.config file is set to 'MSSQL' (MS SQL Server, T-SQL).
/// </seealso>
/// <seealso cref="writeDbOracle(string)">
///	  This is the underlying database update method used when the <c>db_type</c> key in the IIS web.config file is set to 'ORACLE' (Oracle Server).
/// </seealso>
/// <seealso cref="writeDbOdbc(string)">
///	  This is the underlying database update method used when the <c>db_type</c> key in the IIS web.config file is set to 'ODBC' (Any other ODBC-Driver based Database Connection).
/// </seealso>
/// <remarks>
///   This method is a wrapper for the 4 type-specific database update queries.  
/// </remarks>
	public string writeDb(string sql, string dbType)
	{
		string result="";
		string dbCstr="";
		switch (dbType)
		{
		case "MSJET" :
			dbCstr="Provider="+System.Configuration.ConfigurationManager.AppSettings["db_OleDbProv"].ToString()+";Data Source="+System.Configuration.ConfigurationManager.AppSettings["db_OleDbPath"].ToString()+System.Configuration.ConfigurationManager.AppSettings["db_OleDbFile"].ToString()+";"+System.Configuration.ConfigurationManager.AppSettings["db_OleDbOptions"].ToString();
			break;
		case "MSSQL" :
			dbCstr="Data Source="+System.Configuration.ConfigurationManager.AppSettings["db_SqlDbServer"].ToString()+";Initial Catalog="+System.Configuration.ConfigurationManager.AppSettings["db_SqlDbName"].ToString()+";User Id="+System.Configuration.ConfigurationManager.AppSettings["db_SqlDbUser"].ToString()+";Password="+System.Configuration.ConfigurationManager.AppSettings["db_SqlDbPass"].ToString()+";"+System.Configuration.ConfigurationManager.AppSettings["db_SqlDbOptions"].ToString();
			break;
		case "ORACLE" :
			dbCstr="Data Source="+System.Configuration.ConfigurationManager.AppSettings["db_OracleDbUser"].ToString()+"/"+System.Configuration.ConfigurationManager.AppSettings["db_OracleDbPass"].ToString()+"@"+System.Configuration.ConfigurationManager.AppSettings["db_OracleDbServer"].ToString()+"/"+System.Configuration.ConfigurationManager.AppSettings["db_OracleDbService"].ToString()+"/"+System.Configuration.ConfigurationManager.AppSettings["db_OracleDbInstance"].ToString()+";"+System.Configuration.ConfigurationManager.AppSettings["db_OracleDbOptions"].ToString();
			break;
		case "ODBC" :
			dbCstr="Dsn="+System.Configuration.ConfigurationManager.AppSettings["db_OdbcDbDsn"].ToString()+";Uid="+System.Configuration.ConfigurationManager.AppSettings["db_OdbcDbUser"].ToString()+";Pwd="+System.Configuration.ConfigurationManager.AppSettings["db_OdbcDbPass"].ToString()+";"+System.Configuration.ConfigurationManager.AppSettings["db_OdbcDbOptions"].ToString();
			break;
		}
		switch (dbType)
		{
		case "MSJET" :
			try
			{
				result=writeDbOle(sql,dbCstr);
			}
			catch (System.Exception ex)
			{
				result=ex.ToString();
			}
			break;
		case "MSSQL" :
			try
			{
				result=writeDbSql(sql,dbCstr);
			}
			catch (System.Exception ex)
			{
				result=ex.ToString();
			}
			break;
		case "ORACLE" :
			try
			{
				result=writeDbOracle(sql,dbCstr);
			}
			catch (System.Exception ex)
			{
				result=ex.ToString();
			}
			break;
		case "ODBC" :
			try
			{
				result=writeDbOdbc(sql,dbCstr);
			}
			catch (System.Exception ex)
			{
				result=ex.ToString();
			}
			break;
		}
		return dbType+":"+result;
	}

/// <summary>
///   The <see cref="readDbMulti(string, string)"/> non-static method is used to update the backend database.
/// </summary>
/// <param name="sql">
///   A <see cref="System.String"/> containing a SQL Query (SELECT, SHOW).
/// </param>
/// <param name="dbType">
///   A <see cref="System.String"/> containing the specific type of database connection to be used ('MSJET','MSSQL','ORACLE','ODBC').
/// </param>
/// <returns> 
///   A <see cref="System.Data.DataSet"/> containing the table(s) containing the records returned from the database SQL query.  NOTE: The method will return null if the query succeeded but returned no records for the query.
/// </returns>
/// <seealso cref="readDbOle(string)">
///	  This is the underlying database query method used when the <c>db_type</c> key in the IIS web.config file is set to 'MSJET' (MS-Access).
/// </seealso>
/// <seealso cref="readDbSql(string)">
///	  This is the underlying database query method used when the <c>db_type</c> key in the IIS web.config file is set to 'MSSQL' (MS SQL Server, T-SQL).
/// </seealso>
/// <seealso cref="readDbOracle(string)">
///	  This is the underlying database query method used when the <c>db_type</c> key in the IIS web.config file is set to 'ORACLE' (Oracle Server).
/// </seealso>
/// <seealso cref="readDbOdbc(string)">
///	  This is the underlying database query method used when the <c>db_type</c> key in the IIS web.config file is set to 'ODBC' (Any other ODBC-Driver based Database Connection).
/// </seealso>
/// <remarks>
///   This method is a wrapper for the 4 type-specific database read queries.  
/// </remarks>
	public DataSet readDbMulti(string sql,string dbType)
	{
		DataSet dat = new DataSet();
		DataSet returnDat = new DataSet();
		string dbCstr="", err="", results="";
		int count=0;
		sql.Trim();
		if (!sql.EndsWith(";"))
		{
			sql=sql+";";
		}

		switch (dbType)
		{
		case "MSJET" :
			dbCstr="Provider="+System.Configuration.ConfigurationManager.AppSettings["db_OleDbProv"].ToString()+";Data Source="+System.Configuration.ConfigurationManager.AppSettings["db_OleDbPath"].ToString()+System.Configuration.ConfigurationManager.AppSettings["db_OleDbFile"].ToString()+";"+System.Configuration.ConfigurationManager.AppSettings["db_OleDbOptions"].ToString();
			break;
		case "MSSQL" :
			dbCstr="Data Source="+System.Configuration.ConfigurationManager.AppSettings["db_SqlDbServer"].ToString()+";Initial Catalog="+System.Configuration.ConfigurationManager.AppSettings["db_SqlDbName"].ToString()+";User Id="+System.Configuration.ConfigurationManager.AppSettings["db_SqlDbUser"].ToString()+";Password="+System.Configuration.ConfigurationManager.AppSettings["db_SqlDbPass"].ToString()+";"+System.Configuration.ConfigurationManager.AppSettings["db_SqlDbOptions"].ToString();
			break;
		case "ORACLE" :
			dbCstr="Data Source="+System.Configuration.ConfigurationManager.AppSettings["db_OracleDbUser"].ToString()+"/"+System.Configuration.ConfigurationManager.AppSettings["db_OracleDbPass"].ToString()+"@"+System.Configuration.ConfigurationManager.AppSettings["db_OracleDbServer"].ToString()+"/"+System.Configuration.ConfigurationManager.AppSettings["db_OracleDbService"].ToString()+"/"+System.Configuration.ConfigurationManager.AppSettings["db_OracleDbInstance"].ToString()+";"+System.Configuration.ConfigurationManager.AppSettings["db_OracleDbOptions"].ToString();
			break;
		case "ODBC" :
			dbCstr="Dsn="+System.Configuration.ConfigurationManager.AppSettings["db_OdbcDbDsn"].ToString()+";Uid="+System.Configuration.ConfigurationManager.AppSettings["db_OdbcDbUser"].ToString()+";Pwd="+System.Configuration.ConfigurationManager.AppSettings["db_OdbcDbPass"].ToString()+";"+System.Configuration.ConfigurationManager.AppSettings["db_OdbcDbOptions"].ToString();
			break;
		}
		string[] sqlCmds = sql.Split(';');
		while (err=="")
		{
			if (sqlCmds[count]!="")
			{
				switch (dbType)
				{
				case "MSJET" :
					try
					{
						dat=readDbOle(sqlCmds[count],dbCstr);
					}
					catch (System.Exception ex)
					{
						throw ex;
					}
					break;
				case "MSSQL" :
					try
					{
						dat=readDbSql(sqlCmds[count],dbCstr);
					}
					catch (System.Exception ex)
					{
						throw ex;
					}
					break;
				case "ORACLE" :
					try
					{
						dat=readDbOracle(sqlCmds[count],dbCstr);
					}
					catch (System.Exception ex)
					{
						throw ex;
					}
					break;
				case "ODBC" :
					try
					{
						dat=readDbOdbc(sqlCmds[count],dbCstr);
					}
					catch (System.Exception ex)
					{
						throw ex;
					}
					break;
				}
			}
			if (dat!=null && dat.Tables.Count==0) returnDat.Tables.Add(dat.Tables[count]);
			count++;
		}
		if (returnDat!=null && (returnDat.Tables.Count==0 || returnDat.Tables[0].Rows.Count==0)) returnDat=null;
		return returnDat;
	}

/// <summary>
///   The <see cref="writeDbMulti(string, string)"/> non-static method is used to update the backend database.
/// </summary>
/// <param name="sql">
///   A <see cref="System.String"/> containing an updateable SQL Query (CREATE, ALTER, INSERT, UPDATE).
/// </param>
/// <param name="dbType">
///   A <see cref="System.String"/> containing the specific type of database connection to be used ('MSJET','MSSQL','ORACLE','ODBC').
/// </param>
/// <returns> 
///   A <see cref="System.String"/> containing the result of the SQL update, a successful update returns an empty string.
/// </returns>
/// <seealso cref="writeDbOle(string)">
///	  This is the underlying database update method used when the <c>db_type</c> key in the IIS web.config file is set to 'MSJET' (MS-Access).
/// </seealso>
/// <seealso cref="writeDbSql(string)">
///	  This is the underlying database update method used when the <c>db_type</c> key in the IIS web.config file is set to 'MSSQL' (MS SQL Server, T-SQL).
/// </seealso>
/// <seealso cref="writeDbOracle(string)">
///	  This is the underlying database update method used when the <c>db_type</c> key in the IIS web.config file is set to 'ORACLE' (Oracle Server).
/// </seealso>
/// <seealso cref="writeDbOdbc(string)">
///	  This is the underlying database update method used when the <c>db_type</c> key in the IIS web.config file is set to 'ODBC' (Any other ODBC-Driver based Database Connection).
/// </seealso>
/// <remarks>
///   This method is a wrapper for the 4 type-specific database update queries.  
/// </remarks>
	public string writeDbMulti(string sql, string dbType)
	{
		string result="", results="";
		string dbCstr="";
		int count=1;
		sql.Trim();
		if (!sql.EndsWith(";"))
		{
			sql=sql+";";
		}

		switch (dbType)
		{
		case "MSJET" :
			dbCstr="Provider="+System.Configuration.ConfigurationManager.AppSettings["db_OleDbProv"].ToString()+";Data Source="+System.Configuration.ConfigurationManager.AppSettings["db_OleDbPath"].ToString()+System.Configuration.ConfigurationManager.AppSettings["db_OleDbFile"].ToString()+";"+System.Configuration.ConfigurationManager.AppSettings["db_OleDbOptions"].ToString();
			break;
		case "MSSQL" :
			dbCstr="Data Source="+System.Configuration.ConfigurationManager.AppSettings["db_SqlDbServer"].ToString()+";Initial Catalog="+System.Configuration.ConfigurationManager.AppSettings["db_SqlDbName"].ToString()+";User Id="+System.Configuration.ConfigurationManager.AppSettings["db_SqlDbUser"].ToString()+";Password="+System.Configuration.ConfigurationManager.AppSettings["db_SqlDbPass"].ToString()+";"+System.Configuration.ConfigurationManager.AppSettings["db_SqlDbOptions"].ToString();
			break;
		case "ORACLE" :
			dbCstr="Data Source="+System.Configuration.ConfigurationManager.AppSettings["db_OracleDbUser"].ToString()+"/"+System.Configuration.ConfigurationManager.AppSettings["db_OracleDbPass"].ToString()+"@"+System.Configuration.ConfigurationManager.AppSettings["db_OracleDbServer"].ToString()+"/"+System.Configuration.ConfigurationManager.AppSettings["db_OracleDbService"].ToString()+"/"+System.Configuration.ConfigurationManager.AppSettings["db_OracleDbInstance"].ToString()+";"+System.Configuration.ConfigurationManager.AppSettings["db_OracleDbOptions"].ToString();
			break;
		case "ODBC" :
			dbCstr="Dsn="+System.Configuration.ConfigurationManager.AppSettings["db_OdbcDbDsn"].ToString()+";Uid="+System.Configuration.ConfigurationManager.AppSettings["db_OdbcDbUser"].ToString()+";Pwd="+System.Configuration.ConfigurationManager.AppSettings["db_OdbcDbPass"].ToString()+";"+System.Configuration.ConfigurationManager.AppSettings["db_OdbcDbOptions"].ToString();
			break;
		}

		string[] sqlCmds = sql.Split(';');
		foreach (string sqlCmd in sqlCmds)
		{
			switch (dbType)
			{
			case "MSJET" :
				try
				{
					result=writeDbOle(sql,dbCstr);
				}
				catch (System.Exception ex)
				{
					result=ex.ToString();
				}
				break;
			case "MSSQL" :
				try
				{
					result=writeDbSql(sql,dbCstr);
				}
				catch (System.Exception ex)
				{
					result=ex.ToString();
				}
				break;
			case "ORACLE" :
				try
				{
					result=writeDbOracle(sql,dbCstr);
				}
				catch (System.Exception ex)
				{
					result=ex.ToString();
				}
				break;
			case "ODBC" :
				try
				{
					result=writeDbOdbc(sql,dbCstr);
				}
				catch (System.Exception ex)
				{
					result=ex.ToString();
				}
				break;
			}
			results=results+", "+result;
			count++;
		}

		if (result!="")
		{
				results=dbType+":"+results;
		}
		return results;
	}

/// <summary>
///   The <see cref="readDbOle(string)"/> non-static method is used to fetch data from MS-Jet (MS-Access) databases.
/// </summary>
/// <param name="sql">
///   A <see cref="System.String"/> containing a SQL Query (SELECT, SHOW).
/// </param>
/// <returns> 
///   A <see cref="System.Data.DataSet"/> containing the table(s) containing the records returned from the database SQL query.
/// </returns>
/// <remarks>
///   The method will return null if the query succeeded but returned no records for the query.
/// </remarks>
	public DataSet readDbOle(string sql)
	{
		OleDbConnection con;
		OleDbCommand cmd;
		OleDbDataAdapter dap;
		DataSet dat=new DataSet();
		con = new OleDbConnection(cstr);
		cmd = new OleDbCommand(sql,con);
		dap = new OleDbDataAdapter(cmd);
		dat = new DataSet();
		try
		{
			dap.Fill(dat);
		}
		catch (System.Exception ex)
		{
			cmd.Connection.Close();
//			throw ex;
		}
		cmd.Connection.Close();
		if (dat!=null && (dat.Tables.Count==0 || dat.Tables[0].Rows.Count==0)) dat=null;
		return dat; 
	}

/// <summary>
///   The <see cref="writeDbOle(string)"/> non-static method is used to update a MS Access (MS-Jet) database.
/// </summary>
/// <param name="sql">
///   A <see cref="System.String"/> containing an updateable SQL Query (CREATE, ALTER, INSERT, UPDATE).
/// </param>
/// <returns> 
///   A <see cref="System.String"/> containing the result of the SQL update.
/// </returns>
/// <remarks>
///    A successful update will return an empty string.
/// </remarks>
	public string writeDbOle(string sql)
	{
		OleDbConnection con;
		OleDbCommand cmd;
		string result="";
		con = new OleDbConnection(cstr);
		cmd = new OleDbCommand(sql,con);
		cmd.Connection.Open();
		try
		{
			cmd.ExecuteNonQuery();
		}
		catch (System.Exception ex)
		{
			cmd.Connection.Close();
			result=ex.ToString();
		}
		cmd.Connection.Close();
		return result;
	}

/// <summary>
///   The <see cref="readDbSql(string)"/> non-static method is used to fetch data from MS SQL Server (T-SQL) databases.
/// </summary>
/// <param name="sql">
///   A <see cref="System.String"/> containing a SQL Query (SELECT, SHOW).
/// </param>
/// <returns> 
///   A <see cref="System.Data.DataSet"/> containing the table(s) containing the records returned from the database SQL query.
/// </returns>
/// <remarks>
///   The method will return null if the query succeeded but returned no records for the query.
/// </remarks>
	public DataSet readDbSql(string sql)
	{
		SqlConnection con;
		SqlCommand cmd;
		SqlDataAdapter dap;
		DataSet dat=new DataSet();
//		Response.Write("CSTR:"+cstr+"<BR/>");
		con = new SqlConnection(cstr);
		cmd = new SqlCommand(sql,con);
		dap = new SqlDataAdapter(cmd); 
		dat = new DataSet(); 
		try
		{
			dap.Fill(dat);
		}
		catch (System.Exception ex)
		{
			cmd.Connection.Close();
//			Response.Write(System.Configuration.ConfigurationManager.AppSettings["db_type"].ToString().ToUpper()+":"+ex.ToString()+"<BR/>");
//			throw ex;
		}
		cmd.Connection.Close();
		if (dat!=null && (dat.Tables.Count==0 || dat.Tables[0].Rows.Count==0)) dat=null;
		return dat; 
	}

/// <summary>
///   The <see cref="writeDbSql(string)"/> non-static method is used to update a MS SQL Server (T-SQL) database.
/// </summary>
/// <param name="sql">
///   A <see cref="System.String"/> containing an updateable SQL Query (CREATE, ALTER, INSERT, UPDATE).
/// </param>
/// <returns> 
///   A <see cref="System.String"/> containing the result of the SQL update.
/// </returns>
/// <remarks>
///    A successful update will return an empty string.
/// </remarks>
	public string writeDbSql(string sql)
	{
		SqlConnection con;
		SqlCommand cmd;
		string result="";
		con = new SqlConnection(cstr);
		cmd = new SqlCommand(sql,con);
		cmd.Connection.Open();
		try
		{
			cmd.ExecuteNonQuery();
		}
		catch (System.Exception ex)
		{
			cmd.Connection.Close();
			result=ex.ToString();
		}
		cmd.Connection.Close();
		return result;
	}

/// <summary>
///   The <see cref="readDbOracle(string)"/> non-static method is used to fetch data from an Oracle databases.
/// </summary>
/// <param name="sql">
///   A <see cref="System.String"/> containing a SQL Query (SELECT, SHOW).
/// </param>
/// <returns> 
///   A <see cref="System.Data.DataSet"/> containing the table(s) containing the records returned from the database SQL query.
/// </returns>
/// <remarks>
///   The method will return null if the query succeeded but returned no records for the query.
/// </remarks>
	public DataSet readDbOracle(string sql)
	{
		OracleConnection con;
		OracleCommand cmd;
		OracleDataAdapter dap;
		DataSet dat=new DataSet();
		con = new OracleConnection(cstr);
		cmd = new OracleCommand(sql,con);
		dap = new OracleDataAdapter(cmd); 
		dat = new DataSet(); 
		try
		{
			dap.Fill(dat);
		}
		catch (System.Exception ex)
		{
			cmd.Connection.Close();
//			throw ex;
		}
		cmd.Connection.Close();
		if (dat!=null && (dat.Tables.Count==0 || dat.Tables[0].Rows.Count==0)) dat=null;
		return dat; 
	}

/// <summary>
///   The <see cref="writeDbOracle(string)"/> non-static method is used to update an Oracle database.
/// </summary>
/// <param name="sql">
///   A <see cref="System.String"/> containing an updateable SQL Query (CREATE, ALTER, INSERT, UPDATE).
/// </param>
/// <returns> 
///   A <see cref="System.String"/> containing the result of the SQL update.
/// </returns>
/// <remarks>
///    A successful update will return an empty string.
/// </remarks>
	public string writeDbOracle(string sql)
	{
		OracleConnection con;
		OracleCommand cmd;
		string result="";
		con = new OracleConnection(cstr);
		cmd = new OracleCommand(sql,con);
		cmd.Connection.Open();
		try
		{
			cmd.ExecuteNonQuery();
		}
		catch (System.Exception ex)
		{
			cmd.Connection.Close();
			result=ex.ToString();
		}
		cmd.Connection.Close();
		return result;
	}

/// <summary>
///   The <see cref="readDbOdbc(string)"/> non-static method is used to fetch data from any ODBC-Driver based databases.
/// </summary>
/// <param name="sql">
///   A <see cref="System.String"/> containing a SQL Query (SELECT, SHOW).
/// </param>
/// <returns> 
///   A <see cref="System.Data.DataSet"/> containing the table(s) containing the records returned from the database SQL query.
/// </returns>
/// <remarks>
///   The method will return null if the query succeeded but returned no records for the query.
/// </remarks>
	public DataSet readDbOdbc(string sql)
	{
		OdbcConnection con;
		OdbcCommand cmd;
		OdbcDataAdapter dap;
		DataSet dat=new DataSet();
		con = new OdbcConnection(cstr);
		cmd = new OdbcCommand(sql,con);
		dap = new OdbcDataAdapter(cmd); 
		dat = new DataSet(); 
		try
		{
			dap.Fill(dat);
		}
		catch (System.Exception ex)
		{
			cmd.Connection.Close();
//			throw ex;
		}
		cmd.Connection.Close();
		if (dat!=null && (dat.Tables.Count==0 || dat.Tables[0].Rows.Count==0)) dat=null;
		return dat; 
	}

/// <summary>
///   The <see cref="writeDbOdbc(string)"/> non-static method is used to update an ODBC-Driver based database.
/// </summary>
/// <param name="sql">
///   A <see cref="System.String"/> containing an updateable SQL Query (CREATE, ALTER, INSERT, UPDATE).
/// </param>
/// <returns> 
///   A <see cref="System.String"/> containing the result of the SQL update.
/// </returns>
/// <remarks>
///    A successful update will return an empty string.
/// </remarks>
	public string writeDbOdbc(string sql)
	{
		OdbcConnection con;
		OdbcCommand cmd;
		string result="";
		con = new OdbcConnection(cstr);
		cmd = new OdbcCommand(sql,con);
		cmd.Connection.Open();
		try
		{
			cmd.ExecuteNonQuery();
		}
		catch (System.Exception ex)
		{
			cmd.Connection.Close();
			result=ex.ToString();
		}
		cmd.Connection.Close();
		return result;
	}

/// <summary>
///   The <see cref="readChangeDetail(string)"/> non-static method is used to retrieve specific the details from a specific Windows Event Log entry.
/// </summary>
/// <param name="index">
///   A <see cref="System.String"/> containing the numerical index of a Windows Event Log entry.
/// </param>
/// <returns> 
///   A <see cref="System.Data.DataSet"/> containing the details for the specified Windows Event Log entry.
/// </returns>
/// <remarks>
///    This method will use the content of the <see cref="shortSysName"/> property.
/// </remarks>
	public DataSet readChangeDetail(string index)
	{
		DataSet dat = new DataSet();
		EventLog aLog = new EventLog();
		aLog.Log = shortSysName;
		aLog.MachineName = "localhost";
		if (aLog.Entries!=null && index!=null && index!="")
		{
			dat.Tables.Add("CISEvtLog");
			dat.Tables["CISEvtLog"].Columns.Add("Category", typeof(string));
			dat.Tables["CISEvtLog"].Columns.Add("CategoryNumber", typeof(string));
			dat.Tables["CISEvtLog"].Columns.Add("Data", typeof(string));
			dat.Tables["CISEvtLog"].Columns.Add("EntryType", typeof(string));
			dat.Tables["CISEvtLog"].Columns.Add("Index", typeof(string));
			dat.Tables["CISEvtLog"].Columns.Add("InstanceId", typeof(string));
			dat.Tables["CISEvtLog"].Columns.Add("MachineName", typeof(string));
			dat.Tables["CISEvtLog"].Columns.Add("Message", typeof(string));
			dat.Tables["CISEvtLog"].Columns.Add("ReplacementStrings", typeof(string));
			dat.Tables["CISEvtLog"].Columns.Add("Source", typeof(string));
			dat.Tables["CISEvtLog"].Columns.Add("TimeGenerated", typeof(string));
			dat.Tables["CISEvtLog"].Columns.Add("TimeWritten", typeof(string));
			foreach (EventLogEntry entry in aLog.Entries) 
			{
				if (entry.Index.ToString()==index)
				{
					DataRow newEvent = dat.Tables["CISEvtLog"].NewRow();
						if (entry.Category.ToString()!=null && entry.Category.ToString()!="")
						{
							newEvent["Category"]=entry.Category.ToString();
						}
						else 
						{
							newEvent["Category"]="";
						}
						if (entry.CategoryNumber.ToString()!=null && entry.CategoryNumber.ToString()!="")
						{
							newEvent["CategoryNumber"]=entry.CategoryNumber.ToString();
						}
						else 
						{
							newEvent["CategoryNumber"]="";
						}
						if (entry.Data.ToString()!=null && entry.Data.ToString()!="")
						{
							newEvent["Data"]=entry.Data.ToString();
						}
						else 
						{
							newEvent["Data"]="";
						}
						if (entry.EntryType.ToString()!=null && entry.EntryType.ToString()!="")
						{
							newEvent["EntryType"]=entry.EntryType.ToString();
						}
						else 
						{
							newEvent["EntryType"]="";
						}
						if (entry.Index.ToString()!=null && entry.Index.ToString()!="")
						{
							newEvent["Index"]=entry.Index.ToString();
						}
						else 
						{
							newEvent["Index"]="";
						}
						if (entry.InstanceId.ToString()!=null && entry.InstanceId.ToString()!="")
						{
							newEvent["InstanceId"]=entry.InstanceId.ToString();
						}
						else 
						{
							newEvent["InstanceId"]="";
						}
						if (entry.MachineName.ToString()!=null && entry.MachineName.ToString()!="")
						{
							newEvent["MachineName"]=entry.MachineName.ToString();
						}
						else 
						{
							newEvent["MachineName"]="";
						}
						if (entry.Message.ToString()!=null && entry.Message.ToString()!="")
						{
							newEvent["Message"]=entry.Message.ToString();
						}
						else 
						{
							newEvent["Message"]="";
						}
						if (entry.ReplacementStrings.ToString()!=null && entry.ReplacementStrings.ToString()!="")
						{
							newEvent["ReplacementStrings"]=entry.ReplacementStrings.ToString();
						}
						else 
						{
							newEvent["ReplacementStrings"]="";
						}
						if (entry.Source.ToString()!=null && entry.Source.ToString()!="")
						{
							newEvent["Source"]=entry.Source.ToString();
						}
						else 
						{
							newEvent["Source"]="";
						}
						if (entry.TimeGenerated.ToString()!=null && entry.TimeGenerated.ToString()!="")
						{
							newEvent["TimeGenerated"]=entry.TimeGenerated.ToString();
						}
						else 
						{
							newEvent["TimeGenerated"]="";
						}
						if (entry.TimeWritten.ToString()!=null && entry.TimeWritten.ToString()!="")
						{
							newEvent["TimeWritten"]=entry.TimeWritten.ToString();
						}
						else 
						{
							newEvent["TimeWritten"]="";
						}
					dat.Tables["CISEvtLog"].Rows.Add(newEvent);
				}
			}
		}
		return dat; 
	} 

/// <summary>
///   The <see cref="readChangeLog(string)"/> non-static method is used to retrieve all of the entries from a specific Windows Event Log Source.
/// </summary>
/// <param name="sourceMatch">
///   A <see cref="System.String"/> containing the name of the Windows Event Log Source.
/// </param>
/// <returns> 
///   A <see cref="System.Data.DataSet"/> containing the entries from a specific Windows Event Log Source.
/// </returns>
/// <remarks>
///    If no source name is passed, this method will use the content of the <see cref="shortSysName"/> property.
/// </remarks>
	public DataSet readChangeLog(string sourceMatch)
	{
		DataSet dat = new DataSet();
		EventLog aLog = new EventLog();
		aLog.Log = shortSysName;
		aLog.MachineName = "localhost";
		if (sourceMatch=="" || sourceMatch==null)
		{
			sourceMatch=shortSysName;
		}
		if (aLog.Entries!=null)
		{
			dat.Tables.Add("CISEvtLog");
			dat.Tables["CISEvtLog"].Columns.Add("Category", typeof(string));
			dat.Tables["CISEvtLog"].Columns.Add("CategoryNumber", typeof(string));
			dat.Tables["CISEvtLog"].Columns.Add("Data", typeof(string));
			dat.Tables["CISEvtLog"].Columns.Add("EntryType", typeof(string));
			dat.Tables["CISEvtLog"].Columns.Add("Index", typeof(string));
			dat.Tables["CISEvtLog"].Columns.Add("InstanceId", typeof(string));
			dat.Tables["CISEvtLog"].Columns.Add("MachineName", typeof(string));
			dat.Tables["CISEvtLog"].Columns.Add("Message", typeof(string));
			dat.Tables["CISEvtLog"].Columns.Add("ReplacementStrings", typeof(string));
			dat.Tables["CISEvtLog"].Columns.Add("Source", typeof(string));
			dat.Tables["CISEvtLog"].Columns.Add("TimeGenerated", typeof(string));
			dat.Tables["CISEvtLog"].Columns.Add("TimeWritten", typeof(string));
			foreach (EventLogEntry entry in aLog.Entries) 
			{
				if (entry.Source==sourceMatch)
				{
					DataRow newEvent = dat.Tables["CISEvtLog"].NewRow();
						if (entry.Category.ToString()!=null && entry.Category.ToString()!="")
						{
							newEvent["Category"]=entry.Category.ToString();
						}
						else 
						{
							newEvent["Category"]="";
						}
						if (entry.CategoryNumber.ToString()!=null && entry.CategoryNumber.ToString()!="")
						{
							newEvent["CategoryNumber"]=entry.CategoryNumber.ToString();
						}
						else 
						{
							newEvent["CategoryNumber"]="";
						}
						if (entry.Data.ToString()!=null && entry.Data.ToString()!="")
						{
							newEvent["Data"]=entry.Data.ToString();
						}
						else 
						{
							newEvent["Data"]="";
						}
						if (entry.EntryType.ToString()!=null && entry.EntryType.ToString()!="")
						{
							newEvent["EntryType"]=entry.EntryType.ToString();
						}
						else 
						{
							newEvent["EntryType"]="";
						}
						if (entry.Index.ToString()!=null && entry.Index.ToString()!="")
						{
							newEvent["Index"]=entry.Index.ToString();
						}
						else 
						{
							newEvent["Index"]="";
						}
						if (entry.InstanceId.ToString()!=null && entry.InstanceId.ToString()!="")
						{
							newEvent["InstanceId"]=entry.InstanceId.ToString();
						}
						else 
						{
							newEvent["InstanceId"]="";
						}
						if (entry.MachineName.ToString()!=null && entry.MachineName.ToString()!="")
						{
							newEvent["MachineName"]=entry.MachineName.ToString();
						}
						else 
						{
							newEvent["MachineName"]="";
						}
						if (entry.Message.ToString()!=null && entry.Message.ToString()!="")
						{
							newEvent["Message"]=entry.Message.ToString();
						}
						else 
						{
							newEvent["Message"]="";
						}
						if (entry.ReplacementStrings.ToString()!=null && entry.ReplacementStrings.ToString()!="")
						{
							newEvent["ReplacementStrings"]=entry.ReplacementStrings.ToString();
						}
						else 
						{
							newEvent["ReplacementStrings"]="";
						}
						if (entry.Source.ToString()!=null && entry.Source.ToString()!="")
						{
							newEvent["Source"]=entry.Source.ToString();
						}
						else 
						{
							newEvent["Source"]="";
						}
						if (entry.TimeGenerated.ToString()!=null && entry.TimeGenerated.ToString()!="")
						{
							newEvent["TimeGenerated"]=entry.TimeGenerated.ToString();
						}
						else 
						{
							newEvent["TimeGenerated"]="";
						}
						if (entry.TimeWritten.ToString()!=null && entry.TimeWritten.ToString()!="")
						{
							newEvent["TimeWritten"]=entry.TimeWritten.ToString();
						}
						else 
						{
							newEvent["TimeWritten"]="";
						}
					dat.Tables["CISEvtLog"].Rows.Add(newEvent);
				}
			}
		}
		return dat; 
	} 

/// <summary>
///   The <see cref="resetChangeLog()"/> non-static method is used to retrieve all of the entries from a specific Windows Event Log Source.
/// </summary>
/// <param name="index">
///   A <see cref="System.String"/> containing the name of the Windows Event Log Source.
/// </param>
/// <returns> 
///   A <see cref="System.Data.DataSet"/> containing the entries from a specific Windows Event Log Source.
/// </returns>
/// <remarks>
///    This method will use the content of the <see cref="shortSysName"/> property.
/// </remarks>
	public string resetChangeLog()
	{
		DataSet dat = new DataSet();
		DateTime dateStamp = DateTime.Now;
		dat=readChangeLog("");
		string sSource;
		string sLog;
		string result="";

		sSource = shortSysName;
		sLog = shortSysName;
		EventLog inputLog = new EventLog(sLog);
		
		if (dat!=null)
		{
			StreamWriter xmlDoc = new StreamWriter(Server.MapPath("./log_archive/changeLog_"+dateStamp.Month+dateStamp.Day+dateStamp.Year+"-"+dateStamp.Hour+dateStamp.Minute+dateStamp.Second+".xml"), false);
			try
			{
				dat.WriteXml(xmlDoc);
			}
			catch (Exception ex)
			{
				result="Could not archive Event Log: "+ex;
			}
			if (result=="")
			{
				inputLog.Clear();
				result="Success!";
			}
			xmlDoc.Close();
		}
		return result;
	}

/// <summary>
///   The <see cref="writeChangeLog(string, string, string)"/> non-static method is used to write a new Event Log entry to a Windows Event Log Source.
/// </summary>
/// <param name="dateStampVal">
///   A <see cref="System.String"/> containing the date/time stamp for the new Event Log entry.
/// </param>
/// <param name="changedByVal">
///   A <see cref="System.String"/> containing the name of the user / process associated with the new Event Log entry.
/// </param>
/// <param name="useCaseVal">
///   A <see cref="System.String"/> containing the name of the use case / source associated with the new Event Log entry.
/// </param>
/// <returns> 
///   A <see cref="System.String"/> containing the result status from writing the new Event Log entry to a Windows Event Log Source.
/// </returns>
/// <remarks>
///    This method will use the content of the <see cref="shortSysName"/> property.  This method will also call <see cref="resetChangeLog()"/> to archive and clear the Windows Event Log Source in the event that its full.
/// </remarks>
	public string writeChangeLog(string dateStampVal, string changedByVal, string useCaseVal)
	{
		string sSource;
		string sLog;
		string sEvent;
		string result="t";

		sSource = shortSysName;
		sLog = shortSysName;
		sEvent = changedByVal+" : "+useCaseVal+" @ "+dateStampVal;
		if (EventLog.Exists(sLog))
		{
			EventLogEntryType myEventLogEntryType = EventLogEntryType.Information;
		   	if (!EventLog.SourceExists(sSource))
				EventLog.CreateEventSource(sSource,sLog);
			EventLog inputLog = new EventLog(sLog);
			while (result!="Success!")
			{
				try
				{
					EventLog.WriteEntry(sSource, sEvent, myEventLogEntryType, 3333);
					result="Success!";
				}
				catch(Exception ex)
				{
					if (ex.ToString().Contains("The event log file is full"))
					{
						result=resetChangeLog();
					}
				}
				if (result!="Success!")
				{
					result="Windows could not write to the event log:";
				}
				else
				{
					result="Success!";
				}
			}
			result="";
		}
		else
		{
			EventLog.CreateEventSource(sSource,sLog);
			EventLog changeLog = new EventLog(sLog);
			changeLog.MaximumKilobytes = 20480;
			changeLog.ModifyOverflowPolicy(OverflowAction.DoNotOverwrite, 0);
		}
		return result; 
	}

/// <summary>
///   The <see cref="writeChangeLog(string, string, string, string)"/> non-static method is used to write a new Event Log entry to a Windows Event Log Source.
/// </summary>
/// <param name="dateStampVal">
///   A <see cref="System.String"/> containing the date/time stamp for the new Event Log entry.
/// </param>
/// <param name="changedByVal">
///   A <see cref="System.String"/> containing the name of the user / process associated with the new Event Log entry.
/// </param>
/// <param name="useCaseVal">
///   A <see cref="System.String"/> containing the name of the use case / source associated with the new Event Log entry.
/// </param>
/// <param name="type">
///   A <see cref="System.String"/> containing the name of the type to be associated with the new Event Log entry.
/// </param>
/// <returns> 
///   A <see cref="System.String"/> containing the result status from writing the new Event Log entry to a Windows Event Log Source.
/// </returns>
/// <remarks>
///    This method will use the content of the <see cref="shortSysName"/> property.  This method will also call <see cref="resetChangeLog()"/> to archive and clear the Windows Event Log Source in the event that its full.
/// </remarks>
	public string writeChangeLog(string dateStampVal, string changedByVal, string useCaseVal, string type)
	{
		string sSource;
		string sLog;
		string sEvent;
		string result="";

		sSource = shortSysName;
		sLog = shortSysName;
		sEvent = changedByVal+" : "+useCaseVal+" @ "+dateStampVal;
		if (EventLog.Exists(sLog))
		{
			EventLogEntryType myEventLogEntryType = EventLogEntryType.Information;
			switch (type)
			{
			case "W":
			case "w":
				myEventLogEntryType = EventLogEntryType.Warning;
				break;
			case "E":
			case "e":
				myEventLogEntryType = EventLogEntryType.Error;
				break;
			}
		   	if (!EventLog.SourceExists(sSource))
				EventLog.CreateEventSource(sSource,sLog);
			EventLog inputLog = new EventLog(sLog);
			while (result!="Success!")
			{
				try
				{
					EventLog.WriteEntry(sSource, sEvent, myEventLogEntryType, 3333);
					result="Success!";
				}
				catch(Exception ex)
				{
					if (ex.ToString().Contains("The event log file is full"))
					{
						result=resetChangeLog();
					}
				}
				if (result!="Success!")
				{
					result="Windows could not write to the event log:";
				}
				else
				{
					result="Success!";
				}
			}
			result="";
		}
		else
		{
			EventLog.CreateEventSource(sSource,sLog);
			EventLog changeLog = new EventLog(sLog);
			changeLog.MaximumKilobytes = 20480;
			changeLog.ModifyOverflowPolicy(OverflowAction.DoNotOverwrite, 0);
		}
		return result; 
	}

/// <summary>
///   The <see cref="writeChangeLog(string, string, string, string, int)"/> non-static method is used to write a new Event Log entry to a Windows Event Log Source.
/// </summary>
/// <param name="dateStampVal">
///   A <see cref="System.String"/> containing the date/time stamp for the new Event Log entry.
/// </param>
/// <param name="changedByVal">
///   A <see cref="System.String"/> containing the name of the user / process associated with the new Event Log entry.
/// </param>
/// <param name="useCaseVal">
///   A <see cref="System.String"/> containing the name of the use case / source associated with the new Event Log entry.
/// </param>
/// <param name="type">
///   A <see cref="System.String"/> containing the name of the type to be associated with the new Event Log entry.
/// </param>
/// <param name="eventId">
///   A <see cref="System.Int32"/> containing the eventId number to be associated with the new Event Log entry.
/// </param>
/// <returns> 
///   A <see cref="System.String"/> containing the result status from writing the new Event Log entry to a Windows Event Log Source.
/// </returns>
/// <remarks>
///    This method will use the content of the <see cref="shortSysName"/> property.  This method will also call <see cref="resetChangeLog()"/> to archive and clear the Windows Event Log Source in the event that its full.
/// </remarks>
	public string writeChangeLog(string dateStampVal, string changedByVal, string useCaseVal, string type, int eventId)
	{
		string sSource;
		string sLog;
		string sEvent;
		string result="";

		sSource = shortSysName;
		sLog = shortSysName;
		sEvent = changedByVal+" : "+useCaseVal+" @ "+dateStampVal;

		if (EventLog.Exists(sLog))
		{
			EventLogEntryType myEventLogEntryType = EventLogEntryType.Information;
			switch (type)
			{
			case "W":
			case "w":
				myEventLogEntryType = EventLogEntryType.Warning;
				break;
			case "E":
			case "e":
				myEventLogEntryType = EventLogEntryType.Error;
				break;
			}
		   	if (!EventLog.SourceExists(sSource))
				EventLog.CreateEventSource(sSource,sLog);
			EventLog inputLog = new EventLog(sLog);
			while (result!="Success!")
			{
				try
				{
					EventLog.WriteEntry(sSource, sEvent, myEventLogEntryType, 3333);
					result="Success!";
				}
				catch(Exception ex)
				{
					if (ex.ToString().Contains("The event log file is full"))
					{
						result=resetChangeLog();
					}
				}
				if (result!="Success!")
				{
					result="Windows could not write to the event log:";
				}
				else
				{
					result="Success!";
				}
			}
			result="";
		}
		else
		{
			EventLog.CreateEventSource(sSource,sLog);
			EventLog changeLog = new EventLog(sLog);
			changeLog.MaximumKilobytes = 20480;
			changeLog.ModifyOverflowPolicy(OverflowAction.DoNotOverwrite, 0);
		}
		return result; 
	}

/// <summary>
///   The <see cref="lockout()"/> non-static void method is used to execute to common code necessary to authentication-protect CIS application pages.
/// </summary>
/// <remarks>
///    This method checks the value of the <c>username</c> cookie, if missing or empty it performs a page redirect to the authentication page.
/// </remarks>
	public void lockout()
	{
		string v_username;
		try
		{
			v_username=Request.Cookies["username"].Value;
		}
		catch (System.Exception e)
		{
			v_username="";
		}
		if (v_username=="")
		{
			lastpage=Request.ServerVariables["SCRIPT_NAME"];
			Response.Redirect("adauth.aspx");
		}
	}

/// <summary>
///   The <see cref="systemStatus(int)"/> non-static void method is used to execute to common code necessary to facilitate 'down-for-maintenance' page redirects in the CIS application.
/// </summary>
/// <seealso cref="readDb(string)">
///	  The <see cref="readDb(string)"/> static property is accessed(required) by this method.
/// </seealso>
/// <remarks>
///    This method checks the value of the <c>sysStat.code</c> database record value, if <c>0</c> the sustem is down, if <c>1</c> the system is up.
/// </remarks>
	public void systemStatus(int i)
	{
		DataSet dat=new DataSet();
		string sql="SELECT * FROM sysStat";
		dat=readDb(sql);
		if (dat!=null)
		{
			if (dat.Tables[0].Rows[0]["code"].ToString()=="0")
			{
				if (i==1)
				{
					Response.Redirect("popup_down.aspx");
				}
				else
				{
					Response.Redirect("main_down.aspx");
				}
			}
		}
	}

/// <summary>
///   The <see cref="loggedIn()"/> non-static void method is used to execute to common code necessary to present 'the user is logged in' context functionality in the CIS application pages.
/// </summary>
/// <returns> 
///   A <see cref="System.String"/> containing the interactive HTML code for the context functionality.
/// </returns>
/// <remarks>
///    This method checks the value of the <c>firstname</c>,<c>lastname</c>,<c>username</c>,<c>role</c>, and <c>class</c> cookies, if missing or empty it performs a page redirect to the authentication page.
/// </remarks>
	public string loggedIn()
	{
		string v_username, v_firstname, v_lastname, v_roles="", v_uClass="", code;
		try
		{
			v_firstname=Decrypt(Request.Cookies["firstname"].Value);
			v_lastname=Decrypt(Request.Cookies["lastname"].Value);
			v_username=Decrypt(Request.Cookies["username"].Value);
			v_roles=Request.Cookies["role"].Value;
			v_uClass=Request.Cookies["class"].Value;
			code="<SPAN Title='Login: "+v_username+" - User Class: "+v_uClass+" - Roles: "+v_roles.Replace(" ","")+"'>Welcome,<BR/> "+v_firstname+" "+v_lastname+"!</SPAN><BR/><BR/><BR/><A HREF=logout.aspx>Logout</A>";
		}
		catch (System.Exception e)
		{
			v_username="";
			code="<A HREF=adauth.aspx>Login</A>";
		}
		return (code);
	}

/// <summary>
///   The <see cref="isAdmin()"/> non-static void method is used to execute to common code necessary to present 'the user is granted administrative priviledges' context functionality in the CIS application pages.
/// </summary>
/// <returns> 
///   A <see cref="System.String"/> containing the interactive HTML code for the context functionality.
/// </returns>
/// <remarks>
///    This method checks the value of the <c>role</c>, and <c>class</c> cookies for administrative priviledges and presents an admin context menu within the application.
/// </remarks>
	public string isAdmin()
	{
		string code="", code1="", title="", userClass="", userRole="";
		code="<BR/>";
		bool adminFlag;
		try
		{

			userClass=Request.Cookies["class"].Value;
			userRole=Request.Cookies["role"].Value;

			if (userClass=="99" || userClass=="3") adminFlag=true;
			else adminFlag=false;
			if (userClass=="99")
			{
				title="Dev / Admin";
				code1="<DIV><SPAN class='txtAlignMiddleLeft menuItem'><A HREF='adminSqlConsole.aspx' class='nodec'>SQL Console</A></SPAN><SPAN style='txtAlignMiddleRight menuIcon'><SPAN class='bold'>&#8594; </SPAN></SPAN></DIV><DIV><SPAN class='txtAlignMiddleLeft menuItem'><A HREF='adminSystemConsole.aspx' class='nodec'>System Console</A></SPAN><SPAN style='txtAlignMiddleRight menuIcon'><SPAN class='bold'>&#8594; </SPAN></SPAN></DIV>";
			}
			else
			{
				title="Administration";
				code1="";				
			}

			if (adminFlag)
			{
				code="<DIV class='menuSeparator'>"+title+"</DIV><DIV><SPAN class='txtAlignMiddleLeft menuItem'><A HREF='adminUsers.aspx' class='nodec'>Users &amp; Roles</A></SPAN><SPAN style='txtAlignMiddleRight menuIcon'><SPAN class='bold'>&#8594; </SPAN></SPAN></DIV><DIV><SPAN class='txtAlignMiddleLeft menuItem'><A HREF='adminChanges.aspx' class='nodec'>Change Log</A></SPAN><SPAN style='txtAlignMiddleRight menuIcon'><SPAN class='bold'>&#8594; </SPAN></SPAN></DIV><DIV><SPAN class='txtAlignMiddleLeft menuItem'><A HREF='adminHistory.aspx' class='nodec'>History</A></SPAN><SPAN style='txtAlignMiddleRight menuIcon'><SPAN class='bold'>&#8594; </SPAN></SPAN></DIV><DIV><SPAN class='txtAlignMiddleLeft menuItem'><A HREF='adminDataMigration.aspx' class='nodec'>Data Migration</A></SPAN><SPAN style='txtAlignMiddleRight menuIcon'><SPAN class='bold'>&#8594; </SPAN></SPAN></DIV><DIV><SPAN class='txtAlignMiddleLeft menuItem'><A HREF='adminNagiosExport.aspx' class='nodec'>Nagios Export</A></SPAN><SPAN style='txtAlignMiddleRight menuIcon'><SPAN class='bold'>&#8594; </SPAN></SPAN></DIV>"+code1;
			}
		}
		catch (System.Exception e)
		{
			code="not found";
		}
		return code;
	}

/// <summary>
///   The <see cref="showSearch()"/> non-static void method is used to execute to common code necessary to present search context functionality in the CIS application pages.
/// </summary>
/// <returns> 
///   A <see cref="System.String"/> containing the interactive HTML code for the context functionality.
/// </returns>
/// <remarks>
///    This method is at this time unused.
/// </remarks>
	public string showSearch()
	{
		string v_username, code;
		try
		{
			v_username=Request.Cookies["username"].Value;
			code="<%@ Register src=search.ascx TagPrefix=search TagName=forum%><search:forum Id=search runat=server />";
		}
		catch (System.Exception e)
		{
			v_username="";
			code="<TABLE cellspacing=0 class=datatable width=100%><TR class=tableheading><TD></TD></TR><TR><TD><A HREF=adauth.aspx>Login</A> to search Forum.</TD></TR></TABLE>";
//			throw e;
		}
		return (code);
	}

/// <summary>
///   The <see cref="Export_Click(object,ImageClickEventArgs)"/> non-static void method is used to execute to common code necessary to present 'export' functionality in the CIS application pages.
/// </summary>
/// <param name="sender">
///   A <see cref="System.Object"/> containing the name of sending event handler.
/// </param>
/// <param name="e">
///   A <see cref="System.ImageClickEventArgs"/> containing the on-click arguments for the sending event handler.
/// </param>
/// <remarks>
///    This method assumes a use-case identifier will be stored in the page <see cref="Page.ViewState"/> named <c>exportStr</c>, based on the content of <c>exportStr</c> either a 
///    pre-defined query or a custom SQL query stored in the <c>sqlArg</c> cookie will then be used to define what is to be exported.
/// </remarks>
	public void Export_Click(object sender, ImageClickEventArgs e)
	{	
		string exportStr = (string)ViewState["exportStr"];
		string sql="", sqlArg="", file = "";
		DateTime dateStamp = DateTime.Now;
		switch (exportStr)
		{
		case "bc":
			sqlArg = (string)ViewState["sqlArg"];
			sql = @"SELECT serverName, serverLanIP, serverRsaIp, serverOS, serverPurpose, rack, bc, Expr1008 AS slot, class, model, serial FROM (SELECT serverName, serverLanIP, serverRsaIp, serverOS, serverPurpose, rack, bc, FORMAT(slot,""\'@@@@@""),  class, model, serial, rackspace.rackspaceId, reserved FROM rackspace LEFT JOIN servers ON rackspace.rackspaceId=servers.rackspaceId WHERE bc='"+sqlArg+"' ORDER BY slot ASC) WHERE reserved='0'";
			file = "_"+exportStr + sqlArg + "_" +dateStamp.Hour.ToString() + dateStamp.Minute.ToString() + dateStamp.Second.ToString();
			break;
		case "rack":
			sqlArg = (string)ViewState["sqlArg"];
			sql = @"SELECT serverName, serverLanIP, serverRsaIp, serverOS, serverPurpose, rack, bc, Expr1008 AS slot, class, model, serial FROM (SELECT  * FROM (SELECT serverName, serverLanIP, serverRsaIp, serverOS, serverPurpose, rack, bc, FORMAT(slot,""\'@@@@@""),  class, model, serial, rackspace.rackspaceId, reserved FROM rackspace LEFT JOIN servers ON rackspace.rackspaceId=servers.rackspaceId WHERE rack='"+sqlArg+"' ORDER BY bc ASC, slot ASC) WHERE reserved='0') WHERE serverOS='AIX' OR  serverOS='Linux' OR  serverOS='Windows' OR  serverOS IS NULL";
			file = "_"+exportStr + sqlArg + "_" +dateStamp.Hour.ToString() + dateStamp.Minute.ToString() + dateStamp.Second.ToString();
			break;
		case "os":
			sqlArg = (string)ViewState["sqlArg"];
			sql = @"SELECT serverName, serverLanIP, serverRsaIp, serverOS, serverPurpose, rack, bc, Expr1008 AS slot, class, model, serial FROM(SELECT serverName, serverLanIP, serverRsaIp, serverOS, serverPurpose, rack, bc, FORMAT(slot,""\'@@@@@""),  class, model, serial, rackspace.rackspaceId, reserved FROM servers LEFT JOIN rackspace ON servers.rackspaceId=rackspace.rackspaceId WHERE serverOS='"+sqlArg+"' ORDER BY servername ASC, rack ASC)";
			file = "_"+exportStr + sqlArg + "_" +dateStamp.Hour.ToString() + dateStamp.Minute.ToString() + dateStamp.Second.ToString();
			break;
		case "env":
			sqlArg = (string)ViewState["sqlArg"];
			sql = @"SELECT serverName, serverLanIP, serverRsaIp, serverOS, serverPurpose, rack, bc, Expr1008 AS slot, class, model, serial FROM (SELECT serverName, serverLanIP, serverRsaIp, serverOS, serverPurpose, serverOS, rack, bc, FORMAT(slot,""\'@@@@@""),  class, model, serial, rackspace.rackspaceId, reserved FROM servers LEFT JOIN rackspace ON servers.rackspaceId=rackspace.rackspaceId WHERE serverName LIKE '%"+sqlArg+"%' ORDER BY serverName ASC)";
			switch (sqlArg)
			{
				case "All" :
					sql = @"SELECT serverName, serverLanIP, serverRsaIp, serverOS, serverPurpose, rack, bc, Expr1008 AS slot, class, model, serial FROM (SELECT serverName, serverLanIP, serverRsaIp, serverOS, serverPurpose, serverOS, rack, bc, FORMAT(slot,""\'@@@@@""),  class, model, serial, rackspace.rackspaceId, reserved FROM servers LEFT JOIN rackspace ON servers.rackspaceId=rackspace.rackspaceId ORDER BY serverName ASC)";
					break;
				case "QA" :
					sql = @"SELECT serverName, serverLanIP, serverRsaIp, serverOS, serverPurpose, rack, bc, Expr1008 AS slot, class, model, serial FROM (SELECT serverName, serverLanIP, serverRsaIp, serverOS, serverPurpose, serverOS, rack, bc, FORMAT(slot,""\'@@@@@""),  class, model, serial, rackspace.rackspaceId, reserved FROM servers LEFT JOIN rackspace ON servers.rackspaceId=rackspace.rackspaceId WHERE serverName LIKE 'S_"+sqlArg+"%' OR serverName LIKE '%PHE"+sqlArg+"%' OR serverName LIKE '%PRP"+sqlArg+"%' ORDER BY serverName ASC)";
					break;
			}
			file = "_"+exportStr + sqlArg + "_" +dateStamp.Hour.ToString() + dateStamp.Minute.ToString() + dateStamp.Second.ToString();
			break;
		case "srch":
			try
			{
				sql=Request.Cookies["srchSql"].Value;
			}
			catch (System.Exception ex)
			{
				sql="";
			}
			file = "_search_" +dateStamp.Hour.ToString() + dateStamp.Minute.ToString() + dateStamp.Second.ToString();
			break;
		case "sqlConsole":
			sql = (string)ViewState["searchArg"];
			file = "_console_" +dateStamp.Hour.ToString() + dateStamp.Minute.ToString() + dateStamp.Second.ToString();
			break;
		}
		if (sql!="")
		{
			DataSet dat = readDb(sql);
			if (dat!=null)
			{
				DataTable dt = dat.Tables[0];
				string filePath = Server.MapPath("./csv_export/export"+file+".csv");
			    CreateCSVFile(dt, filePath);
				Response.ContentType = "text/csv";
				Response.AddHeader( "content-disposition","attachment; filename=export"+file+".csv");            
				Response.WriteFile(filePath);
				Response.End();
			}
		}
	}

/// <summary>
///   The <see cref="createTicket(string, string, string, string, string, string, string, string, string, string)"/> non-static method is used to make a change of commentary or status to an existing action ticket.
/// </summary>
/// <param name="parent">
///   A <see cref="System.String"/> containing the parent action ticket number of this new ticket (optional).
/// </param>
/// <param name="server">
///   A <see cref="System.String"/> containing the servername to be associated with the action ticket.
/// </param>
/// <param name="sfw">
///   A <see cref="System.String"/> containing the software ID# to be associated with the action ticket (optional).
/// </param>
/// <param name="tixDateTime">
///   A <see cref="System.String"/> containing the date and time stamp of the action ticket.
/// </param>
/// <param name="tixClass">
///   A <see cref="System.String"/> containing the class of the action ticket.
/// </param>
/// <param name="enteredBy">
///   A <see cref="System.String"/> containing the username of the author of the action ticket.
/// </param>
/// <param name="title">
///   A <see cref="System.String"/> containing the title to be added to the action ticket.
/// </param>
/// <param name="comments">
///   A <see cref="System.String"/> containing the comment to be added to the action ticket.
/// </param>
/// <param name="priority">
///   A <see cref="System.String"/> containing the priority to be added to the action ticket.
/// </param>
/// <param name="status">
///   A <see cref="System.String"/> containing the status for the action ticket.
/// </param>
/// <seealso cref="writeDb(string)">
///	  The <see cref="writeDb(string)"/> static property is accessed(required) by this method.
/// </seealso>
/// <returns> 
///   A <see cref="System.String"/> containing the status of the ticket creation.
/// </returns>
/// <remarks>
///    A successful execution will return an empty <see cref="System.String"/>.
/// </remarks>
	public string createTicket(string parent, string server, string sfw, string tixDateTime, string tixClass, string enteredBy, string title, string comments, string priority, string status)
	{	
		string sql="", sqlErr="", traceSql="";
		sql="INSERT INTO tickets (parentProject, ticketServer, ticketSfw, ticketDateTime, ticketClass, ticketEnteredBy, ticketTitle, ticketComments, ticketPriority, ticketStatus) VALUES('"+parent+"','"+server+"',"+sfw+",'"+tixDateTime+"','"+tixClass+"','"+enteredBy+"','"+title+"','"+comments+"','"+priority+"',"+status+")";
		sqlErr=writeDb(sql);
		if (sqlErr=="" || sqlErr==null)
		{
			traceSql="INSERT INTO changelog(dateStamp, changedBy, useCase) VALUES("
								+"'" +tixDateTime+   "',"
								+"'" +enteredBy+  "',"
								+"'" +sql2txt(sql)+"')";
			sqlErr=writeDb(traceSql);
		}
		return sqlErr;
	}

/// <summary>
///   The <see cref="changeTicket(string, string, string)"/> non-static method is used to make a change of commentary or status to an existing action ticket.
/// </summary>
/// <param name="ticketNum">
///   A <see cref="System.String"/> containing the action ticket number to be modified.
/// </param>
/// <param name="comment">
///   A <see cref="System.String"/> containing the comment to be added to the action ticket.
/// </param>
/// <param name="status">
///   A <see cref="System.String"/> containing the status for the action ticket.
/// </param>
/// <seealso cref="readDb(string)">
///	  The <see cref="readDb(string)"/> static property is accessed(required) by this method.
/// </seealso>
/// <seealso cref="writeDb(string)">
///	  The <see cref="writeDb(string)"/> static property is accessed(required) by this method.
/// </seealso>
/// <returns> 
///   A <see cref="System.String"/> containing the status of the ticket change.
/// </returns>
/// <remarks>
///    A successful execution will return an empty <see cref="System.String"/>.
/// </remarks>
	public string changeTicket(string ticketNum, string comment, string status)
	{
		string sql="", sqlErr="", traceSql="", changedBy="";
		DataSet dat=new DataSet();
		try
		{
			changedBy=Request.Cookies["username"].Value;
		}
		catch (System.Exception ex)
		{
			changedBy="";
		}
		DateTime tixDateTime = DateTime.Now;

		sql="SELECT * FROM tickets WHERE ticketId="+ticketNum;
		dat=readDb(sql);
		if (dat!=null)
		{
			sql="UPDATE tickets SET ticketComments='"+dat.Tables[0].Rows[0]["ticketComments"].ToString()+" \r\n "+changedBy+":"+comment+" -"+tixDateTime+"', ticketStatus="+status+" WHERE ticketId="+ticketNum;
			sqlErr=writeDb(sql);
			if (sqlErr=="" || sqlErr==null)
			{
				traceSql="INSERT INTO changelog(dateStamp, changedBy, useCase) VALUES("
									+"'" +tixDateTime+   "',"
									+"'" +changedBy+  "',"
									+"'" +sql2txt(sql)+"')";
				sqlErr=writeDb(traceSql);
			}			
		}
		return sqlErr;
	}

/// <summary>
///   The <see cref="connectToAD()"/> non-static method is used to make a secure connection to AD/LDAP.
/// </summary>
/// <returns> 
///   A <see cref="System.DirectoryServices.DirectoryEntry"/> containing the AD/LDAP connection object.
/// </returns>
/// <seealso cref="strServerName">
///	  The <see cref="strServerName"/> static property is accessed(required) by this method.
/// </seealso>
/// <seealso cref="strBaseDN">
///	  The <see cref="strBaseDN"/> static property is accessed(required) by this method.
/// </seealso>
/// <seealso cref="bindDN">
///	  The <see cref="bindDN"/> static property is accessed(required) by this method.
/// </seealso>
/// <seealso cref="bindPWD">
///	  The <see cref="bindPWD"/> static property is accessed(required) by this method.
/// </seealso>
/// <remarks>
///    
/// </remarks>
	public DirectoryEntry connectToAD()
	{
		DirectoryEntry deSystem = new DirectoryEntry(strServerName+strBaseDN,bindDN,bindPWD,AuthenticationTypes.Secure);
		return deSystem;
	}

/// <summary>
///   The <see cref="getADProperty(DirectoryEntry, string)"/> non-static method is used to fetch data for a property from AD/LDAP.
/// </summary>
/// <param name="oDE">
///   A <see cref="System.DirectoryServices.DirectoryEntry"/> containing the DirectoryEntry connetion to be used for the AD/LDAP query.
/// </param>
/// <param name="PropertyName">
///   A <see cref="System.String"/> containing the name of the AD/LDAP property to be queried.
/// </param>
/// <returns> 
///   A <see cref="System.String"/> containing the content of the AD/LDAP Property.
/// </returns>
/// <remarks>
///    
/// </remarks>
	public string getADProperty(DirectoryEntry oDE, string PropertyName)
	{
		if(oDE.Properties.Contains(PropertyName))
		{
			return oDE.Properties[PropertyName][0].ToString() ;
		}
		else
		{
			return string.Empty;
		}
	}

/// <summary>
///   The <see cref="connectToAD(string)"/> non-static method is used to make a secure connection to AD/LDAP.
/// </summary>
/// <param name="customDN">
///   A <see cref="System.String"/> containing the base DN to use for the of the AD/LDAP query.
/// </param>
/// <returns> 
///   A <see cref="System.DirectoryServices.DirectoryEntry"/> containing the AD/LDAP connection object.
/// </returns>
/// <seealso cref="strServerName">
///	  The <see cref="strServerName"/> static property is accessed(required) by this method.
/// </seealso>
/// <seealso cref="bindDN">
///	  The <see cref="bindDN"/> static property is accessed(required) by this method.
/// </seealso>
/// <seealso cref="bindPWD">
///	  The <see cref="bindPWD"/> static property is accessed(required) by this method.
/// </seealso>
/// <remarks>
///    
/// </remarks>
	public DirectoryEntry connectToAD(string customDN)
	{
		DirectoryEntry deSystem = new DirectoryEntry(strServerName+customDN,bindDN,bindPWD,AuthenticationTypes.Secure);
		return deSystem;
	}

/// <summary>
///   The <see cref="doADAuth(string, string)"/> non-static method is used to do secure authentication against AD/LDAP.
/// </summary>
/// <param name="username">
///   A <see cref="System.String"/> encrypted with <see cref="Encrypt(string)"/> containing the username to be used for the AD/LDAP query.
/// </param>
/// <param name="password">
///   A <see cref="System.String"/> encrypted with <see cref="Encrypt(string)"/> containing the password to be used for the AD/LDAP query.
/// </param>
/// <returns> 
///   A <see cref="System.Boolean"/> success(TRUE) / fail(FALSE) status of the authentication.
/// </returns>
/// <seealso cref="strServerName">
///	  The <see cref="strServerName"/> static property is accessed(required) by this method.
/// </seealso>
/// <seealso cref="strBaseDN">
///	  The <see cref="strBaseDN"/> static property is accessed(required) by this method.
/// </seealso>
/// <remarks>
///    
/// </remarks>
	public bool doADAuth(string username, string password)
	{
		bool success=true;
		string fetch="";
		DirectoryEntry deSystem = new DirectoryEntry(strServerName+strBaseDN,Decrypt(username),Decrypt(password),AuthenticationTypes.Secure);
		try
		{
			fetch=getADProperty(deSystem,"SAMAccountName");
		}
		catch (System.Exception ex)
		{
			fetch="failed";
			success=false;
		}
		Response.Write(fetch);
		return success;
	}

/// <summary>
///   The <see cref="getADUser(string)"/> non-static method is used to search for a specific username against AD/LDAP.
/// </summary>
/// <param name="username">
///   A <see cref="System.String"/> containing the username to be sought by the AD/LDAP query.
/// </param>
/// <returns> 
///   A <see cref="System.DirectoryServices.SearchResult"/> containing the matching result(s) of the AD/LDAP search.
/// </returns>
/// <seealso cref="connectToAD()">
///	  The <see cref="connectToAD()"/> non-static method is accessed(required) by this method.
/// </seealso>
/// <remarks>
///    
/// </remarks>
	public SearchResult getADUser(string username)
	{
		DirectoryEntry de = connectToAD();
		DirectorySearcher deSearch = new DirectorySearcher(de);
	    deSearch.Filter = "(SAMAccountName=" + username + ")";
		deSearch.SearchScope = SearchScope.Subtree;
		SearchResult results = null;
		try
		{
			results = deSearch.FindOne();
		}
		catch (System.Exception ex)
		{
			System.Exception connectEx = new System.InvalidOperationException("No AD search results found for user '"+username+"' !",ex);
			throw connectEx;
		}
		return results;
	}

/// <summary>
///   The <see cref="getADUserProperty(string,string)"/> non-static method is used to search for a specific property associated with a username against AD/LDAP.
/// </summary>
/// <param name="username">
///   A <see cref="System.String"/> containing the username to be searched for by the AD/LDAP query.
/// </param>
/// <param name="property">
///   A <see cref="System.String"/> containing the name of the property of the specified username to be searched for by the AD/LDAP query.
/// </param>
/// <returns> 
///   A <see cref="System.DirectoryServices.SearchResult"/> containing the matching result(s) of the AD/LDAP search.
/// </returns>
/// <exception cref="System.Exception"> 
///   Thrown when the AD/LDAP search encounters an error.
/// </exception>
/// <seealso cref="connectToAD()">
///	  The <see cref="connectToAD()"/> non-static method is accessed(required) by this method.
/// </seealso>
/// <remarks>
///    
/// </remarks>
	public string getADUserProperty(string username, string property)
	{
		string returnVal="";
		DirectoryEntry de = connectToAD();
	    DirectorySearcher deSearch = new DirectorySearcher(de);
		deSearch.Filter = "(SAMAccountName=" + username + ")";
		deSearch.PropertiesToLoad.Add(property);
		SearchResultCollection results = null;
		try
		{
			results = deSearch.FindAll();
		}
		catch (System.Exception ex)
		{
			System.Exception connectEx = new System.InvalidOperationException("No AD search results found for '"+ username+":"+property+"'!",ex);
			throw connectEx;
		}
		if (results != null && results.Count > 0)
		{
			try
			{
				returnVal=results[0].Properties[property][0].ToString();
			}
			catch (Exception ex) 
			{    
				Type exType = ex.GetType();    
				if (exType == typeof(System.ArgumentOutOfRangeException) ||         
					exType == typeof(System.OverflowException))
				{        
					System.Exception connectEx = new System.InvalidOperationException("Value for Property '"+property+"' not found!",ex);
					throw connectEx;  
				} 
				if (exType ==typeof(System.DirectoryServices.DirectoryServicesCOMException))
				{
					System.Exception connectEx = new System.InvalidOperationException("The AD service user does not have permission for that!",ex);
					throw connectEx;  
				}
				else 
				{       
					throw;    
				} 
			} 
			return returnVal;
		}
		else
		{
			return "Unknown User";
		}
	}

/// <summary>
///   The <see cref="getADUserGroups(string)"/> non-static method is used to fetch the groups for a given username against AD/LDAP.
/// </summary>
/// <param name="username">
///   A <see cref="System.String"/> containing the username to be sought by the AD/LDAP query.
/// </param>
/// <returns> 
///   A <see cref="System.Collections.Specialized.StringCollection"/> containing the matching result(s) of the AD/LDAP search.
/// </returns>
/// <exception cref="System.Exception"> 
///   Thrown when the AD/LDAP search encounters an error.
/// </exception>
/// <seealso cref="connectToAD()">
///	  The <see cref="connectToAD()"/> non-static method is accessed(required) by this method.
/// </seealso>
/// <remarks>
///    
/// </remarks>
	public StringCollection getADUserGroups(string username)
	{
		StringCollection groups = new StringCollection();
		int index=0;

	    DirectoryEntry de = connectToAD();
		DirectorySearcher deSearch = new DirectorySearcher(de);
	    deSearch.Filter = "(SAMAccountName=" + username + ")";
		SearchResult results = null;
		try
		{
			results = deSearch.FindOne();
		}
		catch (Exception ex) 
		{    
			Type exType = ex.GetType();    
			if (exType == typeof(System.FormatException) ||         
				exType == typeof(System.OverflowException))
			{        
				System.Exception connectEx = new System.InvalidOperationException("No AD user '"+ username+"' found!",ex);
				throw connectEx;  
			} 
			if (exType ==typeof(System.DirectoryServices.DirectoryServicesCOMException))
			{
				System.Exception connectEx = new System.InvalidOperationException("The AD service user does not have permission for that!",ex);
				throw connectEx;  
			}
			else 
			{       
				throw;    
			} 
		} 
		if (results != null)
		{
			DirectoryEntry obUser = new DirectoryEntry(results.Path,bindDN,bindPWD,AuthenticationTypes.Secure);
			object obGroups = obUser.Invoke("Groups");
			foreach (object ob in (IEnumerable)obGroups)
			{
				DirectoryEntry obGpEntry = new DirectoryEntry(ob);
				groups.Add(obGpEntry.Name);
				index++;
			}
		}
		return groups;
	}

/// <summary>
///   The <see cref="isADUserGroupMember(string, string)"/> non-static method is used to check that a given username is a member of a given group against AD/LDAP.
/// </summary>
/// <param name="username">
///   A <see cref="System.String"/> containing the username to be sought by the AD/LDAP query.
/// </param>
/// <param name="group">
///   A <see cref="System.String"/> containing the group to be sought by the AD/LDAP query.
/// </param>
/// <returns> 
///   A <see cref="System.Boolean"/> success(TRUE) / fail(FALSE) status of the membership.
/// </returns>
/// <exception cref="System.Exception"> 
///   Thrown when the AD/LDAP search encounters an error.
/// </exception>
/// <seealso cref="getADUserGroups(string)">
///	  The <see cref="getADUserGroups(string)"/> non-static method is accessed(required) by this method.
/// </seealso>
/// <remarks>
///    
/// </remarks>
	public bool isADUserGroupMember(string username, string group)
	{
		bool inGroup=false;
		try
		{
			inGroup=getADUserGroups(username).Contains("CN="+group);
		}
		catch (System.Exception ex)
		{
			System.Exception connectEx = new System.InvalidOperationException("No AD group '"+group+"' found!",ex);
			throw connectEx;
		}
		return inGroup;
	}

/// <summary>
///   The <see cref="getAllADUserProperty(string)"/> non-static method is used to fetch all properties for a given username against AD/LDAP.
/// </summary>
/// <param name="username">
///   A <see cref="System.String"/> containing the username to be sought by the AD/LDAP query.
/// </param>
/// <returns> 
///   A <see cref="System.Data.DataSet"/> containing all of the property names and values for the given username.
/// </returns>
/// <exception cref="System.Exception"> 
///   Thrown when the AD/LDAP search encounters an error.
/// </exception>
/// <seealso cref="connectToAD(string)">
///	  The <see cref="connectToAD(string)"/> non-static method is accessed(required) by this method.
/// </seealso>
/// <seealso cref="getADUserProperty(string)">
///	  The <see cref="getADUserProperty(string)"/> non-static method is accessed(required) by this method.
/// </seealso>
/// <remarks>
///    
/// </remarks>
	public DataSet getAllADUserProperty(string username)
	{
		DataSet result= new DataSet();
		DirectoryEntry de = new DirectoryEntry();

		try
		{
			de = connectToAD(getADUserProperty(username,"distinguishedName"));
		}
		catch (System.Exception ex)
		{
			System.Exception connectEx = new System.InvalidOperationException("No AD search results found for '"+ username+":distinguishedName'!",ex);
			throw connectEx;
		}
		if (de!=null)
		{
			DataTable resultTable = result.Tables.Add(de.Path.ToString());
			resultTable.Columns.Add("Property");
			resultTable.Columns.Add("Value");

			System.DirectoryServices.PropertyCollection pc = de.Properties;
			foreach(string propName in pc.PropertyNames)
			{
				foreach(object value in de.Properties[propName])
				{
					DataRow ldapProp = resultTable.NewRow();
					ldapProp["Property"]=propName.ToString();
					ldapProp["Value"]=value.ToString();
					resultTable.Rows.Add(ldapProp);
				}
			}
			result.Tables.Add(resultTable);
		}
		return result;
	}

/// <summary>
///   The <see cref="getADUsersinGroup(string)"/> non-static method is used to fetch all users(members) for a given group against AD/LDAP.
/// </summary>
/// <param name="group">
///   A <see cref="System.String"/> containing the group to be sought by the AD/LDAP query.
/// </param>
/// <returns> 
///   A <see cref="System.Data.DataSet"/> containing all of the usernames names and values for the given group.
/// </returns>
/// <exception cref="System.Exception"> 
///   Thrown when the AD/LDAP search encounters an error.
/// </exception>
/// <seealso cref="strServerName">
///	  The <see cref="strServerName"/> static property is accessed(required) by this method.
/// </seealso>
/// <seealso cref="bindDN">
///	  The <see cref="bindDN"/> static property is accessed(required) by this method.
/// </seealso>
/// <seealso cref="bindPWD">
///	  The <see cref="bindPWD"/> static property is accessed(required) by this method.
/// </seealso>
/// <seealso cref="connectToAD(string)">
///	  The <see cref="connectToAD(string)"/> non-static method is accessed(required) by this method.
/// </seealso>
/// <seealso cref="getADProperty(string,string)">
///	  The <see cref="getADProperty(string,string)"/> non-static method is accessed(required) by this method.
/// </seealso>
/// <remarks>
///    
/// </remarks>
	public DataSet getADUsersinGroup(string group)
	{
		string result="";
		DataSet dsUser = new DataSet();
		DirectoryEntry de = connectToAD();
		DirectorySearcher deSearch = new DirectorySearcher();

		deSearch.SearchRoot =de;
		deSearch.Filter = "(&(objectClass=group)(cn="+group+"))";

		SearchResult results= deSearch.FindOne();
		DataTable tbUser = dsUser.Tables.Add("Users");
		tbUser.Columns.Add("UserName");
		tbUser.Columns.Add("First");
		tbUser.Columns.Add("Last");
		tbUser.Columns.Add("EMailAddress");
		tbUser.Columns.Add("Phone");

		if(results !=null)
		{

			DirectoryEntry deGroup= new DirectoryEntry(results.Path,bindDN,bindPWD,AuthenticationTypes.Secure);
			System.DirectoryServices.PropertyCollection pcoll = deGroup.Properties;
			int n = pcoll["member"].Count;

			for (int l = 0; l < n ; l++)
			{
				DirectoryEntry deUser= new DirectoryEntry(strServerName+pcoll["member"][l].ToString(),bindDN,bindPWD,AuthenticationTypes.Secure);
				DataRow rwUser = tbUser.NewRow();
				rwUser["UserName"]=getADProperty(deUser,"cn");
				rwUser["First"]=getADProperty(deUser,"givenName");
				rwUser["Last"]=getADProperty(deUser,"sn");
				rwUser["EMailAddress"]=getADProperty(deUser,"mail");
				rwUser["Phone"]=getADProperty(deUser,"telephoneNumber");
				tbUser.Rows.Add(rwUser);
				deUser.Close();
			}
			de.Close();
			deGroup.Close();
		}
		return dsUser;
	}

/// <summary>
///   The <see cref="doAd()"/> non-static void method is used to execute to common code necessary to present an advertisement(random image) in the CIS application pages.
/// </summary>
/// <returns> 
///   A <see cref="System.String"/> containing the interactive HTML code for the context functionality.
/// </returns>
/// <remarks>
///    This method is at this time unused.
/// </remarks>
	public string doAd()
	{
		string adSql, adString;
		DataSet ad;
		adString="";
		Random random = new Random();
		int rnd = random.Next(93);
		adSql = "SELECT * FROM bannerAds WHERE adId=" + rnd.ToString();
		ad = readDb(adSql);
		if (ad!=null)
		{
			foreach (DataTable dt in ad.Tables)
			{
				foreach (DataRow dr in dt.Rows)
				{
					adString="<a href="  +dr["adLink"].ToString() +" target=_blank>										 <img src="	+dr["adImg"].ToString()  +" width=468 height=60 alt="										+dr["adAlt"].ToString()  +" border=0/></a>";
				} // for DataRows
			} // for DataTable
		} // if(dat)
		return (adString);
	}

/// <summary>
///   The <see cref="buildCisco6509(string, string, string)"/> non-static void method is used to build a new Cisco 6509 switch for the switch port inventory functionality of CIS.
/// </summary>
/// <param name="name">
///   A <see cref="System.String"/> containing the name to associate with the newly created switch.
/// </param>
/// <param name="rackspaceId">
///   A <see cref="System.String"/> containing the hardware rackspace identifier to associate with the newly created switch.
/// </param>
/// <param name="dc">
///   A <see cref="System.String"/> containing the datacenter identifier to associate with the newly created switch.
/// </param>
/// <returns> 
///   A <see cref="System.String"/> containing the result status of the switch creation action.
/// </returns>
/// <seealso cref="writeDb(string)">
///	  The <see cref="writeDb(string)"/> static property is accessed(required) by this method.
/// </seealso>
/// <remarks>
///    If the method is successful a blank string will be returned.
/// </remarks>
	public string buildCisco6509(string name, string rackspaceId, string dc)
	{
		int curBlade=1, curPort=1;
		int bladeMax=9, portMax=0;
		string sql="", sqlErr="", errMsg="", db_swName="";
		bool sqlSuccess; 
		db_swName=fix_access(removeSpaces(name)).ToLower();
		sql="CREATE TABLE "+dc+db_swName+" ([portId] COUNTER PRIMARY KEY, [switchId] Text(50), [slot] Text(50), [portNum] Text(50), [reserved] Text(50), [cabledTo] Integer, [comment] Text(255), [mode] Text(50))";
		sqlErr=writeDb(sql);
		if (sqlErr!=null && sqlErr!="")
		{
			sqlSuccess=false;
			errMsg= "SQL Update Error - Switch Table Creation<BR/>"+sqlErr;
		}
		else
		{
			sqlErr="";
			sql="INSERT INTO switches (switchName,description,rackspaceId,media) VALUES ('"+dc+db_swName+"','"+name.ToUpper()+"','"+rackspaceId+"','Ethernet')";
			sqlErr=writeDb(sql);
			if (sqlErr=="")
			{
				while (curBlade <=bladeMax && errMsg=="")
				{
					switch (curBlade)
					{
					case 1:
						portMax=2;
						curPort=1;
						while (curPort<=portMax)
						{
							sql="INSERT INTO "+dc+db_swName+" (switchId, slot, portNum, reserved, mode) values('"+db_swName+"', '"+curBlade+"', '"+curPort+"', '0','jack')";
							sqlErr=writeDb(sql);
							if (sqlErr!=null && sqlErr!="")
							{
								sqlSuccess=false;
								errMsg="SQL Update Error - Switch Blade/Port Creation - Blade "+curBlade+", Port "+curPort+"<BR/>"+sqlErr;
							}
							else 
							{
								errMsg="";
							}
							curPort++;
						}
						break;
					case 2:
						portMax=48;
						curPort=1;
						while (curPort<=portMax)
						{
							sql="INSERT INTO "+dc+db_swName+" (switchId, slot, portNum, reserved, mode) values('"+db_swName+"', '"+curBlade+"', '"+curPort+"', '0','jack')";
							sqlErr=writeDb(sql);
							if (sqlErr!=null && sqlErr!="")
							{
								sqlSuccess=false;
								errMsg="SQL Update Error - Switch Blade/Port Creation - Blade "+curBlade+", Port "+curPort+"<BR/>"+sqlErr;
							}
							else 
							{
								errMsg="";
							}
							curPort++;
						}
						break;
					case 3:
						portMax=48;
						curPort=1;
						while (curPort<=portMax)
						{
							sql="INSERT INTO "+dc+db_swName+" (switchId, slot, portNum, reserved, mode) values('"+db_swName+"', '"+curBlade+"', '"+curPort+"', '0','jack')";
							sqlErr=writeDb(sql);
							if (sqlErr!=null && sqlErr!="")
							{
								sqlSuccess=false;
								errMsg="SQL Update Error - Switch Blade/Port Creation - Blade "+curBlade+", Port "+curPort+"<BR/>"+sqlErr;
							}
							else 
							{
								errMsg="";
							}
							curPort++;
						}
						break;
					case 4:
						portMax=48;
						curPort=1;
						while (curPort<=portMax)
						{
							sql="INSERT INTO "+dc+db_swName+" (switchId, slot, portNum, reserved, mode) values('"+db_swName+"', '"+curBlade+"', '"+curPort+"', '0','jack')";
							sqlErr=writeDb(sql);
							if (sqlErr!=null && sqlErr!="")
							{
								sqlSuccess=false;
								errMsg="SQL Update Error - Switch Blade/Port Creation - Blade "+curBlade+", Port "+curPort+"<BR/>"+sqlErr;
							}
							else 
							{
								errMsg="";
							}
							curPort++;
						}
						break;
					case 5:
						portMax=0;
						curPort=1;
						while (curPort<=portMax)
						{
							sql="INSERT INTO "+dc+db_swName+" (switchId, slot, portNum, reserved, mode) values('"+db_swName+"', '"+curBlade+"', '"+curPort+"', '0','jack')";
							sqlErr=writeDb(sql);
							if (sqlErr!=null && sqlErr!="")
							{
								sqlSuccess=false;
								errMsg="SQL Update Error - Switch Blade/Port Creation - Blade "+curBlade+", Port "+curPort+"<BR/>"+sqlErr;
							}
							else 
							{
								errMsg="";
							}
							curPort++;
						}
						break;
					case 6:
						portMax=0;
						curPort=1;
						while (curPort<=portMax)
						{	
							sql="INSERT INTO "+dc+db_swName+" (switchId, slot, portNum, reserved, mode) values('"+db_swName+"', '"+curBlade+"', '"+curPort+"', '0','jack')";
							sqlErr=writeDb(sql);
							if (sqlErr!=null && sqlErr!="")
							{
								sqlSuccess=false;
								errMsg="SQL Update Error - Switch Blade/Port Creation - Blade "+curBlade+", Port "+curPort+"<BR/>"+sqlErr;
							}
							else 
							{
								errMsg="";
							}
							curPort++;
						}
						break;
					case 7:
						portMax=48;
						curPort=1;
						while (curPort<=portMax)
						{
							sql="INSERT INTO "+dc+db_swName+" (switchId, slot, portNum, reserved, mode) values('"+db_swName+"', '"+curBlade+"', '"+curPort+"', '0','jack')";
							sqlErr=writeDb(sql);
							if (sqlErr!=null && sqlErr!="")
							{
								sqlSuccess=false;
								errMsg="SQL Update Error - Switch Blade/Port Creation - Blade "+curBlade+", Port "+curPort+"<BR/>"+sqlErr;
							}
							else 
							{
								errMsg="";
							}
							curPort++;
						}
						break;
					case 8:
						portMax=48;
						curPort=1;
						while (curPort<=portMax)
						{
							sql="INSERT INTO "+dc+db_swName+" (switchId, slot, portNum, reserved, mode) values('"+db_swName+"', '"+curBlade+"', '"+curPort+"', '0','jack')";
							sqlErr=writeDb(sql);
							if (sqlErr!=null && sqlErr!="")
							{
								sqlSuccess=false;
								errMsg="SQL Update Error - Switch Blade/Port Creation - Blade "+curBlade+", Port "+curPort+"<BR/>"+sqlErr;
							}
							else 
							{
								errMsg="";
							}
							curPort++;
						}
						break;
					case 9:
						portMax=48;
						curPort=1;
						while (curPort<=portMax)
						{
							sql="INSERT INTO "+dc+db_swName+" (switchId, slot, portNum, reserved, mode) values('"+db_swName+"', '"+curBlade+"', '"+curPort+"', '0','jack')";
							sqlErr=writeDb(sql);
							if (sqlErr!=null && sqlErr!="")
							{
								sqlSuccess=false;
								errMsg="SQL Update Error - Switch Blade/Port Creation - Blade "+curBlade+", Port "+curPort+"<BR/>"+sqlErr;
							}
							else 
							{
								errMsg="";
							}
							curPort++;
						}
						break;
					}
					curBlade++;
				}
			}
		}
		return errMsg;
	}

/// <summary>
///   The <see cref="buildDS9509(string, string, string)"/> non-static void method is used to build a new Cisco 9509 switch for the switch port inventory functionality of CIS.
/// </summary>
/// <param name="name">
///   A <see cref="System.String"/> containing the name to associate with the newly created switch.
/// </param>
/// <param name="rackspaceId">
///   A <see cref="System.String"/> containing the hardware rackspace identifier to associate with the newly created switch.
/// </param>
/// <param name="dc">
///   A <see cref="System.String"/> containing the datacenter identifier to associate with the newly created switch.
/// </param>
/// <returns> 
///   A <see cref="System.String"/> containing the result status of the switch creation action.
/// </returns>
/// <seealso cref="writeDb(string)">
///	  The <see cref="writeDb(string)"/> static property is accessed(required) by this method.
/// </seealso>
/// <remarks>
///    If the method is successful a blank string will be returned.
/// </remarks>
	public string buildDS9509(string name,string rackspaceId, string dc)
	{
		int curBlade=1, curPort=1;
		int bladeMax=9, portMax=0;
		string sql="", sqlErr="", errMsg="", db_swName="";
		bool sqlSuccess;
		db_swName=fix_access(removeSpaces(name)).ToLower();
		sql="CREATE TABLE "+dc+db_swName+" ([portId] COUNTER PRIMARY KEY, [switchId] Text(50), [slot] Text(50), [portNum] Text(50), [reserved] Text(50), [cabledTo] Integer, [comment] Text(255), [mode] Text(50))";
		sqlErr=writeDb(sql);
		if (sqlErr!=null && sqlErr!="")
		{
			sqlSuccess=false;
			errMsg= "SQL Update Error - Switch Table Creation<BR/>"+sqlErr;
		}
		else
		{
			sqlErr="";
			sql="INSERT INTO switches (switchName,description,rackspaceId,media) VALUES ('"+dc+db_swName+"','"+name.ToUpper()+"','"+rackspaceId+"','Fibre Channel')";
			sqlErr=writeDb(sql);
			if (sqlErr=="")
			{
				while (curBlade <=bladeMax && errMsg=="")
				{
					switch (curBlade)
					{
					case 1:
						portMax=32;
						curPort=1;
						while (curPort<=portMax)
						{
							sql="INSERT INTO "+dc+db_swName+" (switchId, slot, portNum, reserved, mode) values('"+db_swName+"', '"+curBlade+"', '"+curPort+"', '0','gbic')";
							sqlErr=writeDb(sql);
							if (sqlErr!=null && sqlErr!="")
							{
								sqlSuccess=false;
								errMsg="SQL Update Error - Switch Blade/Port Creation - Blade "+curBlade+", Port "+curPort+"<BR/>"+sqlErr;
							}
							else 
							{
								errMsg="";
							}
							curPort++;
						}
						break;
					case 2:
						portMax=32;
						curPort=1;
						while (curPort<=portMax)
						{
							sql="INSERT INTO "+dc+db_swName+" (switchId, slot, portNum, reserved, mode) values('"+db_swName+"', '"+curBlade+"', '"+curPort+"', '0','gbic')";
							sqlErr=writeDb(sql);
							if (sqlErr!=null && sqlErr!="")
							{
								sqlSuccess=false;
								errMsg="SQL Update Error - Switch Blade/Port Creation - Blade "+curBlade+", Port "+curPort+"<BR/>"+sqlErr;
							}
							else 
							{
								errMsg="";
							}
							curPort++;
						}
						break;
					case 3:
						portMax=32;
						curPort=1;
						while (curPort<=portMax)
						{
							sql="INSERT INTO "+dc+db_swName+" (switchId, slot, portNum, reserved, mode) values('"+db_swName+"', '"+curBlade+"', '"+curPort+"', '0','gbic')";
							sqlErr=writeDb(sql);
							if (sqlErr!=null && sqlErr!="")
							{
								sqlSuccess=false;
								errMsg="SQL Update Error - Switch Blade/Port Creation - Blade "+curBlade+", Port "+curPort+"<BR/>"+sqlErr;
							}
							else 
							{
								errMsg="";
							}
							curPort++;
						}
						break;
					case 4:
						portMax=32;
						curPort=1;
						while (curPort<=portMax)
						{
							sql="INSERT INTO "+dc+db_swName+" (switchId, slot, portNum, reserved, mode) values('"+db_swName+"', '"+curBlade+"', '"+curPort+"', '0','gbic')";
							sqlErr=writeDb(sql);
							if (sqlErr!=null && sqlErr!="")
							{
								sqlSuccess=false;
								errMsg="SQL Update Error - Switch Blade/Port Creation - Blade "+curBlade+", Port "+curPort+"<BR/>"+sqlErr;
							}
							else 
							{
								errMsg="";
							}
							curPort++;
						}
						break;
					case 5:
						sql="INSERT INTO "+dc+db_swName+" (switchId, slot, portNum, reserved, mode) values('"+db_swName+"', '"+curBlade+"', 'Mgmt', '0', 'jack')";
						sqlErr=writeDb(sql);
						if (sqlErr!=null && sqlErr!="")
						{
							sqlSuccess=false;
							errMsg="SQL Update Error - Switch Blade/Port Creation - Blade "+curBlade+", Mgmt Port <BR/>"+sqlErr;
						}
						else 
						{
							errMsg="";
						}
						sql="INSERT INTO "+dc+db_swName+" (switchId, slot, portNum, reserved, mode) values('"+db_swName+"', '"+curBlade+"', 'Console', '0', 'jack')";
						sqlErr=writeDb(sql);
						if (sqlErr!=null && sqlErr!="")
						{
							sqlSuccess=false;
							errMsg="SQL Update Error - Switch Blade/Port Creation - Blade "+curBlade+", Console Port <BR/>"+sqlErr;
						}
						else 
						{
							errMsg="";
						}
						break;
					case 6:
						sql="INSERT INTO "+dc+db_swName+" (switchId, slot, portNum, reserved, mode) values('"+db_swName+"', '"+curBlade+"', 'Mgmt', '0', 'jack')";
						sqlErr=writeDb(sql);
						if (sqlErr!=null && sqlErr!="")
						{
							sqlSuccess=false;
							errMsg="SQL Update Error - Switch Blade/Port Creation - Blade "+curBlade+", Mgmt Port <BR/>"+sqlErr;
						}
						else 
						{
							errMsg="";
						}
						sql="INSERT INTO "+dc+db_swName+" (switchId, slot, portNum, reserved, mode) values('"+db_swName+"', '"+curBlade+"', 'Console', '0', 'jack')";
						sqlErr=writeDb(sql);
						if (sqlErr!=null && sqlErr!="")
						{
							sqlSuccess=false;
							errMsg="SQL Update Error - Switch Blade/Port Creation - Blade "+curBlade+", Console Port <BR/>"+sqlErr;
						}
						else 
						{
							errMsg="";
						}
						break;
					case 7:
						portMax=32;
						curPort=1;
						while (curPort<=portMax)
						{
							sql="INSERT INTO "+dc+db_swName+" (switchId, slot, portNum, reserved, mode) values('"+db_swName+"', '"+curBlade+"', '"+curPort+"', '0','gbic')";
							sqlErr=writeDb(sql);
							if (sqlErr!=null && sqlErr!="")
							{
								sqlSuccess=false;
								errMsg="SQL Update Error - Switch Blade/Port Creation - Blade "+curBlade+", Port "+curPort+"<BR/>"+sqlErr;
							}
							else 
							{
								errMsg="";
							}
							curPort++;
						}
						break;
					case 8:
						portMax=32;
						curPort=1;
						while (curPort<=portMax)
						{
							sql="INSERT INTO "+dc+db_swName+" (switchId, slot, portNum, reserved, mode) values('"+db_swName+"', '"+curBlade+"', '"+curPort+"', '0','gbic')";
							sqlErr=writeDb(sql);
							if (sqlErr!=null && sqlErr!="")
							{
								sqlSuccess=false;
								errMsg="SQL Update Error - Switch Blade/Port Creation - Blade "+curBlade+", Port "+curPort+"<BR/>"+sqlErr;
							}
							else 
							{
								errMsg="";
							}
							curPort++;
						}
						break;
					case 9:
						portMax=32;
						curPort=1;
						while (curPort<=portMax)
						{
							sql="INSERT INTO "+dc+db_swName+" (switchId, slot, portNum, reserved, mode) values('"+db_swName+"', '"+curBlade+"', '"+curPort+"', '0','gbic')";
							sqlErr=writeDb(sql);
							if (sqlErr!=null && sqlErr!="")
							{
								sqlSuccess=false;
								errMsg="SQL Update Error - Switch Blade/Port Creation - Blade "+curBlade+", Port "+curPort+"<BR/>"+sqlErr;
							}
							else 
							{
								errMsg="";
							}
							curPort++;
						}
						break;
					}
					curBlade++;
				}
			}
		}
		return errMsg;
	}

/// <summary>
///   The <see cref="buildCatalyst3750G(string, string, string)"/> non-static void method is used to build a new Cisco Catalyst 3750G router for the switch port inventory functionality of CIS.
/// </summary>
/// <param name="name">
///   A <see cref="System.String"/> containing the name to associate with the newly created router.
/// </param>
/// <param name="rackspaceId">
///   A <see cref="System.String"/> containing the hardware rackspace identifier to associate with the newly created router.
/// </param>
/// <param name="dc">
///   A <see cref="System.String"/> containing the datacenter identifier to associate with the newly created router.
/// </param>
/// <returns> 
///   A <see cref="System.String"/> containing the result status of the router creation action.
/// </returns>
/// <seealso cref="writeDb(string)">
///	  The <see cref="writeDb(string)"/> static property is accessed(required) by this method.
/// </seealso>
/// <remarks>
///    If the method is successful a blank string will be returned.
/// </remarks>
	public string buildCatalyst3750G(string name,string rackspaceId, string dc)
	{
		int curBlade=1, curPort=1;
		int bladeMax=1, portMax=0;
		string sql="", sqlErr="", errMsg="", db_swName="";
		bool sqlSuccess;
		db_swName=fix_access(removeSpaces(name)).ToLower();
		sql="CREATE TABLE "+dc+db_swName+" ([portId] COUNTER PRIMARY KEY, [switchId] Text(50), [slot] Text(50), [portNum] Text(50), [reserved] Text(50), [cabledTo] Integer, [comment] Text(255), [mode] Text(50))";
		sqlErr=writeDb(sql);
		if (sqlErr!=null && sqlErr!="")
		{
			sqlSuccess=false;
			errMsg= "SQL Update Error - Switch Table Creation<BR/>"+sqlErr;
		}
		else
		{
			sqlErr="";
			sql="INSERT INTO switches (switchName,description,rackspaceId,media) VALUES ('"+dc+db_swName+"','"+name.ToUpper()+"','"+rackspaceId+"','Ethernet')";
			sqlErr=writeDb(sql);
			if (sqlErr=="")
			{
				while (curBlade <=bladeMax && errMsg=="")
				{
					switch (curBlade)
					{
					case 1:
						portMax=24;
						curPort=1;
						while (curPort<=portMax)
						{
							sql="INSERT INTO "+dc+db_swName+" (switchId, slot, portNum, reserved, mode) values('"+db_swName+"', '"+curBlade+"', '"+curPort+"', '0','jack')";
							sqlErr=writeDb(sql);
							if (sqlErr!=null && sqlErr!="")
							{
								sqlSuccess=false;
								errMsg="SQL Update Error - Switch Blade/Port Creation - Blade "+curBlade+", Port "+curPort+"<BR/>"+sqlErr;
							}
							else 
							{
								errMsg="";
							}
							curPort++;
						}
						portMax=2;
						curPort=1;
						while (curPort<=portMax)
						{
							sql="INSERT INTO "+dc+db_swName+" (switchId, slot, portNum, reserved, mode) values('"+db_swName+"', 'SFP', '"+curPort+"', '0','gbic')";
							sqlErr=writeDb(sql);
							if (sqlErr!=null && sqlErr!="")
							{
								sqlSuccess=false;
								errMsg="SQL Update Error - Switch Blade/Port Creation - SFP Section, Port "+curPort+"<BR/>"+sqlErr;
							}
							else 
							{
								errMsg="";
							}
							curPort++;
						}
						break;
					}
					curBlade++;
				}
			}
		}
		return errMsg;
	}

/// <summary>
///   The <see cref="buildNexus5020(string, string, string)"/> non-static void method is used to build a new Cisco Nexus 5020 switch for the switch port inventory functionality of CIS.
/// </summary>
/// <param name="name">
///   A <see cref="System.String"/> containing the name to associate with the newly created switch.
/// </param>
/// <param name="rackspaceId">
///   A <see cref="System.String"/> containing the hardware rackspace identifier to associate with the newly created switch.
/// </param>
/// <param name="dc">
///   A <see cref="System.String"/> containing the datacenter identifier to associate with the newly created switch.
/// </param>
/// <returns> 
///   A <see cref="System.String"/> containing the result status of the switch creation action.
/// </returns>
/// <seealso cref="writeDb(string)">
///	  The <see cref="writeDb(string)"/> static property is accessed(required) by this method.
/// </seealso>
/// <remarks>
///    If the method is successful a blank string will be returned.
/// </remarks>
	public string buildNexus5020(string name,string rackspaceId, string dc)
	{
		int curBlade=1, curPort=1;
		int bladeMax=2, portMax=0;
		string sql="", sqlErr="", errMsg="", db_swName="";
		bool sqlSuccess;
		db_swName=fix_access(removeSpaces(name)).ToLower();
		sql="CREATE TABLE "+dc+db_swName+" ([portId] COUNTER PRIMARY KEY, [switchId] Text(50), [slot] Text(50), [portNum] Text(50), [reserved] Text(50), [cabledTo] Integer, [comment] Text(255), [mode] Text(50))";
		sqlErr=writeDb(sql);
		if (sqlErr!=null && sqlErr!="")
		{
			sqlSuccess=false;
			errMsg= "SQL Update Error - Switch Table Creation<BR/>"+sqlErr;
		}
		else
		{
			sqlErr="";
			sql="INSERT INTO switches (switchName,description,rackspaceId,media) VALUES ('"+dc+db_swName+"','"+name.ToUpper()+"','"+rackspaceId+"','FCoE')";
			sqlErr=writeDb(sql);
			if (sqlErr=="")
			{
				while (curBlade <=bladeMax && errMsg=="")
				{
					switch (curBlade)
					{
					case 1:
						portMax=20;
						curPort=1;
						while (curPort<=portMax)
						{
							sql="INSERT INTO "+dc+db_swName+" (switchId, slot, portNum, reserved, mode) values('"+db_swName+"', '"+curBlade+"', '"+curPort+"', '0','gbic')";
							sqlErr=writeDb(sql);
							if (sqlErr!=null && sqlErr!="")
							{
								sqlSuccess=false;
								errMsg="SQL Update Error - Switch Blade/Port Creation - Base 10G Section"+curBlade+", Port "+curPort+"<BR/>"+sqlErr;
							}
							else 
							{
								errMsg="";
							}
							curPort++;
						}
						portMax=6;
						curPort=1;
						while (curPort<=portMax)
						{
							sql="INSERT INTO "+dc+db_swName+" (switchId, slot, portNum, reserved, mode) values('"+db_swName+"', '"+curBlade+"-Exp', '"+curPort+"', '0','gbic')";
							sqlErr=writeDb(sql);
							if (sqlErr!=null && sqlErr!="")
							{
								sqlSuccess=false;
								errMsg="SQL Update Error - Switch Blade/Port Creation - 10G Expansion Section "+curBlade+", Port "+curPort+"<BR/>"+sqlErr;
							}
							else 
							{
								errMsg="";
							}
							curPort++;
						}
						break;
					case 2:
						portMax=4;
						curPort=1;
						while (curPort<=portMax)
						{
							sql="INSERT INTO "+dc+db_swName+" (switchId, slot, portNum, reserved, mode) values('"+db_swName+"', '"+curBlade+"-Mgt', '"+curPort+"', '0','jack')";
							sqlErr=writeDb(sql);
							if (sqlErr!=null && sqlErr!="")
							{
								sqlSuccess=false;
								errMsg="SQL Update Error - Switch Blade/Port Creation - OOBE Mgt Section, Port "+curPort+"<BR/>"+sqlErr;
							}
							else 
							{
								errMsg="";
							}
							curPort++;
						}
						sql="INSERT INTO "+dc+db_swName+" (switchId, slot, portNum, reserved, mode) values('"+db_swName+"', '"+curBlade+"-Con', '1', '0','jack')";
						sqlErr=writeDb(sql);
						if (sqlErr!=null && sqlErr!="")
						{
							sqlSuccess=false;
							errMsg="SQL Update Error - Switch Blade/Port Creation - Group "+curBlade+", Console Port<BR/>"+sqlErr;
						}
						else 
						{
							errMsg="";
						}
						portMax=20;
						curPort=1;
						while (curPort<=portMax)
						{
							sql="INSERT INTO "+dc+db_swName+" (switchId, slot, portNum, reserved, mode) values('"+db_swName+"', '"+curBlade+"', '"+curPort+"', '0','gbic')";
							sqlErr=writeDb(sql);
							if (sqlErr!=null && sqlErr!="")
							{
								sqlSuccess=false;
								errMsg="SQL Update Error - Switch Blade/Port Creation - Base 10GE Section"+curBlade+", Port "+curPort+"<BR/>"+sqlErr;
							}
							else 
							{
								errMsg="";
							}
							curPort++;
						}
						portMax=8;
						curPort=1;
						while (curPort<=portMax)
						{
							sql="INSERT INTO "+dc+db_swName+" (switchId, slot, portNum, reserved, mode) values('"+db_swName+"', '"+curBlade+"-Exp', '"+curPort+"', '0','gbic')";
							sqlErr=writeDb(sql);
							if (sqlErr!=null && sqlErr!="")
							{
								sqlSuccess=false;
								errMsg="SQL Update Error - Switch Blade/Port Creation - Expansion Section "+curBlade+", Port "+curPort+"<BR/>"+sqlErr;
							}
							else 
							{
								errMsg="";
							}
							curPort++;
						}
						break;
					}
					curBlade++;
				}
			}
		}
		return errMsg;
	}

/// <summary>
///   The <see cref="buildNexus2232PP(string, string, string)"/> non-static void method is used to build a new Cisco Nexus 2232PP switch for the switch port inventory functionality of CIS.
/// </summary>
/// <param name="name">
///   A <see cref="System.String"/> containing the name to associate with the newly created switch.
/// </param>
/// <param name="rackspaceId">
///   A <see cref="System.String"/> containing the hardware rackspace identifier to associate with the newly created switch.
/// </param>
/// <param name="dc">
///   A <see cref="System.String"/> containing the datacenter identifier to associate with the newly created switch.
/// </param>
/// <returns> 
///   A <see cref="System.String"/> containing the result status of the switch creation action.
/// </returns>
/// <seealso cref="writeDb(string)">
///	  The <see cref="writeDb(string)"/> static property is accessed(required) by this method.
/// </seealso>
/// <remarks>
///    If the method is successful a blank string will be returned.
/// </remarks>
	public string buildNexus2232PP(string name,string rackspaceId, string dc)
	{
		int curBlade=1, curPort=1;
		int bladeMax=1, portMax=0;
		string sql="", sqlErr="", errMsg="", db_swName="";
		bool sqlSuccess;
		db_swName=fix_access(removeSpaces(name)).ToLower();
		sql="CREATE TABLE "+dc+db_swName+" ([portId] COUNTER PRIMARY KEY, [switchId] Text(50), [slot] Text(50), [portNum] Text(50), [reserved] Text(50), [cabledTo] Integer, [comment] Text(255), [mode] Text(50))";
		sqlErr=writeDb(sql);
		if (sqlErr!=null && sqlErr!="")
		{
			sqlSuccess=false;
			errMsg= "SQL Update Error - Switch Table Creation<BR/>"+sqlErr;
		}
		else
		{
			sqlErr="";
			sql="INSERT INTO switches (switchName,description,rackspaceId,media) VALUES ('"+dc+db_swName+"','"+name.ToUpper()+"','"+rackspaceId+"','FCoE')";
			sqlErr=writeDb(sql);
			if (sqlErr=="")
			{
				while (curBlade <=bladeMax && errMsg=="")
				{
					switch (curBlade)
					{
					case 1:
						portMax=32;
						curPort=1;
						while (curPort<=portMax)
						{
							sql="INSERT INTO "+dc+db_swName+" (switchId, slot, portNum, reserved, mode) values('"+db_swName+"', '1/10G', '"+curPort+"', '0','jack')";
							sqlErr=writeDb(sql);
							if (sqlErr!=null && sqlErr!="")
							{
								sqlSuccess=false;
								errMsg="SQL Update Error - Switch Blade/Port Creation - 1/10 Gig Section, Port "+curPort+"<BR/>"+sqlErr;
							}
							else 
							{
								errMsg="";
							}
							curPort++;
						}
						portMax=8;
						curPort=1;
						while (curPort<=portMax)
						{
							sql="INSERT INTO "+dc+db_swName+" (switchId, slot, portNum, reserved, mode) values('"+db_swName+"', '10G', '"+curPort+"', '0','gbic')";
							sqlErr=writeDb(sql);
							if (sqlErr!=null && sqlErr!="")
							{
								sqlSuccess=false;
								errMsg="SQL Update Error - Switch Blade/Port Creation - 10 Gig Section, Port "+curPort+"<BR/>"+sqlErr;
							}
							else 
							{
								errMsg="";
							}
							curPort++;
						}
						break;
					}
					curBlade++;
				}
			}
		}
		return errMsg;
	}

/// <summary>
///   The <see cref="buildNexus2248TP(string, string, string)"/> non-static void method is used to build a new Cisco Nexus 2248TP switch for the switch port inventory functionality of CIS.
/// </summary>
/// <param name="name">
///   A <see cref="System.String"/> containing the name to associate with the newly created switch.
/// </param>
/// <param name="rackspaceId">
///   A <see cref="System.String"/> containing the hardware rackspace identifier to associate with the newly created switch.
/// </param>
/// <param name="dc">
///   A <see cref="System.String"/> containing the datacenter identifier to associate with the newly created switch.
/// </param>
/// <returns> 
///   A <see cref="System.String"/> containing the result status of the switch creation action.
/// </returns>
/// <seealso cref="writeDb(string)">
///	  The <see cref="writeDb(string)"/> static property is accessed(required) by this method.
/// </seealso>
/// <remarks>
///    If the method is successful a blank string will be returned.
/// </remarks>
	public string buildNexus2248TP(string name,string rackspaceId, string dc)
	{
		int curBlade=1, curPort=1;
		int bladeMax=1, portMax=0;
		string sql="", sqlErr="", errMsg="", db_swName="";
		bool sqlSuccess;
		db_swName=fix_access(removeSpaces(name)).ToLower();
		sql="CREATE TABLE "+dc+db_swName+" ([portId] COUNTER PRIMARY KEY, [switchId] Text(50), [slot] Text(50), [portNum] Text(50), [reserved] Text(50), [cabledTo] Integer, [comment] Text(255), [mode] Text(50))";
		sqlErr=writeDb(sql);
		if (sqlErr!=null && sqlErr!="")
		{
			sqlSuccess=false;
			errMsg= "SQL Update Error - Switch Table Creation<BR/>"+sqlErr;
		}
		else
		{
			sqlErr="";
			sql="INSERT INTO switches (switchName,description,rackspaceId,media) VALUES ('"+dc+db_swName+"','"+name.ToUpper()+"','"+rackspaceId+"','FCoE (Ethernet)')";
			sqlErr=writeDb(sql);
			if (sqlErr=="")
			{
				while (curBlade <=bladeMax && errMsg=="")
				{
					switch (curBlade)
					{
					case 1:
						portMax=48;
						curPort=1;
						while (curPort<=portMax)
						{
							sql="INSERT INTO "+dc+db_swName+" (switchId, slot, portNum, reserved, mode) values('"+db_swName+"', '1/10G-TP', '"+curPort+"', '0','jack')";
							sqlErr=writeDb(sql);
							if (sqlErr!=null && sqlErr!="")
							{
								sqlSuccess=false;
								errMsg="SQL Update Error - Switch Blade/Port Creation - 1/10 GigTP Section, Port "+curPort+"<BR/>"+sqlErr;
							}
							else 
							{
								errMsg="";
							}
							curPort++;
						}
						portMax=4;
						curPort=1;
						while (curPort<=portMax)
						{
							sql="INSERT INTO "+dc+db_swName+" (switchId, slot, portNum, reserved, mode) values('"+db_swName+"', '10G-SFP', '"+curPort+"', '0','gbic')";
							sqlErr=writeDb(sql);
							if (sqlErr!=null && sqlErr!="")
							{
								sqlSuccess=false;
								errMsg="SQL Update Error - Switch Blade/Port Creation - 10G SFP Section, Port "+curPort+"<BR/>"+sqlErr;
							}
							else 
							{
								errMsg="";
							}
							curPort++;
						}
						break;
					}
					curBlade++;
				}
			}
		}
		return errMsg;
	}

/// <summary>
///   The <see cref="buildMDS9120(string, string, string)"/> non-static void method is used to build a new Cisco MDS 9120 switch for the switch port inventory functionality of CIS.
/// </summary>
/// <param name="name">
///   A <see cref="System.String"/> containing the name to associate with the newly created switch.
/// </param>
/// <param name="rackspaceId">
///   A <see cref="System.String"/> containing the hardware rackspace identifier to associate with the newly created switch.
/// </param>
/// <param name="dc">
///   A <see cref="System.String"/> containing the datacenter identifier to associate with the newly created switch.
/// </param>
/// <returns> 
///   A <see cref="System.String"/> containing the result status of the switch creation action.
/// </returns>
/// <seealso cref="writeDb(string)">
///	  The <see cref="writeDb(string)"/> static property is accessed(required) by this method.
/// </seealso>
/// <remarks>
///    If the method is successful a blank string will be returned.
/// </remarks>
	public string buildMDS9120(string name,string rackspaceId, string dc)
	{
		int curBlade=1, curPort=1;
		int bladeMax=1, portMax=0;
		string sql="", sqlErr="", errMsg="", db_swName="";
		bool sqlSuccess;
		db_swName=fix_access(removeSpaces(name)).ToLower();
		sql="CREATE TABLE "+dc+db_swName+" ([portId] COUNTER PRIMARY KEY, [switchId] Text(50), [slot] Text(50), [portNum] Text(50), [reserved] Text(50), [cabledTo] Integer, [comment] Text(255), [mode] Text(50))";
		sqlErr=writeDb(sql);
		if (sqlErr!=null && sqlErr!="")
		{
			sqlSuccess=false;
			errMsg= "SQL Update Error - Switch Table Creation<BR/>"+sqlErr;
		}
		else
		{
			sqlErr="";
			sql="INSERT INTO switches (switchName,description,rackspaceId,media) VALUES ('"+dc+db_swName+"','"+name.ToUpper()+"','"+rackspaceId+"','Fibre Channel')";
			sqlErr=writeDb(sql);
			if (sqlErr=="")
			{
				while (curBlade <=bladeMax && errMsg=="")
				{
					switch (curBlade)
					{
					case 1:
						portMax=20;
						curPort=1;
						sql="INSERT INTO "+dc+db_swName+" (switchId, slot, portNum, reserved, mode) values('"+db_swName+"', '"+curBlade+"', 'Con', '0','jack')";
						sqlErr=writeDb(sql);
						if (sqlErr!=null && sqlErr!="")
						{
							sqlSuccess=false;
							errMsg="SQL Update Error - Switch Blade/Port Creation - Group "+curBlade+", Console Port <BR/>"+sqlErr;
						}
						else 
						{
							errMsg="";
						}
						sql="INSERT INTO "+dc+db_swName+" (switchId, slot, portNum, reserved, mode) values('"+db_swName+"', '"+curBlade+"', 'Mgt', '0','jack')";
						sqlErr=writeDb(sql);
						if (sqlErr!=null && sqlErr!="")
						{
							sqlSuccess=false;
							errMsg="SQL Update Error - Switch Blade/Port Creation - Group "+curBlade+", Mgmt Port <BR/>"+sqlErr;
						}
						else 
						{
							errMsg="";
						}

						while (curPort<=portMax)
						{
							sql="INSERT INTO "+dc+db_swName+" (switchId, slot, portNum, reserved, mode) values('"+db_swName+"', '"+curBlade+"', '"+curPort+"', '0','gbic')";
							sqlErr=writeDb(sql);
							if (sqlErr!=null && sqlErr!="")
							{
								sqlSuccess=false;
								errMsg="SQL Update Error - Switch Blade/Port Creation - Group "+curBlade+", Port "+curPort+"<BR/>"+sqlErr;
							}
							else 
							{
								errMsg="";
							}
							curPort++;
						}
						break;
					}
					curBlade++;
				}
			}
		}
		return errMsg;
	}

/// <summary>
///   The <see cref="buildMDS9020(string, string, string)"/> non-static void method is used to build a new Cisco MDS 9020 switch for the switch port inventory functionality of CIS.
/// </summary>
/// <param name="name">
///   A <see cref="System.String"/> containing the name to associate with the newly created switch.
/// </param>
/// <param name="rackspaceId">
///   A <see cref="System.String"/> containing the hardware rackspace identifier to associate with the newly created switch.
/// </param>
/// <param name="dc">
///   A <see cref="System.String"/> containing the datacenter identifier to associate with the newly created switch.
/// </param>
/// <returns> 
///   A <see cref="System.String"/> containing the result status of the switch creation action.
/// </returns>
/// <seealso cref="writeDb(string)">
///	  The <see cref="writeDb(string)"/> static property is accessed(required) by this method.
/// </seealso>
/// <remarks>
///    If the method is successful a blank string will be returned.
/// </remarks>
	public string buildMDS9020(string name,string rackspaceId, string dc)
	{
		int curBlade=1, curPort=1;
		int bladeMax=1, portMax=0;
		string sql="", sqlErr="", errMsg="", db_swName="";
		DataSet dat=new DataSet();
		bool sqlSuccess;
		db_swName=fix_access(removeSpaces(name)).ToLower();
		sql="CREATE TABLE "+dc+db_swName+" ([portId] COUNTER PRIMARY KEY, [switchId] Text(50), [slot] Text(50), [portNum] Text(50), [reserved] Text(50), [cabledTo] Integer, [comment] Text(255), [mode] Text(50))";
		sqlErr=writeDb(sql);
		if (sqlErr!=null && sqlErr!="")
		{
			sqlSuccess=false;
			errMsg= "SQL Update Error - Switch Table Creation<BR/>"+sqlErr;
		}
		else
		{
			sqlErr="";
			sql="INSERT INTO switches (switchName,description,rackspaceId,media) VALUES ('"+dc+db_swName+"','"+name.ToUpper()+"','"+rackspaceId+"','Fibre Channel')";
			sqlErr=writeDb(sql);
			if (sqlErr=="")
			{
				while (curBlade <=bladeMax && errMsg=="")
				{
					switch (curBlade)
					{
					case 1:
						portMax=20;
						curPort=1;
						sql="INSERT INTO "+dc+db_swName+" (switchId, slot, portNum, reserved, mode) values('"+db_swName+"', '"+curBlade+"', 'Mgt', '0','jack')";
						sqlErr=writeDb(sql);
						if (sqlErr!=null && sqlErr!="")
						{
							sqlSuccess=false;
							errMsg="SQL Update Error - Switch Blade/Port Creation - Group "+curBlade+", Mgmt Port <BR/>"+sqlErr;
						}
						else 
						{
							errMsg="";
						}
						while (curPort<=portMax)
						{
							sql="INSERT INTO "+dc+db_swName+" (switchId, slot, portNum, reserved, mode) values('"+db_swName+"', '"+curBlade+"', '"+curPort+"', '0','gbic')";
							sqlErr=writeDb(sql);
							if (sqlErr!=null && sqlErr!="")
							{
								sqlSuccess=false;
								errMsg="SQL Update Error - Switch Blade/Port Creation - Group "+curBlade+", Port "+curPort+"<BR/>"+sqlErr;
							}
							else 
							{
								errMsg="";
							}
							curPort++;
						}
						break;
					}
					curBlade++;
				}
			}
		}
		return errMsg;
	}

/// <summary>
///   The <see cref="buildNexus7000(string, string, string)"/> non-static void method is used to build a new Cisco Nexus 7000 switch for the switch port inventory functionality of CIS.
/// </summary>
/// <param name="name">
///   A <see cref="System.String"/> containing the name to associate with the newly created switch.
/// </param>
/// <param name="rackspaceId">
///   A <see cref="System.String"/> containing the hardware rackspace identifier to associate with the newly created switch.
/// </param>
/// <param name="dc">
///   A <see cref="System.String"/> containing the datacenter identifier to associate with the newly created switch.
/// </param>
/// <returns> 
///   A <see cref="System.String"/> containing the result status of the switch creation action.
/// </returns>
/// <seealso cref="writeDb(string)">
///	  The <see cref="writeDb(string)"/> static property is accessed(required) by this method.
/// </seealso>
/// <remarks>
///    If the method is successful a blank string will be returned.
/// </remarks>
	public string buildNexus7000(string name,string rackspaceId, string dc)
	{
		int curBlade=1, curPort=1;
		int bladeMax=9, portMax=0;
		string sql="", sqlErr="", errMsg="", db_swName="";
		bool sqlSuccess;
		db_swName=fix_access(removeSpaces(name)).ToLower();
		sql="CREATE TABLE "+dc+db_swName+" ([portId] COUNTER PRIMARY KEY, [switchId] Text(50), [slot] Text(50), [portNum] Text(50), [reserved] Text(50), [cabledTo] Integer, [comment] Text(255))";
		sqlErr=writeDb(sql);
		if (sqlErr!=null && sqlErr!="")
		{
			sqlSuccess=false;
			errMsg= "SQL Update Error - Switch Table Creation<BR/>"+sqlErr;
		}
		else
		{
			sqlErr="";
			sql="INSERT INTO switches (switchName,description,rackspaceId,media) VALUES ('"+dc+db_swName+"','"+name.ToUpper()+"','"+rackspaceId+"','FCoE')";
			sqlErr=writeDb(sql);
			if (sqlErr=="")
			{
				while (curBlade <=bladeMax && errMsg=="")
				{
					switch (curBlade)
					{
					case 1:
						portMax=2;
						curPort=1;
						while (curPort<=portMax)
						{
							sql="INSERT INTO "+dc+db_swName+" (switchId, slot, portNum, reserved) values('"+db_swName+"', '"+curBlade+"', '"+curPort+"', '0')";
							sqlErr=writeDb(sql);
							if (sqlErr!=null && sqlErr!="")
							{
								sqlSuccess=false;
								errMsg="SQL Update Error - Switch Blade/Port Creation - Blade "+curBlade+", Port "+curPort+"<BR/>"+sqlErr;
							}
							else 
							{
								errMsg="";
							}
							curPort++;
						}
						break;
					case 2:
						portMax=48;
						curPort=1;
						while (curPort<=portMax)
						{
							sql="INSERT INTO "+dc+db_swName+" (switchId, slot, portNum, reserved) values('"+db_swName+"', '"+curBlade+"', '"+curPort+"', '0')";
							sqlErr=writeDb(sql);
							if (sqlErr!=null && sqlErr!="")
							{
								sqlSuccess=false;
								errMsg="SQL Update Error - Switch Blade/Port Creation - Blade "+curBlade+", Port "+curPort+"<BR/>"+sqlErr;
							}
							else 
							{
								errMsg="";
							}
							curPort++;
						}
						break;
					case 3:
						portMax=48;
						curPort=1;
						while (curPort<=portMax)
						{
							sql="INSERT INTO "+dc+db_swName+" (switchId, slot, portNum, reserved) values('"+db_swName+"', '"+curBlade+"', '"+curPort+"', '0')";
							sqlErr=writeDb(sql);
							if (sqlErr!=null && sqlErr!="")
							{
								sqlSuccess=false;
								errMsg="SQL Update Error - Switch Blade/Port Creation - Blade "+curBlade+", Port "+curPort+"<BR/>"+sqlErr;
							}
							else 
							{
								errMsg="";
							}
							curPort++;
						}
						break;
					case 4:
						portMax=48;
						curPort=1;
						while (curPort<=portMax)
						{
							sql="INSERT INTO "+dc+db_swName+" (switchId, slot, portNum, reserved) values('"+db_swName+"', '"+curBlade+"', '"+curPort+"', '0')";
							sqlErr=writeDb(sql);
							if (sqlErr!=null && sqlErr!="")
							{
								sqlSuccess=false;
								errMsg="SQL Update Error - Switch Blade/Port Creation - Blade "+curBlade+", Port "+curPort+"<BR/>"+sqlErr;
							}
							else 
							{
								errMsg="";
							}
							curPort++;
						}
						break;
					case 5:
						portMax=0;
						curPort=1;
						while (curPort<=portMax)
						{
							sql="INSERT INTO "+dc+db_swName+" (switchId, slot, portNum, reserved) values('"+db_swName+"', '"+curBlade+"', '"+curPort+"', '0')";
							sqlErr=writeDb(sql);
							if (sqlErr!=null && sqlErr!="")
							{
								sqlSuccess=false;
								errMsg="SQL Update Error - Switch Blade/Port Creation - Blade "+curBlade+", Port "+curPort+"<BR/>"+sqlErr;
							}
							else 
							{
								errMsg="";
							}
							curPort++;
						}
						break;
					case 6:
						portMax=0;
						curPort=1;
						while (curPort<=portMax)
						{
							sql="INSERT INTO "+dc+db_swName+" (switchId, slot, portNum, reserved) values('"+db_swName+"', '"+curBlade+"', '"+curPort+"', '0')";
							sqlErr=writeDb(sql);
							if (sqlErr!=null && sqlErr!="")
							{
								sqlSuccess=false;
								errMsg="SQL Update Error - Switch Blade/Port Creation - Blade "+curBlade+", Port "+curPort+"<BR/>"+sqlErr;
							}
							else 
							{
								errMsg="";
							}
							curPort++;
						}
						break;
					case 7:
						portMax=48;
						curPort=1;
						while (curPort<=portMax)
						{
							sql="INSERT INTO "+dc+db_swName+" (switchId, slot, portNum, reserved) values('"+db_swName+"', '"+curBlade+"', '"+curPort+"', '0')";
							sqlErr=writeDb(sql);
							if (sqlErr!=null && sqlErr!="")
							{
								sqlSuccess=false;
								errMsg="SQL Update Error - Switch Blade/Port Creation - Blade "+curBlade+", Port "+curPort+"<BR/>"+sqlErr;
							}
							else 
							{
								errMsg="";
							}
							curPort++;
						}
						break;
					case 8:
						portMax=48;
						curPort=1;
						while (curPort<=portMax)
						{
							sql="INSERT INTO "+dc+db_swName+" (switchId, slot, portNum, reserved) values('"+db_swName+"', '"+curBlade+"', '"+curPort+"', '0')";
							sqlErr=writeDb(sql);
							if (sqlErr!=null && sqlErr!="")
							{
								sqlSuccess=false;
								errMsg="SQL Update Error - Switch Blade/Port Creation - Blade "+curBlade+", Port "+curPort+"<BR/>"+sqlErr;
							}
							else 
							{
								errMsg="";
							}
							curPort++;
						}
						break;
					case 9:
						portMax=48;
						curPort=1;
						while (curPort<=portMax)
						{
							sql="INSERT INTO "+dc+db_swName+" (switchId, slot, portNum, reserved) values('"+db_swName+"', '"+curBlade+"', '"+curPort+"', '0')";
							sqlErr=writeDb(sql);
							if (sqlErr!=null && sqlErr!="")
							{
								sqlSuccess=false;
								errMsg="SQL Update Error - Switch Blade/Port Creation - Blade "+curBlade+", Port "+curPort+"<BR/>"+sqlErr;
							}
							else 
							{
								errMsg="";
							}
							curPort++;
						}	
						break;
					}
					curBlade++;
				}
			}
		}
		return errMsg;
	}

/// <summary>
///   The <see cref="getPorts(string, string)"/> non-static void method is used to fetch all switch ports documented as cabled to a given rackspaceId (lump of hardware) for the switch port inventory functionality of CIS.
/// </summary>
/// <param name="rackspaceId">
///   A <see cref="System.String"/> containing the hardware rackspace identifier for which to seek cabled ports.
/// </param>
/// <param name="dc">
///   A <see cref="System.String"/> containing the datacenter identifier to associate with the porting search.
/// </param>
/// <seealso cref="readDb(string)">
///	  The <see cref="readDb(string)"/> static property is accessed(required) by this method.
/// </seealso>
/// <returns> 
///   A <see cref="System.Data.DataSet"/> containing the results of the port search.
/// </returns>
/// <remarks>
///    
/// </remarks>
	public DataSet getPorts(string rackspaceId, string dcPrefix)
	{
		string sqlServer="", sqlBc="", sqlPorts="", sqlSwitch="", cableSrc="";
		DataSet datServer, datBc, datSwitch, datPorts;
		int i, rowCount;
		
		sqlServer="SELECT * FROM "+dcPrefix+"rackspace WHERE rackspaceId="+rackspaceId;
		datServer=readDb(sqlServer);
		if (datServer.Tables[0].Rows[0]["bc"].ToString()!="")
		{
			sqlBc="SELECT rackspaceId FROM "+dcPrefix+"rackspace WHERE bc='"+datServer.Tables[0].Rows[0]["bc"].ToString()+"' AND slot='00'";
			datBc=readDb(sqlBc);
			if (datBc!=null)
			{
				cableSrc="cabledTo IN ("+datBc.Tables[0].Rows[0]["rackspaceId"].ToString()+","+rackspaceId+")";
			}		
		}
		else
		{
			cableSrc="cabledTo="+rackspaceId;
		}

		sqlSwitch="SELECT switchName FROM "+dcPrefix+"switches";
		datSwitch=readDb(sqlSwitch);

		if (datSwitch!=null)
		{
			rowCount = datSwitch.Tables[0].Rows.Count;
			i=1;
			foreach (DataTable dt in datSwitch.Tables)
			{
				foreach (DataRow dr in dt.Rows)
				{
					sqlPorts=sqlPorts+"SELECT * FROM "+dr["switchName"].ToString()+" WHERE "+cableSrc;
					if (i<rowCount)
					{
						sqlPorts=sqlPorts+" UNION ";
					}
					i++;
				}
			}
		}
		datPorts=readDb(sqlPorts);
		if (datPorts!=null && (datPorts.Tables.Count==0 || datPorts.Tables[0].Rows.Count==0)) datPorts=null;
		return datPorts; 
	}

/// <summary>
///   The <see cref="compactDB()"/> non-static void method is used to perform a compat and repair on MS-JET (MS Access) databases.
/// </summary>
/// <returns> 
///   A <see cref="System.String"/> containing the results of the rompact and repair.
/// </returns>
/// <remarks>
///    If the method is successful a blank string will be returned.
/// </remarks>
	public string compactDB()
	{
	    object[] oParams;
		object objJRO = 
	      Activator.CreateInstance(Type.GetTypeFromProgID("JRO.JetEngine"));

		string infile = System.Configuration.ConfigurationManager.AppSettings["db_OleDbPath"].ToString()+System.Configuration.ConfigurationManager.AppSettings["db_OleDbFile"].ToString();
		string outfile =System.Configuration.ConfigurationManager.AppSettings["db_OleDbPath"].ToString()+System.Configuration.ConfigurationManager.AppSettings["db_OleDbFile"].ToString()+"w";
		try
		{
			File.Delete(outfile);
		}
		catch (System.Exception ex)
		{

		}
		string result="";

		string mySrc = "Provider=Microsoft.Jet.OLEDB.4.0; Data Source=" +infile+ ";";
		string myDst = "Provider=Microsoft.Jet.OLEDB.4.0; Data Source=" +outfile+ ";";

		try
		{
		    oParams = new object[] {
			    mySrc,myDst};
			objJRO.GetType().InvokeMember("CompactDatabase",
				System.Reflection.BindingFlags.InvokeMethod,
				null,
		        objJRO,
			    oParams);
		    System.IO.File.Delete(infile);
			System.IO.File.Move(outfile,infile);
			result="DB Compacted Successfully!";
		}
		catch (System.Exception ex)
		{
			result=ex.ToString();
		}
	    System.Runtime.InteropServices.Marshal.ReleaseComObject(objJRO);
		objJRO=null;
		return result;
	}


// STATIC conspectisLibrary Methods (Usable via WebUI & PowerShell)
//------------------------------------------------------------------------
/// <summary>
///   The <see cref="Encrypt(string)"/> static method is used to apply Rinjadel (MD5/SHA1) encryption to a given string value.
/// </summary>
/// <param name="plainText">
///   A <see cref="System.String"/> containing the text to be encrypted.
/// </param>
/// <param name="initV">
///   A <see cref="System.String"/> containing the Init Vector for the Rinjadel (MD5/SHA1) encryption.
/// </param>
/// <param name="salt">
///   A <see cref="System.String"/> containing the Salt value for the Rinjadel (MD5/SHA1) encryption.
/// </param>
/// <param name="pass">
///   A <see cref="System.String"/> containing the passphrase for the Rinjadel (MD5/SHA1) encryption.
/// </param>
/// <param name="algo">
///   A <see cref="System.String"/> containing the algorithm for the Rinjadel (MD5/SHA1) encryption.
/// </param>
/// <param name="iterations">
///   A <see cref="System.Int32"/> containing the number of iterations for the Rinjadel (MD5/SHA1) encryption.
/// </param>
/// <param name="keySz">
///   A <see cref="System.Int32"/> containing the key size for the Rinjadel (MD5/SHA1) encryption.
/// </param>
/// <param name="prefix">
///   A <see cref="System.String"/> containing the plain-text prefix to attach to for the Rinjadel (MD5/SHA1) encrypted strings.
/// </param>
/// <returns> 
///   A <see cref="System.String"/> containing SHA1/MD5 encrypted string value.
/// </returns>
/// <remarks>
///   Based on sample code from <see cref="!http://www.obviex.com/samples/code.aspx?source=encryptioncs&title=symmetric%20key%20encryption&lang=c%23">HERE</see> in accordance with legal requirements <see cref="http://www.obviex.com/Legal.aspx#Samples">HERE</see>.
///    THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, 
///    EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED 
///    WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE.
/// 
///    Copyright (C) 2002 Obviex(TM). All rights reserved.
/// </remarks>
    public static string Encrypt(string plainText, string initV, string salt, string pass, string algo, int iterations, int keySz, string prefix)
    {
		if (plainText!="" && plainText!=null)
		{
			string cipherCheck;
			if (plainText.Length>3)
			{
				cipherCheck=plainText.Substring(0,3);
			}
			else
			{
				cipherCheck="";
			}
			if (cipherCheck==prefix)
			{
				return plainText;
			}
			else
			{
			    // Convert strings into byte arrays.
		        // Let us assume that strings only contain ASCII codes.
				// If strings include Unicode characters, use Unicode, UTF7, or UTF8 
				// encoding.
		        byte[] initVectorBytes = Encoding.ASCII.GetBytes(initV);
				byte[] saltValueBytes  = Encoding.ASCII.GetBytes(salt);
			
				// Convert our plaintext into a byte array.
		        // Let us assume that plaintext contains UTF8-encoded characters.
				byte[] plainTextBytes  = Encoding.UTF8.GetBytes(plainText);
        
			    // First, we must create a password, from which the key will be derived.
				// This password will be generated from the specified passphrase and 
				// salt value. The password will be created using the specified hash 
			    // algorithm. Password creation can be done in several iterations.
			    PasswordDeriveBytes password = new PasswordDeriveBytes(
								                                pass, 
							                                    saltValueBytes, 
						                                        algo, 
							                                    iterations);
        
				// Use the password to generate pseudo-random bytes for the encryption
			    // key. Specify the size of the key in bytes (instead of bits).
			    byte[] keyBytes = password.GetBytes(keySz / 8);
        
				// Create uninitialized Rijndael encryption object.
			    RijndaelManaged symmetricKey = new RijndaelManaged();
        
		        // It is reasonable to set encryption mode to Cipher Block Chaining
				// (CBC). Use default options for other symmetric key parameters.
				symmetricKey.Mode = CipherMode.CBC;        
        
		        // Generate encryptor from the existing key bytes and initialization 
				// vector. Key size will be defined based on the number of the key 
			    // bytes.
				ICryptoTransform encryptor = symmetricKey.CreateEncryptor(
					                                             keyBytes, 
						                                         initVectorBytes);
        
		        // Define memory stream which will be used to hold encrypted data.
				MemoryStream memoryStream = new MemoryStream();        
                
			    // Define cryptographic stream (always use Write mode for encryption).
				CryptoStream cryptoStream = new CryptoStream(memoryStream, 
					                                         encryptor,
						                                     CryptoStreamMode.Write);
				// Start encrypting.
				cryptoStream.Write(plainTextBytes, 0, plainTextBytes.Length);
                
		        // Finish encrypting.
				cryptoStream.FlushFinalBlock();

			    // Convert our encrypted data from a memory stream into a byte array.
				byte[] cipherTextBytes = memoryStream.ToArray();
                
				// Close both streams.
			    memoryStream.Close();
			    cryptoStream.Close();
        
				// Convert encrypted data into a base64-encoded string.
		        string cipherText = Convert.ToBase64String(cipherTextBytes);
				cipherText=prefix+cipherText;
        
			    // Return encrypted string.
				return cipherText;
			}
		}
		else
		{
			return plainText;
		}
	}

/// <summary>
///   The <see cref="Decrypt(string)"/> static method is used to decrypt Rinjadel (MD5/SHA1) encrypted strings into tplain text.
/// </summary>
/// <param name="cipherText">
///   A <see cref="System.String"/> containing the text to be decrypted.
/// </param>
/// <param name="initV">
///   A <see cref="System.String"/> containing the Init Vector for the Rinjadel (MD5/SHA1) decryption.
/// </param>
/// <param name="salt">
///   A <see cref="System.String"/> containing the Salt value for the Rinjadel (MD5/SHA1) decryption.
/// </param>
/// <param name="pass">
///   A <see cref="System.String"/> containing the passphrase for the Rinjadel (MD5/SHA1) decryption.
/// </param>
/// <param name="algo">
///   A <see cref="System.String"/> containing the algorithm for the Rinjadel (MD5/SHA1) decryption.
/// </param>
/// <param name="iterations">
///   A <see cref="System.Int32"/> containing the number of iterations for the Rinjadel (MD5/SHA1) decryption.
/// </param>
/// <param name="keySz">
///   A <see cref="System.Int32"/> containing the key size for the Rinjadel (MD5/SHA1) decryption.
/// </param>
/// <param name="prefix">
///   A <see cref="System.String"/> containing the plain-text prefix to strip to from the Rinjadel (MD5/SHA1) encrypted strings during decryption.
/// </param>
/// <returns> 
///   A <see cref="System.String"/> containing a plain text string value.
/// </returns>
/// <remarks>
///   Based on sample code from <see cref="!http://www.obviex.com/samples/code.aspx?source=encryptioncs&title=symmetric%20key%20encryption&lang=c%23">HERE</see> in accordance with legal requirements <see cref="http://www.obviex.com/Legal.aspx#Samples">HERE</see>.
///    THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, 
///    EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED 
///    WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE.
/// 
///    Copyright (C) 2002 Obviex(TM). All rights reserved.
/// </remarks>
    public static string Decrypt(string cipherText, string initV, string salt, string pass, string algo, int iterations, int keySz, string prefix)
    {
		if (cipherText!="" && cipherText!=null)
		{
			string cipherCheck=cipherText.Substring(0,3);
			if (cipherCheck!=prefix)
			{
				return cipherText;
			}
			else
			{
				// Convert strings defining encryption key characteristics into byte
			    // arrays. Let us assume that strings only contain ASCII codes.
			    // If strings include Unicode characters, use Unicode, UTF7, or UTF8
				// encoding.
			    byte[] initVectorBytes = Encoding.ASCII.GetBytes(initV);
		        byte[] saltValueBytes  = Encoding.ASCII.GetBytes(salt);
			
				// Convert our ciphertext into a byte array.
				int cipherLen = cipherText.Length - 3;
		        byte[] cipherTextBytes = Convert.FromBase64String(cipherText.Substring(3,cipherLen));
		    
				// First, we must create a password, from which the key will be 
				// derived. This password will be generated from the specified 
		        // pass and salt value. The password will be created using
				// the specified hash algorithm. Password creation can be done in
			    // several iterations.
				PasswordDeriveBytes password = new PasswordDeriveBytes(
								                                pass, 
							                                    saltValueBytes, 
						                                        algo, 
					                                            iterations);
			
				// Use the password to generate pseudo-random bytes for the encryption
			    // key. Specify the size of the key in bytes (instead of bits).
		        byte[] keyBytes = password.GetBytes(keySz / 8);
			
				// Create uninitialized Rijndael encryption object.
			    RijndaelManaged    symmetricKey = new RijndaelManaged();
        
		        // It is reasonable to set encryption mode to Cipher Block Chaining
				// (CBC). Use default options for other symmetric key parameters.
				symmetricKey.Mode = CipherMode.CBC;
        
		        // Generate decryptor from the existing key bytes and initialization 
				// vector. Key size will be defined based on the number of the key 
			    // bytes.
				ICryptoTransform decryptor = symmetricKey.CreateDecryptor(
				                                                 keyBytes, 
			                                                     initVectorBytes);
        
			    // Define memory stream which will be used to hold encrypted data.
				MemoryStream  memoryStream = new MemoryStream(cipherTextBytes);
                
			    // Define cryptographic stream (always use Read mode for encryption).
		        CryptoStream  cryptoStream = new CryptoStream(memoryStream, 
						                                      decryptor,
					                                          CryptoStreamMode.Read);

				// Since at this point we don't know what the size of decrypted data
			    // will be, allocate the buffer long enough to hold ciphertext;
			    // plaintext is never longer than ciphertext.
				byte[] plainTextBytes = new byte[cipherTextBytes.Length];
        
			    // Start decrypting.
		        int decryptedByteCount = cryptoStream.Read(plainTextBytes, 
						                                   0, 
					                                       plainTextBytes.Length);
                
				// Close both streams.
			    memoryStream.Close();
			    cryptoStream.Close();
        
				// Convert decrypted data into a string. 
			    // Let us assume that the original plaintext string was UTF8-encoded.
		        string plainText = Encoding.UTF8.GetString(plainTextBytes, 
					                                       0, 
				                                           decryptedByteCount);
        
			    // Return decrypted string.   
		       return plainText;
			}
		}
		else
		{
			return cipherText;
		}
	}

/// <summary>
///   The <see cref="readDbOle(string, string)"/> static method is used to fetch data from MS-Jet (MS-Access) databases.
/// </summary>
/// <param name="sql">
///   A <see cref="System.String"/> containing a SQL Query (SELECT, SHOW).
/// </param>
/// <param name="dbcstr">
///   A <see cref="System.String"/> containing the full database connection string for the query.
/// </param>
/// <returns> 
///   A <see cref="System.Data.DataSet"/> containing the table(s) containing the records returned from the database SQL query.
/// </returns>
/// <remarks>
///   The method will return null if the query succeeded but returned no records for the query.
/// </remarks>
	public static DataSet readDbOle(string sql, string dbcstr)
	{
		OleDbConnection con;
		OleDbCommand cmd;
		OleDbDataAdapter dap;
		DataSet dat=new DataSet();
		con = new OleDbConnection(dbcstr);
		cmd = new OleDbCommand(sql,con);
		dap = new OleDbDataAdapter(cmd);
		dat = new DataSet();
		try
		{
			dap.Fill(dat);
		}
		catch (System.Exception ex)
		{
			cmd.Connection.Close();
//			throw ex;
		}
		cmd.Connection.Close();
		if (dat!=null && (dat.Tables.Count==0 || dat.Tables[0].Rows.Count==0)) dat=null;
		return dat; 
	}

/// <summary>
///   The <see cref="writeDbOle(string, string)"/> static method is used to update a MS Access (MS-Jet) database.
/// </summary>
/// <param name="sql">
///   A <see cref="System.String"/> containing an updateable SQL Query (CREATE, ALTER, INSERT, UPDATE).
/// </param>
/// <param name="dbcstr">
///   A <see cref="System.String"/> containing the full database connection string for the query.
/// </param>
/// <returns> 
///   A <see cref="System.String"/> containing the result of the SQL update.
/// </returns>
/// <remarks>
///    A successful update will return an empty string.
/// </remarks>
	public static string writeDbOle(string sql, string dbcstr)
	{
		OleDbConnection con;
		OleDbCommand cmd;
		string result="";
		con = new OleDbConnection(dbcstr);
		cmd = new OleDbCommand(sql,con);
		cmd.Connection.Open();
		try
		{
			cmd.ExecuteNonQuery();
		}
		catch (System.Exception ex)
		{
			cmd.Connection.Close();
			result=ex.ToString();
		}
		cmd.Connection.Close();
		return result;
	}

/// <summary>
///   The <see cref="readDbSql(string, string)"/> static method is used to fetch data from MS SQL Server (T-SQL) databases.
/// </summary>
/// <param name="sql">
///   A <see cref="System.String"/> containing a SQL Query (SELECT, SHOW).
/// </param>
/// <param name="dbcstr">
///   A <see cref="System.String"/> containing the full database connection string for the query.
/// </param>
/// <returns> 
///   A <see cref="System.Data.DataSet"/> containing the table(s) containing the records returned from the database SQL query.
/// </returns>
/// <remarks>
///   The method will return null if the query succeeded but returned no records for the query.
/// </remarks>
	public static DataSet readDbSql(string sql, string dbcstr)
	{
		SqlConnection con;
		SqlCommand cmd;
		SqlDataAdapter dap;
		DataSet dat=new DataSet();
		con = new SqlConnection(dbcstr);
		cmd = new SqlCommand(sql,con);
		dap = new SqlDataAdapter(cmd); 
		dat = new DataSet(); 
		try
		{
			dap.Fill(dat);
		}
		catch (System.Exception ex)
		{
			cmd.Connection.Close();
//			throw ex;
		}
		cmd.Connection.Close();
		if (dat!=null && (dat.Tables.Count==0 || dat.Tables[0].Rows.Count==0)) dat=null;
		return dat; 
	}

/// <summary>
///   The <see cref="writeDbSql(string, string)"/> static method is used to update a MS SQL Server (T-SQL) database.
/// </summary>
/// <param name="sql">
///   A <see cref="System.String"/> containing an updateable SQL Query (CREATE, ALTER, INSERT, UPDATE).
/// </param>
/// <param name="dbcstr">
///   A <see cref="System.String"/> containing the full database connection string for the query.
/// </param>
/// <returns> 
///   A <see cref="System.String"/> containing the result of the SQL update.
/// </returns>
/// <remarks>
///    A successful update will return an empty string.
/// </remarks>
	public static string writeDbSql(string sql, string dbcstr)
	{
		SqlConnection con;
		SqlCommand cmd;
		string result="";
		con = new SqlConnection(dbcstr);
		cmd = new SqlCommand(sql,con);
		cmd.Connection.Open();
		try
		{
			cmd.ExecuteNonQuery();
		}
		catch (System.Exception ex)
		{
			cmd.Connection.Close();
			result=ex.ToString();
		}
		cmd.Connection.Close();
		return result;
	}

/// <summary>
///   The <see cref="readDbOracle(string, string)"/> static method is used to fetch data from Oracle databases.
/// </summary>
/// <param name="sql">
///   A <see cref="System.String"/> containing a SQL Query (SELECT, SHOW).
/// </param>
/// <param name="dbcstr">
///   A <see cref="System.String"/> containing the full database connection string for the query.
/// </param>
/// <returns> 
///   A <see cref="System.Data.DataSet"/> containing the table(s) containing the records returned from the database SQL query.
/// </returns>
/// <remarks>
///   The method will return null if the query succeeded but returned no records for the query.
/// </remarks>
	public static DataSet readDbOracle(string sql, string dbcstr)
	{
		OracleConnection con;
		OracleCommand cmd;
		OracleDataAdapter dap;
		DataSet dat=new DataSet();
		con = new OracleConnection(dbcstr);
		cmd = new OracleCommand(sql,con);
		dap = new OracleDataAdapter(cmd); 
		dat = new DataSet(); 
		try
		{
			dap.Fill(dat);
		}
		catch (System.Exception ex)
		{
			cmd.Connection.Close();
//			throw ex;
		}
		cmd.Connection.Close();
		if (dat!=null && (dat.Tables.Count==0 || dat.Tables[0].Rows.Count==0)) dat=null;
		return dat; 
	}

/// <summary>
///   The <see cref="writeDbOracle(string, string)"/> static method is used to update an Oracle database.
/// </summary>
/// <param name="sql">
///   A <see cref="System.String"/> containing an updateable SQL Query (CREATE, ALTER, INSERT, UPDATE).
/// </param>
/// <param name="dbcstr">
///   A <see cref="System.String"/> containing the full database connection string for the query.
/// </param>
/// <returns> 
///   A <see cref="System.String"/> containing the result of the SQL update.
/// </returns>
/// <remarks>
///    A successful update will return an empty string.
/// </remarks>
	public static string writeDbOracle(string sql, string dbcstr)
	{
		OracleConnection con;
		OracleCommand cmd;
		string result="";
		con = new OracleConnection(dbcstr);
		cmd = new OracleCommand(sql,con);
		cmd.Connection.Open();
		try
		{
			cmd.ExecuteNonQuery();
		}
		catch (System.Exception ex)
		{
			cmd.Connection.Close();
			result=ex.ToString();
		}
		cmd.Connection.Close();
		return result;
	}

/// <summary>
///   The <see cref="readDbOdbc(string, string)"/> static method is used to fetch data from any ODBC-driver database connections.
/// </summary>
/// <param name="sql">
///   A <see cref="System.String"/> containing a SQL Query (SELECT, SHOW).
/// </param>
/// <param name="dbcstr">
///   A <see cref="System.String"/> containing the full database connection string for the query.
/// </param>
/// <returns> 
///   A <see cref="System.Data.DataSet"/> containing the table(s) containing the records returned from the database SQL query.
/// </returns>
/// <remarks>
///   The method will return null if the query succeeded but returned no records for the query.
/// </remarks>
	public static DataSet readDbOdbc(string sql, string dbcstr)
	{
		OdbcConnection con;
		OdbcCommand cmd;
		OdbcDataAdapter dap;
		DataSet dat=new DataSet();
		con = new OdbcConnection(dbcstr);
		cmd = new OdbcCommand(sql,con);
		dap = new OdbcDataAdapter(cmd); 
		dat = new DataSet(); 
		try
		{
			dap.Fill(dat);
		}
		catch (System.Exception ex)
		{
			cmd.Connection.Close();
//			throw ex;
		}
		cmd.Connection.Close();
		if (dat!=null && (dat.Tables.Count==0 || dat.Tables[0].Rows.Count==0)) dat=null;
		return dat; 
	}

/// <summary>
///   The <see cref="writeDbOle(string, string)"/> static method is used to update a ODBC-driver based database connection.
/// </summary>
/// <param name="sql">
///   A <see cref="System.String"/> containing an updateable SQL Query (CREATE, ALTER, INSERT, UPDATE).
/// </param>
/// <param name="dbcstr">
///   A <see cref="System.String"/> containing the full database connection string for the query.
/// </param>
/// <returns> 
///   A <see cref="System.String"/> containing the result of the SQL update.
/// </returns>
/// <remarks>
///    A successful update will return an empty string.
/// </remarks>
	public static string writeDbOdbc(string sql, string dbcstr)
	{
		OdbcConnection con;
		OdbcCommand cmd;
		string result="";
		con = new OdbcConnection(dbcstr);
		cmd = new OdbcCommand(sql,con);
		cmd.Connection.Open();
		try
		{
			cmd.ExecuteNonQuery();
		}
		catch (System.Exception ex)
		{
			cmd.Connection.Close();
			result=ex.ToString();
		}
		cmd.Connection.Close();
		return result;
	}

/// <summary>
///   The <see cref="sqlEngine(string)"/> static method is used to store & retrieve SQL strings that have no query arguments.
/// </summary>
/// <param name="strName">
///   A <see cref="System.String"/> containing the keyword of the SQL string being requested.
/// </param>
/// <returns> 
///   A <see cref="System.String"/> containing the desired SQL string.
/// </returns>
/// <remarks>
///    If the method is successful a blank string will be returned.
/// </remarks>
	public static string sqlEngine(string strName)
	{
		string result="";

		if (strName!="" && strName!=null)
		{
			switch (strName)
			{
				case "adAuthGetRoleGroupValue" :
					result="SELECT roleGroup, roleValue FROM userRoles WHERE roleGroup IS NOT NULL";
					break;
/*				case "" :
					result="";
					break;
				case "" :
					result="";
					break;
				case "" :
					result="";
					break;
				case "" :
					result="";
					break;
				case "" :
					result="";
					break;
				case "" :
					result="";
					break;
				case "" :
					result="";
					break;
				case "" :
					result="";
					break;		*/			
			}
		}
		else
		{
			result="";
		}
		return result;
	}

/// <summary>
///   The <see cref="sqlEngine(string, string)"/> static method is used to store & retrieve SQL strings that have a single query argument.
/// </summary>
/// <param name="strName">
///   A <see cref="System.String"/> containing the keyword of the SQL string being requested.
/// </param>
/// <param name="arg1">
///   A <see cref="System.String"/> containing the content of the argument to be inserted in to the SQL string.
/// </param>
/// <returns> 
///   A <see cref="System.String"/> containing the desired SQL string.
/// </returns>
/// <remarks>
///    If the method is successful a blank string will be returned.
/// </remarks>
	public static string sqlEngine(string strName, string arg1)
	{
		string result="";
		string sqlArg="";

		if (arg1!="" && arg1!=null)
		{
			sqlArg=arg1;
		}
		else 
		{
			sqlArg="";
		}
		if (strName!="" && strName!=null)
		{
			switch (strName)
			{
				case "adAuthGetAppUserInfoById" :
					result="SELECT * FROM users WHERE userId='"+sqlArg+"'";
					break;
				case "adAuthAddAppUserId" :
					result="INSERT INTO users (userId) VALUES ('"+sqlArg+"')";
					break;
				case "adAuthGetAppUserEmailById" :
					result="SELECT email FROM users WHERE userId='"+sqlArg+"'";
					break;
				case "adAuthGetAppUserFirstById" :
					result="SELECT userFirstName FROM users WHERE userId='"+sqlArg+"'";
					break;
				case "adAuthGetAppUserLastById" :
					result="SELECT userLastName FROM users WHERE userId='"+sqlArg+"'";
					break;
				case "adAuthGetAppUserPhoneById" :
					result="SELECT userOfficePhone FROM users WHERE userId='"+sqlArg+"'";
					break;
				case "adAuthGetUserRoleById" :
					result="SELECT userRole FROM users WHERE userId='"+sqlArg+"'";
					break;
/*				case "" :
					result=""+sqlArg+"";
					break;
				case "" :
					result=""+sqlArg+"";
					break;			*/
			}
		}
		else
		{
			result="";
		}
		return result;
	}

/// <summary>
///   The <see cref="sqlEngine(string, string, string)"/> static method is used to store & retrieve SQL strings that have two query arguments.
/// </summary>
/// <param name="strName">
///   A <see cref="System.String"/> containing the keyword of the SQL string being requested.
/// </param>
/// <param name="arg1">
///   A <see cref="System.String"/> containing the content of the argument to be inserted in to the SQL string.
/// </param>
/// <param name="arg2">
///   A <see cref="System.String"/> containing the content of the second argument to be inserted in to the SQL string.
/// </param>
/// <returns> 
///   A <see cref="System.String"/> containing the desired SQL string.
/// </returns>
/// <remarks>
///    If the method is successful a blank string will be returned.
/// </remarks>
	public static string sqlEngine(string strName, string arg1, string arg2)
	{
		string result="";
		string sqlArg1="";
		string sqlArg2="";

		if (arg1!="" && arg1!=null)
		{
			sqlArg1=arg1;
		}
		else 
		{
			sqlArg1="";
		}
		if (arg2!="" && arg2!=null)
		{
			sqlArg2=arg2;
		}
		else 
		{
			sqlArg2="";
		}
		if (strName!="" && strName!=null)
		{
			switch (strName)
			{
				case "adAuthUpdateAppUserEmailById" :
					result="UPDATE users SET email='"+sqlArg1+"' WHERE userId='"+sqlArg2+"'";
					break;
				case "adAuthUpdateAppUserFirstById" :
					result="UPDATE users SET userFirstName='"+sqlArg1+"' WHERE userId='"+sqlArg2+"'";
					break;
				case "adAuthUpdateAppUserLastById" :
					result="UPDATE users SET userLastName='"+sqlArg1+"' WHERE userId='"+sqlArg2+"'";
					break;
				case "adAuthUpdateAppUserPhoneById" :
					result="UPDATE users SET userPhone='"+sqlArg1+"' WHERE userId='"+sqlArg2+"'";
					break;
/*				case "" :
					result=""+sqlArg1+""+sqlArg2+"";
					break;
				case "" :
					result=""+sqlArg1+""+sqlArg2+"";
					break;
				case "" :
					result=""+sqlArg1+""+sqlArg2+"";
					break;			*/
			}
		}
		else
		{
			result="";
		}
		return result;
	}

/// <summary>
///   The <see cref="compactDB(string)"/> static method is used to perform a compat and repair on MS-JET (MS Access) databases.
/// </summary>
/// <param name="dbFile">
///   A <see cref="System.String"/> containing the full file path to the database file.
/// </param>
/// <returns> 
///   A <see cref="System.String"/> containing the results of the compact and repair.
/// </returns>
/// <remarks>
///    If the method is successful a blank string will be returned.
/// </remarks>
	public static string compactDB(string dbFile)
	{
	    object[] oParams;
		object objJRO = 
	      Activator.CreateInstance(Type.GetTypeFromProgID("JRO.JetEngine"));
		string infile=dbFile;
		string outfile=dbFile+"w";
		try
		{
			File.Delete(outfile);
		}
		catch (System.Exception ex)
		{
		}
		string result="";
		string mySrc = "Provider=Microsoft.Jet.OLEDB.4.0; Data Source=" +infile+ ";";
		string myDst = "Provider=Microsoft.Jet.OLEDB.4.0; Data Source=" +outfile+ ";";
		try
		{
		    oParams = new object[] {
			    mySrc,myDst};

			objJRO.GetType().InvokeMember("CompactDatabase",
				System.Reflection.BindingFlags.InvokeMethod,
				null,
		        objJRO,
			    oParams);

		    System.IO.File.Delete(infile);
			System.IO.File.Move(outfile,infile);
			result="DB Compacted Successfully!";
		}
		catch (System.Exception ex)
		{
			result=ex.ToString();
		}
	    System.Runtime.InteropServices.Marshal.ReleaseComObject(objJRO);
		objJRO=null;
		return result;
	}

/// <summary>
///   The <see cref="readFile(string, string, string)"/> static method is used to read a delimted-type text file into a <see cref="System.Data.DataSet"/>.
/// </summary>
/// <param name="file">
///   A <see cref="System.String"/> containing the full file path to the text file to be parsed.
/// </param>
/// <param name="tableName">
///   A <see cref="System.String"/> containing the table name to use in the returned <see cref="System.Data.DataSet"/>.
/// </param>
/// <param name="delimeter">
///   A <see cref="System.String"/> containing the text delimeter to use when parsing the text file.
/// </param>
/// <returns> 
///   A <see cref="System.Data.DataSet"/> containing the parsed values from the text file.
/// </returns>
/// <remarks>
///    
/// </remarks>
	public static DataSet readFile(string file,string tableName,string delimeter)
	{
		DataSet domains = new DataSet();
	    domains.Tables.Add(tableName);
		try
	    {
		    if (File.Exists(file))
	        {
			    StreamReader reader = new StreamReader(file);
	            string[] columns = reader.ReadLine().Split(delimeter.ToCharArray());
			    foreach (string col in columns)
		        {
					bool added = false;
		            int i = 0;
	                while (!(added))
					{
				        string columnName = col;
		                if (!(domains.Tables[tableName].Columns.Contains(columnName)))
	                    {
					        domains.Tables[tableName].Columns.Add(columnName, typeof(string));
				            added = true;
			            }
		                else
	                    {
					        i++;
				        }
			        }
		        }
				string data = reader.ReadToEnd();
	            string[] rows = data.Split("\r".ToCharArray());
			    foreach (string r in rows)
		        {
	                string[] items = r.Split(delimeter.ToCharArray());
				    domains.Tables[tableName].Rows.Add(items);
			    }
		    }
	        else
			{
		        throw new FileNotFoundException("The file " + file + " could not be found");
	        }    
	    }

		catch (FileNotFoundException ex)
	    {
			string _message = ex.Message;
		    return null;
	    }
		catch (Exception ex)
	    {
			string _message = ex.Message;
		    return null;
	    }    
	    return domains;
	}

/// <summary>
///   The <see cref="ConvertToDataTable(Object[])"/> static method is used to convert an object array into a <see cref="System.Data.DataTable"/>.
/// </summary>
/// <param name="array">
///   A <see cref="System.Object[]"/> array containing the data to be parsed.
/// </param>
/// <returns> 
///   A <see cref="System.Data.DataTable"/> containing the parsed values from the <see cref="System.Object[]"/> array.
/// </returns>
/// <remarks>
///    
/// </remarks>
	public static DataTable ConvertToDataTable(Object[] array)
	{
		PropertyInfo[] properties = array.GetType().GetElementType().GetProperties();
		DataTable dt = CreateDataTable(properties);
		if (array.Length != 0)
		{
			foreach(object o in array)
			FillData(properties, dt, o);
		}
		return dt;
	}

/// <summary>
///   The <see cref="CreateDataTable(PropertyInfo[])"/> static method is used to convert an object array into a <see cref="System.Data.DataTable"/>.
/// </summary>
/// <param name="properties">
///   A <see cref="System.Reflection.PropertyInfo[]"/> array containing the data to be parsed.
/// </param>
/// <returns> 
///   A <see cref="System.Data.DataTable"/> containing the parsed values from the <see cref="System.Reflection.PropertyInfo[]"/> array.
/// </returns>
/// <remarks>
///    
/// </remarks>
	public static DataTable CreateDataTable(PropertyInfo[] properties)
	{
		DataTable dt = new DataTable();
		DataColumn dc = null;
		foreach(PropertyInfo pi in properties)
		{
			dc = new DataColumn();
			dc.ColumnName = pi.Name;
			dc.DataType = pi.PropertyType;
			dt.Columns.Add(dc);
		}
		return dt;
	}

/// <summary>
///   The <see cref="FillData(PropertyInfo[], DataTable, Object)"/> static void method is used to convert an object array into a <see cref="System.Data.DataTable"/>.
/// </summary>
/// <param name="properties">
///   A <see cref="System.Reflection.PropertyInfo[]"/> array containing the data to be parsed.
/// </param>
/// <param name="dt">
///   A <see cref="System.Data.DataTable"/> containing.
/// </param>
/// <param name="o">
///   A <see cref="System.Object"/> containing.
/// </param>
/// <returns> 
///   A <see cref="System.Data.DataTable"/> containing the parsed values from the <see cref="System.Reflection.PropertyInfo[]"/> array.
/// </returns>
/// <remarks>
///    
/// </remarks>
	public static void FillData(PropertyInfo[] properties, DataTable dt, Object o)
	{
		DataRow dr = dt.NewRow();
		foreach(PropertyInfo pi in properties)
		{
			dr[pi.Name] = pi.GetValue(o, null);
		}
		dt.Rows.Add(dr);
	}
	
/// <summary>
///   The <see cref="sql2txt(string)"/> static method is used to strip single-quote characters from a string.
/// </summary>
/// <param name="x">
///   A <see cref="System.String"/> containing the laden string.
/// </param>
/// <returns> 
///   A <see cref="System.String"/> containing the fixed/stripped string.
/// </returns>
/// <remarks>
///    
/// </remarks>
	public static string sql2txt(string x)
	{
		string good_string;
		good_string = x.Trim();
		good_string = good_string.Replace("'", "");
		return (good_string); }

/// <summary>
///   The <see cref="removeSpaces(string)"/> static method is used to strip whitespace characters from a string.
/// </summary>
/// <param name="x">
///   A <see cref="System.String"/> containing the laden string.
/// </param>
/// <returns> 
///   A <see cref="System.String"/> containing the fixed/stripped string.
/// </returns>
/// <remarks>
///    
/// </remarks>
	public static string removeSpaces(string x)
	{
		string good_string;
		good_string = x.Trim();
		good_string = good_string.Replace(" ", "");
		return (good_string); }

/// <summary>
///   The <see cref="commaRoles(string)"/> static method is used to single-quote and comma characters from a string.
/// </summary>
/// <param name="x">
///   A <see cref="System.String"/> containing the laden string.
/// </param>
/// <returns> 
///   A <see cref="System.String"/> containing the fixed/stripped string.
/// </returns>
/// <remarks>
///    
/// </remarks>
	public static string commaRoles(string x)
	{
		string good_string;
		good_string = x.Trim();
		good_string = good_string.Replace(" ", "' ,'");
		return (good_string); }

/// <summary>
///   The <see cref="spaceDelim_to_commaDelim(string)"/> static method is used to convert a whitespace delimeted string to a comma delimeted string.
/// </summary>
/// <param name="x">
///   A <see cref="System.String"/> containing the laden string.
/// </param>
/// <returns> 
///   A <see cref="System.String"/> containing the fixed/stripped string.
/// </returns>
/// <remarks>
///    
/// </remarks>
	public static string spaceDelim_to_commaDelim(string x)
	{
			string outStr;
			outStr=commaRoles(x);
			return outStr;
	}

/// <summary>
///   The <see cref="hide_txt(string)"/> static method is used to hide characters in a string behind '*' asterisks.
/// </summary>
/// <param name="x">
///   A <see cref="System.String"/> containing the laden string.
/// </param>
/// <returns> 
///   A <see cref="System.String"/> containing the fixed/stripped string.
/// </returns>
/// <remarks>
///    
/// </remarks>
	public static string hide_txt(string x) // Hide characters in a string behind '*' asterisks
	{
		string hiddenStr = "";
		int inLength, count;
		count =0;
		inLength = x.Length;
		while (count <= inLength)
		{
			hiddenStr = hiddenStr + "*";
			count++;
		}
		return hiddenStr;  }

/// <summary>
///   The <see cref="fix_txt(string)"/> static method is used to safely alter (into XML-friendly escape sequences) a variety of insecure and illegal characters from a string.
/// </summary>
/// <param name="x">
///   A <see cref="System.String"/> containing the laden string.
/// </param>
/// <returns> 
///   A <see cref="System.String"/> containing the fixed/stripped string.
/// </returns>
/// <remarks>
///    Characters to be altered include <c>'</c>, <c><</c>, <c>></c>, <c>,</c>, <c>\</c>, <c>_</c>
/// </remarks>
	public static string fix_txt(string x)
	{
		string good_string;
		good_string = x.Trim();
		good_string = good_string.Replace("'", "''");
		good_string = good_string.Replace("<", "&lt;");
		good_string = good_string.Replace(">", "&gt;");
		good_string = good_string.Replace(",", " ");
		good_string = good_string.Replace("\"", "");
		good_string = good_string.Replace("_", " ");
		return (good_string); }

/// <summary>
///   The <see cref="showXml(string)"/> static method is used to safely alter (into XML-friendly escape sequences) a variety of insecure and illegal characters from a string.
/// </summary>
/// <param name="x">
///   A <see cref="System.String"/> containing the laden string.
/// </param>
/// <returns> 
///   A <see cref="System.String"/> containing the fixed/stripped string.
/// </returns>
/// <remarks>
///    Characters to be altered include <c><</c>, <c>></c>, <c>&</c>, <c>/</c>
/// </remarks>
	public static string showXml(string x)
	{
		string good_string;
		good_string = x.Trim();
		good_string = good_string.Replace("<", "&lt;");
		good_string = good_string.Replace(">", "&gt;");
		good_string = good_string.Replace("&", "&amp;");
		good_string = good_string.Replace("/", "&#47;");
		return good_string; }

/// <summary>
///   The <see cref="showXml(string)"/> static method is used to strip characters not allowed by MS-Access per KB826763.
/// </summary>
/// <param name="x">
///   A <see cref="System.String"/> containing the laden string.
/// </param>
/// <returns> 
///   A <see cref="System.String"/> containing the fixed/stripped string.
/// </returns>
/// <remarks>
///    
/// </remarks>
	public static string fix_access(string x)
	{
		string good_string;
		good_string = x.Trim();
		good_string = good_string.Replace(" ", "");
		good_string = good_string.Replace("'", "");
		good_string = good_string.Replace("\"", "");
		good_string = good_string.Replace("`", "");
		good_string = good_string.Replace("@", "");
		good_string = good_string.Replace("#", "");
		good_string = good_string.Replace("%", "");
		good_string = good_string.Replace("<", "");
		good_string = good_string.Replace(">", "");
		good_string = good_string.Replace("!", "");
		good_string = good_string.Replace(".", "");
		good_string = good_string.Replace("}", "");
		good_string = good_string.Replace("{", "");
		good_string = good_string.Replace("]", "");
		good_string = good_string.Replace("[", "");
		good_string = good_string.Replace("*", "");
		good_string = good_string.Replace("$", "");
		good_string = good_string.Replace(";", "");
		good_string = good_string.Replace(":", "");
		good_string = good_string.Replace("?", "");
		good_string = good_string.Replace("^", "");
		good_string = good_string.Replace("+", "");
		good_string = good_string.Replace("-", "_");
		good_string = good_string.Replace("=", "");
		good_string = good_string.Replace("~", "");
		good_string = good_string.Replace(",", "");
		good_string = good_string.Replace("\\", "");
		return (good_string); }

/// <summary>
///   The <see cref="fixQueryStr(string)"/> static method is used to prepare a unstructured string for URL encoding.
/// </summary>
/// <param name="x">
///   A <see cref="System.String"/> containing the laden string.
/// </param>
/// <returns> 
///   A <see cref="System.String"/> containing the fixed/stripped string.
/// </returns>
/// <remarks>
///    
/// </remarks>
	public static string fixQueryStr(string x)
	{
		string good_string;
		good_string = x.Trim();
		good_string = good_string.Replace(" ", "%20");
		good_string = good_string.Replace("&", "%26");
		good_string = good_string.Replace("<", "%3C");
		good_string = good_string.Replace(">", "%3E");
		good_string = good_string.Replace("\"", "%22");
		good_string = good_string.Replace("#", "%23");
		good_string = good_string.Replace("$", "%24");
		good_string = good_string.Replace("%", "%25");
		good_string = good_string.Replace("'", "%27");
		good_string = good_string.Replace("+", "%2B");
		good_string = good_string.Replace(",", "%2C");
		good_string = good_string.Replace("/", "%2F");
		good_string = good_string.Replace(":", "%3A");
		good_string = good_string.Replace(";", "%3D");
		good_string = good_string.Replace("=", "%3D");
		good_string = good_string.Replace("?", "%3F");
		good_string = good_string.Replace("@", "%40");
		good_string = good_string.Replace("[", "%5B");
		good_string = good_string.Replace("\\", "%5C");
		good_string = good_string.Replace("]", "%5D");
		good_string = good_string.Replace("^", "%5E");
		good_string = good_string.Replace("`", "%60");
		good_string = good_string.Replace("{", "%7B");
		good_string = good_string.Replace("|", "%7C");
		good_string = good_string.Replace("}", "%7D");
		good_string = good_string.Replace("~", "%7E");
		return (good_string); }

/// <summary>
///   The <see cref="unFixQueryStr(string)"/> static method is used to revert a URL encoded string to unstructured string.
/// </summary>
/// <param name="x">
///   A <see cref="System.String"/> containing the laden string.
/// </param>
/// <returns> 
///   A <see cref="System.String"/> containing the fixed/stripped string.
/// </returns>
/// <remarks>
///    
/// </remarks>
	public static string unFixQueryStr(string x)
	{
		string good_string;
		good_string = x.Trim();
		good_string = good_string.Replace("%20"," ");
		good_string = good_string.Replace("%26","&");
		good_string = good_string.Replace("%3C","<");
		good_string = good_string.Replace("%3E",">");
		good_string = good_string.Replace("%22","\"");
		good_string = good_string.Replace("%23","#");
		good_string = good_string.Replace("%24","$");
		good_string = good_string.Replace("%25","%");
		good_string = good_string.Replace("%27","'");
		good_string = good_string.Replace("%2B","+");
		good_string = good_string.Replace("%2C",",");
		good_string = good_string.Replace("%2F","/");
		good_string = good_string.Replace("%3A",":");
		good_string = good_string.Replace("%3D",";");
		good_string = good_string.Replace("%3D","=");
		good_string = good_string.Replace("%3F","?");
		good_string = good_string.Replace("%40","@");
		good_string = good_string.Replace("%5B","[");
		good_string = good_string.Replace("%5C","\\");
		good_string = good_string.Replace("%5D","]");
		good_string = good_string.Replace("%5E","^");
		good_string = good_string.Replace("%60","`");
		good_string = good_string.Replace("%7B","{");
		good_string = good_string.Replace("%7C","|");
		good_string = good_string.Replace("%7D","}");
		good_string = good_string.Replace("%7E","~");
		return (good_string); }

/// <summary>
///   The <see cref="fix_csv(string)"/> static method is used to strip characters from a string that would break the typical CSV formatting.
/// </summary>
/// <param name="x">
///   A <see cref="System.String"/> containing the laden string.
/// </param>
/// <returns> 
///   A <see cref="System.String"/> containing the fixed/stripped string.
/// </returns>
/// <remarks>
///    
/// </remarks>
	public static string fix_csv(string x) // 
	{
		string good_string;
		good_string = x.Trim();
		good_string = good_string.Replace("'", "''");
		good_string = good_string.Replace("<", "&lt;");
		good_string = good_string.Replace(">", "&gt;");
		good_string = good_string.Replace(",", " ");
		good_string = good_string.Replace("\"", "");
		return (good_string); }

/// <summary>
///   The <see cref="capitalize(string)"/> static method is used to capitalize a word (string).
/// </summary>
/// <param name="x">
///   A <see cref="System.String"/> containing the laden string.
/// </param>
/// <returns> 
///   A <see cref="System.String"/> containing the fixed/stripped string.
/// </returns>
/// <remarks>
///    
/// </remarks>
	public static string capitalize(string x)
	{
		string good_string;
		int len=x.Length;
		good_string=x.Substring(0,1).ToUpper()+x.Substring(1,len-1).ToLower();
		return (good_string); }

/// <summary>
///   The <see cref="fix_hostname(string)"/> static method is used to replace whitespace in a string with underscore.
/// </summary>
/// <param name="x">
///   A <see cref="System.String"/> containing the laden string.
/// </param>
/// <returns> 
///   A <see cref="System.String"/> containing the fixed/stripped string.
/// </returns>
/// <remarks>
///    
/// </remarks>
	public static string fix_hostname(string x) // Replace any whitespace with underscore
	{
		string good_string;
		good_string = x.Trim();
		good_string = good_string.Replace(" ", "_");
		return (good_string); }

/// <summary>
///   The <see cref="fix_os(string)"/> static method is used to convert the VMWare VimAPI Operating System text to CIS software OSBuild number.
/// </summary>
/// <param name="x">
///   A <see cref="System.String"/> containing the OS string.
/// </param>
/// <returns> 
///   A <see cref="System.String"/> containing the OSBuild Integer string.
/// </returns>
/// <remarks>
///    
/// </remarks>
	public static string fix_os(string x)
	{
		string returnOs="";
		try
		{
			switch (x)
			{
			/*
			UPDATE 10/10/01 - VALID VimAPI OS Table
			---------------------------------------------------------
			Microsoft Windows Server 2003, Enterprise Edition (32-bit)
			Microsoft Windows Server 2003, Enterprise Edition (64-bit)
			Microsoft Windows Server 2003, Standard Edition (32-bit)
			Microsoft Windows XP Professional (32-bit)
			Other (64-bit)
			Red Hat Enterprise Linux 5 (64-bit)
			Suse Linux Enterprise Server (32-bit)
			Suse Linux Enterprise Server (64-bit)
			Suse Linux Enterprise Server 10 (64 bit)
			*/
			case "Microsoft Windows Server 2003, Enterprise Edition (32-bit)":
				returnOs="10";
				break;
			case "Microsoft Windows Server 2003 Enterprise Edition (32-bit)":
				returnOs="10";
				break;
			case "Microsoft Windows Server 2003, Enterprise Edition (64-bit)":
				returnOs="12";
				break;
			case "Microsoft Windows Server 2003 Enterprise Edition (64-bit)":
				returnOs="12";
				break;

			case "Microsoft Windows Server 2003, Standard Edition (64-bit)":
				returnOs="11";
				break;
			case "Microsoft Windows Server 2003 Standard Edition (64-bit)":
				returnOs="12";
				break;
			case "Microsoft Windows Server 2003, Standard Edition (32-bit)":
				returnOs="9";
				break;
			case "Microsoft Windows Server 2003 Standard Edition (32-bit)":
				returnOs="9";
				break;				

			case "Microsoft Windows Server 2008 R2 (64-bit)":
				returnOs="26";
				break;
			case "Microsoft Windows 7 (64-bit)":
				returnOs="26";
				break;		

			case "Microsoft Windows XP Professional (32-bit)":
				returnOs="22";
				break;

			case "Suse Linux Enterprise Server (32-bit)":
				returnOs="2";
				break;
			case "Suse Linux Enterprise Server (64-bit)":
				returnOs="6";
				break;
			case "Suse Linux Enterprise Server 10 (64 bit)":
				returnOs="34";
				break;

			case "Red Hat Enterprise Linux 5 (64-bit)":
				returnOs="21";
				break;
			case "Red Hat Enterprise Linux 4":
				returnOs="20";
				break;
			}
		}
		catch (System.Exception ex)
		{
			returnOs="";
//			throw ex;
		}
		if (returnOs=="" || returnOs==null)
		{
			returnOs="NULL";
		}
		return (returnOs); }

/// <summary>
///   The <see cref="fix_fqdn(string)"/> static method is used to drop domain name from an fqdn.
/// </summary>
/// <param name="x">
///   A <see cref="System.String"/> containing the FQDN.
/// </param>
/// <returns> 
///   A <see cref="System.String"/> containing the hostame (domain removed).
/// </returns>
/// <remarks>
///    
/// </remarks>
	public static string fix_fqdn(string x)
	{
		string good_string="";
		try
		{
			int location=0;
			if (x.Length>0)
			{
				location=x.IndexOf(".");	
				good_string = x.Substring(0,location);
				good_string = good_string.Trim();
			}
		}
		catch (System.Exception ex)
		{
			good_string="";
//			throw ex;
		}
		return (good_string); }

/// <summary>
///   The <see cref="fix_num(string)"/> static method is used to ensure a string is a number.
/// </summary>
/// <param name="x">
///   A <see cref="System.String"/> containing the laden string.
/// </param>
/// <returns> 
///   A <see cref="System.String"/> containing the hostame (domain removed).
/// </returns>
/// <remarks>
///    
/// </remarks>
	public static string fix_num(string x)
	{
		string good_string;
		good_string = x;
		try { Convert.ToInt32(good_string);}
		catch (Exception e) { good_string="0"; throw e;}
		return (good_string); }

/// <summary>
///   The <see cref="fix_num(string)"/> static method is used to shorten a string to a specified length and adds '...' to the end 
/// </summary>
/// <param name="x">
///   A <see cref="System.String"/> containing the laden string.
/// </param>
/// <param name="strLen">
///   A <see cref="System.String"/> containing the desired length of truncation.
/// </param>
/// <returns> 
///   A <see cref="System.String"/> containing the shortened string.
/// </returns>
/// <remarks>
///    
/// </remarks>
	public static string short_hostname(string x, int strLen)
	{
		string good_string="";
		try
		{
			if (x.Length>strLen)
			{
				good_string = x.Substring(0,strLen);
				good_string = good_string.Trim();
				good_string = good_string+"...";
			}
			else
			{
				good_string=x;
			}
		}
		catch (System.Exception ex)
		{
			good_string=x;
//			throw ex;
		}
		return (good_string); }

/// <summary>
///   The <see cref="fix_diskSize(string)"/> static method is used to perform math on a string - divide by 1 Billion (Bytes to GB)
/// </summary>
/// <param name="x">
///   A <see cref="System.String"/> containing the laden string.
/// </param>
/// <returns> 
///   A <see cref="System.String"/> containing the shortened string.
/// </returns>
/// <remarks>
///    
/// </remarks>
	public static string fix_diskSize(string x) 
	{
		string good_disksize;
		long int_disksize;
		try
		{
			int_disksize = Convert.ToInt64(x);
			int_disksize = int_disksize/1000000000;
			int_disksize = int_disksize++;
			good_disksize = int_disksize.ToString();
		}
		catch (System.Exception ex)
		{
				good_disksize="";
		}
		if (good_disksize=="" || good_disksize==null)
		{
			good_disksize="NULL";
		}
		return (good_disksize); }	

/// <summary>
///   The <see cref="fix_diskSize(string)"/> static method is used to perform math on a string - divide by 1 Thousand (MB to GB)
/// </summary>
/// <param name="x">
///   A <see cref="System.String"/> containing the laden string.
/// </param>
/// <returns> 
///   A <see cref="System.String"/> containing the shortened string.
/// </returns>
/// <remarks>
///    
/// </remarks>
	public static string fix_ram(string x)
	{
		string good_ramsize;
		float flt_ram;
		int int_ram;
		try
		{
			flt_ram = Convert.ToSingle(x);
			flt_ram = flt_ram/1000;
			if (flt_ram <1)
			{
				good_ramsize = flt_ram.ToString();
			}
			else
			{
				int_ram = Convert.ToInt32(flt_ram);
				good_ramsize = int_ram.ToString();
			}
		}
		catch (System.Exception ex)
		{
			good_ramsize="";
//			throw ex;
		}
		if (good_ramsize=="" || good_ramsize==null)
		{
			good_ramsize="NULL";
		}
		return (good_ramsize); }	

/// <summary>
///   The <see cref="break_ip(string)"/> static method is used to adds a leading zero to the Class-C portion of IP (for DB storage & sorting)
/// </summary>
/// <param name="x">
///   A <see cref="System.String"/> containing the laden string.
/// </param>
/// <returns> 
///   A <see cref="System.String"/> containing the shortened string.
/// </returns>
/// <remarks>
///    
/// </remarks>
	public static string break_ip(string x) //Adds a leading zero to the Class-C portion of IP (for DB storage & sorting)
	{
		string good_string="";
		if (x.Length > 0)
		{
			int location=0, length=0;
			good_string = x.Trim();
			location=good_string.LastIndexOf(".");
			length=good_string.Length;
			if (length-location < 4)
			{
				switch (length-location)
				{
					case 3:
						good_string=good_string.Insert(location+1,"0");
						break;
					case 2:
						good_string=good_string.Insert(location+1,"00");
						break;
					case 1:
						good_string=good_string;
						break;
				}
			}
		}
		else
		{
			good_string="";
		}
		return (good_string); }

/// <summary>
///   The <see cref="fix_ip(string)"/> static method is used to strips the leading zero from the Class-C portion of IP (for display)
/// </summary>
/// <param name="x">
///   A <see cref="System.String"/> containing the laden string.
/// </param>
/// <returns> 
///   A <see cref="System.String"/> containing the shortened string.
/// </returns>
/// <remarks>
///    
/// </remarks>
	public static string fix_ip(string x)
	{
		string good_string;
		good_string = x.Trim();
		good_string = good_string.Replace(".00", ".");
		good_string = good_string.Replace(".0", ".");
		return (good_string); }

/// <summary>
///   The <see cref="isNumber(string)"/> static method is used to determine if a string is also a number using regular expressions.
/// </summary>
/// <param name="text">
///   A <see cref="System.String"/> containing the laden string.
/// </param>
/// <returns> 
///   A <see cref="System.Boolean"/> indicating if the passed string is a number(TRUE) or not(FALSE).
/// </returns>
/// <remarks>
///    
/// </remarks>
	public static bool isNumber(string text)
	{
		Regex regex = new Regex(@"^[-+]?[0-9]*\.?[0-9]+$");
		return regex.IsMatch(text);
	}

/// <summary>
///   The <see cref="emptyDataset(DataSet)"/> static method is used to determine if a DataSet is empty.
/// </summary>
/// <param name="dat">
///   A <see cref="System.Data.Dataset"/> to be checked for empty.
/// </param>
/// <returns> 
///   A <see cref="System.Boolean"/> indicating if the passed <see cref="System.Data.Dataset"/> is a empty(TRUE) or not(FALSE).
/// </returns>
/// <remarks>
///    
/// </remarks>
	public static bool emptyDataset(DataSet dat)
	{
		bool status=true;
		if (dat!=null)
		{
			if (dat.Tables.Count > 0)
			{
				status=false;
				if (dat.Tables[0].Rows.Count > 0)
				{
					status=false;
				}
			}
		}

		return status;
	}

//RE-DO ALL EMAILING FUNCTIONS!!!
/*	public static void sendServerNotice(string hostname, string fromUser)
	{
		string lanIp, sanAttached, pubVlan="", svcVlan="";
		string mailSubject="", mailGreeting="", mailBody="", mailClose="", mailCc="", mailTo="", portInfo="";
		string sql,sql1,sql2="",sql3="",sqlMm;
		DataSet dat,dat1,dat2=null,dat3=null,datMm;

		sqlMm="SELECT email FROM users WHERE userClass='99'";
		datMm=readDb(sqlMm);
		foreach (DataTable dt in datMm.Tables)
		{
			foreach (DataRow dr in dt.Rows)
			{
				mailCc = mailCc+","+Decrypt(dr["email"].ToString());
			}
		}

		sqlMm="SELECT email FROM users WHERE userClass='1'";
		datMm=readDb(sqlMm);
		foreach (DataTable dt in datMm.Tables)
		{
			foreach (DataRow dr in dt.Rows)
			{
				mailTo = mailTo+","+Decrypt(dr["email"].ToString());
			}
		}


		sql="SELECT * FROM servers INNER JOIN rackspace ON servers.rackspaceId=rackspace.rackspaceId WHERE serverName='"+hostname+"'";
		dat=readDb(sql);
		if (dat!=null)
		{
			lanIp="";
			sanAttached="";
			if (fix_ip(dat.Tables[0].Rows[0]["serverLanIp"].ToString())=="") lanIp="Unassigned, IP Request sent.";
			if (dat.Tables[0].Rows[0]["sanAttached"].ToString()=="0") 
			{
				sanAttached = "No";
			}
			else 
			{
				sanAttached = "Yes";
			}

			switch (dat.Tables[0].Rows[0]["serverPubVlan"].ToString())
			{
			case "subnetPrpDb":
				pubVlan="129";
				break;
			case "subnetPrp":
				pubVlan="130";
				break;
			case "subnetMgt":
				pubVlan="131";
				break;
			case "subnetPheInf":
				pubVlan="133";
				break;
			case "subnetPheRes":
				pubVlan="134";
				break;
			case "subnetNetDmz":
				pubVlan="135";
				break;
			case "subnetPheDmz":
				pubVlan="136";
				break;
			case "subnetPrpDmz":
				pubVlan="137";
				break;
			case "subnetUtilDmz":
				pubVlan="138";
				break;

			}
			switch (dat.Tables[0].Rows[0]["serverOs"].ToString())
			{
			case "Linux":
				svcVlan="190";
				break;
			case "Windows":
				svcVlan="191";
				break;
			case "AIX":
				svcVlan="192";
				break;
			}

			int rackspace=Convert.ToInt32(dat.Tables[0].Rows[0]["rack"].ToString());
			if (dat.Tables[0].Rows[0]["bc"].ToString()!="")
			{
				if (dat.Tables[0].Rows[0]["bc"].ToString()=="14" || dat.Tables[0].Rows[0]["bc"].ToString()=="15")
				{
					sql1="SELECT rackspaceId FROM rackspace WHERE rack='"+dat.Tables[0].Rows[0]["rack"].ToString()+"' AND bc='"+dat.Tables[0].Rows[0]["bc"].ToString()+"' AND slot IN('"+dat.Tables[0].Rows[0]["slot"].ToString()+"','00') AND class<>'Virtual'";
				}
				else
				{
					sql1="SELECT rackspaceId FROM rackspace WHERE rack='"+dat.Tables[0].Rows[0]["rack"].ToString()+"' AND bc='"+dat.Tables[0].Rows[0]["bc"].ToString()+"' AND slot='00' AND class<>'Virtual'";
				}			
			}
			else
			{
				sql1="SELECT rackspaceId FROM rackspace WHERE rack='"+dat.Tables[0].Rows[0]["rack"].ToString()+"' AND slot='"+dat.Tables[0].Rows[0]["slot"].ToString()+"' AND class<>'Virtual'";
			}
			dat1=readDb(sql1);
//			Response.Write(sql1);
			string cableSrc="";
			if (dat1!=null)
			{
				if (dat.Tables[0].Rows[0]["bc"].ToString()=="14" || dat.Tables[0].Rows[0]["bc"].ToString()=="15")
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
				else
				{
					cableSrc="cabledTo="+dat1.Tables[0].Rows[0]["rackspaceId"].ToString()+"";
				}	
			}
//			string accessSwitch="accessA";
//			if(rackspace % 2 ==0) accessSwitch="accessB";
			sql2="SELECT * FROM accessA WHERE "+cableSrc;
//			Response.Write(sql2);
			dat2=readDb(sql2);
			sql3="SELECT * FROM accessB WHERE "+cableSrc;
//			Response.Write(sql3);
			dat3=readDb(sql3);
			string indicateBc="";
			if (dat.Tables[0].Rows[0]["bc"].ToString()!="")
			{
				indicateBc="BC"+dat.Tables[0].Rows[0]["bc"].ToString();
			} 
			if (dat2!=null)
			{
				foreach (DataTable dtt in dat2.Tables)
				{
					foreach (DataRow drr in dtt.Rows)
					{
						portInfo=portInfo+"    "+drr["comment"].ToString()+": Access A, Slot "+drr["slot"].ToString()+", Port "+drr["portNum"].ToString()+"\r\n";
					}
				} 
			}
			portInfo = portInfo +"\r\n";
			if (dat3!=null)
			{
				foreach (DataTable dtt in dat3.Tables)
				{
					foreach (DataRow drr in dtt.Rows)
					{
						portInfo=portInfo+"    "+drr["comment"].ToString()+": Access B, Slot "+drr["slot"].ToString()+", Port "+drr["portNum"].ToString()+"\r\n";
					}
				} 
			}
			if (dat3==null && dat2==null)
			{
				portInfo="No cabled connections found.\r\n";
			}


			mailBody = "The following new server has been provisioned in the PHE Environment:\r\n\r\nHostname: "+dat.Tables[0].Rows[0]["serverName"].ToString()+
																								"\r\nServer OS: "+dat.Tables[0].Rows[0]["serverOs"].ToString()+
																							    "\r\npublic static IP: "+lanIp+
																								"\r\nManagement IP: "+fix_ip(dat.Tables[0].Rows[0]["serverRsaIp"].ToString())+
																								"\r\nServer Purpose: "+dat.Tables[0].Rows[0]["serverPurpose"].ToString()+
																								"\r\nSAN Attached: "+sanAttached+
																								"\r\nServer Class: "+dat.Tables[0].Rows[0]["class"].ToString()+
																								"\r\nServer Model: "+dat.Tables[0].Rows[0]["model"].ToString()+
																								"\r\nServer Serial: "+dat.Tables[0].Rows[0]["serial"].ToString()+
																							    "\r\n-------------------------------------------------------------------------------"+
																								"\r\npublic static Vlan: "+pubVlan+														
																								"\r\nService Vlan: "+svcVlan+
																								"\r\nServer Rack: "+dat.Tables[0].Rows[0]["rack"].ToString()+
																								"\r\nServer BC: "+dat.Tables[0].Rows[0]["bc"].ToString()+
																								"\r\nServer Slot: "+dat.Tables[0].Rows[0]["slot"].ToString()+
																								"\r\nSwitch Porting:\r\n"+portInfo+
																								"\r\n-------------------------------------------------------------------------------"+
																							    "\r\nTo: " +mailTo+
																							    "\r\nCc: " +mailCc+
																								"\r\n\r\n";
		}
		MailMessage mm;
//		MailAttachment ma; --CLEANUP 5/22/12
		mailSubject=shortSysName+": New server "+hostname+" has been provisioned.";
		mm= new MailMessage();
		mm.From=System.Configuration.ConfigurationManager.AppSettings["mailerFrom"].ToString();
//		mm.Bcc="adminuser@home.knightschronicle.com";
//		mm.To="stduser@home.knightschronicle.com";
//		mm.Cc=mailCc;
		mm.To=mailTo;
		mm.To="chrisknight@fs.fed.us";
		mm.Subject=mailSubject;
		mm.BodyFormat=MailFormat.Text;
		mm.Priority=MailPriority.Normal;
		mailGreeting = "PHE/PRP Team,\r\n\r\n";
		System.IO.StreamReader reader = System.IO.File.OpenText(Server.MapPath("mailClose.txt"));
		mailClose = reader.ReadToEnd();
		System.IO.StreamReader reader = System.IO.File.OpenText(-filepath-);
		string mailbody = reader.ReadToEnd();
		mm.Body=mailGreeting + mailBody + mailClose;
		SmtpMail.SmtpServer=mailServer;
		SmtpMail.Send(mm);
		mailBody="";
		mm=null;
//		Response.Write("<script language='JavaScript'>window.alert('Server Provision Notice Sent!')"+"<"+"/script>");
	}

	public static void sendIpRequest(string hostname, string comment, string fromUser)
	{
		string lanIp, sanAttached, pubVlan="", svcVlan="", url="";
		string mailSubject="", mailGreeting="", mailBody="", mailClose="", mailCc="", mailTo="", mailFrom="", portInfo="";
		string sql,sql1,sql2="",sql3="",sqlMm;
		DataSet dat,dat1,dat2=null,dat3=null,datMm;

		sqlMm="SELECT email FROM users WHERE userId='"+Encrypt(fromUser)+"'";
		datMm=readDb(sqlMm);
		foreach (DataTable dt in datMm.Tables)
		{
			foreach (DataRow dr in dt.Rows)
			{
				mailTo = Decrypt(dr["email"].ToString());
			}
		}

		sqlMm="SELECT email FROM contacts WHERE userClass='99'";
		datMm=readDb(sqlMm);
		foreach (DataTable dt in datMm.Tables)
		{
			foreach (DataRow dr in dt.Rows)
			{
				mailCc = mailCc+","+Decrypt(dr["email"].ToString());
			}
		}

		sqlMm="SELECT email FROM contacts WHERE userClass='3'";
		datMm=readDb(sqlMm);
		foreach (DataTable dt in datMm.Tables)
		{
			foreach (DataRow dr in dt.Rows)
			{
				mailTo = mailTo+","+Decrypt(dr["email"].ToString());
			}
		} 


		sql="SELECT * FROM servers INNER JOIN rackspace ON servers.rackspaceId=rackspace.rackspaceId WHERE serverName='"+hostname+"'";
		dat=readDb(sql);
		if (dat!=null)
		{
			sanAttached="";
			if (dat.Tables[0].Rows[0]["sanAttached"].ToString()=="0") 
			{
				sanAttached = "No";
			}
			else 
			{
				sanAttached = "Yes";
			}

			switch (dat.Tables[0].Rows[0]["serverPubVlan"].ToString())
			{
			case "subnetPrpDb":
				pubVlan="129";
				break;
			case "subnetPrp":
				pubVlan="130";
				break;
			case "subnetMgt":
				pubVlan="131";
				break;
			case "subnetPheInf":
				pubVlan="133";
				break;
			case "subnetPheRes":
				pubVlan="134";
				break;
			case "subnetNetDmz":
				pubVlan="135";
				break;
			case "subnetPheDmz":
				pubVlan="136";
				break;
			case "subnetPrpDmz":
				pubVlan="137";
				break;
			case "subnetUtilDmz":
				pubVlan="138";
				break;

			}
			switch (dat.Tables[0].Rows[0]["serverOs"].ToString())
			{
			case "Linux":
				svcVlan="190";
				break;
			case "Windows":
				svcVlan="191";
				break;
			case "AIX":
				svcVlan="192";
				break;
			}

			int rackspace=Convert.ToInt32(dat.Tables[0].Rows[0]["rack"].ToString());
			if (dat.Tables[0].Rows[0]["bc"].ToString()!="")
			{
				if (dat.Tables[0].Rows[0]["bc"].ToString()=="14" || dat.Tables[0].Rows[0]["bc"].ToString()=="15")
				{
					sql1="SELECT rackspaceId FROM rackspace WHERE rack='"+dat.Tables[0].Rows[0]["rack"].ToString()+"' AND bc='"+dat.Tables[0].Rows[0]["bc"].ToString()+"' AND slot IN('"+dat.Tables[0].Rows[0]["slot"].ToString()+"','00') AND class<>'Virtual'";
				}
				else
				{
					sql1="SELECT rackspaceId FROM rackspace WHERE rack='"+dat.Tables[0].Rows[0]["rack"].ToString()+"' AND bc='"+dat.Tables[0].Rows[0]["bc"].ToString()+"' AND slot='00' AND class<>'Virtual'";
				}			
			}
			else
			{
				sql1="SELECT rackspaceId FROM rackspace WHERE rack='"+dat.Tables[0].Rows[0]["rack"].ToString()+"' AND slot='"+dat.Tables[0].Rows[0]["slot"].ToString()+"' AND class<>'Virtual'";
			}
			dat1=readDb(sql1);
//			Response.Write(sql1);
			string cableSrc="";
			if (dat1!=null)
			{
				if (dat.Tables[0].Rows[0]["bc"].ToString()=="14" || dat.Tables[0].Rows[0]["bc"].ToString()=="15")
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
				else
				{
					cableSrc="cabledTo="+dat1.Tables[0].Rows[0]["rackspaceId"].ToString()+"";
				}	
			}
//			string accessSwitch="accessA";
//			if(rackspace % 2 ==0) accessSwitch="accessB";
			sql2="SELECT * FROM accessA WHERE "+cableSrc;
//			Response.Write(sql2);
			dat2=readDb(sql2);
			sql3="SELECT * FROM accessB WHERE "+cableSrc;
//			Response.Write(sql3);
			dat3=readDb(sql3);
			string indicateBc="";
			if (dat.Tables[0].Rows[0]["bc"].ToString()!="")
			{
				indicateBc="BC"+dat.Tables[0].Rows[0]["bc"].ToString();
			} 
			if (dat2!=null)
			{
				foreach (DataTable dtt in dat2.Tables)
				{
					foreach (DataRow drr in dtt.Rows)
					{
						portInfo=portInfo+"    "+drr["comment"].ToString()+": Access A, Slot "+drr["slot"].ToString()+", Port "+drr["portNum"].ToString()+"\r\n";
					}
				} 
			}
			portInfo = portInfo +"\r\n";
			if (dat3!=null)
			{
				foreach (DataTable dtt in dat3.Tables)
				{
					foreach (DataRow drr in dtt.Rows)
					{
						portInfo=portInfo+"    "+drr["comment"].ToString()+": Access B, Slot "+drr["slot"].ToString()+", Port "+drr["portNum"].ToString()+"\r\n";
					}
				} 
			}
			if (dat3==null && dat2==null)
			{
				portInfo="No cabled connections found.\r\n";
			}

			if (dat.Tables[0].Rows[0]["bc"].ToString()=="")
			{
				url=System.Configuration.ConfigurationManager.AppSettings["sysUrl"]+"adminServers.aspx?rack="+dat.Tables[0].Rows[0]["rack"].ToString();
			}
			else
			{
				url=System.Configuration.ConfigurationManager.AppSettings["sysUrl"]+"adminServers.aspx?bc="+dat.Tables[0].Rows[0]["bc"].ToString();
			}

			mailBody = "This information can be useful for getting an IP addressed for your server in the ABQDC Environment:\r\n"+
																							"\r\nComment: "+comment+
																							"\r\n"+
																							"\r\nHostname: "+dat.Tables[0].Rows[0]["serverName"].ToString()+
																						    "\r\nServer OS: "+dat.Tables[0].Rows[0]["serverOs"].ToString()+
																							"\r\nServer Purpose: "+dat.Tables[0].Rows[0]["serverPurpose"].ToString()+
																							"\r\nSAN Attached: "+sanAttached+
																							"\r\n-------------------------------------------------------------------------------"+
																							"\r\npublic static Vlan: "+pubVlan+
																							"\r\nService Vlan: "+svcVlan+
																							"\r\nServer Rack: "+dat.Tables[0].Rows[0]["rack"].ToString()+
																							"\r\nServer BC: "+dat.Tables[0].Rows[0]["bc"].ToString()+
																							"\r\nServer Slot: "+dat.Tables[0].Rows[0]["slot"].ToString()+
																							"\r\nSwitch Porting:\r\n"+portInfo+
																							"\r\n-------------------------------------------------------------------------------"+
																							"\r\n"+
																							"\r\nTo: " +mailTo+
																							"\r\nCc: " +mailCc+
																							"\r\n\r\n Please go to "+url+" and document the public static IP assigned by NOC for this server.\r\n\r\n\r\n";
		}
		MailMessage mm;
		MailAttachment ma;
		mm= new MailMessage();
//		mm.From=mailFrom;
		mm.From=System.Configuration.ConfigurationManager.AppSettings["mailerFrom"].ToString();
//		mm.Bcc="adminuser@home.knightschronicle.com";
//		mm.To="stduser@home.knightschronicle.com";
//		mm.Cc=mailCc;
		mm.To=mailTo;
		mm.To="chrisknight@fs.fed.us";
		mm.Subject=shortSysName+": IP Request - "+hostname+"";
		mm.BodyFormat=MailFormat.Text;
		mm.Priority=MailPriority.Normal;
		mailGreeting = "ABQDC Network Team,\r\n\r\n";
		System.IO.StreamReader reader = System.IO.File.OpenText(Server.MapPath("mailClose.txt"));
		mailClose = reader.ReadToEnd();
		System.IO.StreamReader reader = System.IO.File.OpenText(-filepath-);
		string mailbody = reader.ReadToEnd(); 
		mm.Body=mailGreeting + mailBody + mailClose;
		SmtpMail.SmtpServer=mailServer;
		SmtpMail.Send(mm);
		mailBody="";
		mm=null;
//		Response.Write("<script language='JavaScript'>window.alert('IP Request Sent!')"+"<"+"/script>");
	}

	public static void sendIpProvisionNotice(string hostname, string comment, string fromUser)
	{
		string lanIp, sanAttached, pubVlan="", svcVlan="";
		string mailSubject="", mailGreeting="", mailBody="", mailClose="", mailCc="", mailTo="", mailFrom="", portInfo="";
		string sql,sql1,sql2="",sql3="",sqlMm;
		DataSet dat,dat1,dat2=null,dat3=null,datMm;

		sqlMm="SELECT email FROM users WHERE userId='"+Encrypt(fromUser)+"'";
		datMm=readDb(sqlMm);
		foreach (DataTable dt in datMm.Tables)
		{
			foreach (DataRow dr in dt.Rows)
			{
				mailTo = Decrypt(dr["email"].ToString());
			}
		}

		sqlMm="SELECT email FROM contacts WHERE userClass='99'";
		datMm=readDb(sqlMm);
		foreach (DataTable dt in datMm.Tables)
		{
			foreach (DataRow dr in dt.Rows)
			{
				mailCc = mailCc+","+Decrypt(dr["email"].ToString());
			}
		}

		sqlMm="SELECT email FROM contacts WHERE userClass='3'";
		datMm=readDb(sqlMm);
		foreach (DataTable dt in datMm.Tables)
		{
			foreach (DataRow dr in dt.Rows)
			{
				mailTo = mailTo+","+Decrypt(dr["email"].ToString());
			}
		} 

		sql="SELECT * FROM servers INNER JOIN rackspace ON servers.rackspaceId=rackspace.rackspaceId WHERE serverName='"+hostname+"'";
		dat=readDb(sql);
		if (dat!=null)
		{
			switch (dat.Tables[0].Rows[0]["serverPubVlan"].ToString())
			{
			case "subnetPrpDb":
				pubVlan="129";
				break;
			case "subnetPrp":
				pubVlan="130";
				break;
			case "subnetMgt":
				pubVlan="131";
				break;
			case "subnetPheInf":
				pubVlan="133";
				break;
			case "subnetPheRes":
				pubVlan="134";
				break;
			case "subnetNetDmz":
				pubVlan="135";
				break;
			case "subnetPheDmz":
				pubVlan="136";
				break;
			case "subnetPrpDmz":
				pubVlan="137";
				break;
			case "subnetUtilDmz":
				pubVlan="138";
				break;

			}
			switch (dat.Tables[0].Rows[0]["serverOs"].ToString())
			{
			case "Linux":
				svcVlan="190";
				break;
			case "Windows":
				svcVlan="191";
				break;
			case "AIX":
				svcVlan="192";
				break;
			}

			int rackspace=Convert.ToInt32(dat.Tables[0].Rows[0]["rack"].ToString());
			if (dat.Tables[0].Rows[0]["bc"].ToString()!="")
			{
				if (dat.Tables[0].Rows[0]["bc"].ToString()=="14" || dat.Tables[0].Rows[0]["bc"].ToString()=="15")
				{
					sql1="SELECT rackspaceId FROM rackspace WHERE rack='"+dat.Tables[0].Rows[0]["rack"].ToString()+"' AND bc='"+dat.Tables[0].Rows[0]["bc"].ToString()+"' AND slot IN('"+dat.Tables[0].Rows[0]["slot"].ToString()+"','00') AND class<>'Virtual'";
				}
				else
				{
					sql1="SELECT rackspaceId FROM rackspace WHERE rack='"+dat.Tables[0].Rows[0]["rack"].ToString()+"' AND bc='"+dat.Tables[0].Rows[0]["bc"].ToString()+"' AND slot='00' AND class<>'Virtual'";
				}			
			}
			else
			{
				sql1="SELECT rackspaceId FROM rackspace WHERE rack='"+dat.Tables[0].Rows[0]["rack"].ToString()+"' AND slot='"+dat.Tables[0].Rows[0]["slot"].ToString()+"' AND class<>'Virtual'";
			}
			dat1=readDb(sql1);
//			Response.Write(sql1);
			string cableSrc="";
			if (dat1!=null)
			{
				if (dat.Tables[0].Rows[0]["bc"].ToString()=="14" || dat.Tables[0].Rows[0]["bc"].ToString()=="15")
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
				else
				{
					cableSrc="cabledTo="+dat1.Tables[0].Rows[0]["rackspaceId"].ToString()+"";
				}	
			}
//			string accessSwitch="accessA";
//			if(rackspace % 2 ==0) accessSwitch="accessB";
			sql2="SELECT * FROM accessA WHERE "+cableSrc;
//			Response.Write(sql2);
			dat2=readDb(sql2);
			sql3="SELECT * FROM accessB WHERE "+cableSrc;
//			Response.Write(sql3);
			dat3=readDb(sql3);
			string indicateBc="";
			if (dat.Tables[0].Rows[0]["bc"].ToString()!="")
			{
				indicateBc="BC"+dat.Tables[0].Rows[0]["bc"].ToString();
			} 
			if (dat2!=null)
			{
				foreach (DataTable dtt in dat2.Tables)
				{
					foreach (DataRow drr in dtt.Rows)
					{
						portInfo=portInfo+"    "+drr["comment"].ToString()+": Access A, Slot "+drr["slot"].ToString()+", Port "+drr["portNum"].ToString()+"\r\n";
					}
				} 
			}
			portInfo = portInfo +"\r\n";
			if (dat3!=null)
			{
				foreach (DataTable dtt in dat3.Tables)
				{
					foreach (DataRow drr in dtt.Rows)
					{
						portInfo=portInfo+"    "+drr["comment"].ToString()+": Access B, Slot "+drr["slot"].ToString()+", Port "+drr["portNum"].ToString()+"\r\n";
					}
				} 
			}
			if (dat3==null && dat2==null)
			{
				portInfo="No cabled connections found.\r\n";
			}
			mailBody = "A public static IP address has been provisioned for "+hostname+".\r\n"+
																				 "\r\nComment: "+comment+
																				 "\r\n"+
																				 "\r\nHostname: "+dat.Tables[0].Rows[0]["serverName"].ToString()+
																			     "\r\npublic static IP: "+fix_ip(dat.Tables[0].Rows[0]["serverLanIp"].ToString())+
																			     "\r\nServer Purpose: "+dat.Tables[0].Rows[0]["serverPurpose"].ToString()+
																				 "\r\n-------------------------------------------------------------------------------"+
																				 "\r\npublic static Vlan: "+pubVlan+
     																			 "\r\nService Vlan: "+svcVlan+
																				 "\r\nServer Rack: "+dat.Tables[0].Rows[0]["rack"].ToString()+
																				 "\r\nServer BC: "+dat.Tables[0].Rows[0]["bc"].ToString()+
																				 "\r\nServer Slot: "+dat.Tables[0].Rows[0]["slot"].ToString()+
																				 "\r\nSwitch Porting:\r\n"+portInfo+
																				 "\r\n-------------------------------------------------------------------------------"+
																				 "\r\n"+
																				 "\r\nTo: " +mailTo+
																				 "\r\nCc: " +mailCc+
																				 "\r\n\r\n\r\n\r\n\r\n";

		}

		MailMessage mm;
		MailAttachment ma;
		mm= new MailMessage();
		mm.From=System.Configuration.ConfigurationManager.AppSettings["mailerFrom"].ToString();
//		mm.Bcc="adminuser@home.knightschronicle.com";
//		mm.To="stduser@home.knightschronicle.com";
//		mm.Cc=mailCc;
		mm.To=mailTo;
		mm.To="chrisknight@fs.fed.us";
		mm.Subject=shortSysName+": public static IP Address Provisioned for "+hostname;
		mm.BodyFormat=MailFormat.Text;
		mm.Priority=MailPriority.Normal;
		mailGreeting = "PHE Team,\r\n\r\n";
		System.IO.StreamReader reader = System.IO.File.OpenText(Server.MapPath("mailClose.txt"));
		mailClose = reader.ReadToEnd();
		System.IO.StreamReader reader = System.IO.File.OpenText(-filepath-);
		string mailbody = reader.ReadToEnd();
		mm.Body=mailGreeting + mailBody + mailClose;
		SmtpMail.SmtpServer=mailServer;
		SmtpMail.Send(mm);
		mm=null;
		Response.Write("<script language='JavaScript'>window.alert('IP Provision Notice Sent!')"+"<"+"/script>");
	}

	public static void sendIpReservationNotice(string vlan, string ipAddr, string fromUser)
	{
		string lanIp, sanAttached;
		string sql,sqlMm;
		string reservedStatus;
		string mailSubject="", mailGreeting="", mailBody="", mailClose="", mailCc="", mailTo="";
		DataSet dat,datMm;

		sqlMm="SELECT email FROM users WHERE userId='"+Encrypt(fromUser)+"'";
		datMm=readDb(sqlMm);
		foreach (DataTable dt in datMm.Tables)
		{
			foreach (DataRow dr in dt.Rows)
			{
				mailTo = Decrypt(dr["email"].ToString());
			}
		}

		sqlMm="SELECT email FROM contacts WHERE userClass='99'";
		datMm=readDb(sqlMm);
		foreach (DataTable dt in datMm.Tables)
		{
			foreach (DataRow dr in dt.Rows)
			{
				mailCc = mailCc+","+Decrypt(dr["email"].ToString());
			}
		}

		sqlMm="SELECT email FROM contacts WHERE userClass='3'";
		datMm=readDb(sqlMm);
		foreach (DataTable dt in datMm.Tables)
		{
			foreach (DataRow dr in dt.Rows)
			{
				mailTo = mailTo+","+Decrypt(dr["email"].ToString());
			}
		} 

		sql = "SELECT * FROM "+vlan+" WHERE ipAddr='"+ipAddr+"'";
		dat=readDb(sql);
		MailMessage mm;
		MailAttachment ma;
		mm= new MailMessage();
		mm.From=System.Configuration.ConfigurationManager.AppSettings["mailerFrom"].ToString();
//		mm.Bcc="adminuser@home.knightschronicle.com";
//		mm.To="stduser@home.knightschronicle.com";
//		mm.Cc=mailCc;
		mm.To=mailTo;
		mm.To="chrisknight@fs.fed.us";
		mm.Subject=shortSysName+": IP Address Reservation Change for "+ipAddr;
		mm.BodyFormat=MailFormat.Text;
		mm.Priority=MailPriority.Normal;
		mailGreeting = "PHE Network Team,\r\n\r\n";
		if (dat.Tables[0].Rows[0]["ipAddr"].ToString()=="1")
		{
			reservedStatus = "Yes";
		}
		else
		{
			reservedStatus = "No";
		}

		mailBody = "An IP address reservation change has been made for "+ipAddr+".\r\n\r\nIP: "+dat.Tables[0].Rows[0]["ipAddr"].ToString()+
																			     "\r\nReserved: "+reservedStatus+"\r\n\r\n";
		System.IO.StreamReader reader = System.IO.File.OpenText(Server.MapPath("mailClose.txt"));
		mailClose = reader.ReadToEnd();
		System.IO.StreamReader reader = System.IO.File.OpenText(-filepath-);
		string mailbody = reader.ReadToEnd();
		mm.Body=mailGreeting + mailBody + mailClose;
		SmtpMail.SmtpServer=mailServer;
		SmtpMail.Send(mm);
		mm=null;
		Response.Write("<script language='JavaScript'>window.alert('IP Reservation Change Notice Sent!')"+"<"+"/script>");
	}

	public static void sendDNSNotice(string hostname, string comment, string fromUser)
	{
		string lanIp, sanAttached;
		string sql,sqlMm;
		string reservedStatus;
		string mailSubject="", mailGreeting="", mailBody="", mailClose="", mailCc="", mailTo="";
		DataSet dat,datMm;

		sqlMm="SELECT email FROM users WHERE userId='"+Encrypt(fromUser)+"'";
		datMm=readDb(sqlMm);
		foreach (DataTable dt in datMm.Tables)
		{
			foreach (DataRow dr in dt.Rows)
			{
				mailTo = Decrypt(dr["email"].ToString());
			}
		}

		sqlMm="SELECT email FROM contacts WHERE userClass='99'";
		datMm=readDb(sqlMm);
		foreach (DataTable dt in datMm.Tables)
		{
			foreach (DataRow dr in dt.Rows)
			{
				mailCc = mailCc+","+Decrypt(dr["email"].ToString());
			}
		}

		sqlMm="SELECT email FROM contacts WHERE userClass='3'";
		datMm=readDb(sqlMm);
		foreach (DataTable dt in datMm.Tables)
		{
			foreach (DataRow dr in dt.Rows)
			{
				mailTo = mailTo+","+Decrypt(dr["email"].ToString());
			}
		} 

		sql = "SELECT serverName, serverLanIP FROM servers WHERE serverName='"+hostname+"'";
		dat=readDb(sql);
		MailMessage mm;
		MailAttachment ma;
		mm= new MailMessage();
		mm.From=System.Configuration.ConfigurationManager.AppSettings["mailerFrom"].ToString();
//		mm.Bcc="adminuser@home.knightschronicle.com";
//		mm.To="stduser@home.knightschronicle.com";
//		mm.Cc=mailCc;
		mm.To=mailTo;
		mm.To="chrisknight@fs.fed.us";
		mm.Subject=shortSysName+": Server DNS Registration for "+hostname;
		mm.BodyFormat=MailFormat.Text;
		mm.Priority=MailPriority.Normal;
		mailGreeting = "PHE DNS Team,\r\n\r\n";


		mailBody = "An IP address has been provisioned for the the following server: "+hostname+".\r\n\r\n"+     
																		"Hostname: "+dat.Tables[0].Rows[0]["serverName"].ToString()+"\r\n"+     
																		"IP: "+fix_ip(dat.Tables[0].Rows[0]["serverLanIp"].ToString())+"\r\n\r\n"+
																		"Please update DNS records.\r\n"+
															            "\r\n-------------------------------------------------------------------------------"+
																		"\r\nTo: " +mailTo+
																		"\r\nCc: " +mailCc+"\r\n\r\n\r\n";
		System.IO.StreamReader reader = System.IO.File.OpenText(Server.MapPath("mailClose.txt"));
		mailClose = reader.ReadToEnd();
		System.IO.StreamReader reader = System.IO.File.OpenText(-filepath-);
		string mailbody = reader.ReadToEnd();
		mm.Body=mailGreeting + mailBody + mailClose;
		SmtpMail.SmtpServer=mailServer;
		SmtpMail.Send(mm);
		mm=null;
		Response.Write("<script language='JavaScript'>window.alert('DNS Registration Notice Sent!')"+"<"+"/script>");
	}

	public static void sendOSInstallNotice(string hostname, string comment, string fromUser)
	{
		string keyword="", sanAttached, pubVlan="", svcVlan="";
		string sql,sql1,sql2,sqlMm;
		string mailSubject="", mailGreeting="", mailBody="", mailClose="", mailCc="", mailTo="";
		DataSet dat,dat1,dat2,datMm;

		sqlMm="SELECT email FROM users WHERE userId='"+Encrypt(fromUser)+"'";
		datMm=readDb(sqlMm);
		foreach (DataTable dt in datMm.Tables)
		{
			foreach (DataRow dr in dt.Rows)
			{
				mailTo = Decrypt(dr["email"].ToString());
			}
		}

		sqlMm="SELECT email FROM contacts WHERE userClass='99'";
		datMm=readDb(sqlMm);
		foreach (DataTable dt in datMm.Tables)
		{
			foreach (DataRow dr in dt.Rows)
			{
				mailCc = mailCc+","+Decrypt(dr["email"].ToString());
			}
		}

		sqlMm="SELECT email FROM contacts WHERE userClass='3'";
		datMm=readDb(sqlMm);
		foreach (DataTable dt in datMm.Tables)
		{
			foreach (DataRow dr in dt.Rows)
			{
				mailTo = mailTo+","+Decrypt(dr["email"].ToString());
			}
		} 

		sql="SELECT * FROM servers INNER JOIN rackspace ON servers.rackspaceId=rackspace.rackspaceId WHERE serverName='"+hostname+"'";
		dat=readDb(sql);
		if (dat!=null)
		{
			sanAttached="";

			if (dat.Tables[0].Rows[0]["sanAttached"].ToString()=="0") 
			{
				sanAttached = "No";
			}
			else 
			{
				sanAttached = "Yes";
			}

			int rackspace=Convert.ToInt32(dat.Tables[0].Rows[0]["rack"].ToString());

			mailBody = "The following new server has been provisioned in the PHE Environment. Please proceed with OS Installation.\r\n\r\n"+
																								"\r\nComment: "+comment+
																								"\r\n"+
																								"\r\nHostname: "+dat.Tables[0].Rows[0]["serverName"].ToString()+
																								"\r\nOS Build To Be Installed: "+dat.Tables[0].Rows[0]["serverOsBuild"].ToString()+
																							    "\r\npublic static IP: "+fix_ip(dat.Tables[0].Rows[0]["serverLanIp"].ToString())+
																								"\r\nManagement IP: "+fix_ip(dat.Tables[0].Rows[0]["serverRsaIp"].ToString())+
																								"\r\nServer Purpose: "+dat.Tables[0].Rows[0]["serverPurpose"].ToString()+
																								"\r\nSAN Attached: "+sanAttached+
																								"\r\nServer Class: "+dat.Tables[0].Rows[0]["class"].ToString()+
																								"\r\nServer Model: "+dat.Tables[0].Rows[0]["model"].ToString()+
																								"\r\nServer Serial: "+dat.Tables[0].Rows[0]["serial"].ToString()+
																							    "\r\n-------------------------------------------------------------------------------"+
																								"\r\nServer Rack: "+dat.Tables[0].Rows[0]["rack"].ToString()+
																								"\r\nServer BC: "+dat.Tables[0].Rows[0]["bc"].ToString()+
																								"\r\nServer Slot: "+dat.Tables[0].Rows[0]["slot"].ToString()+
																								"\r\n-------------------------------------------------------------------------------"+
																							    "\r\nTo: " +mailTo+
																							    "\r\nCc: " +mailCc+
																								"\r\n\r\n";
		}
		
		switch (dat.Tables[0].Rows[0]["serverOs"].ToString())
		{
			case "Linux":
				keyword="xcat";
				break;
			case "Windows":
				keyword="director";
				break;
		}
		sqlMm="SELECT email FROM users WHERE userRole LIKE '%"+keyword+"%'";
		datMm=readDb(sqlMm);
		foreach (DataTable dt in datMm.Tables)
		{
			foreach (DataRow dr in dt.Rows)
			{
				mailTo = mailTo+","+Decrypt(dr["email"].ToString());
			}
		}
		MailMessage mm;
		MailAttachment ma;
		mm= new MailMessage();
		mm.From=System.Configuration.ConfigurationManager.AppSettings["mailerFrom"].ToString();
//		mm.Bcc="adminuser@home.knightschronicle.com";
//		mm.To="stduser@home.knightschronicle.com";
//		mm.Cc=mailCc;
		mm.To=mailTo;
		mm.To="chrisknight@fs.fed.us";
		mm.Subject=shortSysName+": OS Install Request for "+hostname;
		mm.BodyFormat=MailFormat.Text;
		mm.Priority=MailPriority.Normal;
		mailGreeting = "PHE/PRP Team,\r\n\r\n";
		System.IO.StreamReader reader = System.IO.File.OpenText(Server.MapPath("mailClose.txt"));
		mailClose = reader.ReadToEnd();
		System.IO.StreamReader reader = System.IO.File.OpenText(-filepath-);
		string mailbody = reader.ReadToEnd();
		mm.Body=mailGreeting + mailBody + mailClose;
		SmtpMail.SmtpServer=mailServer;
		SmtpMail.Send(mm);
		mailBody="";
		mm=null;
//		Response.Write("<script language='JavaScript'>window.alert('Server Provision Notice Sent!')"+"<"+"/script>");
	}

	public static void sendServerDeletionNotice(string hostname, string fromUser)
	{
		string lanIp, sanAttached;
		string sql,sqlMm;
		string reservedStatus;
		string mailSubject="", mailGreeting="", mailBody="", mailClose="", mailCc="", mailTo="";
		DataSet dat,datMm;

		sqlMm="SELECT email FROM users WHERE userId='"+Decrypt(fromUser)+"'";
		datMm=readDb(sqlMm);
		foreach (DataTable dt in datMm.Tables)
		{
			foreach (DataRow dr in dt.Rows)
			{
				mailTo = Decrypt(dr["email"].ToString());
			}
		}

		sqlMm="SELECT email FROM contacts WHERE userClass='99'";
		datMm=readDb(sqlMm);
		foreach (DataTable dt in datMm.Tables)
		{
			foreach (DataRow dr in dt.Rows)
			{
				mailCc = mailCc+","+Decrypt(dr["email"].ToString());
			}
		}

		sqlMm="SELECT email FROM contacts WHERE userClass='3'";
		datMm=readDb(sqlMm);
		foreach (DataTable dt in datMm.Tables)
		{
			foreach (DataRow dr in dt.Rows)
			{
				mailTo = mailTo+","+Decrypt(dr["email"].ToString());
			}
		} 

		sql = "SELECT serverName, serverLanIP FROM servers WHERE serverName='"+hostname+"'";
		dat=readDb(sql);
		MailMessage mm;
		MailAttachment ma;
		mm= new MailMessage();
		mm.From=System.Configuration.ConfigurationManager.AppSettings["mailerFrom"].ToString();
//		mm.Bcc="adminuser@home.knightschronicle.com";
//		mm.To="stduser@home.knightschronicle.com";
//		mm.Cc=mailCc;
		mm.To=mailTo;
		mm.To="chrisknight@fs.fed.us";
		mm.Subject=shortSysName+": Server Deletion Notice - "+hostname;
		mm.BodyFormat=MailFormat.Text;
		mm.Priority=MailPriority.Normal;
		mailGreeting = "PHE/PRP Team,\r\n\r\n";


		mailBody = "The following server has been deleted: \r\n\r\nHostname: "+hostname+"\r\n\r\nPlease remove any DNS records for this server and update your documentation.\r\n"+
																								"\r\n-------------------------------------------------------------------------------"+
																							    "\r\nTo: " +mailTo+
																							    "\r\nCc: " +mailCc+"\r\n\r\n\r\n";
		System.IO.StreamReader reader = System.IO.File.OpenText(Server.MapPath("mailClose.txt"));
		mailClose = reader.ReadToEnd();
		System.IO.StreamReader reader = System.IO.File.OpenText(-filepath-);
		string mailbody = reader.ReadToEnd();
		mm.Body=mailGreeting + mailBody + mailClose;
		SmtpMail.SmtpServer=mailServer;
		SmtpMail.Send(mm);
		mm=null;
		Response.Write("<script language='JavaScript'>window.alert('DNS Registration Notice Sent!')"+"<"+"/script>");
	}

	public static void sendMail(string mailTo, string mailSubject, string mailBody, string mailFrom)
	{
		MailMessage mm;
		MailAttachment ma;
		mm= new MailMessage();
		mm.From=mailFrom;
		mm.To=mailTo;
		mm.Subject=mailSubject;
		mm.BodyFormat=MailFormat.Html;
		mm.Priority=MailPriority.High;
		mm.Body="<P>USFS PHE Stuff</P>"+ mailBody;
		SmtpMail.SmtpServer=mailServer;
		SmtpMail.Send(mm);
		mm=null;
	}

	public static void sendMailAttach(string mailTo, string mailSubject, string mailBody, string mailFrom, string mailAttach)
	{
		MailMessage mm;
		MailAttachment ma;
		mm= new MailMessage();
		ma=new MailAttachment(mailAttach);
		mm.From="mailerdaemon@knightschronicle.com (Mailer Daemon)";
		mm.To=mailTo;
		mm.Subject=mailSubject;
		mm.BodyFormat=MailFormat.Html;
		mm.Priority=MailPriority.High;
		mm.Body="<P>USFS PHE Stuff!</P>"+ mailBody;
		mm.Attachments.Add(ma);
		SmtpMail.SmtpServer=mailServer;
		SmtpMail.Send(mm);
		mm=null; 
	} */

/// <summary>
///   The <see cref="CreateCSVFile(DataTable,string)"/> static void method is used to write a CSV (Excel) file from a DataTable.
/// </summary>
/// <param name="dt">
///   A <see cref="System.Data.DataTable"/> containing data to be exported.
/// </param>
/// <param name="strFilePath">
///   A <see cref="System.String"/> containing the full file path of the CSV file to be created.
/// </param>
/// <remarks>
///    
/// </remarks>
    public static void CreateCSVFile(DataTable dt, string strFilePath)
    {
        #region Export Grid to CSV
        // Create the CSV file to which grid data will be exported.
        StreamWriter sw = new StreamWriter(strFilePath, false);
        // First we will write the headers.
        //DataTable dt = m_dsProducts.Tables[0];
        int iColCount = dt.Columns.Count;
        for (int i = 0; i < iColCount; i++)
        {
            sw.Write(dt.Columns[i]);
            if (i < iColCount - 1)
            {
                sw.Write(",");
            }
        }
        sw.Write(sw.NewLine);
        // Now write all the rows.
        foreach (DataRow dr in dt.Rows)
        {
            for (int i = 0; i < iColCount; i++)
            {
                if (!Convert.IsDBNull(dr[i]))
                {
                    sw.Write(dr[i].ToString());
                }
                if (i < iColCount - 1)
                {
                    sw.Write(",");
                }
            }
            sw.Write(sw.NewLine);
        }
        sw.Close();
        #endregion
    }

/// <summary>
///   The <see cref="sortDS(DataSet,string,string)"/> static method is used to sort the records in a DataSet.
/// </summary>
/// <param name="dset">
///   A <see cref="System.Data.DataSet"/> containing data to be sorted.
/// </param>
/// <param name="sortOn">
///   A <see cref="System.String"/> containing the column name to sort on.
/// </param>
/// <param name="order">
///   A <see cref="System.String"/> containing the discriptor of the sort order - ascending (ASC) or descending (DESC).
/// </param>
/// <returns> 
///   A <see cref="System.Data.DataSet"/> containing the now sorted DataSet.
/// </returns>
/// <remarks>
///    
/// </remarks>
	public static DataSet sortDS(DataSet dset, string sortOn, string order)
	{
		DataSet sortDs = new DataSet();
		if (order!="asc" && order!="ASC" && order!="desc" && order!="DESC")
		{
			order="asc";
		}
		foreach (DataTable dt in dset.Tables)
		{
			DataTable t = new DataTable();
			t=dt.Copy();
			DataView v=t.DefaultView;
			v.Sort=sortOn+" "+order;
			t=v.ToTable();
			sortDs.Tables.Add(t.Copy());
		}
	return sortDs;
	}

/// <summary>
///   The <see cref="sortDT(DataTable,string,string)"/> static method is used to sort the records in a DataTable.
/// </summary>
/// <param name="dset">
///   A <see cref="System.Data.DataTable"/> containing data to be sorted.
/// </param>
/// <param name="sortOn">
///   A <see cref="System.String"/> containing the column name to sort on.
/// </param>
/// <param name="order">
///   A <see cref="System.String"/> containing the discriptor of the sort order - ascending (ASC) or descending (DESC).
/// </param>
/// <returns> 
///   A <see cref="System.Data.DataTable"/> containing the now sorted DataTable.
/// </returns>
/// <remarks>
///    
/// </remarks>
	public static DataTable sortDT(DataTable table, string sortOn, string order)
	{
		if (order!="asc" && order!="ASC" && order!="desc" && order!="DESC")
		{
			order="asc";
		}
		DataTable t = new DataTable();
		t=table.Copy();
		DataView v=t.DefaultView;
		v.Sort=sortOn+" "+order;
		t=v.ToTable();
	return t;
	}

/// <summary>
///   The <see cref="objToDataSet(Object[])"/> static method is used to sort the records in a DataSet.
/// </summary>
/// <param name="dset">
///   A <see cref="System.Object[]"/> array containing data to be put into a DataSet.
/// </param>
/// <returns> 
///   A <see cref="System.Data.DataSet"/> containing the now sorted DataSet.
/// </returns>
/// <remarks>
///    
/// </remarks>
	public static DataSet objToDataSet(object[] objects)
	{
		DataSet dat = new DataSet();
		if (objects != null && objects.Length > 0)
		{
			Type t = objects[0].GetType();
			DataTable dt = new DataTable(t.Name);
			foreach (PropertyInfo pi in t.GetProperties())
			{
				dt.Columns.Add(new DataColumn(pi.Name));
			}
			foreach (object o in objects)
			{
				DataRow dr = dt.NewRow();
				foreach (DataColumn dc in dt.Columns)
				{
					dr[dc.ColumnName] = o.GetType().GetProperty(dc.ColumnName).GetValue(o, null);
				}
				dt.Rows.Add(dr);
			}
			dat.Tables.Add(dt);
			return dat;
		}
		return null; 
	}

/// <summary>
///   The <see cref="ExtractText(string)"/> static method is used to extract the text from a PDF.
/// </summary>
/// <param name="inFileName">
///   A <see cref="System.String"/> containing the full path to the PDF file to be parsed.
/// </param>
/// <returns> 
///   A <see cref="System.String"/> containing the parsed text.
/// </returns>
/// <seealso cref="ExtractTextFromPDFBytes(byte[])">
///	  The <see cref="ExtractTextFromPDFBytes(byte[])"/> static method is accessed(required) by this method.
/// </seealso>
/// <remarks>
///   The iText software by <see cref="!http://http://itextpdf.com/">1T3XT</see> is redistributed in accordance with the Affere General Public License (AGPL).
///
///   Based on sample code from <see cref="!http://www.codeproject.com/KB/cs/PDFToText.aspx">HERE</see> in accordance with the <see cref="http://www.codeproject.com/info/cpol10.aspx">The Code Project Open License (CPOL) 1.02</see>.
///
///   This program is free software; you can redistribute it and/or modify it under the terms of the GNU 
///   Affero General Public License version 3 as published by the Free Software Foundation with the addition 
///   of the following permission added to Section 15 as permitted in Section 7(a): FOR ANY PART OF THE 
///   COVERED WORK IN WHICH THE COPYRIGHT IS OWNED BY 1T3XT, 1T3XT DISCLAIMS THE WARRANTY OF NON INFRINGEMENT 
///   OF THIRD PARTY RIGHTS.
///   
///   This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; 
///   without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
///   See the GNU Affero General Public License for more details. You should have received a copy of the 
///   GNU Affero General Public License along with this program; if not, see http://www.gnu.org/licenses or 
///   write to the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA, 02110-1301 USA, 
///   or download the license from the following URL: http://itextpdf.com/terms-of-use/
///   
///   The interactive user interfaces in modified source and object code versions of this program must 
///   display Appropriate Legal Notices, as required under Section 5 of the GNU Affero General Public License.
///   
///   In accordance with Section 7(b) of the GNU Affero General Public License, you must retain the producer 
///   line in every PDF that is created or manipulated using iText.
///   
///   You can be released from the requirements of the license by purchasing a commercial license. 
///   Buying such a license is mandatory as soon as you develop commercial activities involving the iText 
///   software without disclosing the source code of your own applications. These activities include: offering 
///   paid services to customers as an ASP, serving PDFs on the fly in a web application, shipping iText with 
///   a closed source product.
///   
/// </remarks>
	public static string ExtractText(string inFileName)  
	{
		StreamWriter outFile = null;
		string outString="", pageString="";
		try
		{
			PdfReader reader = new PdfReader(inFileName);
			Console.Write("Processing: ");
			int     totalLen    = 68;
			float   charUnit    = ((float)totalLen) / (float)reader.NumberOfPages;
			int     totalWritten= 0;
			float   curUnit     = 0;
			for (int page = 1; page <= reader.NumberOfPages; page++)
			{             
				pageString="";
				pageString=ExtractTextFromPDFBytes(reader.GetPageContent(page)) + " ";  
				if (charUnit >= 1.0f)
				{
					for (int i = 0; i < (int)charUnit; i++)
					{
						Console.Write("#");
						totalWritten++;
					}
				}
				else
				{
					curUnit += charUnit;
					if (curUnit >= 1.0f)
					{
						for (int i = 0; i < (int)curUnit; i++)
						{
							Console.Write("#");
							totalWritten++;
						}
						curUnit = 0;
					}
				}
				outString=outString+pageString;
			}
			if (totalWritten < totalLen)
			{
				for (int i = 0; i < (totalLen - totalWritten); i++)
				{
					Console.Write("#");
				}
			}
			return outString;
		}
		catch
		{
			return outString;
		}
		finally
		{
			if (outFile != null) outFile.Close();
		}
	}

/// <summary>
///   The <see cref="ExtractTextFromPDFBytes(byte[])"/> method processes an uncompressed Adobe (text) object and extracts text..
/// </summary>
/// <param name="inFileName">
///   A <see cref="System.Byte[]"/> containing an uncompressed Adobe (text) object.
/// </param>
/// <returns> 
///   A <see cref="System.String"/> containing the parsed text.
/// </returns>
/// <seealso cref="CheckToken(string[], char[])">
///	  The <see cref="CheckToken(string[], char[])"/> static method is accessed(required) by this method.
/// </seealso>
/// <remarks>
///   The iText software by <see cref="!http://http://itextpdf.com/">1T3XT</see> is redistributed in accordance with the Affere General Public License (AGPL).
///
///   Based on sample code from <see cref="!http://www.codeproject.com/KB/cs/PDFToText.aspx">HERE</see> in accordance with the <see cref="http://www.codeproject.com/info/cpol10.aspx">The Code Project Open License (CPOL) 1.02</see>.
///
///   This program is free software; you can redistribute it and/or modify it under the terms of the GNU 
///   Affero General Public License version 3 as published by the Free Software Foundation with the addition 
///   of the following permission added to Section 15 as permitted in Section 7(a): FOR ANY PART OF THE 
///   COVERED WORK IN WHICH THE COPYRIGHT IS OWNED BY 1T3XT, 1T3XT DISCLAIMS THE WARRANTY OF NON INFRINGEMENT 
///   OF THIRD PARTY RIGHTS.
///   
///   This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; 
///   without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
///   See the GNU Affero General Public License for more details. You should have received a copy of the 
///   GNU Affero General Public License along with this program; if not, see http://www.gnu.org/licenses or 
///   write to the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA, 02110-1301 USA, 
///   or download the license from the following URL: http://itextpdf.com/terms-of-use/
///   
///   The interactive user interfaces in modified source and object code versions of this program must 
///   display Appropriate Legal Notices, as required under Section 5 of the GNU Affero General Public License.
///   
///   In accordance with Section 7(b) of the GNU Affero General Public License, you must retain the producer 
///   line in every PDF that is created or manipulated using iText.
///   
///   You can be released from the requirements of the license by purchasing a commercial license. 
///   Buying such a license is mandatory as soon as you develop commercial activities involving the iText 
///   software without disclosing the source code of your own applications. These activities include: offering 
///   paid services to customers as an ASP, serving PDFs on the fly in a web application, shipping iText with 
///   a closed source product.
///   
/// </remarks>
	public static string ExtractTextFromPDFBytes(byte[] input)
	{
		// BT = Beginning of a text object operator 
		// ET = End of a text object operator
		// Td move to the start of next line
		//  5 Ts = superscript
		// -5 Ts = subscript
		if (input == null || input.Length == 0) return "";
		try
		{
			string resultString = "";
			// Flag showing if we are we currently inside a text object
			bool inTextObject = false;
			// Flag showing if the next character is literal 
			// e.g. '\\' to get a '\' character or '\(' to get '('
			bool nextLiteral = false;
			// () Bracket nesting level. Text appears inside ()
			int bracketDepth = 0;
			// Keep previous chars to get extract numbers etc.:
			char[] previousCharacters = new char[_numberOfCharsToKeep];
			for (int j = 0; j < _numberOfCharsToKeep; j++) previousCharacters[j] = ' ';
			for (int i = 0; i < input.Length; i++)
			{
				char c = (char)input[i];
				if (inTextObject)
				{
					// Position the text
					if (bracketDepth == 0)
					{
						if (CheckToken(new string[] { "TD", "Td" }, previousCharacters))
						{
							resultString += "\n\r";
						}
						else
						{
							if (CheckToken(new string[] {"'", "T*", "\""}, previousCharacters))
							{
								resultString += "\n";
							}
							else
							{
								if (CheckToken(new string[] { "Tj" }, previousCharacters))
								{
									resultString += " ";
								}
							}
						}
					}
					// End of a text object, also go to a new line.
					if (bracketDepth == 0 && CheckToken( new string[]{"ET"}, previousCharacters))
					{
						inTextObject = false;
						resultString += " ";
					}
					else
					{
						// Start outputting text
						if ((c == '(') && (bracketDepth == 0) && (!nextLiteral))
						{
							bracketDepth = 1;
						}
						else
						{
						// Stop outputting text
							if ((c == ')') && (bracketDepth == 1) && (!nextLiteral))
							{
								bracketDepth = 0;
							}
							else
							{
								// Just a normal text character:
								if (bracketDepth == 1)
								{
									// Only print out next character no matter what. 
									// Do not interpret.
									if (c == '\\' && !nextLiteral)
									{
										nextLiteral = true;
									}
									else
									{
										if (((c >= ' ') && (c <= '~')) || ((c >= 128) && (c < 255)))
										{
											resultString += c.ToString();
										}
										nextLiteral = false;
									}
								}
							}
						}
					}
				}
				// Store the recent characters for 
				// when we have to go back for a checking
				for (int j = 0; j < _numberOfCharsToKeep - 1; j++)
				{
					previousCharacters[j] = previousCharacters[j + 1];
				}
				previousCharacters[_numberOfCharsToKeep - 1] = c;
				// Start of a text object
				if (!inTextObject && CheckToken(new string[]{"BT"}, previousCharacters))
				{
					inTextObject = true;
				}
			}
			return resultString;
		}
		catch
		{
			return "";
		}
	}

/// <summary>
///   The <see cref="CheckToken(string[], char[])"/> method checks to see if a certain 2 character token (e.g. BT) just came through a string array .
/// </summary>
/// <param name="tokens">
///   A <see cref="System.String[]"/> array containing the strings to check for a token.
/// </param>
/// <param name="recent">
///   A <see cref="System.Char[]"/> array containing the token to seek.
/// </param>
/// <returns> 
///   A <see cref="System.String"/> containing the parsed text.
/// </returns>
/// <seealso cref="_numberOfCharsToKeep">
///	  The <see cref="_numberOfCharsToKeep"/> static property is accessed(required) by this method.
/// </seealso>
/// <remarks>
///   The iText software by <see cref="!http://http://itextpdf.com/">1T3XT</see> is redistributed in accordance with the Affere General Public License (AGPL).
///
///   Based on sample code from <see cref="!http://www.codeproject.com/KB/cs/PDFToText.aspx">HERE</see> in accordance with the <see cref="http://www.codeproject.com/info/cpol10.aspx">The Code Project Open License (CPOL) 1.02</see>.
///
///   This program is free software; you can redistribute it and/or modify it under the terms of the GNU 
///   Affero General Public License version 3 as published by the Free Software Foundation with the addition 
///   of the following permission added to Section 15 as permitted in Section 7(a): FOR ANY PART OF THE 
///   COVERED WORK IN WHICH THE COPYRIGHT IS OWNED BY 1T3XT, 1T3XT DISCLAIMS THE WARRANTY OF NON INFRINGEMENT 
///   OF THIRD PARTY RIGHTS.
///   
///   This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; 
///   without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
///   See the GNU Affero General Public License for more details. You should have received a copy of the 
///   GNU Affero General Public License along with this program; if not, see http://www.gnu.org/licenses or 
///   write to the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA, 02110-1301 USA, 
///   or download the license from the following URL: http://itextpdf.com/terms-of-use/
///   
///   The interactive user interfaces in modified source and object code versions of this program must 
///   display Appropriate Legal Notices, as required under Section 5 of the GNU Affero General Public License.
///   
///   In accordance with Section 7(b) of the GNU Affero General Public License, you must retain the producer 
///   line in every PDF that is created or manipulated using iText.
///   
///   You can be released from the requirements of the license by purchasing a commercial license. 
///   Buying such a license is mandatory as soon as you develop commercial activities involving the iText 
///   software without disclosing the source code of your own applications. These activities include: offering 
///   paid services to customers as an ASP, serving PDFs on the fly in a web application, shipping iText with 
///   a closed source product.
///   
/// </remarks>
	public static bool CheckToken(string[] tokens, char[] recent)  // 
	{
		// BT = Beginning of a text object operator 
		// ET = End of a text object operator
		// Td move to the start of next line
		//  5 Ts = superscript
		// -5 Ts = subscript
		foreach(string token in tokens)
		{
			if ((recent[_numberOfCharsToKeep - 3] == token[0]) && (recent[_numberOfCharsToKeep - 2] == token[1]) && ((recent[_numberOfCharsToKeep - 1] == ' ') || (recent[_numberOfCharsToKeep - 1] == 0x0d) || (recent[_numberOfCharsToKeep - 1] == 0x0a)) && ((recent[_numberOfCharsToKeep - 4] == ' ') || (recent[_numberOfCharsToKeep - 4] == 0x0d) || (recent[_numberOfCharsToKeep - 4] == 0x0a)))
			{
				return true;
			}
		}
		return false;
	}

/// <summary>
///   The <see cref="getSRDataSet(string)"/> static method is used to sort the records in a DataSet.
/// </summary>
/// <param name="siteToScrape">
///   A <see cref="System.String"/> containing a URL of a web resource to scrape into a dataset.
/// </param>
/// <returns> 
///   A <see cref="System.Data.DataSet"/> containing the now sorted DataSet.
/// </returns>
/// <seealso cref="stripCode(string)">
///	  The <see cref="stripCode(string)"/> static method is accessed(required) by this method.
/// </seealso>
/// <remarks>
///    Portions credit: http://www.krio.me/dot-net-c-sharp-web-scraper/
///    
/// </remarks>
    public static DataSet getSRDataSet(string siteToScrape)
    {
        DataSet response = new DataSet();
        WebResponse objResponse;
        WebRequest objRequest = System.Net.HttpWebRequest.Create(siteToScrape);
        objResponse = objRequest.GetResponse();
		using (TextReader rdr = new StreamReader(objResponse.GetResponseStream()))
		{
			string line, fixed_line;
			DataTable dt = new DataTable("SR List");
			dt.Columns.Add("SRNumber");
			dt.Columns.Add("SRTitle");
			dt.Columns.Add("SRDetail");
			dt.Columns.Add("SRLastActionDate");
			dt.Columns.Add("SRStatus");
			dt.Columns.Add("SRCategory");
			dt.Columns.Add("SRRequestor");
			string srNum="", srTitle="", srDetail="", srActionDate="", srStatus="";
			string detailText="", srCategory="", srRequestor="";
			int begin=0, end=0, diff=0;
			while ((line = rdr.ReadLine()) != null)
			{
				if (Regex.IsMatch(line,"<tr>"))
				{
					srNum="";
					srTitle="";
					srDetail="";
					srActionDate="";
					srStatus="";
				}
				if (Regex.IsMatch(line,"HHBCASENUMBER821") || Regex.IsMatch(line,"HHBREQUESTTITLE821") || Regex.IsMatch(line,"HHBACTIONDATE821") || Regex.IsMatch(line,"HHBACTIONSTATUS821"))
				{
					if (Regex.IsMatch(line,"HHBCASENUMBER821")) // SR Number
					{
						fixed_line=stripCode(line);
						srNum=fixed_line.Trim();
						srDetail="http://fswebas.wo.fs.fed.us:7777/reports/rwservlet?iso_tracking&report=tr_rfc.rdf&destype=cache&desformat=pdf&p_case_number="+srNum;
					} 
					if (Regex.IsMatch(line,"HHBREQUESTTITLE821")) // SR Title
					{
						fixed_line=stripCode(line);
						srTitle=fixed_line.Trim();
					} 
					// Note SR From URL is 'http://fswebas.wo.fs.fed.us:7777/reports/rwservlet?iso_tracking&report=tr_rfc.rdf&destype=cache&desformat=pdf&p_case_number='+SR Number
					if (Regex.IsMatch(line,"HHBACTIONDATE821")) //SR Last Action Date
					{
						fixed_line=stripCode(line);
						srActionDate=fixed_line.Trim();
					} 
					if (Regex.IsMatch(line,"HHBACTIONSTATUS821")) // SR Status
					{
						fixed_line=stripCode(line);
						srStatus=fixed_line.Trim();
					}
				}
				if (Regex.IsMatch(line,"</tr>"))
				{
					begin=0;
					end=0;
					diff=0;
					if (srNum!="Case Number")
					{
						DataRow dr = dt.NewRow();
						dr["SRNumber"]=srNum;
						dr["SRTitle"]=srTitle;
						dr["SRDetail"]=srDetail;  //URL for the SR Detail (NOTE: its a PDF Document)
						if (srDetail!="")
						{
							detailText=ExtractText(srDetail); //Parse the PDF document into a string
							begin=detailText.IndexOf("Resubmission Date")+17; //17
							end=detailText.IndexOf("Category"); 
							diff=end-begin;
							if (diff>0) // The actual category text we want is between the words 'Resubmission Date' and 'Category' in the parsed string
							{
								srCategory=detailText.Substring(begin,diff);
								srCategory.Trim();
							}
							begin=0;
							end=0;
							diff=0;
							begin=detailText.IndexOf("Request Title")+14; //14
							end=detailText.IndexOf("Requestor Name"); 
							diff=end-begin;
							if (diff>0) // The actual requestor name text we want is between the words 'Request Title' and 'Requestor Name' in the parsed string
							{
								srRequestor=detailText.Substring(begin,diff);
								srRequestor.Trim();
							}
						}
						dr["SRLastActionDate"]=srActionDate;
						dr["SRStatus"]=srStatus;
						dr["SRCategory"]=srCategory;
						dr["SRRequestor"]=srRequestor;
						dt.Rows.Add(dr);
					}
				}
			}
			response.Tables.Add(dt);
		}
		return response;
    }

/// <summary>
///   The <see cref="stripCode(string)"/> static method is used to strip all HTML / XML tags from a string(filestream).
/// </summary>
/// <param name="the_html">
///   A <see cref="System.String"/> containing HTML from a web resource.
/// </param>
/// <returns> 
///   A <see cref="System.String"/> containing sanitized text.
/// </returns>
/// <remarks>
///    Credit: http://www.krio.me/dot-net-c-sharp-web-scraper/
///    
///    Copyright \A9 2009-2012 Krio Media, LLC. A Miami Website Development Company.
/// </remarks>
    public static string stripCode(string the_html) // 
    {
        // Remove google analytics code and other JS
        the_html = Regex.Replace(the_html, "<script.*?</script>", "", RegexOptions.Singleline | RegexOptions.IgnoreCase);
        // Remove inline stylesheets
        the_html = Regex.Replace(the_html, "<style.*?</style>", "", RegexOptions.Singleline | RegexOptions.IgnoreCase);
        // Remove HTML tags
        the_html = Regex.Replace(the_html, "</?[a-z][a-z0-9]*[^<>]*>", "");
        // Remove HTML comments
        the_html = Regex.Replace(the_html, "<!--(.|\\s)*?-->", "");
        // Remove Doctype
        the_html = Regex.Replace(the_html, "<!(.|\\s)*?>", "");
        // Remove excessive whitespace
        the_html = Regex.Replace(the_html, "[\t\r\n]", " ");

        return the_html;
    }

/// <summary>
///   The <see cref="connectToAD(string, string, string, string)"/> static method is used to make a secure connection to AD/LDAP.
/// </summary>
/// <param name="strServer">
///	  A <see cref="System.String"/> containing the base DN to use for the of the AD/LDAP query.
/// </param>
/// <param name="baseDN">
///   A <see cref="System.String"/> containing the base DN to use for the of the AD/LDAP query.
/// </param>
/// <param name="bindUser">
///	  A <see cref="System.String"/> containing the bind username to use for the of the AD/LDAP query.
/// </param>
/// <param name="bindPw">
///	  A <see cref="System.String"/> containing the bind password to use for the of the AD/LDAP query.
/// </param>
/// <returns> 
///   A <see cref="System.DirectoryServices.DirectoryEntry"/> containing the AD/LDAP connection object.
/// </returns>
/// <remarks>
///    
/// </remarks>
	public static DirectoryEntry connectToAD(string strServer, string baseDN, string bindUser, string bindPw)
	{
		DirectoryEntry deSystem = new DirectoryEntry(strServer+baseDN,bindUser,bindPw,AuthenticationTypes.Secure);
		return deSystem;
	}

/// <summary>
///   The <see cref="customConnectToAD(string, string, string, string)"/> static method is used to make a secure connection to AD/LDAP.
/// </summary>
/// <param name="customDN">
///   A <see cref="System.String"/> containing the custom DN to use for the of the AD/LDAP query.
/// </param>
/// <param name="strServer">
///	  A <see cref="System.String"/> containing the base DN to use for the of the AD/LDAP query.
/// </param>
/// <param name="bindUser">
///	  A <see cref="System.String"/> containing the bind username to use for the of the AD/LDAP query.
/// </param>
/// <param name="bindPw">
///	  A <see cref="System.String"/> containing the bind password to use for the of the AD/LDAP query.
/// </param>
/// <returns> 
///   A <see cref="System.DirectoryServices.DirectoryEntry"/> containing the AD/LDAP connection object.
/// </returns>
/// <remarks>
///    
/// </remarks>
	public static DirectoryEntry customConnectToAD(string customDN, string strServer, string bindUser, string bindPw)
	{
		DirectoryEntry deSystem = new DirectoryEntry(strServer+customDN,bindUser,bindPw,AuthenticationTypes.Secure);
		return deSystem;
	}

/// <summary>
///   The <see cref="doPing(string)"/> static method is used to ping a specified IP address.
/// </summary>
/// <param name="ip">
///   A <see cref="System.String"/> containing the ip address to be ping'ed.
/// </param>
/// <returns> 
///   A <see cref="System.Boolean"/> containing the status of the ping, Ping OK=True, Packet Loss=Fail.
/// </returns>
/// <remarks>
///    
/// </remarks>
	public static bool doPing(string ip)
	{
		bool status=false;
		Ping pingSender = new Ping ();
		IPAddress address = IPAddress.Parse(ip);
		PingReply reply = pingSender.Send(address);
		if (reply.Status == IPStatus.Success)
		{
			status=true;
		}
		else
		{
			status=false;
		}
		return status;
	}

/// <summary>
///   The <see cref="simpleDnsLookup(string)"/> static method is used to perform an NSLOOKUP on a hostname.
/// </summary>
/// <param name="hostname">
///   A <see cref="System.String"/> containing the hostname for NSLOOKUP.
/// </param>
/// <returns> 
///   A <see cref="System.String"/> containing the status of the NSLOOKUP.
/// </returns>
/// <seealso cref="dnsLookup(string)">
///	  The <see cref="dnsLookup(string)"/> static method is accessed(required) by this method.
/// </seealso>
/// <remarks>
///    This is 'simple' cuz it just returns one IP. It ignores dumplicate IP resolutions from our search order, 
///    BUT if we get back different IPs from different resolvers in the search order ithe return string contains an error.
/// </remarks>
	public static string simpleDnsLookup(string hostname)
	{
		StringCollection results = new StringCollection();
		string result ="";
		int count=0, length=0;
		string conflicts="";
		string suffixOne="";
		string suffixTwo="";
		StringCollection lookupResult=new StringCollection();
		hostname=hostname.ToLower();	
		lookupResult=dnsLookup(hostname);
		if (lookupResult!=null)
		{
			foreach (string dnsAddr in lookupResult)
			{
				string[] resultData = dnsAddr.Split(':');
				if (result=="")
				{
					result=resultData[1].Trim();
				}
				else
				{
					if (result!=resultData[1].Trim())
					{
						count++;
						if (conflicts=="")
						{
							conflicts=resultData[1].Trim()+"("+resultData[0].Trim()+")";
						}
						else
						{
							conflicts=conflicts+","+resultData[1].Trim()+"("+resultData[0].Trim()+")";
						}
					}
				}
			}
		}
		else
		{
			lookupResult=dnsLookup(hostname);
			if (lookupResult!=null)
			{
				foreach (string dnsAddr in lookupResult)
				{
					string[] resultData = dnsAddr.Split(':');
					if (result=="")
					{
						result=resultData[1].Trim();
					}
					else
					{
						if (result!=resultData[1].Trim())
						{
							count++;
							if (conflicts=="")
							{
								conflicts=resultData[1].Trim()+"("+resultData[0].Trim()+")";
							}
							else
							{
								conflicts=conflicts+","+resultData[1].Trim()+"("+resultData[0].Trim()+")";
							}
						}
					}
				}
			}
		}
		if (count>0)
		{
			result="ERROR: Conflicting Resolution! ["+conflicts+"]";
		}
		return result;
	}

/// <summary>
///   The <see cref="dnsLookup(string)"/> static method is used to perform an NSLOOKUP on a hostname.
/// </summary>
/// <param name="hostname">
///   A <see cref="System.String"/> containing the hostname for NSLOOKUP.
/// </param>
/// <returns> 
///   A <see cref="System.Collections.Specialized.StringCollection"/> containing the matching result(s) of the NSLOOKUP search.
/// </returns>
/// <remarks>
///    This is a full NSLOOKUP, it will return duplicate resolutions from the search order, 
///    BUT if we get back different IPs from different resolvers in the search order the return string contains an error.
/// </remarks>
	public static StringCollection dnsLookup(string hostname)
	{
		string dnsSearchOrder="";
		StringCollection results = new StringCollection();
		hostname=hostname.ToLower();

		if (hostname.Contains("phe"))
		{
				dnsSearchOrder="phe.fs.fed.us,dsphe.fs.fed.us";
		}
		if (hostname.Contains("qa"))
		{
				dnsSearchOrder="qa.fs.fed.us,dsqa.fs.fed.us";
		}
		if (hostname.Contains("prp"))
		{
				dnsSearchOrder="prp.fs.fed.us,dsprp.fs.fed.us";
		}
		if (hostname.Contains("mci") || hostname.Contains("ent"))
		{
				dnsSearchOrder="mci.fs.fed.us,ds.fs.fed.us";
		}

		string[] domains = dnsSearchOrder.Split(',');
		ArrayList domainList = new ArrayList();
	
		domainList.AddRange(domains);
		foreach (string domain in domains)
		{
			try
			{
				//performs the DNS lookup
				IPHostEntry he = Dns.GetHostEntry(hostname+"."+domain);
				IPAddress[] ip_addrs = he.AddressList;
				foreach (IPAddress ip in ip_addrs)
				{
//					Response.Write(hostname+"."+domain+":"+ip+"<BR/>");
					results.Add(hostname+"."+domain+":"+ip);
				}
			}
			catch (System.Exception ex)
			{
//				throw ex;
//				results=null;
			}
		}
		return results;
		// Basically you can grab just the IP found in DNS by doing a foreach result {split(':').result[1]}, while the domain that resolved the ip is foreach result {split(':').result[0]}
	} 

/// <summary>
///   The <see cref="dnsReverseLookup(string)"/> static method is used to perform an NSLOOKUP (reverse DNS) on an IP address.
/// </summary>
/// <param name="hostname">
///   A <see cref="System.String"/> containing the IP address for NSLOOKUP.
/// </param>
/// <returns> 
///   A <see cref="System.Collections.Specialized.StringCollection"/> containing the matching result(s) of the NSLOOKUP search.
/// </returns>
/// <remarks>
///    This is a full reverse lookup, it will return duplicate resolutions from the search order, 
///    BUT if we get back different hostnames from different resolvers in the search order the return string contains an error.
/// </remarks>
	public static StringCollection dnsReverseLookup(string ipAddr)
	{
		StringCollection results = new StringCollection();

		try
		{
			IPHostEntry he = Dns.GetHostEntry(ipAddr);
			results.Add(he.HostName); // Store the A record results (if any)
			string[] hostNames = he.Aliases;
			foreach (string host in hostNames)
			{
				results.Add(host); //Store the CNAME record results (if any)
			}
		}
		catch (System.Exception ex)
		{
			results=null;
		}
		return results;
	} 

} //END-conspectisLibrary


/// <summary>
///   The wodLibrary class contains all code-behind members for the VMWare Workspace-On-Demand module of the CIS application.
/// </summary>
/// <seealso cref="VMware.Vim">
///	  The <see cref="VMware.Vim"/> namespace is accessed(required) by members of this class.
/// </seealso>
/// <seealso cref="conspectisLibrary">
///	  The <see cref="conspectisLibrary"/> class is inherited by this class.
/// </seealso>
/// <remarks>
///   This library uses the VMWare Web Services SDK and is licensed under the VI SDK Developer License.
///   For more information on the VI SDK Developer License see the <see cref="!http://communities.vmware.com/docs/DOC-7983">FAQ</see>
///   
///   * **********************************************************
///   * Copyright 2009 VMware, Inc.  All rights reserved.
///   * **********************************************************/
///   
///   The sample code is provided "AS-IS" for use, modification, and redistribution in source 
///   and binary forms, provided that the copyright notice and this following list of conditions
///   are retained and/or reproduced in your distribution. To the maximum extent permitted by 
///   law, VMware, Inc., its subsidiaries and affiliates hereby disclaim all express, implied 
///   and/or statutory warranties, including duties or conditions of merchantability, fitness 
///   for a particular purpose, and non-infringement of intellectual property rights. IN NO 
///   EVENT WILL VMWARE, ITS SUBSIDIARIES OR AFFILIATES BE LIABLE TO ANY OTHER PARTY FOR THE
///   COST OF PROCURING SUBSTITUTE GOODS OR SERVICES, LOST PROFITS, LOSS OF USE, LOSS OF DATA,
///   OR ANY INCIDENTAL, CONSEQUENTIAL, DIRECT, INDIRECT, OR SPECIAL DAMAGES, ARISING OUT OF
///   THIS OR ANY OTHER AGREEMENT RELATING TO THE SAMPLE CODE.
///   
///   You agree to defend, indemnify and hold harmless VMware, and any of its directors,
///   officers, employees, agents, affiliates, or subsidiaries from and against all losses,
///   damages, costs and liabilities arising from your use, modification and distribution 
///   of the sample code.
///   
///   VMware does not certify or endorse your use of the sample code, nor is any support or 
///   other service provided in connection with the sample code.
///   
/// </remarks>
public class wodLibrary : conspectisLibrary
{

// NON-STATIC conspectisLibrary Properties (Usable via WebUI ONLY!)
//------------------------------------------------------------------------
//
// None.


// STATIC conspectisLibrary Properties (Usable via WebUI & PowerShell)
//------------------------------------------------------------------------
//
// None.


// NON-STATIC conspectisLibrary Methods (Usable via WebUI ONLY!)
//------------------------------------------------------------------------
/// <summary>
///   The <see cref="wodLibrary()"/> constructor is called at class instantiation.
/// </summary>
/// <remarks>
///   
/// </remarks>
	public wodLibrary()  
	{
	}


// STATIC conspectisLibrary Methods (Usable via WebUI & PowerShell)
//------------------------------------------------------------------------
/// <summary>
///   The <see cref="wodConnect(string, string, string)"/> static method is used to connect to a VMware vSphere web service.
/// </summary>
/// <param name="url">
///   A <see cref="System.String"/> containing the URL for the VMware vSphere web service connection.
/// </param>
/// <param name="user">
///   A <see cref="System.String"/> containing the username for the VMware vSphere web service connection.
/// </param>
/// <param name="pass">
///   A <see cref="System.String"/> containing the password for the VMware vSphere web service connection.
/// </param>
/// <returns> 
///   A <see cref="VMware.Vim.VimClient"/> object - 'the connection'.
/// </returns>
/// <remarks>
///   
/// </remarks>
	public static VimClient wodConnect(string url, string user, string pass)
	{
		string result="";
		VimClient client = new VimClient();  
		try
		{
			client.Connect(url);  // connect to vSphere web service
		}
		catch (System.Exception ex)
		{
			System.Exception connectEx = new System.InvalidOperationException("Unable to make VimAPI Connection!",ex);
			throw connectEx;
		}
		if (result==null)
		{
			try
			{
				client.Login(user, pass);  // Login using username/password credentials
			}
			catch (System.Exception ex)
			{
				System.Exception loginEx = new System.InvalidOperationException("Unable to Login to VimAPI!",ex);
				throw loginEx;
			}
		}
		return client;
	}

/// <summary>
///   The <see cref="wodDisconnect()"/> static void method is used to cleanly disconnect from a VMware vSphere web service.
/// </summary>
/// <remarks>
///   
/// </remarks>
	public static void wodDisconnect(VimClient client)
	{
		client.Disconnect();  // Logout from the vSphere server
	}

} //END-wodLibrary

} //END-Namespace
