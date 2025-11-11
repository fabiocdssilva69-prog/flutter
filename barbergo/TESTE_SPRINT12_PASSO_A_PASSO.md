# 🎯 Teste Sprint 12 - Passo a Passo

## ✅ Status: PRONTO PARA TESTAR!

**Índice criado com sucesso!** 🎉

```json
{
  "collectionGroup": "vacancies",
  "fields": [
    {"fieldPath": "barbershopId", "order": "ASCENDING"},
    {"fieldPath": "createdAt", "order": "DESCENDING"}
  ]
}
```

---

## 📱 Sequência de Testes

### 1️⃣ Login e Perfil (✅ Deve funcionar)

**Ação:**
- Abra o app no celular
- Faça login com suas credenciais
- Aguarde carregar o perfil

**Resultado Esperado:**
- ✅ Login bem-sucedido
- ✅ Perfil carrega sem erros PERMISSION_DENIED
- ✅ Foto, nome e dados aparecem

**Se falhar:**
- Verifique logs no terminal
- Procure por "PERMISSION_DENIED"

---

### 2️⃣ Criar Vaga (✅ Deve funcionar)

**Ação:**
1. Alterne para perfil **Barbearia** (se necessário)
2. Navegue: **Gestão → Minhas Vagas**
3. Clique no botão **"+"** (adicionar vaga)
4. Preencha o formulário:
   - **Título:** "Vaga Teste Sprint 12 - [Seu Nome]"
   - **Localização:** "São Paulo, SP" (ou sua cidade)
   - **Salário:** "R$ 2.500,00"
   - **Descrição:** "Teste de denormalização e índices"
   - **Requisitos:** "Experiência mínima, pontualidade"
5. Clique em **"Publicar Vaga"**

**Resultado Esperado:**
- ✅ Mensagem de sucesso
- ✅ Vaga criada no Firestore
- ✅ Dados salvos corretamente

**O que observar:**
- Denormalização deve incluir `barbershopName`, `barbershopLogoUrl`
- Campo `isActive` = true
- `createdAt` com timestamp atual

---

### 3️⃣ Listar Minhas Vagas (🎯 TESTE PRINCIPAL!)

**Ação:**
1. Permaneça em **Gestão → Minhas Vagas**
2. Observe a lista de vagas
3. Faça scroll se houver várias

**Resultado Esperado:**
- ✅ **NENHUM ERRO** `FAILED_PRECONDITION`! 🎉
- ✅ Lista de vagas carrega normalmente
- ✅ Ordenação por data (mais recentes primeiro)
- ✅ Denormalização funcionando:
  - Nome da barbearia aparece
  - Logo aparece (se configurado)
  - Localização aparece

**Se falhar:**
- ❌ Se aparecer FAILED_PRECONDITION → Índice não está habilitado ainda
- ❌ Se aparecer PERMISSION_DENIED → Regras não estão corretas

**Logs esperados (SUCESSO):**
```
✅ Firestore: Listen for Query(vacancies where barbershopId==... order by -createdAt) SUCCEEDED
✅ No warnings or errors
```

---

### 4️⃣ Pausar/Retomar Vaga (✅ Deve funcionar)

**Ação:**
1. Na lista de vagas, clique no botão **Pausar** de uma vaga
2. Observe a mudança de status
3. Clique em **Retomar**
4. Verifique se volta ao status ativo

**Resultado Esperado:**
- ✅ Status muda para `isActive: false`
- ✅ UI atualiza (botão muda de Pausar → Retomar)
- ✅ Atualização em tempo real funciona

---

### 5️⃣ Feed de Vagas (Perfil Barbeiro)

**Ação:**
1. Alterne para perfil **Barbeiro**
2. Configure sua localização: **Perfil → Editar → Cidade/Estado**
3. Navegue: **Feed** (tela inicial)
4. Observe as vagas disponíveis

**Resultado Esperado:**
- ✅ Feed carrega vagas da sua região
- ✅ Filtro por localização funciona
- ✅ Ordenação por data mais recente
- ✅ Swipe cards funcionam

**Se precisar de outro índice:**
Se aparecer erro no feed com filtro de localização, significa que precisa do índice #5:
```json
{
  "collectionGroup": "vacancies",
  "fields": [
    {"fieldPath": "isActive", "order": "ASCENDING"},
    {"fieldPath": "locationCityState", "order": "ASCENDING"},
    {"fieldPath": "createdAt", "order": "DESCENDING"}
  ]
}
```

---

### 6️⃣ Interações Swipe (Candidatar-se)

**Ação:**
1. No Feed, arraste um card para a **DIREITA** (Swipe Right)
2. Confirme a candidatura
3. Arraste outro card para a **ESQUERDA** (Swipe Left)
4. Observe a animação

**Resultado Esperado:**
- ✅ Swipe Right → Cria application no Firestore
- ✅ Swipe Left → Registra interação "ignored"
- ✅ Animação suave
- ✅ Próximo card aparece

**Validação no Firestore:**
- Collection: `applications`
- Campos:
  - `barberId`: Seu user ID
  - `vacancyId`: ID da vaga
  - `status`: "pending"
  - Denormalização: `barbershopName`, `vacancyTitle`

---

### 7️⃣ Minhas Candidaturas

**Ação:**
1. Navegue: **Minhas Candidaturas**
2. Veja a lista de vagas que você se candidatou

**Resultado Esperado:**
- ✅ Lista de applications
- ✅ Status de cada candidatura (pending, accepted, rejected)
- ✅ Denormalização funcionando

