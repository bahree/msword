param(
    [Parameter(Mandatory = $true)]
    [string]$InputPath,

    [Parameter(Mandatory = $true)]
    [string]$OutputPath
)

if (-not (Test-Path -LiteralPath $InputPath)) {
    throw "InputPath does not exist: $InputPath"
}

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

Set-Content -LiteralPath $OutputPath -Value $content -NoNewline -Encoding utf8
