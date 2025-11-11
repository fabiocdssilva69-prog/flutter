# 🧪 TESTE 07: Adicionar constraint de mixin CORRETAMENTE
# Hipótese: "on ProfileEntity" pode funcionar se aplicado de forma específica

Write-Host "🧪 TESTE 07: Manual Mixin Constraint (Smart)" -ForegroundColor Cyan

$freezedFile = "lib/src/domain/entities/profile_entity.freezed.dart"
Copy-Item $freezedFile "$freezedFile.bak"

$content = Get-Content $freezedFile -Raw

# CORREÇÃO INTELIGENTE: Adiciona constraint apenas no mixin abstrato, não na implementação
$content = $content -replace '(?m)^(/// @nodoc\s+mixin _\$ProfileEntity) \{', '$1 on ProfileEntity {'

Set-Content $freezedFile $content -NoNewline

Write-Host "📝 Modificado: mixin _`$ProfileEntity on ProfileEntity" -ForegroundColor Yellow

$result = flutter build apk --debug 2>&1
if ($LASTEXITCODE -eq 0) {
  Write-Host "✅ SUCESSO! Constraint inteligente funciona!" -ForegroundColor Green
  "TESTE 07: ✅ SUCESSO - manual mixin constraint" | Out-File test_lab/results/07_success.txt
  exit 0
}
else {
  $errorMsg = ($result | Select-String "Error" | Select-Object -First 5) -join "`n"
    
  if ($errorMsg -notmatch "supertype of itself") {
    Write-Host "⚠️ Erro diferente! Pode ser progresso:" -ForegroundColor Yellow
    Write-Host $errorMsg -ForegroundColor Gray
    "TESTE 07: ⚠️ Erro diferente (investigar): $errorMsg" | Out-File test_lab/results/07_different_error.txt
  }
  else {
    Write-Host "❌ FALHOU: Ainda causa circular dependency" -ForegroundColor Red
  }
    
  $result | Out-File test_lab/results/07_failure.txt
  Move-Item "$freezedFile.bak" $freezedFile -Force
  exit 1
}
