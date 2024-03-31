import 'dart:convert';

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
