[CmdletBinding()]
Param(
   [Parameter(Mandatory=$True)]
   [string]$name,
   [Parameter(Mandatory=$True)]
   [string]$password,
   [Parameter(Mandatory=$True)]
   [string]$vault
)

$certificate = New-SelfSignedCertificate -Subject $name -Provider 'Microsoft Enhanced Cryptographic Provider v1.0'
$filePath = (Get-Item -Path ".\" -Verbose).FullName + '\' + $certificate.Thumbprint + '.pfx'
$secure = ConvertTo-SecureString $password -AsPlainText -Force

Export-PfxCertificate -Cert $certificate -Password $secure -FilePath $filePath 

$bytes = [System.IO.File]::ReadAllBytes($filePath)
$base64 = [System.Convert]::ToBase64String($bytes)

$jsonBlob = @{
   data = $base64
   dataType = 'pfx'
   password = $password
   } | ConvertTo-Json

    $contentbytes = [System.Text.Encoding]::UTF8.GetBytes($jsonBlob)
    $content = [System.Convert]::ToBase64String($contentbytes)

    $secretValue = ConvertTo-SecureString -String $content -AsPlainText -Force

$secret = Set-AzureKeyVaultSecret -VaultName $vault -Name $name -SecretValue $secretValue

$output = @{};
$output.SourceVault = $vault;
$output.CertificateURL = $secret.Id;
$output.CertificateThumbprint = $certificate.Thumbprint;

return $output  | Format-List