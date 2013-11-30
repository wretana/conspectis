##################################################
#                                                #
# ESMS Powershell Helper Module                  #
#                                                #
#   Desc: This module allows Powershell to       #
#         directly use the ESMS.esmsLibrary      #
#         code-behind class.                     #
# Author: Chris Knight                           #
#   Date: 5/22/12                                #
#                                                #
##################################################

## Path to ESMS C# Code-Behind
$path="C:\inetpub\ESMS-ABQDC"

## Required Dependent Assemblies to support ESMS C# Code Behind
$Assem = (
"c:\Windows\Microsoft.Net\Framework\v2.0.50727\System.Configuration.dll",
"c:\Windows\Microsoft.Net\Framework\v2.0.50727\System.Data.dll",
"c:\Windows\Microsoft.Net\Framework\v2.0.50727\System.DirectoryServices.dll",
"c:\Windows\Microsoft.Net\Framework\v2.0.50727\System.Drawing.dll",
"c:\Windows\Microsoft.Net\Framework\v2.0.50727\System.Web.dll",
"c:\Windows\Microsoft.Net\Framework\v2.0.50727\System.Web.Services.dll",
"c:\Windows\Microsoft.Net\Framework\v2.0.50727\System.Xml.dll",
"c:\Windows\Microsoft.Net\Framework\v2.0.50727\mscorlib.dll",
"c:\Windows\Microsoft.Net\Framework\v2.0.50727\system.dll",
"$path\bin\itextsharp.dll",
"$path\bin\VMWare.Vim.dll"
)


$file = "$path\esmsLibrary.cs"
$Source = [System.IO.File]::ReadAllText($file)

## Compile the Dependent Assemblies into the PowerShell Environment
Add-Type -Path $Assem

$cpar = New-Object System.CodeDom.Compiler.CompilerParameters
$cpar.ReferencedAssemblies.Add("c:\Windows\Microsoft.Net\Framework\v2.0.50727\mscorlib.dll")
$cpar.ReferencedAssemblies.Add("c:\Windows\Microsoft.Net\Framework\v2.0.50727\system.dll")
$cpar.ReferencedAssemblies.Add("c:\Windows\Microsoft.Net\Framework\v2.0.50727\System.Configuration.dll")
$cpar.ReferencedAssemblies.Add("c:\Windows\Microsoft.Net\Framework\v2.0.50727\System.Data.dll")
$cpar.ReferencedAssemblies.Add("c:\Windows\Microsoft.Net\Framework\v2.0.50727\System.DirectoryServices.dll")
$cpar.ReferencedAssemblies.Add("c:\Windows\Microsoft.Net\Framework\v2.0.50727\System.Drawing.dll")
$cpar.ReferencedAssemblies.Add("c:\Windows\Microsoft.Net\Framework\v2.0.50727\System.Web.dll")
$cpar.ReferencedAssemblies.Add("c:\Windows\Microsoft.Net\Framework\v2.0.50727\System.Web.Services.dll")
$cpar.ReferencedAssemblies.Add("c:\Windows\Microsoft.Net\Framework\v2.0.50727\System.Xml.dll")
$cpar.ReferencedAssemblies.Add("$path\bin\itextsharp.dll")
$cpar.ReferencedAssemblies.Add("$path\bin\VMWare.Vim.dll")

## Compile the ESMS C# Code-Behind into the PowerShell Environment
Add-Type -TypeDefinition $Source -Language CSharpVersion3 -passThru -IgnoreWarnings -CompilerParameters $cpar

## Declare Variables for "Wrapper" functions
[string]$cstr="DEFAULT"
[string]$dbFile="DEFAULT"
[string]$sysName="DEFAULT"
[string]$shortSysName="DEFAULT"
[string]$sysURL="DEFAULT"
[string]$mailServer="DEFAULT"

[string]$passPhrase="DEFAULT"
[string]$saltValue="DEFAULT"
[string]$hashAlgorithm="DEFAULT"
[int]$passwordIterations=0
[string]$initVector="DEFAULT"
[int]$keySize=0
[string]$prefix="DEFAULT"

