##################################################
#                                                #
# ESMS Powershell IP Audit Script                #
#                                                #
#   Desc: Audits IP Addresses for all subnets	 #
#         via NSLOOKUP and PING requests,        #
#         supports multi-threading with a        #
#         default of 10 parallel threads.        #
#         NOTE: Requires Vista/ WS08!            #
#                                                #
# Author: Chris Knight                           #
#   Date: 5/30/12                                #
#                                                #
##################################################

## C:\Inetpub\ESMS-ABQDC\powershell\maintIp_multiThread.ps1
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
c:
cd \inetpub\ESMS-ABQDC\powershell

$dat = New-Object -TypeName System.Data.DataTable
$sql="SELECT name FROM subnets"
$dat=Read-EsmsDbDT($sql)
if ($dat -ne $null)
{
   $total=$dat.Count
   foreach ($dr in $dat)
   {
      While ($(Get-Job -state running).count -ge $MaxThreads) 
      {
         Write-Progress -Activity "Auditing IPs..." -Status "Waiting for Subnets to complete audit..." -CurrentOperation "$i threads created - $($(Get-Job -state running).count) threads open" -PercentComplete ($i / $dat.count * 100)
	 Start-Sleep -Milliseconds $SleepTimer
      }
      $i++
      $net=$dr["name"]
      Start-Job -FilePath .\auditSubnet.ps1 -Name $net -ArgumentList `'$net`'
      Write-Progress  -Activity "Auditing IPs..." -Status "Starting Audit Threads..." -CurrentOperation "$i threads created - $($(Get-Job -state running).count) threads open" -PercentComplete ($i / $dat.count * 100)
   }
}

$date = Get-Date
$endTime = $date.Hour.ToString() + $date.Minute.ToString() + $date.Second.ToString()

Write-Host "(" $total ") - Start: " $startTime "  /  End: " $endTime