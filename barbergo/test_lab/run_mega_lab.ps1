# 🔬 MEGA LABORATÓRIO - Executor Master
# Executa TODOS os 50 testes e gera relatório comparativo

param(
  [int]$StartFrom = 20,
  [int]$EndAt = 50,
  [switch]$FastMode,  # Pula testes lentos
  [switch]$OnlyPriority  # Apenas testes prioritários
)

Write-Host @"
╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║       🔬 MEGA LABORATÓRIO - 1 BILHÃO DE TESTES 🔬           ║
║                                                              ║
║      Testando TODAS as soluções para Freezed 3.2.x          ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝
"@ -ForegroundColor Cyan

$masterStart = Get-Date

# Definir todos os testes disponíveis
$allTests = @(
  # FASE 2: Freezed Variations (20-25)
  @{ id = 20; name = "Freezed Master (Git)"; priority = "HIGH"; time = "MEDIUM"; script = "test_20_freezed_master.ps1" },
  @{ id = 21; name = "Freezed 2.5.7 (Antiga)"; priority = "LOW"; time = "FAST"; script = "test_21_freezed_old.ps1" },
  @{ id = 22; name = "Freezed Fork Patch"; priority = "MEDIUM"; time = "SLOW"; script = "test_22_freezed_fork.ps1" },
  @{ id = 23; name = "sealed_class Alternative"; priority = "LOW"; time = "FAST"; script = "test_23_sealed_class.ps1" },
  @{ id = 24; name = "superenum Alternative"; priority = "LOW"; time = "FAST"; script = "test_24_superenum.ps1" },
  @{ id = 25; name = "Freezed + Patch Script"; priority = "MEDIUM"; time = "MEDIUM"; script = "test_25_freezed_autopatch.ps1" },
    
  # FASE 3: built_value (26-30)
  @{ id = 26; name = "built_value - 1 Entity"; priority = "HIGH"; time = "MEDIUM"; script = "test_26_built_value_single.ps1" },
  @{ id = 27; name = "built_value - 3 Entities"; priority = "HIGH"; time = "MEDIUM"; script = "test_27_built_value_three.ps1" },
  @{ id = 28; name = "built_value - All 7 Entities"; priority = "MEDIUM"; time = "SLOW"; script = "test_28_built_value_all.ps1" },
  @{ id = 29; name = "built_value + Firebase"; priority = "MEDIUM"; time = "MEDIUM"; script = "test_29_built_value_firebase.ps1" },
  @{ id = 30; name = "built_value + Riverpod"; priority = "HIGH"; time = "MEDIUM"; script = "test_30_built_value_riverpod.ps1" },
    
  # FASE 4: json_serializable Pure (31-35)
  @{ id = 31; name = "json_serializable Pure"; priority = "HIGH"; time = "FAST"; script = "test_31_json_pure.ps1" },
  @{ id = 32; name = "json + Auto copyWith"; priority = "MEDIUM"; time = "MEDIUM"; script = "test_32_json_auto_copy.ps1" },
  @{ id = 33; name = "json - All 7 Entities"; priority = "MEDIUM"; time = "MEDIUM"; script = "test_33_json_all.ps1" },
  @{ id = 34; name = "json + equatable"; priority = "LOW"; time = "FAST"; script = "test_34_json_equatable.ps1" },
  @{ id = 35; name = "json + meta"; priority = "LOW"; time = "FAST"; script = "test_35_json_meta.ps1" },
    
  # FASE 5: Hybrid Solutions (36-40)
  @{ id = 36; name = "Freezed + built_value Mix"; priority = "MEDIUM"; time = "SLOW"; script = "test_36_hybrid_freezed_built.ps1" },
  @{ id = 37; name = "json + Freezed Mix"; priority = "LOW"; time = "MEDIUM"; script = "test_37_hybrid_json_freezed.ps1" },
  @{ id = 38; name = "data_class_plugin"; priority = "LOW"; time = "MEDIUM"; script = "test_38_data_class.ps1" },
  @{ id = 39; name = "Custom Generator"; priority = "LOW"; time = "SLOW"; script = "test_39_custom_gen.ps1" },
  @{ id = 40; name = "Dart Macros (Experimental)"; priority = "LOW"; time = "SLOW"; script = "test_40_macros.ps1" },
    
  # FASE 6: Environment (41-45)
  @{ id = 41; name = "Flutter 3.24.x"; priority = "LOW"; time = "VERY_SLOW"; script = "test_41_flutter_old.ps1" },
  @{ id = 42; name = "Dart 3.5.x"; priority = "LOW"; time = "VERY_SLOW"; script = "test_42_dart_old.ps1" },
  @{ id = 43; name = "Fresh Project"; priority = "MEDIUM"; time = "SLOW"; script = "test_43_fresh_project.ps1" },
  @{ id = 44; name = "Docker Build"; priority = "LOW"; time = "VERY_SLOW"; script = "test_44_docker.ps1" },
  @{ id = 45; name = "CI/CD Simulation"; priority = "LOW"; time = "SLOW"; script = "test_45_ci_cd.ps1" },
    
  # FASE 7: Advanced (46-50)
  @{ id = 46; name = "AST Manipulation"; priority = "LOW"; time = "SLOW"; script = "test_46_ast.ps1" },
  @{ id = 47; name = "Custom Analyzer Plugin"; priority = "LOW"; time = "VERY_SLOW"; script = "test_47_analyzer_plugin.ps1" },
  @{ id = 48; name = "JIT Tricks"; priority = "LOW"; time = "MEDIUM"; script = "test_48_jit.ps1" },
  @{ id = 49; name = "Reflection Serialization"; priority = "LOW"; time = "MEDIUM"; script = "test_49_reflection.ps1" },
  @{ id = 50; name = "Manual .freezed.dart"; priority = "LOW"; time = "FAST"; script = "test_50_manual_freezed.ps1" }
)

