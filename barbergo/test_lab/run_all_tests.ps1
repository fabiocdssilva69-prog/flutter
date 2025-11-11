# 🚀 EXECUTOR DE TODOS OS TESTES
# Executa sequencialmente e para no primeiro sucesso

param(
  [switch]$ContinueOnSuccess = $false,
  [int]$StartFrom = 1
)

Write-Host @"
╔══════════════════════════════════════════════════════════╗
║  🧪 LABORATÓRIO DE SOLUÇÕES FREEZED                     ║
║  Testando 1 BILHÃO de possibilidades...                 ║
╚══════════════════════════════════════════════════════════╝
"@ -ForegroundColor Cyan

# Cria pasta de resultados
New-Item -ItemType Directory -Force -Path test_lab/results | Out-Null

$tests = @(
  @{Num = 1; Name = "Implements Manual"; Script = "test_01_implements_manual.ps1" },
  @{Num = 2; Name = "Abstract Mixin Class"; Script = "test_02_abstract_mixin_class.ps1" },
  @{Num = 3; Name = "Base Mixin"; Script = "test_03_base_mixin.ps1" },
  @{Num = 4; Name = "Extension Workaround"; Script = "test_04_extension_workaround.ps1" },
  @{Num = 5; Name = "build.yaml Config"; Script = "test_05_build_yaml_config.ps1" },
  @{Num = 6; Name = "Freezed Versions Cascade"; Script = "test_06_freezed_versions_cascade.ps1" },
  @{Num = 7; Name = "Manual Mixin Constraint"; Script = "test_07_manual_mixin_constraint.ps1" },
  @{Num = 8; Name = "Part Of Workaround"; Script = "test_08_part_of_workaround.ps1" },
  @{Num = 9; Name = "@Freezed() Options"; Script = "test_09_union_key_option.ps1" },
  @{Num = 10; Name = "Analyzer Downgrade"; Script = "test_10_analyzer_downgrade.ps1" }
)

$successCount = 0
$failCount = 0
$startTime = Get-Date

foreach ($test in $tests) {
  if ($test.Num -lt $StartFrom) { continue }
    
  Write-Host "`n" + ("=" * 60) -ForegroundColor DarkGray
  Write-Host "🧪 TESTE $($test.Num): $($test.Name)" -ForegroundColor Cyan
  Write-Host ("=" * 60) -ForegroundColor DarkGray
    
  $testStartTime = Get-Date
    
  # Executa teste
  & "test_lab\$($test.Script)"
  $exitCode = $LASTEXITCODE
    
  $duration = (Get-Date) - $testStartTime
    
  if ($exitCode -eq 0) {
    $successCount++
    Write-Host "`n✅ TESTE $($test.Num) PASSOU! (${duration}s)" -ForegroundColor Green
        
    if (-not $ContinueOnSuccess) {
      Write-Host "`n🎉 SOLUÇÃO ENCONTRADA! Parando testes." -ForegroundColor Green
      break
    }
  }
  else {
    $failCount++
    Write-Host "`n❌ TESTE $($test.Num) FALHOU (${duration}s)" -ForegroundColor Red
  }
    
  # Pequena pausa entre testes
  Start-Sleep -Seconds 2
}

$totalDuration = (Get-Date) - $startTime

Write-Host "`n" + ("=" * 60) -ForegroundColor DarkGray
Write-Host "📊 RESUMO DOS TESTES" -ForegroundColor Cyan
Write-Host ("=" * 60) -ForegroundColor DarkGray
Write-Host "✅ Sucessos: $successCount" -ForegroundColor Green
Write-Host "❌ Falhas: $failCount" -ForegroundColor Red
Write-Host "⏱️ Tempo total: $($totalDuration.TotalSeconds)s" -ForegroundColor Yellow
Write-Host ""

if ($successCount -gt 0) {
  Write-Host "🎯 SOLUÇÕES ENCONTRADAS! Veja test_lab/results/" -ForegroundColor Green
  Get-ChildItem test_lab/results/*_success.txt | ForEach-Object {
    Write-Host "   📄 $($_.Name): $(Get-Content $_.FullName)" -ForegroundColor Yellow
  }
  exit 0
}
else {
  Write-Host "😔 Nenhuma solução automática encontrada." -ForegroundColor Red
  Write-Host "📋 Próximos passos:" -ForegroundColor Yellow
  Write-Host "   1. Revisar logs em test_lab/results/" -ForegroundColor Gray
  Write-Host "   2. Considerar migração para dart_mappable" -ForegroundColor Gray
  Write-Host "   3. Reportar bug oficial ao Freezed" -ForegroundColor Gray
  exit 1
}
