# ============================================================================
# 🚀 APLICAR TESTE 31 (json_serializable puro) EM TODAS AS 6 ENTIDADES
# ============================================================================

$ErrorActionPreference = "Continue"
$startTime = Get-Date

Write-Host "`n🎯 MIGRAÇÃO EM MASSA - Teste 31 para 6 entidades" -ForegroundColor Cyan
Write-Host "=" * 70 -ForegroundColor Cyan

# Entidades para migrar (user_interaction_entity já foi migrada)
$entities = @(
  @{
    Name   = "profile_entity"
    File   = "lib/src/domain/entities/profile_entity.dart"
    Fields = 11
  },
  @{
    Name   = "vacancy_entity"
    File   = "lib/src/domain/entities/vacancy_entity.dart"
    Fields = 14
  },
  @{
    Name   = "application_entity"
    File   = "lib/src/domain/entities/application_entity.dart"
    Fields = 9
  },
  @{
    Name   = "notification_entity"
    File   = "lib/src/domain/entities/notification_entity.dart"
    Fields = 8
  },
  @{
    Name   = "chat_message"
    File   = "lib/src/features/chat/models/chat_message.dart"
    Fields = 7
  },
  @{
    Name   = "chat_state"
    File   = "lib/src/features/chat/models/chat_state.dart"
    Fields = 3
  }
)

$totalScore = 0
$successCount = 0
$failCount = 0
$results = @()

