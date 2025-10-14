# Executa lint usando Biome (binário local)
# Uso: .\biome_lint.ps1 [caminho]
# Exemplo: .\biome_lint.ps1 .

param(
  [string]$Path = "."
)

$BiomeExe = Join-Path $PSScriptRoot "biome.exe"

if (-not (Test-Path $BiomeExe)) {
  Write-Host "❌ biome.exe não encontrado!" -ForegroundColor Red
  Write-Host "Execute: Invoke-WebRequest -Uri 'https://github.com/biomejs/biome/releases/download/@biomejs/biome@2.2.5/biome-win32-x64.exe' -OutFile 'biome.exe'" -ForegroundColor Yellow
  exit 1
}

Write-Host "🔍 Executando lint com Biome..." -ForegroundColor Cyan

& $BiomeExe lint --write $Path
