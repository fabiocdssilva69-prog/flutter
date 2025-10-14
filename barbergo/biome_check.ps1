# Executa check completo usando Biome (binário local)
# Uso: .\biome_check.ps1 [caminho]
# Exemplo: .\biome_check.ps1 .

param(
  [string]$Path = "."
)

$BiomeExe = Join-Path $PSScriptRoot "biome.exe"

if (-not (Test-Path $BiomeExe)) {
  Write-Host "❌ biome.exe não encontrado!" -ForegroundColor Red
  Write-Host "Execute: Invoke-WebRequest -Uri 'https://github.com/biomejs/biome/releases/download/@biomejs/biome@2.2.5/biome-win32-x64.exe' -OutFile 'biome.exe'" -ForegroundColor Yellow
  exit 1
}

Write-Host "🔎 Executando check completo com Biome..." -ForegroundColor Cyan

& $BiomeExe check --write $Path
