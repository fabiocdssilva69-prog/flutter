# ⚠️ PROBLEMA PERSISTENTE: App Falha ao Inicializar

## Status Atual

❌ **App trava em "Falha na Inicialização"** mesmo após:
- ✅ Perfil criado no Firestore (`/profiles/6RYGS6HoEkhQgikNxUIkn7NpwmI3`)
- ✅ Todos os campos preenchidos
- ✅ Localização correta (coleção raiz)

## Campos Necessários no Documento Firestore

Verifique se o documento tem **EXATAMENTE** estes campos e tipos:

### Campos Obrigatórios (String)
```
userId: "6RYGS6HoEkhQgikNxUIkn7NpwmI3"
email: "seu-email@exemplo.com"
name: "Seu Nome"
accountType: "barber"  (ou "barbershop")
bio: ""  (string vazia)
location: "Florianópolis, SC"
contactPhone: ""  (string vazia)
```

### Campos Opcionais (podem ser null ou ausentes)
```
fcmToken: null  (NÃO string "null", mas valor null do Firestore)
avatarUrl: null
updatedAt: null
preciseLocation: null
```

### Campos com Valores Padrão
```
portfolioUrls: []  (array VAZIO, não null)
searchRadiusKm: 25  (número, não string)
```

### Campos Timestamp (CRÍTICO)
```
createdAt: Timestamp  (DEVE ser tipo Timestamp, não string!)
```

---

## ⚠️ ERRO MAIS PROVÁVEL

O campo `createdAt` pode estar como **String** em vez de **Timestamp**!

### Como Verificar no Firebase Console:

1. Abra: https://console.firebase.google.com/project/barbergo-38c21/firestore/databases/-default-/data/~2Fprofiles~2F6RYGS6HoEkhQgikNxUIkn7NpwmI3

2. Procure o campo `createdAt`

3. Verifique o TIPO:
   - ✅ **Correto**: `timestamp` (ícone de relógio ⏰)
   - ❌ **Errado**: `string` (ícone de texto "abc")

4. Se estiver como `string`, **DELETE** o campo e adicione novamente:
   - Clique nos 3 pontos ao lado do campo
   - **Excluir campo**
   - Clique **+ Adicionar campo**
   - Nome: `createdAt`
   - Tipo: **timestamp**
   - Clique no ícone de relógio ⏰ e selecione **"Agora"**
   - Salvar

---

## Campos que NÃO Devem Estar Presentes

❌ Remova se existirem:
- `updatedAt` com string (deve ser timestamp ou null)
- Qualquer campo com nome errado
- Campos extras não listados acima

---

## Checklist de Validação

Execute no Firebase Console:

### 1. Tipo de Dados
- [ ] `userId` é string
- [ ] `email` é string
- [ ] `name` é string  
- [ ] `accountType` é string (valor: "barber" ou "barbershop")
- [ ] `bio` é string (pode ser vazio)
- [ ] `location` é string
- [ ] `contactPhone` é string (pode ser vazio)
- [ ] `portfolioUrls` é array
- [ ] `searchRadiusKm` é number (25)
- [ ] `createdAt` é **timestamp** ⚠️ CRÍTICO
- [ ] `fcmToken` é null (não string "null")
- [ ] `avatarUrl` é null
- [ ] `preciseLocation` é null

### 2. Valores Corretos
- [ ] `userId` = "6RYGS6HoEkhQgikNxUIkn7NpwmI3"
- [ ] `accountType` = "barber" OU "barbershop" (lowercase)
- [ ] `portfolioUrls` = [] (array vazio, 0 elementos)

---

## Solução Rápida: Recriar Documento

Se houver QUALQUER dúvida, **delete e recrie** o documento:

1. **Delete o documento atual**:
   - Vá em: Firestore → `profiles` → `6RYGS6HoEkhQgikNxUIkn7NpwmI3`
   - Clique nos 3 pontos → **Excluir documento**

2. **Crie novo documento**:
   - Clique em **Adicionar documento**
   - ID do documento: `6RYGS6HoEkhQgikNxUIkn7NpwmI3`
   
3. **Adicione os campos NESTA ORDEM** (importante para evitar erros):

```
1. userId (string):         6RYGS6HoEkhQgikNxUIkn7NpwmI3
2. email (string):          seu-email@exemplo.com
3. name (string):           Seu Nome
4. accountType (string):    barber
5. bio (string):            [deixe vazio]
6. location (string):       Florianópolis, SC
7. contactPhone (string):   [deixe vazio]
8. portfolioUrls (array):   [clique em + Adicionar item, depois remova o item para ficar array vazio]
9. searchRadiusKm (number): 25
10. createdAt (timestamp):  [clique no relógio, selecione "Agora"]
11. fcmToken (null):        [selecione tipo "null"]
12. avatarUrl (null):       [selecione tipo "null"]
13. preciseLocation (null): [selecione tipo "null"]
```

4. **Salvar**

---

## Após Corrigir

1. **Feche o app completamente** no celular
2. **Limpe cache** (opcional): Configurações → Apps → BarberGO → Limpar cache
3. **Abra o app novamente**
4. **Tente fazer login**

---

## Se Ainda Falhar

Capture logs detalhados:

```powershell
# Reconecte o celular
flutter devices

# Limpe logs antigos e capture novos
adb -s uwbekb8hpf6lamts logcat -c
flutter logs -d uwbekb8hpf6lamts 2>&1 | Tee-Object -FilePath "erro_completo.txt"
```

Depois abra o app e me envie o arquivo `erro_completo.txt`.

---

## Última Opção: Criar Nova Conta

Se nada funcionar:

1. **Faça logout** no app (ou desinstale e reinstale)
2. **Crie NOVA conta** com email diferente
3. **Complete TODO o onboarding** (não pule etapas)
4. Isso criará perfil automaticamente no fluxo correto

O perfil será criado pelo código do onboarding, garantindo todos os campos corretos.
