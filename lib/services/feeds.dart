import '../scopes/images.dart';


class FeedService
{
  final ImageFeed images;

  FeedService() : images = ImageFeed();

  Future<void> init() => Future.wait([ images.load() ]);
}