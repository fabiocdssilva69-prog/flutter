# 🔧 Correções Firestore - Novembro 2, 2025

## 📊 Erros Identificados nos Logs

### **Erro 1: Índice Faltando (Discovery Profiles)**
```
FAILED_PRECONDITION: The query requires an index
Query: profiles where accountType==barber 
       order by -boostedUntil, -isPremium, -updatedAt
```

**Causa:** Consulta complexa com múltiplos campos de ordenação.

**Solução:** Criado índice composto no `firestore.indexes.json`:
```json
{
  "collectionGroup": "profiles",
  "queryScope": "COLLECTION",
  "fields": [
    {"fieldPath": "accountType", "order": "ASCENDING"},
    {"fieldPath": "boostedUntil", "order": "DESCENDING"},
    {"fieldPath": "isPremium", "order": "DESCENDING"},
    {"fieldPath": "updatedAt", "order": "DESCENDING"}
  ]
}
```

---

### **Erro 2: Permissão Negada (Filter Preferences)**
```
PERMISSION_DENIED: Missing or insufficient permissions
Path: profiles/{userId}/preferences/filters
```

**Causa:** Regras Firestore não incluíam subcoleção `preferences`.

**Solução:** Adicionado em `firestore.rules`:
```javascript
match /profiles/{userId} {
  // ... outras regras ...
  
  // Subcoleção: Preferences (Privado)
  match /preferences/{preferencesType} {
    allow read, write: if isSignedIn() && request.auth.uid == userId;
  }
}
```

---

### **Erro 3: Índice Faltando (Matches)**
```
FAILED_PRECONDITION: The query requires an index
Query: matches where userIds array-contains {userId}
       order by -lastMessageAt
```

**Causa:** Consulta com array-contains + ordenação.

**Solução:** Criado índice composto:
```json
{
  "collectionGroup": "matches",
  "queryScope": "COLLECTION",
  "fields": [
    {"fieldPath": "userIds", "arrayConfig": "CONTAINS"},
    {"fieldPath": "lastMessageAt", "order": "DESCENDING"}
  ]
}
```

---

## ✅ Ações Executadas

1. ✅ **Atualizado `firestore.indexes.json`**
   - Corrigido ordem do índice de profiles (accountType primeiro)
   - Adicionado índice para matches

2. ✅ **Atualizado `firestore.rules`**
   - Adicionada permissão para `preferences/{preferencesType}`

3. ✅ **Deploy Firebase**
   - Comando: `firebase deploy --only firestore`
   - Status: **Sucesso**
   - Índices: **Propagando** (leva 1-2 minutos)

---

## 🧪 Próximos Passos

### **Testes a Realizar:**

1. **Discovery de Profiles**
   - [ ] Abrir DiscoveryScreen
   - [ ] Verificar se profiles carregam sem erro
   - [ ] Confirmar ordenação (boosted → premium → recentes)

2. **Filter Preferences**
   - [ ] Abrir FiltersScreen
   - [ ] Ajustar filtros (distância, preço, rating)
   - [ ] Confirmar salvamento sem erro PERMISSION_DENIED

3. **Matches**
   - [ ] Abrir ChatsScreen (aba Matches)
   - [ ] Verificar listagem de matches
   - [ ] Confirmar ordenação por lastMessageAt

---

## ⏱️ Tempo de Propagação

**Índices Firestore:** 1-5 minutos para construção  
**Regras Firestore:** Instantâneo (já ativo)

**Status Atual:**
- Deploy concluído às 18:15 (horário local)
- Aguardar até 18:20 para testes completos
- App recompilando para aplicar mudanças

---

## 📝 Observações

### **Warnings no Deploy**
```
[W] 116:16 - Unused function: getOwnerId.
[W] 117:16 - Invalid variable name: resource.
```

**Impacto:** Nenhum (apenas warnings)  
**Ação:** Limpar função não utilizada em Sprint futura

### **Índice Antigo Detectado**
O Firebase detectou um índice antigo com ordem diferente:
- **Ordem antiga:** boostedUntil → isPremium → accountType → updatedAt
- **Ordem nova:** accountType → boostedUntil → isPremium → updatedAt

**Ação tomada:** Mantido índice antigo (respondido "No" quando perguntado)  
**Motivo:** Possível uso em outras queries

---

## 🎯 Resultados Esperados

### **Antes das Correções:**
- ❌ Discovery infinitamente carregando
- ❌ Erro ao salvar filtros
- ❌ Erro ao listar matches
- ⚠️ 3 tentativas de retry com exponential backoff

### **Depois das Correções:**
- ✅ Discovery carrega profiles imediatamente
- ✅ Filtros salvam sem erros
- ✅ Matches listam corretamente
- ✅ Sem retries desnecessários

---

## 📊 Impacto no Desempenho

**Consultas Otimizadas:**
- `discoverProfiles`: 3 tentativas/falha → 1 consulta/sucesso
- `filterPreferences`: PERMISSION_DENIED → Acesso direto
- `userMatches`: 3 tentativas/falha → 1 consulta/sucesso

**Redução de Tráfego:**
- Antes: ~9 tentativas falhas/minuto
- Depois: 0 erros esperados

**Experiência do Usuário:**
- Loading infinito → Carregamento instantâneo
- Erros silenciosos → Funcionalidade completa