[string]$strServerName="DEFAULT"
[string]$strBaseDN="DEFAULT"
[string]$bindDN="DEFAULT"
[string]$bindPWD="DEFAULT"
[string]$ADUsersGroup="DEFAULT"
[string]$ADAdminsGroup="DEFAULT"
[string]$ADSuperGroup="DEFAULT"
[string]$ADWoDUsersGroup="DEFAULT"
[string]$ADWoDAdminsGroup="DEFAULT"
[string]$dnsSearchOrder="DEFAULT"

## Capture DataCenter Location "Mode" Argument
if ( $Args.Length -gt 0 )
{
	$mode = $Args[0]
}

if ( $mode -eq "ABQDC" )
{
	$dbFile="$path\ems_db.mdb"
	$cstr="Provider=Microsoft.Jet.OLEDB.4.0;Data Source="+$dbFile
	$sysName="Engagement Services Management System"
	$shortSysName="ESMS"
	$sysURL="http://apps.phe.fs.fed.us/esms/"
	$mailServer="smtp1.fs.fed.us"

	$passPhrase="Pas5pr@se"
	$saltValue="s@1tValue"
	$hashAlgorithm="SHA1"
	$passwordIterations=2
	$initVector="@1B2c3D4e5F6g7H8"
	$keySize=256
	$prefix="eNc"

	$strServerName="LDAP://dsphe.fs.fed.us:389/"
	$strBaseDN="OU=_DSPHE_FOREST_SERVICE,DC=dsphe,DC=fs,DC=fed,DC=us"
	$bindDN="svc_esms_vicexport"
	$bindPWD="Ce7gy3#goo7o"
	$ADUsersGroup="FS_ESMS_Users"
	$ADAdminsGroup="FS_ESMS_Admins"
	$ADSuperGroup="FS_ESMS_Super"
	$ADWoDUsersGroup="FS_ESMS_WoD_Users"
	$ADWoDAdminsGroup="FS_ESMS_WoD_Admins"
	$dnsSearchOrder="dsphe.fs.fed.us,phe.fs.fed.us,dsprp.fs.fed.us,prp.fs.fed.us,dsqa.fs.fed.us,qa.fs.fed.us,r3.fs.fed.us,fs.fed.us"
	if ( $Args[1] -eq "DEV" )
	{
		$cstr="Provider=Microsoft.Jet.OLEDB.4.0;Data Source=c:\inetpub\esms\ems_db.mdb"
		$sysURL="http://sxpheiis003.fs.fed.us/esms/"
	}
}

if ( $mode -eq "ABQDC-DEV" )
{
	$dbFile="$path\ems_db.mdb"
	$cstr="Provider=Microsoft.Jet.OLEDB.4.0;Data Source="+$dbFile
	$sysName="Engagement Services Management System"
	$shortSysName="ESMS-ABQDEV"
	$sysURL="http://sxpheiis003.fs.fed.us/esms-abqdc/"
	$mailServer="smtp1.fs.fed.us"

	$passPhrase="Pas5pr@se"
	$saltValue="s@1tValue"
	$hashAlgorithm="SHA1"
	$passwordIterations=2
	$initVector="@1B2c3D4e5F6g7H8"
	$keySize=256
	$prefix="eNc"

	$strServerName="LDAP://dsphe.fs.fed.us:389/"
	$strBaseDN="OU=_DSPHE_FOREST_SERVICE,DC=dsphe,DC=fs,DC=fed,DC=us"
	$bindDN="svc_esms_vicexport"
	$bindPWD="Ce7gy3#goo7o"
	$ADUsersGroup="FS_ESMS_Users"
	$ADAdminsGroup="FS_ESMS_Admins"
	$ADSuperGroup="FS_ESMS_Super"
	$ADWoDUsersGroup="FS_ESMS_WoD_Users"
	$ADWoDAdminsGroup="FS_ESMS_WoD_Admins"
	$dnsSearchOrder="dsphe.fs.fed.us,phe.fs.fed.us,dsprp.fs.fed.us,prp.fs.fed.us,dsqa.fs.fed.us,qa.fs.fed.us,r3.fs.fed.us,fs.fed.us"
}

