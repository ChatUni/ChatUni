import 'package:mobx/mobx.dart';

import '/api/auth.dart';
import '/models/user.dart';

part 'auth.g.dart';

class Auth = _Auth with _$Auth;

abstract class _Auth with Store {
  @observable
  bool isLoggedIn = false;

  @observable
  String phone = '';

  @observable
  String code = '';

  @observable
  bool isSendingCode = false;

  @observable
  bool isLoggingIn = false;

  @observable
  User? user;

  @computed
  bool get isPhoneValid => phone != '';

  @computed
  bool get isLoginEnabled => phone != '' && code != '' && !isLoggingIn;

  @action
  void setPhone(String value) {
    phone = value;
  }

  @action
  void setCode(String value) {
    code = value;
  }

  @action
  Future<void> login() async {
    isLoggingIn = true;
    user = await loginWithPhoneCode(phone, code);
    isLoggingIn = false;
    isLoggedIn = true;
  }

  @action
  void logout() {
    isLoggedIn = false;
  }

  @action
  Future<void> sendCode() async {
    isSendingCode = true;
    final r = await sendCodeToPhone(phone);
    isSendingCode = false;
  }
}
