<#
    .SYNOPSIS
        動き補償を利用して動画のフレームレートを変換する
    .NOTES
        - `ffmpeg -hide_banner -h filter=minterpolate`
        - https://ffmpeg.org/ffmpeg-filters.html#minterpolate
#>
Param(
    [parameter(mandatory=$true)][string]$SrcPath,
    [parameter(mandatory=$true)][string]$OutputFrameRate,
    [ValidateSet("dup", "blend", "mci")][string]$MotionInterpolationMode = "mci",
    [ValidateSet("obmc", "aobmc")][string]$MotionCompensationMode = "obmc",
    [ValidateSet("bidir", "bilat")][string]$MotionEstimationMode = "bilat",
    [ValidateSet(
        "esa", "tss", "tdls", "ntss", "fss", "ds", "hexbs", "epzs", "umh"
    )][string]$MotionEstimation = "epzs",
    [ValidateRange(4, 16)][int]$MacroBlockSize = 16,
    [ValidateRange(4, [int]::MaxValue)][int]$SearchParameter = 32,
    [ValidateSet(0, 1)][int]$VariableSizeBlockMotionCompensation = 0,
    [ValidateSet("none", "fdiff")][string]$SceneChangeDetectionMethod = "fdiff",
    [ValidateRange(0.0, 100.0)][double]$SceneChangeDetectionThreshold = 5.0,
    [string]$VideoCodec = "utvideo",
    [string]$AudioCodec = "pcm_s16le",
    [string]$PixelFormat = "yuv444p",
    [string]$OutputFileName = "$(Get-Date -Format yyyy-MM-dd_HH-mm-ss)"
)

$VideoFilter = @(
    "minterpolate=",
    "fps=${OutputFrameRate}:",
    "mi_mode=${MotionInterpolationMode}:",
    "mc_mode=${MotionCompensationMode}:",
    "me_mode=${MotionEstimationMode}:",
    "me=${MotionEstimation}:",
    "mb_size=${MacroBlockSize}:",
    "search_param=${SearchParameter}:",
    "vsbmc=${VariableSizeBlockMotionCompensation}:",
    "scd=${SceneChangeDetectionMethod}:",
    "scd_threshold=${SceneChangeDetectionThreshold}"
) -join ""

ffmpeg -hide_banner `
       -i $SrcPath `
       -acodec $AudioCodec `
       -vcodec $VideoCodec `
       -pix_fmt $PixelFormat `
       -vf $VideoFilter `
       "${OutputFileName}.avi"

if ($LASTEXITCODE -ne 0) {
    throw "FFMpeg でエラー"
}

exit 0
