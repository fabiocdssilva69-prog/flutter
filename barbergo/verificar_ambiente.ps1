# 🔧 Script de Otimização e Verificação - BarberGO Dev Environment
# Execute este script APÓS reiniciar a máquina

Write-Host "🚀 Iniciando verificação do ambiente de desenvolvimento BarberGO..." -ForegroundColor Cyan
Write-Host ""

# ============================================
# FASE 1: Limpeza e Otimização
# ============================================

Write-Host "📦 FASE 1: Limpeza de Cache e Arquivos Temporários" -ForegroundColor Yellow
Write-Host "=================================================" -ForegroundColor Yellow
Write-Host ""

# Limpar cache do Flutter
Write-Host "🧹 Limpando cache do Flutter..." -ForegroundColor Green
Set-Location "c:\workspaces\fabiocdssilva69-prog\barbergo"
flutter clean
Write-Host "✅ Cache do Flutter limpo" -ForegroundColor Green
Write-Host ""

# Limpar pasta build
Write-Host "🧹 Removendo pasta build antiga..." -ForegroundColor Green
if (Test-Path "build") {
  Remove-Item -Path "build" -Recurse -Force
  Write-Host "✅ Pasta build removida" -ForegroundColor Green
}
else {
  Write-Host "⚠️  Pasta build não encontrada" -ForegroundColor Yellow
}
Write-Host ""

# ============================================
# FASE 2: Verificação do Flutter
# ============================================

Write-Host "🔍 FASE 2: Verificação do Flutter e Dependências" -ForegroundColor Yellow
Write-Host "=================================================" -ForegroundColor Yellow
Write-Host ""

# Flutter Doctor
Write-Host "🏥 Executando Flutter Doctor..." -ForegroundColor Green
flutter doctor -v
Write-Host ""

# Versão do Flutter
Write-Host "📱 Versão do Flutter:" -ForegroundColor Green
flutter --version
Write-Host ""

# ============================================
# FASE 3: Verificação de Dispositivos
# ============================================

Write-Host "📱 FASE 3: Dispositivos Disponíveis" -ForegroundColor Yellow
Write-Host "=================================================" -ForegroundColor Yellow
Write-Host ""

# Listar dispositivos conectados
Write-Host "🔌 Dispositivos conectados:" -ForegroundColor Green
flutter devices
Write-Host ""

# Listar emuladores disponíveis
Write-Host "📲 Emuladores disponíveis:" -ForegroundColor Green
flutter emulators
Write-Host ""

# ============================================
# FASE 4: Dependências do Projeto
# ============================================

Write-Host "📦 FASE 4: Atualizando Dependências do Projeto" -ForegroundColor Yellow
Write-Host "=================================================" -ForegroundColor Yellow
Write-Host ""

# Atualizar dependências
Write-Host "📥 Baixando dependências..." -ForegroundColor Green
flutter pub get
Write-Host ""

# Verificar dependências desatualizadas
Write-Host "🔄 Verificando dependências desatualizadas:" -ForegroundColor Green
flutter pub outdated
Write-Host ""

# ============================================
# FASE 5: Executar Testes
# ============================================

Write-Host "🧪 FASE 5: Executando Testes Unitários" -ForegroundColor Yellow
Write-Host "=================================================" -ForegroundColor Yellow
Write-Host ""

Write-Host "🧪 Rodando testes unitários do AuthController..." -ForegroundColor Green
flutter test test/auth_controller_test.dart --reporter=expanded
Write-Host ""

# ============================================
# FASE 6: Verificação Firebase
# ============================================

Write-Host "🔥 FASE 6: Verificação Firebase CLI" -ForegroundColor Yellow
Write-Host "=================================================" -ForegroundColor Yellow
Write-Host ""

# Verificar se Firebase CLI está instalado
Write-Host "🔍 Verificando Firebase CLI..." -ForegroundColor Green
try {
  firebase --version
  Write-Host "✅ Firebase CLI instalado" -ForegroundColor Green
}
catch {
  Write-Host "❌ Firebase CLI não instalado" -ForegroundColor Red
  Write-Host "📝 Para instalar: npm install -g firebase-tools" -ForegroundColor Yellow
}
Write-Host ""

# Verificar se FlutterFire CLI está instalado
Write-Host "🔍 Verificando FlutterFire CLI..." -ForegroundColor Green
try {
  flutterfire --version
  Write-Host "✅ FlutterFire CLI instalado" -ForegroundColor Green
}
catch {
  Write-Host "❌ FlutterFire CLI não instalado" -ForegroundColor Red
  Write-Host "📝 Para instalar: dart pub global activate flutterfire_cli" -ForegroundColor Yellow
}
Write-Host ""

# ============================================
# FASE 7: Informações do Sistema
# ============================================

Write-Host "💻 FASE 7: Informações do Sistema" -ForegroundColor Yellow
Write-Host "=================================================" -ForegroundColor Yellow
Write-Host ""

# Memória disponível
Write-Host "🧠 Memória do Sistema:" -ForegroundColor Green
Get-CimInstance Win32_OperatingSystem | Select-Object TotalVisibleMemorySize, FreePhysicalMemory | Format-List
Write-Host ""

# Espaço em disco
Write-Host "💾 Espaço em Disco:" -ForegroundColor Green
Get-PSDrive C | Select-Object Used, Free | Format-List
Write-Host ""

# ============================================
# RESUMO FINAL
# ============================================

Write-Host "📊 RESUMO DA VERIFICAÇÃO" -ForegroundColor Cyan
Write-Host "=================================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "✅ Verificação concluída!" -ForegroundColor Green
Write-Host ""
Write-Host "📝 PRÓXIMOS PASSOS:" -ForegroundColor Yellow
Write-Host "1. Verificar saída do 'flutter doctor' acima" -ForegroundColor White
Write-Host "2. Configurar Android Emulator se necessário" -ForegroundColor White
Write-Host "3. Executar testes de integração com: flutter drive --driver=test_driver/integration_driver.dart --target=integration_test/auth_integration_test.dart -d <device>" -ForegroundColor White
Write-Host "4. Consultar PLANO_AMBIENTE_TESTES_E_FIREBASE.md para roadmap completo" -ForegroundColor White
Write-Host ""

Write-Host "🚀 Ambiente pronto para desenvolvimento!" -ForegroundColor Cyan
Write-Host ""
