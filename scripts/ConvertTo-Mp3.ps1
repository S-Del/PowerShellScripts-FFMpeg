<#
    .SYNOPSIS
        mp3 に変換する
    .DESCRIPTION
        指定されたパスのファイルを mp3 に変換する
        パスにフォルダが指定された場合はその中身を全て変換する
#>
[CmdletBinding(DefaultParameterSetName="VBR")]
Param(
    [string]$SrcPath = ".",

    [parameter(ParameterSetName="VBR")][switch]$VBR,
    [parameter(mandatory=$true, ParameterSetName="VBR")][ValidateRange(0, 9)]$Q,

    [parameter(ParameterSetName="CBR")][switch]$CBR,
    [parameter(mandatory=$true, ParameterSetName="CBR")][ValidateSet(
        "8k", "16k", "24k", "32k", "40k", "48k", "64k", "80k", "96k",
        "112k", "128k", "160k", "192k", "224k", "256k", "320k"
    )]$Bitrate
)

function CBR-Encode {
    Param(
        [parameter(mandatory=$true)][string]$InputFilePath,
        [parameter(mandatory=$true)][string]$OutputFilePath,
        [parameter(mandatory=$true)][string]$Bitrate
    )

    ffmpeg -hide_banner `
        -i $InputFilePath`
        -vn `
        -acodec "libmp3lame" `
        -b:a $Bitrate `
        $OutputFilePath

    if ($LASTEXITCODE -ne 0) { throw "FFMpeg でエラー" }
}

function VBR-Encode {
    Param(
        [parameter(mandatory=$true)][string]$InputFilePath,
        [parameter(mandatory=$true)][string]$OutputFilePath,
        [parameter(mandatory=$true)][int]$Q
    )

    ffmpeg -hide_banner `
           -i $InputFilePath `
           -vn `
           -acodec "libmp3lame" `
           -q:a $Q `
           $OutputFilePath

    if ($LASTEXITCODE -ne 0) { throw "FFMpeg でエラー" }
}

if (!(Test-Path $SrcPath)) { throw "指定されたパスが存在しない" }
$File = Get-Item $SrcPath
$DistDirPath = Join-Path $SrcPath $DistDirName
New-Item $DistDirPath -ItemType "Directory" -Force

if (!$File.PSIsContainer) {
    $InputFilePath = $File.FullName
    $OutputFilePath = Join-Path $DistDirPath "$($File.BaseName).mp3"

    if ($CBR) { CBR-Encode $InputFilePath $OutputFilePath $Bitrate }
    VBR-Encode $InputFilePath $OutputFilePath $Q

    exit 0
}

$SrcDir = Get-ChildItem $SrcPath -File
if (($SrcDir | Measure-Object).Count -eq 0) { throw "指定されたソースフォルダが空" }

foreach ($Src in $SrcDir) {
    $InputFilePath = $Src.FullName
    $OutputFilePath = Join-Path $DistDirPath "$($Src.BaseName).mp3"

    if ($CBR) { CBR-Encode $InputFilePath $OutputFilePath $Bitrate }
    VBR-Encode $InputFilePath $OutputFilePath $Q
}

exit 0
