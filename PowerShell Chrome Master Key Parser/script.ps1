Add-Type -AssemblyName "System.Security"

$LocalStateContent = Get-Content -Path "$($env:LOCALAPPDATA)\\Google\\Chrome\\User Data\\Local State" -Raw
$match = [regex]::Match($LocalStateContent, '"encrypted_key"\s*:\s*"([^"]+)"')

if ($match.Success) {
    $encKeyBase64 = $match.Groups[1].Value
    $encKeyBytes = [System.Convert]::FromBase64String($encKeyBase64)[5..([System.Convert]::FromBase64String($encKeyBase64).Length-1)]
    $masterKey = [System.Security.Cryptography.ProtectedData]::Unprotect($encKeyBytes, $null, [System.Security.Cryptography.DataProtectionScope]::CurrentUser)
    Write-Host "Master key (BASE64): $([System.Convert]::ToBase64String($masterKey))"
} else {
    Write-Host "Error: Could not find 'encrypted_key' in Local State file."
}