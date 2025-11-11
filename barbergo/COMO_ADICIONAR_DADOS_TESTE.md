# 🎯 Como Adicionar Dados de Teste ao BarberGO

## ✅ Implementação Completa

Criei uma tela de debug integrada ao app que permite popular o banco de dados com 10 perfis falsos diretamente do dispositivo.

## 📍 Como Acessar

### Opção 1: Via URL (Mais Fácil)
No navegador do seu celular, acesse:
```
barbergo://debug/seed
```

### Opção 2: Adicionar Botão Temporário

Adicione temporariamente no `HomeScreen` ou `ProfileScreen`:

```dart
// Adicione no AppBar ou em algum lugar visível:
IconButton(
  icon: const Icon(Icons.bug_report),
  onPressed: () => context.go('/debug/seed'),
)
```

### Opção 3: Usar Console de Debug

No terminal do Flutter (onde você rodou `flutter run`), digite:
```
g /debug/seed
```

## 🌱 O que a tela faz?

Quando você apertar o botão "🌱 Criar 10 Perfis Falsos":

1. **7 Barbeiros** individuais com:
   - Nomes: Carlos Silva, Rafael Costa, Thiago Alves, Lucas Mendes, André Santos, Felipe Rodrigues, Marcelo Ferreira
   - 5 premium (boosted 3-30 dias)
   - 2 não-premium
   - Ratings: 4.5 - 4.9 estrelas
   - Reviews: 45 - 289 avaliações
   - Serviços variados (Corte, Barba, Sobrancelha, Pigmentação, etc.)
   - Preços: R$30 - R$120

2. **3 Barbearias** estabelecimentos:
   - Barbearia Classic, Barbearia Premium, The Barber House
   - 2 premium (boosted 15-30 dias)
   - 1 não-premium
   - Ratings: 4.6 - 4.9 estrelas
   - Reviews: 234 - 567 avaliações
   - Serviços completos (+ Massagem, Tratamento Capilar)
   - Preços: R$35 - R$200

## 📊 Dados Realistas

Todos os perfis incluem:
- ✅ Localização em São Paulo (com lat/long reais)
- ✅ Horários de funcionamento (alguns fecham dom/seg)
- ✅ Bio descritiva
- ✅ Fotos (via pravatar.cc e Unsplash)
- ✅ Data de criação (30-730 dias atrás)
- ✅ Última atualização (15min - 8hrs atrás)

## 🔒 Segurança

A tela usa `FirebaseFirestore.instance.collection('profiles').doc(id).set()`:
- ✅ Respeita as regras do Firestore
- ✅ Cria profiles com IDs customizados (barber_001, barbershop_001, etc.)
- ✅ Usa autenticação do usuário logado
- ✅ Log em tempo real de sucesso/erro

## 📝 Depois de Executar

1. **Reinicie o app** ou faça hot restart (`R` no terminal)
2. **Vá para Discovery**: Você verá 7 barbeiros (porque você é barbershop)
3. **Teste filtros**: Mude distância, preço, rating
4. **Verifique ordenação**:
   - Primeiro: 6 profiles boosted (7, 3, 15, 30, 5, 10 dias restantes)
   - Depois: Não-premium por updatedAt

## 🎉 Resultado Esperado

```
🌱 Iniciando seed de perfis...
📝 Criando 10 perfis...

✅ Criado: Carlos Silva (barber)
✅ Criado: Rafael Costa (barber)
✅ Criado: Thiago Alves (barber)
✅ Criado: Barbearia Classic (barbershop)
✅ Criado: Lucas Mendes (barber)
✅ Criado: Barbearia Premium (barbershop)
✅ Criado: André Santos (barber)
✅ Criado: Felipe Rodrigues (barber)
✅ Criado: The Barber House (barbershop)
✅ Criado: Marcelo Ferreira (barber)

============================================================
🎉 SEED CONCLUÍDO!
============================================================
✅ Criados com sucesso: 10 perfis
============================================================
```

## 🚨 Se Encontrar Erros

### Erro: PERMISSION_DENIED
**Causa**: Regras do Firestore não permitem criar profiles externos

**Solução**: Temporariamente, no Firebase Console:
1. Vá em Firestore Database → Rules
2. Adicione (APENAS PARA TESTE, REMOVA DEPOIS):
```javascript
match /profiles/{profileId} {
  allow create: if request.auth != null;  // Permite criar qualquer profile
  // ... resto das regras
}
```
3. Publique
4. Execute seed novamente
5. **IMPORTANTE**: Volte a regra original depois

### Discovery Ainda Mostra "0 profiles"
1. Feche o app completamente
2. Reabra
3. Puxe para baixo para forçar refresh
4. Verifique logs: `I/flutter: 🔍 [discoverProfiles] snapshot.docs.length: 7`

## 🗑️ Limpeza (Opcional)

Para remover os perfis fake depois dos testes:

**Via Firebase Console:**
1. Firestore Database → profiles
2. Selecione os documentos `barber_001` a `barber_007` e `barbershop_001` a `barbershop_003`
3. Delete

**Via Código** (adicione na `SeedScreen`):
```dart
ElevatedButton(
  onPressed: () async {
    for (int i = 1; i <= 7; i++) {
      await firestore.collection('profiles').doc('barber_00$i').delete();
    }
    for (int i = 1; i <= 3; i++) {
      await firestore.collection('profiles').doc('barbershop_00$i').delete();
    }
  },
  child: Text('🗑️ Limpar Perfis Fake'),
)
```

## 📍 Arquivos Criados

1. **lib/src/features/debug/seed_screen.dart** - Tela de seed com UI
2. **scripts/seed_profiles.dart** - Script original (não funciona sem Firebase Admin)
3. **scripts/seed_profiles_http.dart** - Script HTTP (precisa auth)
4. **lib/src/routing/app_router.dart** - Rota `/debug/seed` adicionada

## 🎯 Próximos Passos

Depois de executar o seed:
1. ✅ Testar Discovery com filtros
2. ✅ Testar ordenação (boosted → premium → recent)
3. ✅ Testar swipe/like nos perfis
4. ✅ Testar matches
5. ✅ Verificar cache (5min TTL)
6. ✅ Documentar resultados no `SPRINT1_COMPLETO_FINAL.md`

---

**Criado em**: 2 de novembro de 2025, 18:20  
**Status**: ✅ Pronto para usar  
**Duração estimada**: 5-10 segundos para criar os 10 perfis
