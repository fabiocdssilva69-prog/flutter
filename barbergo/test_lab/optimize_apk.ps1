# Otimizador de APK
Write-Host "📦 Construindo APK otimizado..." -ForegroundColor Cyan

# Build com split per ABI (reduz tamanho)
flutter build apk --split-per-abi --target-platform android-arm64

# Build com obfuscação
flutter build apk --obfuscate --split-debug-info=debug-symbols/

# Analisar tamanho
if (Test-Path "build/app/outputs/flutter-apk/") {
    $apks = Get-ChildItem "build/app/outputs/flutter-apk/*.apk"
    foreach ($apk in $apks) {
        $sizeMB = [math]::Round($apk.Length / 1MB, 2)
        $color = if ($sizeMB -lt 30) { "Green" } elseif ($sizeMB -lt 50) { "Yellow" } else { "Red" }
        Write-Host "  📱 $($apk.Name): ${sizeMB}MB" -ForegroundColor $color
    }
}

Write-Host "`n💡 Dicas adicionais:" -ForegroundColor Cyan
Write-Host "  - Otimizar imagens (WebP, compressão)" -ForegroundColor Gray
Write-Host "  - Remover assets não usados" -ForegroundColor Gray
Write-Host "  - Usar font subsetting" -ForegroundColor Gray
