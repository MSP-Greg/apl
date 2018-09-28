$env:VCVER = "12"
$cd = $pwd
$path = $env:path

$base_path = "C:\Windows\system32;C:\Windows;C:\Windows\System32\Wbem"

$PSDefaultParameterValues['*:Encoding'] = 'utf8'

$7z_file = "7z1805-x64.exe"
$7z_uri  = "https://www.7-zip.org/a/$7z_file"

$openssl_base = "openssl-1.1.1_vc"
$openssl_uri  = "https://dl.bintray.com/msp-greg/VC-OpenSSL/$openssl_base$env:VCVER.7z"

$ruby_base = "rubyinstaller-2.5.1-2"
$ruby_uri  = "https://github.com/oneclick/rubyinstaller2/releases/download/$ruby_base/$ruby_base-x64.7z"

[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
$wc  = $(New-Object System.Net.WebClient)

$drv = (get-location).Drive.Name + ":"

# put all downloaded items in this folder
New-Item -Path $drv/depends -ItemType Directory 1> $null

#—————————————————————————————————————————————————————————————————————————  7Zip
$wc.DownloadFile($7z_uri, "$drv/depends/$7z_file")
# current version of 7zip seems to drop the last character when using the /Directory
# parameter for install
$t = "$drv/7zipp".replace('/', '\')
iex "$drv/depends/$7z_file /S /D=$t"
$env:path = "$drv\7zip;$base_path"
Write-Host "7zip installed"

#——————————————————————————————————————————————————————————————————————  OpenSSL
$file = "$openssl_base$env:VCVER.7z"
$wc.DownloadFile($openssl_uri, "$drv/depends/$file")

$dir = "-o$drv\openssl".replace('/', '\')
$file = "$drv/depends/$file"
7z.exe x $file $dir 1> $null
Write-Host "OpenSSL installed"

#—————————————————————————————————————————————————————————————————————————  Ruby
$file = "$drv/depends/$ruby_base-x64.7z"
$wc.DownloadFile($ruby_uri, "$file")
$dir = "-o$drv".replace('/', '\')
7z.exe x $file $dir 1> $null
Rename-Item -Path "$drv/$ruby_base-x64" -NewName "$drv/ruby"
Write-Host "Ruby installed"
$env:path = "$drv/ruby/bin;$env:path"
ruby -v
$path = $env:path
