# 🧪 TESTE 04: Usar extension ao invés de mixin
# Hipótese: Podemos converter mixin em extension + implementação manual

Write-Host "🧪 TESTE 04: Extension Workaround" -ForegroundColor Cyan

$entityFile = "lib/src/domain/entities/profile_entity.dart"
Copy-Item $entityFile "$entityFile.bak"

# Remove 'with _$ProfileEntity' e adiciona implementação via extension
$content = Get-Content $entityFile -Raw
$content = $content -replace '(class \w+Entity) with (_\$\w+Entity)', '$1'
$content = $content -replace '(?s)(@freezed\s+class \w+Entity)', '$1 /* IMPLEMENTADO VIA EXTENSION */'

Set-Content $entityFile $content -NoNewline

# Cria extension manualmente
$extensionCode = @"

extension ProfileEntityExtension on ProfileEntity {
  // CopyWith será implementado manualmente
  ProfileEntity copyWith({
    String? userId,
    AccountType? accountType,
    String? name,
    String? email,
    String? bio,
    String? location,
    String? contactPhone,
    String? fcmToken,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProfileEntity(
      userId: userId ?? this.userId,
      accountType: accountType ?? this.accountType,
      name: name ?? this.name,
      email: email ?? this.email,
      bio: bio ?? this.bio,
      location: location ?? this.location,
      contactPhone: contactPhone ?? this.contactPhone,
      fcmToken: fcmToken ?? this.fcmToken,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
"@

Add-Content $entityFile $extensionCode

Write-Host "📝 Modificado: Removido mixin, adicionado extension" -ForegroundColor Yellow

$result = dart analyze lib/src/domain/entities/profile_entity.dart 2>&1
if ($result -notmatch "error") {
  Write-Host "✅ SUCESSO! Extension workaround funciona!" -ForegroundColor Green
  "TESTE 04: ✅ SUCESSO - extension workaround" | Out-File test_lab/results/04_success.txt
  exit 0
}
else {
  Write-Host "❌ FALHOU: Extension workaround não funciona" -ForegroundColor Red
  $result | Out-File test_lab/results/04_failure.txt
  Move-Item "$entityFile.bak" $entityFile -Force
  exit 1
}
