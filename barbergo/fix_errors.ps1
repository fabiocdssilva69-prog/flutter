# Script para corrigir erros de compilação em massa

Write-Host "🔧 Iniciando correções em massa..." -ForegroundColor Cyan

# 1. AppColors.primaryColor → AppColors.primary
Write-Host "`n📝 Corrigindo AppColors.primaryColor → AppColors.primary" -ForegroundColor Yellow
$files = Get-ChildItem -Path "lib" -Filter "*.dart" -Recurse
foreach ($file in $files) {
  $content = Get-Content $file.FullName -Raw
  if ($content -match "AppColors\.primaryColor") {
    $content = $content -replace "AppColors\.primaryColor", "AppColors.primary"
    Set-Content -Path $file.FullName -Value $content -NoNewline
    Write-Host "  ✅ $($file.Name)" -ForegroundColor Green
  }
}

# 2. VacancyType.freelance → VacancyType.freelancer
Write-Host "`n📝 Corrigindo VacancyType.freelance → VacancyType.freelancer" -ForegroundColor Yellow
foreach ($file in $files) {
  $content = Get-Content $file.FullName -Raw
  if ($content -match "VacancyType\.freelance[^r]") {
    $content = $content -replace "VacancyType\.freelance", "VacancyType.freelancer"
    Set-Content -Path $file.FullName -Value $content -NoNewline
    Write-Host "  ✅ $($file.Name)" -ForegroundColor Green
  }
}

# 3. application.appliedAt → application.createdAt
Write-Host "`n📝 Corrigindo appliedAt → createdAt" -ForegroundColor Yellow
foreach ($file in $files) {
  $content = Get-Content $file.FullName -Raw
  if ($content -match "appliedAt") {
    $content = $content -replace "appliedAt", "createdAt"
    Set-Content -Path $file.FullName -Value $content -NoNewline
    Write-Host "  ✅ $($file.Name)" -ForegroundColor Green
  }
}

Write-Host "`n✅ Correções em massa concluídas!" -ForegroundColor Green
Write-Host "`n🔄 Execute agora: dart run build_runner build --delete-conflicting-outputs" -ForegroundColor Cyan
