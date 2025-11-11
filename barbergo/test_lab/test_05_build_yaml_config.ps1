# 🧪 TESTE 05: Configurar build.yaml para controlar geração
# Hipótese: Podemos forçar Freezed a gerar código diferente

Write-Host "🧪 TESTE 05: build.yaml Configuration" -ForegroundColor Cyan

# Cria build.yaml customizado
$buildYaml = @"
targets:
  `$default:
    builders:
      freezed:
        options:
          # Força formatação manual
          format: false
          # Usa classes abstratas
          abstract_classes: true
          # Desabilita mixin generation
          mixin: false
"@

Set-Content build.yaml $buildYaml

Write-Host "📝 Criado build.yaml customizado" -ForegroundColor Yellow

# Limpa e regenera
Get-ChildItem -Path lib -Recurse -Filter *.freezed.dart | Remove-Item -Force
dart run build_runner build --delete-conflicting-outputs 2>&1 | Out-Null

$result = flutter build apk --debug 2>&1
if ($LASTEXITCODE -eq 0) {
  Write-Host "✅ SUCESSO! build.yaml config funciona!" -ForegroundColor Green
  "TESTE 05: ✅ SUCESSO - build.yaml config" | Out-File test_lab/results/05_success.txt
  Copy-Item build.yaml test_lab/results/05_working_build.yaml
  exit 0
}
else {
  Write-Host "❌ FALHOU: build.yaml config não funciona" -ForegroundColor Red
  $result | Select-String "Error" | Select-Object -First 10 | Out-File test_lab/results/05_failure.txt
  Remove-Item build.yaml -ErrorAction SilentlyContinue
  exit 1
}
