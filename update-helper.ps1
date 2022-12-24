$Version_v2rayA = Invoke-WebRequest -Uri 'https://api.github.com/repos/v2raya/v2raya/releases/latest' | ConvertFrom-Json | Select-Object tag_name | ForEach-Object { ([string]$_.tag_name).Split('v')[1] }
$Version_v2ray = Invoke-WebRequest -Uri 'https://api.github.com/repos/v2fly/v2ray-core/releases/latest' | ConvertFrom-Json | Select-Object tag_name | ForEach-Object { ([string]$_.tag_name).Split('v')[1] }

$Url_v2rayA_x64 = "https://github.com/v2rayA/v2rayA/releases/download/v$Version_v2rayA/v2raya_windows_x64_$Version_v2rayA.exe"
$Url_v2rayA_A64 = "https://github.com/v2rayA/v2rayA/releases/download/v$Version_v2rayA/v2raya_windows_arm64_$Version_v2rayA.exe"
$Url_v2ray_x64 = "https://github.com/v2fly/v2ray-core/releases/download/v$Version_v2ray/v2ray-windows-64.zip"
$Url_v2ray_A64 = "https://github.com/v2fly/v2ray-core/releases/download/v$Version_v2ray/v2ray-windows-arm64-v8a.zip"

Write-Output $Url_v2rayA_x64 $Url_v2rayA_A64 $Url_v2ray_x64 $Url_v2ray_A64

New-Item -ItemType Directory -Path "./v2rayA-x64"
New-Item -ItemType Directory -Path "./v2rayA-x64/data"

New-Item -ItemType Directory -Path "./v2rayA-A64"
New-Item -ItemType Directory -Path "./v2rayA-A64/data"

Invoke-WebRequest $Url_v2rayA_x64 -OutFile "./v2rayA-x64/v2raya.exe"
Invoke-WebRequest $Url_v2rayA_A64 -OutFile "./v2rayA-A64/v2raya.exe"

Invoke-WebRequest -Uri "https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat" -OutFile "./LoyalsoldierSite.dat"
Invoke-WebRequest -Uri "https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat" -OutFile "./LoyalsoldierIP.dat"

Invoke-WebRequest $Url_v2ray_x64 -OutFile "./v2ray-windows-x64.zip"
Expand-Archive -Path "./v2ray-windows-x64.zip" -DestinationPath "./v2rayA-x64/"
Remove-Item -Path "./v2rayA-x64/*.json" -Force -Recurse
Move-Item -Path  "./v2rayA-x64/*.dat" -Destination "./v2rayA-x64/data" -Force
Copy-Item -Path "./LoyalsoldierSite.dat" -Destination "./v2rayA-x64/data"
Copy-Item -Path "./LoyalsoldierIP.dat" -Destination "./v2rayA-x64/data"

Invoke-WebRequest $Url_v2ray_A64 -OutFile "./v2ray-windows-A64.zip"
Expand-Archive -Path "./v2ray-windows-A64.zip" -DestinationPath "./v2rayA-A64/"
Remove-Item -Path "./v2rayA-A64/*.json" -Force -Recurse
Move-Item -Path  "./v2rayA-A64/*.dat" -Destination "./v2rayA-A64/data" -Force
Copy-Item -Path "./LoyalsoldierSite.dat" -Destination "./v2rayA-A64/data"
Copy-Item -Path "./LoyalsoldierIP.dat" -Destination "./v2rayA-A64/data"

Compress-Archive -Path "./v2rayA-x64/*" -DestinationPath "./v2rayA-x64.zip"
Compress-Archive -Path "./v2rayA-A64/*" -DestinationPath "./v2rayA-A64.zip"


Get-FileHash "./v2rayA-x64.zip" | Select-Object Hash | ForEach-Object { ([string]$_.Hash) } | Out-File -Path v2rayA_x64_sha256.txt
Get-FileHash "./v2rayA-A64.zip" | Select-Object Hash | ForEach-Object { ([string]$_.Hash) } | Out-File -Path v2rayA_A64_sha256.txt
