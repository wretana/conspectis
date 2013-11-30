##########################################################
# Notice: This module requires PowerShell Version 2 CTP 3.
# CTP 1, CTP 2 and CTP 3 can be downloaded so make sure you have the right version.
##########################################################

######################################
### Type Definitions               ###
######################################
#region TypeDefinitions

# Thanks to Glenn Sizemore for figuring out how to add types.
$assemblyToReference = [reflection.assembly]::loadwithpartialname("vmware.vim").FullName
Add-Type -TypeDefinition @"
using VMware.Vim;

namespace VMware.TKE
{
    public class HostSoftwareIscsiImpl
    {
        #region private Paramaters

        private string _IScsiName;
        private string _IScsiAlias;
        private ManagedObjectReference _MoRef;
        private bool _IScsiEnabled;
        private HostInternetScsiHba _HBA;
        private HostInternetScsiHbaSendTarget[] _SendTarget;
        private HostInternetScsiHbaStaticTarget[] _StaticTarget;

        #endregion private Paramaters

        #region public Paramaters

        public string IScsiName
        {
            get
            {
                return this._IScsiName;
            }
            set
            {
                this._IScsiName = value;
            }
        }
        public string IScsiAlias
        {
            get
            {
                return this._IScsiAlias;
            }
            set
            {
                this._IScsiAlias = value;
            }
        }
        public ManagedObjectReference MoRef
        {
            get
            {
                return this._MoRef;
            }
            set
            {
                this._MoRef = value;
            }
        }
        public bool IScsiEnabled
        {
            get
            {
                return this._IScsiEnabled;
            }
            set
            {
                this._IScsiEnabled = value;
            }
        }
        public HostInternetScsiHba HBA
        {
            get
            {
                return this._HBA;
            }
            set
            {
                this._HBA = value;
            }
        }
        public HostInternetScsiHbaSendTarget[] SendTarget
        {
            get
            {
                return this._SendTarget;
            }
            set
            {
                this._SendTarget = value;
            }
        }
        public HostInternetScsiHbaStaticTarget[] StaticTarget
        {
            get
            {
                return this._StaticTarget;
            }
            set
            {
                this._StaticTarget = value;
            }
        }

        #endregion public Paramaters

        #region constructors

        public HostSoftwareIscsiImpl()
        {
            this._IScsiName = null;
            this._IScsiAlias = null;
            this._MoRef = null;
            this._IScsiEnabled = false;
            this._HBA = null;
            this._SendTarget = null;
            this._StaticTarget = null;
        }

        #endregion constructors
    }
}
"@ -ReferencedAssemblies $assemblyToReference -ea SilentlyContinue
#endregion

######################################
### Helper Functions               ###
######################################
#region HelperFunctions
# Invoke an internal method using the scheduled task trick.
Function Invoke-TkeInternalMethod {
	param ($description, $view, $action)

	# The ScheduledTaskManager is in the Service Instance.
	$si = get-view ServiceInstance
	$scheduledTaskManager = Get-View $si.Content.ScheduledTaskManager

	# Schedule a task far in the future to call this action.
	$scheduler = new-object VMware.Vim.OnceTaskScheduler
	$scheduler.runat = (get-date).addYears(5)
	$task = New-Object VMware.Vim.ScheduledTaskSpec
	$task.Action = $action
	$task.Description = $description
	$task.Enabled = $true
	$task.Name = "PowerCLI " + (Get-Random)
	$task.Scheduler = $scheduler
	$myTask = $scheduledTaskManager.CreateScheduledTask($view.MoRef, $task)
	$taskView = Get-View $myTask

	# Execute the task ahead of schedule.
	$taskView.RunScheduledTask()
	for ($i = 0; $i -lt 100; $i++) {
		Start-Sleep -Milliseconds 200
		$taskView = Get-View $myTask
		if ($taskView.activeTask -eq $null) {
			break
		}
	}
	$taskView.RemoveScheduledTask()
}

# Create a web client that ignores SSL certificate errors.
# This code comes to us courtesy of Stephen Campbell of Marchview Consultants, Ltd.
function New-TkeTrustAllHttpWebRequest {
	param(
	[string]$URL
	)

	# Create a compilation environment
	$Provider = New-Object Microsoft.CSharp.CSharpCodeProvider
	$Compiler = $Provider.CreateCompiler()
	$Params = New-Object System.CodeDom.Compiler.CompilerParameters
	$Params.GenerateExecutable=$False
	$Params.GenerateInMemory=$True
	$Params.IncludeDebugInformation=$False
	$Params.ReferencedAssemblies.Add("System.DLL") > $null
	$TASource = @'
	  namespace Local.ToolkitExtensions.Net.CertificatePolicy {
	    public class TrustAll : System.Net.ICertificatePolicy {
	      public TrustAll() { 
	      }
	      public bool CheckValidationResult(System.Net.ServicePoint sp,
	        System.Security.Cryptography.X509Certificates.X509Certificate cert, 
	        System.Net.WebRequest req, int problem) {
	        return true;
	      }
	    }
	  }
'@ 
	$TAResults = $Provider.CompileAssemblyFromSource($Params,$TASource)
	$TAAssembly = $TAResults.CompiledAssembly

	## We now create an instance of the TrustAll and attach it to the ServicePointManager
	$TrustAll = $TAAssembly.CreateInstance("Local.ToolkitExtensions.Net.CertificatePolicy.TrustAll")
	[System.Net.ServicePointManager]::CertificatePolicy=$TrustAll

	$WebRequest = [System.Net.WebRequest]::create($URL)
	$WebRequest.PreAuthenticate = $True;
	$WebRequest.Timeout = [System.Threading.Timeout]::Infinite;
	$WebRequest.AllowWriteStreamBuffering = $False
	$WebRequest.Method="PUT"

	return $WebRequest
}

function Select-Property {
    param(
        [Parameter(
            Mandatory=$true,
            ValueFromPipeline=$true
        )]
        [PSObject]
        $InputObject,

		[Parameter(
            Mandatory=$true
        )]
        [string]
        $Property
    )

	Process {
		Write-Output $InputObject.$Property
	}
}

# Replace text in an array of strings.
function Replace-StringArray {
	param($stringArray, $old, $new)

	return $stringArray | foreach { $_ -replace $old, $new }
}

# Parse a datastore path, returning the datastore name and file path.
function Extract-TkeDatastorePathElements {
	param(
	[string]$path
	)

	# Extract the subpath.
	if ($path -match "\[([^\]]+)\] (.+)") {
		$datastore = $matches[1]
		$dsPath = $matches[2]
		$ret = new-object psobject
		$ret | add-member -type NoteProperty -name "Datastore" -value $datastore
		$ret | add-member -type NoteProperty -name "Path" -value $dsPath

		return $ret
	} else {
		return $null
	}
}

# Determine if a given string is a datastore path.
function Is-TkeDatastorePath {
	param(
	[string]$path
	)

	if ((Extract-TkeDatastorePathElements -path $path) -ne $null) {
		return $true
	}
	return $false
}

# Given a VMX file, return the path to the VM.
function Get-TkeVMPath {
	param(
	[VMware.VimAutomation.Client20.VirtualMachineImpl]$vm
	)

	$vmView = $vm | get-view
	$vmxPath = $vmView.Config.Files.VmPathName

	# Extract the subpath.
	$extracted = Extract-TkeDatastorePathElements $vmxPath
	$vmPath = $extracted.Path

	# Determine the path to the log file.
	$vmPath -match "(.+/)[^/]+" > $null
	$vmDirectory = $matches[1]
	return $vmDirectory
}

# Parse a VMX file.
function Get-TkeVmxEntries {
	param(
	[String]$path
	)

	$ret = @()
	foreach ($line in (get-content $path)) {
		if ($line -match '([\S]+) = "([\S]+)"') {
			$lobj = new-object psobject
			$lobj | add-member -type noteproperty -name "Key" -value $matches[1]
			$lobj | add-member -type noteproperty -name "Value" -value $matches[2]
			$ret += $lobj
		}
	}

	return $ret
}

# TODO: Use certificates if they are available.
function Execute-RemoteSshCommand {
	param($remoteHost, $credential, $command)

	$plink = Locate-Plink
	if ($plink -eq $null) {
		write-error "Cannot find plink. Please install it and try again."
		return
	}

	& $plink.definition -l $cred.username -pw $cred.password $remoteHost $command
}

# Thanks to Hal Rottenberg for these two functions.
# Originally from http://poshcode.org/501
function Export-PSCredential {
        param ( $Credential = (Get-Credential), $Path = "credentials.enc.xml" )
 
        # Look at the object type of the $Credential parameter to determine how to handle it
        switch ( $Credential.GetType().Name ) {
                # It is a credential, so continue
                PSCredential            { continue } 
                # It is a string, so use that as the username and prompt for the password
                String                          { $Credential = Get-Credential -credential $Credential }
                # In all other caess, throw an error and exit
                default                         { Throw "You must specify a credential object to export to disk." }
        }
        
        # Create temporary object to be serialized to disk
        $export = New-Object PSObject
        Add-Member -InputObject $export -Name Username -Value $Credential.Username `
                -MemberType NoteProperty 
 
        # Encrypt SecureString password using Data Protection API
        $EncryptedPassword = $Credential.Password | ConvertFrom-SecureString
        Add-Member -InputObject $export -Name EncryptedPassword -Value $EncryptedPassword `
                -MemberType NoteProperty
        
        # Give object a type name which can be identified later
        $export.PSObject.TypeNames.Insert(0,’ExportedPSCredential’)
        
 
        # Export using the Export-Clixml cmdlet
        $export | Export-Clixml $Path
        Write-Host -foregroundcolor Green "Credentials saved to: " -noNewLine
 
        # Return FileInfo object referring to saved credentials
        Get-Item $Path
}
 
function Import-PSCredential {
        param ( [string]$Path = "credentials.enc.xml",[string]$cred)
 
        # Import credential file
        $import = Import-Clixml $Path
 
        # Test for valid import
        if ( !$import.UserName -or !$import.EncryptedPassword ) {
                Throw "Input is not a valid ExportedPSCredential object, exiting."
        }
        $Username = $import.Username
 
        # Decrypt the password and store as a SecureString object for safekeeping
        $SecurePass = $import.EncryptedPassword | ConvertTo-SecureString
 
        # Build the new credential object
        $Credential = New-Object System.Management.Automation.PSCredential $Username, $SecurePass
 
        if ($cred) {
                New-Variable -Name $cred -scope Global -value $Credential
        } else {
                Write-Output $Credential
        }
}

function Connect-Recent {
	param(
		[string]
		$targetHost="",

		[switch]
		$cache,

		[switch]
		$noCache
	)

	if ($targetHost -eq "") {
		$local:ErrorActionPreference = "SilentlyContinue"
		$recent = (Get-Itemproperty "hkcu:\software\vmware\VMware Infrastructure Client\Preferences").RecentConnections
		if ($recent -eq $null) {
			$recent = (Get-Itemproperty "hkcu:\software\vmware\Virtual Infrastructure Client\Preferences").RecentConnections
		}
		if ($recent -eq $null) {
			write-host -fore red "No recent hosts defined."
			return
		}
		$local:ErrorActionPreference = "Continue"
	
		$recents = $recent.split(",")

		write-host -fore yellow "Your recently visited hosts are:"
		$max = 10
		if ($recents.length -lt $max) {
			$max = $recents.length
		}
		for ($i = 1; $i -lt $max + 1; $i ++ ) {
			write-host -n "["
			write-host -n -f yellow "$i"
			write-host "]", $recents[$i - 1]
		}

		$selection = 0
		while ($selection -gt $max -or $selection -lt 1) {
			$selection = [int](read-host "Select a host to connect to")
		}
		$targetHost = $recents[$selection - 1]
	}

	Remove-Variable -Scope Global -Name vitkCachedCredential 2>$null
	$cacheFile = $env:appdata + "\vitoolkitextensions\" + $targetHost
	if (-not $noCache) {
		if (Test-Path $cacheFile) {
			$local:ErrorActionPreference = "SilentlyContinue"
			Import-PSCredential -Path $cacheFile -Cred vitkCachedCredential
			$local:ErrorActionPreference = "Continue"
			if ($global:vitkCachedCredential -eq $null) {
				write-host -fore Red "Cached credential is corrupt, ignoring."
			}
		}
	}
	if ($cache -and ($global:vitkCachedCredential -eq $null)) {
		mkdir $env:appdata\vitoolkitextensions 2>$null
		$global:vitkCachedCredential = get-credential
		$newCred = $true
	}
	write-host -fore yellow "Connecting to", $targetHost
	if ($global:vitkCachedCredential) {
		$local:ErrorActionPreference = "SilentlyContinue"
		while ((connect-viserver $targetHost -credential $global:vitkCachedCredential) -eq $null) {
			# Connection failed, bad cached credential.
			write-host -fore yellow "Failed to authenticate with cached credential. Enter new credential."
			Remove-Variable -Scope Global -Name vitkCachedCredential 2>$null
			$global:vitkCachedCredential = get-credential
			if ($global:vitkCachedCredential -eq $null) {
				return
			}
			$newCred = $true
		}
		$global:defaultVIServer = $defaultVIServer
		if ($newCred) {
			Export-PSCredential $global:vitkCachedCredential $cacheFile
		}
	} else {
		$local:ErrorActionPreference = "Stop"
		connect-viserver $targetHost
		$global:defaultVIServer = $defaultVIServer
	}
}

# Helper functions for locating external executables.
function Locate-Command {
	param($paths)

	$ErrorActionPreference = "SilentlyContinue"
	foreach ($path in $paths) {
		$command = get-command $path
		if ($command -ne $null) {
			return $command
		}
	}

	return $null
}

function Locate-Vnc {
	return Locate-Command -paths @(
	"$env:ProgramFiles\RealVNC\VNC4\vncviewer.exe",
	"vncviewer.exe")
}

function Locate-PuTTY {
	return Locate-Command -paths @(
	"$env:ProgramFiles\PuTTY\putty.exe",
	"putty.exe")
}

function Locate-Plink {
	return Locate-Command -paths @(
	"$env:ProgramFiles\PuTTY\plink.exe",
	"plink.exe")
}

function Locate-7Zip {
	$ErrorActionPreference = "SilentlyContinue"
	$dir = (Get-Itemproperty "hkcu:\software\7-Zip").Path

	return Locate-Command -paths @("$dir\7z.exe")
}

function Get-Archive {
	param ($archive)

	$regex = "(\S+)\s+(\S+)\s+(\S+)\s+(\d+)\s+(\d+)?\s+(.+)$"

	$7zip = Locate-7Zip
	if ($7zip -eq $null) {
		write-error "Need 7-Zip to be installed. Please install it and try again."
		return
	}

	# Get a listing from 7zip.
	$output = & $7Zip l $archive
	foreach ($line in $output) {
		if ($line -match $regex) {
			[psobject]$object = "" | select-object Date, Time, Attr, Size, Compressed, Name
			$object.Date = $matches[1]
			$object.Time = $matches[2]
			$object.Attr = $matches[3]
			$object.Size = $matches[4]
			$object.Compressed = $matches[5]
			$object.Name = $matches[6]
			$object
		}
	}
}

function Extract-Archive {
	param ($archive, $destination)

	$7zip = Locate-7Zip
	if ($7zip -eq $null) {
		write-error "Need 7-Zip to be installed. Please install it and try again."
		return
	}

	# Get a listing from 7zip.
	$output = & $7Zip e - o$destination $archive
}
#endregion

######################################
### VM Host Operations             ###
######################################
#region VMHost
Function Set-TkeVMHostLockdown {
    <#
    .SYNOPSIS
        Set or unset lockdown mode on an ESX host. Requires vCenter.
    .PARAMETER VMHost
        VMHost to modify.
    .PARAMETER Enable
        $true to enable lockdown mode, $false to disable it.
    .EXAMPLE
		# Set lockdown on all hosts in cluster X.
		Get-Cluster X | Get-VMHost | Set-TkeVMHostLockdown
    #>

	param(
        [Parameter(
            Mandatory=$true,
            ValueFromPipeline=$true,
            HelpMessage="VMHost"
        )]
        [VMware.VimAutomation.Client20.VMHostImpl]
        $VMHost,

		[Parameter(
            Mandatory=$true,
            HelpMessage="Whether to enable lockdown mode."
        )]
        [bool]
        $Enable
    )

	Process {
		# The host to lock down.
		$esxView = $VMHost | Get-View -property Name

		# Since the Admin methods are private, create a scheduled task to perform the lockdown.
		$action = New-Object VMware.Vim.MethodAction
		if ($Enable) {
			$action.Name = "DisableAdmin"
		} else {
			$action.Name = "EnableAdmin"
		}
		Invoke-TkeInternalMethod -Description ("Enable lockdown mode on " + $VMHost.Name) -View $esxView -Action $action
		Write-Output $esxView | Get-VIObjectByVIView
	}
}

