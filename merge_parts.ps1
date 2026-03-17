param(
    [string]$PartDir
)

$manifestPath = Join-Path $PartDir "manifest.json"
if (!(Test-Path $manifestPath)) {
    throw "manifest.json not found in $PartDir"
}

$meta = Get-Content $manifestPath -Raw | ConvertFrom-Json
$outFile = Join-Path $PartDir $meta.original_name

if (Test-Path $outFile) {
    Remove-Item $outFile -Force
}

$out = [System.IO.File]::Open($outFile, [System.IO.FileMode]::Create)
try {
    $parts = Get-ChildItem -Path $PartDir -Filter "*.part*" | Sort-Object Name
    foreach ($p in $parts) {
        $bytes = [System.IO.File]::ReadAllBytes($p.FullName)
        $out.Write($bytes, 0, $bytes.Length)
    }
} finally {
    $out.Close()
}

$hash = (Get-FileHash -Algorithm SHA256 -Path $outFile).Hash
Write-Host "Merged file: $outFile"
Write-Host "SHA256    : $hash"
Write-Host "Expected  : $($meta.sha256)"

if ($hash -eq $meta.sha256) {
    Write-Host "[OK] checksum matched"
} else {
    Write-Host "[FAIL] checksum mismatch"
}