import 'package:dart_mappable/dart_mappable.dart';

part 'in_app_purchase.g.dart';

/// Entity para In-App Purchases (Phase 4 - Feature 2/6)
/// Sistema de compras dentro do app
@MappableClass()
class InAppPurchase with InAppPurchaseMappable {
  final String purchaseId;
  final String userId;
  final PurchaseableProduct product;
  final PurchaseStatus status;
  final double amount;
  final String currency;
  final String? paymentProvider; // stripe, google_play, app_store
  final String? transactionId;
  final String? receiptData;
  final DateTime purchaseDate;
  final DateTime? consumedAt;
  final DateTime createdAt;
  
  const InAppPurchase({
    required this.purchaseId,
    required this.userId,
    required this.product,
    required this.status,
    required this.amount,
    this.currency = 'BRL',
    this.paymentProvider,
    this.transactionId,
    this.receiptData,
    required this.purchaseDate,
    this.consumedAt,
    required this.createdAt,
  });

  /// Verificar se foi consumido
  bool get isConsumed => consumedAt != null;

  /// Verificar se está pendente
  bool get isPending => status == PurchaseStatus.pending;

  /// Verificar se foi bem-sucedido
  bool get isCompleted => status == PurchaseStatus.completed;
}

/// Status da compra
enum PurchaseStatus {
  pending,      // Pendente
  completed,    // Completa
  failed,       // Falhou
  cancelled,    // Cancelada
  refunded,     // Reembolsada
}

/// Produto comprável
@MappableClass()
class PurchaseableProduct with PurchaseableProductMappable {
  final String productId;
  final String name;
  final String description;
  final ProductType type;
  final double price;
  final String currency;
  final String? sku; // Store SKU
  final ProductReward reward;
  final bool isAvailable;
  final DateTime createdAt;
  
  const PurchaseableProduct({
    required this.productId,
    required this.name,
    required this.description,
    required this.type,
    required this.price,
    this.currency = 'BRL',
    this.sku,
    required this.reward,
    this.isAvailable = true,
    required this.createdAt,
  });
}

/// Tipo de produto
enum ProductType {
  consumable,       // Consumível (pode ser comprado múltiplas vezes)
  nonConsumable,    // Não consumível (compra única)
  subscription,     // Assinatura (gerenciada separadamente)
}

/// Recompensa do produto
@MappableClass()
class ProductReward with ProductRewardMappable {
  final RewardType type;
  final int quantity;
  final String? description;
  final Duration? duration; // Para itens temporários
  
  const ProductReward({
    required this.type,
    required this.quantity,
    this.description,
    this.duration,
  });
}

/// Tipos de recompensa
enum RewardType {
  superLikes,       // Super Likes
  boosts,           // Profile Boosts
  coins,            // Moedas virtuais
  premiumTime,      // Tempo de premium
  rewinds,          // Desfazer swipes
  spotlights,       // Spotlight (destaque)
  gifts,            // Presentes virtuais
}

/// Pacote de produtos (bundle)
@MappableClass()
class ProductBundle with ProductBundleMappable {
  final String bundleId;
  final String name;
  final String description;
  final List<PurchaseableProduct> products;
  final double originalPrice;
  final double bundlePrice;
  final bool isLimitedTime;
  final DateTime? expiresAt;
  
  const ProductBundle({
    required this.bundleId,
    required this.name,
    required this.description,
    required this.products,
    required this.originalPrice,
    required this.bundlePrice,
    this.isLimitedTime = false,
    this.expiresAt,
  });

  /// Desconto em porcentagem
  double get discountPercent {
    if (originalPrice == 0) return 0;
    return ((originalPrice - bundlePrice) / originalPrice) * 100;
  }

  /// Verificar se está válido
  bool get isValid {
    if (!isLimitedTime) return true;
    if (expiresAt == null) return true;
    return DateTime.now().isBefore(expiresAt!);
  }
}

/// Carrinho de compras
@MappableClass()
class ShoppingCart with ShoppingCartMappable {
  final String cartId;
  final String userId;
  final List<CartItem> items;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  const ShoppingCart({
    required this.cartId,
    required this.userId,
    required this.items,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Total do carrinho
  double get total => items.fold(0, (sum, item) => sum + item.totalPrice);

  /// Quantidade total de itens
  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);
}

/// Item do carrinho
@MappableClass()
class CartItem with CartItemMappable {
  final String itemId;
  final PurchaseableProduct product;
  final int quantity;
  
  const CartItem({
    required this.itemId,
    required this.product,
    required this.quantity,
  });

  /// Preço total do item
  double get totalPrice => product.price * quantity;
}

/// Transação de pagamento
@MappableClass()
class PaymentTransaction with PaymentTransactionMappable {
  final String transactionId;
  final String userId;
  final PaymentMethod method;
  final double amount;
  final String currency;
  final PaymentStatus status;
  final String? providerTransactionId;
  final String? errorMessage;
  final List<String> purchaseIds; // IDs das compras relacionadas
  final DateTime createdAt;
  final DateTime? completedAt;
  