# iSCSI cmdlets courtesy of Glenn Sizemore.
#Requires -version 2
Function Get-TkeVMHostSWIscsi {
    <#
    .SYNOPSIS
        Get's the Software ISCSI initiator.
    .PARAMETER VMHost
        Vmhost to query
    .EXAMPLE
        $VMHostSWIscsi = Get-TkeVMHostSWIscsi -VMHost (Get-VMHost ESX1)
        
    .LINK
        Set-TkeVMHostSWIscsi
        Get-TkeSWIscsiSendTarget
        New-TkeSWIscsiSendTarget
        Remove-TkeSWIscsiSendTarget
    #>
    [CmdletBinding(
        SupportsShouldProcess=$false,
        ConfirmImpact="none",
        DefaultParameterSetName=''
    )]
    param(
        [Parameter(
            Mandatory=$true,
            ValueFromPipeline=$true,
            HelpMessage="VMHost"
        )]
        [VMware.VimAutomation.Client20.VMHostImpl]
        $VMHost
    )
    Process 
    {
        $VMHostView = $VMHost | get-view -property config

        $HostInternetScsiHba = $VMHostView.config.StorageDevice.HostBusAdapter | 
            where-object { $_.IsSoftwareBased } | select-object -First 1
        
        $HostSoftwareIscsiImpl = New-Object VMware.TKe.HostSoftwareIscsiImpl
        $HostSoftwareIscsiImpl.MoRef = $VMHostView.MoRef
        $HostSoftwareIscsiImpl.IScsiEnabled = $VMHostView.config.StorageDevice.SoftwareInternetScsiEnabled
        $HostSoftwareIscsiImpl.HBA = $HostInternetScsiHba
        $HostSoftwareIscsiImpl.SendTarget = $HostInternetScsiHba.ConfiguredSendTarget
        $HostSoftwareIscsiImpl.StaticTarget = $HostInternetScsiHba.ConfiguredStaticTarget

        if ($HostInternetScsiHba)
        {
            $HostSoftwareIscsiImpl.IScsiName = $HostInternetScsiHba.IScsiName
            $HostSoftwareIscsiImpl.IScsiAlias = $HostInternetScsiHba.IScsiAlias
        }

        Write-Output $HostSoftwareIscsiImpl
    }
}

Function Set-TkeVMHostSWIscsi {
    <#
    .SYNOPSIS
        Configure the Software ISCSI initiator.
    .PARAMETER VMHostSWIscsi
        The host's iSCSI objectthis object is retrieved with the Get-TkeVMHostSWIscsi cmdlet
    .PARAMETER Enable
        Enable the Software ISCSI initiator.
    .PARAMETER Disable
        Disable the Software ISCSI initiator.
    .PARAMETER IScsiName
        Set the ISCSI Name (IQN) for the Software ISCSI HBA
    .PARAMETER IScsiAlias
        Set the ISCSI Alias for the Software ISCSI HBA
    .EXAMPLE
        $VMHostSWIscsi = Get-TkeVMHostSWIscsi -VMHost (Get-VMHost ESX1)
        Set-TkeVMHostSWIscsi -VMHostSWIscsi $VMHostSWIscsi -Enable

        Enable the Software ISCSI Initiator
    .EXAMPLE
        $VMHostSWIscsi = Get-TkeVMHostSWIscsi -VMHost (Get-VMHost ESX1)
        Set-TkeVMHostSWIscsi -VMHostSWIscsi $VMHostSWIscsi -Disable

        Disable the Software ISCSI Initiator
    .EXAMPLE
        $VMHostSWIscsi = Get-TkeVMHostSWIscsi -VMHost (Get-VMHost ESX1)
        Set-TkeVMHostSWIscsi -VMHostSWIscsi $VMHostSWIscsi -IScsiName "iqn.1998-01.com.vmware:ESX1"

        Set the Software ISCSI Initiator name (IQN) to iqn.1998-01.com.vmware:ESX2
    .EXAMPLE
        $VMHostSWIscsi = Get-TkeVMHostSWIscsi -VMHost (Get-VMHost ESX1)
        Set-TkeVMHostSWIscsi -VMHostSWIscsi $VMHostSWIscsi -IScsiAlias "ESX2.Get-Admin.local"

        Set the Software ISCSI Initiator Alias to ESX2.Get-Admin.local
    .LINK
        Get-TkeVMHostSWIscsi
        Get-TkeSWIscsiSendTarget
        New-TkeSWIscsiSendTarget
        Remove-TkeSWIscsiSendTarget
    #>
    [CmdletBinding(
        SupportsShouldProcess=$true,
        ConfirmImpact="Medium",
        DefaultParameterSetName='enableISCSI'
    )]
    param(
        [Parameter(
            Mandatory=$true,
            ValueFromPipeline=$true,
            HelpMessage="The host's iSCSI object (see Get-TkeVMHostSWIscsi)"
        )]
        [VMware.TKe.HostSoftwareIscsiImpl]
        $VMHostSWIscsi,

        [Parameter(
            Mandatory=$true,
            parameterSetName = "enableISCSI",
            HelpMessage="Enable Software IScsi"
        )]
        [switch]
        $Enable,
        
        [Parameter(
            Mandatory=$true,
            parameterSetName = "disableISCSI",
            HelpMessage="Disable Software IScsi"
        )]
        [switch]
        $Disable,

        [Parameter(
            Mandatory=$true,
            parameterSetName = "SetIQN",
            HelpMessage="Name of the iSCSI device"
        )]
        [string]
        $IScsiName,

        [Parameter(
            Mandatory=$true,
            parameterSetName = "SetIQNAlias",
            HelpMessage="Alias of the iSCSI device"
        )]
        [string]
        $IScsiAlias
    )
    process
    {
        $VMHostView = get-view -Id $VMHostSWIscsi.MoRef -property ConfigManager
        $HostStorageSystem = get-view -Id $VMHostView.ConfigManager.StorageSystem
        
        switch ($PSCmdlet.ParameterSetName)
        {
            "enableISCSI"
            {
                if ($PScmdlet.ShouldProcess($VMHostView.Name, "Enabling the ISCSI Software Initiator")) 
                {
                    $HostStorageSystem.UpdateSoftwareInternetScsiEnabled($true)
                }
            }
            "disableISCSI"
            {
                if ($PScmdlet.ShouldProcess($VMHostView.Name, "Disabling the ISCSI Software Initiator")) 
                {
                    $HostStorageSystem.UpdateSoftwareInternetScsiEnabled($false)
                }
            }
            "SetIQN"
            {
                if ($PScmdlet.ShouldProcess($VMHostView.Name, "Setting the ISCSI name to $(iScsiName)")) 
                {
                    $HostStorageSystem.UpdateInternetScsiName($VMHostSWIscsi.HBA.Device,$iScsiName)
                }
            }
            "SetIQNAlias"
            {
                if ($PScmdlet.ShouldProcess($VMHostView.Name, "Setting the ISCSI alias to $(iScsiAlias)")) 
                {            
                    $HostStorageSystem.UpdateInternetScsiAlias($VMHostSWIscsi.HBA.Device,$iScsiAlias)
                }
            }
        }
        
        return Get-TkeVMHostSWIscsi -vmhost (Get-VIObjectByVIView -MoRef $VMHostSWIscsi.MoRef)
    }
}

Function Get-TkeSWIscsiSendTarget {
    <#
    .SYNOPSIS
        Get the Software ISCSI initiators Send Targets.
    .PARAMETER VMHostSWIscsi
        ISCSI object, this object is retrieved with the Get-TkeVMHostSWIscsi cmdlet
    .EXAMPLE
        $VMHostSWIscsi = Get-TkeVMHostSWIscsi -VMHost (Get-VMHost ESX1)
        
        Enable the Software ISCSI Initiator
    .LINK
        Get-TkeVMHostSWIscsi
        Set-TkeVMHostSWIscsi
        New-TkeSWIscsiSendTarget
        Remove-TkeSWIscsiSendTarget
    #>
    [CmdletBinding(
        SupportsShouldProcess=$false,
        ConfirmImpact="none",
        DefaultParameterSetName=''
    )]
    param(
        [Parameter(
            Mandatory=$true,
            ValueFromPipeline=$true,
            HelpMessage="The host's iSCSI object (see Get-TkeVMHostSWIscsi)"
        )]
    [VMware.TKe.HostSoftwareIscsiImpl]
        $VMHostSWIscsi
    )
    Process 
    {
        # incase we're handed the same object that was used to 
        # add/remove anything... get a new one.
        $vmhostimpl = Get-VIObjectByVIView -MORef $VMHostSWIscsi.moref
        $VMHostSWIscsi = Get-TkeVMHostSWIscsi -VMHost $vmhostimpl
        if ($VMHostSWIscsi.SendTarget -eq $null) 
        {
            return
        }
        
        foreach ($Target in $VMHostSWIscsi.SendTarget) 
        {
			$Target
#            Write-Output $Target | Select-Object @{
#                Name='Address'
#                Expression={$Target.address}
#            }, @{
#                Name='Port'
#                Expression={$Target.port}
#            }
        }
    }
}

Function New-TkeSWIscsiSendTarget {
    <#
    .SYNOPSIS
        Add a Send target to the Software ISCSI initiator.
    .PARAMETER VMHostSWIscsi
        ISCSI object, this object is retrieved with the Get-TkeVMHostSWIscsi cmdlet
    .PARAMETER Address
        The target IP address or DNS name
    .PARAMETER Port
        The target port number, if none is provided then 3260 will be used.
    .EXAMPLE
        $VMHostSWIscsi = Get-TkeVMHostSWIscsi -VMHost (Get-VMHost ESX1)
        New-TkeSWIscsiSendTarget -VMHostSWIscsi $VMHostSWIscsi -Address 10.10.10.230
        
        Add 10.10.10.230 to the send targets on ESX1
    .LINK
        Get-TkeVMHostSWIscsi
        Set-TkeVMHostSWIscsi
        Get-TkeSWIscsiSendTarget
        Remove-TkeSWIscsiSendTarget
    #>
    [CmdletBinding(
        SupportsShouldProcess=$true,
        ConfirmImpact="low",
        DefaultParameterSetName=''
    )]
    param(
        [Parameter(
            Mandatory=$true,
            ValueFromPipeline=$true,
            HelpMessage="The host's iSCSI object (see Get-TkeVMHostSWIscsi)"
        )]
        [VMware.TKe.HostSoftwareIscsiImpl]
        $VMHostSWIscsi,

        [Parameter(
            Mandatory=$true,
            HelpMessage="The target IP address or DNS name"
        )]
        [string[]]
        $address,

        [Parameter(
            HelpMessage="The target port number (defaults to 3260)")]
        [int]
        $port = 3260
    )
    Process {
        $VMHostView = get-view -Id $VMHostSWIscsi.MoRef -property ConfigManager
        $HostStorageSystem = get-view -Id $VMHostView.ConfigManager.StorageSystem
        $addedIPs = ""
        $HostInternetScsiHBASendTargets = @()
        foreach ($IP in $address) {
            $HostInternetScsiHBASendTarget = New-Object VMware.Vim.HostInternetScsiHBASendTarget
            $HostInternetScsiHBASendTarget.address = $IP
            $HostInternetScsiHBASendTarget.port = $port
            $HostInternetScsiHBASendTargets += $HostInternetScsiHBASendTarget
            $addedIPs = $addedIPs + " " + $IP
        }
        if ($PScmdlet.ShouldProcess($VMHostView.Name, "adding $($addedIPs) to $($VMHostView.name)")) 
        {
           $HostStorageSystem.addInternetScsiSendTargets($VMHostSWIscsi.HBA.device, $HostInternetScsiHBASendTargets)
        }
    }
}

Function Remove-TkeSWIscsiSendTarget { 
    <#
    .SYNOPSIS
        remove one or more Send targets from the Software ISCSI initiator.
    .PARAMETER VMHostSWIscsi
        ISCSI object, this object is retrieved with the Get-TkeVMHostSWIscsi cmdlet
    .PARAMETER Address
        The target IP address or DNS name
    .PARAMETER Port
        The target port number, if none is provided then 3260 will be used.
    .PARAMETER RemoveAllTargets
        clear the send targets from the specified adapter.
    .EXAMPLE
        $VMHostSWIscsi = Get-TkeVMHostSWIscsi -VMHost (Get-VMHost ESX1)
        Remove-TkeSWIscsiSendTarget -VMHostSWIscsi $VMHostSWIscsi -Address 10.10.10.230
        
        remove 10.10.10.230 from the send targets on ESX1
    .EXAMPLE
        $VMHostSWIscsi = Get-TkeVMHostSWIscsi -VMHost (Get-VMHost ESX1)
        Remove-TkeSWIscsiSendTarget -VMHostSWIscsi $VMHostSWIscsi -RemoveAllTargets
        
        Remove all the sendtargets from ESX1.
    .LINK
        Get-TkeVMHostSWIscsi
        Set-TkeVMHostSWIscsi
        Get-TkeSWIscsiSendTarget
        New-TkeSWIscsiSendTarget
    #>
    [CmdletBinding(
        SupportsShouldProcess=$true,
        ConfirmImpact="low",
        DefaultParameterSetName=''
    )]
    param(
        [Parameter(
            Mandatory=$true,
            ValueFromPipeline=$true,
            HelpMessage="The host's iSCSI object (see Get-TkeVMHostSWIscsi)"
        )]
        [VMware.TKe.HostSoftwareIscsiImpl]
        $VMHostSWIscsi,

        [Parameter(
            Mandatory=$true,
            parametersetname='one',
            HelpMessage="The target IP address or DNS name"
        )]
        [string[]]
        $address,

        [Parameter(
            parametersetname='one',
            HelpMessage="The target port number (defaults to 3260)"
        )]
        [int]
        $port = 3260,
        
        [Parameter(
            parametersetname='ALL'
        )]
        [switch]
        $RemoveAllTargets
    )
    Process {
        $VMHostView = get-view -Id $VMHostSWIscsi.MoRef -property ConfigManager
        $HostStorageSystem = get-view -Id $VMHostView.ConfigManager.StorageSystem
        $removed = ""
        $HostInternetScsiHBASendTargets = @()
        
        if ($RemoveAllTargets) 
        {
            $VMHostSWIscsi = Get-TkeVMHostSWIscsi -vmhost (Get-VIObjectByVIView $VMHostView)
            $allSendTargets = Get-TkeSWIscsiSendTarget $VMHostSWIscsi
            foreach ($Target in $allSendTargets) {
                $HostInternetScsiHBASendTarget = New-Object VMware.Vim.HostInternetScsiHBASendTarget
                $HostInternetScsiHBASendTarget.address = $Target.Address
                $HostInternetScsiHBASendTarget.port = $Target.Port
                $HostInternetScsiHBASendTargets += $HostInternetScsiHBASendTarget
                $Removed = $Removed + " " + $IP
            }
        }
        else
        {
              foreach ($IP in $address) {
                $HostInternetScsiHBASendTarget = New-Object VMware.Vim.HostInternetScsiHBASendTarget
                $HostInternetScsiHBASendTarget.address = $IP
                $HostInternetScsiHBASendTarget.port = $port
                $HostInternetScsiHBASendTargets += $HostInternetScsiHBASendTarget
                $Removed = $Removed + " " + $IP
            }
        }
        if ($PScmdlet.ShouldProcess($VMHostView.Name, "adding $($Removed) to $($VMHostView.name)")) 
        {
           $HostStorageSystem.RemoveInternetScsiSendTargets($VMHostSWIscsi.HBA.device, $HostInternetScsiHBASendTargets)
        }
    }
}

function New-TkeVMHostAccount {
    <#
    .SYNOPSIS
        As of PowerCLI 4.0 this function should not be used.
        
    .LINK
        New-VMHostAccount
    #>

	param(
	[Parameter(Mandatory=$true,HelpMessage="User ID")]
	[string]
	$id,

	[Parameter(Mandatory=$true,HelpMessage="Password")]
	[string]
	$password,

	[Parameter(HelpMessage="Description")]
	[string]
	$description,

	[Parameter(HelpMessage="POSIX ID")]
	[int]
	$posixId,

	[Parameter(HelpMessage="Enable shell access?")]
	[bool]
	$shellAccess = $true
	)

	$si = get-view serviceinstance
	$accountManager = get-view $si.Content.AccountManager
	$as = new-object VMware.Vim.HostPosixAccountSpec
	$as.id = $id
	$as.password = $password
	$as.description = $description
	$as.shellAccess = $shellAccess
	$as.posixId = $posixId
	$accountManager.CreateUser($as)
}

function Get-TkeVMHostMemoryReservation {
    <#
    .SYNOPSIS
        Gets the ESX host's service console memory reservation.
    .PARAMETER VMHost
        VMHost to query.
    .EXAMPLE
        Get-VMHost myhost | Get-TkeVMHostMemoryReservation
	.LINK
        Set-TkeVMHostMemoryReservation
    #>

	param(
	[Parameter(Mandatory=$true,ValueFromPipeline=$true,HelpMessage="One or more hosts whose reservation we retrieve")]
	[VMware.VimAutomation.Client20.VMHostImpl[]]
	$vmhost
	)

	process {
		foreach ($h in $vmhost) {
			$hView = $h | Get-View
			$memManager = Get-View -Id $hView.ConfigManager.MemoryManager
			$obj = new-object psobject
			$obj | add-member -type noteproperty -name "Host" -value $h.Name
			$obj | add-member -type noteproperty -name "ReservedMB" -value ($memManager.consoleReservationInfo.serviceConsoleReserved / 1mb)
			$obj | add-member -type noteproperty -name "ReservedConfigurationMB" -value ($memManager.consoleReservationInfo.serviceConsoleReservedCfg / 1mb)
			$obj | add-member -type noteproperty -name "UnreservedMB" -value ($memManager.consoleReservationInfo.unreserved / 1mb)
			$obj
		}
	}
}

function Set-TkeVMHostMemoryReservation {
    <#
    .SYNOPSIS
        Sets the ESX host's service console memory reservation.
    .PARAMETER VMHost
        VMHost to modify.
    .PARAMETER Reservation
        The reservation amount (in megabytes).
    .EXAMPLE
        Get-VMHost myhost | Set-TkeVMHostMemoryReservation -Reservation 800
	.LINK
        Set-TkeVMHostMemoryReservation
    #>

	param(
	[Parameter(Mandatory=$true,ValueFromPipeline=$true,HelpMessage="One or more hosts whose reservation we configure")]
	[VMware.VimAutomation.Client20.VMHostImpl]
	$VMHost,

	[Parameter(Mandatory=$true,HelpMessage="The amount of memory (in megabytes) to reserve on next boot")]
	[int]
	$Reservation
	)

	process {
		$hView = $VMHost | Get-View
		$memManager = Get-View -Id $hView.ConfigManager.MemoryManager
		$memManager.ReconfigureServiceConsoleReservation($Reservation * 1mb)
	}
}

