final _graphqlDefaultScalarTypes = ["ID", "String", "Boolean", "Int", "Float"];

final _isListRegex = RegExp(r'\[(\w*|\w*!)\]');

String _buildDartType(attributeType) {
  bool isList = _isListRegex.hasMatch(attributeType);
  if (isList) {
    attributeType = attributeType.replaceAll(r'\W', '');
    return 'List<${_parseScalarType(attributeType)}>';
  }

  return _parseScalarType(attributeType);
}

String _parseScalarType(attributeType) {
  switch (attributeType) {
    case 'ID':
      return 'String';
    case 'Boolean':
      return 'bool';
    case 'Int':
      return 'int';
    case 'Float':
      return 'double';
    default:
      return attributeType;
  }
}

class GraphqlAttribute {
  String name;
  bool isRequired;
  String type;
  String dartType;

  GraphqlAttribute({required this.name, required this.isRequired, required this.type, required this.dartType});


  factory GraphqlAttribute.fromJson(Map<String, dynamic> json) => GraphqlAttribute(
    name: json['name'],
    isRequired: json['isRequired'],
    type: json['type'],
    dartType: _buildDartType(json['type'])
  );

  // ? String should be like:
  // attributeName: type!
  // attributeName: type
  factory GraphqlAttribute.fromString(String rawAttribute){
    final List<String> attributeParts = rawAttribute.split(':');

    final String attributeName = attributeParts.first.trim();
    final bool attributeRquired = attributeParts.last.trim().endsWith('!');
    final String attributeType = attributeParts.last.trim().replaceFirst('!', '');

    return GraphqlAttribute(
      name: attributeName,
      isRequired: attributeRquired,
      type: attributeType,
      dartType: _buildDartType(attributeType),
    );
  }

  get attributeSymbol => isRequired ? '' : '?';

  String get attributeDartType => isRequired ? '' : '?';

  bool get isScalar => _graphqlDefaultScalarTypes.contains(type);

  bool get isList => dartType.startsWith('List<');

  String get prettyType => _parseScalarType(type);

  // ignore: unnecessary_string_interpolations
  String get dartTypeWithoutList => '$dartType'.replaceAll('List<', '').replaceAll('>', '');
}