  const PaymentTransaction({
    required this.transactionId,
    required this.userId,
    required this.method,
    required this.amount,
    this.currency = 'BRL',
    required this.status,
    this.providerTransactionId,
    this.errorMessage,
    required this.purchaseIds,
    required this.createdAt,
    this.completedAt,
  });
}

/// Método de pagamento
enum PaymentMethod {
  creditCard,       // Cartão de crédito
  debitCard,        // Cartão de débito
  pix,              // PIX
  googlePay,        // Google Pay
  applePay,         // Apple Pay
  paypal,           // PayPal
  storeCredit,      // Crédito da loja
}

/// Status do pagamento
enum PaymentStatus {
  pending,          // Pendente
  processing,       // Processando
  completed,        // Completo
  failed,           // Falhou
  refunded,         // Reembolsado
  cancelled,        // Cancelado
}

/// Histórico de compras do usuário
@MappableClass()
class PurchaseHistory with PurchaseHistoryMappable {
  final String userId;
  final List<InAppPurchase> purchases;
  final double totalSpent;
  final int totalPurchases;
  final DateTime firstPurchaseDate;
  final DateTime? lastPurchaseDate;
  final Map<RewardType, int> rewardsSummary;
  
  const PurchaseHistory({
    required this.userId,
    required this.purchases,
    required this.totalSpent,
    required this.totalPurchases,
    required this.firstPurchaseDate,
    this.lastPurchaseDate,
    required this.rewardsSummary,
  });
}

/// Inventory de itens comprados (wallet)
@MappableClass()
class UserInventory with UserInventoryMappable {
  final String userId;
  final Map<RewardType, int> balance; // tipo -> quantidade
  final List<InventoryItem> items;
  final DateTime updatedAt;
  
  const UserInventory({
    required this.userId,
    required this.balance,
    required this.items,
    required this.updatedAt,
  });

  /// Obter saldo de um tipo específico
  int getBalance(RewardType type) => balance[type] ?? 0;

  /// Verificar se tem quantidade suficiente
  bool hasEnough(RewardType type, int quantity) {
    return getBalance(type) >= quantity;
  }
}

/// Item no inventário
@MappableClass()
class InventoryItem with InventoryItemMappable {
  final String itemId;
  final RewardType type;
  final int quantity;
  final DateTime acquiredAt;
  final DateTime? expiresAt;
  final bool isExpired;
  
  const InventoryItem({
    required this.itemId,
    required this.type,
    required this.quantity,
    required this.acquiredAt,
    this.expiresAt,
    this.isExpired = false,
  });

  /// Verificar se expirou
  bool get hasExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }
}

/// Promoção de produto
@MappableClass()
class ProductPromotion with ProductPromotionMappable {
  final String promotionId;
  final String title;
  final String description;
  final List<String> productIds;
  final double discountPercent;
  final DateTime validFrom;
  final DateTime validUntil;
  final bool isActive;
  
  const ProductPromotion({
    required this.promotionId,
    required this.title,
    required this.description,
    required this.productIds,
    required this.discountPercent,
    required this.validFrom,
    required this.validUntil,
    this.isActive = true,
  });

  /// Verificar se está válida
  bool get isValid {
    if (!isActive) return false;
    final now = DateTime.now();
    return now.isAfter(validFrom) && now.isBefore(validUntil);
  }

  /// Calcular preço com desconto
  double calculateDiscountedPrice(double originalPrice) {
    return originalPrice * (1 - discountPercent / 100);
  }
}

/// Request para processar compra
@MappableClass()
class ProcessPurchaseRequest with ProcessPurchaseRequestMappable {
  final String userId;
  final String productId;
  final int quantity;
  final PaymentMethod paymentMethod;
  final String? promotionCode;
  
  const ProcessPurchaseRequest({
    required this.userId,
    required this.productId,
    this.quantity = 1,
    required this.paymentMethod,
    this.promotionCode,
  });
}

/// Estatísticas de compras
@MappableClass()
class PurchaseStats with PurchaseStatsMappable {
  final int totalPurchases;
  final double totalRevenue;
  final Map<ProductType, int> purchasesByType;
  final Map<RewardType, int> rewardsDistribution;
  final List<PurchaseableProduct> topSellingProducts;
  final double averageTransactionValue;
  final DateTime generatedAt;
  
  const PurchaseStats({
    required this.totalPurchases,
    required this.totalRevenue,
    required this.purchasesByType,
    required this.rewardsDistribution,
    required this.topSellingProducts,
    required this.averageTransactionValue,
    required this.generatedAt,
  });
}
