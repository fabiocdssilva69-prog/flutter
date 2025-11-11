# Sistema de Backup Automático
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$backupDir = "backups/$timestamp"
New-Item -ItemType Directory -Path $backupDir -Force | Out-Null

# Backup de arquivos críticos
Copy-Item "pubspec.yaml" "$backupDir/" -Force
Get-ChildItem -Path lib -Recurse -Filter *.dart | ForEach-Object {
    $relativePath = $_.FullName.Substring((Get-Location).Path.Length + 1)
    $backupPath = Join-Path $backupDir $relativePath
    New-Item -ItemType Directory -Path (Split-Path $backupPath) -Force | Out-Null
    Copy-Item $_.FullName $backupPath -Force
}

Write-Host "✅ Backup criado: $backupDir" -ForegroundColor Green
