import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env', requireEnvFile: false, obfuscate: true)
abstract class Env {
  @EnviedField(varName: 'OPENAI_API_KEY')
  static final String openaiApiKey = _Env.openaiApiKey;

  @EnviedField(varName: 'ELEVENLABS_API_KEY')
  static final String elevenlabsApiKey = _Env.elevenlabsApiKey;

  @EnviedField(varName: 'HEYGEN_API_KEY')
  static final String heygenApiKey = _Env.heygenApiKey;

  @EnviedField(varName: 'D_ID_API_KEY')
  static final String dIdApiKey = _Env.dIdApiKey;

  @EnviedField(varName: 'YOUDAO_APP_KEY')
  static final String youdaoAppKey = _Env.youdaoAppKey;

  @EnviedField(varName: 'YOUDAO_APP_SECRET')
  static final String youdaoAppSecret = _Env.youdaoAppSecret;

  @EnviedField(varName: 'ABLY_API_KEY')
  static final String ablyAppKey = _Env.ablyAppKey;

  @EnviedField(varName: 'USER_JWT_SECRET')
  static final String userJwtSecret = _Env.userJwtSecret;
}
