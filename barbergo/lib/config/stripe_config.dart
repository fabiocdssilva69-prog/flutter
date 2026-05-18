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

  // ============================================
  // SILVER & GOLD - Sistema de Selos Premium
  // ============================================

  /// Silver Mensal - R$ 14,90/mês
  /// Selo de verificação Silver + benefícios (PRODUÇÃO)
  static const String silverMonthly = 'price_1ShGe4Pru6X3lyL9EYUlrwuz';

  /// Silver Anual - R$ 149,90/ano (17% desconto)
  /// Selo de verificação Silver + benefícios
  static const String silverYearly = 'price_1ShGe4Pru6X3lyL9z8DSuDMD';

  /// Gold Mensal - R$ 29,90/mês
  /// Selo de verificação Gold + todos benefícios
  static const String goldMonthly = 'price_1ShGe3Pru6X3lyL9tvExYkyc';

  /// Gold Anual - R$ 249,90/ano (30% desconto)
  /// Selo de verificação Gold + todos benefícios
  static const String goldYearly = 'price_1ShGe3Pru6X3lyL97BKkZ2yH';

  /// 5 Boosts - R$ 9,90
  /// Tipo: Compra única
  static const String boosts5 = 'price_1ShGe2Pru6X3lyL9rNLIbjDx';

  /// 10 Boosts - R$ 9,90
  /// Tipo: Compra única
  /// Product ID: prod_TeZnV56ASqVguH
  static const String boosts10 = 'price_1ShGe3Pru6X3lyL9B0MVE8Fv';

  /// 20 Boosts - R$ 17,90
  /// Tipo: Compra única
  /// Product ID: prod_TeZnqFPk9eRlGN
  static const String boosts20 = 'price_1ShGe2Pru6X3lyL90Rb0xJMD';

  /// 10 Super Likes - R$ 8,90
  /// Tipo: Compra única
  static const String superLikes10 = 'price_1ShGe1Pru6X3lyL9uyCNuWqL';

  /// 20 Super Likes - R$ 9,90
  /// Tipo: Compra única
  /// Product ID: prod_TeZnsjlfdstPBa
  static const String superLikes20 = 'price_1ShGe2Pru6X3lyL9kwLldKir';

  /// 50 Super Likes - R$ 19,90
  /// Tipo: Compra única
  /// Product ID: prod_TeZnKMD8XbhquO
  static const String superLikes50 = 'price_1ShGe2Pru6X3lyL9w9mlMEGO';

  // ============================================
  // API Keys
  // ============================================

  /// Publishable Key (Safe to use in client-side code)
  /// Esta chave é segura para usar no código do app
  static const String publishableKey =
      'pk_test_51SOisVLOjlvmVFrXdULKMqqOH4PeNabglE6YpQ9yJf8RvK5j2xF3wN1mH7dC4bL9tS8aG6vR5pT0eZ2qK1iJ3uM00sVpXyZwQ';

  // ============================================
  // PAYMENT LINKS - URLs diretas de checkout
  // ============================================

  /// Payment Links configurados no Stripe Dashboard
  /// Esses links servem como fallback quando a extensão Firebase não responde

  // Badges
  static const String paymentLinkSilverMonthly = 'https://buy.stripe.com/aFa28t3wN274gbFczCak00b'; // R$ 14,90/mês
  static const String paymentLinkSilverYearly = 'https://buy.stripe.com/7sYaEZ9Vb130f7B6beak00a'; // R$ 149,90/ano
  static const String paymentLinkGoldMonthly = 'https://buy.stripe.com/8x28wR1oF4fc9Nh6beak00c'; // R$ 29,90/mês
  static const String paymentLinkGoldYearly = 'https://buy.stripe.com/6oU7sNebreTQgbF7fiak00d'; // R$ 249,90/ano

  // Boosts
  static const String paymentLinkBoosts5 = 'https://buy.stripe.com/9B68wR1oFcLIe3x7fiak00t'; // R$ 4,90
  static const String paymentLinkBoosts10 = 'https://buy.stripe.com/fZu00laZfeTQ3oTgPSak00s'; // R$ 9,90
  static const String paymentLinkBoosts20 = 'https://buy.stripe.com/4gMaEZc3j5jg0cH9nqak00f'; // R$ 17,90

  // Super Likes
  static const String paymentLinkSuperLikes10 = 'https://buy.stripe.com/5kQdRbebrfXUf7BczCak00j'; // R$ 8,90
  static const String paymentLinkSuperLikes20 = 'https://buy.stripe.com/3cI5kF5EVh1YaRl7fiak00h'; // R$ 9,90
  static const String paymentLinkSuperLikes50 = 'https://buy.stripe.com/7sYbJ35EV130bVpczCak00i'; // R$ 19,90

  // Magic Match 🪄
  static const String paymentLinkMagicMatch3 = 'https://buy.stripe.com/6oU3cx6IZ8vs3oT8jmak00l'; // R$ 4,90
  static const String paymentLinkMagicMatch10 = 'https://buy.stripe.com/00w28t3wN7ro1gLczCak00m'; // R$ 11,90
  static const String paymentLinkMagicMatch25 = 'https://buy.stripe.com/eVq5kF7N37ro4sX0QUak00n'; // R$ 19,90

  // Replay ↩️
  static const String paymentLinkReplay10 = 'https://buy.stripe.com/3cIbJ3ffvh1Y2kP9nqak00o'; // R$ 4,90
  static const String paymentLinkReplay20 = 'https://buy.stripe.com/dRm8wR4AReTQ5x19nqak00q'; // R$ 9,90
  static const String paymentLinkReplay50 = 'https://buy.stripe.com/7sYaEZebr5jg6B5eHKak00p'; // R$ 19,90

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
    if (priceId == premiumMonthly ||
        priceId == premiumYearly ||
        priceId == silverMonthly ||
        priceId == silverYearly ||
        priceId == goldMonthly ||
        priceId == goldYearly) {
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
      case silverMonthly:
        return 'Selo Silver Mensal';
      case silverYearly:
        return 'Selo Silver Anual';
      case goldMonthly:
        return 'Selo Gold Mensal';
      case goldYearly:
        return 'Selo Gold Anual';
      case boosts5:
        return '5 Boosts';
      case boosts10:
        return '10 Boosts';
      case boosts20:
        return '20 Boosts';
      case superLikes10:
        return '10 Super Likes';
      case superLikes20:
        return '20 Super Likes';
      case superLikes50:
        return '50 Super Likes';
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
      case silverMonthly:
        return 'R\$ 14,90/mês';
      case silverYearly:
        return 'R\$ 149,90/ano';
      case goldMonthly:
        return 'R\$ 29,90/mês';
      case goldYearly:
        return 'R\$ 249,90/ano';
      case boosts5:
        return 'R\$ 9,90';
      case boosts10:
        return 'R\$ 9,90';
      case boosts20:
        return 'R\$ 17,90';
      case superLikes10:
        return 'R\$ 8,90';
      case superLikes20:
        return 'R\$ 9,90';
      case superLikes50:
        return 'R\$ 19,90';
      default:
        return 'R\$ -';
    }
  }
}
