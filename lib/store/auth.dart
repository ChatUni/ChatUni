import 'package:mobx/mobx.dart';
import 'package:url_launcher/url_launcher.dart';

import '/api/auth.dart';
import '/api/payment.dart';
import '/models/pricing.dart';
import '/models/user.dart';

part 'auth.g.dart';

final countryCodes = ['+86', '+1'];
final paymentMethods = ['Wechat', 'Alipay'];

class Auth = _Auth with _$Auth;

abstract class _Auth with Store {
  @observable
  bool isLoggedIn = false;

  @observable
  String phone = '';

  @observable
  String email = '';

  @observable
  String countryCode = countryCodes.first;

  @observable
  String code = '';

  // @observable
  // String cpcode = '';

  @observable
  bool isSendingCode = false;

  @observable
  bool isLoggingIn = false;

  @observable
  bool hasSentCodeBefore = false;

  @observable
  bool optmatch = false;

  @observable
  User? user;

  @observable
  List<Pricing> priceList = [];

  @observable
  String paymentMethod = paymentMethods.first;

  @computed
  bool get isPhoneValid => phone != '';

  @computed
  bool get isEmailValid => true;

  @computed
  bool get isLoginEnabled => phone != '' && code != '' && !isLoggingIn;

  @computed
  bool get isemailLoginEnabled => isEmailValid && code != '' && !isLoggingIn;

  @action
  void setPhone(String value) {
    phone = value;
  }

  @action
  void setEmail(String value) {
    email = value;
  }

  @action
  void setCountryCode(String value) {
    countryCode = value;
  }

  @action
  void setCode(String value) {
    code = value;
    // cpcode = value;
  }

  @action
  void setPaymentMethod(String value) {
    paymentMethod = value;
  }

  @action
  void ValidateOPT(String phone, String code) {
    if (phone == code) {
      optmatch = true;
    }
  }

  @action
  Future<void> login() async {
    isLoggingIn = true;
    user = await loginWithPhoneCode(phone, code);
    isLoggingIn = false;
    isLoggedIn = true;
  }

  @action
  Future<void> elogin() async {
    isLoggingIn = true;
    user = await loginWithEmailCode(email, code);
    isLoggingIn = false;
    isLoggedIn = true;
  }

  @action
  void logout() {
    isLoggedIn = false;
  }

  @action
  Future<void> sendCode() async {
    if (!hasSentCodeBefore) {
      // This is the first time sending the code
      print('Sending code for the first time');
      hasSentCodeBefore = true;
    } else {
      // Logic for subsequent sends
      print('Code has already been sent before');
    }

    isSendingCode = true;
    final r = await sendCodeToPhone(phone);
    isSendingCode = false;
  }

  @action
  Future<void> esendCode() async {
    if (!hasSentCodeBefore) {
      // This is the first time sending the code
      print('Sending code for the first time');
      hasSentCodeBefore = true;
    } else {
      // Logic for subsequent sends
      print('Code has already been sent before');
    }

    isSendingCode = true;
    final r = await sendCodeToEmail(email);
    isSendingCode = false;
  }

  @action
  Future<void> getPrices() async {
    priceList = await getPriceList();
  }

  @action
  Future<void> createPayment(int id) async {
    final r = await createPayorder(id, paymentMethod);
    await launchUrl(Uri.parse(r['payurl']));
  }
}
