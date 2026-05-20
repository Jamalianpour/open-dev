import 'dart:convert';

import 'package:yaml/yaml.dart';
import 'package:yaml_edit/yaml_edit.dart';

String prettyJson(String jsonString) {
  // Convert the JSON string to a Dart object (Map)
  Map<String, dynamic> jsonData = jsonDecode(jsonString);

  // Create a JsonEncoder with indentation
  const JsonEncoder encoder = JsonEncoder.withIndent('  ');

  // Convert the Dart object back to a JSON string with indentation
  return encoder.convert(jsonData);
}

String minifyJson(String jsonString) {
  // Convert the JSON string to a Dart object (Map)
  Map<String, dynamic> jsonData = jsonDecode(jsonString);

  // Create a JsonEncoder with indentation
  const JsonEncoder encoder = JsonEncoder.withIndent('');

  // Convert the Dart object back to a JSON string with indentation
  return encoder.convert(jsonData).trim().replaceAll('\n', '');
}

String convertJsonToYaml(String jsonString) {
  final jsonValue = json.decode(jsonString);

  YamlEditor yamlEditor = YamlEditor('');
  yamlEditor.update([], jsonValue);
  return yamlEditor.toString();
}

/// Converts a YAML document to a pretty-printed JSON string.
String convertYamlToJson(String yamlString) {
  final parsed = loadYaml(yamlString);
  final native = _yamlToNative(parsed);
  const encoder = JsonEncoder.withIndent('  ');
  return encoder.convert(native);
}

/// Recursively converts `YamlMap`/`YamlList`/scalar values into the standard
/// `Map<String, dynamic>` / `List<dynamic>` types that `jsonEncode` accepts.
dynamic _yamlToNative(dynamic node) {
  if (node is YamlMap) {
    return {
      for (final entry in node.entries)
        entry.key.toString(): _yamlToNative(entry.value),
    };
  }
  if (node is YamlList) {
    return [for (final v in node) _yamlToNative(v)];
  }
  return node;
}
