import 'package:Fluttegram/layout/feed/entity/DiscoverWorldPostsPage.dart';
import 'package:Fluttegram/layout/feed/entity/Post.dart';
import 'package:Fluttegram/layout/feed/entity/Story.dart';
import 'package:Fluttegram/model/StorySeenCountModel.dart';
import 'package:Fluttegram/theme/ThemeSettings.dart';
import 'package:Fluttegram/util/Utility.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'entity/photo_story.dart';

class FeedList extends StatefulWidget {
  @override
  _FeedListState createState() => _FeedListState();
}

class _FeedListState extends State<FeedList> {
  final _postList = <Post>[
    Post(),
    Post(),
    Post(),
    Post(),
    Post(),
  ];

  @override
  Widget build(BuildContext context) {
    var isDarkThemeActive =
        context.select<ThemeNotifier, bool>((th) => th.isDarkTheme);
    return MaterialApp(
      theme: isDarkThemeActive ? dark : light,
      // theme: ThemeData(
      //   primarySwatch: BlackPrimary.primaryBlack,
      // ),
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor:
              Utility.defineColorDependingOnTheme(isDarkThemeActive),
          appBar: AppBar(
            title: _buildTabBar(),
          ),
          body: _buildTabBarView(),
        ),
      ),
    );
  }

  TabBar _buildTabBar() {
    var isDarkThemeActive =
        context.select<ThemeNotifier, bool>((th) => th.isDarkTheme);
    return TabBar(
      indicatorColor: Colors.transparent,
      labelPadding: EdgeInsets.symmetric(horizontal: 0),
      tabs: [
        Align(
            alignment: Alignment.centerLeft,
            child: Tab(
                icon: Icon(
              Icons.camera_alt,
            ))),
        Align(
            alignment: Alignment.center,
            child: Tab(
                icon: Text(
              'Instagram',
              style: TextStyle(
                  fontFamily: 'Billabong',
                  fontSize: 27,
                  color:
                      Utility.defineColorDependingOnTheme(!isDarkThemeActive)),
            ))),
        Align(
            alignment: Alignment.centerRight,
            child: Tab(
                icon: Icon(
              Icons.send,
            ))),
      ],
    );
  }

  TabBarView _buildTabBarView() {
    return TabBarView(
      children: [
        //left
        dummyTestExpandedClass(),

        //main
        CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
                child: Consumer<ThemeNotifier>(
                    builder: (context, notifier, child) => SwitchListTile(
                          inactiveTrackColor: BlackPrimary.primaryBlack,
                          activeTrackColor: Colors.white,
                          inactiveThumbColor: Colors.grey,
                          activeColor: Colors.red,
                          title: Text("Dark Mode"),
                          onChanged: (value) {
                            notifier.toggleTheme();
                          },
                          value: notifier.isDarkTheme,
                        ))),
            //buildSliverAppBar(),
            buildStories(),
            buildPosts(),
          ],
        ),

        //right
        PostsPage()
      ],
    );
  }

  Center dummyTestExpandedClass() {
    return Center(
      child: Column(
        children: <Widget>[
          Container(
            color: Colors.green,
            height: 100,
            width: 100,
          ),
          Expanded(
            child: Icon(
              Icons.camera,
              color: Colors.white,
              size: 250,
            ),
          ),
          Container(
            color: Colors.yellow,
            height: 100,
            width: 100,
          ),
        ],
      ),
    );
  }


  Widget buildStories() {
    return SliverToBoxAdapter(
      child: Container(
        height: 65,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: _populateStoryList(),
        ),
      ),
    );
  }

  List<_ClickableStory> _populateStoryList() {
    List<Story> stories = context.select<StorySeenModel, List<Story>>(
      (storyModel) => storyModel.storyViewsCountMap.keys.toList(),
    );
    return stories.map((story) => _ClickableStory(story: story)).toList();
  }

  Widget buildPosts() {
    return SliverList(
      delegate: SliverChildListDelegate([..._postList]),
    );
  }
}

class _ClickableStory extends StatelessWidget {
  final Story story;

  const _ClickableStory({Key key, @required this.story}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // var isAlreadySeen = context.select<StorySeenModel, bool>(
    //   (storyModel) =>
    //       storyModel.storiesPartitionMap[StoryActuality.SEEN].contains(story),
    // );

    return Container(
      child: Hero(
          tag: story.tag,
          child: GestureDetector(
              onTap: () {
                final model =
                    Provider.of<StorySeenModel>(context, listen: false);
                model.incrementViewCount(story.tag);

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HeroPhotoStory(story.username,
                            story.tag, Image.asset(story.contentImagePath))));
              },
              child: story)),
    );
  }
}
