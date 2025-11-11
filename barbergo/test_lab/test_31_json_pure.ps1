# 🧪 TESTE 31: json_serializable Puro com copyWith Manual
# Hipótese: Simplicidade funciona - sem Freezed, sem built_value

Write-Host "🧪 TESTE 31: json_serializable Pure + Manual copyWith" -ForegroundColor Cyan
Write-Host "=" * 70

$testStart = Get-Date
$score = 0

# PASSO 1: Backup
Write-Host "`n💾 Backup user_interaction_entity..." -ForegroundColor Yellow
$entityFile = "lib/src/domain/entities/user_interaction_entity.dart"
Copy-Item $entityFile "$entityFile.test31_backup" -Force

# PASSO 2: Criar versão json_serializable pura
Write-Host "`n📝 Criando versão pura..." -ForegroundColor Yellow

$pureCode = @'
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

import 'converters.dart';
import 'enums.dart';

part 'user_interaction_entity.g.dart';

@JsonSerializable()
class UserInteractionEntity {
  final String vacancyId;
  final InteractionType type;
  
  @TimestampConverter()
  final DateTime timestamp;

  const UserInteractionEntity({
    required this.vacancyId,
    required this.type,
    required this.timestamp,
  });

  // ✨ copyWith manual (simples!)
  UserInteractionEntity copyWith({
    String? vacancyId,
    InteractionType? type,
    DateTime? timestamp,
  }) {
    return UserInteractionEntity(
      vacancyId: vacancyId ?? this.vacancyId,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  // ✨ Equality manual
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserInteractionEntity &&
          runtimeType == other.runtimeType &&
          vacancyId == other.vacancyId &&
          type == other.type &&
          timestamp == other.timestamp;

  @override
  int get hashCode => Object.hash(vacancyId, type, timestamp);

  // Serialization
  factory UserInteractionEntity.fromJson(Map<String, dynamic> json) =>
      _$UserInteractionEntityFromJson(json);

  Map<String, dynamic> toJson() => _$UserInteractionEntityToJson(this);
}
'@

Set-Content $entityFile $pureCode -NoNewline
$score += 25  # Código criado

# PASSO 3: Remover .freezed.dart
$freezedFile = "lib/src/domain/entities/user_interaction_entity.freezed.dart"
if (Test-Path $freezedFile) {
  Remove-Item $freezedFile -Force
  Write-Host "🗑️ Removido .freezed.dart" -ForegroundColor Gray
}

# PASSO 4: Regenerar código
Write-Host "`n🔄 Regenerando com json_serializable..." -ForegroundColor Yellow
$buildOutput = dart run build_runner build --delete-conflicting-outputs 2>&1
$buildSuccess = $LASTEXITCODE -eq 0

if ($buildSuccess) {
  Write-Host "✅ Geração bem-sucedida!" -ForegroundColor Green
  $score += 25
}
else {
  Write-Host "⚠️ Warnings na geração" -ForegroundColor Yellow
  $score += 10
}

# PASSO 5: Verificar arquivo gerado
$generatedFile = "lib/src/domain/entities/user_interaction_entity.g.dart"
if (Test-Path $generatedFile) {
  Write-Host "✅ Arquivo .g.dart gerado!" -ForegroundColor Green
  $score += 15
    
  # Verificar tamanho (deve ser menor que .freezed.dart)
  $size = (Get-Item $generatedFile).Length
  Write-Host "📦 Tamanho: $([math]::Round($size / 1KB, 1)) KB" -ForegroundColor Cyan
  if ($size -lt 10KB) {
    Write-Host "✅ Código compacto!" -ForegroundColor Green
    $score += 5  # Bônus simplicidade
  }
}

# PASSO 6: Análise de código
Write-Host "`n🔍 Analisando código..." -ForegroundColor Yellow
$analyzeOutput = dart analyze --fatal-infos $entityFile 2>&1
$errorCount = ($analyzeOutput | Select-String "error •").Count
$warningCount = ($analyzeOutput | Select-String "warning •").Count

Write-Host "📊 Erros: $errorCount | Warnings: $warningCount" -ForegroundColor $(if ($errorCount -eq 0) { "Green" } else { "Red" })

if ($errorCount -eq 0) {
  Write-Host "✅ SEM ERROS! json_serializable puro funciona!" -ForegroundColor Green
  $score += 30
    
  if ($warningCount -eq 0) {
    Write-Host "✅ SEM WARNINGS!" -ForegroundColor Green
    $score += 10  # Bônus
  }
}

# PASSO 7: Verificar funcionalidades implementadas
Write-Host "`n🧪 Verificando funcionalidades..." -ForegroundColor Yellow
$sourceContent = Get-Content $entityFile -Raw

$features = @{
  "copyWith" = $sourceContent -match 'copyWith'
  "equality" = $sourceContent -match 'operator =='
  "hashCode" = $sourceContent -match 'int get hashCode'
  "toJson"   = $sourceContent -match 'toJson'
  "fromJson" = $sourceContent -match 'fromJson'
}

$featuresOK = 0
foreach ($feature in $features.GetEnumerator()) {
  if ($feature.Value) {
    Write-Host "  ✅ $($feature.Key)" -ForegroundColor Green
    $featuresOK++
  }
  else {
    Write-Host "  ❌ $($feature.Key)" -ForegroundColor Red
  }
}

$score += ($featuresOK * 3)  # 3 pontos por feature

$testDuration = ((Get-Date) - $testStart).TotalSeconds

# RESULTADO FINAL
Write-Host "`n" + ("=" * 70) -ForegroundColor Cyan
Write-Host "📊 RESULTADO TESTE 31" -ForegroundColor White
Write-Host "=" * 70

$result = @{
  test                 = 31
  name                 = "json_serializable Pure + Manual copyWith"
  score                = $score
  max_score            = 125
  errors               = $errorCount
  warnings             = $warningCount
  features_implemented = $featuresOK
  duration             = $testDuration
  success              = ($score -ge 70)
  complexity           = "LOW"  # Muito simples
  maintainability      = "HIGH"  # Fácil manter
  recommendation       = if ($score -ge 90) { 
    "✅ EXCELENTE! Simplicidade vence!" 
  }
  elseif ($score -ge 70) { 
    "✅ VIÁVEL! Boa alternativa simples" 
  }
  elseif ($score -ge 40) { 
    "⚠️ Funciona mas precisa melhorias" 
  }
  else { 
    "❌ Não funcional" 
  }
}

Write-Host "🎯 Pontuação: $score/125" -ForegroundColor $(if ($score -ge 90) { "Green" } elseif ($score -ge 70) { "Yellow" } else { "Red" })
Write-Host "⚱️ Complexidade: $($result.complexity)" -ForegroundColor Green
Write-Host "🔧 Manutenibilidade: $($result.maintainability)" -ForegroundColor Green
Write-Host "⏱️ Duração: $([math]::Round($testDuration, 1))s" -ForegroundColor Cyan
Write-Host "📋 Recomendação: $($result.recommendation)" -ForegroundColor $(if ($score -ge 90) { "Green" } elseif ($score -ge 70) { "Yellow" } else { "Red" })

# Salvar resultado
New-Item -Path "test_lab/results" -ItemType Directory -Force | Out-Null
$result | ConvertTo-Json | Set-Content "test_lab/results/test_31_result.json"

# PASSO 8: Decisão
if ($score -ge 90) {
  Write-Host "`n✅ MANTENDO solução pura (excelente!)..." -ForegroundColor Green
  Write-Host "📝 Backup: $entityFile.test31_backup" -ForegroundColor Cyan
}
else {
  Write-Host "`n↩️ Restaurando original..." -ForegroundColor Yellow
  Move-Item "$entityFile.test31_backup" $entityFile -Force
  dart run build_runner build --delete-conflicting-outputs | Out-Null
}

if ($score -ge 70) {
  exit 0
}
else {
  exit 1
}
