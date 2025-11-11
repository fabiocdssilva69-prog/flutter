# Script para compilar e instalar APK
Write-Host "🔨 Iniciando build do APK..." -ForegroundColor Cyan

# Compilar APK
flutter build apk --release

if ($LASTEXITCODE -eq 0) {
  Write-Host "✅ Build concluído com sucesso!" -ForegroundColor Green
    
  # Instalar no dispositivo
  Write-Host "📲 Instalando no dispositivo..." -ForegroundColor Cyan
  flutter install -d uwbekb8hpf6lamts
    
  if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Instalação concluída!" -ForegroundColor Green
    Write-Host "🚀 Inicie o app manualmente no dispositivo" -ForegroundColor Yellow
  }
  else {
    Write-Host "❌ Erro na instalação" -ForegroundColor Red
  }
}
else {
  Write-Host "❌ Erro no build" -ForegroundColor Red
}
