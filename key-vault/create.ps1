[CmdletBinding()]
Param(
   [Parameter(Mandatory=$True)]
   [string]$name,
   [Parameter(Mandatory=$True)]
   [string]$group,
   [Parameter(Mandatory=$True)]
   [string]$location,
   [Parameter(Mandatory=$True)]
   [string]$user
)

New-AzureRmKeyVault -VaultName $name -ResourceGroupName $group -Location $location

Set-AzureRmKeyVaultAccessPolicy -VaultName $name -ResourceGroupName $group -EnabledForDeployment

Set-AzureRmKeyVaultAccessPolicy -VaultName $name -ResourceGroupName $group -UserPrincipalName $user -PermissionsToKeys all -PermissionsToSecrets all