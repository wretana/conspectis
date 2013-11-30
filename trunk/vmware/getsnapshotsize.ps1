param($vm)

###############################################################################
#
# GetDeltaFileList  - walks through list of files and for each .vmdk returns
# relative -delta.vmdk item.
#
# params:
#    [string[]] $fileList - array of file names
#    
# returns:
#    [string[]] array of file names
###############################################################################
function GetDeltaFileList($fileList) {
   $deltaFileList = @()
   foreach($file in $fileList) {
      if ($file -match ".vmdk") {
         $deltaFile = $file.Replace(".vmdk", "-delta.vmdk")
         $deltaFileList += $deltaFile
      }
   }
   return $deltaFileList
}

###############################################################################
#
# GetVirtualMachineFilesSizeHash - returns a hashtable
# in which keys are file names that are part of the VM and 
# the values are their sizes
#
# params:
#    [VMware.Vim.VirtualMachine] $vmView - the vm view for which to get file 
#    size information
#    
# returns:
#    [Hashtable] Hashtable in which keys are filenames, values are their sizes
###############################################################################
function GetVirtualMachineFilesSizeHash($vmView) {
   # first collect all files that are part of VM snapshots
   $allFileList = $vmView.Layout.Snapshot | `
      foreach { $_.SnapshotFile } | `
      select -Unique

   # add to the list current delta disk files
   # getting them from harddisks
   $vmView.Config.Hardware.Device  | `
      where { $_ -is [VMware.Vim.VirtualDisk]} | `
      foreach { $_.Backing } | `
      foreach { $allFileList += $_.FileName }
      
   # adding -delta.vmdk files to the list 
   # because each snapshot .vmdk file has a pair named -delta.vmdk
   # we should add them into calculation
   GetDeltaFileList $allFileList | `
      foreach { $allFileList +=  $_ }
      
   # extract unique folder list, we will make a query for each folder
   $folderList = @()
   foreach($file in $allFileList) {
      $lastSlashPosition = $file.LastIndexOf('/')
      $folder = $file.Substring(0, $lastSlashPosition+1)
      if ($folderList -notcontains $folder) {
         $folderList += $folder
      }
   }

   # prepare file query flag struct
   $fileQueryFlags = New-Object VMware.Vim.FileQueryFlags
   $fileQueryFlags.FileSize = $true
   $fileQueryFlags.FileType = $false
   $fileQueryFlags.Modification = $true
   
   # prepare search specification
   $searchSpec = New-Object VMware.Vim.HostDatastoreBrowserSearchSpec
   $searchSpec.details = $fileQueryFlags

   $filesizeHash = @{}
   # iterate through all folders and query each of them
   # fill up $filesizeHash
   foreach($folder in $folderList) {
      if ($folder -match "\[(.+)\] (.+)") {
         $datastoreName = $matches[1]
         $folderName = $matches[2].Replace('/', '\')
      
         $dsView = Get-Datastore $datastoreName | Get-View
            
         $dsBrowserView = Get-View $dsView.browser
         $searchResult = $dsBrowserView.SearchDatastoreSubFolders($folder, $searchSpec)
         foreach($searchResultItem in $searchResult) {
            foreach($searchResultFileItem in $searchResultItem.File) {
               $fileName = ($folder + $searchResultFileItem.Path)
               $filesizeHash[$fileName] = $searchResultFileItem.FileSize
            }
         }
      }
   }
   return $filesizeHash
}

###############################################################################
#
# CalculateSnapshotTreeSize - calculates the size of each snapshot in given
# snapshot tree.
#
# params:
#    [VMware.Vim.VirtualMachine] $vmView - Virtual machine view object of the 
#    machine from which is the snapshot tree object
#
#    [VMware.Vim.VirtualMachineSnapshotTree] $snapshotTreeView - a snapshot tree 
#    view object for which will be calculated the size of each snapshot
#
#    [String[]] $alreadyCalculatedFileList - list of file names that are
#    already calculated in previous levels of the snapshot tree
#
#    [ArrayList] $resultObjectList - list in which are collected result objects
#    Structure of the objects are described below in CalculateVMSnapshotsSizeMB 
#    function comments
#
# returns: no output
#    
#
###############################################################################
function CalculateSnapshotTreeSize(
   $vmView, 
   $snapshotTreeView, 
   [array]$alreadyCalculatedFileList, 
   $resultObjectList,
   $filesizeHash) {

   $snapshotId = $snapshotTreeView.Snapshot.ToString()
   
   # Obtaining the list of all files that are part of current snapshot
   [array]$snapshotFileList = $vmView.Layout.Snapshot | `
      where { $_.Key.ToString() -eq $snapshotId } | `
      foreach { $_.SnapshotFile }
      
   # filter already calculated files
   [array]$snapshotFileList = $snapshotFileList | `
      where { $alreadyCalculatedFileList -notcontains $_ }
      
   # Into the size of the active (current) snapshot should be added
   # the size of delta files which maintain changes made after creating/reverting
   # to that snapshot.
   # These files are not pointed in the layout property. They are related
   # to the HardDisk objects, so we are getting them from Hardware property
   if ($snapshotId -eq $vmView.Snapshot.CurrentSnapshot.ToString()) {
      # working on current snapshot
      [array]$currentVMDKFilenameList = $vmView.Config.Hardware.Device  | `
         where { $_ -is [VMware.Vim.VirtualDisk]} | `
         foreach { $_.Backing } | `
         foreach { $_.FileName }
         
      if ($currentVMDKFilenameList) {
         $snapshotFileList += $currentVMDKFilenameList
      }
   }
   
   $deltaFileList = GetDeltaFileList $snapshotFileList
   if ($deltaFileList) {
      $snapshotFileList += $deltaFileList
   }

   $sizeBytes = 0
   foreach($file in $snapshotFileList) {
      $sizeBytes += $filesizeHash[$file]
   }

   # creating result object
   $resultObject = "" | Select ID,Name,SizeMB,FileList,PowerState,`
      CreateTime,Description,IsCurrent,VMName,VirtualMachineID
   $resultObject.ID = $snapshotId
   $resultObject.Name = $snapshotTreeView.Name
   $resultObject.SizeMB = ($sizeBytes / 1024 / 1024)
   $resultObject.FileList = $snapshotFileList
   $resultObject.PowerState = $snapshotTreeView.State
   $resultObject.Description = $snapshotTreeView.Description
   $resultObject.CreateTime = $snapshotTreeView.CreateTime
   $resultObject.IsCurrent = ($snapshotId -eq $vmView.Snapshot.CurrentSnapshot.ToString())
   $resultObject.VMName = $vmView.Name
   $resultObject.VirtualMachineID = $vmView.MoRef.ToString()
   
   # adding the object to result list
   [void]($resultObjectList.Add($resultObject))
   
   # Calculating size of all child snapshots in the tree
   if ($snapshotTreeView.ChildSnapshotList.Count -gt 0) {
      # adding this snapshot files to already calculated file list
      $alreadyCalculatedFileList += $snapshotFileList
      
      # calling the function for each child
      foreach($snapshotTree in $snapshotTreeView.ChildSnapshotList) {
         CalculateSnapshotTreeSize $vmView $snapshotTree $alreadyCalculatedFileList $resultObjectList $filesizeHash
      }
   }
}

###############################################################################
#
# CalculateVMSnapshotsSizeMB - calculates size of all snapshots of given VM
# Returns list of objects , each of them describes a snapshot and its size in MB.
#
# parasm:
#    [VirtualMachine] $vm  - virtual machine for which snapshot size will be calculated
#
# return:
#    [PSCustomObject[]] array of objects with following structure:
#        ID - Snapshot ID
#        Name - snapshot Name   
#        SizeMB - size of the snapshot in MB
#        FileList - files that are part of the snapshot
#        PowerState - powere state of the snapshot
#        CreateTime - creation time of the snapshot
#        Description - snapshot description
#        IsCurrent - flag that shows is this snapshot currunt or not
#        VirtualMachineID - ID of the snapshot's virtual machine
###############################################################################
function CalculateVMSnapshotsSizeMB($vm) {
   $vmView = Get-View -VIObject $vm
   
   if (-not $vmView.Snapshot) {
      # no snapshots, nothing to do
      return
   }
   
   # To optimize the process file size retrieving we use GetVirtualMachineFilesSizeHash
   # It returns a hashtable in which keys are file names and values are sizes
   # This hashtable is passed to CalculateSnapshotTreeSize function
   $filesizeHash = GetVirtualMachineFilesSizeHash $vmView

   # initialize ArrayList in which all size of all snapshots will be collected
   $resultObjectList = New-Object System.Collections.ArrayList
   
   # iterate through all items in RootSnapshotList and calculate the size
   # for each tree 
   foreach($snapshotTree in $vmView.Snapshot.RootSnapshotList) {
      # For each root snapshot all VMDK files should be excluded from calculations
      $snapshotId = $snapshotTree.Snapshot.ToString()
      $vmdkFiles = $vmView.Layout.Snapshot | `
         where { $_.Key.ToString() -eq $snapshotId } | `
         foreach { $_.SnapshotFile } | `
         where { $_ -like '*.vmdk' }
      CalculateSnapshotTreeSize $vmView $snapshotTree $vmdkFiles $resultObjectList $filesizeHash
   }
   
   return $resultObjectList
}

if (-not $vm) {
   $vm = @()
}

foreach($item in $input) {
   $vm += $item
}

if (-not $vm)  {
   $usageText = @"
Usage: SnapshotSize.ps1 <virtual machine object>
Return list of PSCustomObjects with similar structure of the Snapshot 
type with correctly calculated SizeMB property.

Examples: 
.\SnapshotSize.ps1 (Get-VM MyVM)
Get-VM | .\SnapshotSize.ps1
"@
   Write-Host $usageText
   return
}

foreach($item in $vm) {
   CalculateVMSnapshotsSizeMB $item
}
