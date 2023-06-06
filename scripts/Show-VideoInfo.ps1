<#
    .SYNOPSIS
        動画情報を出力する
    .DESCRIPTION
        パスで指定された動画の情報を標準出力かファイル出力する
    .EXAMPLE
        Show-VideoInfo -Format "json" `
                       -OutFile $true `
                       "D:\video\example.mp4"
#>
Param(
    [parameter(mandatory=$true)][string]$SrcPath,
    [ValidateSet(
        "default", "compact", "csv", "flat", "ini", "json", "xml"
    )][string]$Format = "default",
    [boolean]$OutFile = $false
)

function Get-OutFileExt() {
    return $(switch ($Format) {
        "default" { "default.txt"; break }
        "compact" { "compact.txt"; break }
        "flat" { "flat.txt"; break }
        "csv" { "csv"; break }
        "ini" { "ini"; break }
        "json" { "json"; break }
        "xml" { "xml"; break }
        default { throw "Format の指定が不正" }
    })
}

function Out-InfoFile() {
    $Ext = Get-OutFileExt
    ffprobe -v "error" `
            -print_format $Format `
            -show_format `
            -show_streams `
            -show_chapters `
            -i $SrcPath `
            > ".\info.${Ext}"

    if ($LASTEXITCODE -ne 0) {
        throw "FFMpeg でエラー"
    }

    Write-Host "info.${Ext} ファイルに出力しました"
}

function Show-Info() {
    ffprobe -v "error" `
            -print_format $Format `
            -show_format `
            -show_streams `
            -show_chapters `
            -i $SrcPath

    if ($LASTEXITCODE -ne 0) {
        throw "FFMpeg でエラー"
    }
}

if ($OutFile) {
    Out-InfoFile
    exit 0
}
Show-Info

exit 0
