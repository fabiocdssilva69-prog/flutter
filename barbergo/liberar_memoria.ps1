# Script para Liberar Memória e Otimizar Sistema
# BarberGO Project - Memory Optimization Script

Write-Host "`n===========================================================" -ForegroundColor Cyan
Write-Host "🧹 LIBERANDO MEMÓRIA DO SISTEMA" -ForegroundColor Yellow
Write-Host "===========================================================" -ForegroundColor Cyan

# Função para mostrar uso de memória
function Show-MemoryUsage {
  $computerInfo = Get-ComputerInfo
  $totalGB = [math]::Round($computerInfo.CsTotalPhysicalMemory / 1GB, 2)
  $freeGB = [math]::Round($computerInfo.CsFreePhysicalMemory / 1GB, 2)
  $usedGB = [math]::Round(($computerInfo.CsTotalPhysicalMemory - $computerInfo.CsFreePhysicalMemory) / 1GB, 2)
  $usedPercent = [math]::Round((($computerInfo.CsTotalPhysicalMemory - $computerInfo.CsFreePhysicalMemory) / $computerInfo.CsTotalPhysicalMemory) * 100, 1)
    
  Write-Host "`n📊 Uso de Memória:" -ForegroundColor Cyan
  Write-Host "  Total: $totalGB GB" -ForegroundColor White
  Write-Host "  Em Uso: $usedGB GB ($usedPercent%)" -ForegroundColor $(if ($usedPercent -gt 90) { "Red" } elseif ($usedPercent -gt 75) { "Yellow" } else { "Green" })
  Write-Host "  Livre: $freeGB GB" -ForegroundColor $(if ($freeGB -lt 2) { "Red" } elseif ($freeGB -lt 4) { "Yellow" } else { "Green" })
}

Write-Host "`n📊 ANTES da limpeza:" -ForegroundColor Yellow
Show-MemoryUsage

# 1. Fechar emulador Android (maior consumidor)
Write-Host "`n1️⃣ Encerrando emulador Android..." -ForegroundColor Cyan
$emulatorProcesses = Get-Process | Where-Object { $_.ProcessName -like "*qemu*" -or $_.ProcessName -like "*emulator*" }
if ($emulatorProcesses) {
  foreach ($proc in $emulatorProcesses) {
    Write-Host "  ❌ Encerrando: $($proc.ProcessName) (PID: $($proc.Id), RAM: $([math]::Round($proc.WorkingSet64/1MB,0)) MB)" -ForegroundColor Yellow
    Stop-Process -Id $proc.Id -Force -ErrorAction SilentlyContinue
  }
  Start-Sleep -Seconds 2
  Write-Host "  ✅ Emulador encerrado" -ForegroundColor Green
}
else {
  Write-Host "  ℹ️  Nenhum emulador rodando" -ForegroundColor Gray
}

# 2. Limpar processos ADB desnecessários
Write-Host "`n2️⃣ Limpando processos ADB..." -ForegroundColor Cyan
$adbProcesses = Get-Process -Name "adb" -ErrorAction SilentlyContinue
if ($adbProcesses -and $adbProcesses.Count -gt 1) {
  Write-Host "  🔄 Reiniciando ADB (remover múltiplas instâncias)..." -ForegroundColor Yellow
  $env:ANDROID_HOME = "$env:LOCALAPPDATA\Android\Sdk"
  $adb = "$env:ANDROID_HOME\platform-tools\adb.exe"
  if (Test-Path $adb) {
    & $adb kill-server | Out-Null
    Start-Sleep -Seconds 1
    Write-Host "  ✅ ADB limpo" -ForegroundColor Green
  }
}
else {
  Write-Host "  ✅ ADB OK" -ForegroundColor Green
}