function Stop-TkeVMHost {
    <#
    .SYNOPSIS
        Put a VMHost into standby or power it down.
    .PARAMETER VMHost
        VMHost to affect.
    .PARAMETER Standby
        Whether to put the host in standby. If true, put the host into standby. If $false, power it down.
    .PARAMETER Evacuate
        Whether to evacuate the host.
    .PARAMETER Timeout
        If you choose to evacuate, the timeout to use.
    .EXAMPLE
        Get-VMHost X | Stop-TkeVMHost -Standby $true -Evacuate $true -Timeout 600
        
    .LINK
        Start-TkeVMHost
    #>
	
	param(
	[Parameter(Mandatory=$true,ValueFromPipeline=$true,HelpMessage="One or more hosts to stop")]
	[VMware.VimAutomation.Client20.VMHostImpl]
	$VMHost,

	[Parameter(HelpMessage="Whether to put the host in standby mode")]
	[bool]
	$Standby = $true,

	[Parameter(HelpMessage="Whether to evacuate VMs")]
	[bool]
	$Evacuate = $false,

	[Parameter(HelpMessage="Timeout")]
	[int]
	$Timeout = 360
	)

	process {
		$hView = $VMHost | get-view
		if ($standby) {
			$task = $hView.PowerDownHostToStandBy_Task($timeout, $evacuate)
		} else {
			$task = $hView.ShutdownHost_Task($force)
		}
	}
}

# Power an ESX host up when it is in standby mode.
function Start-TkeVMHost {
	param(
	[Parameter(Mandatory=$true,ValueFromPipeline=$true,HelpMessage="One or more hosts to start")]
	[VMware.VimAutomation.Client20.VMHostImpl]
	$VMHost,

	[Parameter(HelpMessage="Timeout")]
	[int]
	$Timeout = 360
	)

	process {
		$hView = $VMHost | get-view
		$task = $hView.PowerUpHostFromStandBy_Task($timeout)
	}
}

# Restart an ESX host.
function Restart-TkeVMHost {
	param(
	[Parameter(Mandatory=$true,ValueFromPipeline=$true,HelpMessage="One or more hosts to restart")]
	[VMware.VimAutomation.Client20.VMHostImpl]
	$VMHost,

	[Parameter(HelpMessage="Whether to force a restart")]
	[bool]
	$Force = $false
	)

	process {
		$hView = $VMHost | get-view
		$task = $hView.RebootHost_Task($force)
	}
}

# Set an ESX host's maintenance mode.
function Set-TkeVMHostMaintenanceMode {
	param(
	[Parameter(Mandatory=$true,ValueFromPipeline=$true,HelpMessage="One or more hosts for which we set maintenance mode")]
	[VMware.VimAutomation.Client20.VMHostImpl]
	$vmhost,

	[Parameter(Mandatory=$true,HelpMessage="Enable maintenance mode?")]
	[bool]
	$enableMaintenanceMode,

	[Parameter(HelpMessage="The amount of time to wait for the change to succeed")]
	[int]
	$timeout = 360,

	[Parameter(HelpMessage="Whether to evacuate the host")]
	[bool]
	$evacuate = $false
	)

	process {
		$hView = $VMHost | get-view
		if ($enableMaintenanceMode) {
			$task = $hView.EnterMaintenanceMode_Task($timeout, $evacuate)
		} else {
			$task = $hView.ExitMaintenanceMode_Task($timeout)
		}
	}
}
#endregion

######################################
### Networking Operations          ###
######################################
#region Networking
# XXX: Should move this to a real object system.
function New-BlankRouteObject {
	$entry = New-Object PSobject

	$entry | Add-Member -MemberType NoteProperty -Name "Type"           -Value $null
	$entry | Add-Member -MemberType NoteProperty -Name "Network"        -Value $null
	$entry | Add-Member -MemberType NoteProperty -Name "Gateway"        -Value $null
	$entry | Add-Member -MemberType NoteProperty -Name "DefaultGateway" -Value $null
	$entry | Add-Member -MemberType NoteProperty -Name "PrefixLength"   -Value $null
	$entry | Add-Member -MemberType NoteProperty -Name "GatewayDevice"  -Value $null
	$entry | Add-Member -MemberType NoteProperty -Name "VMHost"         -Value $null

	return $entry
}

function Get-TkeVMHostRoute {
	param(
		[Parameter(Mandatory=$true,ValueFromPipeline=$true,HelpMessage="VMHost")]
		[VMware.VimAutomation.Client20.VMHostImpl]
		$VMHost
	)

	Process {
		$hView = $VMHost | Get-View -property Config
		$network = $hView.Config.Network

		# Add the console route.
		if ($network.ConsoleIpRouteConfig.DefaultGateway) {
			$entry = New-BlankRouteObject
			$entry.DefaultGateway = $network.ConsoleIpRouteConfig.DefaultGateway
			$entry.GatewayDevice  = $network.ConsoleIpRouteConfig.GatewayDevice
			$entry.Type = "Console"
			$entry.VMHost = $VMHost
			$entry
		}

		# The host route.
		if ($network.IpRouteConfig.DefaultGateway) {
			$entry = New-BlankRouteObject
			$entry.DefaultGateway = $network.IpRouteConfig.DefaultGateway
			$entry.GatewayDevice  = $network.IpRouteConfig.GatewayDevice
			$entry.Type = "Host"
			$entry.VMHost = $VMHost
			$entry
		}
		
		# If you're using vSphere 4+ you also have a real routing table finally!
		if ($network.routeTableInfo -ne $null) {
			foreach ($route in $network.RouteTableInfo.IpRoute) {
				$entry = New-BlankRouteObject
				$entry.Network      = $route.Network
				$entry.Gateway      = $route.Gateway
				$entry.PrefixLength = $route.PrefixLength
				$entry.Type = "Table"
				$entry.VMHost = $VMHost
				$entry
			}
		}
	}
}

function New-TkeVMHostRoute {
	[CmdletBinding(DefaultParameterSetName="p1",ConfirmImpact="high")]
	param(
		[Parameter(Mandatory=$true,ValueFromPipeline=$true,HelpMessage="VMHost")]
		[VMware.VimAutomation.Client20.VMHostImpl]
		$VMHost,

		[Parameter(ParameterSetName="p1")]
		[switch]
		$ConsoleRoute,

		[Parameter(ParameterSetName="p1")]
		[switch]
		$HostRoute,

		[Parameter(ParameterSetName="p1")]
		[string]
		$DefaultGateway=$null,

		[Parameter(ParameterSetName="p1")]
		[string]
		$GatewayDevice=$null,

		[Parameter(Mandatory=$true,ParameterSetName="p2")]
		[switch]
		$TableRoute=$null,

		[Parameter(Mandatory=$true,ParameterSetName="p2")]
		[string]
		$Network=$null,

		[Parameter(Mandatory=$true,ParameterSetName="p2")]
		[string]
		$Gateway=$null,

		[Parameter(Mandatory=$true,ParameterSetName="p2")]
		[int32]
		$PrefixLength
	)

	process {
		$hView = $VMHost | Get-View -property ConfigManager
		$hns = get-view $hView.ConfigManager.NetworkSystem

		# XXX: This doesn't generate any output objects like it should!
		if ($PsCmdlet.ParameterSetName -eq "p1") {
			if ($ConsoleRoute -and $HostRoute) {
				throw "You can't specify both -ConsoleRoute and -HostRoute. Please make up your mind."
			}
			if ($ConsoleRoute) {
				$config = new-object VMware.Vim.HostIpRouteConfig
				$config.defaultGateway = $DefaultGateway
				if ($GatewayDevice -ne $null) {
					$config.gatewayDevice  = $GatewayDevice
				}
				$hns.UpdateConsoleIpRouteConfig($config)
			} else {
				$config = new-object VMware.Vim.HostIpRouteConfig
				$config.defaultGateway = $DefaultGateway
				if ($GatewayDevice -ne $null) {
					$config.gatewayDevice  = $GatewayDevice
				}
				$hns.UpdateIpRouteConfig($config)
			}
		} else {
			$config = new-object VMware.Vim.HostIpRouteTableConfig
			$config.ipRoute = @()
			$routeOp = new-object VMware.Vim.HostIpRouteOp
			$routeOp.changeOperation = "add"
			$routeOp.route = new-object VMware.Vim.HostIpRouteEntry
			$routeOp.route.gateway = $Gateway
			$routeOp.route.network = $Network
			$routeOp.route.prefixLength = $PrefixLength
			$config.ipRoute += $routeOp
			$hns.UpdateIpRouteTableConfig($config)
		}
	}
}

function Remove-TkeVMHostRoute {
	param(
		[Parameter(Mandatory=$true,ValueFromPipeline=$true)]
		[PSObject]
		$Route
	)

	process {
		if ($Route.Type -eq "Table") {
			$hView = $Route.VMHost | Get-View -property ConfigManager
			$hns = get-view $hView.ConfigManager.NetworkSystem

			$config = new-object VMware.Vim.HostIpRouteTableConfig
			$config.ipRoute = @()
			$routeOp = new-object VMware.Vim.HostIpRouteOp
			$routeOp.changeOperation = "remove"
			$routeOp.route = new-object VMware.Vim.HostIpRouteEntry
			$routeOp.route.gateway = $Route.Gateway
			$routeOp.route.network = $Route.Network
			$routeOp.route.prefixLength = $Route.PrefixLength
			$config.ipRoute += $routeOp
			$hns.UpdateIpRouteTableConfig($config)
		} else {
			throw "Removing routes is only supported from the routing table."
		}
	}
}

function Get-TkeVMHostNetworkAdapter {
	param(
	[Parameter(ValueFromPipeline=$true,HelpMessage="VMHost")]
	[VMware.VimAutomation.Client20.VMHostImpl]
	$VMHost=$null,

	[switch]
	$physicalOnly=$null,

	[switch]
	$virtualOnly=$null
	)

	process {
		if ($VMHost -eq $null) {
			$VMHost = Get-VMHost
		}
		$networks = $VMHost | Get-VMHostNetwork
		if (-not $virtualOnly) {
			$networks | foreach { $_.PhysicalNic }
		}
		if (-not $physicalOnly) {
			$networks | foreach { $_.VirtualNic }
		}
	}
}

function Get-TkeVSwitchSecurity {
	param (
	[Parameter(position=1,Mandatory=$TRUE,ValueFromPipeline=$TRUE,HelpMessage="One or more hosts for which we return the virtual switch security policy")]
	[VMware.VimAutomation.Client20.VMHostImpl]
	$VMhost,

	[Parameter(position=0,Mandatory=$FALSE,HelpMessage="Name of the vSwitch to query")]
	[string]
	$Name
	)

	Process {
		$hostView = $VMHost | Get-View
		$networkSystem = Get-View $hostView.ConfigManager.NetworkSystem
		foreach ($switch in $networkSystem.NetworkConfig.Vswitch) {
			if ($Name -and -not ($switch.Name -match $Name)) {
				continue
			}
			$ret = New-Object PSObject
			$ret | Add-Member -Type noteproperty -Name "Name" -Value $switch.Name
			$ret | Add-Member -Type noteproperty -Name "Host" -Value $h
			$ret | Add-Member -Type noteproperty -Name "AllowPromiscuous" -Value $switch.spec.policy.security.AllowPromiscuous
			$ret | Add-Member -Type noteproperty -Name "MacChanges" -Value $switch.spec.policy.security.MacChanges
			$ret | Add-Member -Type noteproperty -Name "ForgedTransmits" -Value $switch.spec.policy.security.ForgedTransmits
			$ret
		}
	}
}

# Author: Glenn Sizemore 12/19/2009
# Source: http://get-admin.com/blog/?p=239
<#
.SYNOPSIS
Modify the security settings of a virtual switch.
.DESCRIPTION
Modify the security settings of a virtual switch.
.PARAMETER Name
Name of the virtual switch to modify.

Type : String
Mandatory : TRUE
ParamaterSet: 
PipeLine : FALSE
.PARAMETER VMHost
One or more hosts for which we want to modify the vSwitch Security

Type : VMHostImpl[]
Mandatory : TRUE
ParamaterSet: 
PipeLine : ByValue
.PARAMETER AllowPromiscuous
if provided then AllowPromiscuous will be enabled thus allowing all traffic is seen on the port. The default action is to disable AllowPromiscuous.

Type : switch
Mandatory : TRUE
ParamaterSet: 
PipeLine : FALSE
.PARAMETER ForgedTransmits
if provided then ForgedTransmits will be enabled thus allowing the virtual network adapter to send network traffic with a different MAC address than that of the virtual network adapter. The default action is to disable ForgedTransmits

Type : switch
Mandatory : FALSE
ParamaterSet : 
PipeLine : FALSE
.PARAMETER MacChanges
if provided then MacChanges will be enabled thus allowing Media Access Control (MAC) address to be changed. The default action is to disable MacChanges

Type : switch
Mandatory : FALSE
ParamaterSet: 
PipeLine : FALSE
.EXAMPLE
# Set Promiscuous Mode, MAC Addess Changes, and Forged Transmits to reject.
Set-TkeVSwitchSecurity -VMHost (get-vmhost ESX1) -Name 'vSwitch0'
.EXAMPLE
# Enable Promiscuous Mode on vSwitch1 on all ESX hosts in cluster SQL
Get-Cluster SQL | Get-VMHost | Set-TkeVSwitchSecurity vswitch1 -AllowPromiscuous

# If your not sure your running against the correct host/switch use -whatif/confirm
Get-Cluster SQL | Get-VMHost | Set-TkeVSwitchSecurity vswitch1 -AllowPromiscuous -whatif

# Will output:
What if: Performing operation "Updating vSwitch1 Security settings: AllowPromiscuous=TRUE, 
 MacChanges=FALSE, ForgedTransmits=FALSE" on Target "ESX1".
 What if: Performing operation "Updating vSwitch1 Security settings: AllowPromiscuous=TRUE,
 MacChanges=FALSE, ForgedTransmits=FALSE" on Target "ESX2".
 What if: Performing operation "Updating vSwitch1 Security settings: AllowPromiscuous=TRUE,
 MacChanges=FALSE, ForgedTransmits=FALSE" on Target "ESX3".

Be aware that the vSwitch param will perform a wildcard search for the vswitch name! 
.LINK
Get-VirtualSwitch
#>
function Set-TkeVSwitchSecurity {
	[CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact="high")]
	param (
	[Parameter(position=0,Mandatory=$TRUE,HelpMessage="Name of the vSwitch to modify")]
	[string]
	$Name,

	[Parameter(position=1,Mandatory=$TRUE,ValueFromPipeline=$TRUE,HelpMessage="One or more hosts for which we want to modify the vSwitch Security")]
	[VMware.VimAutomation.Client20.VMHostImpl[]]
	$VMhost,

	[switch]
	$AllowPromiscuous,

	[switch]
	$MacChanges,

	[switch]
	$ForgedTransmits
	)
	foreach ($H in $vmhost) {
		$hostid = Get-VMHost $H | get-view
		$networkSystem = get-view $hostid.ConfigManager.NetworkSystem
		$networkSystem.NetworkConfig.Vswitch| ?{$_.name -match $Name} | % {
			$switchSpec = $_.spec
			$vSwitchName = $_.name
			if ($AllowPromiscuous) {
				$switchSpec.Policy.Security.AllowPromiscuous = $TRUE
				$msg = "Updating $($vSwitchName) Security settings: AllowPromiscuous=True"
			} else {
				$switchSpec.Policy.Security.AllowPromiscuous = $FALSE
				$msg = "Updating $($vSwitchName) Security settings: AllowPromiscuous=False"
			}
			if ($MacChanges) {
				$switchSpec.Policy.Security.MacChanges = $TRUE
				$msg += ", MacChanges=True"
			} else {
				$switchSpec.Policy.Security.MacChanges = $FALSE
				$msg += ", MacChanges=False"
			}
			if ($ForgedTransmits) {
				$switchSpec.Policy.Security.ForgedTransmits = $TRUE
				$msg += ", ForgedTransmits=True"
			} else {
				$switchSpec.Policy.Security.ForgedTransmits = $FALSE
				$msg += ", ForgedTransmits=False"
			}
			if (($psfunction.ShouldProcess($H.Name, $msg))) {
				$hostNetworkSystemView = get-view $hostid.configManager.networkSystem
				$hostNetworkSystemView.UpdateVirtualSwitch($vSwitchName, $switchSpec)
			}
		}
	}
}

