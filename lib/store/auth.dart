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

  @observable
  bool isSendingCode = false;

  @observable
  bool isLoggingIn = false;

  @observable
  User? user;

  @observable
  List<Pricing> priceList = [];

  @observable
  String paymentMethod = paymentMethods.first;

  @computed
  bool get isPhoneValid => phone != '';

  // @computed
  // bool get isEmailValid => email != '';
  @computed
  bool get isEmailValid => true;

  @computed
  bool get isLoginEnabled => phone != '' && code != '' && !isLoggingIn;

  @computed
  bool get isemailLoginEnabled => email != '' && code != '' && !isLoggingIn;

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
  }

  @action
  void setPaymentMethod(String value) {
    paymentMethod = value;
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

  // @action
  // Future<void> login() async {
  //   isLoggingIn = true;
  //   if (await validateOTP(phone, code)) {
  //     user = await loginWithPhoneCode(phone, code);
  //     isLoggedIn = user != null;
  //   } else {
  //     snack('Invalid code. Please try again.');
  //   }
  //   isLoggingIn = false;
  // }

  @action
  void logout() {
    isLoggedIn = false;
    // snack('log out successfully!');
  }

  @action
  Future<void> sendCode() async {
    isSendingCode = true;
    final r = await sendCodeToPhone(phone);
    // snack('Code sent!');
    isSendingCode = false;
  }

  @action
  Future<void> esendCode() async {
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
