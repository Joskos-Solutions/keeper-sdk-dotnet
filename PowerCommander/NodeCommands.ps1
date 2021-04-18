using namespace KeeperSecurity.Sdk

function Get-KeeperManagementNode {
	<#
		.Synopsis
		Get Keeper Management Nodes
	
		.Parameter Id
		Node matching Id
	#>
	[CmdletBinding()]
	Param (
		[string] $Id
	)
	
	$Enterprise = $Script:Enterprise
	if ($Enterprise) {
		if ($Id) {
			return $Enterprise.Nodes | Where-Object {$_.Id -eq $Id}
		} 
		$Enterprise.Nodes
	} else {
		Write-Error -Message "Not connected"
	}
}