if ( $mode -eq "KCDC" )
{
	$dbFile="$path\ems_db.mdb"
	$cstr="Provider=Microsoft.Jet.OLEDB.4.0;Data Source="+$dbFile
	$sysName="Engagement Services Management System"
	$shortSysName="ESMS"
	$sysURL="http://apps.fs.fed.us/esms/"
	$mailServer="smtp1.fs.fed.us"

	$passPhrase="6ewACrA5"
	$saltValue="sasPU5ej"
	$hashAlgorithm="SHA1"
	$passwordIterations=2
	$initVector="@1B2c3D4e5F6g7H8"
	$keySize=256
	$prefix="eNc"

	$strServerName="LDAP://ds.fs.fed.us:389/"
	$strBaseDN="OU=_FOREST_SERVICE,DC=ds,DC=fs,DC=fed,DC=us"
	$bindDN="svc_esms_app"
	$bindPWD="wIehLAriAcB!"
	$ADUsersGroup="FS_ESMS_Users"
	$ADAdminsGroup="FS_ESMS_Admins"
	$ADSuperGroup="FS_ESMS_Super"
	$ADWoDUsersGroup="FS_ESMS_WoD_Users"
	$ADWoDAdminsGroup="FS_ESMS_WoD_Admins"
	$dnsSearchOrder="ds.fs.fed.us,mci.fs.fed.us,abq.fs.fed.us,fs.fed.us"
	if ( $Args[1] -eq "DEV" )
	{
		$cstr="Provider=Microsoft.Jet.OLEDB.4.0;Data Source=c:\inetpub\esms-nitc\ems_db.mdb"
		$sysURL="http://sxpheiis003.fs.fed.us/esms-nitc/"
	}
}

if ( $mode -eq "KCDC-DEV" )
{
	$dbFile="$path\ems_db.mdb"
	$cstr="Provider=Microsoft.Jet.OLEDB.4.0;Data Source="+$dbFile
	$sysName="Engagement Services Management System"
	$shortSysName="ESMS-KCDEV"
	$sysURL="http://sxpheiis003.fs.fed.us/esms-kcdc/"
	$mailServer="smtp1.fs.fed.us"

	$passPhrase="6ewACrA5"
	$saltValue="sasPU5ej"
	$hashAlgorithm="SHA1"
	$passwordIterations=2
	$initVector="@1B2c3D4e5F6g7H8"
	$keySize=256
	$prefix="eNc"

	$strServerName="LDAP://ds.fs.fed.us:389/"
	$strBaseDN="OU=_FOREST_SERVICE,DC=ds,DC=fs,DC=fed,DC=us"
	$bindDN="svc_esms_app"
	$bindPWD="wIehLAriAcB!"
	$ADUsersGroup="FS_ESMS_Users"
	$ADAdminsGroup="FS_ESMS_Admins"
	$ADSuperGroup="FS_ESMS_Super"
	$ADWoDUsersGroup="FS_ESMS_WoD_Users"
	$ADWoDAdminsGroup="FS_ESMS_WoD_Admins"
	$dnsSearchOrder="ds.fs.fed.us,mci.fs.fed.us,abq.fs.fed.us,fs.fed.us"
}

Function IsNullOrEmpty ([string]$str)
{
  if ( $str ) 
  {
     return $false
  }
  elseif ( $str -eq [DBNull]::Value )
  {
     return $true
  }
  else
  {
     return $true
  }
}

Function Read-EsmsDbDS ([string]$sql)
{
  $dat = New-Object -TypeName System.Data.DataSet
  $dat=[ESMS.esmsLibrary]::readDb($sql, $cstr)
  if ($dat.Tables.Count -gt 0)
  {
     if ( $dat.Tables[0].Rows.Count -ne 0 )
     {
        return $dat
     }
  }
}

