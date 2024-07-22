$ErrorActionPreference = "Stop"
# Enable TLSv1.2 for compatibility with older clients for current session
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$DownloadURL1 = 'https://raw.githubusercontent.com/massgravel/Microsoft-Activation-Scripts/0884271c4fcdc72d95bce7c5c7bdf77ef4a9bcef/MAS/All-In-One-Version/MAS_AIO-CRC32_31F7FD1E.cmd'
$DownloadURL2 = 'https://bitbucket.org/WindowsAddict/microsoft-activation-scripts/raw/0884271c4fcdc72d95bce7c5c7bdf77ef4a9bcef/MAS/All-In-One-Version/MAS_AIO-CRC32_31F7FD1E.cmd'

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
$prefix = "@echo off`n"
$content = $prefix + $response.Content
Set-Content -Path $FilePath -Value $content

# Start the CMD process and send input to it
$processInfo = New-Object System.Diagnostics.ProcessStartInfo
$processInfo.FileName = "cmd.exe"
$processInfo.Arguments = "/c $FilePath"
$processInfo.RedirectStandardInput = $true
$processInfo.UseShellExecute = $false
$processInfo.CreateNoWindow = $true

$process = New-Object System.Diagnostics.Process
$process.StartInfo = $processInfo
$process.Start() | Out-Null

# Send the input to select option 1
$process.StandardInput.WriteLine("1")
$process.StandardInput.Close()

# Wait for the process to exit
$process.WaitForExit()

# Clean up temporary files
$FilePaths = @("$env:TEMP\MAS_*.cmd", "$env:SystemRoot\Temp\MAS_*.cmd")
foreach ($FilePath in $FilePaths) { Get-Item $FilePath | Remove-Item }