# Get Cisco Discovery Protocol information from a pNIC
# If no pNIC is specified the function returns the information for all pNICs ob VMhost
# v1.0 - 29/12/08 - LucD
<#
.Synopsis
Returns CDP info for one or more pNICs on one or more ESX servers
.Description
Returns CDP info, if available, from one or morepNICs on one or more ESX servers. 
The cmdlet returns an object for each pNIC containing the ESX hostname, the pNIC name
and the PhysicalNicCdpInfo object.
for the layout of the PhysicalNicCdpInfo object see 
http://www.vmware.com/support/developer/vc-sdk/visdk25pubs/ReferenceGuide/vim.host.PhysicalNic.CdpInfo.html
if there is no CDP info available, the CDPInfo property will equal $null
.Parameter vmhost 
One or more ESX hosts. The object(s) returned by the Get-VMHost cmdlet
.Parameter pNICs
The device name of the pNIC. if not specified CDP info for all pNICs is returned
.Example
$esxImpl = Get-VMHost my.esx.server
Get-TkeCDPInfo $esxImpl vmnic1,vmnic2
.Example
Get-VMHost | Get-TKECDPInfo
#>
function Get-TkeCDPInfo
{
	param (
	[Parameter(Mandatory=$true, Position=0, ValueFromPipeline=$true, HelpMessage="One or more hosts from which to get the pNIC CDP info")]
	[VMware.VimAutomation.Client20.VMHostImpl[]]
	$vmhost,
	[Parameter(Mandatory=$false, Position=1, HelpMessage="One or more pNICs. Default is all pNICs.")]
	[String[]]
	$pNICs
	)
	Begin {
		$report = @()
	}
	Process {
		foreach($esxImpl in $vmhost){
			if($esxImpl.State -eq "Connected"){
				$esx = Get-View -Id $esxImpl.Id
				$netsys = Get-View $esx.ConfigManager.NetworkSystem
				#				if($pNICs -eq $null){
#					$pNICs = @()
#					foreach($physnic in $netsys.NetworkInfo.Pnic){
#						$pNICs += $physnic.Device
#					}
#				}
				$pnicInfo = $netsys.QueryNetworkHint($pNICs)
				foreach($hint in $pnicInfo){
					$ret = New-Object PSObject
					$ret | Add-Member -Type noteproperty -Name "VMHost" -Value $esx.Name
					$ret | Add-Member -Type noteproperty -Name "pNIC" -Value $hint.Device
					$ret | Add-Member -Type noteproperty -Name "CDPInfo" -Value $hint.connectedSwitchPort
					$report += $ret
				}
			}
		}
	}
	End {
		return $report
	}
}
#endregion

######################################
### Storage Operations             ###
######################################
#region Storage
function Build-TkeUploadHttpPath {
	param(
	[VMware.VimAutomation.VIServerImpl]$server,
	[VMware.VimAutomation.Client20.DatacenterImpl]$datacenter,
	[string]$path,
	[switch]$localPath
	)

	[reflection.assembly]::loadwithpartialname("system.web") > $null

	if ($localPath) {
		$url = "https://" + $server.Name + ":" + $server.Port
		#$url += "/" + [web.httputility]::urlencode($path.SubString(1))
		$url += $path
	} else {
		$pathElements = Extract-TkeDatastorePathElements $path

		# Build our URL.
		$url = "https://" + $server.Name + ":" + $server.Port + "/folder"
		$url += "/" + [web.httputility]::urlencode($pathElements.Path)
		$url += "?dcPath=" + [web.httputility]::urlencode($datacenter.Name)
		$url += "&dsName=" + [web.httputility]::urlencode($pathElements.Datastore)
	}

	return $url
}

# Get the disk partition info for a disk. The diskInfo parameter is expected to be in the same
# format as the objects returned by Get-TkeAvailableDisk.
function Get-TkeDiskPartitionInfo {
	param($storageSystem, $diskInfo)

	return $storageSystem.RetrieveDiskPartitionInfo($diskInfo.devicepath)[0]
}

# Get all unformatted devices for a VMHost.
function Get-TkeAvailableDisk {
	param(
	[Parameter(Mandatory=$true,ValueFromPipeline=$true)]
	[VMware.VimAutomation.Client20.VMHostImpl]
	$VMHost
	)

	Process {
		$hView = $VMHost | get-view
		$datastoreSystem = get-view $hView.configmanager.datastoresystem
		Write-Output $datastoreSystem.queryavailabledisksforvmfs($null)
	}
}

# Format an entire disk into VMFS3 format. Requires a host that is able to see the disk.
function Format-TkeDisk {
	param(
	[Parameter(Mandatory=$true,ValueFromPipeline=$true)]
	[VMware.VimAutomation.Client20.VMHostImpl]
	$VMhost,

	[Parameter(Mandatory=$true)]
	[VMware.Vim.HostScsiDisk]
	$diskinfo,

	[Parameter(Mandatory=$true)]
	[string]
	$volumeName
	)

	Process {
		# Get the storage system that manages this partition.
		$hostView = $VMHost | get-view
		$storage = get-vmhoststorage $VMHost
		$storageSystem = get-view $storage.id
		$datastoreSystem = get-view $hostView.configmanager.datastoresystem

		$diskPartition = Get-DiskPartitionInfo -storageSystem $storagesystem -diskinfo $diskinfo
		$lastBlock = $diskPartition.layout.total.Block
		$blockSize = $diskPartition.layout.total.BlockSize

		$start = new-object VMware.Vim.HostDiskDimensionsLba
		$end = new-object VMware.Vim.HostDiskDimensionsLba
		$start.block = 0
		$start.blockSize = $blockSize
		$end.block = $lastBlock - 1
		$end.blockSize = $blockSize
		$partitionBlockRange = new-object VMware.Vim.HostDiskPartitionBlockRange
		$partitionBlockRange.start = $start
		$partitionBlockRange.end = $end
		$partitionBlockRange.type = "vmfs"
		$partitionBlockRange.partition = 1

		$total = new-object VMware.Vim.HostDiskDimensionsLba
		$total.block = $diskPartition.layout.total.block
		$total.blockSize = $diskPartition.layout.total.blocksize
		$layout = new-object VMware.Vim.HostDiskPartitionLayout
		$layout.partition = @($partitionBlockRange)
		$layout.total = $total
		$partitionInfo = $storageSystem.ComputeDiskPartitionInfo($diskInfo.DevicePath, $layout)

		# The VMFS spec.
		$extent = new-object VMware.Vim.HostScsiDiskPartition
		$scsiLun = $storage.scsilun | where { $_.ConsoleDeviceName -eq $diskInfo.devicePath }
		$extent.diskName = $scsiLun.CanonicalName
		$extent.partition = 1
		$vmfsSpec = new-object VMware.Vim.HostVmfsSpec
		$vmfsSpec.blockSizeMb = 1
		$vmfsSpec.majorVersion = 3
		$vmfsSpec.volumeName = $volumeName
		$vmfsSpec.extent = $extent
		$createSpec = new-object VMware.Vim.VmfsDatastoreCreateSpec
		$createSpec.vmfs = $vmfsSpec
		$createSpec.partition = $partitionInfo.spec
		$createSpec.diskuuid = $diskInfo.uuid
		$datastoreSystem.CreateVmfsDatastore($createSpec)
		write-output get-datastore $volumename
	}
}

function New-TkeDatastoreDirectory {
	param(
	[Parameter(Mandatory=$true,HelpMessage="Directory to create in datastore format")]
	[string]
	$path = "",

	[Parameter(HelpMessage="VIServer to use")]
	[VMware.VimAutomation.VIServerImpl]
	$server,

	[Parameter(Mandatory=$true,HelpMessage="Datacenter where the directory is made")]
	[VMware.VimAutomation.Client20.DatacenterImpl]
	$datacenter,

	[Parameter(HelpMessage="Whether to create parent directories")]
	[bool]
	$createParentDirectories = $true
	)

	# Get the server connection.
	if ($server -eq $null) {
		$server = $defaultVIServer
	}
	if ($server -eq $null) {
		$server = $global:defaultVIServer
	}
	if ($server -eq $null) {
		write-error "Can't determine source server, are you connected?"
		return
	}

	# Load the FileManager object.
	$si = get-view -server $VIServer ServiceInstance
	$fm = get-view -server $VIServer $si.content.filemanager

	# Make the directory.
	$fm.MakeDirectory($path, ($Datacenter | get-view).MoRef, $createParentDirectories)
}

# Copy a file to or from a datastore.
# 3 modes are supported: Upload from local client, download to local client, and streaming from
# an HTTP server (which could point to another datastore) to a datastore using the client as a proxy.
function Copy-TkeDatastoreFile {
	param(
	[Parameter(Mandatory=$true,HelpMessage="Source (Datastore path, URL, or local file)")]
	[String]
	$source,

	[Parameter(Mandatory=$true,HelpMessage="Destination (Datastore path, URL, or local file")]
	[String]
	$destination,

	[Parameter(HelpMessage="If the source is a datastore, the source server")]
	[VMware.VimAutomation.VIServerImpl]
	$sourceServer,

	[Parameter(HelpMessage="If the destination is a datastore, the destination server")]
	[VMware.VimAutomation.VIServerImpl]
	$destinationServer,

	[Parameter(HelpMessage="If the source is a datastore, the Datacenter containing the file")]
	[VMware.VimAutomation.Client20.DatacenterImpl]
	$sourceDatacenter,

	[Parameter(HelpMessage="If the destination is a datastore, the Datacenter containing the file")]
	[VMware.VimAutomation.Client20.DatacenterImpl]
	$destinationDatacenter,

	[Parameter(HelpMessage="Source credential, if needed")]
	[System.Management.Automation.PSCredential]
	$sourceCredential,

	[Parameter(HelpMessage="Destination credential, if needed")]
	[System.Management.Automation.PSCredential]
	$destinationCredential,

	[Parameter(HelpMessage="Display progress?")]
	[switch]
	$noprogress
	)

	# Are the source and destination datastore paths or ordinary URLs?
	$sourceIsDatastore = Is-TkeDatastorePath $source
	$destinationIsDatastore = Is-TkeDatastorePath $destination
	$sourceIsLocalPath = $source[0] -eq "/"
	$destinationIsLocalPath = $destination[0] -eq "/"

	# Build the real paths if some are on datastores.
	if ($sourceServer -eq $null) {
		$sourceServer = $defaultVIServer
	}
	if ($sourceServer -eq $null) {
		$sourceServer = $global:defaultVIServer
	}
	if ($sourceServer -eq $null) {
		write-error "Can't determine source server, are you connected?"
		return
	}
	if ($sourceIsDatastore) {
		if ($sourceDatacenter -eq $null) {
			write-error "Need a -sourceDatacenter argument"
			return
		}
		$sourceUrl = Build-TkeUploadHttpPath -server $sourceServer -datacenter $sourceDatacenter -path $source
	} elseif ($sourceIsLocalPath) {
		# Download a file from a local directory on ESX.
		$sourceUrl = Build-TkeUploadHttpPath -server $sourceServer -path $source -localPath
	} else {
		$sourceUrl = $source
	}

	if ($destinationServer -eq $null) {
		$destinationServer = $defaultVIServer
	}
	if ($destinationServer -eq $null) {
		$destinationServer = $global:defaultVIServer
	}
	if ($destinationServer -eq $null) {
		write-error "Can't determine destination server, are you connected?"
		return
	}
	if ($destinationIsDatastore) {
		if ($destinationDatacenter -eq $null) {
			write-error "Need a -destinationDatacenter argument"
			return
		}
		$destinationUrl = Build-TkeUploadHttpPath -server $destinationServer -datacenter $destinationDatacenter -path $destination
	} elseif ($destinationIsLocalPath) {
		# Upload a file to a local directory (usually /tmp).
		$destinationUrl = Build-TkeUploadHttpPath -server $destinationServer -path $destination -localPath
	} else {
		$destinationUrl = $destination
	}

	$sourceIsHttp = ($sourceUrl -match "^http")
	$destinationIsHttp = ($destinationUrl -match "^http")
	if ($sourceIsHttp) {
		$sourceWC = new-object system.net.webclient
		if ($sourceCredential) {
			$sourceWC.set_Credentials($sourceCredential.GetNetworkCredential())
		} elseif ($sourceIsDatastore) {
			$sourceWC.headers.Add('Cookie: vmware_soap_session="' + $sourceServer.SessionId + '"')
		}
	}
	if ($destinationIsHttp) {
		$destinationWR = New-TkeTrustAllHttpWebRequest -URL $destinationURL
		# This prevents connection re-use, which causes PowerCLI to choke.
		$destinationWR.ConnectionGroupName = "filetransfer" + (get-random)
		if ($destinationCredential) {
			$destinationWR.set_Credentials($destinationCredential.GetNetworkCredential())
		} elseif ($destinationIsDatastore -or $destinationIsLocalPath) {
			$destinationWR.headers.Add('Cookie: vmware_soap_session="' + $destinationServer.SessionId + '"')
		}
	}

	# XXX: TODO: Figure out how to do a "finally" clause in a sane way.
	# XXX: This doesn't trap Ctrl-C and may leave resources open.
	$ErrorActionPreference = "Stop"
	trap [Exception] {
		if ($sourceStream) {
			$sourceStream.Close()
			$sourceStream.Dispose()
		}
		if ($destinationStream) {
			$destinationStream.Close()
			$destinationStream.Dispose()
		}
		break
	}

	# Transfer the file.
	if ($sourceIsHttp -and $destinationIsHttp) {
		$sourceStream = $sourceWC.OpenRead($sourceUrl)
		$totalLength = $sourceWC.ResponseHeaders["Content-Length"]
		$destinationWR.ContentLength=$totalLength
		$destinationStream = $destinationWR.getRequestStream()

		$activity = "Transferring"
		$status = "Transferring $source"
	} elseif ($sourceIsHttp) {
		$sourceStream = $sourceWC.OpenRead($sourceUrl)
		$totalLength = $sourceWC.ResponseHeaders["Content-Length"]
		$item = new-item $destination -type file -force
		$destinationStream = $item.OpenWrite()

		$activity = "Downloading"
		$status = "Downloading $source"
	} elseif ($destinationIsHttp) {
		$item = get-childitem $source
		$sourceStream = $item.OpenRead()
		$totalLength = $item.length
		$destinationWR.ContentLength=$totalLength
		$destinationStream = $destinationWR.getRequestStream()

		$activity = "Uploading"
		$status = "Uploading $source"
	} else {
		write-error "Local copy not supported"
		return
	}

	$bufferSize = 32768
	$buffer = new-object byte[] $bufferSize
	if ($totalLength -gt 0 -and (-not $noprogress)) {
		$written = 0
		$increment = $currentIncrement = [int]($length / 100)
		write-progress -activity $activity -status $status -percentComplete 0
	}
	do {
		$len = $sourceStream.Read($buffer, 0, $bufferSize)
		$destinationStream.Write($buffer, 0, $len)
		if ($totalLength -gt 0 -and (-not $noprogress)) {
			$written += $len
			$currentIncrement -= $len
			if ($currentIncrement -lt 0) {
				write-progress -activity $activity -status $status -percentComplete ([int]($written * 100 / $totalLength))
				$currentIncrement = $increment
			}
		}
	} while ($len -ne 0)
	$sourceStream.Close()
	$sourceStream.Dispose()
	$destinationStream.Close()
	$destinationStream.Dispose()
}

# List files in a datastore. Optionally lists only one subdirectory.
# XXX: This shouldn't use the _Task form of the browser call.
function Get-TkeDatastoreFile {
	param(
	[Parameter(Mandatory=$true,ValueFromPipeline=$true,HelpMessage="Datastores to get files from")]
	[VMware.VimAutomation.Client20.DatastoreImpl]
	$datastore,

	[Parameter(HelpMessage="Subpath to search")]
	[string]
	$subpath = "",

	[Parameter(HelpMessage="If set to true, don't get the file size")]
	[switch]
	$noSize,

	[Parameter(HelpMessage="If set to true, don't get the file type")]
	[switch]
	$noType,

	[Parameter(HelpMessage="If set to true, don't get the file modification date")]
	[switch]
	$noModification
	)

	Process {
		$datastoreView = $datastore | get-view
		$datastoreBrowser = get-view $datastoreView.browser
		$name = $datastore.name
		$spec = new-object vmware.vim.HostDatastoreBrowserSearchSpec
		$queryFlags = new-object vmware.vim.FileQueryFlags
		if ($queryFlags | Get-Member FileOwner) {
			$queryFlags = $true
		}
		$queryFlags = -not $noSize
		$queryFlags = -not $noType
		$queryFlags = -not $noModification
		# XXX: A bug in PowerCLI 4 prevents this from working.
		#$spec.details = $queryFlags
		$task = $datastoreBrowser.SearchDatastoreSubFolders_Task("[$name] /$subpath", $spec)

		$view = get-view $task
		while ($view.info.state -eq "running") {
			start-sleep 1
			$view = get-view $task
		}
		if ($view.info.result -eq $null) {
			return
		}
		foreach ($result in $view.info.result) {
			$folderPath = $result.FolderPath
			if ($folderPath[-1] -ne "/") {
				$folderPath += "/"
			}
			foreach ($file in $result.File) {
				$fullPath = $folderPath + $file.Path
				$obj = new-object psobject
				$obj | add-member -type noteproperty -name "Path" -value $fullPath
				$obj | add-member -type noteproperty -name "Size" -value $file.FileSize
				$obj | add-member -type noteproperty -name "Modification" -value $file.Modification
				$obj | add-member -type noteproperty -name "Datastore" -value $ds.Name
				Write-Output $obj
			}
		}
	}
}

# Find any orphaned VMDKs on datastores.
# Please interpret your results with caution if your datastores are in use
# from multiple VC instances.
# Originally by HJA van Bokhoven.
function Get-TkeOrphanedVmdk {
	$ret = @()
	$arrUsedDisks = Get-VM | Get-HardDisk | % {$_.filename}
	foreach ($datastore in (get-datastore)) {
		$searchResult = Get-TkeDatastoreFile -datastore $datastore
		foreach ($file in $searchResult) {
			if ($file.Path.Contains(".vmdk")) {
				#write-host "Checking ", $file.Path
				if ($file.Path.contains("-flat.vmdk")) {
					continue
				}
				if ($file.Path.contains("delta.vmdk")) {
					continue
				}

				$strCheckfile = "*" + $file.Path + "*"
				if (-not ($arrUsedDisks -like $strCheckfile)) {
					$obj = new-object psobject
					$obj | add-member -type NoteProperty -name "OrphanedVMDK" -value $file.Path
					$ret += $obj
				}
			}
		}
	}

	return $ret
}
#endregion

