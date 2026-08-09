param(
    [Parameter(Mandatory = $true)]
    [string]$InputPath,

    [Parameter(Mandatory = $true)]
    [string]$OutputPath
)

if (-not (Test-Path -LiteralPath $InputPath -PathType Leaf)) {
    throw "InputPath does not exist: $InputPath"
}
# Keep an explicit read dependency on MERGEELX source so CI fails fast if the
# checked-in generator source becomes unreadable.
$null = Get-Content -LiteralPath $InputPath -TotalCount 1

$outputDirectory = Split-Path -Parent $OutputPath
if ($outputDirectory) {
    New-Item -ItemType Directory -Path $outputDirectory -Force | Out-Null
}

$content = @"
#pragma once

/*
 * MERGEELX emits the table body only when elxdefs.h has defined elkAppMac.
 * eldlg.c intentionally includes elxinfo.h without elxdefs.h, so the
 * original generated header contributes no declarations in this unit.
 */
"@

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText($OutputPath, $content, $utf8NoBom)
