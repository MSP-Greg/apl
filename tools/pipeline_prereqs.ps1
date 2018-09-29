$env:VCVER = "12"
$cd = $pwd
$path = $env:path

$base_path = "C:\Windows\system32;C:\Windows;C:\Windows\System32\Wbem"

$PSDefaultParameterValues['*:Encoding'] = 'utf8'

$7z_file = "7zip_ci.zip"
$7z_uri  = "https://dl.bintray.com/msp-greg/VC-OpenSSL/7zip_ci.zip"

$openssl_base = "openssl-1.1.1_vc"
$openssl_uri  = "https://dl.bintray.com/msp-greg/VC-OpenSSL/$openssl_base$env:VCVER.7z"

$ruby_base = "rubyinstaller-2.5.1-2"
$ruby_uri  = "https://github.com/oneclick/rubyinstaller2/releases/download/$ruby_base/$ruby_base-x64.7z"

$zlib_file = "zlib1.2.11.zip"
$zlib_uri  = "https://zlib.net/$zlib_file"

[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
$wc  = $(New-Object System.Net.WebClient)

$drv = (get-location).Drive.Name + ":"

# put all downloaded items in this folder
New-Item -Path $drv/depends -ItemType Directory 1> $null

#—————————————————————————————————————————————————————————————————————————  7Zip
$wc.DownloadFile($7z_uri, "$drv/depends/$7z_file")
Expand-Archive -Path "$drv/depends/$7z_file" -DestinationPath "$drv/7zip"
$env:path = "$drv/7zip;$base_path"
Write-Host "7zip installed"

#——————————————————————————————————————————————————————————————————————  OpenSSL
$file = "$drv/depends/$openssl_base$env:VCVER.7z"
$wc.DownloadFile($openssl_uri, $file)
$dir = "-o$drv\openssl"
7z.exe x $file $dir 1> $null
Write-Host "OpenSSL installed"
$env:path = "$drv/openssl/bin;$env:path"
openssl.exe version

#—————————————————————————————————————————————————————————————————————————  Ruby
$file = "$drv/depends/$ruby_base-x64.7z"
$wc.DownloadFile($ruby_uri, $file)
$dir = "-o$drv\"
7z.exe x $file $dir 1> $null
Rename-Item -Path "$drv/$ruby_base-x64" -NewName "$drv/ruby"
Write-Host "Ruby installed"
$env:path = "$drv/ruby/bin;$env:path"
ruby -v

#—————————————————————————————————————————————————————————————————————————  zlib
$file = "$drv/depends/$zlib_file"
$wc.DownloadFile($zlib_uri, $file)
$dir = "-o$AGENT_BUILDDIRECTORY\ext\zlib"
Expand-Archive -Path $file -DestinationPath $dir

$env:path = $path
