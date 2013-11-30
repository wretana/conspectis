if (-not (Get-PSSnapin VMware.VimAutomation.Core -ErrorAction SilentlyContinue)) 
{
    Add-PSSnapin VMware.VimAutomation.Core
}
#Script REQUIRES vSphere PowerCLI 4.0.0 -- PowerCLI 4.0u1 brings major changes to get-snapshot so the script would need to be rewritten.

[void][Reflection.Assembly]::LoadWithPartialName("VMware.Vim")

[array] $vcsource = "","","","",""
[array] $vcuser = "","","","",""
[array] $vcpass = "","","","",""

$vcsource[0]= "clphevcs001.phe.fs.fed.us"
$vcuser[0] = "DSPHE\svc_esms_vicexport"
$vcpass[0] = "Ce7gy3#goo7o"

$vcsource[1]= "clphevcs002.phe.fs.fed.us"
$vcuser[1] = "DSPHE\svc_esms_vicexport"
$vcpass[1] = "Ce7gy3#goo7o"

$vcsource[2]= "clprpvcs001.prp.fs.fed.us"
$vcuser[2] = "DSPRP\svc_esms_vicexport"
$vcpass[2] = "Jug6j0@miebu"

$vcsource[3]= "cxqavcs001.qa.fs.fed.us"
$vcuser[3] = "DSQA\svc_esms_vicexport"
$vcpass[3] = "Si7WhaEaeaT7"

$vcsource[4]= "cxqavcs003.qa.fs.fed.us"
$vcuser[4] = "DSQA\svc_esms_vicexport"
$vcpass[4] = "Si7WhaEaeaT7"

$filepath ="C:\inetpub\ESMS-ABQDC\vmware\import\"
[string]$dir=Get-Location

$date = Get-Date
$datestamp = $date.Month.ToString() + $date.Day.ToString() + $date.Year.ToString() + "-" + $date.Hour.ToString() + $date.Minute.ToString() + $date.Second.ToString()
$starttime = $date.Hour.ToString() + $date.Minute.ToString() + $date.Second.ToString()
$ipguest = @{ Name = "IP Address"; Expression = { $_.Guest.IpAddress } }
$hostnameguest = @{ Name = "Hostname"; Expression = { $_.Guest.Hostname } }
$os = @{ Name = "OSFullName"; Expression = { $_.Guest.OSFullName } }
$vmtoolsguest = @{ Name = "VMToolsState"; Expression = { $_.Guest.State } }
$sysdiskguest = @{ Name = "SysDiskSize"; Expression = { $_.Guest.Disks[0].Capacity } }
$datadiskguest = @{ Name = "DataDiskSize"; Expression = { $_.Guest.Disks[1].Capacity } }
$eth0mac = @{ Name = "Eth0Mac"; Expression = { ($_ | Get-NetworkAdapter).MacAddress } } 
$Function = @{ Name = "Function/Role"; Expression = { $_.CustomFields.Item("Function / Role") } }
$Owner = @{ Name = "Owner"; Expression = { $_.CustomFields.Item("Owner") } }
$Project = @{ Name = "Project"; Expression = { $_.CustomFields.Item("Project") } }

$count=0
$arrLen=$vcsource.length

del $filepath"*.csv"

new-eventlog -LogName ESMS -Source ESMS-VICExport -ea SilentlyContinue


