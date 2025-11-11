import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'analytics_service.g.dart';

/// Service para tracking de eventos com Firebase Analytics
/// Foca em monetização premium e conversão de usuários
@Riverpod(keepAlive: true)
AnalyticsService analyticsService(Ref ref) {
  return AnalyticsService();
}

class AnalyticsService {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  /// Observer para GoRouter (tracking de navegação)
  static FirebaseAnalyticsObserver get observer => FirebaseAnalyticsObserver(analytics: _analytics);

  // ========================================
  // PREMIUM FEATURES EVENTS
  // ========================================

  /// 1. Premium screen viewed
  Future<void> logPremiumScreenViewed({
    required String source, // 'navigation' | 'cta' | 'boost_screen' | 'banner'
  }) async {
    await _analytics.logEvent(
      name: 'premium_screen_viewed',
      parameters: {'source': source, 'timestamp': DateTime.now().toIso8601String()},
    );
    print('📊 Analytics: premium_screen_viewed (source: $source)');
  }

  /// 2. Checkout started
  Future<void> logCheckoutStarted({
    required String plan, // 'monthly' | 'yearly'
    required double price,
    String? couponCode,
  }) async {
    await _analytics.logBeginCheckout(
      value: price,
      currency: 'BRL',
      items: [
        AnalyticsEventItem(
          itemId: 'premium_$plan',
          itemName: 'BarberGO Premium ${plan == "monthly" ? "Mensal" : "Anual"}',
          itemCategory: 'subscription',
          price: price,
          quantity: 1,
        ),
      ],
      coupon: couponCode,
    );
    print('📊 Analytics: checkout_started (plan: $plan, price: R\$ $price)');
  }

