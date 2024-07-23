import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env', requireEnvFile: false, obfuscate: true)
abstract class Env {
  @EnviedField(varName: 'OPENAI_API_KEY')
  static final String openaiApiKey = _Env.openaiApiKey;

  @EnviedField(varName: 'USER_JWT_SECRET')
  static final String userJwtSecret = _Env.userJwtSecret;
}
