# Limpar Logs Sensíveis
Write-Host "🔒 Verificando logs com dados sensíveis..." -ForegroundColor Cyan
$dartFiles = Get-ChildItem -Path lib -Recurse -Filter *.dart
$printsFound = 0
foreach ($file in $dartFiles) {
    $content = Get-Content $file.FullName -Raw
    $prints = ([regex]::Matches($content, "print\(")).Count
    $printsFound += $prints
}
Write-Host "⚠️  $printsFound prints encontrados" -ForegroundColor Yellow
Write-Host "💡 Usar logger com níveis (debug/info/error)" -ForegroundColor Cyan
Write-Host "💡 Remover prints em --release builds" -ForegroundColor Cyan
