// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$Auth on _Auth, Store {
  Computed<bool>? _$isPhoneValidComputed;

  @override
  bool get isPhoneValid => (_$isPhoneValidComputed ??=
          Computed<bool>(() => super.isPhoneValid, name: '_Auth.isPhoneValid'))
      .value;
  Computed<bool>? _$isLoginEnabledComputed;

  @override
  bool get isLoginEnabled =>
      (_$isLoginEnabledComputed ??= Computed<bool>(() => super.isLoginEnabled,
              name: '_Auth.isLoginEnabled'))
          .value;

  late final _$isLoggedInAtom =
      Atom(name: '_Auth.isLoggedIn', context: context);

  @override
  bool get isLoggedIn {
    _$isLoggedInAtom.reportRead();
    return super.isLoggedIn;
  }

  @override
  set isLoggedIn(bool value) {
    _$isLoggedInAtom.reportWrite(value, super.isLoggedIn, () {
      super.isLoggedIn = value;
    });
  }

  late final _$phoneAtom = Atom(name: '_Auth.phone', context: context);

  @override
  String get phone {
    _$phoneAtom.reportRead();
    return super.phone;
  }

  @override
  set phone(String value) {
    _$phoneAtom.reportWrite(value, super.phone, () {
      super.phone = value;
    });
  }

  late final _$codeAtom = Atom(name: '_Auth.code', context: context);

  @override
  String get code {
    _$codeAtom.reportRead();
    return super.code;
  }

  @override
  set code(String value) {
    _$codeAtom.reportWrite(value, super.code, () {
      super.code = value;
    });
  }

  late final _$isSendingCodeAtom =
      Atom(name: '_Auth.isSendingCode', context: context);

  @override
  bool get isSendingCode {
    _$isSendingCodeAtom.reportRead();
    return super.isSendingCode;
  }

  @override
  set isSendingCode(bool value) {
    _$isSendingCodeAtom.reportWrite(value, super.isSendingCode, () {
      super.isSendingCode = value;
    });
  }

  late final _$isLoggingInAtom =
      Atom(name: '_Auth.isLoggingIn', context: context);

  @override
  bool get isLoggingIn {
    _$isLoggingInAtom.reportRead();
    return super.isLoggingIn;
  }

  @override
  set isLoggingIn(bool value) {
    _$isLoggingInAtom.reportWrite(value, super.isLoggingIn, () {
      super.isLoggingIn = value;
    });
  }

  late final _$userAtom = Atom(name: '_Auth.user', context: context);

  @override
  User? get user {
    _$userAtom.reportRead();
    return super.user;
  }

  @override
  set user(User? value) {
    _$userAtom.reportWrite(value, super.user, () {
      super.user = value;
    });
  }

  late final _$priceListAtom = Atom(name: '_Auth.priceList', context: context);

  @override
  List<Pricing> get priceList {
    _$priceListAtom.reportRead();
    return super.priceList;
  }

  @override
  set priceList(List<Pricing> value) {
    _$priceListAtom.reportWrite(value, super.priceList, () {
      super.priceList = value;
    });
  }

  late final _$loginAsyncAction = AsyncAction('_Auth.login', context: context);

  @override
  Future<void> login() {
    return _$loginAsyncAction.run(() => super.login());
  }

  late final _$sendCodeAsyncAction =
      AsyncAction('_Auth.sendCode', context: context);

  @override
  Future<void> sendCode() {
    return _$sendCodeAsyncAction.run(() => super.sendCode());
  }

  late final _$getPricesAsyncAction =
      AsyncAction('_Auth.getPrices', context: context);

  @override
  Future<void> getPrices() {
    return _$getPricesAsyncAction.run(() => super.getPrices());
  }

  late final _$_AuthActionController =
      ActionController(name: '_Auth', context: context);

  @override
  void setPhone(String value) {
    final _$actionInfo =
        _$_AuthActionController.startAction(name: '_Auth.setPhone');
    try {
      return super.setPhone(value);
    } finally {
      _$_AuthActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCode(String value) {
    final _$actionInfo =
        _$_AuthActionController.startAction(name: '_Auth.setCode');
    try {
      return super.setCode(value);
    } finally {
      _$_AuthActionController.endAction(_$actionInfo);
    }
  }

  @override
  void logout() {
    final _$actionInfo =
        _$_AuthActionController.startAction(name: '_Auth.logout');
    try {
      return super.logout();
    } finally {
      _$_AuthActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoggedIn: ${isLoggedIn},
phone: ${phone},
code: ${code},
isSendingCode: ${isSendingCode},
isLoggingIn: ${isLoggingIn},
user: ${user},
priceList: ${priceList},
isPhoneValid: ${isPhoneValid},
isLoginEnabled: ${isLoginEnabled}
    ''';
  }
}
