# 🧪 TESTE 20: Freezed 3.3.0-dev (Git Master)
# Hipótese: Versão em desenvolvimento pode ter o fix

Write-Host "🧪 TESTE 20: Freezed 3.3.0-dev (Git Master Branch)" -ForegroundColor Cyan
Write-Host "=" * 70

$testStart = Get-Date
$score = 0

# PASSO 1: Backup pubspec.yaml
Write-Host "`n💾 Backup pubspec.yaml..." -ForegroundColor Yellow
Copy-Item "pubspec.yaml" "pubspec.yaml.test20_backup" -Force

# PASSO 2: Modificar pubspec para usar Freezed do Git
Write-Host "`n📝 Modificando pubspec.yaml para Freezed master..." -ForegroundColor Yellow
$pubspecContent = Get-Content "pubspec.yaml" -Raw

$newPubspec = $pubspecContent -replace 'freezed: 3\.2\.0.*', @'
freezed:
    git:
      url: https://github.com/rrousselGit/freezed.git
      path: packages/freezed
      ref: master  # Última versão de desenvolvimento
'@

Set-Content "pubspec.yaml" $newPubspec -NoNewline

# PASSO 3: Instalar dependências
Write-Host "`n📦 Instalando Freezed master..." -ForegroundColor Yellow
$pubGetOutput = flutter pub get 2>&1
$pubGetSuccess = $LASTEXITCODE -eq 0

if (-not $pubGetSuccess) {
  Write-Host "❌ Erro ao instalar Freezed master" -ForegroundColor Red
  Write-Host $pubGetOutput | Select-String "error|Error" | Select-Object -First 5
  Move-Item "pubspec.yaml.test20_backup" "pubspec.yaml" -Force
  exit 1
}

Write-Host "✅ Freezed master instalado!" -ForegroundColor Green

# PASSO 4: Verificar versão instalada
Write-Host "`n🔍 Verificando versão..." -ForegroundColor Yellow
$lockContent = Get-Content "pubspec.lock" -Raw
if ($lockContent -match 'freezed:.*?version: ([\d\.]+)') {
  $version = $Matches[1]
  Write-Host "📌 Versão: $version" -ForegroundColor Cyan
}

# PASSO 5: Regenerar código
Write-Host "`n🔄 Regenerando com Freezed master..." -ForegroundColor Yellow
Get-ChildItem -Path lib -Recurse -Filter *.freezed.dart | Remove-Item -Force
$buildOutput = dart run build_runner build --delete-conflicting-outputs 2>&1
$buildSuccess = $LASTEXITCODE -eq 0

if (-not $buildSuccess) {
  Write-Host "⚠️ Erro na regeneração" -ForegroundColor Yellow
  $score += 10  # Tentou mas falhou na geração
}

# PASSO 6: Analisar código gerado
Write-Host "`n🔍 Analisando código gerado..." -ForegroundColor Yellow
$profileFreezed = "lib/src/domain/entities/profile_entity.freezed.dart"

if (Test-Path $profileFreezed) {
  $freezedContent = Get-Content $profileFreezed -Raw
    
  # Verificar se ainda tem o bug
  if ($freezedContent -match 'mixin _\$\w+ \{') {
    Write-Host "❌ Bug ainda presente: mixin sem constraint" -ForegroundColor Red
  }
  elseif ($freezedContent -match 'mixin _\$\w+ on \w+ \{') {
    Write-Host "✅ POSSIVELMENTE CORRIGIDO! Mixin com constraint!" -ForegroundColor Green
    $score += 30
  }
  else {
    Write-Host "⚠️ Estrutura de mixin diferente - investigar" -ForegroundColor Yellow
    $score += 15
  }
}

# PASSO 7: Testar compilação
Write-Host "`n🧪 Testando compilação..." -ForegroundColor Yellow
$analyzeOutput = dart analyze --fatal-infos 2>&1
$errorCount = ($analyzeOutput | Select-String "error •").Count

Write-Host "📊 Erros encontrados: $errorCount" -ForegroundColor $(if ($errorCount -eq 0) { "Green" } else { "Yellow" })

if ($errorCount -eq 0) {
  Write-Host "✅ SEM ERROS! Freezed master resolve o problema!" -ForegroundColor Green
  $score += 60
    
  # TESTE BÔNUS: Compilar APK
  Write-Host "`n🏆 TESTE BÔNUS: Compilando APK..." -ForegroundColor Cyan
  $apkOutput = flutter build apk --debug 2>&1
  if (Test-Path "build/app/outputs/flutter-apk/app-debug.apk") {
    $apkSize = (Get-Item "build/app/outputs/flutter-apk/app-debug.apk").Length / 1MB
    Write-Host "🎉 APK COMPILADO! $([math]::Round($apkSize, 2)) MB" -ForegroundColor Green
    $score += 10  # Bônus
  }
}

$testDuration = ((Get-Date) - $testStart).TotalSeconds

# RESULTADO FINAL
Write-Host "`n" + ("=" * 70) -ForegroundColor Cyan
Write-Host "📊 RESULTADO TESTE 20" -ForegroundColor White
Write-Host "=" * 70

$result = @{
  test           = 20
  name           = "Freezed 3.3.0-dev (Git Master)"
  score          = $score
  max_score      = 100
  errors         = $errorCount
  duration       = $testDuration
  success        = ($score -ge 70)
  recommendation = if ($score -ge 70) { "✅ USAR ESTA VERSÃO!" } elseif ($score -ge 40) { "⚠️ Parcialmente funcional" } else { "❌ Não resolver" }
}

Write-Host "🎯 Pontuação: $score/100" -ForegroundColor $(if ($score -ge 70) { "Green" } elseif ($score -ge 40) { "Yellow" } else { "Red" })
Write-Host "⏱️ Duração: $([math]::Round($testDuration, 1))s" -ForegroundColor Cyan
Write-Host "📋 Recomendação: $($result.recommendation)" -ForegroundColor $(if ($score -ge 70) { "Green" } elseif ($score -ge 40) { "Yellow" } else { "Red" })

# Salvar resultado
New-Item -Path "test_lab/results" -ItemType Directory -Force | Out-Null
$result | ConvertTo-Json | Set-Content "test_lab/results/test_20_result.json"

# PASSO 8: Restaurar pubspec original
Write-Host "`n↩️ Restaurando pubspec.yaml original..." -ForegroundColor Yellow
Move-Item "pubspec.yaml.test20_backup" "pubspec.yaml" -Force
flutter pub get | Out-Null

Write-Host "`n✅ Teste 20 concluído!" -ForegroundColor Green

if ($score -ge 70) {
  Write-Host "`n🎊🎊🎊 SOLUÇÃO ENCONTRADA! 🎊🎊🎊" -ForegroundColor Green
  Write-Host "Freezed master resolve o problema!" -ForegroundColor Green
  exit 0
}
else {
  exit 1
}
