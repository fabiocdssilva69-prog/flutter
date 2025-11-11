# 🧪 TESTE 02: Usar abstract mixin class
# Hipótese: Talvez o compilador aceite se usarmos sintaxe mais moderna

Write-Host "🧪 TESTE 02: Abstract Mixin Class" -ForegroundColor Cyan

# Modifica .freezed.dart diretamente
$freezedFile = "lib/src/domain/entities/profile_entity.freezed.dart"
Copy-Item $freezedFile "$freezedFile.bak"

$content = Get-Content $freezedFile -Raw
$content = $content -replace 'mixin _\$(\w+)', 'abstract mixin class _$$1'
Set-Content $freezedFile $content -NoNewline

Write-Host "📝 Modificado: abstract mixin class _`$ProfileEntity" -ForegroundColor Yellow

# Testa compilação (sem regenerar - testa código modificado)
$result = flutter build apk --debug 2>&1
if ($LASTEXITCODE -eq 0) {
  Write-Host "✅ SUCESSO! Abstract mixin class funciona!" -ForegroundColor Green
  "TESTE 02: ✅ SUCESSO - abstract mixin class" | Out-File test_lab/results/02_success.txt
  exit 0
}
else {
  Write-Host "❌ FALHOU: Abstract mixin class não funciona" -ForegroundColor Red
  $result | Select-String "Error" | Select-Object -First 10 | Out-File test_lab/results/02_failure.txt
    
  # Restaura backup
  Move-Item "$freezedFile.bak" $freezedFile -Force
  exit 1
}
