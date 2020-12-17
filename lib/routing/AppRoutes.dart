import 'package:Fluttegram/dto/ScreenArguments.dart';
import 'package:flutter/material.dart';

import 'InitialDiagramScreen.dart';
import 'DiagramScreen.dart';
import 'UndefinedView.dart';

Route<dynamic> generateRouteForDiagramsScreen(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(builder: (context) => InitialDiagramScreen());
    case '/first':
    case '/second':
      final ScreenArguments args = settings.arguments;
      return MaterialPageRoute(
        builder: (context) {
          return DiagramScreen(
            title: args.title,
            message: args.message,
            paintingStyle: args.paintingStyle,
          );
        },
      );
    default:
      return MaterialPageRoute(
          builder: (context) => UndefinedView(
                name: settings.name,
              ));
  }
}
