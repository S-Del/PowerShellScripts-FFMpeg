<#
    .SYNOPSIS
        連番画像から動画を作成する
    .DESCRIPTION
        連番画像を各フレームとした AVI 形式の動画を FFMpeg で作成し出力する
        コーデックは utvideo を利用する
    .PARAMETER InputFileName
        必須 (文字列): 入力する連番画像名のフォーマットを指定する
                       例: "%d.png"、"%05d.png"
    .PARAMETER InputFrameRate
        必須 (文字列): 入力フレームレートを指定する
                       例: "30000/1001"、"24"
                       この値と総画像数で再生時間が決定する
    .PARAMETER PixelFormat
        任意 (文字列) デフォルト - "yuv444p": 作成する動画の色空間フォーマットを指定できる。
    .PARAMETER OutputFrameRate
        任意 (文字列) デフォルト - InputFrameRate に同じ: 出力フレームレートを指定する
                                   例: "30000/1001"、"24"
    .PARAMETER OutputFileName
        任意 (文字列) デフォルト - "yyyy-MM-dd_HH-mm-ss.avi": 出力する動画のファイル名を指定できる。
    .EXAMPLE
        ConvertTo-AviFromSequencialImage -InputFileName "%05d.png" `
                                         -FrameRate "24000/1001" `
                                         -VideoSize "1280x720"
    .COMPONENT
        ffmpeg
        utvideo
#>
Param(
    [parameter(mandatory=$true)][string]$InputFileName,
    [parameter(mandatory=$true)][string]$InputFrameRate,
    [string]$PixelFormat = "yuv444p",
    [string]$OutputFrameRate = $InputFrameRate,
    [string]$OutputFileName = "$(Get-Date -Format yyyy-MM-dd_HH-mm-ss)"
)

<#
    -framerate オプションで入力フレームレートを明示することで、
    コマ落ちや再生時間が変わってしまう問題を回避する。
#>
ffmpeg -hide_banner `
       -framerate $InputFrameRate `
       -i $InputFileName `
       -vcodec "utvideo" `
       -pix_fmt $PixelFormat `
       -r $OutputFrameRate `
       "${OutputFileName}.avi"

if ($LASTEXITCODE -ne 0) {
    throw "FFMpeg でエラー"
}

exit 0