Function Read-EsmsDbDT ([string]$sql)
{
  $dat = New-Object -TypeName System.Data.DataSet
  $dat=[ESMS.esmsLibrary]::readDb($sql, $cstr)
  if ($dat.Tables.Count -gt 0)
  {
     if ( $dat.Tables[0].Rows.Count -ne 0 )
     {
        return $dat.Tables[0]
     }
  }	
}

Function Write-EsmsDb ([string]$sql)
{
  [string]$result=""
  $result=[ESMS.esmsLibrary]::writeDb($sql, $cstr)
  return $result
}

Function Write-EsmsEncrypted ([string]$text)
{
  [string]$out=""
  $out=[ESMS.esmsLibrary]::Encrypt($text, $initVector, $saltValue, $passPhrase, $hashAlgorithm, $passwordIterations, $keySize, $prefix)
  return $out
}

Function Write-EsmsDecrypted ([string]$cipher)
{
  [string]$out=""
  $out=[ESMS.esmsLibrary]::Decrypt($cipher, $initVector, $saltValue, $passPhrase, $hashAlgorithm, $passwordIterations, $keySize, $prefix)
  return $out
}

Function Invoke-EsmsCompactDb ([string]$dbFile)
{
  [string]$out=""
  $out=[ESMS.esmsLibrary]::compactDB($dbFile)
  return $out
}

Function Write-EsmsExtractPDFText ([string]$filePath)
{
  [string]$outStr=""
  if (Test-Path $filePath)
  {
    $outStr=[ESMS.esmsLibrary]::ExtractText($filePath)
  }
  else
  {
    throw "ERROR: File not found at "+$filePath 
  }
  return $outStr
}

Function Write-EsmsSRSiteToDataSet ([string]$siteUrl)
{
  $outDt = New-Object -TypeName System.Data.DataTable
  if (Test-URL($siteUrl))
  {
    $outDt=[ESMS.esmsLibrary]::getSRDataSet($siteUrl)
  }
  else
  {
    throw "ERROR: Site not found at URL "+$siteUrl 
  }
  return $outDt  
}

Function Invoke-EsmsDnsLongLookup ([string]$hostname)
{
  $outColl = New-Object -TypeName System.Collections.Specialized.StringCollection
  if ($hostname.Length -gt 0 )
  {
    $outColl=[ESMS.esmsLibrary]::dnsLookup($hostname)
  }
  else
  {
    throw "ERROR: Invalid Hostname Entered "+$hostname
  }
  return $outColl
}

Function Invoke-EsmsDnsRevLookup ([string]$ipAddr)
{
  $outColl = New-Object -TypeName System.Collections.Specialized.StringCollection
  if ($ipAddr.Length -gt 0 )
  {
    $outColl=[ESMS.esmsLibrary]::dnsReverseLookup($ipAddr)
  }
  else
  {
    throw "ERROR: Invalid IP Address Entered "+$hostname
  }
  return $outColl
}

Function Invoke-EsmsDnsShortLookup ([string]$hostname)
{
  [string]$outStr=""
  if ($hostname.Length -gt 0 )
  {
    $outStr=[ESMS.esmsLibrary]::simpleDnsLookup($hostname)
  }
  else
  {
    throw "ERROR: Invalid Hostname Entered "+$hostname
  }
  return $outStr
}

Function Test-EsmsPing ([string]$ipAddr)
{
  [bool]$outStatus=$false
  if ($ipAddr.Length -gt 0 )
  {
    $outStatus=[ESMS.esmsLibrary]::doPing($ipAddr)
  }
  else
  {
    throw "ERROR: Invalid IP Address Entered "+$ipAddr
  }
  return $outStatus
}

Function Test-EsmsIsNumber ([string]$str)
{
  [bool]$outStatus=$false
  if ($str.Length -gt 0 )
  {
    $outStatus=[ESMS.esmsLibrary]::isNumber($str)
  }
  else
  {
    throw "ERROR: Invalid Argument Entered "+$str
  }
  return $outStatus
}

