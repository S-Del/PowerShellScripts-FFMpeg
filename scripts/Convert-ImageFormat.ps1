<#
    .SYNOPSIS
        フォルダ内の指定された形式の画像を他の形式に変換する
    .EXAMPLE
        Convert-ImageFormat -FromExtension ".png" `
                            -ToExtension ".jpg"
#>
Param(
    [parameter(mandatory=$true)][string]$FromExtension,
    [parameter(mandatory=$true)][string]$ToExtension,
    [string]$SrcDirPath = ".",
    [ValidateRange(-1,69)][int]$Quality = 1,
    [string]$OutputDirName = "converted"
)

New-Item ".\${OutputDirName}" -ItemType "Directory" -Force

<#
    Get-ChildItem の -Filter オプションを使うことも考えたが、
    指定した拡張子以外にもヒットするのでやめた。
    例えば `*.htm` などと指定されたときに `.html` などもヒットしてしまう
    これは `*.htm*` などと指定してるのと同じ挙動だ
    MS-DOS の仕様を引き継いでこの様になっているようだ
#>
foreach ($item in Get-ChildItem -Path $SrcDirPath -File) {
    if ($item.Extension -ne $FromExtension) {
        continue
    }

    ffmpeg -hide_banner `
           -i "$($item.FullName)" `
           -f "image2" `
           -qmin 1 `
           -q $Quality `
           ".\${OutputDirName}\$($item.BaseName)${ToExtension}"

    if ($LASTEXITCODE -ne 0) {
        throw "FFMpeg でエラー"
    }
}

exit 0
