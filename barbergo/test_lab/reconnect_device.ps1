# 📱 GUIA DE RECONEXÃO DO DEVICE
# ============================================================================
# Ajuda a reconectar o Redmi Note 8 Pro ao computador
# ============================================================================

Write-Host "`n╔═══════════════════════════════════════════════════════════╗" -ForegroundColor Yellow
Write-Host "║                                                           ║" -ForegroundColor Yellow
Write-Host "║        📱 GUIA PARA RECONECTAR DEVICE 📱                 ║" -ForegroundColor Yellow
Write-Host "║                                                           ║" -ForegroundColor Yellow
Write-Host "╚═══════════════════════════════════════════════════════════╝" -ForegroundColor Yellow

Write-Host "`n⚠️  O device Redmi Note 8 Pro foi desconectado!" -ForegroundColor Red
Write-Host "=" * 70

Write-Host "`n📋 SIGA ESTES PASSOS PARA RECONECTAR:" -ForegroundColor Cyan
Write-Host "`n1️⃣  NO CELULAR:" -ForegroundColor Yellow
Write-Host "   a) Vá em Configurações > Opções do desenvolvedor" -ForegroundColor Gray
Write-Host "   b) Verifique se 'Depuração USB' está ATIVO" -ForegroundColor Gray
Write-Host "   c) Se aparecer popup 'Permitir depuração USB?', clique SIM" -ForegroundColor Gray

Write-Host "`n2️⃣  NO COMPUTADOR:" -ForegroundColor Yellow
Write-Host "   a) Desconecte o cabo USB" -ForegroundColor Gray
Write-Host "   b) Aguarde 5 segundos" -ForegroundColor Gray
Write-Host "   c) Conecte o cabo USB novamente" -ForegroundColor Gray

Write-Host "`n3️⃣  REINICIAR ADB (se necessário):" -ForegroundColor Yellow
Write-Host "   Execute este comando:" -ForegroundColor Gray
Write-Host "   adb kill-server && adb start-server" -ForegroundColor Cyan

Write-Host "`n🔍 Tentando reiniciar ADB automaticamente..." -ForegroundColor Cyan
try {
  adb kill-server 2>&1 | Out-Null
  Start-Sleep -Seconds 2
  adb start-server 2>&1 | Out-Null
  Write-Host "✅ ADB reiniciado com sucesso!" -ForegroundColor Green
}
catch {
  Write-Host "❌ Erro ao reiniciar ADB" -ForegroundColor Red
}

Write-Host "`n🔍 Verificando devices conectados..." -ForegroundColor Cyan
Start-Sleep -Seconds 3

$devices = flutter devices | Out-String
if ($devices -match "Redmi Note 8 Pro") {
  Write-Host "`n✅✅✅ DEVICE RECONECTADO COM SUCESSO! ✅✅✅" -ForegroundColor Green
  Write-Host "Device: Redmi Note 8 Pro (uwbekb8hpf6lamts)" -ForegroundColor Cyan
  Write-Host "`n🚀 Agora você pode executar:" -ForegroundColor Yellow
  Write-Host "   flutter run -d uwbekb8hpf6lamts" -ForegroundColor Cyan
}
else {
  Write-Host "`n⚠️  Device ainda não conectado" -ForegroundColor Yellow
  Write-Host "`nDevices disponíveis:" -ForegroundColor Cyan
  flutter devices
    
  Write-Host "`n💡 DICAS ADICIONAIS:" -ForegroundColor Yellow
  Write-Host "   • Tente outro cabo USB" -ForegroundColor Gray
  Write-Host "   • Tente outra porta USB do computador" -ForegroundColor Gray
  Write-Host "   • Reinicie o celular" -ForegroundColor Gray
  Write-Host "   • Desative e reative 'Depuração USB'" -ForegroundColor Gray
  Write-Host "   • Verifique se os drivers USB estão instalados" -ForegroundColor Gray
}

Write-Host "`n" -NoNewline
Write-Host ("=" * 70) -ForegroundColor Yellow

exit 0
