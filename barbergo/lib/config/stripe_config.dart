/// Configurações do Stripe para BarberGO
///
/// Este arquivo contém todos os Price IDs e configurações necessárias
/// para integração com o Stripe Payments.
class StripeConfig {
  // ============================================
  // PRICE IDs - Produtos Stripe
  // ============================================

  /// Premium Mensal - R$ 19,90/mês
  /// Tipo: Assinatura recorrente
  static const String premiumMonthly = 'price_1SOktGLOjlvmVFrXmpINUDN4';

  /// Premium Anual - R$ 191,04/ano (16% desconto)
  /// Tipo: Assinatura recorrente
  static const String premiumYearly = 'price_1SOkvnLOjlvmVFrXKGBgR6Jg';

  /// 5 Boosts - R$ 9,90
  /// Tipo: Compra única
  static const String boosts5 = 'price_1SOkxNLOjlvmVFrXQlNv9kyI';

  /// 10 Super Likes - R$ 8,90
  /// Tipo: Compra única
  static const String superLikes10 = 'price_1SOkztLOjlvmVFrXpqTIoa7w';

  // ============================================
  // API Keys
  // ============================================

  /// Publishable Key (Safe to use in client-side code)
  /// Esta chave é segura para usar no código do app
  static const String publishableKey =
      'pk_test_51SOisVLOjlvmVFrXdULKMqqOH4PeNabglEKai1bnxnXlpWRdtZ9j07RhyE7O0KBHP8vKj7hLRjTvVE5fKOS7beTH001jZNaqra';

  // ============================================
  // URLs
  // ============================================

  /// URL de sucesso após pagamento
  static const String successUrl = 'https://barbergo.app/payment-success';

  /// URL de cancelamento
  static const String cancelUrl = 'https://barbergo.app/payment-cancel';

  // ============================================
  // Helpers
  // ============================================

  /// Retorna o modo de pagamento baseado no priceId
  static String getPaymentMode(String priceId) {
    if (priceId == premiumMonthly || priceId == premiumYearly) {
      return 'subscription';
    }
    return 'payment'; // one-time payment
  }

  /// Retorna o nome do produto baseado no priceId
  static String getProductName(String priceId) {
    switch (priceId) {
      case premiumMonthly:
        return 'Premium Mensal';
      case premiumYearly:
        return 'Premium Anual';
      case boosts5:
        return '5 Boosts';
      case superLikes10:
        return '10 Super Likes';
      default:
        return 'Produto Desconhecido';
    }
  }

  /// Retorna o preço formatado baseado no priceId
  static String getFormattedPrice(String priceId) {
    switch (priceId) {
      case premiumMonthly:
        return 'R\$ 19,90/mês';
      case premiumYearly:
        return 'R\$ 191,04/ano';
      case boosts5:
        return 'R\$ 9,90';
      case superLikes10:
        return 'R\$ 8,90';
      default:
        return 'R\$ -';
    }
  }
}
