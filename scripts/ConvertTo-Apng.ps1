<#
    .SYNOPSIS
        動画からアニメーション APNG 画像を作成する
#>
Param(
    [parameter(mandatory=$true)][string]$SrcPath,
    [int]$Loop = 0,
    [string]$FrameRate = "24000/1001",
    [string]$OutputName = "$(Get-Date -Format yyyy-MM-dd_HH-mm-ss)"
)

ffmpeg -hide_banner `
       -i $SrcPath `
       -plays $Loop `
       -r $FrameRate `
       -an `
       "${OutputName}.apng"

if ($LASTEXITCODE -ne 0) {
    throw "ffmpeg でエラー"
}

exit 0
