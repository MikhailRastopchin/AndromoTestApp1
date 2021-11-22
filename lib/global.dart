import 'services/feeds.dart';


abstract class Global
{
  static FeedService feeds;

  static void init()
  {
    feeds = FeedService();
  }
}