foreach ($entity in $entities) {
  Write-Host "`n" -NoNewline
  Write-Host ("=" * 70) -ForegroundColor Yellow
  Write-Host "🧪 Migrando: $($entity.Name) ($($entity.Fields) campos)" -ForegroundColor Yellow
  Write-Host ("=" * 70) -ForegroundColor Yellow
    
  $entityStartTime = Get-Date
  $entityFile = $entity.File
    
  # Verificar se arquivo existe
  if (-not (Test-Path $entityFile)) {
    Write-Host "❌ Arquivo não encontrado: $entityFile" -ForegroundColor Red
    $failCount++
    continue
  }
    
  # 1. BACKUP
  Write-Host "`n💾 Backup $($entity.Name)..." -NoNewline
  $backupFile = "$entityFile.test31_migration_backup"
  Copy-Item $entityFile $backupFile -Force
  Write-Host " ✅" -ForegroundColor Green
    
  # 2. LER ARQUIVO ORIGINAL
  $originalContent = Get-Content $entityFile -Raw
    
  # 3. DETECTAR ESTRUTURA FREEZED
  Write-Host "🔍 Analisando estrutura Freezed..." -NoNewline
    
  # Extrair nome da classe
  if ($originalContent -match '@freezed\s+class\s+(\w+)') {
    $className = $Matches[1]
    Write-Host " ✅ Classe: $className" -ForegroundColor Green
  }
  else {
    Write-Host " ❌ Não encontrou @freezed class" -ForegroundColor Red
    $failCount++
    continue
  }
    
  # Extrair factory constructor e campos
  if ($originalContent -match 'factory\s+' + $className + '\s*\(([\s\S]*?)\)\s*=\s*_' + $className + ';') {
    $factoryParams = $Matches[1]
    Write-Host "✅ Factory encontrado" -ForegroundColor Green
  }
  else {
    Write-Host "❌ Factory não encontrado" -ForegroundColor Red
    $failCount++
    continue
  }
    
  # 4. CONVERTER PARA json_serializable PURO
  Write-Host "📝 Convertendo para json_serializable puro..." -ForegroundColor Cyan
    
  # Remover imports do Freezed, adicionar json_serializable
  $newContent = $originalContent -replace "import 'package:freezed_annotation/freezed_annotation.dart';", "import 'package:json_annotation/json_annotation.dart';"
  $newContent = $newContent -replace "part '.*\.freezed\.dart';", ""
    
  # Substituir @freezed por @JsonSerializable()
  $newContent = $newContent -replace '@freezed\s+class', '@JsonSerializable()`nclass'
    
  # Remover with _$ClassName
  $newContent = $newContent -replace '\s+with\s+_\$\w+', ''
    
  # Converter factory constructor para construtor normal
  # Extrair campos do factory
  $fields = @()
  $factoryLines = $factoryParams -split "`n"
  foreach ($line in $factoryLines) {
    if ($line -match '(required\s+)?(@\w+\(\))?\s*(\w+)\s+(\w+)') {
      $fieldType = $Matches[3]
      $fieldName = $Matches[4]
      $annotation = $Matches[2]
      $isRequired = $Matches[1] -ne ""
            
      $fields += @{
        Type       = $fieldType
        Name       = $fieldName
        Annotation = $annotation
        Required   = $isRequired
      }
    }
  }
    
  Write-Host "  📋 Campos detectados: $($fields.Count)" -ForegroundColor Cyan
    
  # Gerar construtor normal
  $constructorParams = ($fields | ForEach-Object {
      $annotation = if ($_.Annotation) { "$($_.Annotation) " } else { "" }
      $required = if ($_.Required) { "required " } else { "" }
      "    ${required}${annotation}this.$($_.Name)"
    }) -join ",`n"
    
  $constructorCode = @"

  const $className({
$constructorParams,
  });
"@
    
  # Substituir factory por construtor normal
  $newContent = $newContent -replace "factory\s+$className\s*\([^;]+\)\s*=\s*_$className;", $constructorCode
    
  # Remover factory fromJson antiga
  $newContent = $newContent -replace "factory\s+$className\.fromJson\([^)]+\)\s*=>\s*_\$${className}FromJson\([^)]+\);", ""
    
  # Adicionar serialization methods
  $serializationCode = @"

  // Serialization
  factory $className.fromJson(Map<String, dynamic> json) =>
      _`$${className}FromJson(json);
  
  Map<String, dynamic> toJson() => _`$${className}ToJson(this);
"@
    
  # Adicionar copyWith manual
  $copyWithParams = ($fields | ForEach-Object {
      "    $($_.Type)? $($_.Name)"
    }) -join ",`n"
    
  $copyWithArgs = ($fields | ForEach-Object {
      "      $($_.Name): $($_.Name) ?? this.$($_.Name)"
    }) -join ",`n"
    
  $copyWithCode = @"

  // Manual copyWith
  $className copyWith({
$copyWithParams,
  }) {
    return $className(
$copyWithArgs,
    );
  }
"@
    
  # Adicionar equality e hashCode
  $equalityChecks = ($fields | ForEach-Object {
      "other.$($_.Name) == $($_.Name)"
    }) -join " &&`n        "
    
  $hashFields = ($fields | ForEach-Object { $_.Name }) -join ", "
    
  $equalityCode = @"

  // Equality
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is $className &&
      runtimeType == other.runtimeType &&
      $equalityChecks;

  @override
  int get hashCode => Object.hash($hashFields);
"@
    
  # Inserir todos os métodos antes do último }
  $newContent = $newContent -replace '(\r?\n)\}(\s*)$', "$copyWithCode$equalityCode$serializationCode`$1}`$2"
    
  # 5. SALVAR NOVA VERSÃO
  Write-Host "💾 Salvando nova versão..." -NoNewline
  $newContent | Out-File -FilePath $entityFile -Encoding UTF8 -NoNewline
  Write-Host " ✅" -ForegroundColor Green
    
  # 6. REMOVER .freezed.dart
  $freezedFile = $entityFile -replace '\.dart$', '.freezed.dart'
  if (Test-Path $freezedFile) {
    Write-Host "🗑️  Removendo $([System.IO.Path]::GetFileName($freezedFile))..." -NoNewline
    Remove-Item $freezedFile -Force
    Write-Host " ✅" -ForegroundColor Green
  }
    
  # 7. REGENERAR
  Write-Host "🔄 Regenerando código..." -ForegroundColor Cyan
  $buildOutput = & dart run build_runner build --delete-conflicting-outputs 2>&1 | Out-String
    
  if ($buildOutput -match "Succeeded") {
    Write-Host "✅ Geração concluída!" -ForegroundColor Green
  }
  else {
    Write-Host "⚠️  Warnings na geração" -ForegroundColor Yellow
  }
    
  # 8. VERIFICAR .g.dart
  $gFile = $entityFile -replace '\.dart$', '.g.dart'
  if (Test-Path $gFile) {
    Write-Host "✅ Arquivo .g.dart gerado!" -ForegroundColor Green
  }
  else {
    Write-Host "❌ Arquivo .g.dart não foi gerado!" -ForegroundColor Red
    # Restaurar backup
    Write-Host "↩️  Restaurando backup..." -NoNewline
    Copy-Item $backupFile $entityFile -Force
    Write-Host " ✅" -ForegroundColor Green
    $failCount++
    continue
  }
    
  # 9. ANÁLISE
  Write-Host "`n🔍 Analisando código..." -ForegroundColor Cyan
  $analyzeOutput = & dart analyze $entityFile 2>&1 | Out-String
    
  # Contar erros e warnings
  $errors = ([regex]::Matches($analyzeOutput, "error •")).Count
  $warnings = ([regex]::Matches($analyzeOutput, "warning •")).Count
    
  Write-Host "📊 Erros: $errors | Warnings: $warnings" -ForegroundColor $(if ($errors -eq 0) { "Green" } else { "Red" })
    
  # 10. CALCULAR PONTUAÇÃO
  $entityScore = 0
    
  # Base
  $entityScore += 25  # Código criado
  $entityScore += 25  # Geração bem-sucedida
  $entityScore += 15  # Arquivo .g.dart gerado
    
  if ($errors -eq 0) {
    $entityScore += 30  # Zero erros
    Write-Host "✅ SEM ERROS!" -ForegroundColor Green
  }
  else {
    Write-Host "❌ $errors erros encontrados" -ForegroundColor Red
  }
    
  if ($warnings -eq 0) {
    $entityScore += 10  # Bonus sem warnings
    Write-Host "✅ SEM WARNINGS!" -ForegroundColor Green
  }
    
  # Verificar funcionalidades
  $entityContent = Get-Content $entityFile -Raw
  $features = @(
    @{ Name = "equality"; Pattern = "operator =="; Points = 3 },
    @{ Name = "hashCode"; Pattern = "get hashCode"; Points = 3 },
    @{ Name = "toJson"; Pattern = "toJson\(\)"; Points = 3 },
    @{ Name = "fromJson"; Pattern = "fromJson\("; Points = 3 },
    @{ Name = "copyWith"; Pattern = "copyWith\("; Points = 3 }
  )
    
  Write-Host "`n🧪 Verificando funcionalidades..." -ForegroundColor Cyan
  foreach ($feature in $features) {
    if ($entityContent -match $feature.Pattern) {
      Write-Host "  ✅ $($feature.Name)" -ForegroundColor Green
      $entityScore += $feature.Points
    }
    else {
      Write-Host "  ❌ $($feature.Name)" -ForegroundColor Red
    }
  }
    
  $entityDuration = (Get-Date) - $entityStartTime
    
  # Resultado
  Write-Host "`n" -NoNewline
  Write-Host ("=" * 70) -ForegroundColor Cyan
  Write-Host "📊 RESULTADO - $($entity.Name)" -ForegroundColor Cyan
  Write-Host ("=" * 70) -ForegroundColor Cyan
  Write-Host "🎯 Pontuação: $entityScore/125" -ForegroundColor $(if ($entityScore -ge 90) { "Green" } elseif ($entityScore -ge 70) { "Yellow" } else { "Red" })
  Write-Host "⏱️  Duração: $($entityDuration.TotalSeconds.ToString('F1'))s" -ForegroundColor Cyan
  Write-Host "📋 Status: " -NoNewline
    
  if ($errors -eq 0 -and $entityScore -ge 90) {
    Write-Host "✅ SUCESSO - Mantendo migração!" -ForegroundColor Green
    $successCount++
    $totalScore += $entityScore
        
    # Remover backup (mantendo a migração)
    # Remove-Item $backupFile -Force
    Write-Host "📝 Backup mantido: $([System.IO.Path]::GetFileName($backupFile))" -ForegroundColor Gray
  }
  else {
    Write-Host "⚠️  PROBLEMAS - Restaurando backup" -ForegroundColor Yellow
    Copy-Item $backupFile $entityFile -Force
    Write-Host "↩️  Backup restaurado" -ForegroundColor Yellow
    $failCount++
  }
    
  # Salvar resultado
  $results += @{
    Entity   = $entity.Name
    Score    = $entityScore
    Duration = $entityDuration.TotalSeconds
    Errors   = $errors
    Warnings = $warnings
    Success  = ($errors -eq 0 -and $entityScore -ge 90)
  }
}

