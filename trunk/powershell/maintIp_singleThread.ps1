##################################################
#                                                #
# ESMS Powershell IP Audit Script                #
#                                                #
#   Desc: Audits IP Addresses for all subnets	 #
#         via NSLOOKUP and PING requests,        #
#         single-threaded batch.                 #
# Author: Chris Knight                           #
#   Date: 5/30/12                                #
#                                                #
##################################################

## C:\Inetpub\ESMS-ABQDC\powershell\maintIp_singleThread.ps1
##
## This brings the ESMS.esmsLibrary class into our Powershell session. 
## All STATIC properties and methods from esmsLibrary.cs can be used in PowerShell
Import-Module c:\inetpub\ESMS-ABQDC\powershell\Get-EsmsLibrary.psm1 -ArgumentList 'ABQDC-DEV'

$date = Get-Date
$startTime = $date.Hour.ToString() + $date.Minute.ToString() + $date.Second.ToString()
$maxThreads=10
$SleepTimer=500
$i=0

DEL c:\inetpub\ESMS-ABQDC\log\ipMaint_*.log

$dat = New-Object -TypeName System.Data.DataTable
$sql="SELECT name FROM subnets"
$dat=Read-EsmsDbDT($sql)
if ($dat -ne $null)
{
   $total=$dat.Count
   foreach ($dr in $dat)
   {
      $net=$dr["name"]
      C:\Inetpub\ESMS-ABQDC\powershell\auditSubnet.ps1 $net
   }
}

$date = Get-Date
$endTime = $date.Hour.ToString() + $date.Minute.ToString() + $date.Second.ToString()

Write-Host "(" $total ") - Start: " $startTime "  /  End: " $endTime