while ($count -lt $arrLen)
{
	$started = "Script started at "+$datestamp+" by "+$vcuser[$count]+ " for " +$vcsource[$count]
	write-eventlog -LogName ESMS -Source ESMS-VICExport -Message $started -EntryType Information -EventId 1111 -ea SilentlyContinue
	write-host $started
	$vcsource_file = $vcsource[$count].Split('.')[0]
	write-host "Querying " $vcsource[$count] " as" $vcuser[$count]
	Connect-VIServer $vcsource[$count] -User $vcuser[$count] -Password $vcpass[$count]

		#Create the Cluster CSV files, and write column headers
		$clusters = get-cluster
		foreach ($cluster in $clusters)
		{
			echo "`"Cluster`"~`"VmId`"~`"DataStore`"" >> $filepath$vcsource_file"-"$cluster".csv"
		}

		#Populate virtual cluster and datastore details for each vm name
		echo `r`n
		echo "Collecting Clusters & Datastores..."
		get-cluster | %{$cluster = $_; get-vm -Location $_ | %{$vm = $_; $vmid = $_.id; $ds = get-datastore -vm $_; echo "`"$cluster`"~`"$vmid`"~`"$ds`"" >> $filepath$vcsource_file"-"$cluster.csv ; write-host -NoNewline . }}
		get-datacenter | get-datastore | select Name, CapacityMB, FreeSpaceMB | Sort-Object -Descending Name | export-csv $filepath$vcsource_file"-datastores.csv" -delimiter "~" -notype

		#Get the VM Hosts attached to this VIC and the Clusters to which they are attached 
		echo `r`n
		echo "Collecting VM Hosts..."
		get-vmhost | select Name, @{N="Cluster";E={Get-Cluster -VMHost $_}} | Sort Cluster | export-csv $filepath$vcsource_file"-hosts.csv" -delimiter "~" -notype

		#Get the rest of the base VM details
		echo `r`n
		echo "Collecting VMs..."
		Get-VM | select Id, Name, VMHost, $ipguest, $hostnameguest, $os, $vmtoolsguest, $sysdiskguest, $datadiskguest, $eth0mac, MemoryMB, numCPU, PowerState, $Function, $Owner, $Project -ea SilentlyContinue | export-csv $filepath$vcsource_file"-vms.csv" -delimiter "~" -notype

		#Get the Snapshots
		echo `r`n
		echo "Collecting Snapshots..."
		Get-VM | Get-Snapshot | select Id, VM, Name, Created | export-csv $filepath$vcsource_file"-snaps.csv" -delimiter "~" -notype
		Get-VM | ../vmware/getsnapshotsize.ps1 | select Id, SizeMB | export-csv $filepath$vcsource_file"-snapFileSize.csv" -delimiter "~" -notype

		#Get the VMTools and Disk Usage Details
		echo `r`n
		echo "Collecting VMTools and Disk Usage Details..."
		$MyCollection = @()
		$AllVMs = Get-View -ViewType VirtualMachine | Where {-not $_.Config.Template}
		$SortedVMs = $AllVMs | Select *, @{N="NumDisks";E={@($_.Guest.Disk.Length)}} | Sort-Object -Descending NumDisks
		ForEach ($VM in $SortedVMs)
		{
			$Details = New-object PSObject
			$Details | Add-Member -Name Name -Value $VM.name -Membertype NoteProperty
			$Details | Add-Member -Name FQDN -Value $VM.Guest.hostName -Membertype NoteProperty
			$Details | Add-Member -Name ToolsVer -Value $VM.Config.Tools.ToolsVersion -Membertype NoteProperty
			$DiskNum = 0
			Foreach ($disk in $VM.Guest.Disk)
			{
				$Details | Add-Member -Name "Disk$($DiskNum)path" -MemberType NoteProperty -Value $Disk.DiskPath
				$Details | Add-Member -Name "Disk$($DiskNum)Capacity(MB)" -MemberType NoteProperty -Value ([math]::Round($disk.Capacity/ 1MB))
				$Details | Add-Member -Name "Disk$($DiskNum)FreeSpace(MB)" -MemberType NoteProperty -Value ([math]::Round($disk.FreeSpace / 1MB))
				$DiskNum++
			}
			$MyCollection += $Details
		}
		$MyCollection | export-csv $filepath$vcsource_file"-vmtools.csv" -delimiter "~" -notype
	Disconnect-VIServer -Confirm:$False 
	write-host "Done!"
	$date = Get-Date
	$datestamp = $date.Month.ToString() + $date.Day.ToString() + $date.Year.ToString() + "-" + $date.Hour.ToString() + $date.Minute.ToString() + $date.Second.ToString()
	$endtime = $date.Hour.ToString() + $date.Minute.ToString() + $date.Second.ToString()

	[int32] $elapsed = ([System.Convert]::ToInt32($endtime)-[System.Convert]::ToInt32($starttime))/60
	$finished = "Script completed at "+$datestamp+" by "+$vcuser[$count]+ "for " +$vcsource[$count]+ ". Elapsed Time: " +$elapsed.ToString()+ "m"
	write-host $finished
	write-eventlog -LogName ESMS -Source ESMS-VICExport -Message $finished -EntryType Information -EventId 2222 -ea SilentlyContinue
	$count++
}
write-host "Done!"