  /// 3. Checkout completed
  Future<void> logCheckoutCompleted({
    required String plan,
    required double price,
    required String paymentMethod,
    required String transactionId,
    String? couponCode,
  }) async {
    await _analytics.logPurchase(
      currency: 'BRL',
      value: price,
      transactionId: transactionId,
      items: [
        AnalyticsEventItem(
          itemId: 'premium_$plan',
          itemName: 'BarberGO Premium ${plan == "monthly" ? "Mensal" : "Anual"}',
          itemCategory: 'subscription',
          price: price,
          quantity: 1,
        ),
      ],
      coupon: couponCode,
    );

    // Log adicional com mais detalhes
    await _analytics.logEvent(
      name: 'checkout_completed',
      parameters: {
        'plan': plan,
        'price': price,
        'payment_method': paymentMethod,
        'transaction_id': transactionId,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );

    print('📊 Analytics: checkout_completed (plan: $plan, R\$ $price)');
  }

  /// 4. Checkout failed
  Future<void> logCheckoutFailed({
    required String plan,
    required String errorCode,
    required String errorMessage,
  }) async {
    await _analytics.logEvent(
      name: 'checkout_failed',
      parameters: {
        'plan': plan,
        'error_code': errorCode,
        'error_message': errorMessage,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
    print('📊 Analytics: checkout_failed (plan: $plan, error: $errorCode)');
  }

  /// 5. Super Like used
  Future<void> logSuperLikeUsed({
    required String targetId,
    required int superLikesRemaining,
    required bool isPremium,
  }) async {
    await _analytics.logEvent(
      name: 'super_like_used',
      parameters: {
        'target_id': targetId,
        'super_likes_remaining': superLikesRemaining,
        'is_premium': isPremium,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
    print('📊 Analytics: super_like_used (remaining: $superLikesRemaining)');
  }

  /// 6. Boost activated
  Future<void> logBoostActivated({
    required int boostsRemaining,
    required String source, // 'button' | 'screen' | 'auto'
  }) async {
    await _analytics.logEvent(
      name: 'boost_activated',
      parameters: {
        'boosts_remaining': boostsRemaining,
        'source': source,
        'activated_at': DateTime.now().toIso8601String(),
      },
    );
    print('📊 Analytics: boost_activated (remaining: $boostsRemaining)');
  }

  /// 7. Boost expired
  Future<void> logBoostExpired({
    required int duration, // minutos que durou
  }) async {
    await _analytics.logEvent(
      name: 'boost_expired',
      parameters: {'duration_minutes': duration, 'timestamp': DateTime.now().toIso8601String()},
    );
    print('📊 Analytics: boost_expired (duration: ${duration}min)');
  }

  /// 8. Likes received viewed
  Future<void> logLikesReceivedViewed({required int likesCount, required bool isPremium}) async {
    await _analytics.logEvent(
      name: 'likes_received_viewed',
      parameters: {'likes_count': likesCount, 'is_premium': isPremium, 'timestamp': DateTime.now().toIso8601String()},
    );
    print('📊 Analytics: likes_received_viewed (count: $likesCount, premium: $isPremium)');
  }

  /// 9. Subscription cancelled
  Future<void> logSubscriptionCancelled({required String plan, String? reason, int? daysUsed}) async {
    await _analytics.logEvent(
      name: 'subscription_cancelled',
      parameters: {
        'plan': plan,
        'reason': reason ?? 'not_specified',
        'days_used': daysUsed ?? 0,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
    print('📊 Analytics: subscription_cancelled (plan: $plan, reason: $reason)');
  }

  /// 10. Boost screen viewed
  Future<void> logBoostScreenViewed({required String source}) async {
    await _analytics.logEvent(
      name: 'boost_screen_viewed',
      parameters: {'source': source, 'timestamp': DateTime.now().toIso8601String()},
    );
    print('📊 Analytics: boost_screen_viewed (source: $source)');
  }

  /// 11. Boost purchase started
  Future<void> logBoostPurchaseStarted({
    required int quantity, // 5 ou 10
    required double price,
  }) async {
    await _analytics.logBeginCheckout(
      value: price,
      currency: 'BRL',
      items: [
        AnalyticsEventItem(
          itemId: 'boosts_$quantity',
          itemName: '$quantity Boosts',
          itemCategory: 'consumable',
          price: price,
          quantity: 1,
        ),
      ],
    );
    print('📊 Analytics: boost_purchase_started ($quantity boosts, R\$ $price)');
  }

  /// 12. Boost purchase completed
  Future<void> logBoostPurchaseCompleted({
    required int quantity,
    required double price,
    required String transactionId,
  }) async {
    await _analytics.logPurchase(
      currency: 'BRL',
      value: price,
      transactionId: transactionId,
      items: [
        AnalyticsEventItem(
          itemId: 'boosts_$quantity',
          itemName: '$quantity Boosts',
          itemCategory: 'consumable',
          price: price,
          quantity: 1,
        ),
      ],
    );
    print('📊 Analytics: boost_purchase_completed ($quantity boosts, R\$ $price)');
  }

  /// 13. Super Likes purchase started
  Future<void> logSuperLikesPurchaseStarted({required int quantity, required double price}) async {
    await _analytics.logBeginCheckout(
      value: price,
      currency: 'BRL',
      items: [
        AnalyticsEventItem(
          itemId: 'super_likes_$quantity',
          itemName: '$quantity Super Likes',
          itemCategory: 'consumable',
          price: price,
          quantity: 1,
        ),
      ],
    );
    print('📊 Analytics: super_likes_purchase_started ($quantity super likes, R\$ $price)');
  }

  /// 14. Super Likes purchase completed
  Future<void> logSuperLikesPurchaseCompleted({
    required int quantity,
    required double price,
    required String transactionId,
  }) async {
    await _analytics.logPurchase(
      currency: 'BRL',
      value: price,
      transactionId: transactionId,
      items: [
        AnalyticsEventItem(
          itemId: 'super_likes_$quantity',
          itemName: '$quantity Super Likes',
          itemCategory: 'consumable',
          price: price,
          quantity: 1,
        ),
      ],
    );
    print('📊 Analytics: super_likes_purchase_completed ($quantity super likes, R\$ $price)');
  }

  // ========================================
  // USER PROPERTIES
  // ========================================

  /// Set user properties (chamado ao login ou mudança de premium)
  Future<void> setUserProperties({
    required String userId,
    required bool isPremium,
    String? subscriptionPlan,
    int? superLikesRemaining,
    int? boostsRemaining,
  }) async {
    await _analytics.setUserId(id: userId);

    await _analytics.setUserProperty(name: 'is_premium', value: isPremium.toString());

    if (subscriptionPlan != null) {
      await _analytics.setUserProperty(name: 'subscription_plan', value: subscriptionPlan);
    }

    if (superLikesRemaining != null) {
      await _analytics.setUserProperty(name: 'super_likes_remaining', value: superLikesRemaining.toString());
    }

    if (boostsRemaining != null) {
      await _analytics.setUserProperty(name: 'boosts_remaining', value: boostsRemaining.toString());
    }

    print('📊 Analytics: User properties updated (premium: $isPremium)');
  }

  // ========================================
  // CONVERSION FUNNEL
  // ========================================

  /// Step 1: User saw premium CTA
  Future<void> logPremiumCtaViewed({
    required String ctaLocation, // 'banner' | 'modal' | 'screen'
    required String ctaType, // 'upgrade' | 'unlock_feature' | 'trial'
  }) async {
    await _analytics.logEvent(
      name: 'premium_cta_viewed',
      parameters: {'cta_location': ctaLocation, 'cta_type': ctaType, 'timestamp': DateTime.now().toIso8601String()},
    );
  }

  /// Step 2: User clicked premium CTA
  Future<void> logPremiumCtaClicked({required String ctaLocation, required String ctaType}) async {
    await _analytics.logEvent(
      name: 'premium_cta_clicked',
      parameters: {'cta_location': ctaLocation, 'cta_type': ctaType, 'timestamp': DateTime.now().toIso8601String()},
    );
  }

  /// Step 3: User selected a plan
  Future<void> logPlanSelected({required String plan, required double price}) async {
    await _analytics.logEvent(
      name: 'plan_selected',
      parameters: {'plan': plan, 'price': price, 'timestamp': DateTime.now().toIso8601String()},
    );
  }

  // ========================================
  // ENGAGEMENT METRICS
  // ========================================

  /// Track feature usage
  Future<void> logFeatureUsed({required String featureName, required bool isPremiumFeature}) async {
    await _analytics.logEvent(
      name: 'feature_used',
      parameters: {
        'feature_name': featureName,
        'is_premium_feature': isPremiumFeature,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track session duration
  Future<void> logSessionStart() async {
    await _analytics.logEvent(name: 'session_start');
  }

  Future<void> logSessionEnd({required int durationSeconds}) async {
    await _analytics.logEvent(name: 'session_end', parameters: {'duration_seconds': durationSeconds});
  }
}
