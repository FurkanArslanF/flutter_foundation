import 'dart:convert';
import 'dart:io';

Future<void> main() async {
  final swaggerUrl = _readSwaggerUrl();

  final swaggerFile = File('lib/generated/swagger/common.swagger');

  // 1. Swagger indir
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

    // JSON geçerli mi kontrol et
    jsonDecode(body);

    await swaggerFile.parent.create(recursive: true);
    await swaggerFile.writeAsString(body);

    // ignore: avoid_print
    print('✅ Swagger downloaded');
  } finally {
    client.close();
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

String _readSwaggerUrl() {
  final environmentUrl = Platform.environment['SWAGGER_URL'];
  if (environmentUrl != null && environmentUrl.isNotEmpty) {
    return environmentUrl;
  }

  final envFile = File('.env.dev');
  if (!envFile.existsSync()) {
    throw StateError('SWAGGER_URL is not set and .env.dev was not found');
  }

  for (final line in envFile.readAsLinesSync()) {
    final trimmedLine = line.trim();
    if (trimmedLine.isEmpty || trimmedLine.startsWith('#')) {
      continue;
    }

    final separatorIndex = trimmedLine.indexOf('=');
    if (separatorIndex == -1) {
      continue;
    }

    final key = trimmedLine.substring(0, separatorIndex).trim();
    if (key != 'SWAGGER_URL') {
      continue;
    }

    final value = trimmedLine.substring(separatorIndex + 1).trim();
    if (value.length >= 2 &&
        ((value.startsWith("'") && value.endsWith("'")) ||
            (value.startsWith('"') && value.endsWith('"')))) {
      return value.substring(1, value.length - 1);
    }
    return value;
  }

  throw StateError('SWAGGER_URL was not found in .env.dev');
}
