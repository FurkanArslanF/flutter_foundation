// ignore_for_file: cascade_invocations, unused_element

import 'dart:convert';
import 'dart:io';

const _swaggerPath = 'lib/generated/swagger/common.swagger';
const _outputPath = 'lib/generated/dio/common_api.dart';
const key = r'$key';
Future<void> main() async {
  final document = jsonDecode(await File(_swaggerPath).readAsString()) as Map<String, dynamic>;
  final output = StringBuffer()
    ..writeln("import 'package:flutter_app_foundation/core/network/base_service.dart';")
    ..writeln("import 'package:dio/dio.dart';")
    ..writeln("import '../common.models.swagger.dart';")
    ..writeln()
    ..writeln('class CommonApi extends BaseService {')
    ..writeln('  dynamic _encode(dynamic value) {')
    ..writeln('    if (value == null) return null;')
    ..writeln('    if (value is Map) {')
    ..writeln('      return value.map((key, item) => MapEntry(key, _encode(item)));')
    ..writeln('    }')
    ..writeln('    if (value is List) return value.map(_encode).toList();')
    ..writeln('    if (value is Enum) return (value as dynamic).value;')
    ..writeln('    return (value as dynamic).toJson();')
    ..writeln('  }')
    ..writeln()
    ..writeln('  String _path(String template, Map<String, dynamic> values) {')
    ..writeln('    var result = template;')
    ..writeln('    values.forEach((key, value) {')
    ..writeln(r"      result = result.replaceAll('{$key}', Uri.encodeComponent(value.toString()));")
    ..writeln('    });')
    ..writeln('    return result;')
    ..writeln('  }')
    ..writeln();

  final paths = document['paths'] as Map<String, dynamic>? ?? {};
  final usedNames = <String, int>{};
  for (final pathEntry in paths.entries) {
    final path = pathEntry.key;
    final pathItem = pathEntry.value as Map<String, dynamic>;
    for (final methodEntry in pathItem.entries) {
      if (!_httpMethods.contains(methodEntry.key)) {
        continue;
      }
      final operation = methodEntry.value as Map<String, dynamic>;
      final methodName = _uniqueMethodName(
        _operationName(operation, methodEntry.key, path),
        usedNames,
      );
      _writeMethod(output, path, methodEntry.key, operation, methodName);
    }
  }

  output.writeln('}');
  final file = File(_outputPath);
  await file.parent.create(recursive: true);
  await file.writeAsString(output.toString());
  stdout.writeln('Dio API generated: $_outputPath');
}

const _httpMethods = {'get', 'post', 'put', 'patch', 'delete', 'head'};

