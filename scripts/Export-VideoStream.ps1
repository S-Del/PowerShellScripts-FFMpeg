<#
    .SYNOPSIS
        動画からビデオストリームのみを取り出す
    .PARAMETER SrcPath
        文字列 (必須): 入力するソース動画のパスを指定する
    .PARAMETER OutputExtension
        文字列 (必須): 出力するファイルの拡張子を指定する
                       "." は不要。含まれていた場合は取り除かれる。
    .NOTES
        出力する拡張子を事前に調べる必要がある
        以下のコマンドで動画の情報を表示できる
            - `ffmpeg -hide_banner -i <動画パス>`
        もしくはこのリポジトリの Show-VideoInfo.ps1 を利用できる
            - `Get-Help Show-VideoInfo`
#>
Param(
    [parameter(mandatory=$true)][string]$SrcPath,
    [parameter(mandatory=$true)][string]$OutputExtension
)

$BaseName = (Get-ChildItem $SrcPath).BaseName
$OutputExtension = $OutputExtension -replace "\.", ""

ffmpeg -hide_banner `
       -i $SrcPath `
       -an `
       -vcodec: "copy" `
       "${BaseName}-video_only.${OutputExtension}"

if ($LASTEXITCODE -ne 0) {
    throw "ffmpeg でエラー"
}

exit 0
