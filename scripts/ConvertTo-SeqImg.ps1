<#
    .SYNOPSIS
        動画から連番画像を出力する
#>
Param(
    [parameter(mandatory=$true)][string]$SrcPath,
    [string]$DirName = "sequence",
    [string]$StartTime = "0:00",
    [int]$Sec = 3
)

New-Item ".\${DirName}" -ItemType "Directory" -Force

ffmpeg -hide_banner `
        -i $SrcPath `
        -ss $StartTime `
        -t $Sec `
        -f "image2" `
        -start_number 0 `
        ".\${DirName}\%04d.png"

if ($LASTEXITCODE -ne 0) {
    throw "FFMpeg でエラー"
}

exit 0
