// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'enums.dart';

class AccountTypeMapper extends EnumMapper<AccountType> {
  AccountTypeMapper._();

  static AccountTypeMapper? _instance;
  static AccountTypeMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AccountTypeMapper._());
    }
    return _instance!;
  }

  static AccountType fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  AccountType decode(dynamic value) {
    switch (value) {
      case r'customer':
        return AccountType.customer;
      case r'barber':
        return AccountType.barber;
      case r'barbershop':
        return AccountType.barbershop;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(AccountType self) {
    switch (self) {
      case AccountType.customer:
        return r'customer';
      case AccountType.barber:
        return r'barber';
      case AccountType.barbershop:
        return r'barbershop';
    }
  }
}

extension AccountTypeMapperExtension on AccountType {
  String toValue() {
    AccountTypeMapper.ensureInitialized();
    return MapperContainer.globals.toValue<AccountType>(this) as String;
  }
}

class VacancyTypeMapper extends EnumMapper<VacancyType> {
  VacancyTypeMapper._();

  static VacancyTypeMapper? _instance;
  static VacancyTypeMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = VacancyTypeMapper._());
    }
    return _instance!;
  }

  static VacancyType fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  VacancyType decode(dynamic value) {
    switch (value) {
      case r'freelancer':
        return VacancyType.freelancer;
      case r'clt':
        return VacancyType.clt;
      case r'commission':
        return VacancyType.commission;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(VacancyType self) {
    switch (self) {
      case VacancyType.freelancer:
        return r'freelancer';
      case VacancyType.clt:
        return r'clt';
      case VacancyType.commission:
        return r'commission';
    }
  }
}

extension VacancyTypeMapperExtension on VacancyType {
  String toValue() {
    VacancyTypeMapper.ensureInitialized();
    return MapperContainer.globals.toValue<VacancyType>(this) as String;
  }
}

class ApplicationStatusMapper extends EnumMapper<ApplicationStatus> {
  ApplicationStatusMapper._();

  static ApplicationStatusMapper? _instance;
  static ApplicationStatusMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ApplicationStatusMapper._());
    }
    return _instance!;
  }

  static ApplicationStatus fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  ApplicationStatus decode(dynamic value) {
    switch (value) {
      case r'pending':
        return ApplicationStatus.pending;
      case r'accepted':
        return ApplicationStatus.accepted;
      case r'rejected':
        return ApplicationStatus.rejected;
      case r'withdrawn':
        return ApplicationStatus.withdrawn;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(ApplicationStatus self) {
    switch (self) {
      case ApplicationStatus.pending:
        return r'pending';
      case ApplicationStatus.accepted:
        return r'accepted';
      case ApplicationStatus.rejected:
        return r'rejected';
      case ApplicationStatus.withdrawn:
        return r'withdrawn';
    }
  }
}

extension ApplicationStatusMapperExtension on ApplicationStatus {
  String toValue() {
    ApplicationStatusMapper.ensureInitialized();
    return MapperContainer.globals.toValue<ApplicationStatus>(this) as String;
  }
}

