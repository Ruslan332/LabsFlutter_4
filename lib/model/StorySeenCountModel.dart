import 'package:Fluttegram/layout/feed/entity/Story.dart';
import 'package:flutter/foundation.dart';

class StorySeenModel extends ChangeNotifier {
  static var fakeDbStories = _initStories(); // todo we should take it from db

  Map<StoryActuality, List<Story>> _storiesPartitionMap = {
    StoryActuality.SEEN: [],
    StoryActuality.NOT_SEEN: fakeDbStories
  };

  Map<Story, int> _storyViewsCountMap = Map.fromIterable(fakeDbStories,
      key: (story) => story, value: (story) => 0);

  ///update
  void seeTheStory(Story story) {
    if (!_storiesPartitionMap[StoryActuality.SEEN].contains(story)) {
      _storiesPartitionMap[StoryActuality.SEEN].add(story);
      _storiesPartitionMap[StoryActuality.NOT_SEEN].remove(story);
    }
    notifyListeners();
  }

  void incrementViewCount(String storyTag) {
    Story key = _populateStoryByTag(storyTag);
    storyViewsCountMap[key]++;
  }

  void seeTheStoryByTag(String storyTag) {
    Story key = _populateStoryByTag(storyTag);
    seeTheStory(key);
  }

  ///fail safe
  int getViewsCountByStoryTag(String storyTag) {
    try {
      Story key = _populateStoryByTag(storyTag);
      return storyViewsCountMap[key];
    } catch (e) {
      return 0;
    }
  }

  ///get set
  Map<Story, int> get storyViewsCountMap => _storyViewsCountMap;

  set storyViewsCountMap(Map<Story, int> value) {
    _storyViewsCountMap = value;
    notifyListeners();
  }

  Map<StoryActuality, List<Story>> get storiesPartitionMap =>
      _storiesPartitionMap;

  set storiesPartitionMap(Map<StoryActuality, List<Story>> value) {
    _storiesPartitionMap = value;
    notifyListeners();
  }

  ///helper
  Story _populateStoryByTag(String storyTag) {
    Story key =
        _storyViewsCountMap.keys.firstWhere((story) => story.tag == storyTag);
    return key;
  }

  /// init stub
  static List<Story> _initStories() {
    List<Story> stories = [];
    for (int i = 0; i < 9; i++) {
      stories.add(Story());
    }
    return stories;
  }
}

///can be replaced by bool for better performance
enum StoryActuality { SEEN, NOT_SEEN }