**Se falhar com FAILED_PRECONDITION:**
Precisa criar índice #4:
```json
{
  "collectionGroup": "applications",
  "fields": [
    {"fieldPath": "barberId", "order": "ASCENDING"},
    {"fieldPath": "createdAt", "order": "DESCENDING"}
  ]
}
```

---

### 8️⃣ Ver Candidatos (Barbearia)

**Ação:**
1. Alterne para perfil **Barbearia**
2. Navegue: **Gestão → Minhas Vagas**
3. Clique em uma vaga que recebeu candidaturas
4. Clique em **"Ver Candidatos"**

**Resultado Esperado:**
- ✅ Lista de barbeiros candidatos
- ✅ Foto, nome, rating aparecem
- ✅ Botões Aceitar/Rejeitar disponíveis

**Se falhar com FAILED_PRECONDITION:**
Precisa criar índices #2 ou #3:
```json
// Índice #2
{
  "collectionGroup": "applications",
  "fields": [
    {"fieldPath": "barbershopId", "order": "ASCENDING"},
    {"fieldPath": "createdAt", "order": "DESCENDING"}
  ]
}

// Índice #3
{
  "collectionGroup": "applications",
  "fields": [
    {"fieldPath": "vacancyId", "order": "ASCENDING"},
    {"fieldPath": "createdAt", "order": "DESCENDING"}
  ]
}
```

---

### 9️⃣ Aceitar/Rejeitar Candidatura

**Ação:**
1. Na lista de candidatos, clique **Aceitar** em um
2. Clique **Rejeitar** em outro
3. Observe as mudanças

**Resultado Esperado:**
- ✅ Status muda para "accepted" ou "rejected"
- ✅ UI atualiza imediatamente
- ✅ Método `updateApplicationStatus()` funciona
- ✅ Real-time sync

---

### 🔟 Tempo Real (Teste Avançado)

**Ação:**
1. Abra o app em **dois dispositivos** ou **web + celular**
2. Faça uma ação em um (ex: criar vaga)
3. Observe a atualização no outro

**Resultado Esperado:**
- ✅ Mudanças aparecem instantaneamente
- ✅ Streams do Riverpod funcionam
- ✅ Sem necessidade de refresh manual

---

## 🐛 Troubleshooting

### Se aparecer FAILED_PRECONDITION:

**Passo 1:** Identifique qual query está falhando no log:
```
W/Firestore: Query(vacancies where [campo1] order by [campo2])
```

**Passo 2:** Crie o índice correspondente no Firebase Console:
1. Copie o link do erro
2. Cole no navegador
3. Clique "Create Index"
4. Aguarde 2-10 minutos

**Passo 3:** Reinicie o app (hot restart: `R`)

### Se aparecer PERMISSION_DENIED:

**Significa:** Regras do Firestore bloqueando acesso

**Solução:**
```bash
firebase deploy --only firestore:rules
```

Verifique se `firestore.rules` tem collection names **lowercase**:
- ✅ `match /vacancies/`
- ✅ `match /applications/`
- ❌ `match /Vacancies/` ← ERRADO

### Se app crashar:

**Verifique logs:**
```bash
adb logcat | Select-String "Exception|Error|FATAL"
```

**Possíveis causas:**
- Null safety violation (campo null inesperado)
- Denormalização incompleta
- Provider não disponível

---

## 📊 Critérios de Sucesso

### ✅ Sucesso Mínimo (MVP):
- [x] App compila
- [x] App instala
- [x] Login funciona
- [x] Perfil carrega
- [ ] Criar vaga funciona
- [ ] **Listar vagas funciona SEM FAILED_PRECONDITION**

### ✅ Sucesso Completo:
- [ ] Todos os itens do MVP
- [ ] Feed com filtros funciona
- [ ] Swipe registra interações
- [ ] Candidaturas aparecem
- [ ] Aceitar/Rejeitar funciona
- [ ] Tempo real funciona

### ✅ Sucesso Ideal:
- [ ] Tudo acima
- [ ] Performance < 2s para carregar listas
- [ ] Animações suaves (60fps)
- [ ] Sem memory leaks
- [ ] Sem frame skipping

---

## 📈 Próximos Passos Após Teste

### Se tudo funcionar:
1. ✅ Commit das mudanças
2. ✅ Documentar resultados
3. ✅ Planejar Sprint 13

### Se encontrar bugs:
1. 📝 Documentar em `BUGS_SPRINT12.md`
2. 🔧 Priorizar correções
3. 🔄 Corrigir e testar novamente

---

## 🎯 Status Atual

**Data:** 18 de Outubro de 2025  
**Sprint:** 12 - Smart Matching System v1  
**Dispositivo:** Redmi Note 8 Pro (Android 11)  
**Índice Principal:** ✅ CRIADO E HABILITADO

**Correções Aplicadas:**
- ✅ Case-sensitivity (vacancies, applications)
- ✅ Firestore Rules lowercase
- ✅ Repository constants lowercase
- ✅ Composite index #1 (vacancies by barbershop)
- ✅ Providers implementados
- ✅ Métodos implementados

**Pendente:**
- ⏳ Índices adicionais (criar se necessário)
- ⏳ Testes completos
- ⏳ Validação de performance

---

## 📞 Suporte

**Firebase Console:**
- Indexes: https://console.firebase.google.com/project/barbergo-38c21/firestore/indexes
- Rules: https://console.firebase.google.com/project/barbergo-38c21/firestore/rules
- Data: https://console.firebase.google.com/project/barbergo-38c21/firestore/data

**Comandos Úteis:**
```bash
# Ver índices
firebase firestore:indexes

# Verificar device
flutter devices

# Hot reload
r

# Hot restart
R

# Ver logs
adb logcat
```

---

**BOA SORTE NOS TESTES! 🚀**
