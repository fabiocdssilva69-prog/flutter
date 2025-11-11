# ����� SOLUÇÃO DEFINITIVA: Análise Reversa do Sucesso
# Baseado nos terminais Exit Code 0 do usuário

Write-Host @"
╔══════════════════════════════════════════════════════════╗
║  🔬 ANÁLISE REVERSA: Por que funcionou antes?           ║
╚══════════════════════════════════════════════════════════╝
"@ -ForegroundColor Cyan

Write-Host "`n📋 DADOS DOS TERMINAIS COM EXIT CODE 0:" -ForegroundColor Yellow
Write-Host "   ✅ flutter run -d uwbekb8hpf6lamts (Exit 0)" -ForegroundColor Green
Write-Host "   ✅ dart run build_runner build (Exit 0)" -ForegroundColor Green
Write-Host "   ✅ firebase deploy --only firestore:rules (Exit 0)" -ForegroundColor Green

Write-Host "`n💡 HIPÓTESE: O app RODOU mesmo com erros de analyzer!" -ForegroundColor Cyan
Write-Host "   Razão: Erros podem ser apenas WARNINGS do analyzer," -ForegroundColor Gray
Write-Host "          mas o runtime Dart ignora e executa normalmente." -ForegroundColor Gray

Write-Host "`n🧪 TESTE: Rodar app no dispositivo IGNORANDO analyzer" -ForegroundColor Yellow

# Verifica se dispositivo está conectado
$devices = flutter devices --machine | ConvertFrom-Json
$redmi = $devices | Where-Object { $_.id -eq "uwbekb8hpf6lamts" }

if ($redmi) {
  Write-Host "`n📱 Dispositivo encontrado: $($redmi.name)" -ForegroundColor Green
    
  # Tenta rodar (mesmo com erros de analyzer)
  Write-Host "`n🚀 Executando flutter run..." -ForegroundColor Cyan
  Write-Host "   ⚠️ Se pedir 'r' para reload, significa que FUNCIONOU!" -ForegroundColor Yellow
    
  $runOutput = flutter run -d uwbekb8hpf6lamts --no-pub 2>&1
    
  if ($runOutput -match "Application finished|Flutter run key commands|To hot reload") {
    Write-Host "`n✅ SUCESSO! APP RODANDO!" -ForegroundColor Green
    "✅ flutter run FUNCIONA (app executa mesmo com erros de analyzer)" | Out-File test_lab/results/SOLUCAO_DEFINITIVA.txt
    exit 0
  }
  else {
    Write-Host "`n❌ App não rodou" -ForegroundColor Red
    $runOutput | Out-File test_lab/results/flutter_run_failed.txt
    exit 1
  }
}
else {
  Write-Host "`n⚠️ Dispositivo uwbekb8hpf6lamts não conectado" -ForegroundColor Yellow
  Write-Host "   Tentando com emulador ou Chrome..." -ForegroundColor Gray
    
  # Tenta com Chrome
  $chromeRun = flutter run -d chrome --no-pub 2>&1
  if ($chromeRun -match "Application finished|Flutter run key commands") {
    Write-Host "`n✅ SUCESSO no Chrome!" -ForegroundColor Green
    "✅ flutter run -d chrome FUNCIONA" | Out-File test_lab/results/SOLUCAO_DEFINITIVA.txt
    exit 0
  }
  else {
    Write-Host "`n❌ Chrome também falhou" -ForegroundColor Red
    exit 1
  }
}
