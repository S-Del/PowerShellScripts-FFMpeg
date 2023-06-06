<#
    .SYNOPSIS
        2 つの動画ファイルを比較して SSIM 値を出力する
#>
Param(
    [parameter(mandatory=$true)][string]$SrcPath,
    [parameter(mandatory=$true)][string]$TgtPath,
    [boolean]$OutFile = $false
)

function Out-ResultFile() {
    ffmpeg -i $SrcPath `
            -i $TgtPath `
            -hide_banner `
            -filter_complex "scale2ref,ssim=ssim.txt" `
            -an `
            -f null -

    if ($LASTEXITCODE -ne 0) {
        throw "FFMpeg でエラー"
    }

    Write-Host "ssim.txt ファイルに詳細を出力しました"
}

function Show-Result() {
    ffmpeg -i $SrcPath `
            -i $TgtPath `
            -hide_banner `
            -filter_complex "scale2ref,ssim" `
            -an `
            -f null -

    if ($LASTEXITCODE -ne 0) {
        throw "FFMpeg でエラー"
    }
}

if ($OutFile) {
    Out-ResultFile
    exit 0
}

Show-Result

exit 0
