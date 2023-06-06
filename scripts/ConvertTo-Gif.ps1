<#
    .SYNOPSIS
        アニメーション GIF を作成する
    .DESCRIPTION
        入力された動画からアニメーション GIF を作成して出力する
        出力名には使用したディザリングアルゴリズムの名前が付加される
    .PARAMETER SrcPath
        文字列 (必須): 入力するソース動画のパスを指定する
    .PARAMETER OutputFrameRate
        文字列 (必須): 出力フレームレートの指定する
    .PARAMETER AlgoNum
        整数 0-5: 使用するアルゴリズムを整数で指定できる (デフォルト: 5)
                  1: bayer
                  2: heckbert
                  3: floyd_steinberg
                  4: sierra2
                  5: sierra2_4a (default)
    .PARAMETER Loop
        整数 -1 to 65535: ループ回数を整数で指定できる (デフォルト: 0)
                          -1: ループ無し
                           0: 無限ループ
    .EXAMPLE
        ConvertTo-Gif -OutputFrameRate "24000/1001" `
                      -AlgoNum 3 `
                      -Loop -1 `
                      .\src.avi
    .NOTES
        - `ffmpeg -h filter=paletteuse`
        - `ffmepg -h muxer=gif`
#>
Param(
    [parameter(mandatory=$true)][string]$SrcPath,
    [parameter(mandatory=$true)][string]$OutputFrameRate,
    [ValidateRange(0,5)][int]$AlgoNum = 5,
    [ValidateRange(-1,65535)][int]$Loop = 0
)

$AlgoName = switch ($AlgoNum) {
    0 { "none" }
    1 { "bayer" }
    2 { "heckbert" }
    3 { "floyd_steinberg" }
    4 { "sierra2" }
    5 { "sierra2_4a" }
}

$FilterComplex = @(
    "[0:v] fps=${OutputFrameRate},",
    "scale=-1:-1,",
    "split [a][b];",
    "[a] palettegen [p];[b][p] paletteuse=dither=${AlgoName}"
) -join ""

$BaseName = (Get-ChildItem $SrcPath).BaseName

ffmpeg -hide_banner `
       -i $SrcPath `
       -filter_complex $FilterComplex `
       -loop $Loop `
       -an `
       "${BaseName}-${AlgoName}.gif"

if ($LASTEXITCODE -ne 0) {
    throw "ffmpeg でエラー"
}

exit 0
