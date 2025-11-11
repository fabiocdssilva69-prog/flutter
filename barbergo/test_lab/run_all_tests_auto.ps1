# Test Runner Automático
Write-Host "🧪 Executando suite completa de testes..." -ForegroundColor Cyan

# Testes estáticos
dart analyze
if ($LASTEXITCODE -ne 0) { exit 1 }

# Testes unitários
flutter test
if ($LASTEXITCODE -ne 0) { exit 1 }

# Verificações customizadas
.\test_lab\detect_circular_deps.ps1
.\test_lab\test_serialization.ps1

Write-Host "✅ Todos os testes passaram!" -ForegroundColor Green
