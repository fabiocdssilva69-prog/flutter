# Security Auditor
Write-Host "🔒 Auditoria de segurança..." -ForegroundColor Cyan

$issues = 0

# Verificar API keys
$dartFiles = Get-ChildItem -Path lib -Recurse -Filter *.dart
foreach ($file in $dartFiles) {
    $content = Get-Content $file.FullName -Raw
    if ($content -match "apiKey|secret|token") {
        Write-Host "⚠️  Possível key em: $($file.Name)" -ForegroundColor Yellow
        $issues++
    }
}

if ($issues -eq 0) {
    Write-Host "✅ Nenhum problema de segurança encontrado!" -ForegroundColor Green
} else {
    Write-Host "❌ $issues problemas de segurança encontrados!" -ForegroundColor Red
}
