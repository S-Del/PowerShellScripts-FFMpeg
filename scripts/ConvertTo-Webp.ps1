<#
    .SYNOPSIS
        動画ファイルをモーション webp に変換する
    .PARAMETER Lossless
        <bool> 0 or 1: 0 (default)
                       1 lossless
    .PARAMETER Quality
        <float> 0 to 100: 75 (default)
    .PARAMETER Preset
        <int> -1 to 5: -1 - none (default) <- 何故かこちらがデフォルト
                        0 - default        <- デフォルトとは・・・？？？
                        1 - picture
                        2 - photo
                        3 - drawing
                        4 - icon
                        5 - text
    .NOTES
        ffmpeg -h encoder=libwebp
#>

Param(
    [parameter(mandatory=$true)][string]$SrcPath,
    [int]$Lossless = 0,
    [ValidateRange(0,100)][float]$Quality = 75,
    [ValidateRange(-1,5)][int]$Preset = -1,
    [int]$Loop = 0,
    [string]$OutputName = "$(Get-Date -Format yyyy-MM-dd_HH-mm-ss)"
)

ffmpeg -hide_banner `
       -i $SrcPath `
       -vcodec "libwebp" `
       -lossless $Lossless `
       -quality $Quality `
       -preset $Preset `
       -loop $Loop `
       -an `
       -vsync "0" `
       "${OutputName}.webp"

if ($LASTEXITCODE -ne 0) {
    throw "ffmpeg でエラー"
}

exit 0
