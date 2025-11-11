# 📱 Guia de Troubleshooting - Celular não Detectado

## ❌ Problema: Celular não é detectado pelo computador

### ✅ Soluções (faça na ordem):

## 1️⃣ Verificar Cabo USB
- ✅ Use um cabo USB **de dados** (não apenas carregador)
- ✅ Teste em outra porta USB do computador
- ✅ Se possível, teste outro cabo USB

## 2️⃣ Habilitar Depuração USB no Celular

### No seu celular Android:

```
1. Configurações
2. Sobre o telefone (ou Sistema)
3. Toque 7x em "Número da versão"
   → Aparecerá: "Você agora é um desenvolvedor!"
4. Volte para Configurações
5. Opções do desenvolvedor (ou Opções de desenvolvedor)
6. Ative "Depuração USB"
7. Ative "Instalar via USB" (se disponível)
```

## 3️⃣ Autorizar o Computador

Quando conectar o cabo, deve aparecer um popup no celular:

```
"Permitir depuração USB?"
Computador: [fingerprint RSA]

[ ] Sempre permitir deste computador
[Cancelar] [OK]
```

✅ **Marque** "Sempre permitir deste computador"  
✅ Clique em **OK**

## 4️⃣ Verificar Modo de Conexão USB

Na barra de notificações do celular, deve aparecer:

```
"Sistema Android"
USB para transferência de arquivos

Toque para ver mais opções
```

Toque e selecione:
- ✅ **Transferência de arquivos** (ou MTP)
- ❌ NÃO use "Apenas carregamento"

## 5️⃣ Reiniciar Servidor ADB

Execute no terminal:

```powershell
& "$env:LOCALAPPDATA\Android\sdk\platform-tools\adb.exe" kill-server
& "$env:LOCALAPPDATA\Android\sdk\platform-tools\adb.exe" start-server
& "$env:LOCALAPPDATA\Android\sdk\platform-tools\adb.exe" devices
```

Deve aparecer:
```
List of devices attached
XXXXXXXXXXXXXX    device
```

## 6️⃣ Verificar com Flutter

```powershell
flutter devices
```

Deve aparecer:
```
SM-XXXXX (mobile) • XXXXXXXXXXXXXX • android • Android XX (API XX)
```

---

## 🔧 Se AINDA não funcionar:

### Opção A: Instalar Driver USB (Windows)
1. Abra Gerenciador de Dispositivos
2. Procure por "Dispositivos Portáteis" ou "Outros dispositivos"
3. Se aparecer com "!" amarelo, clique com direito → Atualizar driver
4. Escolha "Procurar automaticamente"

### Opção B: Modo de Desenvolvedor (Avançado)
No celular, em Opções do desenvolvedor:
- ✅ Ative "Manter ativo"
- ✅ Ative "Depuração USB"
- ✅ Desative "Verificar apps via USB" (temporariamente)

### Opção C: Reiniciar Tudo
1. Desconecte o celular
2. Feche VS Code
3. Execute: `adb kill-server`
4. Reinicie o celular
5. Reinicie o computador (se necessário)
6. Conecte novamente

---

## ✅ Quando Funcionar:

Você verá:

```powershell
flutter devices

Found 4 connected devices:
  SM-G973F (mobile) • XXXXXXXXXXXXXX • android • Android 12 (API 31)
  Windows (desktop) • windows        • windows-x64    • Microsoft Windows
  Chrome (web)      • chrome         • web-javascript • Google Chrome
  Edge (web)        • edge           • web-javascript • Microsoft Edge
```

Aí é só executar:
```powershell
.\test_firebase_celular.ps1
```

---

## 🆘 Alternativas se Não Funcionar:

### 1. Testar no Navegador (Mais Rápido)
```powershell
flutter run -d chrome
```
✅ Não usa RAM  
❌ Não é dispositivo real

### 2. Usar Emulador (Usa mais RAM)
```powershell
flutter emulators --launch Medium_Phone_API_36.1
flutter run
```
✅ Simula dispositivo Android  
❌ Usa ~2GB de RAM

### 3. Build APK e Instalar Manualmente
```powershell
flutter build apk --debug
```
Depois copie o APK para o celular e instale manualmente.

---

**Última atualização:** 2025-10-17
