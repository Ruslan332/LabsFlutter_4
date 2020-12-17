import 'package:Fluttegram/model/StorySeenCountModel.dart';
import 'package:Fluttegram/theme/ThemeSettings.dart';
import 'package:Fluttegram/util/Utility.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dashed_circle/dashed_circle.dart';

class Story extends StatefulWidget {
  final String tag;
  final String username;
  final String contentImagePath;

  Story(
      [this.username = 'story_name',
      this.contentImagePath = 'assets/images/avatar.jpg'])
      : this.tag = Utility.getRandomTag(9);

  @override
  _StoryState createState() => _StoryState();
}

class _StoryState extends State<Story> with SingleTickerProviderStateMixin {
  /// Variables
  Animation gap;
  Animation base;
  Animation reverse;
  AnimationController controller;

  /// Init
  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 5));
    base = CurvedAnimation(parent: controller, curve: Curves.easeOut);
    reverse = Tween<double>(begin: 0.0, end: -1.0).animate(base);
    gap = Tween<double>(begin: 3.0, end: 0.0).animate(base)
      ..addListener(() {
        setState(() {});
      });
    controller.forward();
  }

  /// Dispose
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  /// Widget
  @override
  Widget build(BuildContext context) {
    return Consumer<StorySeenModel>(builder: (context, model, child) {
      return Container(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          child: Column(
            children: <Widget>[
              _buildStoryAccordingToSeenModel(widget.contentImagePath, model),
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 0, vertical: 3),
                  child: Text(
                    'name',
                    style: TextStyle(fontSize: 10),
                  ))
            ],
          ));
    });
  }

  Widget _buildStoryAccordingToSeenModel(imgPath, StorySeenModel model) {
    bool storyAlreadySeen =
        model.storiesPartitionMap[StoryActuality.SEEN].contains(widget);

    var color = storyAlreadySeen ? Colors.grey : Color(0XFFED4634);

    if (storyAlreadySeen) {
      return CircleAvatar(backgroundImage: AssetImage(imgPath));
    } else {
      return RotationTransition(
          turns: base,
          child: DashedCircle(
              gapSize: gap.value,
              dashes: 30,
              color: color,
              child: RotationTransition(
                  turns: reverse,
                  child: CircleAvatar(backgroundImage: AssetImage(imgPath)))));
    }
  }
}