######################################
### VM Operations                  ###
######################################
#region VM
function New-TkeLinkedClone {
	param(
	[Parameter(Mandatory=$true,ValueFromPipeline=$true,HelpMessage="The VM to clone")]
	[VMware.VimAutomation.Client20.VirtualMachineImpl]
	$vm,

	[Parameter(HelpMessage="The VMHost for the new linked clones")]
	[VMware.VimAutomation.Client20.VMHostImpl]
	$vmhost,
	
	[Parameter(HelpMessage="VM Name template (ex: Clone{0:00000})")]
	[string]
	$template,

	[Parameter(Mandatory=$true,HelpMessage="The number of clones to make")]
	[int]
	$nClones
	)

	# Set the host if it's not already.
	if ($vmhost -eq $null) {
		$vmhost = $vm | Get-VMHost
	}
	# Use a default template if none was given.
	if ($template -eq $null) {
		$template = $vm.Name + " Clone {0:00000}"
	}
	# We also need the VM's datacenter.
	$datacenter = $vm | Get-Datacenter

	# Locate the directory and VMX for this VM.
	$vmView = $vm | get-view -Property config
	$oldVmx = $vmView.Config.Files.VmPathName
	$oldDirectory = $vmView.Config.Files.SnapshotDirectory

	# Download this VM's VMX file.
	$tempVmxFile = "$env:TEMP\temp.vmx"
	Copy-TkeDatastoreFile -source $oldVmx -destination $tempVmxFile -sourceDatacenter $datacenter -noprogress
	$tempVmx = Get-Content $tempVmxFile
	Remove-Item $tempVmxFile

	# There seems to be a bug around getting folders more than once in VI4 beta2, so do it once here for all VMs.
	# XXX: The bug seems to be related to file uploads killing the session.
	$folder = Get-Folder vm
	$resourcePool = $vmhost | Get-ResourcePool resources

	for ($i = 1; $i -le $nClones; $i++) {
		# Get the name for this instance.
		$vmName = $template -f $i

		# Make a subdirectory to hold this linked clone.
		$newDirectory = $oldDirectory + "/$vmName"
		$newVmxFile = $newDirectory + "/$vmName.vmx"
		#New-TkeDatastoreDirectory -path $newDirectory -datacenter $datacenter

		# Modify the VMX settings for the new clone. Get rid of lines that mention uuid or swap derived name.
		$newVmx = $tempVmx
		$newVmx = $newVmx | where { -not ($_ -match "uuid") }
		$newVmx = $newVmx | where { -not ($_ -match "derivedName") }

		# Replace the VMX, VMSD and NVRAM variables.
		$newVmx = Replace-StringArray -stringArray $newVmx -old 'nvram = ".+"'              -new "nvram = `"$vmName.nvram`""
		$newVmx = Replace-StringArray -stringArray $newVmx -old 'displayName = ".+"'        -new "displayName = `"$vmName`""
		$newVmx = Replace-StringArray -stringArray $newVmx -old 'extendedConfigFile = ".+"' -new "extendedConfigFile = `"$vmName.vmxf`""

		# Point the disks to the parent directory.
		$newVmx = Replace-StringArray -stringArray $newVmx -old '"(.+.vmdk")' -new '"../$1'

		# Copy the modified VMX file into this new subdirectory.
		$encoding = New-Object system.Text.UTF8Encoding
		$newVmxBytes = $encoding.GetBytes([string]::Join("`n", $newVmx) + "`n")
		$newVmxBytes | Set-Content -Encoding byte $tempVmxFile
		Copy-TkeDatastoreFile -source $tempVmxFile -destination $newVmxFile -destinationDatacenter $datacenter -noprogress

		# Register this clone.
		$moRef = Register-TkeVM -vmxfile $newVmxFile -vmhost $vmhost -folder $folder -resourcepool $resourcepool
		$newVM = $moRef | Get-VIObjectByVIView

		# Take a snapshot while it is still powered off.
		$snap = $newVM | New-Snapshot -Name "Base Clone -- Don't Delete"
		$newVM
	}
}

function Get-TkeVMRemoteConsole {
	param(
	[Parameter(Mandatory=$true,ValueFromPipeline=$true,HelpMessage="VMs for which we open remote consoles")]
	[VMware.VimAutomation.Client20.VirtualMachineImpl[]]
	$vm,

	[Parameter(HelpMessage="Use VNC")]
	[switch]
	$useVnc
	)

	foreach ($v in $vm) {
		$guest = $v | get-vmguest
		if ($guest -eq $null) {
			write-error "VMware tools is not installed, can't determine IP address."
			return
		}
		if ($guest.state -ne "Running") {
			write-error "VMware tools is not running, can't determine IP address."
			return
		}
		$ip = $guest.IPAddress[0]

		if ($useVnc) {
			$vnc = Locate-Vnc
			if ($vnc -eq $null) {
				write-error "Can't locate a VNC viewer. Please install one and retry."
				return
			}
			& $vnc.definition $ip
		} else {
			if ($guest.OSFullName -match "Windows") {
				mstsc /v $ip
			} else {
				$putty = Locate-Putty
				if ($putty -eq $null) {
					write-error "Can't locate putty. Please install it and retry."
					return
				}
				& $putty.definition $ip
			}
		}
	}
}

# Return an array representing lines in a file formatted in VMX format. This may be the VMX file
# itself but could also be other files, such as the VMSD file.
function Get-TkeVmxFormatData {
	param($path, $datacenter)

	$ret = @()
	$destinationFile = ($env:TEMP + "_temp.vmx")
	Copy-TkeDatastoreFile -source $path -destination $destinationFile -sourceDatacenter $datacenter -noprogress
	$ret += Get-TkeVmxEntries $destinationFile
	remove-item $destinationFile
	return $ret
}

# Retrieve the contents of a VM's VMSD (Snapshot Definition) file.
function Get-TkeVmsd {
	param(
	[Parameter(Mandatory=$true,ValueFromPipeline=$true,HelpMessage="VMs for which we list VMX entries")]
	[VMware.VimAutomation.Client20.VirtualMachineImpl[]]
	$vm
	)

	$ret = @()
	foreach ($v in $vm) {
		# Get the path to the VMX file. We assume the VMSD file is in the same directory.
		# XXX: This may not be a very smart assumption.
		$vmView = $v | get-view
		$vmxPath = $vmView.Config.Files.VmPathName
		$vmsdPath = $vmxPath -replace "vmx$", "vmsd"
		$datacenter = $vm | get-datacenter

		# Parse the VMSD itself.
		$ret += Get-TkeVmxFormatData -path $vmsdPath -datacenter $datacenter
	}

	return $ret
}

# Retrieve the contents of a VM's VMX file.
function Get-TkeVmx {
	param(
	[Parameter(Mandatory=$true,ValueFromPipeline=$true,HelpMessage="VMs for which we list VMX entries")]
	[VMware.VimAutomation.Client20.VirtualMachineImpl]
	$vm
	)

	Process {
		# Get the path to the VMX file.
		$vmView = $vm | get-view
		$vmxPath = $vmView.Config.Files.VmPathName
		$datacenter = $vm | get-datacenter

		# Parse the VMX itself.
		Write-Output (Get-TkeVmxFormatData -path $vmxPath -datacenter $datacenter)
	}
}

# Sets a VMX value.
function Set-TkeVmx {
	param(
	[Parameter(Mandatory=$true,ValueFromPipeline=$true,HelpMessage="VMs for which we list VMX entries")]
	[VMware.VimAutomation.Client20.VirtualMachineImpl[]]
	$vm,

	[Parameter(Mandatory=$true,HelpMessage="VMX Key Name")]
	[String]
	$key,

	[Parameter(Mandatory=$true,HelpMessage="VMX Key Value")]
	[String]
	$value
	)

	$vmConfigSpec = new-object VMware.Vim.VirtualMachineConfigSpec
	$vmConfigSpec.ExtraConfig += new-object VMware.Vim.OptionValue
	$vmConfigSpec.ExtraConfig[0].key = $key
	$vmConfigSpec.ExtraConfig[0].value = $value

	foreach ($v in $vm) {
		$view = $v | get-view
		$view.ReconfigVM_Task($vmConfigSpec) | get-viobjectbyviview | wait-task
	}
}

# Find the date when a VM's log file was last modified. This may correlate well
# with the last time the VM was used.
function Get-TkeLogLastModifiedDate {
	param(
	[Parameter(Mandatory=$true,ValueFromPipeline=$true,HelpMessage="VMs to process")]
	[VMware.VimAutomation.Client20.VirtualMachineImpl[]]
	$vm
	)

	$ret = @()
	foreach ($v in $vm) {
		$vmDirectory = Get-TkeVMPath $v
		$logFile = $vmDirectory + "vmware.log"

		$datastore = $v | get-datastore
		$files = get-datastorefiles -datastore $datastore -subpath $subpath
		$entry = $files | where { $_.Path -eq $logFile }
		$obj = new-object psobject
		$obj | add-member -type noteproperty -name "Name" -value $v.Name
		if ($entry) {
			$obj | add-member -type noteproperty -name "LogLastModifiedDate" -value $entry.modification
		} else {
			$obj | add-member -type noteproperty -name "LogLastModifiedDate" -value (new-object datetime)
		}
		$ret += $obj
	}

	return $ret
}

# Kills a VM's process. This is done by logging into the system via SSH.
# If you are using ESXi you must enable SSH for this to work. Also requires plink to be installed.
# Doesn't support certificate-based auth currently.
function Stop-TkeVMProcess {
	param(
	[Parameter(Mandatory=$true,ValueFromPipeline=$true,HelpMessage="VMs to process")]
	[VMware.VimAutomation.Client20.VirtualMachineImpl[]]
	$vm,

	[Parameter(Mandatory=$true,HelpMessage="Login credential to ESX")]
	[System.Management.Automation.PSCredential]
	$credential
	)

	# We kill the VM based on the VMX path. This deals with escaping issues for strange
# characters and the fact that VM names don't have to map to VMX paths.
	foreach ($v in $vm) {
		$vmView = $v | get-view
		$vmxPath = $vmView.config.files.VmPathName
		$components = Extract-TkeDatastorePathElements -path $vmxPath
		$cred = $credential.GetNetworkCredential()
		$hostServer = $v | get-vmhost

		$command = "kill -9 ``ps auxwww | grep '" + $components.path + "' | grep -v grep " + 
		" | awk '" + '{print $2}' + "'``"
 Execute-RemoteSshCommand -remoteHost $hostServer.Name -credential $credential -command
	}
}

# Get a VM's layout.
function Get-TkeVMLayout {
	param ($vmView)

	if ($vmView.layout -eq $null) {
		# layout is gone starting with VI4.
		$layout = $vmView.layoutEx
	} else {
		$layout = $vmView.layout
	}
	return $layout
}

# Locate a snapshot in a VM's layout.
function Get-TkeSnapshotWithinLayout {
	param ($vmView, $snapshot)

	$layout = Get-TkeVMLayout $vmView
	return $layout.snapshot | where { ($_.Key.Type + "-" + $_.Key.Value) -eq $snapshot.id }
}

# Sum up the sizes of all files matching a specified pattern.
function Add-TkeFileSize {
	param ($files, $pattern, [switch]$simpleMatch)

	$ret = 0
	if ($simpleMatch) {
		foreach ($file in $files) {
			if ($file.Path -eq $pattern) {
				$ret += $file.Size
			}
		}
	} else {
		foreach ($file in $files) {
			if ($file.Path -match $pattern) {
				$ret += $file.Size
			}
		}
	}
	return $ret
}

# Get snapshots for all specified virtual machines, including the size of the snapshot.
# Two important points to note: the current snapshot is considered to have all non-commited data.
# Any leaf snapshot that is not the current snapshot has no delta information, so its size is only the contents of its vmsn file.
function Get-TkeSnapshotExtended {
	param(
	[Parameter(Mandatory=$true,ValueFromPipeline=$true,HelpMessage="VMs to process")]
	[VMware.VimAutomation.Client20.VirtualMachineImpl[]]
	$vms
	)

	process {
		foreach ($vm in $vms) {
			$snapshots = $vm | get-snapshot
			if (!$snapshots) {
				return
			}

			# Get the VM's view.
			$vmView = $vm | get-view -property layout,snapshot

			# We only support the case of all snapshots in the same directory.
			$layout = Get-TkeVMLayout $vmView
			$ssView = get-view $layout.snapshot[0].key -property config
			$snapshotDirectory = $ssView.config.files.snapshotdirectory
			$elements = Extract-TkeDatastorePathElements -path $snapshotDirectory
			$files = Get-TkeDatastoreFile -datastore (get-datastore $elements.datastore) -subpath $elements.path -notype -nomodification

			foreach ($s in $snapshots) {
				# Get the layout for this snapshot.
				$snapshot = Get-TkeSnapshotWithinLayout $vmView $s

				# First, let's find the size of this snapshot's VMSN file.
				$totalSize = Add-TkeFileSize $files $snapshot.snapshotFile[1] -simpleMatch

				# If we have any children, their base delta disks count against the size of this snapshot.
				if ($s.children -ne $null) {
					foreach ($child in $s.children) {
						$thisChild = Get-TkeSnapshotWithinLayout $vmView $child
						$thisChild.snapshotFile[0] -match "(\d+).vmdk" > $null
						$totalSize += Add-TkeFileSize $files $matches[1]
					}
				}

				# Is this the current snapshot? Non-committed data is considered to belong to the current snapshot.
				# $ssView = $s | get-view
				$currentSnapshot = $vmView.snapshot.currentSnapshot
				$isCurrent = ($currentSnapshot.Type + "-" + $currentSnapshot.Value) -eq $s.id
				if ($isCurrent) {
					$used = $layout.snapshot | ? { $_.SnapshotFile[0] -match "(\d+).vmdk" } | % { $matches[1] } | select -unique
					$available = $files | ? { $_.Path -match "(\d+).vmdk" } | % { $matches[1] } | select -unique
					$disksToAdd = $available | ? { $used -notcontains $_ } # This should be a set of one.
					foreach ($disk in $disksToAdd) {
						$totalSize += Add-TkeFileSize $files ($disk + "-delta.vmdk")
					}
				}

				# Add this to the input object and pass it through.
				$s | add-member -type noteproperty -name "SizeMB" -value ($totalSize / 1mb)
				$s
			}
		}
	}
}

# Register a VM in a host's inventory.
function Register-TkeVM {
	param(
	[Parameter(Mandatory=$true,ValueFromPipeline=$true,HelpMessage="VMX files to register")]
	[String[]]
	$VmxFile,

	[Parameter(Mandatory=$true,ValueFromPipeline=$true,HelpMessage="The host for the new VM")]
	[VMware.VimAutomation.Client20.VMHostImpl]
	$VMhost,

	[VMware.VimAutomation.Client20.ResourcePoolImpl]
	$ResourcePool,

	[VMware.VimAutomation.Client20.FolderImpl]
	$Folder
	)

	if ($Folder -eq $null) {
		$Folder = get-folder vm
	}
	if ($ResourcePool -eq $null) {
		$ResourcePool = $VMHost | get-resourcepool resources
	}
	$ResourcePoolView = $ResourcePool | get-view -property name
	$FolderView = $folder | get-view -property name
	$VMHostView = $VMHost | get-view -property name

	foreach ($file in $VmxFile) {
		$file -match '/([^/]+).vmx$' > $null
		$vmName = $matches[1]
		if (!$vmName) {
			write-warning "Can't determine VM name for $file, skipping"
		} else {
			$mor = $FolderView.RegisterVM($file, $vmName, $false, $ResourcePoolView.MoRef, $VMHostView.MoRef)
			$mor
		}
	}
}

# Storage VMotion a VM from one datastore to another.
# Note that move-vm doesn't work properly in 1.0 for pure SVmotion. This function
# should become obsolete in version 1.5.
function SVmotion-TkeVM {
	param(
	[Parameter(Mandatory=$true,ValueFromPipeline=$true,HelpMessage="VMX files to register")]
	[Mandatory]
	[ValueFromPipeline]
	[VMware.VimAutomation.Client20.VirtualMachineImpl[]]
	$vm,

	[Mandatory]
	[VMware.VimAutomation.Client20.DatastoreImpl]
	$destination
	)

	Begin {
		$datastoreView = Get-View -VIObject $destination
		$relocationSpec = New-Object VMware.Vim.VirtualMachineRelocateSpec
		$relocationSpec.Datastore = $datastoreView.MoRef
	}

	Process {
		$vmView = Get-View -VIObject $_
		$vmView.RelocateVM_Task($relocationSpec)
	}
}
#endregion

######################################
### Miscellaneous Operations       ###
######################################
#region Misc
# Turns (some) log entries into real objects.
function Get-TkeLogObject {
	param(
		[Parameter(Mandatory=$true,ValueFromPipeline=$true,HelpMessage="Output from Get-Log")]
		[System.Object] # Hack! VMware.VimAutomation.Client20.LogImpl is marked private.
		$Log
	)

	# This format is also used by vpxa
	$hostdEsx4Regex    = "\[(?<Date>[^ ]+) (?<Time>[^ ]+) (?<ID>[^ ]+) (?<Level>[^ ]+) (?<Object>'[^']+')\] (?<Message>.+)"
	$messagesEsx4Regex = ""
	$entries = $Log.Entries
	foreach ($entry in $entries) {
		if ($entry -match $hostdEsx4Regex) {
			$logObj = New-Object System.Management.Automation.PsObject
			foreach ($property in "Date","Time","Object","ID","Level","Message") {
				$logObj | Add-Member NoteProperty $property $matches.$property
			}
			$logObj
		}
	}
}

# Gets custom fields from an inventory item as a set of PowerShell objects.
function Get-TkeCustomField {
	param(
		[Parameter(Mandatory=$true,ValueFromPipeline=$true,HelpMessage="The item in question.")]
		[VMware.VimAutomation.Client20.InventoryItemImpl]
		$item
	)

	Process {
		foreach ($cf in $item.CustomFields) {
			$field = "" | Select Key, Value, EntityName
			$field.Key        = $cf.Key
			$field.Value      = $cf.Value
			$field.EntityName = $item.Name
			$field
		}
	}
}

# Back a VM up using VCB 1.1
# This function was contributed by Justin Grote (jgrote*NO*@!SPAM!enpointe.|PLEASE|com) 7/15/2008.
function Backup-VM {
	[CmdletBinding(SupportsShouldProcess=$true)]
	param (
	# Virtual Machine Location to back up
	[Mandatory]
	[ValueFromPipeline]
	[HelpMessage("Virtual Machines to Back Up")]
	[VMware.VimAutomation.Client20.VirtualMachineImpl]
	$VM,

	# Path to backup location (ex. "G:\MyBackups")
	[Mandatory]
	[HelpMessage("Path to backup location (ex. 'G:\MyBackups')")]
	[string]
	$Destination,

	#VCB Mode
	[string]$Mode = "nbd",
	[ValidateRange(0,6)]
	[int]$Verbosity = 0,

	# Other parameters
	[bool]$Monolithic = 0,

	#Backup Credentials
	[string]$VCBHost = $VCBHOST, #Hostname of Virtualcenter/ESX Server
	[string]$User = $VCBUSER, #User to connect with. I Recommend a VCB Service Account
	[string]$Password = $VCBPASSWORD #Password for the user
	) #Param

	Begin {
		#Validate Parameters
		foreach ($Parameter in $VCBHost,$User,$Password) { 
			if ( $Parameter -eq $null ) { Throw "Backup-VM: Missing VMware Infrastructure credentials. Please use the -VCBHost, -User, and -Password arguments, or define VCBHOST, VCBUSER and VCBPASSWORD global variables" }
		} #Validate Parameters

#Ensure that VMWare Consolidated Backup is installed
		$VCBMounter = (Get-Itemproperty "hklm:\SOFTWARE\VMware, Inc.\VMware Consolidated Backup\").installpath
		$VCBMounter += "vcbMounter.exe"
		if (-not (Test-Path $VCBMounter)) { Throw "Backup-VM: VMWare Consolidated Backup 1.1 or better is not installed. Please install it and retry this script."}
	} #Begin

	Process {
		write-host -fore yellow "Backing up " $VM.Name "to $destination"
		foreach ($V in $VM) { 
			#Create the VCBMounter Command arguments
#BREAK WARNING: This script uses some string manipulation to get the MoRef for the VM. If the format of the $VM.ID property changes, this will break!
			$VCBMounterArgs = "-h `'$VCBHost`'"
			$VCBMounterArgs += " -u `'$User`'"
			$VCBMounterArgs += " -p `'$Password`'"
			$VCBMounterArgs += " -m `'$Mode`'"
			$VCBMounterArgs += " -L `'$Verbosity`'"
			$VCBMounterArgs += " -a `'moref:$($V.ID.substring(15))`'"
			$VCBMounterArgs += " -r `'$Destination\$($V.Name)`'"
			if ($monolithic) {
				$VCBMounterArgs += " -M"
			}

			#Run VCBMounter backup for this Virtual Machine
			write-host -fore cyan "VCB Command: & $VCBMounter `"$VCBMounterArgs`""
			invoke-expression "& '$VCBMounter' $VCBMounterArgs"
		} #Foreach
	} #Process
} # Backup-VM

# Close all sessions that are inactive for longer than '$limit' minutes.
# The function returns the number of sessions that were closed
# v1.0 - 24/12/08 - LucD
function Disconnect-TkeIdleSession
{
	param (
	# Inactivity time cutoff value
	[Parameter(Mandatory=$true,HelpMessage="Inactivity time cutoff")]
	[int]
	$limit
	)

	Begin {
		$sessMgr = Get-View SessionManager
		$idleSessions = @()
	}

	Process {
		foreach($session in $sessMgr.SessionList){
			$idle = [int]((Get-Date) - ($session.LastActiveTime).ToLocalTime()).TotalMinutes
			if($idle -gt $limit){
				$idleSessions += $session.Key
			}
		}
		$sessMgr.TerminateSession($idleSessions)
	}
	End {
		return $idleSessions.Count
	}
}

# Get a list of all GuestIds that are supported by a specific ESX server
# v1.0 - 24/12/08 - LucD
function Get-TkeValidGuestIds
{
	param(
	[Parameter(Mandatory=$true, ValueFromPipeline=$true, HelpMessage="One or more hosts from which to get the valid GuestIds")]
	[VMware.VimAutomation.Client20.VMHostImpl[]]
	$vmhost
	)
	Begin{ 
		$guestIds = @()
	}
	Process{
		$esx = Get-View -Id $_.Id
		$envBrowser = Get-View -Id (Get-View -id $esx.Parent).EnvironmentBrowser
		$VMConfigOptionDescriptors = ($envBrowser.QueryConfigOptionDescriptor).Invoke()

		foreach($desc in $VMConfigOptionDescriptors){
			$config = $envBrowser.QueryConfigOption($desc.Key, $esx.MoRef)
			foreach($os in $config.GuestOSDescriptor){
				if(-not($guestIds -contains $os.Id)){
					$guestIds += $os.Id
				}
			}
		}
		#		}
	}
	End{
		return $guestIds
	}
}
#endregion

#region Permissions
# Get all permissions on a entity
# v1.0 - 29/12/08 - LucD
<#
.Synopsis
Returns all permissions on one or more VI objects
.Description
Returns all permissions set on one or more VI objects.
With the -inherited switch the function can include/exclude the inherited permissions
on the VI object(s).
The returned object(s) contain the Entity property which is the VI object on which the
permission is set.
The returned object(s) contain the Role property which is rolename that was used to give
The specific permission.
.Parameter object 
One or more VI objects (can be datacenters, folders, vmhosts, virtual machines...)
.Parameter inherited
A switch that allows to specify if inherited permissions should be included in the output.
The default for this switch is $false
.Example
$esx = Get-VMHost my.esx.server
Get-TkePermissions $esx
.Example
Get-folder MyFolder | Get-TkePermissions - inherited:$true
#>
function Get-TkePermissions
{
	param(
	[Parameter(Mandatory=$true, ValueFromPipeline=$true, HelpMessage="One or more virtual infrastructure container objects (e.g. folders, datacenters, clusters) to get the permissions from.")]
	[VMware.VimAutomation.Types.VIObject[]]
	$object,
	[Parameter(Mandatory=$false, ValueFromPipeline=$false, HelpMessage="Include inherited permissions")]
	[switch]
	$inherited = $false
	)
	Begin{
		$report = @()
		$authMgr = Get-View AuthorizationManager
	}
	Process{
		foreach($objImpl in $object){
			$obj = $objImpl | Get-View
			$perms = $authMgr.RetrieveEntityPermissions($obj.MoRef,$inherited)
			foreach($perm in $perms){
				$ret = New-Object PSObject
				$ret | Add-Member -Type noteproperty -Name "Entity" -Value ($perm.Entity | Get-VIObjectByVIView)
				$ret | Add-Member -Type noteproperty -Name "Group" -Value $perm.Group
				$ret | Add-Member -Type noteproperty -Name "Principal" -Value $perm.Principal
				$ret | Add-Member -Type noteproperty -Name "Propagate" -Value $perm.Propagate
				$ret | Add-Member -Type noteproperty -Name "Role" -Value ($authMgr.RoleList | Where-Object {$_.RoleId -eq $perm.RoleId} | % {$_.Name})
				$report += $ret
			}
		}
	}
	End{
		return $report
	}
}

# Set permissions on an entity
# v1.0 - 30/12/08 - LucD
<#
.Synopsis
Sets permissions on one or more VI entities
.Description
Sets permissions on one or more VI entities.
VI entities can be vmhosts, clusters, datacenters, folders, resource pools or virtual machines.
.Parameter object 
One or more VI entities
.Parameter permission
One or more permissions that will be applied on the VI object(s).
A permision object has the following properties
Principal [string] user or group receiving access in the form of "login" for local or "DOMAIN\login" for users in a Windows domain. 
Group [boolean] whether principal refers to a user or a group. True for a group and false for a user. 
Propagate [boolean] whether or not this permission propagates down the hierarchy to sub-entities.
RoleId [int] reference to the role providing the access. See Get-TkeRoles 
.Example
$esx = Get-VMHost my.esx.server
$MyPermission = New-Object VMware.Vim.Permission
$MyPermission.principal = "MyDomain\MyAccount"
$MyPermission.group = $false
$myPermission.propagate = $false
$MyPermission.RoleId = (Get-TkeRoles | Where-Object {$_.Name -eq "ReadOnly"} | % {$_.RoleId}) 
Set-TkePermissions $esx $MyPermission
#>
function Set-TkePermissions
{
	param(
	[Parameter(Mandatory=$true, ValueFromPipeline=$true, HelpMessage="One or more VI entities (e.g. vmhosts, clusters, datacenters, folders, resource pools, virtual machines).")]
	[VMware.VimAutomation.Types.VIObject[]]
	$object,
	[Parameter(Mandatory=$true, ValueFromPipeline=$false, HelpMessage="Principal")]
	[VMware.Vim.Permission[]]
	$permission
	)
	Begin{
		$authMgr = Get-View AuthorizationManager
	}
	Process{
		foreach($objImpl in $object){
			$obj = $objImpl | Get-View
			$perms = $authMgr.SetEntityPermissions($obj.MoRef,$permission)
		}
	}
	End{
		return
	}
}

# Remove permissions from an entity
# v1.0 - 30/12/08 - LucD
<#
.Synopsis
Remove a permission from one or more VI entities
.Description
Remove a permission from one or more VI entities.
VI entities can be vmhosts, clusters, datacenters, folders, resource pools or virtual machines.
.Parameter object 
One or more VI entities
.Parameter principal
The user or group identification.
.Parameter isGroup
A switch to indicate if the principal is a user or a group.
Default is $false (a user)
.Example
Get-VMHost my.esx.server | Remove-TkePermissions -principal "MyDomain\MyAccount" 
#>
function Remove-TkePermissions
{
	param(
	[Parameter(Mandatory=$true, ValueFromPipeline=$true, HelpMessage="One or more VI entities (e.g. vmhosts, clusters, datacenters, folders, resource pools, virtual machines).")]
	[VMware.VimAutomation.Types.VIObject[]]
	$object,
	[Parameter(Mandatory=$true, ValueFromPipeline=$false, HelpMessage="Principal")]
	[string]
	$principal,
	[Parameter(Mandatory=$false, ValueFromPipeline=$false, HelpMessage="Is the principal a group ?")]
	[switch]
	$isGroup = $false
	)
	Begin{
		$authMgr = Get-View AuthorizationManager
	}
	Process{
		foreach($objImpl in $object){
			$obj = $objImpl | Get-View
			$authMgr.RemoveEntityPermission($obj.MoRef,$principal,$isGroup)
		}
	}
	End{
		return
	}
}

# Get roles
# v1.0 - 30/12/08 - LucD
<#
.Synopsis
Get the roles defined in the VI system
.Description
Get a list of all the roles that are defined in the VI system.
The cmdlet returns an array of role objects.
A role object has the following properties
Name [string] internal or user-defined name of the role
Label [string] display label
Summary [string] summary description
RoleId [int] unique role identifier
System [boolean] whether or not the role is system-defined
Privilege [string[]] privilege(s) provided by this role, by privilege identifier
.Example
$roles = Get-TkeRoles
#>
function Get-TkeRoles
{
	Begin{
		$authMgr = Get-View AuthorizationManager
		$report = @()
	}
	Process{
		foreach($role in $authMgr.roleList){
			$ret = New-Object PSObject
			$ret | Add-Member -Type noteproperty -Name "Name" -Value $role.name
			$ret | Add-Member -Type noteproperty -Name "Label" -Value $role.info.label
			$ret | Add-Member -Type noteproperty -Name "Summary" -Value $role.info.summary
			$ret | Add-Member -Type noteproperty -Name "RoleId" -Value $role.roleId
			$ret | Add-Member -Type noteproperty -Name "System" -Value $role.system
			$ret | Add-Member -Type noteproperty -Name "Privilege" -Value $role.privilege
			$report += $ret
		}
	}
	End{
		return $report
	}
}

# Create a role
# v1.0 - 30/12/08 - LucD
<#
.Synopsis
Create a new role.
.Description
Create a new role in the VI environment.
.Parameter name
The name of the new role
.Parameter privIds
An array with the privilege ids that will be assigned to the new role.
Use Get-TkeAllPrivileges to get a list of all available privileges
.Example
New-TkeRole -name "MyRole" -privIds "VirtualMachine.Interact.PowerOn","VirtualMachine.Interact.PowerOff" 
#>
function New-TkeRole
{
	param(
	[Parameter(Mandatory=$true, ValueFromPipeline=$true, HelpMessage="Role name")]
	[string]
	$name,
	[Parameter(Mandatory=$true, ValueFromPipeline=$false, HelpMessage="Principal")]
	[string[]]
	$privIds
	)
	Begin{
		$authMgr = Get-View AuthorizationManager
	}
	Process{
		$roleId = $authMgr.AddAuthorizationRole($name,$privIds)
	}
	End{
		return $roleId
	}
}

# Change an existing role
# v1.0 - 30/12/08 - LucD
# v1.1 - 31/12/08 - LucD - accept $newName -eq $null
#                        - add append switch
<#
.Synopsis
Change the name and/or the privileges of a role
.Description
.Parameter name
The name of the role.
.Parameter newName
The new name of the role
.Parameter privIds
An array with the privilege ids that will be added to the role.
.Parameter append
A switch that defines if the new privileges are appended to the existing privileges or not.
The default is $true, the privileges are appended.
.Example
Set-TkeRole -name "MyRole" -newName "MyNewRole"
.Example
Set-TkeRole -name "MyRole" -privIds "VirtualMachine.Interact.Suspend","VirtualMachine.Interact.Reset"
#>
function Set-TkeRole
{
	param(
	[Parameter(Mandatory=$true, ValueFromPipeline=$true, HelpMessage="Role name")]
	[string]
	$name,
	[Parameter(Mandatory=$false, ValueFromPipeline=$false, HelpMessage="Optional new role name")]
	[string]
	$newName,
	[Parameter(Mandatory=$false, ValueFromPipeline=$false, HelpMessage="Role privileges")]
	[string[]]
	$privIds,
	[Parameter(Mandatory=$false, ValueFromPipeline=$false, HelpMessage="Append new privileges")]
	[switch]
	$append = $true
	)
	Begin{
		$authMgr = Get-View AuthorizationManager
		# Allow for a missing newName parameter
		if($newName -eq $null){
			$newName = $name
		}
	}
	Process{
		$roleId = ($authMgr.roleList | Where-Object {$_.Name -eq $name} | % {$_.roleId})
		$oldIds = Get-TkeRolePrivileges -name $name | % {$_.privId}
		if($privIds -eq $null){
		  $privIds = $oldIds
		}
		if($append){
			$privIds = $oldIds + $privIds
		}
		$authMgr.UpdateAuthorizationRole($roleId,$newName,$privIds)
	}
	End{
		return
	}
}

# Remove a role
# v1.0 - 30/12/08 - LucD
<#
.Synopsis
Remove a role definition
.Description
Remove a role definition from the VI environment.
Note that this does not work for the builtin roles!
.Parameter name
The name of the role that will be removed
.Parameter FailIfUsed
A switch that allows you to avoid the deletion of the role if the role
is used in any permissions.
The default is $true
.Example
Remove-TkeRole -name "MyRole" - FailIfUsed:$false
#>
function Remove-TkeRole
{
	param(
	[Parameter(Mandatory=$true, ValueFromPipeline=$true, HelpMessage="Role name")]
	[string]
	$name,
	[Parameter(Mandatory=$false, ValueFromPipeline=$false, HelpMessage="Fail remove if role is used")]
	[switch]
	$FailIfUsed = $true
	)
	Begin{
		$authMgr = Get-View AuthorizationManager
	}
	Process{
		$roleId = ($authMgr.roleList | Where-Object {$_.Name -eq $name} | % {$_.roleId})
		$authMgr.RemoveAuthorizationRole($roleId,$FailIfUsed)
	}
	End{
		return
	}
}

# Clone a role
# v1.0 - 31/12/08 - LucD
<#
.Synopsis
Clone a role definition
.Description
Clone a role.
The new role will have all the privileges the source role had.
You can also clone pre-defined roles.
.Parameter name
The name of the role that will be cloned
.Parameter cloneName
The name of the role that will be created
.Example
Clone-TkeRole -name "MyRole" -cloneName "Cloned Role"
#>
function Clone-TkeRole
{
	param(
	[Parameter(Mandatory=$true, ValueFromPipeline=$true, HelpMessage="Source role name")]
	[string]
	$name,
	[Parameter(Mandatory=$true, ValueFromPipeline=$false, HelpMessage="Clone role name")]
	[string]
	$cloneName
	)
	Begin{
		$authMgr = Get-View AuthorizationManager
	}
	Process{
		$privIds = Get-TkeRolePrivileges -name $name | % {$_.privId}
		$roleId = $authMgr.AddAuthorizationRole($cloneName,$privIds)
	}
	End{
		return $roleId
	}
}

# Get all privileges assigned to a role
# v1.0 - 30/12/08 - LucD
<#
.Synopsis
Get all privileges assigned to a role
.Description
Get all privileges assigned to a specific role.
Note that the name of a role used in the VI is not the same name that is 
displayed in the VI client.
.Parameter name
The name of the role as used in the VI environment.
Use Get-TkeRoles to get all the known roles in the VI environment.
.Example
$privs = Get-TkeRolePrivileges -name "ReadOnly" 
#>
function Get-TkeRolePrivileges
{
	param(
	[Parameter(Mandatory=$true, ValueFromPipeline=$true, HelpMessage="Role name")]
	[string]
	$name
	)

	Begin{
		$authMgr = Get-View AuthorizationManager
		$report = @()
	}
	Process{
		$privs = ($authMgr.roleList | Where-Object {$_.Name -eq $name} | % {$_.privilege})
		foreach($priv in $authMgr.privilegeList){
			if($privs -contains $priv.privId){
				$ret = New-Object PSObject
				$ret | Add-Member -Type noteproperty -Name "Name" -Value $priv.name
				$ret | Add-Member -Type noteproperty -Name "OnParent" -Value $priv.OnParent
				$ret | Add-Member -Type noteproperty -Name "privGroupName" -Value $priv.privGroupName
				$ret | Add-Member -Type noteproperty -Name "privId" -Value $priv.privId
				$report += $ret
			}
		}
	}
	End{
		return $report
	}
}

# Get a list with all available privileges
# v1.0 - 30/12/08 - LucD
<#
.Synopsis
Get a list with all available privileges in the VI system
.Description
Get a list with all available privileges in the VI system
.Example
$privs = Get-TkeAllPrivileges
#>
function Get-TkeAllPrivileges
{
	Begin{
		$authMgr = Get-View AuthorizationManager
		$report = @()
	}
	Process{
		foreach($priv in $authMgr.privilegeList){
			$ret = New-Object PSObject
			$ret | Add-Member -Type noteproperty -Name "Name" -Value $priv.name
			$ret | Add-Member -Type noteproperty -Name "OnParent" -Value $priv.OnParent
			$ret | Add-Member -Type noteproperty -Name "privGroupName" -Value $priv.privGroupName
			$ret | Add-Member -Type noteproperty -Name "privId" -Value $priv.privId
			$report += $ret
		}
	}
	End{
		return $report
	}
}
#endregion

######################################
### Half-baked stuff               ###
######################################
#region NotWorking
# Import a Virtual Appliance from the Internet.
function Import-TkeVirtualAppliance {
	param(
	[Parameter(Mandatory=$true,HelpMessage="One or more Virtual Appliance URLs or local files")]
	[string[]]
	$Url,

	[Parameter(Mandatory=$true,HelpMessage="Datastore where the appliances are placed")]
	[VMware.VimAutomation.Client20.DatastoreImpl]
	$Datastore,

	[Parameter(HelpMessage="Datastore path")]
	[string]
	$DatastorePath,

	[Parameter(Mandatory=$true,HelpMessage="VMHost where the appliance is placed")]
	[VMware.VimAutomation.Client20.VMHostImpl]
	$VMHost,

	[Parameter(HelpMessage="Resource pool where the appliance is placed")]
	[VMware.VimAutomation.Client20.ResourcePoolImpl]
	$ResourcePool,

	[Parameter(HelpMessage="Port group to attach appliance to")]
	[VMware.VimAutomation.Client20.VirtualPortGroupImpl]
	$PortGroup,

	[Parameter(HelpMessage="Target disk size")]
	[uint64]
	$diskSize
	)

	foreach ($u in $url) {
		$fileName = $url.Split('/')[-1]

		# Build our datastore path.
		if ($datastorePath -eq $null) {
			# Auto-generate a path from the URL.
			$DatastorePath = $fileName + "-" + [string](get-date).ToFileTimeUtc()
		}
		$destPath = "[" + $datastore.Name + "] /$DatastorePath"

		# Ensure the destination path exists.
		New-TkeDatastoreDirectory -path $destPath

		# Transfer the file to the datastore.
		Copy-TkeDatastoreFile -sourcePath $url -destinationPath $destPath

		# Extract the archive (via SSH).
		$command = "tar -zxf $datastoreFilePath/$fileName"
		Execute-RemoteSshCommand -credential $credential -command

		# Locate the VMX file for this appliance.
		$files = Get-TkeDatastoreFile -subpath $destPath
		$vmxFile = $files | where { $_.Name -match "\.vmx$" } | select -first 1
		if ($vmxFile -eq $null) {
			write-error "No VMX file found, cannot register this virtual appliance."
			# XXX: Delete the stuff we uploaded.
			continue
		}

		# Register the VM.
		$moRef = Register-TkeVM -vmxfile $vmxFile.Name -resourcePool $resourcePool -VMHost $vmHost -Folder $folder
		$moRef | Get-VIObjectByVIView
	}
}

function New-OpenfilerIscsi {
	param(
	[Parameter(Mandatory=$true,ValueFromPipeline=$true,HelpMessage="VMHost where the Openfiler will be located")]
	[VMware.VimAutomation.Client20.VMHostImpl[]]
	$VMHost,

	[Parameter(Mandatory=$true,HelpMessage="Datastore where the Openfiler will be located")]
	[VMware.VimAutomation.Client20.DatastoreImpl]
	$Datastore,

	[Parameter(HelpMessage="Cluster where the Openfiler will be located")]
	[VMware.VimAutomation.Client20.ClusterImpl]
	$Cluster,

	[Parameter(HelpMessage="Resource Pool where the Openfiler will be located")]
	[VMware.VimAutomation.Client20.ClusterImpl]
	$ResourcePool,

	[Parameter(HelpMessage="Folder for the new VM")]
	[VMware.VimAutomation.Client20.FolderImpl]
	$Folder,

	[Parameter(HelpMessage="The amount of disk that will be allocated to the secondary disk (used for iSCSI storage)")]
	[Long]
	$DiskSize
	)

	# The URL for the Openfiler VA. This should be dynamic.
	$url = "http://amazonsomewhere/openfiler.tar.gz";
	$fileName = $url.Split("/")[-1]

	# Build the datastore path for this VM.
	$path = "[" + $Datastore.Name + "] /" + [string][System.DateTime]::Now.ToFileTimeUtc() + "/" + $fileName

	# Install the Openfiler virtual appliance.
	Import-TkeVirtualAppliance -VMHost $VMHost

	# Configure iSCSI within the VM.
# XXXXX how do you do this?

# Configure iSCSI on the host.

# Add the VA as an iSCSI target.

# Format the datastore.
	Format-Datastore -datastore $datastoreName

	# Return the datastore.
	get-datastore $datastoreName
}
#endregion

#region Performance
# Determines paravirtualization status of VMs.
function Get-TkeParavirtualization {
	param(
	[Parameter(Mandatory=$true,ValueFromPipeline=$true,HelpMessage="The VM to clone")]
	[VMware.VimAutomation.Client20.VirtualMachineImpl]
	$vm
	)
	
	Process {
		$obj = New-Object PSObject
		$obj | Add-Member -MemberType NoteProperty -Name VM -Value $vm
		$vmView = $vm | Get-View -Property Config

		# Build up a list of types.
		$types = @()
		foreach ($device in $vmView.Config.Hardware.Device) {
			$types += $device.GetType()
		}
		
		# Look for VMI.
		$obj | Add-Member -membertype NoteProperty -Name VMI -Value ($types -contains [VMware.Vim.VirtualMachineVMIROM])

		# VMXNet 3. PowerCLI has a bug that causes it to think these are vmxnet, so we check the devices.
		$totalVmxNet = $totalEthernet = 0
		foreach ($type in $types) {
			if ($type.IsSubclassOf([VMware.Vim.VirtualEthernetCard])) {
				$totalEthernet++
				if ($type -eq [VMware.Vim.VirtualVmxnet3]) {
					$totalVmxNet++
				}
			}
		}
		$obj | Add-Member -MemberType NoteProperty -Name Vmxnet3Ratio -Value ($totalVmxNet / $totalEthernet)
		
		# PVSCSI controllers. Again we check the devices.
		$totalPvscsi = $totalScsi = 0
		foreach ($type in $types) {
			if ($type.IsSubclassOf([VMware.Vim.VirtualSCSIController])) {
				$totalScsi++
				if ($type -eq [VMware.Vim.ParaVirtualSCSIController]) {
					$totalPvscsi++
				}
			}
		}
		$obj | Add-Member -MemberType NoteProperty -Name PvscsiRatio -Value ($totalPvScsi / $totalScsi)

		Write-Output $obj
	}
}
#endregion

#region LogAnalysis
function Get-TkeLogBundleProcess {
	param(
	[Parameter(Mandatory=$true,ValueFromPipeline=$true,HelpMessage="Path to extracted log bundle")]
	[String]
	$path
	)

	$procDirs = Get-Childitem "$path/proc/[0-9]*"
	foreach ($dir in $procDirs) {
		$process = new-object psobject
		$status = Get-Content ($dir.FullName + "\status")
		foreach ($line in $status) {
			if ($line -match '([\S]+):\s+([\S]+)') {
				$lhs = $matches[1]
				$rhs = $matches[2]
				if ($rhs -match '^[0-9]+$') {
					$rhs = [int64]$rhs
				}
				$process | add-member -type noteproperty -name $lhs -value $rhs
			}
		}
		$process
	}
}

function Get-TkeConfigIssue {
    param(
        [Parameter(
            Mandatory=$true,
            ValueFromPipeline=$true,
            HelpMessage="VI Object"
        )]
        [VMware.VimAutomation.Types.VIObject]
        $VIObject
    )

	Process {
		$hView = $VIObject | Get-View -Property configIssue
		if ($hView.ConfigIssue) {
			foreach ($issue in $hView.ConfigIssue) {
				$obj = New-Object PSObject
				$obj | Add-Member -MemberType NoteProperty -Name Object      -Value $VIObject
				$obj | Add-Member -MemberType NoteProperty -Name CreatedTime -Value $issue.CreatedTime
				$obj | Add-Member -MemberType NoteProperty -Name Message     -Value $issue.FullFormattedMessage
				$obj | Add-Member -MemberType NoteProperty -Name EventType   -Value $issue.EventTypeId
				$obj | Add-Member -MemberType NoteProperty -Name Severity    -Value $issue.Severity
				Write-Output $obj
			}
		}
	}
}

function Get-TkeAlarm {
    param(
        [Parameter(
            Mandatory=$true,
            ValueFromPipeline=$true,
            HelpMessage="VI Object"
        )]
        [VMware.VimAutomation.Types.VIObject]
        $VIObject
    )
	
	Process {
		$oView = $VIObject | Get-View -Property triggeredAlarmState
		if ($oView.triggeredAlarmState) {
			foreach ($trigger in $oView.triggeredAlarmState) {
				$alarm = Get-View $trigger.Alarm

				$obj = New-Object PSObject
				$obj | Add-Member -MemberType NoteProperty -Name Object             -Value $VIObject
				$obj | Add-Member -MemberType NoteProperty -Name OverallStatus      -Value $trigger.OverallStatus
				$obj | Add-Member -MemberType NoteProperty -Name Acknowledged       -Value $trigger.Acknowledged
				$obj | Add-Member -MemberType NoteProperty -Name AcknowledgedByUser -Value $trigger.AcknowledgedByUser
				$obj | Add-Member -MemberType NoteProperty -Name AcknowledgedTime   -Value $trigger.AcknowledgedTime
				$obj | Add-Member -MemberType NoteProperty -Name Name               -Value $alarm.Info.Name
				Write-Output $obj
			}
		}
	}
}

# Internal function, don't use.
Function Export-TkeLogSingleVM {
	param($vm, $path)

	$vmView = $vm | Get-View -Property Config
	$logDirectory = $vmView.Config.Files.LogDirectory
	$elements = Extract-TkeDatastorePathElements $logDirectory
	$dc = $vm | Get-Datacenter

	$files = Get-TkeDatastoreFile -datastore (Get-Datastore $elements.Datastore) -subpath $elements.Path -noSize -noType -noModification
	foreach ($file in ($files | Where { $_.Path -like "*.log" } )) {
		$elements = Extract-TkeDatastorePathElements ($file.Path)
		Copy-TkedatastoreFile -sourceDatacenter $dc -source $file.Path -destination ($path + "\" + $elements.Datastore + "\" + $elements.Path)
	}
}

Function Export-TkeLog {
    <#
    .SYNOPSIS
        Export Server or VM log files to the local computer.
    .EXAMPLE
        Export-TkeLogFile -AllServerLogs -AllVMLogs c:\temp\mylogs
    .LINK
        Get-Log
    #>
	[CmdletBinding(
        SupportsShouldProcess=$true,
        ConfirmImpact="None",
        DefaultParameterSetName='Default'
    )]
    param(
		[Parameter(Mandatory=$true,Position=0,HelpMessage="The local path where log files are saved.")]
		[string]
		$DestinationPath,

		[Parameter(ParameterSetName="Default",HelpMessage="Export all server logs?")]
		[switch]
		$AllServerLogs,

		[Parameter(ParameterSetName="Default",HelpMessage="Export all VM logs?")]
		[switch]
		$AllVMLogs,

		[Parameter(ParameterSetName="SingleVM",ValueFromPipeline=$true,HelpMessage="The VM whose log files we save.")]
		[VMware.VimAutomation.Client20.VirtualMachineImpl]
		$VM
	)

	Process {
		$ci = Get-ChildItem $DestinationPath -ErrorAction SilentlyContinue -ErrorVariable ev
		if ($ev -ne $null) {
			throw "DestinationPath does not exist."
		}

		if ($PSCmdlet.ParameterSetName -eq "Default") {
			if ($AllVMLogs) {
				Get-VM | Foreach { Export-TkeSingleVM $_ $DestinationPath }
			}
			if ($AllServerLogs) {
				$types = Get-LogType
				foreach ($type in $types) {
					Get-Log $type | select -ExpandProperty Entries | Set-Content $DestinationPath\$type
				}
			}
		} else {
			Export-TkeLogSingleVM $vm $DestinationPath
		}
	}
}

# Turns log messages into log objects.
function Get-TkeLogObject {
	# Date formats:
	# vmksummary style: Fri May 29 04:02:06 PDT 2009 Format: ddd MMM dd HH:mm:ss 'PDT' yyyy
	# messages   style: May 27 01:01:02              Format: MMM dd HH:mm:ss
	# hostd      style: 2009-05-29 21:04:26.540      Format: yyyy-MM-dd HH:mm:ss.fff

	# The various log formats.
	$dateRegex       = ""
	$hostdRegex      = "\[(?<Date>[^ ]+) (?<Time>[^ ]+) (?<Object>'[^']+') (?<ID>[^ ]+) (?<Level>[^ ]+)\] (?<Message>.+)"
	$messagesRegex   = ""
	$vpxa3Regex      = ""
	$vpxa4Regex      = ""
	$vpxdRegex       = ""
	$vpxdProfilerRegex = ""
	$vmkernelRegex   = ""
	$vmksummaryRegex = "Need a special parser for this to get the availability report"
	$vmkwarningRegex = ""

	# Try it against hostd.
	if ($logLine -match $hostdRegex) {
		$logObj = New-Object System.Management.Automation.PsObject
		foreach ($property in "Date", "Time", "Object", "ID", "Level", "Message") {
			$logObj | Add-Member NoteProperty $property $matches.$property
			Write-Output $logObj
		}
	}
}
#endregion

#region Debugging
# Test cmdlets against the usability standards.
function Get-TkeUsabilityProblems {
	$commands = Get-Command -Module VMware.VimAutomation.Core
	$groups = $commands | Group Noun

	foreach ($group in $groups) {
		$verbs = ($group.group | Foreach { $_.Verb })

		# Find cmdlets with Set-* but no Get-*
		if ($verbs -contains "Set" -and $verbs -notcontains "Get") {
			Write-Host $group.Name has a Set but no Get
		}

		# Return type not documented.

		# Getters that don't have Name as first positional parameter.
	
		# Getters that have mandatory parameters.
	
		# Get-* cmdlets that don't pipe into Set-* cmdlets.
	}
}

# Create an error report based on a script block containing code that fails.
function New-TkeErrorReport {
	param($scriptblock)

	# To be implemented.
}

# Measures the amount of data transferred for a command.
function Measure-TkeRequestSize {
	param($scriptblock)
	
	$file = $env:APPDATA + "\soapmeasure.txt"

	$oldPreference = $global:DebugPreference
	$global:DebugPreference = "Continue"
	Start-Transcript -Path $file >$null
	$output = . $scriptblock
	Stop-Transcript >$null
	$global:DebugPreference = $oldPreference
	
	Write-Output (Get-ChildItem $file).Length
}

# This is not working properly now.
# Copy and paste the function into your session, then run it.
function Get-TkeDocumentationProblems {
	$modules = @("VMware.VimAutomation.Core")
	$cmdlets = Get-Command -Module $modules

	$global:ErrorActionPreference = $ErrorActionPreference = "silentlycontinue"
	Disconnect-VIServer -Confirm:$false

	foreach ($c in $cmdlets) {
		$help = Get-Help $c

		# Find cmdlets with no examples.
		if ($help.examples -eq $null) {
			$obj = New-Object psobject
			$obj | Add-Member -MemberType NoteProperty -Name Name -Value $c.Name
			$obj | Add-Member -MemberType NoteProperty -Name Reason -Value "No Examples"
			Write-Output $obj
		}
	
		# Find syntax problems in cmdlet examples. Don't do Connect-VIServer
		$exampleNumber = 1
		foreach ($example in $help.examples.example) {
			# Skip examples that try to connect.
			if ($example.code -like "*Connect-VIServer*") {
				continue
			}

			foreach ($i in 0..20) {
				$global:Error[$i] = $null
			}
			
			Invoke-Expression $example.code
			$errorFound = $false
			foreach ($i in 0..20) {
				if ($global:Error[$i].CategoryInfo.Reason -eq "ParameterBindingException" -and $global:error[$i].CategoryInfo.Category -eq "InvalidArgument") {
					$errorFound = $true
				}
			}
			if ($errorFound) {
				$obj = New-Object psobject
				$obj | Add-Member -MemberType NoteProperty -Name Name -Value $c.Name
				$obj | Add-Member -MemberType NoteProperty -Name Reason -Value "Compile failure in example $exampleNumber"
				Write-Output $obj
			}
			$exampleNumber++
		}
	}
}

#endregion

#region ScheduledTasks
function Get-TkeScheduledTask {
	$tempDir = $env:appdata + "\vitoolkitextensions"
	$tempCsv = $tempDir + "\schtasks.csv"
	mkdir -force $tempDir > $null
	. schtasks /query /fo csv /v | Set-Variable schTaskText

	# Delete any leading whitespace.
	$schTaskText = $schTaskText | Where { $_ -ne "" }
	$schTaskText | Set-Content $tempCsv
	Import-Csv $tempCsv
}

# Schedule a new task on the system.
# TODO: Times and dates should be DateTimes, not strings.
# TODO: need a better way to handle modifier.
# Example: Schedule a script for 1:00 A.M. every day:
#      New-TkeScheduledTask -Schedule Daily -StartTime 01:00:00 -Taskname MyReport1 -command "powershell -WindowStyle Hidden -Command c:\scripts\nightly.ps1"
function New-TkeScheduledTask {
	param(
		[Parameter()]
		[string]
		$system,

		[Parameter()]
		[string]
		$userContextName,

		[Parameter()]
		[string]
		$userContextPassword,

		[Parameter()]
		[string]
		$userAccountName,

		[Parameter()]
		[string]
		$userAccountPassword,

		[Parameter(Mandatory=$true)]
		[string]
		$schedule,

		[Parameter()]
		[string]
		$modifier,

		[Parameter()]
		[string]
		$idletime,

		[Parameter(Mandatory=$true)]
		[string]
		$taskname,

		[Parameter(Mandatory=$true)]
		[string]
		$command,

		[Parameter()]
		[string]
		$startTime,

		[Parameter()]
		[string]
		$startDate,

		[Parameter()]
		[string]
		$endDate
	)

	$map = @{"system" = "S"; "userContextName" = "U"; "userContextPassword" = "P"; "userAccountName" = "RU";
	         "userAccountPassword" = "RP"; "schedule" = "SC"; "modifier" = "MO"; "idletime" = "I";
			 "taskname" = "TN"; "command" = "TR"; "startTime" = "ST"; "startDate" = "SD"; "endDate" = "ED" }
	
	$argString = "schtasks /create"
	foreach ($kname in $map.Keys) {
		$kvalue = $map.$kname
		Invoke-Expression "if (`$$kname) { `$argString += (' /' + '$kvalue ' + '`"' + `$$kname + '`"') }"
	}

	Invoke-Expression $argstring
}

