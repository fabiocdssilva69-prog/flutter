# Watchdog - Detecta se mixin bug reapareceu
$freezedFiles = Get-ChildItem -Path lib -Recurse -Filter *.freezed.dart
$bugFound = $false
foreach ($file in $freezedFiles) {
    $content = Get-Content $file.FullName -Raw
    if ($content -match 'mixin\s+_\$\w+\s+on\s+\w+\s*\{') {
        # Padrão CORRETO encontrado
    } elseif ($content -match 'mixin\s+_\$\w+\s*\{') {
        Write-Host "❌ BUG DETECTADO: $($file.Name)" -ForegroundColor Red
        $bugFound = $true
    }
}
if (-not $bugFound) {
    Write-Host "✅ Sem bugs de mixin" -ForegroundColor Green
}
exit $(if ($bugFound) { 1 } else { 0 })
