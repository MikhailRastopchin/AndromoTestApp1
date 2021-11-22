import 'package:flutter/material.dart';

import '../scopes/images.dart';
import 'home/image_view.dart';


class HomePage extends StatefulWidget
{
  final ImageFeed imageFeed;

  HomePage({ final Key key, @required this.imageFeed })
  : assert(imageFeed != null)
  , super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}


class _HomePageState extends State<HomePage>
{
  @override
  void initState()
  {
    super.initState();
    widget.imageFeed.addListener(_onFeedChanged);
  }

  @override
  void dispose()
  {
    widget.imageFeed.removeListener(_onFeedChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Stack(
            children: [
              content,
              if (widget.imageFeed.isLoading) Opacity(
                opacity: 0.5,
                child: Container(color: Colors.white),
              ),
              if (widget.imageFeed.isLoading) Center(
                child: CircularProgressIndicator()
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget get content
  {
    final theme = Theme.of(context);
    return RefreshIndicator(
      onRefresh: () => widget.imageFeed.load(),
      child: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          if (scrollNotification is ScrollEndNotification) {
            final offset = scrollNotification.metrics.extentAfter;
            if (offset <= 0.0) {
              widget.imageFeed.loadNext();
              return true;
            }
          }
          return false;
        },
        child:CustomScrollView(
          slivers: [
            SliverGrid.count(
              crossAxisCount: 3,
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
              children: widget.imageFeed.items
                .map((image) =>  buildItem(image))
                .toList(),
            ),
            if (!widget.imageFeed.hasMore) SliverToBoxAdapter(
              child: SizedBox(
                height: 60.0,
                child: Center(
                  child: Text('End of story :(', style: theme.textTheme.headline5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildItem(final String image)
  {
    final imageIcon = Icon(Icons.image, size: 40, color: Colors.grey[800]);
    final imageView =  Image.network(image,
      key: ValueKey(image),
      fit: BoxFit.cover,
      loadingBuilder: (
        BuildContext context,
        Widget child,
        ImageChunkEvent loadingProgress
      ) {
        if (loadingProgress == null)
          return InkWell(
            child: child,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => ImageViewPage(image: image),
              ),
            ),
          );
        return Center(
          child: SizedBox(
            height: 20.0,
            width: 20.0,
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                : null,
            ),
          ),
        );
      },
      errorBuilder: (context, exception, stackTrace) => imageIcon,
    );
    return Material(
      color: Colors.grey,
      clipBehavior: Clip.antiAlias,
      child: imageView,
    );
  }

  void _onFeedChanged() => setState(() {});
}