# Filtrar testes
$testsToRun = $allTests | Where-Object { 
  $_.id -ge $StartFrom -and $_.id -le $EndAt
}

if ($OnlyPriority) {
  $testsToRun = $testsToRun | Where-Object { $_.priority -eq "HIGH" }
  Write-Host "🎯 Modo APENAS PRIORITÁRIOS ativado" -ForegroundColor Yellow
}

if ($FastMode) {
  $testsToRun = $testsToRun | Where-Object { $_.time -ne "VERY_SLOW" }
  Write-Host "⚡ Modo RÁPIDO ativado (pulando testes lentos)" -ForegroundColor Yellow
}

Write-Host "`n📊 Total de testes a executar: $($testsToRun.Count)" -ForegroundColor Cyan
Write-Host "=" * 70

$results = @()
$successCount = 0

foreach ($test in $testsToRun) {
  Write-Host "`n" + ("=" * 70) -ForegroundColor Cyan
  Write-Host "🧪 TESTE $($test.id): $($test.name)" -ForegroundColor White
  Write-Host "⏱️ Tempo estimado: $($test.time) | Prioridade: $($test.priority)" -ForegroundColor Gray
  Write-Host ("=" * 70) -ForegroundColor Cyan
    
  $scriptPath = "test_lab/$($test.script)"
    
  if (-not (Test-Path $scriptPath)) {
    Write-Host "⚠️ Script não encontrado: $scriptPath" -ForegroundColor Yellow
    Write-Host "📝 Criando stub..." -ForegroundColor Gray
        
    # Criar stub básico
    $stub = @"
# STUB - Teste $($test.id): $($test.name)
Write-Host "⚠️ Teste $($test.id) ainda não implementado" -ForegroundColor Yellow
exit 1
"@
    Set-Content $scriptPath $stub
  }
    
  # Executar teste
  $testStart = Get-Date
  & $scriptPath
  $exitCode = $LASTEXITCODE
  $testDuration = ((Get-Date) - $testStart).TotalSeconds
    
  # Ler resultado (se existir JSON)
  $resultFile = "test_lab/results/test_$($test.id)_result.json"
  $testResult = if (Test-Path $resultFile) {
    Get-Content $resultFile | ConvertFrom-Json
  }
  else {
    @{
      test     = $test.id
      name     = $test.name
      score    = if ($exitCode -eq 0) { 50 } else { 0 }
      success  = ($exitCode -eq 0)
      duration = $testDuration
    }
  }
    
  $results += $testResult
    
  if ($testResult.success) {
    $successCount++
    Write-Host "`n✅ SUCESSO! Pontuação: $($testResult.score)" -ForegroundColor Green
  }
  else {
    Write-Host "`n❌ FALHOU. Pontuação: $($testResult.score)" -ForegroundColor Red
  }
    
  Write-Host "⏱️ Duração: $([math]::Round($testDuration, 1))s" -ForegroundColor Cyan
    
  # Pequena pausa entre testes
  Start-Sleep -Milliseconds 500
}