# Remove an existing scheduled task.
function Remove-TkeScheduledTask {
	param(
		[Parameter(Mandatory=$true)]
		[string]
		$taskname
	)

	. schtasks /delete /f /tn "$taskname"
}
#endregion

#region Other
Function Get-TkeVMHostLicenseUsage {
    param(
        [Parameter(
            Mandatory=$true,
            ValueFromPipeline=$true,
            HelpMessage="VMHost"
        )]
        [VMware.VimAutomation.Client20.VMHostImpl]
        $VMHost
    )

	Process {
		$si = Get-View ServiceInstance
		$lm = Get-View $si.Content.LicenseManager

		# First, query license usage to determine the source.
		$hView = $VMHost | Get-View -Property Name
		$usage = $lm.QueryLicenseUsage($hView.MoRef)

		foreach ($feature in $usage.FeatureInfo) {
			$usageInfo = New-Object psobject
			$usageInfo | Add-Member -MemberType NoteProperty -Name FeatureShortName -Value $feature.Key
			$usageInfo | Add-Member -MemberType NoteProperty -Name FeatureLongName  -Value $feature.FeatureName
			$usageInfo | Add-Member -MemberType NoteProperty -Name Status           -Value $feature.State
			$usageInfo | Add-Member -MemberType NoteProperty -Name Host             -Value $VMHost

			# Get the usage amount as well.
			$reservation = $usage.ReservationInfo | Where { $_.Key -eq $feature.Key }
			if ($reservation -eq $null) {
				$usageInfo | Add-Member -MemberType NoteProperty -Name State    -Value "notUsed"
				$usageInfo | Add-Member -MemberType NoteProperty -Name Required -Value 0
			} else {
				$usageInfo | Add-Member -MemberType NoteProperty -Name State    -Value $reservation.State
				$usageInfo | Add-Member -MemberType NoteProperty -Name Required -Value $reservation.Required
			}
			Write-Output $usageInfo
		}
	}
}

