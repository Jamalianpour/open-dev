import 'dart:convert';

/// Generates null-safe Dart model classes from a JSON sample.
///
/// Supports nested objects (each becomes its own class), arrays (typed as
/// `List<T>`), and primitive scalars. Empty arrays default to
/// `List<dynamic>`. Heterogeneous arrays also fall back to `List<dynamic>`.
class DartClassUtils {
  /// Builds Dart class source for [jsonString], using [rootName] for the
  /// outer class. Returns the joined source for all generated classes.
  static String generate(
    String jsonString, {
    String rootName = 'Root',
    bool nullable = true,
    bool immutable = true,
  }) {
    final decoded = jsonDecode(jsonString);
    final builder = _Builder(nullable: nullable, immutable: immutable);
    builder.generateClass(decoded, rootName);
    return builder.buffer.toString();
  }
}

class _Builder {
  _Builder({required this.nullable, required this.immutable});

  final bool nullable;
  final bool immutable;
  final StringBuffer buffer = StringBuffer();
  final Set<String> _emitted = {};

  /// Recursively generates a class for [value] (which should be a Map) under
  /// [name]. Returns the class name to use as a type reference.
  String generateClass(dynamic value, String name) {
    if (value is! Map) {
      // Caller asked for a class but the JSON root isn't an object.
      // Bail with a comment so the user sees something useful.
      buffer.writeln('// Root JSON is ${value.runtimeType}, not an object.');
      buffer.writeln('// Wrap your input in `{}` to generate a class.');
      return 'dynamic';
    }

    final className = _uniqueClassName(name);
    final fields = <_Field>[];
    for (final entry in value.entries) {
      final fieldName = _camelCase(entry.key.toString());
      final fieldType = _typeFor(entry.value, _pascalCase(entry.key.toString()));
      fields.add(_Field(
        jsonKey: entry.key.toString(),
        dartName: fieldName,
        dartType: fieldType,
      ));
    }

    _emitClass(className, fields);
    return className;
  }

  String _typeFor(dynamic value, String hintedName) {
    if (value == null) return 'dynamic';
    if (value is bool) return 'bool';
    if (value is int) return 'int';
    if (value is double) return 'double';
    if (value is String) return 'String';
    if (value is List) {
      if (value.isEmpty) return 'List<dynamic>';
      // Find a common element type. If the list mixes shapes, fall back.
      final first = value.first;
      for (final v in value.skip(1)) {
        if (v.runtimeType != first.runtimeType) return 'List<dynamic>';
      }
      final inner = _typeFor(first, hintedName);
      return 'List<$inner>';
    }
    if (value is Map) {
      return generateClass(value, hintedName);
    }
    return 'dynamic';
  }

  void _emitClass(String name, List<_Field> fields) {
    buffer.writeln('class $name {');
    final prefix = immutable ? '  final ' : '  ';
    final qmark = nullable ? '?' : '';

    for (final f in fields) {
      buffer.writeln('$prefix${f.dartType}$qmark ${f.dartName};');
    }
    buffer.writeln();

    // Constructor.
    if (immutable) {
      buffer.writeln('  const $name({');
    } else {
      buffer.writeln('  $name({');
    }
    for (final f in fields) {
      buffer.writeln(
          '    ${nullable ? '' : 'required '}this.${f.dartName},');
    }
    buffer.writeln('  });');
    buffer.writeln();

    // fromJson.
    buffer.writeln('  factory $name.fromJson(Map<String, dynamic> json) {');
    buffer.writeln('    return $name(');
    for (final f in fields) {
      buffer.writeln('      ${f.dartName}: ${_fromJsonExpr(f)},');
    }
    buffer.writeln('    );');
    buffer.writeln('  }');
    buffer.writeln();

    // toJson.
    buffer.writeln('  Map<String, dynamic> toJson() {');
    buffer.writeln('    return {');
    for (final f in fields) {
      buffer.writeln("      '${f.jsonKey}': ${_toJsonExpr(f)},");
    }
    buffer.writeln('    };');
    buffer.writeln('  }');
    buffer.writeln('}');
    buffer.writeln();
  }