# RELATÓRIO FINAL
$totalDuration = (Get-Date) - $startTime

Write-Host "`n`n" -NoNewline
Write-Host ("=" * 70) -ForegroundColor Magenta
Write-Host "🏆 RELATÓRIO FINAL - MIGRAÇÃO EM MASSA" -ForegroundColor Magenta
Write-Host ("=" * 70) -ForegroundColor Magenta

Write-Host "`n📊 ESTATÍSTICAS:" -ForegroundColor Cyan
Write-Host "  ✅ Sucessos: $successCount/$($entities.Count)" -ForegroundColor Green
Write-Host "  ❌ Falhas: $failCount/$($entities.Count)" -ForegroundColor $(if ($failCount -eq 0) { "Green" } else { "Red" })
Write-Host "  🎯 Pontuação Total: $totalScore" -ForegroundColor $(if ($totalScore -ge 125) { "Green" } elseif ($totalScore -ge 90) { "Yellow" } else { "Red" })
Write-Host "  ⏱️  Tempo Total: $($totalDuration.TotalSeconds.ToString('F1'))s" -ForegroundColor Cyan

Write-Host "`n📋 DETALHES POR ENTIDADE:" -ForegroundColor Cyan
foreach ($result in $results) {
  $icon = if ($result.Success) { "✅" } else { "❌" }
  $color = if ($result.Success) { "Green" } else { "Red" }
  Write-Host "  $icon $($result.Entity): $($result.Score)/125 pts ($($result.Duration.ToString('F1'))s)" -ForegroundColor $color
}