void _writeMethod(
  StringBuffer output,
  String path,
  String httpMethod,
  Map<String, dynamic> operation,
  String methodName,
) {
  final parameters = <Map<String, dynamic>>[];
  final operationParameters = operation['parameters'] as List<dynamic>? ?? [];
  for (final parameter in operationParameters) {
    parameters.add(parameter as Map<String, dynamic>);
  }

  final pathParameters = parameters.where((parameter) => parameter['in'] == 'path').toList();
  final queryParameters = parameters.where((parameter) => parameter['in'] == 'query').toList();
  final headerParameters = parameters.where((parameter) => parameter['in'] == 'header').toList();
  final pageParameter = _findQueryParameter(queryParameters, 'pagenumber');
  final pageSizeParameter = _findQueryParameter(queryParameters, 'pagesize');
  final isPaginated = httpMethod == 'get' && pageParameter != null && pageSizeParameter != null;
  final bodySchema = _requestBodySchema(operation);
  final bodyType = bodySchema == null ? null : _dartType(bodySchema);
  final responseSchema = _responseSchema(operation);
  final responseType = responseSchema == null ? 'void' : _dartType(responseSchema);

  output.writeln('  Future<$responseType> $methodName({');
  for (final parameter in [...pathParameters, ...queryParameters, ...headerParameters]) {
    final name = _parameterName(parameter['name'] as String);
    final required = parameter['required'] == true;
    final type = _parameterType(parameter['schema'] as Map<String, dynamic>? ?? {}, required);
    output.writeln('    ${required ? 'required ' : ''}$type $name,');
  }
  if (bodyType != null) {
    final bodyRequired = operation['requestBody']?['required'] == true;
    output.writeln('    ${bodyRequired ? 'required ' : ''}${bodyRequired ? bodyType : _nullableType(bodyType)} body,');
  }
  output
    ..writeln('    CancelToken? cancelToken,')
    ..writeln('    ProgressCallback? onSendProgress,')
    ..writeln('    ProgressCallback? onReceiveProgress,')
    ..writeln('  }) async {');
  if (!isPaginated) output.writeln('    final headers = await getHeaders();');
  for (final parameter in headerParameters) {
    final name = _parameterName(parameter['name'] as String);
    output.writeln("    headers['${parameter['name']}'] = $name;");
  }
  if (responseType == 'void') {
    output
      ..writeln('    await requestWithoutResponse(')
      ..writeln("      method: '${httpMethod.toUpperCase()}',")
      ..writeln("      path: _path('$path', {");
    for (final parameter in pathParameters) {
      final name = _parameterName(parameter['name'] as String);
      output.writeln("        '${parameter['name']}': _encode($name),");
    }
    output
      ..writeln('      }),')
      ..writeln("      data: ${bodyType == null ? 'null' : '_encode(body)'},")
      ..writeln('      queryParameters: {');
    for (final parameter in queryParameters) {
      final name = _parameterName(parameter['name'] as String);
      output.writeln("        '${parameter['name']}': $name,");
    }
    output
      ..writeln('      }..removeWhere((key, value) => value == null),')
      ..writeln('      options: Options(headers: headers),')
      ..writeln('      cancelToken: cancelToken,')
      ..writeln('      onSendProgress: onSendProgress,')
      ..writeln('      onReceiveProgress: onReceiveProgress,')
      ..writeln('    );')
      ..writeln('    return;');
  } else {
    if (isPaginated) {
      final pageName = _parameterName(pageParameter['name'] as String);
      final pageSizeName = _parameterName(pageSizeParameter['name'] as String);
      output.writeln('    return paginatedGet<$responseType>(');
      output.writeln("      path: _path('$path', {");
      for (final parameter in pathParameters) {
        final name = _parameterName(parameter['name'] as String);
        output.writeln("        '${parameter['name']}': _encode($name),");
      }
      output.writeln('      }),');
      output.writeln('      page: $pageName ?? 1,');
      output.writeln("      pageParameterName: '${pageParameter['name']}',");
      output.writeln('      pageSize: $pageSizeName,');
      output.writeln("      pageSizeParameterName: '${pageSizeParameter['name']}',");
      output.writeln('      additionalData: {');
      for (final parameter in queryParameters) {
        final name = _parameterName(parameter['name'] as String);
        if (parameter == pageParameter || parameter == pageSizeParameter) continue;
        output.writeln("        '${parameter['name']}': _encode($name),");
      }
      output
        ..writeln('      }..removeWhere((key, value) => value == null),')
        ..writeln('      cancelToken: cancelToken,')
        ..writeln('      onReceiveProgress: onReceiveProgress,')
        ..writeln('      parser: (data) => ${_decodeExpression(responseSchema!, responseType, 'data')},')
        ..writeln('    );');
    } else {
      final baseMethod = _baseMethod(httpMethod);
      output.writeln('    return $baseMethod<$responseType>(');
      output.writeln("      path: _path('$path', {");
      for (final parameter in pathParameters) {
        final name = _parameterName(parameter['name'] as String);
        output.writeln("        '${parameter['name']}': _encode($name),");
      }
      output.writeln('      }),');
      if (bodyType != null) output.writeln('      data: _encode(body),');
      output.writeln('      queryParameters: {');
      for (final parameter in queryParameters) {
        final name = _parameterName(parameter['name'] as String);
        output.writeln("        '${parameter['name']}': _encode($name),");
      }
      output
        ..writeln('      }..removeWhere((key, value) => value == null),')
        ..writeln('      options: Options(headers: headers),')
        ..writeln('      cancelToken: cancelToken,');
      if (httpMethod != 'delete') {
        output.writeln('      onReceiveProgress: onReceiveProgress,');
      }
      if (httpMethod == 'post' || httpMethod == 'put') {
        output.writeln('      onSendProgress: onSendProgress,');
      }
      output
        ..writeln('      parser: (data) => ${_decodeExpression(responseSchema!, responseType, 'data')},')
        ..writeln('    );');
    }
  }
  output
    ..writeln('  }')
    ..writeln();
}

Map<String, dynamic>? _requestBodySchema(Map<String, dynamic> operation) {
  final requestBody = operation['requestBody'] as Map<String, dynamic>?;
  final content = requestBody?['content'] as Map<String, dynamic>?;
  final jsonContent = content?['application/json'] as Map<String, dynamic>? ?? content?.values.firstOrNull as Map<String, dynamic>?;
  return jsonContent?['schema'] as Map<String, dynamic>?;
}