# 3. Fechar Gradle daemons (Java)
Write-Host "`n3️⃣ Encerrando Gradle daemons..." -ForegroundColor Cyan
$gradleProcesses = Get-Process -Name "java" -ErrorAction SilentlyContinue | Where-Object {
  $_.MainWindowTitle -like "*gradle*" -or $_.Path -like "*gradle*"
}
if ($gradleProcesses) {
  foreach ($proc in $gradleProcesses) {
    Write-Host "  ❌ Encerrando Gradle daemon (PID: $($proc.Id), RAM: $([math]::Round($proc.WorkingSet64/1MB,0)) MB)" -ForegroundColor Yellow
    Stop-Process -Id $proc.Id -Force -ErrorAction SilentlyContinue
  }
  Write-Host "  ✅ Gradle daemons encerrados" -ForegroundColor Green
}
else {
  Write-Host "  ℹ️  Nenhum Gradle daemon rodando" -ForegroundColor Gray
}

# 4. Limpar cache de builds do Flutter
Write-Host "`n4️⃣ Limpando cache do Flutter..." -ForegroundColor Cyan
$buildDir = ".\build"
if (Test-Path $buildDir) {
  Write-Host "  🗑️  Removendo pasta build/..." -ForegroundColor Yellow
  Remove-Item -Path $buildDir -Recurse -Force -ErrorAction SilentlyContinue
  Write-Host "  ✅ Cache de build limpo" -ForegroundColor Green
}
else {
  Write-Host "  ℹ️  Nenhum cache para limpar" -ForegroundColor Gray
}

# 5. Sugerir fechar aplicações pesadas
Write-Host "`n5️⃣ Verificando outras aplicações pesadas..." -ForegroundColor Cyan
$heavyApps = Get-Process | Where-Object {
  $_.ProcessName -in @("chrome", "msedge", "Code", "devenv", "firefox", "slack", "teams", "discord") -and
  $_.WorkingSet64 -gt 200MB
} | Select-Object ProcessName, @{Name = "RAM(MB)"; Expression = { [math]::Round($_.WorkingSet64 / 1MB, 0) } } | 
Group-Object ProcessName | 
ForEach-Object {
  [PSCustomObject]@{
    App       = $_.Name
    Instances = $_.Count
    TotalRAM  = ($_.Group | Measure-Object -Property "RAM(MB)" -Sum).Sum
  }
} | Sort-Object TotalRAM -Descending

if ($heavyApps) {
  Write-Host "`n  ⚠️  Aplicações consumindo muita memória:" -ForegroundColor Yellow
  foreach ($app in $heavyApps) {
    $color = if ($app.TotalRAM -gt 1000) { "Red" } elseif ($app.TotalRAM -gt 500) { "Yellow" } else { "White" }
    Write-Host "    • $($app.App): $($app.TotalRAM) MB ($($app.Instances) instância(s))" -ForegroundColor $color
  }
    
  Write-Host "`n  💡 RECOMENDAÇÕES:" -ForegroundColor Cyan
  Write-Host "    • Feche navegadores com muitas abas abertas" -ForegroundColor White
  Write-Host "    • Feche IDEs/editores não utilizados" -ForegroundColor White
  Write-Host "    • Feche aplicativos de comunicação (Teams, Slack, Discord)" -ForegroundColor White
}
else {
  Write-Host "  ✅ Nenhuma aplicação pesada detectada" -ForegroundColor Green
}

# 6. Limpar arquivos temporários do sistema (requer admin)
Write-Host "`n6️⃣ Limpando arquivos temporários..." -ForegroundColor Cyan
$tempDirs = @($env:TEMP, "$env:LOCALAPPDATA\Temp")
$totalFreed = 0

foreach ($tempDir in $tempDirs) {
  if (Test-Path $tempDir) {
    try {
      $beforeSize = (Get-ChildItem -Path $tempDir -Recurse -File -ErrorAction SilentlyContinue | 
        Measure-Object -Property Length -Sum).Sum / 1MB
            
      Get-ChildItem -Path $tempDir -Recurse -File -ErrorAction SilentlyContinue | 
      Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-7) } | 
      Remove-Item -Force -ErrorAction SilentlyContinue
            
      $afterSize = (Get-ChildItem -Path $tempDir -Recurse -File -ErrorAction SilentlyContinue | 
        Measure-Object -Property Length -Sum).Sum / 1MB
            
      $freed = [math]::Round($beforeSize - $afterSize, 2)
      $totalFreed += $freed
    }
    catch {
      # Ignorar erros de permissão
    }
  }
}

