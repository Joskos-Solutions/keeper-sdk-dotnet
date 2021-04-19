using namespace KeeperSecurity.Sdk

function Get-KeeperTeams {
	<#
		.Synopsis
		Get Keeper Teams
	
		.Parameter Uid
		Team matching UId
	#>
	[CmdletBinding()]
	Param (
		[string] $Uid
	)
	
	$Enterprise = $Script:Enterprise
	if ($Enterprise) {
		if ($Uid) {
			return $Enterprise.Teams | Where-Object {$_.Uid -eq $Uid}
		} 
		$Enterprise.Teams
	} else {
		Write-Error -Message "Not connected"
	}
}

function Get-KeeperTeamMembers {
	<#
		.Synopsis
		Get Members of Team 
	
		.Parameter TeamId
		ID of Team to retreive members
	#>
	[CmdletBinding()]
	Param (
		[Parameter(Mandatory=$true)][string] $TeamId
	)
	
	$Enterprise = $Script:Enterprise
	if ($Enterprise) {
		$Output = @()
		$Team = $Enterprise.Teams | Where-Object { $_.Uid -eq $TeamId }
		foreach ($User in $Team.Users) {
			$User = $Enterprise.Users | Where-Object { $_.Id -eq $User }
			$Output += $User
		}
		Return $Output
	} else {
		Write-Error -Message "Not connected"
	}
}

function Add-KeeperTeamMember {
	<#
		.Synopsis
		Add Keeper Team Member
	
		.Parameter TeamUid
		UId for Team

		.Parameter MemberEmail
		Email address of member to remove
	#>
	[CmdletBinding()]
	Param (
		[Parameter(Mandatory=$true)] [string] $TeamUid,
		[Parameter(Mandatory=$true)] [string] $MemberEmail
	)

	$Enterprise = $Script:Enterprise
	if ($Enterprise) {
		$Task = $Enterprise.AddUsersToTeams($MemberEmail,$TeamUid)
		$Task.GetAwaiter().GetResult() | Out-Null
	} else {
		Write-Error -Message "Not connected"
	}
}

function Remove-KeeperTeamMember {
	<#
		.Synopsis
		Remove Keeper Team Member
	
		.Parameter TeamUid
		UId for Team

		.Parameter MemberEmail
		Email address of member to remove
	#>
	[CmdletBinding()]
	Param (
		[Parameter(Mandatory=$true)] [string] $TeamUid,
		[Parameter(Mandatory=$true)] [string] $MemberEmail
	)

	$Enterprise = $Script:Enterprise
	if ($Enterprise) {
		$Task = $Enterprise.RemoveUsersFromTeams($MemberEmail,$TeamUid)
		$Task.GetAwaiter().GetResult() | Out-Null
	} else {
		Write-Error -Message "Not connected"
	}
}

function Add-KeeperTeam {
		<#
		.Synopsis
		Add Keeper Team
	
		.Parameter Name
		Name of new Team

		.Parameter ParentNodeId
		Id of ParentNode 

		.Parameter RestrictEdit
		Restrict record editing 

		.Parameter RestrictSharing
		Restrict re-shares

		.Parameter RestrictView
		Applies privacy screen
	#>
	[CmdletBinding()]
	Param (
		[Parameter(Mandatory=$true)] [string] $Name,
		[Parameter()] [long] $ParentNodeId,
		[Parameter()] [bool] $RestrictEdit = $false,
		[Parameter()] [bool] $RestrictSharing = $false, 
		[Parameter()] [bool] $RestrictView = $false
	)

	if (!$ParentNodeId) {
		$ParentNodeID = Get-KeeperManagementNode | Where-Object { $_.ParentNodeId -eq 0 } | Select-Object -ExpandProperty Id
	}

	$Enterprise = $Script:Enterprise
	if ($Enterprise) {
		$Team = [KeeperSecurity.Enterprise.EnterpriseTeam]@{
			Name = $Name
			ParentNodeId = $ParentNodeId
			RestrictEdit = $RestrictEdit
			RestrictSharing = $RestrictSharing
			RestrictView = $RestrictView
		}
		$task = $Enterprise.CreateTeam($Team)
 		$Task.Result
		
	} else {
		Write-Error -Message "Not connected"
	}
}

function Remove-KeeperTeam {
	<#
		.Synopsis
		Remove Keeper Team
	
		.Parameter Name
		Id of Team to remove

	#>
	[CmdletBinding()]
	Param (
		[Parameter(Mandatory=$true)] [string] $TeamId
	)

	$Enterprise = $Script:Enterprise
	if ($Enterprise) {
		$task = $Enterprise.DeleteTeam($TeamId)
		$Task.GetAwaiter().GetResult() | Out-Null
	}
}