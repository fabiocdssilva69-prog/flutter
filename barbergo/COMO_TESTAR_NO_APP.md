# 🚀 COMO TESTAR NO APP FLUTTER

## Método 1: Adicionar Rota (Recomendado)

### Passo 1: Adicionar dependência (se ainda não tiver)

```yaml
# pubspec.yaml
dependencies:
  url_launcher: ^6.2.0  # Para abrir URLs do Stripe
```

```bash
flutter pub get
```

### Passo 2: Adicionar rota no seu app

**Se você usa rotas nomeadas:**

```dart
// main.dart ou routes.dart
import 'screens/test_payment_screen.dart';

MaterialApp(
  routes: {
    '/test-payments': (context) => TestPaymentScreen(),
    // ... outras rotas
  },
)
```

**Se você usa navegação direta:**

```dart
import 'screens/test_payment_screen.dart';

// De qualquer lugar do app
Navigator.push(
  context,
  MaterialPageRoute(builder: (_) => TestPaymentScreen()),
);
```

### Passo 3: Criar botão de acesso temporário

**Adicione em alguma tela (ex: Settings, Profile, Home):**

```dart
// REMOVER EM PRODUÇÃO!
if (kDebugMode) {  // Só aparece em modo debug
  ElevatedButton(
    onPressed: () => Navigator.pushNamed(context, '/test-payments'),
    style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
    child: Text('🧪 Testar Pagamentos (DEV)'),
  ),
}
```

---

## Método 2: Teste Rápido via Main

**Temporariamente, altere o `main.dart`:**

```dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/test_payment_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BarberGO Test',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: TestPaymentScreen(),  // ← Rota de teste temporária
    );
  }
}
```

**Execute:**
```bash
flutter run
```

---

## Método 3: Teste sem UI (Console)

**Crie um script de teste:**

```dart
// test/stripe_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import '../lib/services/stripe_service.dart';
import '../lib/config/stripe_config.dart';

void main() {
  setUpAll(() async {
    await Firebase.initializeApp();
  });

  test('Criar checkout session Premium Mensal', () async {
    final service = StripeService();
    
    final url = await service.createCheckoutSession(
      priceId: StripeConfig.premiumMonthly,
      mode: 'subscription',
    );
    
    expect(url, isNotNull);
    expect(url, contains('checkout.stripe.com'));
    
    print('✅ Checkout URL criada: $url');
  });

  test('Criar checkout session 5 Boosts', () async {
    final service = StripeService();
    
    final url = await service.createCheckoutSession(
      priceId: StripeConfig.boosts5,
      mode: 'payment',
    );
    
    expect(url, isNotNull);
    print('✅ Checkout URL criada: $url');
  });
}
```

**Execute:**
```bash
flutter test test/stripe_test.dart
```

---

## 📱 FLUXO COMPLETO NO APP

### Quando o app abre a TestPaymentScreen:

```
1. App mostra 4 produtos disponíveis
   ├── Premium Mensal (R$ 19,90/mês)
   ├── Premium Anual (R$ 191,04/ano)
   ├── 5 Boosts (R$ 9,90)
   └── 10 Super Likes (R$ 8,90)

2. Usuário clica em um produto
   └── App chama StripeService.createCheckoutSession()
       └── Firestore cria documento em customers/{uid}/checkout_sessions
           └── Extensão Firebase popula campo 'url'
               └── App recebe URL

3. App abre URL no navegador
   └── url_launcher abre: https://checkout.stripe.com/...
       └── Usuário completa pagamento
           └── Stripe redireciona para success_url ou cancel_url

4. Webhook processa evento
   └── Cloud Function stripeWebhook recebe:
       ├── checkout.session.completed
       ├── customer.subscription.created (se assinatura)
       └── invoice.payment_succeeded
           └── Atualiza Firestore
               └── customers/{uid}/subscriptions/{sub_id}
                   └── App detecta via subscriptionStatusStream()
                       └── UI atualiza automaticamente
```

---

## ✅ CHECKLIST DE INTEGRAÇÃO

- [ ] ✅ `url_launcher` adicionado ao pubspec.yaml
- [ ] ✅ `test_payment_screen.dart` copiado para `lib/screens/`
- [ ] ✅ Rota adicionada ao app
- [ ] ✅ Firebase inicializado no main.dart
- [ ] ✅ Usuário autenticado (FirebaseAuth.instance.currentUser != null)
- [ ] ✅ Internet disponível
- [ ] ✅ App rodando: `flutter run`

---

## 🎯 TESTE RÁPIDO (2 MINUTOS)

```bash
# 1. Instalar dependência
flutter pub add url_launcher

# 2. Rodar app
flutter run

# 3. Navegar para tela de teste
# (use o botão que você adicionou)

# 4. Clicar em "Premium Mensal"

# 5. Completar pagamento com:
#    Cartão: 4242 4242 4242 4242
#    Data: 12/34
#    CVV: 123

# 6. Verificar no Firestore:
#    customers/{uid}/subscriptions
#    → Deve ter 1 documento com status: "active"
```

---

## 🎨 EXEMPLO DE INTEGRAÇÃO VISUAL

**Adicionar botão na HomeScreen:**

```dart
// lib/screens/home_screen.dart
import 'package:flutter/foundation.dart';
import '../screens/test_payment_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('BarberGO')),
      body: Column(
        children: [
          // ... seu conteúdo normal
          
          // BOTÃO DE TESTE (remover em produção)
          if (kDebugMode)
            Container(
              padding: EdgeInsets.all(16),
              color: Colors.orange.shade100,
              child: Row(
                children: [
                  Icon(Icons.science, color: Colors.orange),
                  SizedBox(width: 8),
                  Text('Modo Desenvolvimento'),
                  Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TestPaymentScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                    child: Text('🧪 Testar Pagamentos'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
```

---

## 🔥 PRÓXIMO PASSO

Após validar que tudo funciona, podemos criar:

### Opção A: UI Premium Real (2-3 dias)

```
✅ Tela de Premium com design profissional
✅ Modal de seleção de plano (Mensal vs Anual)
✅ Badge premium no perfil
✅ Recursos premium funcionais:
   - Ver quem curtiu você
   - Super Likes ilimitados
   - Boost
```

### Opção B: Continuar com Testes

```
✅ Testar assinatura mensal
✅ Testar assinatura anual
✅ Testar compra de boosts
✅ Testar compra de super likes
✅ Verificar webhooks
✅ Verificar Firestore
```

**Me avise quando conseguir rodar a tela de teste! 🚀**
