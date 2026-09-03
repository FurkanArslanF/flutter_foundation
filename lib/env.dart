import 'package:envied/envied.dart';
import 'package:flutter/foundation.dart';
part 'env.g.dart';

@Envied(path: kDebugMode ? '.env.dev' : '.env.prod')
abstract class Env {
  @EnviedField(varName: 'BASE_URL', obfuscate: true)
  static String baseUrl = _Env.baseUrl;
  @EnviedField(varName: 'SWAGGER_URL', obfuscate: true)
  static String swaggerUrl = _Env.swaggerUrl;
}
