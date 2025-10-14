# Biome - Guia de Início Rápido

## ⚡ Uso Rápido

```powershell
# Formatar e lint tudo
.\biome.exe check --write .

# Apenas formatar
.\biome.exe format --write .

# Apenas lint
.\biome.exe lint --write .
```

## 📦 Ou Use os Scripts

```powershell
.\biome_check.ps1       # Check completo
.\biome_format.ps1      # Apenas formatar
.\biome_lint.ps1        # Apenas lint
```

## ⚠️ IMPORTANTE

**Biome NÃO formata Dart!**

Para arquivos `.dart`, use:
```bash
dart format lib/
```

## 📚 Documentação Completa

- **BIOME_BINARY_SETUP.md** - Setup completo do binário local
- **BIOME_USAGE.md** - Comparação de métodos (npm, Docker, binário)
- **BIOME_DOCKER.md** - Uso via Docker (fallback)

## 🔧 Reinstalar Binário

Se precisar baixar novamente:

```powershell
Invoke-WebRequest -Uri "https://github.com/biomejs/biome/releases/download/@biomejs/biome@2.2.5/biome-win32-x64.exe" -OutFile "biome.exe" -UseBasicParsing
```

## 📊 Performance

- **Binário Local**: ~10ms ⚡⚡⚡ (RECOMENDADO)
- **npm/npx**: ~50ms ⚡⚡
- **Docker**: ~280ms ⚡

---

**Versão**: 2.2.5 | **Status**: ✅ Operacional
