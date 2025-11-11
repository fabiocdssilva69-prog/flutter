# Scripts de Automação - BarberGo

Este diretório contém scripts para automatizar tarefas de desenvolvimento e otimização.

## 📜 Scripts Disponíveis

### `open-vscode-optimized.ps1` ⭐ **MAIS USADO**

**Abre o VS Code 1.99.3 otimizado com perfil limpo.**

#### Como usar:

```powershell
.\scripts\open-vscode-optimized.ps1
```

Ou dê duplo clique em: `open-vscode-optimized.bat`

#### O que faz:
- Fecha automaticamente o VS Code antigo (1.105.1)
- Abre o VS Code 1.99.3 com perfil isolado e limpo
- Carrega o projeto BarberGo
- Aplica todas as configurações otimizadas automaticamente
- Reduz uso de RAM de 8GB para 2-3GB

---

### `install-vscode-1.99.3.ps1`

**Instalação automática do VS Code 1.99.3 para otimização de performance.**

#### Como usar:

```powershell
.\scripts\install-vscode-1.99.3.ps1
```

#### O que faz:
- Baixa automaticamente o VS Code 1.99.3
- Fecha o VS Code atual (se estiver rodando)
- Instala a versão otimizada
- Remove arquivos temporários
- Oferece abrir o VS Code ao final

#### Requisitos:
- Windows PowerShell 5.1+
- Conexão com internet
- Permissões para instalar software

#### Troubleshooting:

**"Execution Policy" bloqueando o script:**
```powershell
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned -Force
```

**Rodar como Administrador (opcional):**
```powershell
Start-Process powershell -Verb runAs -ArgumentList "-File .\scripts\install-vscode-1.99.3.ps1"
```

---

## 📚 Documentação Relacionada

- **[QUICKSTART_PERFORMANCE.md](../QUICKSTART_PERFORMANCE.md)** - Guia rápido de 5 minutos
- **[VSCODE_PERFORMANCE_GUIDE.md](../VSCODE_PERFORMANCE_GUIDE.md)** - Documentação completa

---

## 🔧 Adicionar Novos Scripts

Para adicionar scripts ao projeto:

1. Crie o arquivo `.ps1` neste diretório
2. Adicione documentação no header do script
3. Atualize este README com instruções de uso
4. Teste o script antes de commitar

---

## 💡 Scripts Futuros (Sugestões)

- `setup-flutter-env.ps1` - Configuração automática do ambiente Flutter
- `clean-project.ps1` - Limpeza de cache e build
- `backup-settings.ps1` - Backup de configurações do VS Code
- `update-dependencies.ps1` - Atualização de dependências do projeto

---

**Contribua com novos scripts úteis para a equipe!**
