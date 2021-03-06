import 'package:collection/collection.dart';
import 'package:graphql_types_builder/src/services/graphql_class_generator.dart';

final RegExp _regex = RegExp(r'((\btype\b|\binput\b)\s)(\w*)(\s\{)(([\w\W](?!\}))*)');

class GraphqlParserService {
  String parse(String rawGraphqlSchema) {
    _graphQLTypes = _getRawTypes(rawGraphqlSchema);

    return _parseRawTypes();
  }

  List<String> _graphQLTypes = [];
  String _graphqlClasses = '';

  List<String> _getRawTypes(String rawGraphqlSchema) {
    List<RegExpMatch> matches = _regex.allMatches(rawGraphqlSchema).toList();

    return matches.map((match) => match.group(0)).whereNotNull().toList();
  }

  String _parseRawTypes() {
    final StringBuffer sb = StringBuffer();

    sb.writeln('// This file was generated by graphql_types_builder package.');
    sb.writeln('// Do not edit this file manually.');
    sb.writeln();

    for (var type in _graphQLTypes) {
      if (type.isNotEmpty) {
        final String classString = GraphQLClassGenerator(type).generate();
        if(!classString.contains('Mutation') && !classString.contains('Query')) { sb.writeln(classString); }
      }
    }

    return _graphqlClasses = sb.toString();
  }
}