Map<String, dynamic>? _responseSchema(Map<String, dynamic> operation) {
  final responses = operation['responses'] as Map<String, dynamic>? ?? {};
  final success = responses.entries.where((entry) => entry.key.startsWith('2')).toList()..sort((a, b) => a.key.compareTo(b.key));
  if (success.isEmpty) return null;
  final content = (success.first.value as Map<String, dynamic>)['content'] as Map<String, dynamic>?;
  final jsonContent = content?['application/json'] as Map<String, dynamic>? ?? content?.values.firstOrNull as Map<String, dynamic>?;
  return jsonContent?['schema'] as Map<String, dynamic>?;
}

String _dartType(Map<String, dynamic> schema) {
  final reference = schema[r'$ref'] as String?;
  if (reference != null) return reference.split('/').last;
  if (schema['nullable'] == true) return '${_nonNullableType(schema)}?';
  return _nonNullableType(schema);
}

String _parameterType(Map<String, dynamic> schema, bool required) {
  final type = _dartType(schema);
  return required ? type : _nullableType(type);
}

String _nullableType(String type) {
  return type == 'dynamic' || type.endsWith('?') ? type : '$type?';
}

String _nonNullableType(Map<String, dynamic> schema) {
  switch (schema['type']) {
    case 'array':
      return 'List<${_dartType(schema['items'] as Map<String, dynamic>? ?? {})}>';
    case 'integer':
      return 'int';
    case 'number':
      return 'double';
    case 'boolean':
      return 'bool';
    case 'string':
      return 'String';
    case 'object':
      return 'Map<String, dynamic>';
    default:
      return 'dynamic';
  }
}

String _baseMethod(String httpMethod) {
  if (httpMethod == 'get' || httpMethod == 'post' || httpMethod == 'put' || httpMethod == 'delete') {
    return httpMethod;
  }
  return 'get';
}

Map<String, dynamic>? _findQueryParameter(List<Map<String, dynamic>> parameters, String name) {
  for (final parameter in parameters) {
    if ((parameter['name'] as String?)?.toLowerCase() == name) return parameter;
  }
  return null;
}

String _decodeExpression(Map<String, dynamic> schema, String type, String expression) {
  if (schema['type'] == 'array') {
    final itemSchema = schema['items'] as Map<String, dynamic>? ?? {};
    final itemType = _dartType(itemSchema);
    return '($expression as List<dynamic>).map((item) => ${_decodeValue(itemSchema, 'item', itemType)}).toList()';
  }
  return _decodeValue(schema, expression, type);
}

String _decodeValue(Map<String, dynamic> schema, String expression, String type) {
  if (schema[r'$ref'] != null) {
    return '$type.fromJson($expression as Map<String, dynamic>)';
  }
  if (schema['type'] == 'object') return '$expression as $type';
  return '$expression as $type';
}

String _operationName(Map<String, dynamic> operation, String method, String path) {
  final operationId = operation['operationId'] as String?;
  if (operationId != null && operationId.isNotEmpty) return _parameterName(operationId);
  final words = path.replaceAll(RegExp('[^a-zA-Z0-9]+'), ' ').trim().split(RegExp(r'\s+'))..removeWhere((word) => word.isEmpty);
  final suffix = words.map((word) => word[0].toUpperCase() + word.substring(1)).join();
  return '${method.toLowerCase()}$suffix';
}

String _uniqueMethodName(String name, Map<String, int> usedNames) {
  final count = usedNames.update(name, (value) => value + 1, ifAbsent: () => 1);
  return count == 1 ? name : '$name$count';
}

String _parameterName(String value) {
  final words = value.replaceAll(RegExp('[^a-zA-Z0-9]+'), ' ').trim().split(RegExp(r'\s+'))..removeWhere((word) => word.isEmpty);
  if (words.isEmpty) return 'value';

  final result = words.first[0].toLowerCase() + words.first.substring(1) + words.skip(1).map((word) => word[0].toUpperCase() + word.substring(1)).join();
  final safeResult = RegExp('^[0-9]').hasMatch(result) ? '_$result' : result;
  return safeResult;
}

dynamic _encode(dynamic value) {
  if (value == null) return null;
  if (value is String || value is num || value is bool) return value;
  if (value is Map) {
    return value.map((key, item) => MapEntry(key, _encode(item)));
  }
  if (value is List) return value.map(_encode).toList();
  if (value is Enum) return (value as dynamic).value;
  return (value as dynamic).toJson();
}

String _path(String template, Map<String, dynamic> values) {
  var result = template;
  values.forEach((key, value) {
    result = result.replaceAll('{$key}', Uri.encodeComponent(value.toString()));
  });
  return result;
}

extension on Iterable<dynamic> {
  dynamic get firstOrNull => isEmpty ? null : first;
}
