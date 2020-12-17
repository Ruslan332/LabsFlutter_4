import 'package:Fluttegram/model/StorySeenCountModel.dart';
import 'package:Fluttegram/theme/ThemeSettings.dart';
import 'package:Fluttegram/util/Utility.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ReactionsScreen.dart';

class HeroPhotoStory extends StatelessWidget {
  final String username;
  final String tag;
  final Image image;

  HeroPhotoStory(this.username, this.tag, this.image);

  @override
  Widget build(BuildContext context) {
    var isDarkThemeActive =
        context.select<ThemeNotifier, bool>((th) => th.isDarkTheme);
    return Scaffold(
      backgroundColor: Utility.defineColorDependingOnTheme(isDarkThemeActive),
      appBar: AppBar(
        title: Text('$username'),
      ),
      body: Column(children: <Widget>[
        Container(
          child: Hero(
            tag: '$tag',
            child: this.image,
          ),
        ),
        Text(
          "Переглядів: " + _populateViewsCount(context, tag),
          overflow: TextOverflow.ellipsis,
          // style: TextStyle(color: Utility.defineColorDependingOnTheme(!isDarkThemeActive)),
        )
      ]),
      floatingActionButton: _markStorySeenBtn(context, tag),
    );
  }

  FloatingActionButton _markStorySeenBtn(BuildContext context, String tag) {
    var isAlreadySeen = context.select<StorySeenModel, bool>(
      (storyModel) => storyModel.storiesPartitionMap[StoryActuality.SEEN]
          .map((story) => story.tag)
          .contains(tag),
    );

    return FloatingActionButton(
      onPressed: () {
        final model = Provider.of<StorySeenModel>(context, listen: false);
        model.seeTheStoryByTag(tag);
      },
      tooltip: 'Відмітити як переглянуту',
      child: Icon(Icons.remove_red_eye,
          color: isAlreadySeen ? Colors.red : Colors.green),
    );
  }

  String _populateViewsCount(context, String storyTag) {
    final model = Provider.of<StorySeenModel>(context);
    return model.getViewsCountByStoryTag(storyTag).toString();
  }
}