Function Get-TkeVMHostLicenseServerUsage {
    param(
        [Parameter(
            Mandatory=$true,
            ValueFromPipeline=$true,
            HelpMessage="VMHost"
        )]
        [VMware.VimAutomation.Client20.VMHostImpl]
        $VMHost
    )
	
	Begin {
		$ret = @()
	}
	Process {
		$si = Get-View ServiceInstance
		$lm = Get-View $si.Content.LicenseManager

		# First, query license usage to determine the source.
		$hView = $VMHost | Get-View -Property Name
		$usage = $lm.QueryLicenseUsage($hView.MoRef)
		$sourceInfo = $ret | Where { $_.LicenseSourceType -eq "LicenseServerSource" -and $_.LicenseSourceDetails -eq $usage.Source.LicenseServer }
		if ($sourceInfo -eq $null) {
			# New license source.
			$avail = $lm.QueryLicenseSourceAvailability($hView.MoRef)
			foreach ($a in $avail) {
				$sourceInfo = New-Object PSObject
				$sourceType = $usage.Source.GetType().Name
				$sourceInfo | Add-Member -MemberType NoteProperty -Name LicenseSourceType -Value $sourceType
				if ($sourceType -eq "LicenseServerSource") {
					$sourceInfo | Add-Member -MemberType NoteProperty -Name LicenseSourceDetails -Value $usage.Source.LicenseServer
				} elseif ($sourceType -eq "LocalLicenseSource") {
					$sourceInfo | Add-Member -MemberType NoteProperty -Name LicenseSourceDetails -Value $usage.Source.licenseKeys
				} elseif ($sourceType -eq "EvaluationLicenseSource") {
					$sourceInfo | Add-Member -MemberType NoteProperty -Name LicenseSourceDetails -Value $usage.Source.remainingHours
				}
				$sourceInfo | Add-Member -MemberType NoteProperty -Name FeatureShortName -Value $a.Feature.Key
				$sourceInfo | Add-Member -MemberType NoteProperty -Name FeatureLongName  -Value $a.Feature.FeatureName
				$sourceInfo | Add-Member -MemberType NoteProperty -Name Total            -Value $a.Total
				$sourceInfo | Add-Member -MemberType NoteProperty -Name Available        -Value $a.Available
				$sourceInfo | Add-Member -MemberType NoteProperty -Name Hosts            -Value @($VMHost)
				$ret += $sourceInfo
			}
		} else {
			# Add this host to the list of hosts using this license source.
			foreach ($s in $sourceInfo) {
				$s.Hosts += $VMHost
			}
		}
	} End {
		Write-Output $ret
	}
}
#endregion

