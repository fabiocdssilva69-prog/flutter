# Auto-fix de Warnings
Write-Host "🔧 Aplicando dart fix..." -ForegroundColor Cyan
dart fix --apply

Write-Host "📊 Contando warnings restantes..." -ForegroundColor Cyan
$warnings = (dart analyze 2>&1 | Select-String "warning •").Count
Write-Host "⚠️  Warnings restantes: $warnings" -ForegroundColor Yellow

if ($warnings -eq 0) {
    Write-Host "✅ Código limpo de warnings!" -ForegroundColor Green
} else {
    Write-Host "💡 Revisar manualmente os $warnings warnings restantes" -ForegroundColor Cyan
}