Function Write-EsmsBreakIp([string]$ipAddr)
{
  [string]$outStr=""
  if ($ipAddr.Length -gt 0 )
  {
    $outStr=[ESMS.esmsLibrary]::break_ip($ipAddr)
  }
  else
  {
    throw "ERROR: Invalid IP Address Entered "+$ipAddr
  }
  return $outStr
}

Function Write-EsmsFixIp([string]$zeroIpAddr)
{
  [string]$outStr=""
  if ($zeroIpAddr.Length -gt 0 )
  {
    $outStr=[ESMS.esmsLibrary]::fix_ip($zeroIpAddr)
  }
  else
  {
    throw "ERROR: Invalid Zero-Laden IP Address Entered "+$zeroIpAddr
  }
  return $outStr
}

Function Write-EsmsVmDiskSize([string]$str)
{
  [string]$outStr=""
  if ($str.Length -gt 0 )
  {
    $outStr=[ESMS.esmsLibrary]::fix_diskSize($str)
  }
  else
  {
    throw "ERROR: Invalid Argument Entered "+$str
  }
  return $outStr
}

Function Write-EsmsVmRam([string]$str)
{
  [string]$outStr=""
  if ($str.Length -gt 0 )
  {
    $outStr=[ESMS.esmsLibrary]::fix_ram($str)
  }
  else
  {
    throw "ERROR: Invalid Argument Entered "+$str
  }
  return $outStr
}

Function Write-EsmsHostnameFromFqdn([string]$str)
{
  [string]$outStr=""
  if ($str.Length -gt 0 )
  {
    $outStr=[ESMS.esmsLibrary]::fix_fqdn($str)
  }
  else
  {
    throw "ERROR: Invalid Argument Entered "+$str
  }
  return $outStr
}

Function Write-EsmsUnderscoreSpaces ([string]$str)
{
  [string]$outStr=""
  if ($str.Length -gt 0 )
  {
    $outStr=[ESMS.esmsLibrary]::fix_hostname($str)
  }
  else
  {
    throw "ERROR: Invalid Argument Entered "+$str
  }
  return $outStr
}

Function Write-EsmsVmOs([string]$str)
{
  [string]$outStr=""
  if ($str.Length -gt 0 )
  {
    $outStr=[ESMS.esmsLibrary]::fix_os($str)
  }
  else
  {
    throw "ERROR: Invalid Argument Entered "+$str
  }
  return $outStr
}

Function Write-EsmsStrToInt ([string]$str)
{
  [int]$outInt=0
  if ($str.Length -gt 0 )
  {
    $outStr=[ESMS.esmsLibrary]::fix_num($str)
  }
  else
  {
    throw "ERROR: Invalid Argument Entered "+$str
  }
  return $outInt
}

Function Write-EsmsToQueryStr ([string]$str)
{
  [string]$outStr=""
  if ($str.Length -gt 0 )
  {
    $outStr=[ESMS.esmsLibrary]::fixQueryStr($str)
  }
  else
  {
    throw "ERROR: Invalid Argument Entered "+$str
  }
  return $outStr
}

Function Write-EsmsFromQueryStr ([string]$str)
{
  [string]$outStr=""
  if ($str.Length -gt 0 )
  {
    $outStr=[ESMS.esmsLibrary]::unFixQueryStr($str)
  }
  else
  {
    throw "ERROR: Invalid Argument Entered "+$str
  }
  return $outStr
}

Function Write-EsmsCapitalize ([string]$str)
{
  [string]$outStr=""
  if ($str.Length -gt 0 )
  {
    $outStr=[ESMS.esmsLibrary]::capitalize($str)
  }
  else
  {
    throw "ERROR: Invalid Argument Entered "+$str
  }
  return $outStr
}

Function Write-EsmsFixAccess ([string]$str)
{
  [string]$outStr=""
  if ($str.Length -gt 0 )
  {
    $outStr=[ESMS.esmsLibrary]::fix_access($str)
  }
  else
  {
    throw "ERROR: Invalid Argument Entered "+$str
  }
  return $outStr
}

