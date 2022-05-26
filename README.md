<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

# Graphql Types Builder
<p align="center">
  <a href="https://github.com/freewaymx/graphql_types_builder/releases" alt="Lastest release">
    <img src="https://img.shields.io/github/v/tag/freewaymx/graphql_types_builder" /></a>
</p>

A small package that use the power of build_runner package to create simply dart classes from a GraphQL schema file.

> This package is in beta. Use it with caution and [file any potential issues you see](https://github.com/freewaymx/graphql_types_builder/issues/new)
## Features
- [x] Generate Dart Class from GraphQL Schema
- [x] Generate constructor fromMap for each generated dart class
- [x] Support custom data types (Non Graphql Native types)


## Upcoming Features
- [ ] Add support for GraphQL Queries
- [ ] Add support for GraphQL Mutations
- [ ] Add support for GraphQL Subscriptions
- [ ] Generate `toMap` instance method
- [ ] Improve readme file


## Getting started
First you need to add the following dev_dependencies to your pubspec.yaml file.
```yaml
dev_dependencies:
  build_runner:
  graphql_types_builder: ^0.1.0
  ...
```

Then create a `build.yaml` with the following content in your project's root path.
```yaml
targets:
  your_project_name:your_project_name:
    builders:
      graphql_types_builder|graphqlTypesBuilder:
        enabled: True
        generate_for:
          - lib/src/**/*schema.graphql
```
> Note you have to change **your_project_name** with your project's name, you can find it in the top section of your pubspec.yaml file.

And finally just be sure that you have a `schema.graphql` file inside of your `lib/src` folder

## Usage
```bash
flutter packages pub run build_runner build
```

## Contributing
> This package is in beta. If you want to contribute ask to the package owners by sending an email or creating a Github discussion

## Additional information

This is a package created and maintained by the FreeWay Mx team. If you have a suggestion or found an issue, don't hesitate in creating a new Github issue 😁
