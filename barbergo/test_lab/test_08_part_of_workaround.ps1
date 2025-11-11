# 🧪 TESTE 08: Usar 'part of' em arquivo separado
# Hipótese: Separar definição pode resolver análise do compilador

Write-Host "🧪 TESTE 08: Part Of Workaround" -ForegroundColor Cyan

$entityFile = "lib/src/domain/entities/profile_entity.dart"
$mixinFile = "lib/src/domain/entities/profile_entity_mixin.dart"

Copy-Item $entityFile "$entityFile.bak"

# Cria arquivo separado com mixin implementation
$mixinContent = @"
part of 'profile_entity.dart';

// Implementação manual do mixin
mixin ProfileEntityMixin {
  String get userId;
  AccountType get accountType;
  String get name;
  String get email;
  String get bio;
  String get location;
  String get contactPhone;
  String? get fcmToken;
  DateTime get createdAt;
  DateTime? get updatedAt;
  
  Map<String, dynamic> toJson();
}
"@

Set-Content $mixinFile $mixinContent

# Modifica entity para usar mixin manual
$content = Get-Content $entityFile -Raw
$content = $content -replace 'with _\$ProfileEntity', 'with ProfileEntityMixin'
$content = $content -replace "part 'profile_entity.freezed.dart';", "part 'profile_entity.freezed.dart';`npart 'profile_entity_mixin.dart';"

Set-Content $entityFile $content -NoNewline

Write-Host "📝 Criado mixin manual em arquivo separado" -ForegroundColor Yellow

$result = dart analyze lib/src/domain/entities/profile_entity.dart 2>&1
if ($result -notmatch "error") {
  Write-Host "✅ SUCESSO! Part of workaround funciona!" -ForegroundColor Green
  "TESTE 08: ✅ SUCESSO - part of workaround" | Out-File test_lab/results/08_success.txt
  Copy-Item $mixinFile test_lab/results/08_working_mixin.dart
  exit 0
}
else {
  Write-Host "❌ FALHOU: Part of não resolve" -ForegroundColor Red
  $result | Out-File test_lab/results/08_failure.txt
  Move-Item "$entityFile.bak" $entityFile -Force
  Remove-Item $mixinFile -ErrorAction SilentlyContinue
  exit 1
}
