<#
    .SYNOPSIS
        指定された動画をリサイズして AVI 形式で出力する
    .PARAMETER AlgorithmNumber
        任意 (整数) 0 - 5: リサイズに使用されるアルゴリズムを整数で指定する
                           0 - point
                           1 - bilinear (default)
                           2 - bicubic
                           3 - spline16
                           4 - spline32
                           5 - lanczos
    .NOTES
        ffmpeg -h filter=zscale
#>
Param(
    [parameter(mandatory=$true)][string]$SrcPath,
    [string]$Width = "-1",
    [string]$Height = "-1",
    [ValidateRange(0,5)][int]$AlgorithmNumber = 1,
    [string]$OutputFileName = (&{
        $BaseName = (Get-ChildItem $SrcPath).BaseName
        $AlgorithmName = switch ($AlgorithmNumber) {
            0 { "point" }
            1 { "bilinear" }
            2 { "bicubic" }
            3 { "spline16" }
            4 { "spline32" }
            5 { "lanczos" }
        }
        return "${BaseName}_${AlgorithmName}-resized"
    })
)

ffmpeg -hide_banner `
       -i $SrcPath `
       -vf "zscale=w=${Width}:h=${Height}:f=${AlgorithmNumber}" `
       -vcodec "utvideo" `
       -pix_fmt "yuv444p" `
       -acodec "copy" `
       "${OutputFileName}.avi"

if ($LASTEXITCODE -ne 0) {
    throw "FFMpeg でエラー"
}

exit 0
