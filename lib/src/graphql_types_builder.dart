import 'package:build/build.dart';

import 'services/graphql_parser_service.dart';

class GraphqlTypesBuilder implements Builder {
  @override
  Map<String, List<String>> get buildExtensions => {
    '.graphql': ['.graphql.dart'],
  };

  @override
  Future<void> build(BuildStep buildStep) async {
    // Retrive the current matched assets
    AssetId currentAssetId = buildStep.inputId;

    // Create a new target ID
    var copyAssetId = currentAssetId.changeExtension('.graphql.dart');
    var assetContent = await buildStep.readAsString(currentAssetId);

    // Generate the dart classes based on the graphql schema
    String newAssetContent = GraphqlParserService().parse(assetContent);

    // Write the new asset
    await buildStep.writeAsString(copyAssetId, newAssetContent);
  }
}
