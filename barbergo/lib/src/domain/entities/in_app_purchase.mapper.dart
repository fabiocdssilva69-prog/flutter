// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'in_app_purchase.dart';

class InAppPurchaseMapper extends ClassMapperBase<InAppPurchase> {
  InAppPurchaseMapper._();

  static InAppPurchaseMapper? _instance;
  static InAppPurchaseMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = InAppPurchaseMapper._());
      PurchaseableProductMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'InAppPurchase';

  static String _$purchaseId(InAppPurchase v) => v.purchaseId;
  static const Field<InAppPurchase, String> _f$purchaseId = Field(
    'purchaseId',
    _$purchaseId,
  );
  static String _$userId(InAppPurchase v) => v.userId;
  static const Field<InAppPurchase, String> _f$userId = Field(
    'userId',
    _$userId,
  );
  static PurchaseableProduct _$product(InAppPurchase v) => v.product;
  static const Field<InAppPurchase, PurchaseableProduct> _f$product = Field(
    'product',
    _$product,
  );
  static PurchaseStatus _$status(InAppPurchase v) => v.status;
  static const Field<InAppPurchase, PurchaseStatus> _f$status = Field(
    'status',
    _$status,
  );
  static double _$amount(InAppPurchase v) => v.amount;
  static const Field<InAppPurchase, double> _f$amount = Field(
    'amount',
    _$amount,
  );
  static String _$currency(InAppPurchase v) => v.currency;
  static const Field<InAppPurchase, String> _f$currency = Field(
    'currency',
    _$currency,
    opt: true,
    def: 'BRL',
  );
  static String? _$paymentProvider(InAppPurchase v) => v.paymentProvider;
  static const Field<InAppPurchase, String> _f$paymentProvider = Field(
    'paymentProvider',
    _$paymentProvider,
    opt: true,
  );
  static String? _$transactionId(InAppPurchase v) => v.transactionId;
  static const Field<InAppPurchase, String> _f$transactionId = Field(
    'transactionId',
    _$transactionId,
    opt: true,
  );
  static String? _$receiptData(InAppPurchase v) => v.receiptData;
  static const Field<InAppPurchase, String> _f$receiptData = Field(
    'receiptData',
    _$receiptData,
    opt: true,
  );
  static DateTime _$purchaseDate(InAppPurchase v) => v.purchaseDate;
  static const Field<InAppPurchase, DateTime> _f$purchaseDate = Field(
    'purchaseDate',
    _$purchaseDate,
  );
  static DateTime? _$consumedAt(InAppPurchase v) => v.consumedAt;
  static const Field<InAppPurchase, DateTime> _f$consumedAt = Field(
    'consumedAt',
    _$consumedAt,
    opt: true,
  );
  static DateTime _$createdAt(InAppPurchase v) => v.createdAt;
  static const Field<InAppPurchase, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
  );
  static bool _$isConsumed(InAppPurchase v) => v.isConsumed;
  static const Field<InAppPurchase, bool> _f$isConsumed = Field(
    'isConsumed',
    _$isConsumed,
    mode: FieldMode.member,
  );
  static bool _$isPending(InAppPurchase v) => v.isPending;
  static const Field<InAppPurchase, bool> _f$isPending = Field(
    'isPending',
    _$isPending,
    mode: FieldMode.member,
  );
  static bool _$isCompleted(InAppPurchase v) => v.isCompleted;
  static const Field<InAppPurchase, bool> _f$isCompleted = Field(
    'isCompleted',
    _$isCompleted,
    mode: FieldMode.member,
  );

  @override
  final MappableFields<InAppPurchase> fields = const {
    #purchaseId: _f$purchaseId,
    #userId: _f$userId,
    #product: _f$product,
    #status: _f$status,
    #amount: _f$amount,
    #currency: _f$currency,
    #paymentProvider: _f$paymentProvider,
    #transactionId: _f$transactionId,
    #receiptData: _f$receiptData,
    #purchaseDate: _f$purchaseDate,
    #consumedAt: _f$consumedAt,
    #createdAt: _f$createdAt,
    #isConsumed: _f$isConsumed,
    #isPending: _f$isPending,
    #isCompleted: _f$isCompleted,
  };

  static InAppPurchase _instantiate(DecodingData data) {
    return InAppPurchase(
      purchaseId: data.dec(_f$purchaseId),
      userId: data.dec(_f$userId),
      product: data.dec(_f$product),
      status: data.dec(_f$status),
      amount: data.dec(_f$amount),
      currency: data.dec(_f$currency),
      paymentProvider: data.dec(_f$paymentProvider),
      transactionId: data.dec(_f$transactionId),
      receiptData: data.dec(_f$receiptData),
      purchaseDate: data.dec(_f$purchaseDate),
      consumedAt: data.dec(_f$consumedAt),
      createdAt: data.dec(_f$createdAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static InAppPurchase fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<InAppPurchase>(map);
  }

  static InAppPurchase fromJson(String json) {
    return ensureInitialized().decodeJson<InAppPurchase>(json);
  }
}

mixin InAppPurchaseMappable {
  String toJson() {
    return InAppPurchaseMapper.ensureInitialized().encodeJson<InAppPurchase>(
      this as InAppPurchase,
    );
  }

  Map<String, dynamic> toMap() {
    return InAppPurchaseMapper.ensureInitialized().encodeMap<InAppPurchase>(
      this as InAppPurchase,
    );
  }

  InAppPurchaseCopyWith<InAppPurchase, InAppPurchase, InAppPurchase>
  get copyWith => _InAppPurchaseCopyWithImpl<InAppPurchase, InAppPurchase>(
    this as InAppPurchase,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return InAppPurchaseMapper.ensureInitialized().stringifyValue(
      this as InAppPurchase,
    );
  }

  @override
  bool operator ==(Object other) {
    return InAppPurchaseMapper.ensureInitialized().equalsValue(
      this as InAppPurchase,
      other,
    );
  }

  @override
  int get hashCode {
    return InAppPurchaseMapper.ensureInitialized().hashValue(
      this as InAppPurchase,
    );
  }
}

extension InAppPurchaseValueCopy<$R, $Out>
    on ObjectCopyWith<$R, InAppPurchase, $Out> {
  InAppPurchaseCopyWith<$R, InAppPurchase, $Out> get $asInAppPurchase =>
      $base.as((v, t, t2) => _InAppPurchaseCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class InAppPurchaseCopyWith<$R, $In extends InAppPurchase, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  PurchaseableProductCopyWith<$R, PurchaseableProduct, PurchaseableProduct>
  get product;
  $R call({
    String? purchaseId,
    String? userId,
    PurchaseableProduct? product,
    PurchaseStatus? status,
    double? amount,
    String? currency,
    String? paymentProvider,
    String? transactionId,
    String? receiptData,
    DateTime? purchaseDate,
    DateTime? consumedAt,
    DateTime? createdAt,
  });
  InAppPurchaseCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _InAppPurchaseCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, InAppPurchase, $Out>
    implements InAppPurchaseCopyWith<$R, InAppPurchase, $Out> {
  _InAppPurchaseCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<InAppPurchase> $mapper =
      InAppPurchaseMapper.ensureInitialized();
  @override
  PurchaseableProductCopyWith<$R, PurchaseableProduct, PurchaseableProduct>
  get product => $value.product.copyWith.$chain((v) => call(product: v));
  @override
  $R call({
    String? purchaseId,
    String? userId,
    PurchaseableProduct? product,
    PurchaseStatus? status,
    double? amount,
    String? currency,
    Object? paymentProvider = $none,
    Object? transactionId = $none,
    Object? receiptData = $none,
    DateTime? purchaseDate,
    Object? consumedAt = $none,
    DateTime? createdAt,
  }) => $apply(
    FieldCopyWithData({
      if (purchaseId != null) #purchaseId: purchaseId,
      if (userId != null) #userId: userId,
      if (product != null) #product: product,
      if (status != null) #status: status,
      if (amount != null) #amount: amount,
      if (currency != null) #currency: currency,
      if (paymentProvider != $none) #paymentProvider: paymentProvider,
      if (transactionId != $none) #transactionId: transactionId,
      if (receiptData != $none) #receiptData: receiptData,
      if (purchaseDate != null) #purchaseDate: purchaseDate,
      if (consumedAt != $none) #consumedAt: consumedAt,
      if (createdAt != null) #createdAt: createdAt,
    }),
  );
  @override
  InAppPurchase $make(CopyWithData data) => InAppPurchase(
    purchaseId: data.get(#purchaseId, or: $value.purchaseId),
    userId: data.get(#userId, or: $value.userId),
    product: data.get(#product, or: $value.product),
    status: data.get(#status, or: $value.status),
    amount: data.get(#amount, or: $value.amount),
    currency: data.get(#currency, or: $value.currency),
    paymentProvider: data.get(#paymentProvider, or: $value.paymentProvider),
    transactionId: data.get(#transactionId, or: $value.transactionId),
    receiptData: data.get(#receiptData, or: $value.receiptData),
    purchaseDate: data.get(#purchaseDate, or: $value.purchaseDate),
    consumedAt: data.get(#consumedAt, or: $value.consumedAt),
    createdAt: data.get(#createdAt, or: $value.createdAt),
  );

  @override
  InAppPurchaseCopyWith<$R2, InAppPurchase, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _InAppPurchaseCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class PurchaseableProductMapper extends ClassMapperBase<PurchaseableProduct> {
  PurchaseableProductMapper._();

  static PurchaseableProductMapper? _instance;
  static PurchaseableProductMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PurchaseableProductMapper._());
      ProductRewardMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'PurchaseableProduct';

  static String _$productId(PurchaseableProduct v) => v.productId;
  static const Field<PurchaseableProduct, String> _f$productId = Field(
    'productId',
    _$productId,
  );
  static String _$name(PurchaseableProduct v) => v.name;
  static const Field<PurchaseableProduct, String> _f$name = Field(
    'name',
    _$name,
  );
  static String _$description(PurchaseableProduct v) => v.description;
  static const Field<PurchaseableProduct, String> _f$description = Field(
    'description',
    _$description,
  );
  static ProductType _$type(PurchaseableProduct v) => v.type;
  static const Field<PurchaseableProduct, ProductType> _f$type = Field(
    'type',
    _$type,
  );
  static double _$price(PurchaseableProduct v) => v.price;
  static const Field<PurchaseableProduct, double> _f$price = Field(
    'price',
    _$price,
  );
  static String _$currency(PurchaseableProduct v) => v.currency;
  static const Field<PurchaseableProduct, String> _f$currency = Field(
    'currency',
    _$currency,
    opt: true,
    def: 'BRL',
  );
  static String? _$sku(PurchaseableProduct v) => v.sku;
  static const Field<PurchaseableProduct, String> _f$sku = Field(
    'sku',
    _$sku,
    opt: true,
  );
  static ProductReward _$reward(PurchaseableProduct v) => v.reward;
  static const Field<PurchaseableProduct, ProductReward> _f$reward = Field(
    'reward',
    _$reward,
  );
  static bool _$isAvailable(PurchaseableProduct v) => v.isAvailable;
  static const Field<PurchaseableProduct, bool> _f$isAvailable = Field(
    'isAvailable',
    _$isAvailable,
    opt: true,
    def: true,
  );
  static DateTime _$createdAt(PurchaseableProduct v) => v.createdAt;
  static const Field<PurchaseableProduct, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
  );

  @override
  final MappableFields<PurchaseableProduct> fields = const {
    #productId: _f$productId,
    #name: _f$name,
    #description: _f$description,
    #type: _f$type,
    #price: _f$price,
    #currency: _f$currency,
    #sku: _f$sku,
    #reward: _f$reward,
    #isAvailable: _f$isAvailable,
    #createdAt: _f$createdAt,
  };

  static PurchaseableProduct _instantiate(DecodingData data) {
    return PurchaseableProduct(
      productId: data.dec(_f$productId),
      name: data.dec(_f$name),
      description: data.dec(_f$description),
      type: data.dec(_f$type),
      price: data.dec(_f$price),
      currency: data.dec(_f$currency),
      sku: data.dec(_f$sku),
      reward: data.dec(_f$reward),
      isAvailable: data.dec(_f$isAvailable),
      createdAt: data.dec(_f$createdAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static PurchaseableProduct fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PurchaseableProduct>(map);
  }

  static PurchaseableProduct fromJson(String json) {
    return ensureInitialized().decodeJson<PurchaseableProduct>(json);
  }
}

mixin PurchaseableProductMappable {
  String toJson() {
    return PurchaseableProductMapper.ensureInitialized()
        .encodeJson<PurchaseableProduct>(this as PurchaseableProduct);
  }

  Map<String, dynamic> toMap() {
    return PurchaseableProductMapper.ensureInitialized()
        .encodeMap<PurchaseableProduct>(this as PurchaseableProduct);
  }

  PurchaseableProductCopyWith<
    PurchaseableProduct,
    PurchaseableProduct,
    PurchaseableProduct
  >
  get copyWith =>
      _PurchaseableProductCopyWithImpl<
        PurchaseableProduct,
        PurchaseableProduct
      >(this as PurchaseableProduct, $identity, $identity);
  @override
  String toString() {
    return PurchaseableProductMapper.ensureInitialized().stringifyValue(
      this as PurchaseableProduct,
    );
  }

  @override
  bool operator ==(Object other) {
    return PurchaseableProductMapper.ensureInitialized().equalsValue(
      this as PurchaseableProduct,
      other,
    );
  }

  @override
  int get hashCode {
    return PurchaseableProductMapper.ensureInitialized().hashValue(
      this as PurchaseableProduct,
    );
  }
}

extension PurchaseableProductValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PurchaseableProduct, $Out> {
  PurchaseableProductCopyWith<$R, PurchaseableProduct, $Out>
  get $asPurchaseableProduct => $base.as(
    (v, t, t2) => _PurchaseableProductCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class PurchaseableProductCopyWith<
  $R,
  $In extends PurchaseableProduct,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  ProductRewardCopyWith<$R, ProductReward, ProductReward> get reward;
  $R call({
    String? productId,
    String? name,
    String? description,
    ProductType? type,
    double? price,
    String? currency,
    String? sku,
    ProductReward? reward,
    bool? isAvailable,
    DateTime? createdAt,
  });
  PurchaseableProductCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _PurchaseableProductCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PurchaseableProduct, $Out>
    implements PurchaseableProductCopyWith<$R, PurchaseableProduct, $Out> {
  _PurchaseableProductCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PurchaseableProduct> $mapper =
      PurchaseableProductMapper.ensureInitialized();
  @override
  ProductRewardCopyWith<$R, ProductReward, ProductReward> get reward =>
      $value.reward.copyWith.$chain((v) => call(reward: v));
  @override
  $R call({
    String? productId,
    String? name,
    String? description,
    ProductType? type,
    double? price,
    String? currency,
    Object? sku = $none,
    ProductReward? reward,
    bool? isAvailable,
    DateTime? createdAt,
  }) => $apply(
    FieldCopyWithData({
      if (productId != null) #productId: productId,
      if (name != null) #name: name,
      if (description != null) #description: description,
      if (type != null) #type: type,
      if (price != null) #price: price,
      if (currency != null) #currency: currency,
      if (sku != $none) #sku: sku,
      if (reward != null) #reward: reward,
      if (isAvailable != null) #isAvailable: isAvailable,
      if (createdAt != null) #createdAt: createdAt,
    }),
  );
  @override
  PurchaseableProduct $make(CopyWithData data) => PurchaseableProduct(
    productId: data.get(#productId, or: $value.productId),
    name: data.get(#name, or: $value.name),
    description: data.get(#description, or: $value.description),
    type: data.get(#type, or: $value.type),
    price: data.get(#price, or: $value.price),
    currency: data.get(#currency, or: $value.currency),
    sku: data.get(#sku, or: $value.sku),
    reward: data.get(#reward, or: $value.reward),
    isAvailable: data.get(#isAvailable, or: $value.isAvailable),
    createdAt: data.get(#createdAt, or: $value.createdAt),
  );

  @override
  PurchaseableProductCopyWith<$R2, PurchaseableProduct, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _PurchaseableProductCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class ProductRewardMapper extends ClassMapperBase<ProductReward> {
  ProductRewardMapper._();

  static ProductRewardMapper? _instance;
  static ProductRewardMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ProductRewardMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'ProductReward';

  static RewardType _$type(ProductReward v) => v.type;
  static const Field<ProductReward, RewardType> _f$type = Field('type', _$type);
  static int _$quantity(ProductReward v) => v.quantity;
  static const Field<ProductReward, int> _f$quantity = Field(
    'quantity',
    _$quantity,
  );
  static String? _$description(ProductReward v) => v.description;
  static const Field<ProductReward, String> _f$description = Field(
    'description',
    _$description,
    opt: true,
  );
  static Duration? _$duration(ProductReward v) => v.duration;
  static const Field<ProductReward, Duration> _f$duration = Field(
    'duration',
    _$duration,
    opt: true,
  );

  @override
  final MappableFields<ProductReward> fields = const {
    #type: _f$type,
    #quantity: _f$quantity,
    #description: _f$description,
    #duration: _f$duration,
  };

  static ProductReward _instantiate(DecodingData data) {
    return ProductReward(
      type: data.dec(_f$type),
      quantity: data.dec(_f$quantity),
      description: data.dec(_f$description),
      duration: data.dec(_f$duration),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ProductReward fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ProductReward>(map);
  }

  static ProductReward fromJson(String json) {
    return ensureInitialized().decodeJson<ProductReward>(json);
  }
}

mixin ProductRewardMappable {
  String toJson() {
    return ProductRewardMapper.ensureInitialized().encodeJson<ProductReward>(
      this as ProductReward,
    );
  }

  Map<String, dynamic> toMap() {
    return ProductRewardMapper.ensureInitialized().encodeMap<ProductReward>(
      this as ProductReward,
    );
  }

  ProductRewardCopyWith<ProductReward, ProductReward, ProductReward>
  get copyWith => _ProductRewardCopyWithImpl<ProductReward, ProductReward>(
    this as ProductReward,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return ProductRewardMapper.ensureInitialized().stringifyValue(
      this as ProductReward,
    );
  }

  @override
  bool operator ==(Object other) {
    return ProductRewardMapper.ensureInitialized().equalsValue(
      this as ProductReward,
      other,
    );
  }

  @override
  int get hashCode {
    return ProductRewardMapper.ensureInitialized().hashValue(
      this as ProductReward,
    );
  }
}

extension ProductRewardValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ProductReward, $Out> {
  ProductRewardCopyWith<$R, ProductReward, $Out> get $asProductReward =>
      $base.as((v, t, t2) => _ProductRewardCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ProductRewardCopyWith<$R, $In extends ProductReward, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    RewardType? type,
    int? quantity,
    String? description,
    Duration? duration,
  });
  ProductRewardCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ProductRewardCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ProductReward, $Out>
    implements ProductRewardCopyWith<$R, ProductReward, $Out> {
  _ProductRewardCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ProductReward> $mapper =
      ProductRewardMapper.ensureInitialized();
  @override
  $R call({
    RewardType? type,
    int? quantity,
    Object? description = $none,
    Object? duration = $none,
  }) => $apply(
    FieldCopyWithData({
      if (type != null) #type: type,
      if (quantity != null) #quantity: quantity,
      if (description != $none) #description: description,
      if (duration != $none) #duration: duration,
    }),
  );
  @override
  ProductReward $make(CopyWithData data) => ProductReward(
    type: data.get(#type, or: $value.type),
    quantity: data.get(#quantity, or: $value.quantity),
    description: data.get(#description, or: $value.description),
    duration: data.get(#duration, or: $value.duration),
  );

  @override
  ProductRewardCopyWith<$R2, ProductReward, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ProductRewardCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class ProductBundleMapper extends ClassMapperBase<ProductBundle> {
  ProductBundleMapper._();

  static ProductBundleMapper? _instance;
  static ProductBundleMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ProductBundleMapper._());
      PurchaseableProductMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'ProductBundle';

  static String _$bundleId(ProductBundle v) => v.bundleId;
  static const Field<ProductBundle, String> _f$bundleId = Field(
    'bundleId',
    _$bundleId,
  );
  static String _$name(ProductBundle v) => v.name;
  static const Field<ProductBundle, String> _f$name = Field('name', _$name);
  static String _$description(ProductBundle v) => v.description;
  static const Field<ProductBundle, String> _f$description = Field(
    'description',
    _$description,
  );
  static List<PurchaseableProduct> _$products(ProductBundle v) => v.products;
  static const Field<ProductBundle, List<PurchaseableProduct>> _f$products =
      Field('products', _$products);
  static double _$originalPrice(ProductBundle v) => v.originalPrice;
  static const Field<ProductBundle, double> _f$originalPrice = Field(
    'originalPrice',
    _$originalPrice,
  );
  static double _$bundlePrice(ProductBundle v) => v.bundlePrice;
  static const Field<ProductBundle, double> _f$bundlePrice = Field(
    'bundlePrice',
    _$bundlePrice,
  );
  static bool _$isLimitedTime(ProductBundle v) => v.isLimitedTime;
  static const Field<ProductBundle, bool> _f$isLimitedTime = Field(
    'isLimitedTime',
    _$isLimitedTime,
    opt: true,
    def: false,
  );
  static DateTime? _$expiresAt(ProductBundle v) => v.expiresAt;
  static const Field<ProductBundle, DateTime> _f$expiresAt = Field(
    'expiresAt',
    _$expiresAt,
    opt: true,
  );
  static double _$discountPercent(ProductBundle v) => v.discountPercent;
  static const Field<ProductBundle, double> _f$discountPercent = Field(
    'discountPercent',
    _$discountPercent,
    mode: FieldMode.member,
  );
  static bool _$isValid(ProductBundle v) => v.isValid;
  static const Field<ProductBundle, bool> _f$isValid = Field(
    'isValid',
    _$isValid,
    mode: FieldMode.member,
  );

  @override
  final MappableFields<ProductBundle> fields = const {
    #bundleId: _f$bundleId,
    #name: _f$name,
    #description: _f$description,
    #products: _f$products,
    #originalPrice: _f$originalPrice,
    #bundlePrice: _f$bundlePrice,
    #isLimitedTime: _f$isLimitedTime,
    #expiresAt: _f$expiresAt,
    #discountPercent: _f$discountPercent,
    #isValid: _f$isValid,
  };

  static ProductBundle _instantiate(DecodingData data) {
    return ProductBundle(
      bundleId: data.dec(_f$bundleId),
      name: data.dec(_f$name),
      description: data.dec(_f$description),
      products: data.dec(_f$products),
      originalPrice: data.dec(_f$originalPrice),
      bundlePrice: data.dec(_f$bundlePrice),
      isLimitedTime: data.dec(_f$isLimitedTime),
      expiresAt: data.dec(_f$expiresAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ProductBundle fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ProductBundle>(map);
  }

  static ProductBundle fromJson(String json) {
    return ensureInitialized().decodeJson<ProductBundle>(json);
  }
}

mixin ProductBundleMappable {
  String toJson() {
    return ProductBundleMapper.ensureInitialized().encodeJson<ProductBundle>(
      this as ProductBundle,
    );
  }

  Map<String, dynamic> toMap() {
    return ProductBundleMapper.ensureInitialized().encodeMap<ProductBundle>(
      this as ProductBundle,
    );
  }

  ProductBundleCopyWith<ProductBundle, ProductBundle, ProductBundle>
  get copyWith => _ProductBundleCopyWithImpl<ProductBundle, ProductBundle>(
    this as ProductBundle,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return ProductBundleMapper.ensureInitialized().stringifyValue(
      this as ProductBundle,
    );
  }

  @override
  bool operator ==(Object other) {
    return ProductBundleMapper.ensureInitialized().equalsValue(
      this as ProductBundle,
      other,
    );
  }

  @override
  int get hashCode {
    return ProductBundleMapper.ensureInitialized().hashValue(
      this as ProductBundle,
    );
  }
}

extension ProductBundleValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ProductBundle, $Out> {
  ProductBundleCopyWith<$R, ProductBundle, $Out> get $asProductBundle =>
      $base.as((v, t, t2) => _ProductBundleCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ProductBundleCopyWith<$R, $In extends ProductBundle, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    PurchaseableProduct,
    PurchaseableProductCopyWith<$R, PurchaseableProduct, PurchaseableProduct>
  >
  get products;
  $R call({
    String? bundleId,
    String? name,
    String? description,
    List<PurchaseableProduct>? products,
    double? originalPrice,
    double? bundlePrice,
    bool? isLimitedTime,
    DateTime? expiresAt,
  });
  ProductBundleCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ProductBundleCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ProductBundle, $Out>
    implements ProductBundleCopyWith<$R, ProductBundle, $Out> {
  _ProductBundleCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ProductBundle> $mapper =
      ProductBundleMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    PurchaseableProduct,
    PurchaseableProductCopyWith<$R, PurchaseableProduct, PurchaseableProduct>
  >
  get products => ListCopyWith(
    $value.products,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(products: v),
  );
  @override
  $R call({
    String? bundleId,
    String? name,
    String? description,
    List<PurchaseableProduct>? products,
    double? originalPrice,
    double? bundlePrice,
    bool? isLimitedTime,
    Object? expiresAt = $none,
  }) => $apply(
    FieldCopyWithData({
      if (bundleId != null) #bundleId: bundleId,
      if (name != null) #name: name,
      if (description != null) #description: description,
      if (products != null) #products: products,
      if (originalPrice != null) #originalPrice: originalPrice,
      if (bundlePrice != null) #bundlePrice: bundlePrice,
      if (isLimitedTime != null) #isLimitedTime: isLimitedTime,
      if (expiresAt != $none) #expiresAt: expiresAt,
    }),
  );
  @override
  ProductBundle $make(CopyWithData data) => ProductBundle(
    bundleId: data.get(#bundleId, or: $value.bundleId),
    name: data.get(#name, or: $value.name),
    description: data.get(#description, or: $value.description),
    products: data.get(#products, or: $value.products),
    originalPrice: data.get(#originalPrice, or: $value.originalPrice),
    bundlePrice: data.get(#bundlePrice, or: $value.bundlePrice),
    isLimitedTime: data.get(#isLimitedTime, or: $value.isLimitedTime),
    expiresAt: data.get(#expiresAt, or: $value.expiresAt),
  );

  @override
  ProductBundleCopyWith<$R2, ProductBundle, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ProductBundleCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class ShoppingCartMapper extends ClassMapperBase<ShoppingCart> {
  ShoppingCartMapper._();

  static ShoppingCartMapper? _instance;
  static ShoppingCartMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ShoppingCartMapper._());
      CartItemMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'ShoppingCart';

  static String _$cartId(ShoppingCart v) => v.cartId;
  static const Field<ShoppingCart, String> _f$cartId = Field(
    'cartId',
    _$cartId,
  );
  static String _$userId(ShoppingCart v) => v.userId;
  static const Field<ShoppingCart, String> _f$userId = Field(
    'userId',
    _$userId,
  );
  static List<CartItem> _$items(ShoppingCart v) => v.items;
  static const Field<ShoppingCart, List<CartItem>> _f$items = Field(
    'items',
    _$items,
  );
  static DateTime _$createdAt(ShoppingCart v) => v.createdAt;
  static const Field<ShoppingCart, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
  );
  static DateTime _$updatedAt(ShoppingCart v) => v.updatedAt;
  static const Field<ShoppingCart, DateTime> _f$updatedAt = Field(
    'updatedAt',
    _$updatedAt,
  );
  static double _$total(ShoppingCart v) => v.total;
  static const Field<ShoppingCart, double> _f$total = Field(
    'total',
    _$total,
    mode: FieldMode.member,
  );
  static int _$itemCount(ShoppingCart v) => v.itemCount;
  static const Field<ShoppingCart, int> _f$itemCount = Field(
    'itemCount',
    _$itemCount,
    mode: FieldMode.member,
  );

  @override
  final MappableFields<ShoppingCart> fields = const {
    #cartId: _f$cartId,
    #userId: _f$userId,
    #items: _f$items,
    #createdAt: _f$createdAt,
    #updatedAt: _f$updatedAt,
    #total: _f$total,
    #itemCount: _f$itemCount,
  };

  static ShoppingCart _instantiate(DecodingData data) {
    return ShoppingCart(
      cartId: data.dec(_f$cartId),
      userId: data.dec(_f$userId),
      items: data.dec(_f$items),
      createdAt: data.dec(_f$createdAt),
      updatedAt: data.dec(_f$updatedAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ShoppingCart fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ShoppingCart>(map);
  }

  static ShoppingCart fromJson(String json) {
    return ensureInitialized().decodeJson<ShoppingCart>(json);
  }
}

mixin ShoppingCartMappable {
  String toJson() {
    return ShoppingCartMapper.ensureInitialized().encodeJson<ShoppingCart>(
      this as ShoppingCart,
    );
  }

  Map<String, dynamic> toMap() {
    return ShoppingCartMapper.ensureInitialized().encodeMap<ShoppingCart>(
      this as ShoppingCart,
    );
  }

  ShoppingCartCopyWith<ShoppingCart, ShoppingCart, ShoppingCart> get copyWith =>
      _ShoppingCartCopyWithImpl<ShoppingCart, ShoppingCart>(
        this as ShoppingCart,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return ShoppingCartMapper.ensureInitialized().stringifyValue(
      this as ShoppingCart,
    );
  }

  @override
  bool operator ==(Object other) {
    return ShoppingCartMapper.ensureInitialized().equalsValue(
      this as ShoppingCart,
      other,
    );
  }

  @override
  int get hashCode {
    return ShoppingCartMapper.ensureInitialized().hashValue(
      this as ShoppingCart,
    );
  }
}

extension ShoppingCartValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ShoppingCart, $Out> {
  ShoppingCartCopyWith<$R, ShoppingCart, $Out> get $asShoppingCart =>
      $base.as((v, t, t2) => _ShoppingCartCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ShoppingCartCopyWith<$R, $In extends ShoppingCart, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, CartItem, CartItemCopyWith<$R, CartItem, CartItem>>
  get items;
  $R call({
    String? cartId,
    String? userId,
    List<CartItem>? items,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  ShoppingCartCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ShoppingCartCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ShoppingCart, $Out>
    implements ShoppingCartCopyWith<$R, ShoppingCart, $Out> {
  _ShoppingCartCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ShoppingCart> $mapper =
      ShoppingCartMapper.ensureInitialized();
  @override
  ListCopyWith<$R, CartItem, CartItemCopyWith<$R, CartItem, CartItem>>
  get items => ListCopyWith(
    $value.items,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(items: v),
  );
  @override
  $R call({
    String? cartId,
    String? userId,
    List<CartItem>? items,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => $apply(
    FieldCopyWithData({
      if (cartId != null) #cartId: cartId,
      if (userId != null) #userId: userId,
      if (items != null) #items: items,
      if (createdAt != null) #createdAt: createdAt,
      if (updatedAt != null) #updatedAt: updatedAt,
    }),
  );
  @override
  ShoppingCart $make(CopyWithData data) => ShoppingCart(
    cartId: data.get(#cartId, or: $value.cartId),
    userId: data.get(#userId, or: $value.userId),
    items: data.get(#items, or: $value.items),
    createdAt: data.get(#createdAt, or: $value.createdAt),
    updatedAt: data.get(#updatedAt, or: $value.updatedAt),
  );

  @override
  ShoppingCartCopyWith<$R2, ShoppingCart, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ShoppingCartCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class CartItemMapper extends ClassMapperBase<CartItem> {
  CartItemMapper._();

  static CartItemMapper? _instance;
  static CartItemMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = CartItemMapper._());
      PurchaseableProductMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'CartItem';

  static String _$itemId(CartItem v) => v.itemId;
  static const Field<CartItem, String> _f$itemId = Field('itemId', _$itemId);
  static PurchaseableProduct _$product(CartItem v) => v.product;
  static const Field<CartItem, PurchaseableProduct> _f$product = Field(
    'product',
    _$product,
  );
  static int _$quantity(CartItem v) => v.quantity;
  static const Field<CartItem, int> _f$quantity = Field('quantity', _$quantity);
  static double _$totalPrice(CartItem v) => v.totalPrice;
  static const Field<CartItem, double> _f$totalPrice = Field(
    'totalPrice',
    _$totalPrice,
    mode: FieldMode.member,
  );

  @override
  final MappableFields<CartItem> fields = const {
    #itemId: _f$itemId,
    #product: _f$product,
    #quantity: _f$quantity,
    #totalPrice: _f$totalPrice,
  };

  static CartItem _instantiate(DecodingData data) {
    return CartItem(
      itemId: data.dec(_f$itemId),
      product: data.dec(_f$product),
      quantity: data.dec(_f$quantity),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static CartItem fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<CartItem>(map);
  }

  static CartItem fromJson(String json) {
    return ensureInitialized().decodeJson<CartItem>(json);
  }
}

mixin CartItemMappable {
  String toJson() {
    return CartItemMapper.ensureInitialized().encodeJson<CartItem>(
      this as CartItem,
    );
  }

  Map<String, dynamic> toMap() {
    return CartItemMapper.ensureInitialized().encodeMap<CartItem>(
      this as CartItem,
    );
  }

  CartItemCopyWith<CartItem, CartItem, CartItem> get copyWith =>
      _CartItemCopyWithImpl<CartItem, CartItem>(
        this as CartItem,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return CartItemMapper.ensureInitialized().stringifyValue(this as CartItem);
  }

  @override
  bool operator ==(Object other) {
    return CartItemMapper.ensureInitialized().equalsValue(
      this as CartItem,
      other,
    );
  }

  @override
  int get hashCode {
    return CartItemMapper.ensureInitialized().hashValue(this as CartItem);
  }
}

extension CartItemValueCopy<$R, $Out> on ObjectCopyWith<$R, CartItem, $Out> {
  CartItemCopyWith<$R, CartItem, $Out> get $asCartItem =>
      $base.as((v, t, t2) => _CartItemCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class CartItemCopyWith<$R, $In extends CartItem, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  PurchaseableProductCopyWith<$R, PurchaseableProduct, PurchaseableProduct>
  get product;
  $R call({String? itemId, PurchaseableProduct? product, int? quantity});
  CartItemCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _CartItemCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, CartItem, $Out>
    implements CartItemCopyWith<$R, CartItem, $Out> {
  _CartItemCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<CartItem> $mapper =
      CartItemMapper.ensureInitialized();
  @override
  PurchaseableProductCopyWith<$R, PurchaseableProduct, PurchaseableProduct>
  get product => $value.product.copyWith.$chain((v) => call(product: v));
  @override
  $R call({String? itemId, PurchaseableProduct? product, int? quantity}) =>
      $apply(
        FieldCopyWithData({
          if (itemId != null) #itemId: itemId,
          if (product != null) #product: product,
          if (quantity != null) #quantity: quantity,
        }),
      );
  @override
  CartItem $make(CopyWithData data) => CartItem(
    itemId: data.get(#itemId, or: $value.itemId),
    product: data.get(#product, or: $value.product),
    quantity: data.get(#quantity, or: $value.quantity),
  );

  @override
  CartItemCopyWith<$R2, CartItem, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _CartItemCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class PaymentTransactionMapper extends ClassMapperBase<PaymentTransaction> {
  PaymentTransactionMapper._();

  static PaymentTransactionMapper? _instance;
  static PaymentTransactionMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PaymentTransactionMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'PaymentTransaction';

  static String _$transactionId(PaymentTransaction v) => v.transactionId;
  static const Field<PaymentTransaction, String> _f$transactionId = Field(
    'transactionId',
    _$transactionId,
  );
  static String _$userId(PaymentTransaction v) => v.userId;
  static const Field<PaymentTransaction, String> _f$userId = Field(
    'userId',
    _$userId,
  );
  static PaymentMethod _$method(PaymentTransaction v) => v.method;
  static const Field<PaymentTransaction, PaymentMethod> _f$method = Field(
    'method',
    _$method,
  );
  static double _$amount(PaymentTransaction v) => v.amount;
  static const Field<PaymentTransaction, double> _f$amount = Field(
    'amount',
    _$amount,
  );
  static String _$currency(PaymentTransaction v) => v.currency;
  static const Field<PaymentTransaction, String> _f$currency = Field(
    'currency',
    _$currency,
    opt: true,
    def: 'BRL',
  );
  static PaymentStatus _$status(PaymentTransaction v) => v.status;
  static const Field<PaymentTransaction, PaymentStatus> _f$status = Field(
    'status',
    _$status,
  );
  static String? _$providerTransactionId(PaymentTransaction v) =>
      v.providerTransactionId;
  static const Field<PaymentTransaction, String> _f$providerTransactionId =
      Field('providerTransactionId', _$providerTransactionId, opt: true);
  static String? _$errorMessage(PaymentTransaction v) => v.errorMessage;
  static const Field<PaymentTransaction, String> _f$errorMessage = Field(
    'errorMessage',
    _$errorMessage,
    opt: true,
  );
  static List<String> _$purchaseIds(PaymentTransaction v) => v.purchaseIds;
  static const Field<PaymentTransaction, List<String>> _f$purchaseIds = Field(
    'purchaseIds',
    _$purchaseIds,
  );
  static DateTime _$createdAt(PaymentTransaction v) => v.createdAt;
  static const Field<PaymentTransaction, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
  );
  static DateTime? _$completedAt(PaymentTransaction v) => v.completedAt;
  static const Field<PaymentTransaction, DateTime> _f$completedAt = Field(
    'completedAt',
    _$completedAt,
    opt: true,
  );

  @override
  final MappableFields<PaymentTransaction> fields = const {
    #transactionId: _f$transactionId,
    #userId: _f$userId,
    #method: _f$method,
    #amount: _f$amount,
    #currency: _f$currency,
    #status: _f$status,
    #providerTransactionId: _f$providerTransactionId,
    #errorMessage: _f$errorMessage,
    #purchaseIds: _f$purchaseIds,
    #createdAt: _f$createdAt,
    #completedAt: _f$completedAt,
  };

  static PaymentTransaction _instantiate(DecodingData data) {
    return PaymentTransaction(
      transactionId: data.dec(_f$transactionId),
      userId: data.dec(_f$userId),
      method: data.dec(_f$method),
      amount: data.dec(_f$amount),
      currency: data.dec(_f$currency),
      status: data.dec(_f$status),
      providerTransactionId: data.dec(_f$providerTransactionId),
      errorMessage: data.dec(_f$errorMessage),
      purchaseIds: data.dec(_f$purchaseIds),
      createdAt: data.dec(_f$createdAt),
      completedAt: data.dec(_f$completedAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static PaymentTransaction fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PaymentTransaction>(map);
  }

  static PaymentTransaction fromJson(String json) {
    return ensureInitialized().decodeJson<PaymentTransaction>(json);
  }
}

mixin PaymentTransactionMappable {
  String toJson() {
    return PaymentTransactionMapper.ensureInitialized()
        .encodeJson<PaymentTransaction>(this as PaymentTransaction);
  }

  Map<String, dynamic> toMap() {
    return PaymentTransactionMapper.ensureInitialized()
        .encodeMap<PaymentTransaction>(this as PaymentTransaction);
  }

  PaymentTransactionCopyWith<
    PaymentTransaction,
    PaymentTransaction,
    PaymentTransaction
  >
  get copyWith =>
      _PaymentTransactionCopyWithImpl<PaymentTransaction, PaymentTransaction>(
        this as PaymentTransaction,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return PaymentTransactionMapper.ensureInitialized().stringifyValue(
      this as PaymentTransaction,
    );
  }

  @override
  bool operator ==(Object other) {
    return PaymentTransactionMapper.ensureInitialized().equalsValue(
      this as PaymentTransaction,
      other,
    );
  }

  @override
  int get hashCode {
    return PaymentTransactionMapper.ensureInitialized().hashValue(
      this as PaymentTransaction,
    );
  }
}

extension PaymentTransactionValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PaymentTransaction, $Out> {
  PaymentTransactionCopyWith<$R, PaymentTransaction, $Out>
  get $asPaymentTransaction => $base.as(
    (v, t, t2) => _PaymentTransactionCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class PaymentTransactionCopyWith<
  $R,
  $In extends PaymentTransaction,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get purchaseIds;
  $R call({
    String? transactionId,
    String? userId,
    PaymentMethod? method,
    double? amount,
    String? currency,
    PaymentStatus? status,
    String? providerTransactionId,
    String? errorMessage,
    List<String>? purchaseIds,
    DateTime? createdAt,
    DateTime? completedAt,
  });
  PaymentTransactionCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _PaymentTransactionCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PaymentTransaction, $Out>
    implements PaymentTransactionCopyWith<$R, PaymentTransaction, $Out> {
  _PaymentTransactionCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PaymentTransaction> $mapper =
      PaymentTransactionMapper.ensureInitialized();
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get purchaseIds => ListCopyWith(
    $value.purchaseIds,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(purchaseIds: v),
  );
  @override
  $R call({
    String? transactionId,
    String? userId,
    PaymentMethod? method,
    double? amount,
    String? currency,
    PaymentStatus? status,
    Object? providerTransactionId = $none,
    Object? errorMessage = $none,
    List<String>? purchaseIds,
    DateTime? createdAt,
    Object? completedAt = $none,
  }) => $apply(
    FieldCopyWithData({
      if (transactionId != null) #transactionId: transactionId,
      if (userId != null) #userId: userId,
      if (method != null) #method: method,
      if (amount != null) #amount: amount,
      if (currency != null) #currency: currency,
      if (status != null) #status: status,
      if (providerTransactionId != $none)
        #providerTransactionId: providerTransactionId,
      if (errorMessage != $none) #errorMessage: errorMessage,
      if (purchaseIds != null) #purchaseIds: purchaseIds,
      if (createdAt != null) #createdAt: createdAt,
      if (completedAt != $none) #completedAt: completedAt,
    }),
  );
  @override
  PaymentTransaction $make(CopyWithData data) => PaymentTransaction(
    transactionId: data.get(#transactionId, or: $value.transactionId),
    userId: data.get(#userId, or: $value.userId),
    method: data.get(#method, or: $value.method),
    amount: data.get(#amount, or: $value.amount),
    currency: data.get(#currency, or: $value.currency),
    status: data.get(#status, or: $value.status),
    providerTransactionId: data.get(
      #providerTransactionId,
      or: $value.providerTransactionId,
    ),
    errorMessage: data.get(#errorMessage, or: $value.errorMessage),
    purchaseIds: data.get(#purchaseIds, or: $value.purchaseIds),
    createdAt: data.get(#createdAt, or: $value.createdAt),
    completedAt: data.get(#completedAt, or: $value.completedAt),
  );

  @override
  PaymentTransactionCopyWith<$R2, PaymentTransaction, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _PaymentTransactionCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class PurchaseHistoryMapper extends ClassMapperBase<PurchaseHistory> {
  PurchaseHistoryMapper._();

  static PurchaseHistoryMapper? _instance;
  static PurchaseHistoryMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PurchaseHistoryMapper._());
      InAppPurchaseMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'PurchaseHistory';

  static String _$userId(PurchaseHistory v) => v.userId;
  static const Field<PurchaseHistory, String> _f$userId = Field(
    'userId',
    _$userId,
  );
  static List<InAppPurchase> _$purchases(PurchaseHistory v) => v.purchases;
  static const Field<PurchaseHistory, List<InAppPurchase>> _f$purchases = Field(
    'purchases',
    _$purchases,
  );
  static double _$totalSpent(PurchaseHistory v) => v.totalSpent;
  static const Field<PurchaseHistory, double> _f$totalSpent = Field(
    'totalSpent',
    _$totalSpent,
  );
  static int _$totalPurchases(PurchaseHistory v) => v.totalPurchases;
  static const Field<PurchaseHistory, int> _f$totalPurchases = Field(
    'totalPurchases',
    _$totalPurchases,
  );
  static DateTime _$firstPurchaseDate(PurchaseHistory v) => v.firstPurchaseDate;
  static const Field<PurchaseHistory, DateTime> _f$firstPurchaseDate = Field(
    'firstPurchaseDate',
    _$firstPurchaseDate,
  );
  static DateTime? _$lastPurchaseDate(PurchaseHistory v) => v.lastPurchaseDate;
  static const Field<PurchaseHistory, DateTime> _f$lastPurchaseDate = Field(
    'lastPurchaseDate',
    _$lastPurchaseDate,
    opt: true,
  );
  static Map<RewardType, int> _$rewardsSummary(PurchaseHistory v) =>
      v.rewardsSummary;
  static const Field<PurchaseHistory, Map<RewardType, int>> _f$rewardsSummary =
      Field('rewardsSummary', _$rewardsSummary);

  @override
  final MappableFields<PurchaseHistory> fields = const {
    #userId: _f$userId,
    #purchases: _f$purchases,
    #totalSpent: _f$totalSpent,
    #totalPurchases: _f$totalPurchases,
    #firstPurchaseDate: _f$firstPurchaseDate,
    #lastPurchaseDate: _f$lastPurchaseDate,
    #rewardsSummary: _f$rewardsSummary,
  };

  static PurchaseHistory _instantiate(DecodingData data) {
    return PurchaseHistory(
      userId: data.dec(_f$userId),
      purchases: data.dec(_f$purchases),
      totalSpent: data.dec(_f$totalSpent),
      totalPurchases: data.dec(_f$totalPurchases),
      firstPurchaseDate: data.dec(_f$firstPurchaseDate),
      lastPurchaseDate: data.dec(_f$lastPurchaseDate),
      rewardsSummary: data.dec(_f$rewardsSummary),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static PurchaseHistory fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PurchaseHistory>(map);
  }

  static PurchaseHistory fromJson(String json) {
    return ensureInitialized().decodeJson<PurchaseHistory>(json);
  }
}

mixin PurchaseHistoryMappable {
  String toJson() {
    return PurchaseHistoryMapper.ensureInitialized()
        .encodeJson<PurchaseHistory>(this as PurchaseHistory);
  }

  Map<String, dynamic> toMap() {
    return PurchaseHistoryMapper.ensureInitialized().encodeMap<PurchaseHistory>(
      this as PurchaseHistory,
    );
  }

  PurchaseHistoryCopyWith<PurchaseHistory, PurchaseHistory, PurchaseHistory>
  get copyWith =>
      _PurchaseHistoryCopyWithImpl<PurchaseHistory, PurchaseHistory>(
        this as PurchaseHistory,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return PurchaseHistoryMapper.ensureInitialized().stringifyValue(
      this as PurchaseHistory,
    );
  }

  @override
  bool operator ==(Object other) {
    return PurchaseHistoryMapper.ensureInitialized().equalsValue(
      this as PurchaseHistory,
      other,
    );
  }

  @override
  int get hashCode {
    return PurchaseHistoryMapper.ensureInitialized().hashValue(
      this as PurchaseHistory,
    );
  }
}

extension PurchaseHistoryValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PurchaseHistory, $Out> {
  PurchaseHistoryCopyWith<$R, PurchaseHistory, $Out> get $asPurchaseHistory =>
      $base.as((v, t, t2) => _PurchaseHistoryCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class PurchaseHistoryCopyWith<$R, $In extends PurchaseHistory, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    InAppPurchase,
    InAppPurchaseCopyWith<$R, InAppPurchase, InAppPurchase>
  >
  get purchases;
  MapCopyWith<$R, RewardType, int, ObjectCopyWith<$R, int, int>>
  get rewardsSummary;
  $R call({
    String? userId,
    List<InAppPurchase>? purchases,
    double? totalSpent,
    int? totalPurchases,
    DateTime? firstPurchaseDate,
    DateTime? lastPurchaseDate,
    Map<RewardType, int>? rewardsSummary,
  });
  PurchaseHistoryCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _PurchaseHistoryCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PurchaseHistory, $Out>
    implements PurchaseHistoryCopyWith<$R, PurchaseHistory, $Out> {
  _PurchaseHistoryCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PurchaseHistory> $mapper =
      PurchaseHistoryMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    InAppPurchase,
    InAppPurchaseCopyWith<$R, InAppPurchase, InAppPurchase>
  >
  get purchases => ListCopyWith(
    $value.purchases,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(purchases: v),
  );
  @override
  MapCopyWith<$R, RewardType, int, ObjectCopyWith<$R, int, int>>
  get rewardsSummary => MapCopyWith(
    $value.rewardsSummary,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(rewardsSummary: v),
  );
  @override
  $R call({
    String? userId,
    List<InAppPurchase>? purchases,
    double? totalSpent,
    int? totalPurchases,
    DateTime? firstPurchaseDate,
    Object? lastPurchaseDate = $none,
    Map<RewardType, int>? rewardsSummary,
  }) => $apply(
    FieldCopyWithData({
      if (userId != null) #userId: userId,
      if (purchases != null) #purchases: purchases,
      if (totalSpent != null) #totalSpent: totalSpent,
      if (totalPurchases != null) #totalPurchases: totalPurchases,
      if (firstPurchaseDate != null) #firstPurchaseDate: firstPurchaseDate,
      if (lastPurchaseDate != $none) #lastPurchaseDate: lastPurchaseDate,
      if (rewardsSummary != null) #rewardsSummary: rewardsSummary,
    }),
  );
  @override
  PurchaseHistory $make(CopyWithData data) => PurchaseHistory(
    userId: data.get(#userId, or: $value.userId),
    purchases: data.get(#purchases, or: $value.purchases),
    totalSpent: data.get(#totalSpent, or: $value.totalSpent),
    totalPurchases: data.get(#totalPurchases, or: $value.totalPurchases),
    firstPurchaseDate: data.get(
      #firstPurchaseDate,
      or: $value.firstPurchaseDate,
    ),
    lastPurchaseDate: data.get(#lastPurchaseDate, or: $value.lastPurchaseDate),
    rewardsSummary: data.get(#rewardsSummary, or: $value.rewardsSummary),
  );

  @override
  PurchaseHistoryCopyWith<$R2, PurchaseHistory, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _PurchaseHistoryCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class UserInventoryMapper extends ClassMapperBase<UserInventory> {
  UserInventoryMapper._();

  static UserInventoryMapper? _instance;
  static UserInventoryMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = UserInventoryMapper._());
      InventoryItemMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'UserInventory';

  static String _$userId(UserInventory v) => v.userId;
  static const Field<UserInventory, String> _f$userId = Field(
    'userId',
    _$userId,
  );
  static Map<RewardType, int> _$balance(UserInventory v) => v.balance;
  static const Field<UserInventory, Map<RewardType, int>> _f$balance = Field(
    'balance',
    _$balance,
  );
  static List<InventoryItem> _$items(UserInventory v) => v.items;
  static const Field<UserInventory, List<InventoryItem>> _f$items = Field(
    'items',
    _$items,
  );
  static DateTime _$updatedAt(UserInventory v) => v.updatedAt;
  static const Field<UserInventory, DateTime> _f$updatedAt = Field(
    'updatedAt',
    _$updatedAt,
  );

  @override
  final MappableFields<UserInventory> fields = const {
    #userId: _f$userId,
    #balance: _f$balance,
    #items: _f$items,
    #updatedAt: _f$updatedAt,
  };

  static UserInventory _instantiate(DecodingData data) {
    return UserInventory(
      userId: data.dec(_f$userId),
      balance: data.dec(_f$balance),
      items: data.dec(_f$items),
      updatedAt: data.dec(_f$updatedAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static UserInventory fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<UserInventory>(map);
  }

  static UserInventory fromJson(String json) {
    return ensureInitialized().decodeJson<UserInventory>(json);
  }
}

mixin UserInventoryMappable {
  String toJson() {
    return UserInventoryMapper.ensureInitialized().encodeJson<UserInventory>(
      this as UserInventory,
    );
  }

  Map<String, dynamic> toMap() {
    return UserInventoryMapper.ensureInitialized().encodeMap<UserInventory>(
      this as UserInventory,
    );
  }

  UserInventoryCopyWith<UserInventory, UserInventory, UserInventory>
  get copyWith => _UserInventoryCopyWithImpl<UserInventory, UserInventory>(
    this as UserInventory,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return UserInventoryMapper.ensureInitialized().stringifyValue(
      this as UserInventory,
    );
  }

  @override
  bool operator ==(Object other) {
    return UserInventoryMapper.ensureInitialized().equalsValue(
      this as UserInventory,
      other,
    );
  }

  @override
  int get hashCode {
    return UserInventoryMapper.ensureInitialized().hashValue(
      this as UserInventory,
    );
  }
}

extension UserInventoryValueCopy<$R, $Out>
    on ObjectCopyWith<$R, UserInventory, $Out> {
  UserInventoryCopyWith<$R, UserInventory, $Out> get $asUserInventory =>
      $base.as((v, t, t2) => _UserInventoryCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class UserInventoryCopyWith<$R, $In extends UserInventory, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  MapCopyWith<$R, RewardType, int, ObjectCopyWith<$R, int, int>> get balance;
  ListCopyWith<
    $R,
    InventoryItem,
    InventoryItemCopyWith<$R, InventoryItem, InventoryItem>
  >
  get items;
  $R call({
    String? userId,
    Map<RewardType, int>? balance,
    List<InventoryItem>? items,
    DateTime? updatedAt,
  });
  UserInventoryCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _UserInventoryCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, UserInventory, $Out>
    implements UserInventoryCopyWith<$R, UserInventory, $Out> {
  _UserInventoryCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<UserInventory> $mapper =
      UserInventoryMapper.ensureInitialized();
  @override
  MapCopyWith<$R, RewardType, int, ObjectCopyWith<$R, int, int>> get balance =>
      MapCopyWith(
        $value.balance,
        (v, t) => ObjectCopyWith(v, $identity, t),
        (v) => call(balance: v),
      );
  @override
  ListCopyWith<
    $R,
    InventoryItem,
    InventoryItemCopyWith<$R, InventoryItem, InventoryItem>
  >
  get items => ListCopyWith(
    $value.items,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(items: v),
  );
  @override
  $R call({
    String? userId,
    Map<RewardType, int>? balance,
    List<InventoryItem>? items,
    DateTime? updatedAt,
  }) => $apply(
    FieldCopyWithData({
      if (userId != null) #userId: userId,
      if (balance != null) #balance: balance,
      if (items != null) #items: items,
      if (updatedAt != null) #updatedAt: updatedAt,
    }),
  );
  @override
  UserInventory $make(CopyWithData data) => UserInventory(
    userId: data.get(#userId, or: $value.userId),
    balance: data.get(#balance, or: $value.balance),
    items: data.get(#items, or: $value.items),
    updatedAt: data.get(#updatedAt, or: $value.updatedAt),
  );

  @override
  UserInventoryCopyWith<$R2, UserInventory, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _UserInventoryCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class InventoryItemMapper extends ClassMapperBase<InventoryItem> {
  InventoryItemMapper._();

  static InventoryItemMapper? _instance;
  static InventoryItemMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = InventoryItemMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'InventoryItem';

  static String _$itemId(InventoryItem v) => v.itemId;
  static const Field<InventoryItem, String> _f$itemId = Field(
    'itemId',
    _$itemId,
  );
  static RewardType _$type(InventoryItem v) => v.type;
  static const Field<InventoryItem, RewardType> _f$type = Field('type', _$type);
  static int _$quantity(InventoryItem v) => v.quantity;
  static const Field<InventoryItem, int> _f$quantity = Field(
    'quantity',
    _$quantity,
  );
  static DateTime _$acquiredAt(InventoryItem v) => v.acquiredAt;
  static const Field<InventoryItem, DateTime> _f$acquiredAt = Field(
    'acquiredAt',
    _$acquiredAt,
  );
  static DateTime? _$expiresAt(InventoryItem v) => v.expiresAt;
  static const Field<InventoryItem, DateTime> _f$expiresAt = Field(
    'expiresAt',
    _$expiresAt,
    opt: true,
  );
  static bool _$isExpired(InventoryItem v) => v.isExpired;
  static const Field<InventoryItem, bool> _f$isExpired = Field(
    'isExpired',
    _$isExpired,
    opt: true,
    def: false,
  );
  static bool _$hasExpired(InventoryItem v) => v.hasExpired;
  static const Field<InventoryItem, bool> _f$hasExpired = Field(
    'hasExpired',
    _$hasExpired,
    mode: FieldMode.member,
  );

  @override
  final MappableFields<InventoryItem> fields = const {
    #itemId: _f$itemId,
    #type: _f$type,
    #quantity: _f$quantity,
    #acquiredAt: _f$acquiredAt,
    #expiresAt: _f$expiresAt,
    #isExpired: _f$isExpired,
    #hasExpired: _f$hasExpired,
  };

  static InventoryItem _instantiate(DecodingData data) {
    return InventoryItem(
      itemId: data.dec(_f$itemId),
      type: data.dec(_f$type),
      quantity: data.dec(_f$quantity),
      acquiredAt: data.dec(_f$acquiredAt),
      expiresAt: data.dec(_f$expiresAt),
      isExpired: data.dec(_f$isExpired),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static InventoryItem fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<InventoryItem>(map);
  }

  static InventoryItem fromJson(String json) {
    return ensureInitialized().decodeJson<InventoryItem>(json);
  }
}

mixin InventoryItemMappable {
  String toJson() {
    return InventoryItemMapper.ensureInitialized().encodeJson<InventoryItem>(
      this as InventoryItem,
    );
  }

  Map<String, dynamic> toMap() {
    return InventoryItemMapper.ensureInitialized().encodeMap<InventoryItem>(
      this as InventoryItem,
    );
  }

  InventoryItemCopyWith<InventoryItem, InventoryItem, InventoryItem>
  get copyWith => _InventoryItemCopyWithImpl<InventoryItem, InventoryItem>(
    this as InventoryItem,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return InventoryItemMapper.ensureInitialized().stringifyValue(
      this as InventoryItem,
    );
  }

  @override
  bool operator ==(Object other) {
    return InventoryItemMapper.ensureInitialized().equalsValue(
      this as InventoryItem,
      other,
    );
  }

  @override
  int get hashCode {
    return InventoryItemMapper.ensureInitialized().hashValue(
      this as InventoryItem,
    );
  }
}

extension InventoryItemValueCopy<$R, $Out>
    on ObjectCopyWith<$R, InventoryItem, $Out> {
  InventoryItemCopyWith<$R, InventoryItem, $Out> get $asInventoryItem =>
      $base.as((v, t, t2) => _InventoryItemCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class InventoryItemCopyWith<$R, $In extends InventoryItem, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? itemId,
    RewardType? type,
    int? quantity,
    DateTime? acquiredAt,
    DateTime? expiresAt,
    bool? isExpired,
  });
  InventoryItemCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _InventoryItemCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, InventoryItem, $Out>
    implements InventoryItemCopyWith<$R, InventoryItem, $Out> {
  _InventoryItemCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<InventoryItem> $mapper =
      InventoryItemMapper.ensureInitialized();
  @override
  $R call({
    String? itemId,
    RewardType? type,
    int? quantity,
    DateTime? acquiredAt,
    Object? expiresAt = $none,
    bool? isExpired,
  }) => $apply(
    FieldCopyWithData({
      if (itemId != null) #itemId: itemId,
      if (type != null) #type: type,
      if (quantity != null) #quantity: quantity,
      if (acquiredAt != null) #acquiredAt: acquiredAt,
      if (expiresAt != $none) #expiresAt: expiresAt,
      if (isExpired != null) #isExpired: isExpired,
    }),
  );
  @override
  InventoryItem $make(CopyWithData data) => InventoryItem(
    itemId: data.get(#itemId, or: $value.itemId),
    type: data.get(#type, or: $value.type),
    quantity: data.get(#quantity, or: $value.quantity),
    acquiredAt: data.get(#acquiredAt, or: $value.acquiredAt),
    expiresAt: data.get(#expiresAt, or: $value.expiresAt),
    isExpired: data.get(#isExpired, or: $value.isExpired),
  );

  @override
  InventoryItemCopyWith<$R2, InventoryItem, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _InventoryItemCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class ProductPromotionMapper extends ClassMapperBase<ProductPromotion> {
  ProductPromotionMapper._();

  static ProductPromotionMapper? _instance;
  static ProductPromotionMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ProductPromotionMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'ProductPromotion';

  static String _$promotionId(ProductPromotion v) => v.promotionId;
  static const Field<ProductPromotion, String> _f$promotionId = Field(
    'promotionId',
    _$promotionId,
  );
  static String _$title(ProductPromotion v) => v.title;
  static const Field<ProductPromotion, String> _f$title = Field(
    'title',
    _$title,
  );
  static String _$description(ProductPromotion v) => v.description;
  static const Field<ProductPromotion, String> _f$description = Field(
    'description',
    _$description,
  );
  static List<String> _$productIds(ProductPromotion v) => v.productIds;
  static const Field<ProductPromotion, List<String>> _f$productIds = Field(
    'productIds',
    _$productIds,
  );
  static double _$discountPercent(ProductPromotion v) => v.discountPercent;
  static const Field<ProductPromotion, double> _f$discountPercent = Field(
    'discountPercent',
    _$discountPercent,
  );
  static DateTime _$validFrom(ProductPromotion v) => v.validFrom;
  static const Field<ProductPromotion, DateTime> _f$validFrom = Field(
    'validFrom',
    _$validFrom,
  );
  static DateTime _$validUntil(ProductPromotion v) => v.validUntil;
  static const Field<ProductPromotion, DateTime> _f$validUntil = Field(
    'validUntil',
    _$validUntil,
  );
  static bool _$isActive(ProductPromotion v) => v.isActive;
  static const Field<ProductPromotion, bool> _f$isActive = Field(
    'isActive',
    _$isActive,
    opt: true,
    def: true,
  );
  static bool _$isValid(ProductPromotion v) => v.isValid;
  static const Field<ProductPromotion, bool> _f$isValid = Field(
    'isValid',
    _$isValid,
    mode: FieldMode.member,
  );

  @override
  final MappableFields<ProductPromotion> fields = const {
    #promotionId: _f$promotionId,
    #title: _f$title,
    #description: _f$description,
    #productIds: _f$productIds,
    #discountPercent: _f$discountPercent,
    #validFrom: _f$validFrom,
    #validUntil: _f$validUntil,
    #isActive: _f$isActive,
    #isValid: _f$isValid,
  };

  static ProductPromotion _instantiate(DecodingData data) {
    return ProductPromotion(
      promotionId: data.dec(_f$promotionId),
      title: data.dec(_f$title),
      description: data.dec(_f$description),
      productIds: data.dec(_f$productIds),
      discountPercent: data.dec(_f$discountPercent),
      validFrom: data.dec(_f$validFrom),
      validUntil: data.dec(_f$validUntil),
      isActive: data.dec(_f$isActive),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ProductPromotion fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ProductPromotion>(map);
  }

  static ProductPromotion fromJson(String json) {
    return ensureInitialized().decodeJson<ProductPromotion>(json);
  }
}

mixin ProductPromotionMappable {
  String toJson() {
    return ProductPromotionMapper.ensureInitialized()
        .encodeJson<ProductPromotion>(this as ProductPromotion);
  }

  Map<String, dynamic> toMap() {
    return ProductPromotionMapper.ensureInitialized()
        .encodeMap<ProductPromotion>(this as ProductPromotion);
  }

  ProductPromotionCopyWith<ProductPromotion, ProductPromotion, ProductPromotion>
  get copyWith =>
      _ProductPromotionCopyWithImpl<ProductPromotion, ProductPromotion>(
        this as ProductPromotion,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return ProductPromotionMapper.ensureInitialized().stringifyValue(
      this as ProductPromotion,
    );
  }

  @override
  bool operator ==(Object other) {
    return ProductPromotionMapper.ensureInitialized().equalsValue(
      this as ProductPromotion,
      other,
    );
  }

  @override
  int get hashCode {
    return ProductPromotionMapper.ensureInitialized().hashValue(
      this as ProductPromotion,
    );
  }
}

extension ProductPromotionValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ProductPromotion, $Out> {
  ProductPromotionCopyWith<$R, ProductPromotion, $Out>
  get $asProductPromotion =>
      $base.as((v, t, t2) => _ProductPromotionCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ProductPromotionCopyWith<$R, $In extends ProductPromotion, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get productIds;
  $R call({
    String? promotionId,
    String? title,
    String? description,
    List<String>? productIds,
    double? discountPercent,
    DateTime? validFrom,
    DateTime? validUntil,
    bool? isActive,
  });
  ProductPromotionCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _ProductPromotionCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ProductPromotion, $Out>
    implements ProductPromotionCopyWith<$R, ProductPromotion, $Out> {
  _ProductPromotionCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ProductPromotion> $mapper =
      ProductPromotionMapper.ensureInitialized();
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get productIds =>
      ListCopyWith(
        $value.productIds,
        (v, t) => ObjectCopyWith(v, $identity, t),
        (v) => call(productIds: v),
      );
  @override
  $R call({
    String? promotionId,
    String? title,
    String? description,
    List<String>? productIds,
    double? discountPercent,
    DateTime? validFrom,
    DateTime? validUntil,
    bool? isActive,
  }) => $apply(
    FieldCopyWithData({
      if (promotionId != null) #promotionId: promotionId,
      if (title != null) #title: title,
      if (description != null) #description: description,
      if (productIds != null) #productIds: productIds,
      if (discountPercent != null) #discountPercent: discountPercent,
      if (validFrom != null) #validFrom: validFrom,
      if (validUntil != null) #validUntil: validUntil,
      if (isActive != null) #isActive: isActive,
    }),
  );
  @override
  ProductPromotion $make(CopyWithData data) => ProductPromotion(
    promotionId: data.get(#promotionId, or: $value.promotionId),
    title: data.get(#title, or: $value.title),
    description: data.get(#description, or: $value.description),
    productIds: data.get(#productIds, or: $value.productIds),
    discountPercent: data.get(#discountPercent, or: $value.discountPercent),
    validFrom: data.get(#validFrom, or: $value.validFrom),
    validUntil: data.get(#validUntil, or: $value.validUntil),
    isActive: data.get(#isActive, or: $value.isActive),
  );

  @override
  ProductPromotionCopyWith<$R2, ProductPromotion, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ProductPromotionCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class ProcessPurchaseRequestMapper
    extends ClassMapperBase<ProcessPurchaseRequest> {
  ProcessPurchaseRequestMapper._();

  static ProcessPurchaseRequestMapper? _instance;
  static ProcessPurchaseRequestMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ProcessPurchaseRequestMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'ProcessPurchaseRequest';

  static String _$userId(ProcessPurchaseRequest v) => v.userId;
  static const Field<ProcessPurchaseRequest, String> _f$userId = Field(
    'userId',
    _$userId,
  );
  static String _$productId(ProcessPurchaseRequest v) => v.productId;
  static const Field<ProcessPurchaseRequest, String> _f$productId = Field(
    'productId',
    _$productId,
  );
  static int _$quantity(ProcessPurchaseRequest v) => v.quantity;
  static const Field<ProcessPurchaseRequest, int> _f$quantity = Field(
    'quantity',
    _$quantity,
    opt: true,
    def: 1,
  );
  static PaymentMethod _$paymentMethod(ProcessPurchaseRequest v) =>
      v.paymentMethod;
  static const Field<ProcessPurchaseRequest, PaymentMethod> _f$paymentMethod =
      Field('paymentMethod', _$paymentMethod);
  static String? _$promotionCode(ProcessPurchaseRequest v) => v.promotionCode;
  static const Field<ProcessPurchaseRequest, String> _f$promotionCode = Field(
    'promotionCode',
    _$promotionCode,
    opt: true,
  );

  @override
  final MappableFields<ProcessPurchaseRequest> fields = const {
    #userId: _f$userId,
    #productId: _f$productId,
    #quantity: _f$quantity,
    #paymentMethod: _f$paymentMethod,
    #promotionCode: _f$promotionCode,
  };

  static ProcessPurchaseRequest _instantiate(DecodingData data) {
    return ProcessPurchaseRequest(
      userId: data.dec(_f$userId),
      productId: data.dec(_f$productId),
      quantity: data.dec(_f$quantity),
      paymentMethod: data.dec(_f$paymentMethod),
      promotionCode: data.dec(_f$promotionCode),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ProcessPurchaseRequest fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ProcessPurchaseRequest>(map);
  }

  static ProcessPurchaseRequest fromJson(String json) {
    return ensureInitialized().decodeJson<ProcessPurchaseRequest>(json);
  }
}

mixin ProcessPurchaseRequestMappable {
  String toJson() {
    return ProcessPurchaseRequestMapper.ensureInitialized()
        .encodeJson<ProcessPurchaseRequest>(this as ProcessPurchaseRequest);
  }

  Map<String, dynamic> toMap() {
    return ProcessPurchaseRequestMapper.ensureInitialized()
        .encodeMap<ProcessPurchaseRequest>(this as ProcessPurchaseRequest);
  }

  ProcessPurchaseRequestCopyWith<
    ProcessPurchaseRequest,
    ProcessPurchaseRequest,
    ProcessPurchaseRequest
  >
  get copyWith =>
      _ProcessPurchaseRequestCopyWithImpl<
        ProcessPurchaseRequest,
        ProcessPurchaseRequest
      >(this as ProcessPurchaseRequest, $identity, $identity);
  @override
  String toString() {
    return ProcessPurchaseRequestMapper.ensureInitialized().stringifyValue(
      this as ProcessPurchaseRequest,
    );
  }

  @override
  bool operator ==(Object other) {
    return ProcessPurchaseRequestMapper.ensureInitialized().equalsValue(
      this as ProcessPurchaseRequest,
      other,
    );
  }

  @override
  int get hashCode {
    return ProcessPurchaseRequestMapper.ensureInitialized().hashValue(
      this as ProcessPurchaseRequest,
    );
  }
}

extension ProcessPurchaseRequestValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ProcessPurchaseRequest, $Out> {
  ProcessPurchaseRequestCopyWith<$R, ProcessPurchaseRequest, $Out>
  get $asProcessPurchaseRequest => $base.as(
    (v, t, t2) => _ProcessPurchaseRequestCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class ProcessPurchaseRequestCopyWith<
  $R,
  $In extends ProcessPurchaseRequest,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? userId,
    String? productId,
    int? quantity,
    PaymentMethod? paymentMethod,
    String? promotionCode,
  });
  ProcessPurchaseRequestCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _ProcessPurchaseRequestCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ProcessPurchaseRequest, $Out>
    implements
        ProcessPurchaseRequestCopyWith<$R, ProcessPurchaseRequest, $Out> {
  _ProcessPurchaseRequestCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ProcessPurchaseRequest> $mapper =
      ProcessPurchaseRequestMapper.ensureInitialized();
  @override
  $R call({
    String? userId,
    String? productId,
    int? quantity,
    PaymentMethod? paymentMethod,
    Object? promotionCode = $none,
  }) => $apply(
    FieldCopyWithData({
      if (userId != null) #userId: userId,
      if (productId != null) #productId: productId,
      if (quantity != null) #quantity: quantity,
      if (paymentMethod != null) #paymentMethod: paymentMethod,
      if (promotionCode != $none) #promotionCode: promotionCode,
    }),
  );
  @override
  ProcessPurchaseRequest $make(CopyWithData data) => ProcessPurchaseRequest(
    userId: data.get(#userId, or: $value.userId),
    productId: data.get(#productId, or: $value.productId),
    quantity: data.get(#quantity, or: $value.quantity),
    paymentMethod: data.get(#paymentMethod, or: $value.paymentMethod),
    promotionCode: data.get(#promotionCode, or: $value.promotionCode),
  );

  @override
  ProcessPurchaseRequestCopyWith<$R2, ProcessPurchaseRequest, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _ProcessPurchaseRequestCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class PurchaseStatsMapper extends ClassMapperBase<PurchaseStats> {
  PurchaseStatsMapper._();

  static PurchaseStatsMapper? _instance;
  static PurchaseStatsMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PurchaseStatsMapper._());
      PurchaseableProductMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'PurchaseStats';

  static int _$totalPurchases(PurchaseStats v) => v.totalPurchases;
  static const Field<PurchaseStats, int> _f$totalPurchases = Field(
    'totalPurchases',
    _$totalPurchases,
  );
  static double _$totalRevenue(PurchaseStats v) => v.totalRevenue;
  static const Field<PurchaseStats, double> _f$totalRevenue = Field(
    'totalRevenue',
    _$totalRevenue,
  );
  static Map<ProductType, int> _$purchasesByType(PurchaseStats v) =>
      v.purchasesByType;
  static const Field<PurchaseStats, Map<ProductType, int>> _f$purchasesByType =
      Field('purchasesByType', _$purchasesByType);
  static Map<RewardType, int> _$rewardsDistribution(PurchaseStats v) =>
      v.rewardsDistribution;
  static const Field<PurchaseStats, Map<RewardType, int>>
  _f$rewardsDistribution = Field('rewardsDistribution', _$rewardsDistribution);
  static List<PurchaseableProduct> _$topSellingProducts(PurchaseStats v) =>
      v.topSellingProducts;
  static const Field<PurchaseStats, List<PurchaseableProduct>>
  _f$topSellingProducts = Field('topSellingProducts', _$topSellingProducts);
  static double _$averageTransactionValue(PurchaseStats v) =>
      v.averageTransactionValue;
  static const Field<PurchaseStats, double> _f$averageTransactionValue = Field(
    'averageTransactionValue',
    _$averageTransactionValue,
  );
  static DateTime _$generatedAt(PurchaseStats v) => v.generatedAt;
  static const Field<PurchaseStats, DateTime> _f$generatedAt = Field(
    'generatedAt',
    _$generatedAt,
  );

  @override
  final MappableFields<PurchaseStats> fields = const {
    #totalPurchases: _f$totalPurchases,
    #totalRevenue: _f$totalRevenue,
    #purchasesByType: _f$purchasesByType,
    #rewardsDistribution: _f$rewardsDistribution,
    #topSellingProducts: _f$topSellingProducts,
    #averageTransactionValue: _f$averageTransactionValue,
    #generatedAt: _f$generatedAt,
  };

  static PurchaseStats _instantiate(DecodingData data) {
    return PurchaseStats(
      totalPurchases: data.dec(_f$totalPurchases),
      totalRevenue: data.dec(_f$totalRevenue),
      purchasesByType: data.dec(_f$purchasesByType),
      rewardsDistribution: data.dec(_f$rewardsDistribution),
      topSellingProducts: data.dec(_f$topSellingProducts),
      averageTransactionValue: data.dec(_f$averageTransactionValue),
      generatedAt: data.dec(_f$generatedAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static PurchaseStats fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PurchaseStats>(map);
  }

  static PurchaseStats fromJson(String json) {
    return ensureInitialized().decodeJson<PurchaseStats>(json);
  }
}

mixin PurchaseStatsMappable {
  String toJson() {
    return PurchaseStatsMapper.ensureInitialized().encodeJson<PurchaseStats>(
      this as PurchaseStats,
    );
  }

  Map<String, dynamic> toMap() {
    return PurchaseStatsMapper.ensureInitialized().encodeMap<PurchaseStats>(
      this as PurchaseStats,
    );
  }

  PurchaseStatsCopyWith<PurchaseStats, PurchaseStats, PurchaseStats>
  get copyWith => _PurchaseStatsCopyWithImpl<PurchaseStats, PurchaseStats>(
    this as PurchaseStats,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return PurchaseStatsMapper.ensureInitialized().stringifyValue(
      this as PurchaseStats,
    );
  }

  @override
  bool operator ==(Object other) {
    return PurchaseStatsMapper.ensureInitialized().equalsValue(
      this as PurchaseStats,
      other,
    );
  }

  @override
  int get hashCode {
    return PurchaseStatsMapper.ensureInitialized().hashValue(
      this as PurchaseStats,
    );
  }
}

extension PurchaseStatsValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PurchaseStats, $Out> {
  PurchaseStatsCopyWith<$R, PurchaseStats, $Out> get $asPurchaseStats =>
      $base.as((v, t, t2) => _PurchaseStatsCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class PurchaseStatsCopyWith<$R, $In extends PurchaseStats, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  MapCopyWith<$R, ProductType, int, ObjectCopyWith<$R, int, int>>
  get purchasesByType;
  MapCopyWith<$R, RewardType, int, ObjectCopyWith<$R, int, int>>
  get rewardsDistribution;
  ListCopyWith<
    $R,
    PurchaseableProduct,
    PurchaseableProductCopyWith<$R, PurchaseableProduct, PurchaseableProduct>
  >
  get topSellingProducts;
  $R call({
    int? totalPurchases,
    double? totalRevenue,
    Map<ProductType, int>? purchasesByType,
    Map<RewardType, int>? rewardsDistribution,
    List<PurchaseableProduct>? topSellingProducts,
    double? averageTransactionValue,
    DateTime? generatedAt,
  });
  PurchaseStatsCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _PurchaseStatsCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PurchaseStats, $Out>
    implements PurchaseStatsCopyWith<$R, PurchaseStats, $Out> {
  _PurchaseStatsCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PurchaseStats> $mapper =
      PurchaseStatsMapper.ensureInitialized();
  @override
  MapCopyWith<$R, ProductType, int, ObjectCopyWith<$R, int, int>>
  get purchasesByType => MapCopyWith(
    $value.purchasesByType,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(purchasesByType: v),
  );
  @override
  MapCopyWith<$R, RewardType, int, ObjectCopyWith<$R, int, int>>
  get rewardsDistribution => MapCopyWith(
    $value.rewardsDistribution,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(rewardsDistribution: v),
  );
  @override
  ListCopyWith<
    $R,
    PurchaseableProduct,
    PurchaseableProductCopyWith<$R, PurchaseableProduct, PurchaseableProduct>
  >
  get topSellingProducts => ListCopyWith(
    $value.topSellingProducts,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(topSellingProducts: v),
  );
  @override
  $R call({
    int? totalPurchases,
    double? totalRevenue,
    Map<ProductType, int>? purchasesByType,
    Map<RewardType, int>? rewardsDistribution,
    List<PurchaseableProduct>? topSellingProducts,
    double? averageTransactionValue,
    DateTime? generatedAt,
  }) => $apply(
    FieldCopyWithData({
      if (totalPurchases != null) #totalPurchases: totalPurchases,
      if (totalRevenue != null) #totalRevenue: totalRevenue,
      if (purchasesByType != null) #purchasesByType: purchasesByType,
      if (rewardsDistribution != null)
        #rewardsDistribution: rewardsDistribution,
      if (topSellingProducts != null) #topSellingProducts: topSellingProducts,
      if (averageTransactionValue != null)
        #averageTransactionValue: averageTransactionValue,
      if (generatedAt != null) #generatedAt: generatedAt,
    }),
  );
  @override
  PurchaseStats $make(CopyWithData data) => PurchaseStats(
    totalPurchases: data.get(#totalPurchases, or: $value.totalPurchases),
    totalRevenue: data.get(#totalRevenue, or: $value.totalRevenue),
    purchasesByType: data.get(#purchasesByType, or: $value.purchasesByType),
    rewardsDistribution: data.get(
      #rewardsDistribution,
      or: $value.rewardsDistribution,
    ),
    topSellingProducts: data.get(
      #topSellingProducts,
      or: $value.topSellingProducts,
    ),
    averageTransactionValue: data.get(
      #averageTransactionValue,
      or: $value.averageTransactionValue,
    ),
    generatedAt: data.get(#generatedAt, or: $value.generatedAt),
  );

  @override
  PurchaseStatsCopyWith<$R2, PurchaseStats, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _PurchaseStatsCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