  String _fromJsonExpr(_Field f) {
    final access = "json['${f.jsonKey}']";
    return _readExpr(access, f.dartType, isTopLevel: true);
  }

  String _readExpr(String access, String type, {bool isTopLevel = false}) {
    if (type == 'dynamic') return access;
    if (type == 'String' || type == 'int' || type == 'double' || type == 'bool') {
      return nullable ? '$access as $type?' : '$access as $type';
    }
    if (type.startsWith('List<')) {
      final inner = type.substring(5, type.length - 1);
      final mapped = inner == 'dynamic'
          ? '(e) => e'
          : '(e) => ${_readExpr('e', inner)}';
      if (nullable) {
        return '($access as List?)?.map($mapped).toList()';
      }
      return '($access as List).map($mapped).toList()';
    }
    // Nested class.
    if (nullable) {
      return '$access == null ? null : $type.fromJson($access as Map<String, dynamic>)';
    }
    return '$type.fromJson($access as Map<String, dynamic>)';
  }

  String _toJsonExpr(_Field f) {
    final name = f.dartName;
    final type = f.dartType;
    if (type == 'dynamic' || type == 'String' || type == 'int' ||
        type == 'double' || type == 'bool') {
      return name;
    }
    if (type.startsWith('List<')) {
      final inner = type.substring(5, type.length - 1);
      if (inner == 'dynamic' || inner == 'String' || inner == 'int' ||
          inner == 'double' || inner == 'bool') {
        return name;
      }
      // List of nested classes.
      if (nullable) {
        return '$name?.map((e) => e.toJson()).toList()';
      }
      return '$name.map((e) => e.toJson()).toList()';
    }
    // Nested class.
    return nullable ? '$name?.toJson()' : '$name.toJson()';
  }

  String _uniqueClassName(String base) {
    var name = _pascalCase(base);
    if (name.isEmpty) name = 'Root';
    if (!_emitted.contains(name)) {
      _emitted.add(name);
      return name;
    }
    int n = 2;
    while (_emitted.contains('$name$n')) {
      n++;
    }
    final unique = '$name$n';
    _emitted.add(unique);
    return unique;
  }

  static String _camelCase(String key) {
    final words = _splitWords(key);
    if (words.isEmpty) return 'value';
    final head = _safeIdentifier(words.first.toLowerCase());
    return head + words.skip(1).map(_capitalize).join();
  }

  static String _pascalCase(String key) {
    final words = _splitWords(key);
    return words.map(_capitalize).join();
  }

  static List<String> _splitWords(String input) {
    if (input.isEmpty) return const [];
    final cleaned = input.replaceAll(RegExp(r'[_\-./\\\s]+'), ' ');
    final spaced = cleaned
        .replaceAllMapped(
            RegExp(r'([a-z0-9])([A-Z])'), (m) => '${m[1]} ${m[2]}');
    return spaced
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .toList(growable: false);
  }

  static String _capitalize(String w) =>
      w.isEmpty ? w : w[0].toUpperCase() + w.substring(1).toLowerCase();

  /// Dart reserved words and identifiers that would clash with built-ins.
  /// Prefixes with `$` to make them legal.
  static const _reserved = {
    'class', 'const', 'final', 'var', 'void', 'return', 'if', 'else',
    'for', 'while', 'switch', 'case', 'break', 'continue', 'new',
    'true', 'false', 'null', 'this', 'super', 'is', 'as', 'in', 'do',
    'try', 'catch', 'throw', 'finally', 'default', 'enum', 'extends',
    'implements', 'with', 'mixin', 'factory', 'static', 'abstract',
    'import', 'export', 'library', 'part',
  };

  static String _safeIdentifier(String name) {
    if (name.isEmpty) return 'value';
    if (RegExp(r'^[0-9]').hasMatch(name)) name = 'n$name';
    if (_reserved.contains(name)) name = '\$$name';
    return name;
  }
}

class _Field {
  _Field(
      {required this.jsonKey, required this.dartName, required this.dartType});
  final String jsonKey;
  final String dartName;
  final String dartType;
}
