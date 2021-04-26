#requires -Version 5.0

using namespace KeeperSecurity.Sdk

function Get-KeeperSharedFolders {
<#
	.Synopsis
	Get Keeper Shared Folders

	.Parameter Uid
	Shared Folder UID

	.Parameter Filter
	Return matching shared folders only
#>
	[CmdletBinding()]
	[OutputType([Vault.SharedFolder[]])] 
	Param (
		[string] $Uid,
		[string] $Filter
	)
	Begin {
	}

	Process {
		[Vault.VaultOnline]$vault = $Script:Vault
		if ($vault) {
			[Vault.SharedFolder] $sharedFolder = $null
			if ($Uid) {
				if ($vault.TryGetSharedFolder($uid, [ref]$sharedFolder)) {
					$sharedFolder
				}
			} else {
				foreach ($sharedFolder in $vault.SharedFolders) {
					if ($Filter) {
						$match = $($record.Uid, $sharedFolder.Name) | Select-String $Filter | Select-Object -First 1
						if (-not $match) {
							continue
						}
					}
					$sharedFolder
				}
			}
		} else {
			Write-Error -Message "Not connected"
		}
	}

	End {
	}
}
New-Alias -Name ksf -Value Get-KeeperSharedFolders

function Add-KeeperFolderMember {
	<#
		.Synopsis
		Adds member to Keeper Shared folder
	
		.Parameter SharedFolderID
		ID for shared folder
	
		.Parameter TeamId
		ID of team

		.Parameter UserId
		ID or email of user 
	#>
	[CmdletBinding()]
	Param(
		[Parameter()][string] $SharedFolderID,
		[Parameter()][string] $TeamId,
		[Parameter()][string] $UserId,
		[Parameter()][switch] $ManageUsers,
		[Parameter()][switch] $ManageRecords
	)

	if ($TeamId -and $UserId) {
		Write-Error "TeamId and UserId params cannot be used together."
		break
	}

	$options = $null
	$options = New-Object KeeperSecurity.Vault.SharedFolderOptions
	if ($ManageUsers) {
		$options.ManageRecords = $true
	}
	if ($ManageRecords) {
		$options.ManageUsers = $true
	}

	if ($TeamId) {
		$IdType = 2
	} else {
		$IdType = 1
	}

	[Vault.VaultOnline]$Vault = $Script:Vault
	if ($Vault) {
		$task = $Vault.SyncDown()
        $task.GetAwaiter().GetResult()  | Out-Null

		$Task = $Vault.PutUserToSharedFolder($SharedFolderID,$UserID,$IdType,$options)
		$task.GetAwaiter().GetResult() | Out-Null
	}
}

function Remove-KeeperFolderMember {
	<#
		.Synopsis
		Adds member to Keeper Shared folder
	
		.Parameter SharedFolderID
		ID for shared folder
	
		.Parameter TeamId
		ID of team

		.Parameter UserId
		ID or email of user 
	#>
	[CmdletBinding()]
	Param(
		[Parameter()][string] $SharedFolderID,
		[Parameter()][string] $TeamId,
		[Parameter()][string] $UserId
	)

	if ($TeamId -and $UserId) {
		Write-Error "TeamId and UserId params cannot be used together."
		break
	}

	if ($TeamId) {
		$IdType = 2
	} else {
		$IdType = 1
	}

	[Vault.VaultOnline]$Vault = $Script:Vault
	if ($Vault) {
		$task = $Vault.SyncDown()
        $task.GetAwaiter().GetResult()  | Out-Null
		
		$Task = $Vault.RemoveUserFromSharedFolder($SharedFolderID,$UserID,$IdType)
		$task.GetAwaiter().GetResult() | Out-Null
	}
}