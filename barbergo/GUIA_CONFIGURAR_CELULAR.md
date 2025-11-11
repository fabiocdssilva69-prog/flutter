# 📱 GUIA PASSO A PASSO - Configurar Celular para Depuração

## ✅ PASSO 1: Habilitar Modo Desenvolvedor

### No seu celular Android:

1. **Abra Configurações** (ícone de engrenagem ⚙️)

2. **Procure por "Sobre o telefone"** ou "Sistema"
   - Pode estar em: Configurações → Sistema → Sobre o telefone
   - Ou: Configurações → Sobre o telefone

3. **Encontre "Número da versão"** ou "Número de compilação"
   - Role a tela para baixo
   - Vai ver algo como: "Número da versão: XX.XX.XX"

4. **Toque 7 vezes seguidas** nesse número
   - Toque, toque, toque, toque, toque, toque, toque (7x)
   - Aparecerá uma mensagem: 
     * "Você agora é um desenvolvedor!"
     * ou "Modo desenvolvedor ativado"

5. ✅ **Pronto!** Agora você tem acesso às Opções do Desenvolvedor

---

## ✅ PASSO 2: Ativar Depuração USB

1. **Volte para Configurações principais**

2. **Procure por:**
   - "Opções do desenvolvedor" 
   - ou "Opções de desenvolvedor"
   - ou "Developer options"
   
   📍 Geralmente está em:
   - Configurações → Sistema → Opções do desenvolvedor
   - ou Configurações → Opções do desenvolvedor

3. **Ative o botão no topo** (se estiver desativado)

4. **Role e encontre:**
   - ✅ "Depuração USB" → ATIVE
   - ✅ "Instalar via USB" → ATIVE (se disponível)
   - ✅ "Manter ativo" → ATIVE (opcional, mas recomendado)

5. Aparecerá um aviso de segurança → Clique em **OK** ou **Permitir**

---

## ✅ PASSO 3: Conectar Cabo USB

1. **Pegue o cabo USB do celular**
   - IMPORTANTE: Precisa ser cabo de **dados** (não apenas carregador)
   - Teste em uma porta USB diferente se não funcionar

2. **Conecte o celular no computador**

3. **No celular, vai aparecer:**
   - Uma notificação: "USB para carregamento"
   - Ou: "Carregando via USB"

4. **Toque na notificação** e selecione:
   - ✅ **"Transferência de arquivos"** (MTP)
   - ou "Transferir arquivos"
   - ❌ NÃO deixe em "Apenas carregamento"

---

## ✅ PASSO 4: Autorizar o Computador

Quando conectar o cabo, deve aparecer um **popup no celular**:

```
🔐 Permitir depuração USB?

A chave de impressão digital RSA do computador é:
XX:XX:XX:XX:XX...

□ Sempre permitir deste computador

[Cancelar]  [OK]
```

**IMPORTANTE:**
1. ✅ **MARQUE** a caixinha "Sempre permitir deste computador"
2. ✅ Clique em **OK**

⚠️ **Se o popup NÃO aparecer:**
- Desconecte o cabo
- Espere 5 segundos
- Conecte novamente
- Ou tente em outra porta USB

---

## ✅ PASSO 5: Verificar Conexão

Depois de fazer tudo acima, volte para o VS Code e execute:

```powershell
& "$env:LOCALAPPDATA\Android\sdk\platform-tools\adb.exe" devices
```

**RESULTADO ESPERADO:**
```
List of devices attached
XXXXXXXXXXXXXX    device
```

Se aparecer **"device"** ao lado do número, FUNCIONOU! ✅

**Se aparecer "unauthorized":**
- O celular não autorizou o computador
- Verifique se apareceu o popup no celular
- Desconecte e conecte novamente

**Se aparecer lista vazia:**
- O celular não foi detectado
- Verifique os passos anteriores
- Tente outro cabo USB ou porta USB

---

## 🆘 TROUBLESHOOTING

### "Não encontro 'Opções do desenvolvedor'"
→ Você tocou 7x no "Número da versão"? Precisa ser exatamente 7 vezes.

### "Não aparece popup de autorização"
→ Vá em: Opções do desenvolvedor → "Revogar autorizações de depuração USB"
→ Desconecte e conecte novamente

### "Aparece 'unauthorized' no adb devices"
→ No celular: Opções do desenvolvedor → "Revogar autorizações"
→ Reconecte o cabo e autorize novamente

### "Não funciona de jeito nenhum"
→ Reinicie o celular
→ Reinicie o computador
→ Tente outro cabo USB

---

## ✅ QUANDO FUNCIONAR

Execute este comando no VS Code para testar:

```powershell
.\test_firebase_celular.ps1
```

Pronto! 🎉

---

**Criado em:** 2025-10-17  
**Última atualização:** 2025-10-17
