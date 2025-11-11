import '../../../domain/entities/enums.dart';

class DiscoveryFilters {
  final int radiusKm;
  final AccountType? accountType;
  final bool onlineOnly;

  const DiscoveryFilters({this.radiusKm = 25, this.accountType, this.onlineOnly = false});

  DiscoveryFilters copyWith({int? radiusKm, AccountType? accountType, bool? onlineOnly}) {
    return DiscoveryFilters(
      radiusKm: radiusKm ?? this.radiusKm,
      accountType: accountType ?? this.accountType,
      onlineOnly: onlineOnly ?? this.onlineOnly,
    );
  }
}
