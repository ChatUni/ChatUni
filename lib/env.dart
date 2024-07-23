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

  @EnviedField(varName: 'USER_JWT_SECRET')
  static final String userJwtSecret = _Env.userJwtSecret;
}
