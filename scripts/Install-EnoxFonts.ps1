#Requires -Version 5.1
<#
.SYNOPSIS
Installeert de vijf Enox-fonts voor de huidige Windows-gebruiker.
.DESCRIPTION
Downloadt het originele Microsoft Aptos-pakket 4.40 en controleert SHA-256.
Geen administratorrechten nodig. -WhatIf valideert het pakket zonder installatie.
.PARAMETER PackagePath
Optioneel pad naar het originele Microsoft ZIP-bestand voor offline gebruik.
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param([string]$PackagePath)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
if ([Environment]::OSVersion.Platform -ne [PlatformID]::Win32NT) {
    throw 'Dit script ondersteunt alleen Windows.'
}
$url = 'https://download.microsoft.com/download/8/6/0/860a94fa-7feb-44ef-ac79-c072d9113d69/Microsoft%20Aptos%20Fonts.zip'
$expectedHash = '6528FD120E719A9F985E94214ECA6887D1653B88456916A792A630B02E95B025'
$fonts = [ordered]@{
    'Aptos.ttf' = 'Aptos (TrueType)'
    'Aptos-Bold.ttf' = 'Aptos Bold (TrueType)'
    'Aptos-Italic.ttf' = 'Aptos Italic (TrueType)'
    'Aptos-Bold-Italic.ttf' = 'Aptos Bold Italic (TrueType)'
    'Aptos-Display-Bold.ttf' = 'Aptos Display Bold (TrueType)'
}
$fontDir = Join-Path ([Environment]::GetFolderPath('LocalApplicationData')) 'Microsoft\Windows\Fonts'
$registryPath = 'HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Fonts'
$download = $null
$archive = $null
$oldProtocol = [Net.ServicePointManager]::SecurityProtocol
try {
    if (-not $PackagePath) {
        $download = Join-Path ([IO.Path]::GetTempPath()) ('Enox-Aptos-' + [guid]::NewGuid().ToString('N') + '.zip')
        [Net.ServicePointManager]::SecurityProtocol = $oldProtocol -bor [Net.SecurityProtocolType]::Tls12
        Write-Host 'Downloaden van Microsoft Aptos 4.40...'
        Invoke-WebRequest -Uri $url -OutFile $download -UseBasicParsing
        $PackagePath = $download
    }
    $resolved = (Resolve-Path -LiteralPath $PackagePath).ProviderPath
    if ((Get-FileHash -LiteralPath $resolved -Algorithm SHA256).Hash -ne $expectedHash) {
        throw 'Onverwachte pakketinhoud (SHA-256 wijkt af). Er zijn geen fonts geinstalleerd. Controleer het Microsoft-pakket; omzeil deze controle niet.'
    }
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    $archive = [IO.Compression.ZipFile]::OpenRead($resolved)
    $selected = @{}
    foreach ($name in @($fonts.Keys) + @('Microsoft Aptos Fonts EULA.rtf')) {
        $matches = @($archive.Entries | Where-Object { $_.Name -eq $name })
        if ($matches.Count -ne 1) { throw "Pakket bevat geen uniek bestand: $name" }
        $selected[$name] = $matches[0]
    }
    Write-Host 'Pakket gecontroleerd. De Microsoft-licentie is van toepassing; zie de fontinstructies in deze repository.'
    if ($PSCmdlet.ShouldProcess($fontDir, 'Vijf Aptos-fonts installeren en registreren voor de huidige gebruiker')) {
        if (-not ('Enox.FontNative' -as [type])) {
            Add-Type -TypeDefinition @'
using System;
using System.Runtime.InteropServices;
namespace Enox {
    public static class FontNative {
        [DllImport("gdi32.dll", CharSet = CharSet.Unicode)]
        public static extern int AddFontResourceEx(string path, uint flags, IntPtr reserved);
        [DllImport("user32.dll", CharSet = CharSet.Unicode, SetLastError = true)]
        public static extern IntPtr SendMessageTimeout(IntPtr window, uint message,
            UIntPtr wparam, IntPtr lparam, uint flags, uint timeout, out UIntPtr result);
    }
}
'@
        }
        [IO.Directory]::CreateDirectory($fontDir) | Out-Null
        New-Item -Path $registryPath -Force | Out-Null
        foreach ($name in $fonts.Keys) {
            $target = Join-Path $fontDir $name
            $sourceStream = $selected[$name].Open()
            $memory = New-Object IO.MemoryStream
            try { $sourceStream.CopyTo($memory); $bytes = $memory.ToArray() }
            finally { $sourceStream.Dispose(); $memory.Dispose() }
            $sha = [Security.Cryptography.SHA256]::Create()
            try { $sourceHash = [BitConverter]::ToString($sha.ComputeHash($bytes)).Replace('-', '') }
            finally { $sha.Dispose() }
            if (Test-Path -LiteralPath $target) {
                if ((Get-FileHash -LiteralPath $target -Algorithm SHA256).Hash -ne $sourceHash) {
                    throw "Andere fontversie aanwezig: $target. Deze wordt niet overschreven. Verwijder die versie via Windows Instellingen voordat je opnieuw installeert."
                }
            } else { [IO.File]::WriteAllBytes($target, $bytes) }
            New-ItemProperty -Path $registryPath -Name $fonts[$name] -Value $target -PropertyType String -Force | Out-Null
            if ([Enox.FontNative]::AddFontResourceEx($target, 0, [IntPtr]::Zero) -eq 0) {
                throw "Windows kon het font niet laden: $target. Het bestand en de registratie zijn aanwezig; meld opnieuw aan en controleer het font."
            }
            Write-Host "Beschikbaar: $name"
        }
        $licenseDir = Join-Path ([Environment]::GetFolderPath('LocalApplicationData')) 'Enox\Licenses'
        [IO.Directory]::CreateDirectory($licenseDir) | Out-Null
        $licenseTarget = Join-Path $licenseDir 'Microsoft Aptos Fonts EULA.rtf'
        [IO.Compression.ZipFileExtensions]::ExtractToFile($selected['Microsoft Aptos Fonts EULA.rtf'], $licenseTarget, $true)
        $result = [UIntPtr]::Zero
        [Enox.FontNative]::SendMessageTimeout([IntPtr]0xffff, 0x001D, [UIntPtr]::Zero, [IntPtr]::Zero, 2, 3000, [ref]$result) | Out-Null
        Write-Host "Installatie gereed. Licentie: $licenseTarget"
        Write-Host 'Sluit Word, PowerPoint en LibreOffice en open ze opnieuw. Meld zo nodig opnieuw aan bij Windows.'
    }
} finally {
    if ($archive) { $archive.Dispose() }
    [Net.ServicePointManager]::SecurityProtocol = $oldProtocol
    if ($download -and (Test-Path -LiteralPath $download)) {
        # The temporary download is also removed after a -WhatIf validation.
        Remove-Item -LiteralPath $download -Force -WhatIf:$false -Confirm:$false
    }
}
