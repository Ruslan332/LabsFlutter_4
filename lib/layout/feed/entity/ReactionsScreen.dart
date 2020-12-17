import 'package:flutter/material.dart';

class ReactionScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pick an option'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildIconReaction(context, Icon(Icons.mood), "SMILE"),
            _buildIconReaction(context, Icon(Icons.thumb_up), 'THUMB UP'),
            _buildIconReaction(context, Icon(Icons.thumb_down), "THUMB DOWN"),
            _buildIconReaction(context, Icon(Icons.favorite), "HEART"),
          ],
        ),
      ),
    );
  }

  Padding _buildIconReaction(BuildContext context, Icon icon , String label) {
    return Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () {
                Navigator.pop(context, label);
              },
              icon: icon,
            ),
          );
  }
}
