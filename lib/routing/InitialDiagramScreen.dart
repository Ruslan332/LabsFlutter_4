import 'package:Fluttegram/dto/ScreenArguments.dart';
import 'package:flutter/material.dart';

class InitialDiagramScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget buttonSection = Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildButtonColumn(context, Icons.filter_1, '/first', PaintingStyle.fill),
          _buildButtonColumn(context, Icons.filter_2, '/second', PaintingStyle.stroke),
        ],
      ),
    );
    return buttonSection;
  }

  Column _buildButtonColumn(BuildContext context, IconData icon, String route,
      PaintingStyle paintingStyle) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {
            Navigator.pushNamed(
              context,
              route,
              arguments: ScreenArguments(
                  "[$route] diagram title.",
                  "You made choice [$route].",
                  paintingStyle),
            );
          },
          icon: Icon(icon),
        ),
        Container(
          margin: const EdgeInsets.only(top: 8),
          child: Text(
            route,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
