import 'package:collection/collection.dart';
import 'package:graphql_types_builder/src/models/graphql_attribute.dart';

// ? Get type input | type
final typeInputRegex = RegExp(r'input [A-Z]');
final typeTypeRegex = RegExp(r'type [A-Z]');

// ? Get attributes
final attributesRegex = RegExp(r'\w{2,}?: [A-Z]\w*(!(?!.)|)');

// ? Get Name
final nameRegex = RegExp(r'(?<=(input|type) )(.*?)(?= \{)');

const String tab1 = '\t';
const String tab2 = '\t\t';
const String tab3 = '\t\t\t';


class GraphQLClassGenerator {
  String rawGraphQLType = '';
  bool identifyRequiredAttributes;

  String? _name = '';
  // ignore: unused_field
  String? _type = '';
  List<GraphqlAttribute> _attributes = [];


  GraphQLClassGenerator(this.rawGraphQLType, {this.identifyRequiredAttributes = false});

  String generate() {
    _setUpClass();

    return _writeClass();
  }

  void _setUpClass() {
    _initializeType();
    _initializeAttributes();
    _initializeName();
  }

  void _initializeType() {
    if(typeInputRegex.hasMatch(rawGraphQLType)) {
      _type = 'input';
      return;
    } else if(typeTypeRegex.hasMatch(rawGraphQLType)) {
      _type = 'type';
      return;
    }

    throw Exception('Unknown type for: $rawGraphQLType');
  }

  void _initializeAttributes() {
    List<RegExpMatch> matches = attributesRegex.allMatches(rawGraphQLType).toList();

    List<String> rawAttributes = matches.map((match) => match.group(0)).whereNotNull().toList();

    _attributes = rawAttributes.map((rawAttribute) => GraphqlAttribute.fromString(rawAttribute)).toList();
  }

  void _initializeName() {
    _name = nameRegex.stringMatch(rawGraphQLType);
  }

  String _writeClass() {
    final StringBuffer sb = StringBuffer();

    sb.writeln('class $_name {');
    sb.writeln(_writeAttributesAndConstructor());
    sb.writeln('}');

    return sb.toString();
  }

  String _writeAttributesAndConstructor() {
    final String attributesString = _writeAttributes();
    final String constructorString = _writeConstructor();
    final String namedConstructorString = _writeNamedConstructor();

    // TODO: Write `fromMap` contructor in another method and also write `toMap` method in another method and define the class contrsuctor.
    final StringBuffer sb = StringBuffer();

    sb.writeln(attributesString);
    sb.writeln(constructorString);
    sb.writeln(namedConstructorString);

    return sb.toString();
  }

  String _writeAttributes() {
    final StringBuffer sb = StringBuffer();

    for (GraphqlAttribute attribute in _attributes) {
      String attributeSymbol = identifyRequiredAttributes ? attribute.attributeSymbol : '?';

      sb.writeln('$tab1 final ${attribute.prettyType}$attributeSymbol ${attribute.name};');
    }

    return sb.toString();
  }

  String _writeConstructor() {
    final StringBuffer sb = StringBuffer();
    sb.writeln('$tab1$_name({');

    for (GraphqlAttribute attribute in _attributes) {
      sb.writeln('$tab2 this.${attribute.name},');
    }

    sb.writeln('$tab1});');

    return sb.toString();
  }

  // ? .fromMap constructor
  String _writeNamedConstructor() {
    final StringBuffer sb = StringBuffer();
    sb.writeln('$tab1 factory $_name.fromMap(Map<String, dynamic> map) {');
    sb.writeln('$tab2 return $_name(');

    for (GraphqlAttribute attribute in _attributes) {
      _writeAttributeInitilization(sb, attribute);
    }

    sb.writeln('$tab2);');
    sb.writeln('$tab1}');

    return sb.toString();
  }

  void _writeAttributeInitilization(StringBuffer sb, GraphqlAttribute attribute) {
    if (attribute.isScalar) {
      return sb.writeln('$tab3${attribute.name}: map["${attribute.name}"],');
    }

    if (attribute.isList) {
      return sb.writeln('$tab3${attribute.name}: ${attribute.dartType}.from(map["${attribute.name}"]?.map((x) => ${attribute.dartTypeWithoutList}.fromMap(x))),');
    }

    sb.writeln('$tab3${attribute.name}: ${attribute.dartType}.fromMap(map["${attribute.name}"]),');
  }
}
