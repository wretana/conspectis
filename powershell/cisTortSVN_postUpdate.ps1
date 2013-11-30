set-executionpolicy Unrestricted -scope currentuser

if ($args[0]) { $rev = $args[0] }
if ($args[1]) { $esmsPath = $args[1] }

$date=svn info http://zlphenag001.phe.fs.fed.us/svn/ESMSv3/trunk | find "Last Changed Date:" | %{$_ -replace "Last Changed Date:"," "}
$date=$date.Trim()
$date=$date.Substring(0,10)

get-content $esmsPath\closer.inc | %{$_ -replace "-=.*=-","-= Version 3.0 svn $rev ($date) =-"} | Out-File -encoding ASCII -append $esmsPath\closer.tmp
mv $esmsPath\closer.tmp $esmsPath\closer.inc -force

$x= get-content $esmsPath\web.config | Select-String "systemURL"

if ($x.ToString().Contains("http://apps.phe.fs.fed.us")) ## Auto-PostInstall for ABQDC
{
	del $esmsPath\esmsLibrary.cs
	cp $esmsPath\esmsLibrary_fs.cs $esmsPath\esmsLibrary.cs
	del $esmsPath\web.config
	cp $esmsPath\webconfig.phe $esmsPath\web.config
	del $esmsPath\header.inc
	cp $esmsPath\header_abqdc.inc $esmsPath\header.inc
	del $esmsPath\adAuth.aspx
	cp $esmsPath\adAuth_abqdc.aspx $esmsPath\adAuth.aspx
	del $esmsPath\adminServers.aspx
	cp $esmsPath\adminServers_abqdc.aspx $esmsPath\adminServers.aspx
	del $esmsPath\default.aspx
	cp $esmsPath\default_abqdc.aspx $esmsPath\default.aspx
	del $esmsPath\editHardware.aspx
	cp $esmsPath\editHardware_abqdc.aspx $esmsPath\editHardware.aspx
	del $esmsPath\editRoles.aspx
	cp $esmsPath\editRoles_abqdc.aspx $esmsPath\editRoles.aspx
	del $esmsPath\editServer.aspx
	cp $esmsPath\editServer_abqdc.aspx $esmsPath\editServer.aspx
	del $esmsPath\hardware.aspx
	cp $esmsPath\hardware_abqdc.aspx $esmsPath\hardware.aspx
	del $esmsPath\newBladeCenter.aspx
	cp $esmsPath\newBladeCenter_abqdc.aspx $esmsPath\newBladeCenter.aspx
	del $esmsPath\newEntity.aspx
	cp $esmsPath\newEntity_abqdc.aspx $esmsPath\newEntity.aspx
	del $esmsPath\newHardware.aspx
	cp $esmsPath\newHardware_abqdc.aspx $esmsPath\newHardware.aspx
	del $esmsPath\newServer.aspx
	cp $esmsPath\newServer_abqdc.aspx $esmsPath\newServer.aspx
	del $esmsPath\portAssign.aspx
	cp $esmsPath\portAssign_abqdc.aspx $esmsPath\portAssign.aspx
	del $esmsPath\provision.aspx
	cp $esmsPath\provision_abqdc.aspx $esmsPath\provision.aspx
	del $esmsPath\recycleServer.aspx
	cp $esmsPath\recycleServer_abqdc.aspx $esmsPath\recycleServer.aspx
	del $esmsPath\showServer.aspx
	cp $esmsPath\showServer_abqdc.aspx $esmsPath\showServer.aspx
	del $esmsPath\vmware\ESMS-VICExport.ps1
	cp $esmsPath\vmware\ESMS-VICExport-abqdc.ps1 $esmsPath\vmware\ESMS-VICExport.ps1
	del $esmsPath\powershell\esmsPsTemplate.ps1
	cp $esmsPath\powershell\esmsPsTemplate-ABQDC.ps1 $esmsPath\powershell\esmsPsTemplate.ps1
	del $esmsPath\powershell\maintIp_multiThread.ps1
	cp $esmsPath\powershell\maintIp_multiThread_ABQDC.ps1 $esmsPath\powershell\maintIp_multiThread.ps1
	del $esmsPath\powershell\maintIp_singleThread.ps1
	cp $esmsPath\powershell\maintIp_singleThread_ABQDC.ps1 $esmsPath\powershell\maintIp_singleThread.ps1
	del $esmsPath\powershell\auditSubnet.ps1
	cp $esmsPath\powershell\auditSubnet_ABQDC.ps1 $esmsPath\powershell\auditSubnet.ps1
	Get-Content $esmsPath\sched\SchedESMS_Daily.bat | Foreach-Object {$_ -replace '^set esmsDir=.+$',"set esmsDir=$esmsPath\" } | Out-File -encoding ASCII -append $esmsPath\sched\SchedESMS_Daily.tmp 
	mv $esmsPath\sched\SchedESMS_Daily.tmp $esmsPath\sched\SchedESMS_Daily.bat -force
	Get-Content $esmsPath\sched\SchedESMS_Daily.bat | Foreach-Object {$_ -replace '^set esmsUrl=.+$',"set esmsUrl=http://localhost/esms/" } | Out-File -encoding ASCII -append $esmsPath\sched\SchedESMS_Daily.tmp
	mv $esmsPath\sched\SchedESMS_Daily.tmp $esmsPath\sched\SchedESMS_Daily.bat -force
	Get-Content $esmsPath\sched\SchedESMS_Weekly.bat | Foreach-Object {$_ -replace '^set esmsDir=.+$',"set esmsDir=$esmsPath\" } | Out-File -encoding ASCII -append $esmsPath\sched\SchedESMS_Weekly.tmp
	mv $esmsPath\sched\SchedESMS_Weekly.tmp $esmsPath\sched\SchedESMS_Weekly.bat -force
	Get-Content $esmsPath\sched\SchedESMS_Weekly.bat | Foreach-Object {$_ -replace '^set esmsUrl=.+$',"set esmsUrl=http://localhost/esms/" } | Out-File -encoding ASCII -append $esmsPath\sched\SchedESMS_Weekly.tmp
	mv $esmsPath\sched\SchedESMS_Weekly.tmp $esmsPath\sched\SchedESMS_Weekly.bat -force
	Get-Content $esmsPath\vmware\ESMS-VICExport.ps1 | Foreach-Object {$_ -replace '^\$filepath =.+$',"`$filepath =`"$esmsPath\vmware\import\`"" } | Out-File -encoding ASCII -append $esmsPath\vmware\ESMS-VICExport.tmp
	mv $esmsPath\vmware\ESMS-VICExport.tmp $esmsPath\vmware\ESMS-VICExport.ps1 -force
	Get-Content $esmsPath\powershell\Get-EsmsLibrary.psm1 | Foreach-Object {$_ -replace '^\$path=.+$',"`$path=`"$esmsPath`"" } | Out-File -encoding ASCII -append $esmsPath\powershell\Get-EsmsLibrary.tmp
	mv $esmsPath\powershell\Get-EsmsLibrary.tmp $esmsPath\powershell\Get-EsmsLibrary.psm1 -force
}
if ($x.ToString().Contains("http://apps.fs.fed.us")) ## Auto-PostInstall for KCDC
{
	del $esmsPath\esmsLibrary.cs
	cp $esmsPath\esmsLibrary_fs.cs $esmsPath\esmsLibrary.cs
	del $esmsPath\web.config
	cp $esmsPath\webconfig.prod $esmsPath\web.config
	del $esmsPath\header.inc
	cp $esmsPath\header_kcdc.inc $esmsPath\header.inc
	del $esmsPath\adAuth.aspx
	cp $esmsPath\adAuth_kcdc.aspx $esmsPath\adAuth.aspx
	del $esmsPath\adminServers.aspx
	cp $esmsPath\adminServers_kcdc.aspx $esmsPath\adminServers.aspx
	del $esmsPath\default.aspx
	cp $esmsPath\default_kcdc.aspx $esmsPath\default.aspx
	del $esmsPath\editHardware.aspx
	cp $esmsPath\editHardware_kcdc.aspx $esmsPath\editHardware.aspx
	del $esmsPath\editRoles.aspx
	cp $esmsPath\editRoles_kcdc.aspx $esmsPath\editRoles.aspx
	del $esmsPath\editServer.aspx
	cp $esmsPath\editServer_kcdc.aspx $esmsPath\editServer.aspx
	del $esmsPath\hardware.aspx
	cp $esmsPath\hardware_kcdc.aspx $esmsPath\hardware.aspx
	del $esmsPath\newBladeCenter.aspx
	cp $esmsPath\newBladeCenter_kcdc.aspx $esmsPath\newBladeCenter.aspx
	del $esmsPath\newEntity.aspx
	cp $esmsPath\newEntity_kcdc.aspx $esmsPath\newEntity.aspx
	del $esmsPath\newHardware.aspx
	cp $esmsPath\newHardware_kcdc.aspx $esmsPath\newHardware.aspx
	del $esmsPath\newServer.aspx
	cp $esmsPath\newServer_kcdc.aspx $esmsPath\newServer.aspx
	del $esmsPath\portAssign.aspx
	cp $esmsPath\portAssign_kcdc.aspx $esmsPath\portAssign.aspx
	del $esmsPath\provision.aspx
	cp $esmsPath\provision_kcdc.aspx $esmsPath\provision.aspx
	del $esmsPath\recycleServer.aspx
	cp $esmsPath\recycleServer_kcdc.aspx $esmsPath\recycleServer.aspx
	del $esmsPath\showServer.aspx
	cp $esmsPath\showServer_kcdc.aspx $esmsPath\showServer.aspx
	del $esmsPath\vmware\ESMS-VICExport.ps1
	cp $esmsPath\vmware\ESMS-VICExport-kcdc.ps1 $esmsPath\vmware\ESMS-VICExport.ps1
	del $esmsPath\powershell\esmsPsTemplate.ps1
	cp $esmsPath\powershell\esmsPsTemplate-KCDC.ps1 $esmsPath\powershell\esmsPsTemplate.ps1
	del $esmsPath\powershell\maintIp_multiThread.ps1
	cp $esmsPath\powershell\maintIp_multiThread_KCDC.ps1 $esmsPath\powershell\maintIp_multiThread.ps1
	del $esmsPath\powershell\maintIp_singleThread.ps1
	cp $esmsPath\powershell\maintIp_singleThread_KCDC.ps1 $esmsPath\powershell\maintIp_singleThread.ps1
	del $esmsPath\powershell\auditSubnet.ps1
	cp $esmsPath\powershell\auditSubnet_KCDC.ps1 $esmsPath\powershell\auditSubnet.ps1
	Get-Content $esmsPath\sched\SchedESMS_Daily.bat | Foreach-Object {$_ -replace '^set esmsDir=.+$',"set esmsDir=$esmsPath\" } | Out-File -encoding ASCII -append $esmsPath\sched\SchedESMS_Daily.tmp
	mv $esmsPath\sched\SchedESMS_Daily.tmp $esmsPath\sched\SchedESMS_Daily.bat -force
	Get-Content $esmsPath\sched\SchedESMS_Daily.bat | Foreach-Object {$_ -replace '^set esmsUrl=.+$',"set esmsUrl=http://localhost/esms/" } | Out-File -encoding ASCII -append $esmsPath\sched\SchedESMS_Daily.tmp
	mv $esmsPath\sched\SchedESMS_Daily.tmp $esmsPath\sched\SchedESMS_Daily.bat -force
	Get-Content $esmsPath\sched\SchedESMS_Weekly.bat | Foreach-Object {$_ -replace '^set esmsDir=.+$',"set esmsDir=$esmsPath\" } | Out-File -encoding ASCII -append $esmsPath\sched\SchedESMS_Weekly.tmp
	mv $esmsPath\sched\SchedESMS_Weekly.tmp $esmsPath\sched\SchedESMS_Weekly.bat -force
	Get-Content $esmsPath\sched\SchedESMS_Weekly.bat | Foreach-Object {$_ -replace '^set esmsUrl=.+$',"set esmsUrl=http://localhost/esms/" } | Out-File -encoding ASCII -append $esmsPath\sched\SchedESMS_Weekly.tmp
	mv $esmsPath\sched\SchedESMS_Weekly.tmp $esmsPath\sched\SchedESMS_Weekly.bat -force
	Get-Content $esmsPath\vmware\ESMS-VICExport.ps1 | Foreach-Object {$_ -replace '^\$filepath =.+$',"`$filepath =`"$esmsPath\vmware\import\`"" } | Out-File -encoding ASCII -append $esmsPath\vmware\ESMS-VICExport.tmp
	mv $esmsPath\vmware\ESMS-VICExport.tmp $esmsPath\vmware\ESMS-VICExport.ps1 -force
	Get-Content $esmsPath\powershell\Get-EsmsLibrary.psm1 | Foreach-Object {$_ -replace '^\$path=.+$',"`$path=`"$esmsPath`"" } | Out-File -encoding ASCII -append $esmsPath\powershell\Get-EsmsLibrary.tmp
	mv $esmsPath\powershell\Get-EsmsLibrary.tmp $esmsPath\powershell\Get-EsmsLibrary.psm1 -force
}

if ($x.ToString().Contains("esms-abqdc"))  ## Auto-PostInstall for ABQDC-DEV
{
	del $esmsPath\esmsLibrary.cs
	cp $esmsPath\esmsLibrary_fs.cs $esmsPath\esmsLibrary.cs
	del $esmsPath\web.config
	cp $esmsPath\webconfig.abqdev $esmsPath\web.config
	del $esmsPath\header.inc
	cp $esmsPath\header_abqdev.inc $esmsPath\header.inc
	del $esmsPath\adAuth.aspx
	cp $esmsPath\adAuth_abqdc.aspx $esmsPath\adAuth.aspx
	del $esmsPath\adminServers.aspx
	cp $esmsPath\adminServers_abqdc.aspx $esmsPath\adminServers.aspx
	del $esmsPath\default.aspx
	cp $esmsPath\default_abqdc.aspx $esmsPath\default.aspx
	del $esmsPath\editHardware.aspx
	cp $esmsPath\editHardware_abqdc.aspx $esmsPath\editHardware.aspx
	del $esmsPath\editRoles.aspx
	cp $esmsPath\editRoles_abqdc.aspx $esmsPath\editRoles.aspx
	del $esmsPath\editServer.aspx
	cp $esmsPath\editServer_abqdc.aspx $esmsPath\editServer.aspx
	del $esmsPath\hardware.aspx
	cp $esmsPath\hardware_abqdc.aspx $esmsPath\hardware.aspx
	del $esmsPath\newBladeCenter.aspx
	cp $esmsPath\newBladeCenter_abqdc.aspx $esmsPath\newBladeCenter.aspx
	del $esmsPath\newEntity.aspx
	cp $esmsPath\newEntity_abqdc.aspx $esmsPath\newEntity.aspx
	del $esmsPath\newHardware.aspx
	cp $esmsPath\newHardware_abqdc.aspx $esmsPath\newHardware.aspx
	del $esmsPath\newServer.aspx
	cp $esmsPath\newServer_abqdc.aspx $esmsPath\newServer.aspx
	del $esmsPath\portAssign.aspx
	cp $esmsPath\portAssign_abqdc.aspx $esmsPath\portAssign.aspx
	del $esmsPath\provision.aspx
	cp $esmsPath\provision_abqdc.aspx $esmsPath\provision.aspx
	del $esmsPath\recycleServer.aspx
	cp $esmsPath\recycleServer_abqdc.aspx $esmsPath\recycleServer.aspx
	del $esmsPath\showServer.aspx
	cp $esmsPath\showServer_abqdc.aspx $esmsPath\showServer.aspx
	del $esmsPath\vmware\ESMS-VICExport.ps1
	cp $esmsPath\vmware\ESMS-VICExport-abqdc.ps1 $esmsPath\vmware\ESMS-VICExport.ps1
	del $esmsPath\powershell\esmsPsTemplate.ps1
	cp $esmsPath\powershell\esmsPsTemplate-ABQDC-DEV.ps1 $esmsPath\powershell\esmsPsTemplate.ps1
	del $esmsPath\powershell\maintIp_multiThread.ps1
	cp $esmsPath\powershell\maintIp_multiThread_ABQDC-DEV.ps1 $esmsPath\powershell\maintIp_multiThread.ps1
	del $esmsPath\powershell\maintIp_singleThread.ps1
	cp $esmsPath\powershell\maintIp_singleThread_ABQDC-DEV.ps1 $esmsPath\powershell\maintIp_singleThread.ps1
	del $esmsPath\powershell\auditSubnet.ps1
	cp $esmsPath\powershell\auditSubnet_ABQDC-DEV.ps1 $esmsPath\powershell\auditSubnet.ps1
	Get-Content $esmsPath\sched\SchedESMS_Daily.bat | Foreach-Object {$_ -replace '^set esmsDir=.+$',"set esmsDir=$esmsPath\" } | Out-File -encoding ASCII -append $esmsPath\sched\SchedESMS_Daily.tmp
	mv $esmsPath\sched\SchedESMS_Daily.tmp $esmsPath\sched\SchedESMS_Daily.bat -force
	Get-Content $esmsPath\sched\SchedESMS_Daily.bat | Foreach-Object {$_ -replace '^set esmsUrl=.+$',"set esmsUrl=http://localhost/esms-abqdc/" } | Out-File -encoding ASCII -append $esmsPath\sched\SchedESMS_Daily.tmp
	mv $esmsPath\sched\SchedESMS_Daily.tmp $esmsPath\sched\SchedESMS_Daily.bat -force
	Get-Content $esmsPath\sched\SchedESMS_Weekly.bat | Foreach-Object {$_ -replace '^set esmsDir=.+$',"set esmsDir=$esmsPath\" } | Out-File -encoding ASCII -append $esmsPath\sched\SchedESMS_Weekly.tmp
	mv $esmsPath\sched\SchedESMS_Weekly.tmp $esmsPath\sched\SchedESMS_Weekly.bat -force
	Get-Content $esmsPath\sched\SchedESMS_Weekly.bat | Foreach-Object {$_ -replace '^set esmsUrl=.+$',"set esmsUrl=http://localhost/esms-abqdc/" } | Out-File -encoding ASCII -append $esmsPath\sched\SchedESMS_Weekly.tmp
	mv $esmsPath\sched\SchedESMS_Weekly.tmp $esmsPath\sched\SchedESMS_Weekly.bat -force
	Get-Content $esmsPath\vmware\ESMS-VICExport.ps1 | Foreach-Object {$_ -replace '^\$filepath =.+$',"`$filepath =`"$esmsPath\vmware\import\`"" } | Out-File -encoding ASCII -append $esmsPath\vmware\ESMS-VICExport.tmp
	mv $esmsPath\vmware\ESMS-VICExport.tmp $esmsPath\vmware\ESMS-VICExport.ps1 -force
	Get-Content $esmsPath\powershell\Get-EsmsLibrary.psm1 | Foreach-Object {$_ -replace '^\$path=.+$',"`$path=`"$esmsPath`"" } | Out-File -encoding ASCII -append $esmsPath\powershell\Get-EsmsLibrary.tmp
	mv $esmsPath\powershell\Get-EsmsLibrary.tmp $esmsPath\powershell\Get-EsmsLibrary.psm1 -force
}

if ($x.ToString().Contains("esms-kcdc")) ## Auto-PostInstall for KCDC-DEV
{
	del $esmsPath\esmsLibrary.cs
	cp $esmsPath\esmsLibrary_fs.cs $esmsPath\esmsLibrary.cs
	del $esmsPath\web.config
	cp $esmsPath\webconfig.kcdev $esmsPath\web.config
	del $esmsPath\header.inc
	cp $esmsPath\header_kcdev.inc $esmsPath\header.inc
	del $esmsPath\adAuth.aspx
	cp $esmsPath\adAuth_kcdc.aspx $esmsPath\adAuth.aspx
	del $esmsPath\adminServers.aspx
	cp $esmsPath\adminServers_kcdc.aspx $esmsPath\adminServers.aspx
	del $esmsPath\default.aspx
	cp $esmsPath\default_kcdc.aspx $esmsPath\default.aspx
	del $esmsPath\editHardware.aspx
	cp $esmsPath\editHardware_kcdc.aspx $esmsPath\editHardware.aspx
	del $esmsPath\editRoles.aspx
	cp $esmsPath\editRoles_kcdc.aspx $esmsPath\editRoles.aspx
	del $esmsPath\editServer.aspx
	cp $esmsPath\editServer_kcdc.aspx $esmsPath\editServer.aspx
	del $esmsPath\hardware.aspx
	cp $esmsPath\hardware_kcdc.aspx $esmsPath\hardware.aspx
	del $esmsPath\newBladeCenter.aspx
	cp $esmsPath\newBladeCenter_kcdc.aspx $esmsPath\newBladeCenter.aspx
	del $esmsPath\newEntity.aspx
	cp $esmsPath\newEntity_kcdc.aspx $esmsPath\newEntity.aspx
	del $esmsPath\newHardware.aspx
	cp $esmsPath\newHardware_kcdc.aspx $esmsPath\newHardware.aspx
	del $esmsPath\newServer.aspx
	cp $esmsPath\newServer_kcdc.aspx $esmsPath\newServer.aspx
	del $esmsPath\portAssign.aspx
	cp $esmsPath\portAssign_kcdc.aspx $esmsPath\portAssign.aspx
	del $esmsPath\provision.aspx
	cp $esmsPath\provision_kcdc.aspx $esmsPath\provision.aspx
	del $esmsPath\recycleServer.aspx
	cp $esmsPath\recycleServer_kcdc.aspx $esmsPath\recycleServer.aspx
	del $esmsPath\showServer.aspx
	cp $esmsPath\showServer_kcdc.aspx $esmsPath\showServer.aspx
	del $esmsPath\vmware\ESMS-VICExport.ps1
	cp $esmsPath\vmware\ESMS-VICExport-kcdc.ps1 $esmsPath\vmware\ESMS-VICExport.ps1
	del $esmsPath\powershell\esmsPsTemplate.ps1
	cp $esmsPath\powershell\esmsPsTemplate-KCDC-DEV.ps1 $esmsPath\powershell\esmsPsTemplate.ps1
	del $esmsPath\powershell\maintIp_multiThread.ps1
	cp $esmsPath\powershell\maintIp_multiThread_KCDC-DEV.ps1 $esmsPath\powershell\maintIp_multiThread.ps1
	del $esmsPath\powershell\maintIp_singleThread.ps1
	cp $esmsPath\powershell\maintIp_singleThread_KCDC-DEV.ps1 $esmsPath\powershell\maintIp_singleThread.ps1
	del $esmsPath\powershell\auditSubnet.ps1
	cp $esmsPath\powershell\auditSubnet_KCDC-DEV.ps1 $esmsPath\powershell\auditSubnet.ps1
	Get-Content $esmsPath\sched\SchedESMS_Daily.bat | Foreach-Object {$_ -replace '^set esmsDir=.+$',"set esmsDir=$esmsPath\" } | Out-File -encoding ASCII -append $esmsPath\sched\SchedESMS_Daily.tmp
	mv $esmsPath\sched\SchedESMS_Daily.tmp $esmsPath\sched\SchedESMS_Daily.bat -force
	Get-Content $esmsPath\sched\SchedEsms_Daily.bat | Foreach-Object {$_ -replace '^set esmsUrl=.+$',"set esmsUrl=http://localhost/esms-kcdc/" } | Out-File -encoding ASCII -append $esmsPath\sched\SchedESMS_Daily.tmp
	mv $esmsPath\sched\SchedESMS_Daily.tmp $esmsPath\sched\SchedESMS_Daily.bat -force
	Get-Content $esmsPath\sched\SchedESMS_Weekly.bat | Foreach-Object {$_ -replace '^set esmsDir=.+$',"set esmsDir=$esmsPath\" } | Out-File -encoding ASCII -append $esmsPath\sched\SchedESMS_Weekly.tmp
	mv $esmsPath\sched\SchedESMS_Weekly.tmp $esmsPath\sched\SchedESMS_Weekly.bat -force
	Get-Content $esmsPath\sched\SchedESMS_Weekly.bat | Foreach-Object {$_ -replace '^set esmsUrl=.+$',"set esmsUrl=http://localhost/esms-kcdc/" } | Out-File -encoding ASCII -append $esmsPath\sched\SchedESMS_Weekly.tmp
	mv $esmsPath\sched\SchedESMS_Weekly.tmp $esmsPath\sched\SchedESMS_Weekly.bat -force
	Get-Content $esmsPath\vmware\ESMS-VICExport.ps1 | Foreach-Object {$_ -replace '^\$filepath =.+$',"`$filepath =`"$esmsPath\vmware\import\`"" } | Out-File -encoding ASCII -append $esmsPath\vmware\ESMS-VICExport.tmp
	mv $esmsPath\vmware\ESMS-VICExport.tmp $esmsPath\vmware\ESMS-VICExport.ps1 -force
	Get-Content $esmsPath\powershell\Get-EsmsLibrary.psm1 | Foreach-Object {$_ -replace '^\$path=.+$',"`$path=`"$esmsPath`"" } | Out-File -encoding ASCII -append $esmsPath\powershell\Get-EsmsLibrary.tmp
	mv $esmsPath\powershell\Get-EsmsLibrary.tmp $esmsPath\powershell\Get-EsmsLibrary.psm1 -force
}

[string]$sysX = get-content $esmsPath\web.config | Select-String "systemShortName"
$readS=$sysX.split('`"')

[string]$userX = get-content $esmsPath\web.config | Select-String "vic_user"
$readU=$userX.split('`"')

[string]$passX = get-content $esmsPath\web.config | Select-String "vic_pass"
$readP=$passX.split('`"')

[string]$TaskUser=$readU[3]
[string]$TaskPass=$readP[3]
$TaskHost = $env:computername

## [string]$TaskName=$readS[3]+" Daily Tasks"
## $TaskFile="$esmsPath\sched\SchedESMS_Daily.bat"
## $TaskRun = '\"' + $TaskFile + '\"'
## $TaskDays= "MON, TUE, WED, THU, FRI"

## [string]$TaskCheck = schtasks /query | Select-String $TaskName
## if ( $TaskCheck -ne "" )
## {
##    schtasks /Delete /TN $TaskName /F
## }
## schtasks /create /s $TaskHost /ru $TaskUser /rp $TaskPass /tn $TaskName /tr $TaskRun /sc weekly /d $TaskDays /st 04:00

## [string]$TaskName=$readS[3]+" Weekly Tasks"
## $TaskFile="$esmsPath\sched\SchedESMS_Weekly.bat"
## $TaskRun = '\"' + $TaskFile + '\"'
## $TaskDays= "SAT"

## [string]$TaskCheck = schtasks /query | Select-String $TaskName
## if ( $TaskCheck -ne "" )
## {
##    schtasks /Delete /TN $TaskName /F
## }
## schtasks /create /s $TaskHost /ru $TaskUser /rp $TaskPass /tn $TaskName /tr $TaskRun /sc weekly /d $TaskDays /st 08:00