Write-Host "`n🎯 META: 125+ pontos ou resolver todas" -ForegroundColor Yellow
if ($totalScore -ge 125) {
  Write-Host "✅ META ATINGIDA! Pontuação: $totalScore" -ForegroundColor Green
}
elseif ($successCount -eq $entities.Count) {
  Write-Host "✅ TODAS ENTIDADES RESOLVIDAS!" -ForegroundColor Green
}
else {
  Write-Host "⚠️  Meta não atingida. Entidades com problemas: $failCount" -ForegroundColor Yellow
  Write-Host "💡 Sugestão: Testar outras soluções do mega lab para entidades que falharam" -ForegroundColor Cyan
}

Write-Host "`n" -NoNewline
Write-Host ("=" * 70) -ForegroundColor Magenta

# Salvar relatório JSON
$reportFile = "test_lab/results/mass_migration_test31.json"
$reportData = @{
  timestamp    = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
  test         = "Test 31 - Mass Migration"
  totalScore   = $totalScore
  successCount = $successCount
  failCount    = $failCount
  duration     = $totalDuration.TotalSeconds
  entities     = $results
  metaAchieved = ($totalScore -ge 125 -or $successCount -eq $entities.Count)
} | ConvertTo-Json -Depth 10

$reportData | Out-File -FilePath $reportFile -Encoding UTF8
Write-Host "📄 Relatório salvo: $reportFile" -ForegroundColor Gray

# Retornar código de saída
if ($successCount -eq $entities.Count) {
  exit 0
}
else {
  exit 1
}