function Get-TkeAlarm {
    param(
        [Parameter(
            HelpMessage="Name",
			Position=1
        )]
        [String]
        $Name
    )

	Process {
		$si = Get-View ServiceInstance
		$alarmManager = Get-View $si.Content.AlarmManager
		$alarms = $alarmManager.GetAlarm($null)
		foreach ($alarmId in $alarms) {
			$alarm = Get-View $alarmId

			if ($name -and -not ($alarm.Info.Name -like $Name)) {
				continue
			}
			$obj = New-Object PSObject
			$obj | Add-Member -MemberType NoteProperty -Name Id -Value ([String]$alarm.MoRef)
			$obj | Add-Member -MemberType NoteProperty -Name Entity -Value $alarm.Info.Entity
			$obj | Add-Member -MemberType NoteProperty -Name Name -Value $alarm.Info.Name
			$obj | Add-Member -MemberType NoteProperty -Name Description -Value $alarm.Info.Description
			$obj | Add-Member -MemberType NoteProperty -Name Enabled -Value $alarm.Info.Enabled
			$obj | Add-Member -MemberType NoteProperty -Name ToleranceRange -Value $alarm.Info.Setting.ToleranceRange
			$obj | Add-Member -MemberType NoteProperty -Name ReportingFrequency -Value $alarm.Info.Setting.ReportingFrequency
			$obj | Add-Member -MemberType NoteProperty -Name ActionFrequency -Value $alarm.Info.ActionFrequency
			$obj | Add-Member -MemberType NoteProperty -Name Action -Value "Nothing"
			$obj | Add-Member -MemberType NoteProperty -Name ActionTarget -Value $null
			if ($alarm.Info.Action -ne $null) {
				if ($alarm.Info.Action -is [VMware.Vim.GroupAlarmAction]) {
					$action = $alarm.Info.Action.Action[0].Action
				} else {
					$action = $alarm.Info.Action.Action
				}

				if ($action -is [VMware.Vim.CreateTaskAction]) {
					$obj.Action = "CreateTask"
				} elseif ($action -is [VMware.Vim.MethodAction]) {
					$obj.Action = "InvokeMethod"
				} elseif ($action -is [VMware.Vim.RunScriptAction]) {
					$obj.Action = "RunScript"
					$obj.ActionTarget = $action.script
				} elseif ($action -is [VMware.Vim.SendEmailAction]) {
					$obj.Action = "SendEmail"
					$obj.ActionTarget = $action.toList
				} elseif ($action -is [VMware.Vim.SendSNMPAction]) {
					$obj.Action = "SendSnmp"
				} else {
					$obj.Action = "Unknown"
				}
			}
			Write-Output $obj
		}
	}
}

function Get-TkePerformanceCounter {
	Process {
		$si = Get-View ServiceInstance
		$pm = Get-View $si.Content.PerfManager

		foreach ($counter in $pm.PerfCounter) {
			$obj = New-Object PSObject
			$obj | Add-Member -MemberType NoteProperty -Name Key -Value $counter.Key
			$obj | Add-Member -MemberType NoteProperty -Name Summary -Value $counter.NameInfo.Summary
			$obj | Add-Member -MemberType NoteProperty -Name Name -Value $counter.NameInfo.key
			$obj | Add-Member -MemberType NoteProperty -Name Group -Value $counter.GroupInfo.key
			$obj | Add-Member -MemberType NoteProperty -Name Unit -Value $counter.UnitInfo.Key
			$obj | Add-Member -MemberType NoteProperty -Name RollupType -Value $counter.RollupType
			$obj | Add-Member -MemberType NoteProperty -Name StatType -Value $counter.StatsType
			$obj | Add-Member -MemberType NoteProperty -Name Level -Value $counter.Level
			Write-Output $obj
		}
	}
}

function New-TkeAlarm {
    [CmdletBinding(
        SupportsShouldProcess=$false,
        ConfirmImpact="none",
        DefaultParameterSetName=''
    )]
	param(
        [Parameter(
            Mandatory=$true,
            ValueFromPipeline=$true,
            HelpMessage="Entity associated with the alarm (usually the root folder)"
        )]
        [VMware.VimAutomation.Types.VIObject]
		$Entity,

        [Parameter(Mandatory=$true)]
        [String]
		$Name,

        [Parameter(Mandatory=$true)]
        [String]
		$Description,

        [Int]
		$ToleranceRange=0,

        [Int]
		$ReportingFrequency=300,

        [Int]
		$AlarmInterval=300,

		[Int]
		$ActionFrequency=0,

        [String]
		$Action,
		
        [String]
		$ActionTarget,
		
		[switch]
		$LegacyAction,
		
		[Parameter(parameterSetName="StatBased")]
		[switch]
		$StatBased,

		[Parameter(parameterSetName="StatBased")]
		[String]
		$StatType,

		[Parameter(parameterSetName="StatBased")]
		[String]
		$Operator,

		[Parameter(parameterSetName="StatBased")]
		[Int]
		$AlarmValue=$null,

		[Parameter(parameterSetName="StatBased")]
		[Int]
		$StatTypeInstance=$null,

		[Parameter(parameterSetName="StatBased")]
		[String]
		$TypeForThisStatType,

		[Parameter(parameterSetName="EventBased")]
		[switch]
		$EventBased,

		[Parameter(parameterSetName="EventBased")]
		[String]
		$EventTypeId
	)

	Process {
		if (!$StatBased -and !$EventBased) {
			throw "One of -StatBased or -EventBased must be specified"
		}
		
		$si = Get-View ServiceInstance
		$alarmManager = Get-View $si.Content.AlarmManager

		$entityView = Get-View $Entity.Id -Property Name
		$spec = New-Object VMware.Vim.AlarmSpec
		$spec.description = $description
		$spec.enabled = $true
		$spec.name = $Name
		$spec.setting = New-Object VMware.Vim.AlarmSetting
		$spec.setting.reportingFrequency = $ReportingFrequency
		$spec.setting.toleranceRange = $ToleranceRange

		# The expression defines when the alarm is triggered.
		if ($StatBased) {
			$spec.expression = New-Object VMware.Vim.MetricAlarmExpression
			
			# Look up the counter ID.
			if ($StatType -match "(\S+)\.(\S+)\.(\S+)") {
				$counterGroup = $matches[1]
				$counterName  = $matches[2]
				$rollupType   = $matches[3]
				$targetCounter = Get-TkePerformanceCounter |
					Where { $_.Group -eq $counterGroup -and $_.Name -eq $counterName -and $_.RollupType -eq $rollupType }
			}
			if (!$targetCounter) {
				throw "Unrecognized stat type $StatType"
			}
			$metricSpec = New-Object VMware.Vim.PerfMetricId
			$metricSpec.counterId = $targetCounter.Key
			$metricSpec.instance = $StatTypeInstance
			$spec.expression.metric = $metricSpec

			if ($Operator -ne "isAbove" -and $Operator -ne "isBelow") {
				throw "-Operator must be one of isAbove or isBelow"
			}
			$spec.expression.operator = $Operator
			if ($TypeForThisStatType -eq $null) {
				throw "-TypeForThisStatType must be set when using -StatBased. Example value: HostSystem"
			}
			$spec.expression.type = $TypeForThisStatType
			if ($AlarmValue -eq $null) {
				throw "-AlarmValue must be set."
			}
			if ($LegacyAction -and $action) {
				# VC 2.5 didn't support actions on transitions from green to red.
				# Instead we will transition to yellow and the alarm will never go red.
				$spec.expression.yellow = $AlarmValue
				$spec.expression.yellowInterval = $AlarmInterval
			} else {
				# Make the alarm a nice angry red.
				$spec.expression.red = $AlarmValue
				$spec.expression.redInterval = $AlarmInterval
			}
		} else {
			$spec.expression = New-Object VMware.Vim.EventAlarmExpression
		}

		# The action, if given.
		if ($action) {
			$spec.actionFrequency = $ActionFrequency
			if ($Action -ne "ScriptAction") {
				throw "-Action must be ScriptAction"
			}
			$spec.action = New-Object VMware.Vim.AlarmTriggeringAction

			if ($LegacyAction) {
				# Create an action that will work on either VC 2.5 or vSphere.
				# This does not handle transitions from gray to yellow.
			} else {
				# Take the action any time we transition into red. This is vSphere+.
				$transitionSpecs = @()
				foreach ($color in ("gray", "green", "yellow")) {
					$tspec = New-Object VMware.Vim.AlarmTriggeringActionTransitionSpec
					$tspec.startState = $color
					$tspec.finalState = "red"
					$tspec.repeats    = $false
					$transitionSpecs += $tspec
				}
				$spec.action.transitionSpecs = $transitionSpecs
	
				if ($Action -eq "ScriptAction") {
					$spec.action.action = New-Object VMware.Vim.RunScriptAction
					# Environment variables don't work at all.
					#$scriptLocation = "%ALLUSERSPROFILE%\Application Data\VMware\VMware VirtualCenter\Scripts\$ActionTarget"
					$scriptLocation = "$ActionTarget"
					$spec.action.action.script = $scriptLocation
				}
			}
		}

		#Write-Output $spec
		$alarmManager.CreateAlarm($entityView.MoRef, $spec)
	}
}

#$f = get-folder -norecursion
## Alarm triggered whenever CPU usage is less than 50%.
#new-tkealarm -Entity $f -Name "My CPU Alarm" -Description "My CPU Alarm" `
#    -StatBased -StatType cpu.usage.average -Operator "isBelow" -AlarmValue 5000 `
#    -TypeForThisStatType "HostSystem" -Action "ScriptAction" -ActionTarget "temp.bat"
#
## Alarm triggered whenever a host reboots.
#new-tkealarm -Entity $f -Name "Host recently rebooted" -Description "Host recently rebooted" `
#    -StatBased -StatType sys.uptime.latest -Operator "isBelow" -AlarmValue 600 `
#    -AlarmInterval 120 -TypeForThisStatType "HostSystem" # -Action "ScriptAction" `
#    -ActionTarget "HostReconfigure.ps1"
#
## Alarm triggered whenever a VM reboots.
#new-tkealarm -Entity $f -Name "VM guest recently rebooted" -Description "VM guest recently rebooted" -StatBased -StatType sys.heartbeat.summation `
#	-Operator "isBelow" -AlarmValue 600 -TypeForThisStatType "VirtualMachine" # -Action "ScriptAction" -ActionTarget "VMReconfigure.ps1"

function Set-TkeAlarm {
	# Allow change: Enabled, ToleranceRange, ReportingFrequency, Name, Description, Entity, Change Action
}

function Remove-TkeAlarm {
	[CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact="high")]
	param(
		[Parameter(
            Mandatory=$true,
            ValueFromPipeline=$true,
            HelpMessage="The alarm to remove"
        )]
		[PSObject]
		$Alarm
	)

	process {
		if ($PScmdlet.ShouldProcess($Alarm.Name, "Remove this alarm.")) {
			$alarmView = Get-View $Alarm.Id
			$alarmView.RemoveAlarm()
		}
	}
}

function Get-TkeAlarmState {
}

function Set-TkeAlarmState {
}