Function Write-EsmsFixCsv ([string]$str)
{
  [string]$outStr=""
  if ($str.Length -gt 0 )
  {
    $outStr=[ESMS.esmsLibrary]::fix_csv($str)
  }
  else
  {
    throw "ERROR: Invalid Argument Entered "+$str
  }
  return $outStr
}

Function Write-EsmsFixTxt ([string]$str)
{
  [string]$outStr=""
  if ($str.Length -gt 0 )
  {
    $outStr=[ESMS.esmsLibrary]::fix_txt($str)
  }
  else
  {
    throw "ERROR: Invalid Argument Entered "+$str
  }
  return $outStr
}

Function Write-EsmsAsteriskTxt ([string]$str)
{
  [string]$outStr=""
  if ($str.Length -gt 0 )
  {
    $outStr=[ESMS.esmsLibrary]::hide_txt($str)
  }
  else
  {
    throw "ERROR: Invalid Argument Entered "+$str
  }
  return $outStr
}

Function Write-EsmsRemoveSpaces ([string]$str)
{
  [string]$outStr=""
  if ($str.Length -gt 0 )
  {
    $outStr=[ESMS.esmsLibrary]::removeSpaces($str)
  }
  else
  {
    throw "ERROR: Invalid Argument Entered "+$str
  }
  return $outStr
}

Function Write-EsmsSpaceDelimToCommaDelim ([string]$str)
{
  [string]$outStr=""
  if ($str.Length -gt 0 )
  {
    $outStr=[ESMS.esmsLibrary]::spaceDelim_to_commaDelim($str)
  }
  else
  {
    throw "ERROR: Invalid Argument Entered "+$str
  }
  return $outStr
}

Function Write-EsmsTruncate ([string]$str, [int]$strLen)
{
  [string]$outStr=""
  if ($str.Length -gt 0 )
  {
    $outStr=[ESMS.esmsLibrary]::short_hostname($str, $strLen)
  }
  else
  {
    throw "ERROR: Invalid Argument Entered "+$str
  }
  return $outStr
}

Function Write-EsmsSqlToText([string]$str)
{
  [string]$outStr=""
  if ($str.Length -gt 0 )
  {
    $outStr=[ESMS.esmsLibrary]::sql2txt($str)
  }
  else
  {
    throw "ERROR: Invalid Argument Entered "+$str
  }
  return $outStr
}

Function Write-EsmsStripHtml([string]$str)
{
  [string]$outStr=""
  if ($str.Length -gt 0 )
  {
    $outStr=[ESMS.esmsLibrary]::stripCode($str)
  }
  else
  {
    throw "ERROR: Invalid Argument Entered "+$str
  }
  return $outStr
}

Function Convert-EsmsSortDS([System.Data.DataSet]$dset, [string]$sortOn, [string]$order)
{
  $outDat = New-Object -TypeName System.Data.DataSet
  if (($sortOn.Length -gt 0) -and ($order.Length -gt 0))
  {
    $outStr=[ESMS.esmsLibrary]::sortDS($dset, $sortOn, $order)
  }
  else
  {
    throw "ERROR: Invalid Argument Entered "+$sortOn+" , "+$order
  }
  return $outDat
}

Function Convert-EsmsSortDT([System.Data.DataTable]$dtable,[string]$sortOn, [string]$order)
{
  $outDt = New-Object -TypeName System.Data.DataTable
  if ($hostname.Length -gt 0 )
  {
    $outStr=[ESMS.esmsLibrary]::sortDT($dtable, $sortOn, $order)
  }
  else
  {
    throw "ERROR: Invalid Argument Entered "+$sortOn+" , "+$order
  }
  return $outDt
}

Function Test-URL ([string]$siteUrl)
{
  $webclient = New-Object Net.WebClient
  $webclient.Credentials = [System.Net.CredentialCache]::DefaultCredential
  $webclient.DownloadString($siteUrl) | Out-Null
}
