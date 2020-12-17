import 'package:Fluttegram/layout/feed/FeedList.dart';
import 'package:Fluttegram/model/StorySeenCountModel.dart';
import 'package:Fluttegram/theme/ThemeSettings.dart';
import 'package:Fluttegram/util/Utility.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'routing/AppRoutes.dart';
import 'routing/UndefinedView.dart';

void main() {
  runApp(InstagramApp());
}

class InstagramApp extends StatefulWidget {
  @override
  _InstagramAppState createState() => _InstagramAppState();
}

class _InstagramAppState extends State<InstagramApp> {
  int _currentIndex = 0;

  final _feedScreen = GlobalKey<NavigatorState>();
  final _diagramScreen = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => ThemeNotifier(),
          ),
          ChangeNotifierProvider<StorySeenModel>(
              create: (context) => StorySeenModel()),
        ],
        child: Consumer<ThemeNotifier>(
          builder: (context, ThemeNotifier notifier, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'instagram copy',
              theme: notifier.isDarkTheme ? dark : light,
              home: home(context),
            );
          },
        ));
  }

  Scaffold home(BuildContext context) {
    return Scaffold(
              body: IndexedStack(
                index: _currentIndex,
                children: <Widget>[
                  Navigator(
                    key: _feedScreen,
                    onGenerateRoute: (route) => MaterialPageRoute(
                      settings: route,
                      builder: (context) => FeedList(),
                    ),
                  ),
                  Navigator(
                    key: _diagramScreen,
                    initialRoute: '/',
                    onGenerateRoute: generateRouteForDiagramsScreen,
                    onUnknownRoute: (settings) => MaterialPageRoute(
                        builder: (context) => UndefinedView(
                          name: settings.name,
                        )),
                  ),
                ],
              ),
              bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: _currentIndex,
                onTap: (val) => _onTap(val, context),
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.library_books),
                    title: Text('Main'),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.list),
                    title: Text('Diagram'),
                  ),
                ],
              ),
            );
  }

  void _onTap(int val, BuildContext context) {
        setState(() {
          _currentIndex = val;
        });
  }
}
