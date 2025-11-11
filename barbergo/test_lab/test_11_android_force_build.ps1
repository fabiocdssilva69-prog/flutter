# 🧪 TESTE 11: Compilação Android Forçada (Ignorar Analyzer)
# Hipótese: Gradle consegue compilar mesmo com analyzer reclamando

Write-Host "🧪 TESTE 11: Android Force Build (Bypass Analyzer)" -ForegroundColor Cyan
Write-Host "=" * 60

$testStart = Get-Date

# PASSO 1: Verificar device conectado
Write-Host "`n📱 Verificando device Android..." -ForegroundColor Yellow
$device = flutter devices --machine | ConvertFrom-Json | Where-Object { $_.platformType -eq "android" } | Select-Object -First 1

if (-not $device) {
  Write-Host "❌ Nenhum device Android conectado!" -ForegroundColor Red
  exit 1
}

Write-Host "✅ Device: $($device.name) ($($device.id))" -ForegroundColor Green

# PASSO 2: Limpar build anterior
Write-Host "`n🧹 Limpando build anterior..." -ForegroundColor Yellow
flutter clean | Out-Null
Remove-Item -Path "build" -Recurse -Force -ErrorAction SilentlyContinue

# PASSO 3: Tentar compilação DIRETA sem analyzer
Write-Host "`n🔨 Tentando compilação DIRETA (sem dart analyze)..." -ForegroundColor Yellow
Write-Host "Comando: flutter build apk --debug --no-tree-shake-icons" -ForegroundColor Gray

$buildOutput = flutter build apk --debug --no-tree-shake-icons 2>&1
$buildSuccess = $LASTEXITCODE -eq 0

$testDuration = ((Get-Date) - $testStart).TotalSeconds

# PASSO 4: Verificar se APK foi gerado
$apkPath = "build/app/outputs/flutter-apk/app-debug.apk"
$apkExists = Test-Path $apkPath

Write-Host "`n" + ("=" * 60) -ForegroundColor Cyan

if ($apkExists) {
  $apkSize = (Get-Item $apkPath).Length / 1MB
  Write-Host "✅✅✅ SUCESSO TOTAL! APK GERADO! ✅✅✅" -ForegroundColor Green
  Write-Host "📦 Tamanho: $([math]::Round($apkSize, 2)) MB" -ForegroundColor Cyan
  Write-Host "⏱️ Tempo: $([math]::Round($testDuration, 1))s" -ForegroundColor Yellow
    
  # PASSO 5: Tentar instalar no device
  Write-Host "`n📲 Instalando no device..." -ForegroundColor Yellow
  flutter install -d $device.id
    
  if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ App instalado com sucesso!" -ForegroundColor Green
    Write-Host "`n🎯 TESTE 11: SUCESSO - Gradle compila mesmo com analyzer reclamando!" -ForegroundColor Green
    exit 0
  }
  else {
    Write-Host "⚠️ APK gerado mas instalação falhou" -ForegroundColor Yellow
    exit 0
  }
}
else {
  Write-Host "❌ FALHOU - Gradle também não consegue compilar" -ForegroundColor Red
  Write-Host "Erros principais:" -ForegroundColor Yellow
  $buildOutput | Select-String "Error:" | Select-Object -First 5
  Write-Host "`n⏱️ Tempo: $([math]::Round($testDuration, 1))s" -ForegroundColor Yellow
  exit 1
}
