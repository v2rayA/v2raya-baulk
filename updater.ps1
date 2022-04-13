$VersionLatest = curl --silent "https://api.github.com/repos/v2rayA/v2rayA-baulk/releases/latest" | Select-String -Pattern "tag_name" | ForEach-Object { ([string]$_).Split('v')[1] } |  ForEach-Object { ([string]$_).Split('"')[0] }
$VersionCurrent = Get-Content .\bucket\v2raya.json | Select-String version | Select-Object -First 1| ForEach-Object { ([string]$_).Split('"')[3] }

function UpdateInfo (){
    $HashLatest_x64 = curl -Ls https://github.com/v2rayA/v2raya-baulk/releases/download/v$VersionLatest/v2rayA_x64_sha256.txt
    $HashLatest_A64 = curl -Ls https://github.com/v2rayA/v2raya-baulk/releases/download/v$VersionLatest/v2rayA_A64_sha256.txt
    $HashCurrent_x64 = Get-Content .\bucket\v2raya.json | Select-String url64.hash | ForEach-Object { ([string]$_).Split('"')[3] }
    $HashCurrent_A64 = Get-Content .\bucket\v2raya.json | Select-String urlarm64.hash |  ForEach-Object { ([string]$_).Split('"')[3] }
    (Get-Content -Path "./bucket/v2raya.json") -replace $VersionCurrent, $VersionLatest | Out-File "./bucket/v2raya.json"
    (Get-Content -Path "./bucket/v2raya.json") -replace $HashCurrent_x64, $HashLatest_x64 | Out-File "./bucket/v2raya.json"
    (Get-Content -Path "./bucket/v2raya.json") -replace $HashCurrent_A64, $HashLatest_A64 | Out-File "./bucket/v2raya.json"
    git commit "./bucket/v2raya.json" -m "v2raya: Update to $VersionLatest"
}

if ($VersionCurrent -eq $VersionLatest) {
    Write-Output "You have latest v2rayA with V2Ray core!"
}else {
    Write-Output "Updating v2rayA to $VersionLatest..."
    UpdateInfo
}