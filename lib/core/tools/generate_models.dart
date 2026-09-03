import 'dart:convert';
import 'dart:io';

import 'package:flutter_app_foundation/env.dart';

Future<void> main() async {
  final swaggerFile = File('lib/generated/swagger/common.swagger');

  if (swaggerFile.existsSync()) {
    jsonDecode(await swaggerFile.readAsString());
    // ignore: avoid_print
    print('Using local Swagger: ${swaggerFile.path}');
  } else {
    final swaggerUrl = Env.swaggerUrl;
    if (swaggerUrl.isEmpty) {
      throw StateError(
        'Local Swagger file not found. Set SWAGGER_URL in .env.dev or .env.prod.',
      );
    }
    final client = HttpClient();

    try {
      final request = await client.getUrl(Uri.parse(swaggerUrl));
      final response = await request.close();

      if (response.statusCode != HttpStatus.ok) {
        throw Exception(
          'Swagger download failed: ${response.statusCode}',
        );
      }

      final body = await response.transform(utf8.decoder).join();
      jsonDecode(body);

      await swaggerFile.parent.create(recursive: true);
      await swaggerFile.writeAsString(body);

      // ignore: avoid_print
      print('Swagger downloaded');
    } finally {
      client.close();
    }
  }

  // 2. build_runner çalıştır
  final result = await Process.run(
    'dart',
    [
      'run',
      'build_runner',
      'build',
    ],
    runInShell: true,
  );

  stdout.write(result.stdout);
  stderr.write(result.stderr);

  if (result.exitCode != 0) {
    exit(result.exitCode);
  }

  final dioResult = await Process.run(
    'dart',
    [
      'run',
      'lib/core/tools/generate_dio_services.dart',
    ],
    runInShell: true,
  );

  stdout.write(dioResult.stdout);
  stderr.write(dioResult.stderr);

  if (dioResult.exitCode != 0) {
    exit(dioResult.exitCode);
  }
}