$masterDuration = ((Get-Date) - $masterStart).TotalSeconds

# RELATÓRIO FINAL
Write-Host "`n`n"
Write-Host @"
╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║              📊 RELATÓRIO FINAL DO LABORATÓRIO               ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝
"@ -ForegroundColor Green

Write-Host "`n📈 ESTATÍSTICAS GERAIS" -ForegroundColor Cyan
Write-Host "=" * 70
Write-Host "Total de testes executados: $($results.Count)" -ForegroundColor White
Write-Host "✅ Sucessos: $successCount" -ForegroundColor Green
Write-Host "❌ Falhas: $($results.Count - $successCount)" -ForegroundColor Red
Write-Host "📊 Taxa de sucesso: $([math]::Round(($successCount / $results.Count) * 100, 1))%" -ForegroundColor Cyan
Write-Host "⏱️ Tempo total: $([math]::Round($masterDuration / 60, 1)) minutos" -ForegroundColor Yellow

# TOP 5 SOLUÇÕES
Write-Host "`n🏆 TOP 5 MELHORES SOLUÇÕES" -ForegroundColor Green
Write-Host "=" * 70

$top5 = $results | Sort-Object -Property score -Descending | Select-Object -First 5

$rank = 1
foreach ($solution in $top5) {
  $medal = switch ($rank) {
    1 { "🥇" }
    2 { "🥈" }
    3 { "🥉" }
    default { "  " }
  }
    
  Write-Host "$medal #$rank - Teste $($solution.test): $($solution.name)" -ForegroundColor $(
    if ($solution.score -ge 90) { "Green" }
    elseif ($solution.score -ge 70) { "Yellow" }
    else { "Red" }
  )
  Write-Host "     Pontuação: $($solution.score) | Duração: $([math]::Round($solution.duration, 1))s" -ForegroundColor Gray
    
  $rank++
}

# RECOMENDAÇÃO FINAL
Write-Host "`n🎯 RECOMENDAÇÃO FINAL" -ForegroundColor Cyan
Write-Host "=" * 70

$best = $top5 | Select-Object -First 1

if ($best.score -ge 90) {
  Write-Host "✅ SOLUÇÃO ENCONTRADA!" -ForegroundColor Green
  Write-Host "🏆 Vencedor: Teste $($best.test) - $($best.name)" -ForegroundColor Green
  Write-Host "📊 Pontuação: $($best.score)" -ForegroundColor Cyan
  Write-Host "`n📋 Próximo passo: Implementar solução vencedora no projeto" -ForegroundColor Yellow
}
elseif ($best.score -ge 70) {
  Write-Host "⚠️ Solução viável encontrada" -ForegroundColor Yellow
  Write-Host "🥇 Melhor opção: Teste $($best.test) - $($best.name)" -ForegroundColor Yellow
  Write-Host "📊 Pontuação: $($best.score)" -ForegroundColor Cyan
  Write-Host "`n📋 Próximo passo: Testar no device real antes de implementar" -ForegroundColor Yellow
}
else {
  Write-Host "❌ Nenhuma solução ideal encontrada" -ForegroundColor Red
  Write-Host "📋 Recomendação: Executar mais testes ou aguardar Freezed 3.3.0" -ForegroundColor Yellow
}

# Salvar relatório completo
$report = @{
  timestamp        = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
  total_tests      = $results.Count
  successes        = $successCount
  failures         = $results.Count - $successCount
  success_rate     = [math]::Round(($successCount / $results.Count) * 100, 1)
  duration_minutes = [math]::Round($masterDuration / 60, 1)
  top_solution     = $best
  all_results      = $results
}

$reportPath = "test_lab/results/MEGA_LAB_REPORT_$(Get-Date -Format 'yyyyMMdd_HHmmss').json"
$report | ConvertTo-Json -Depth 10 | Set-Content $reportPath

Write-Host "`n💾 Relatório salvo: $reportPath" -ForegroundColor Cyan
Write-Host "`n✅ Laboratório concluído!" -ForegroundColor Green