if ($totalFreed -gt 0) {
  Write-Host "  ✅ $totalFreed MB de arquivos temporários removidos" -ForegroundColor Green
}
else {
  Write-Host "  ℹ️  Poucos arquivos temporários para remover" -ForegroundColor Gray
}

# 7. Forçar garbage collection do .NET (libera memória do PowerShell)
Write-Host "`n7️⃣ Forçando garbage collection..." -ForegroundColor Cyan
[System.GC]::Collect()
[System.GC]::WaitForPendingFinalizers()
[System.GC]::Collect()
Write-Host "  ✅ Garbage collection executado" -ForegroundColor Green

# Aguardar sistema estabilizar
Write-Host "`n⏳ Aguardando sistema estabilizar..." -ForegroundColor Cyan
Start-Sleep -Seconds 3

# Mostrar uso de memória após limpeza
Write-Host "`n📊 DEPOIS da limpeza:" -ForegroundColor Green
Show-MemoryUsage

# Calcular quanto foi liberado
$afterInfo = Get-ComputerInfo
$afterFreeGB = [math]::Round($afterInfo.CsFreePhysicalMemory / 1GB, 2)

Write-Host "`n===========================================================" -ForegroundColor Cyan
Write-Host "✅ LIMPEZA CONCLUÍDA!" -ForegroundColor Green
Write-Host "===========================================================" -ForegroundColor Cyan

# Recomendações finais baseadas na memória livre
$freeGB = [math]::Round($afterInfo.CsFreePhysicalMemory / 1GB, 2)
Write-Host "`n💡 PRÓXIMOS PASSOS:" -ForegroundColor Cyan

if ($freeGB -lt 4) {
  Write-Host "`n⚠️  ATENÇÃO: Memória ainda MUITO BAIXA ($freeGB GB livre)" -ForegroundColor Red
  Write-Host "`nACÕES URGENTES:" -ForegroundColor Yellow
  Write-Host "  1. ❌ Feche TODOS os navegadores" -ForegroundColor Red
  Write-Host "  2. ❌ Feche aplicações não essenciais" -ForegroundColor Red
  Write-Host "  3. 🔄 Considere REINICIAR o computador" -ForegroundColor Yellow
  Write-Host "  4. 🚫 NÃO use o emulador Android (use Web)" -ForegroundColor Red
  Write-Host "  5. 💾 Considere adicionar mais RAM (mínimo 32GB recomendado)" -ForegroundColor Yellow
  Write-Host "`n  Para testar: Use apenas .\run_web_tests.ps1" -ForegroundColor Cyan
}
elseif ($freeGB -lt 6) {
  Write-Host "`n⚠️  Memória BAIXA ($freeGB GB livre)" -ForegroundColor Yellow
  Write-Host "`nRECOMENDAÇÕES:" -ForegroundColor Yellow
  Write-Host "  1. ✅ Pode usar testes web normalmente" -ForegroundColor Green
  Write-Host "  2. ⚠️  Emulador Android pode ser lento" -ForegroundColor Yellow
  Write-Host "  3. 💡 Feche aplicações não essenciais antes de usar emulador" -ForegroundColor White
  Write-Host "  4. 🔄 Considere reiniciar se o sistema ficar lento" -ForegroundColor White
}
else {
  Write-Host "`n✅ Memória OK ($freeGB GB livre)" -ForegroundColor Green
  Write-Host "`nVocê pode:" -ForegroundColor Cyan
  Write-Host "  • ✅ Usar testes web (.\run_web_tests.ps1)" -ForegroundColor Green
  Write-Host "  • ✅ Usar emulador Android (.\run_android_tests.ps1)" -ForegroundColor Green
  Write-Host "  • ✅ Desenvolver normalmente" -ForegroundColor Green
}

Write-Host "`n===========================================================" -ForegroundColor Cyan
Write-Host ""
