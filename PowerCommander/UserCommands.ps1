using namespace KeeperSecurity.Sdk

function Get-KeeperUsers {
	<#
		.Synopsis
		Get Keeper User
	
        .Parameter Email
        User matching email
	#>
	[CmdletBinding()]
	Param (
        [string] $Email
	)
	
	$Enterprise = $Script:Enterprise
	if ($Enterprise) {
        if ($Email) {
            return $Enterprise.Users | Where-Object { $_.Email -eq $Email }
        }
		$Enterprise.Users
	} else {
		Write-Error -Message "Not connected"
	}
}