using namespace KeeperSecurity.Sdk

function Get-KeeperTeams {
	<#
		.Synopsis
		Get Keeper Teams
	
		.Parameter Uid
		Teams UID
	
		.Parameter Filter
		Return matching Teams only
	#>
	[CmdletBinding()]
	[OutputType([Vault.Team[]])] 
	Param (
		[string] $Uid,
		[string] $Filter
	)
	Begin {
	}
	
	Process {
		[Vault.VaultOnline]$Vault = $Script:Vault
		if ($vault) {
			[Vault.Team] $Teams = $null

			if ($Uid) {
				if ($Vault.TryGetTeam($uid, [ref]$Teams)) {
					$Teams
				}
			} else {
				foreach ($Team in $Vault.Teams) {
					if ($Filter) {
						$match = $($record.Uid, $Team.Name) | Select-String $Filter | Select-Object -First 1
						if (-not $match) {
							continue
						}
					}
					$Team
				}
			}
		} else {
			Write-Error -Message "Not connected"
		}
	}
	
	End {}
}