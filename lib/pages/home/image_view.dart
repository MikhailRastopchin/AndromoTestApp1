import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import '../../pages/common/page_title.dart';


class ImageViewPage extends StatefulWidget
{
  final String image;

  ImageViewPage({ final Key key, @required this.image })
  : assert(image != null)
  , super(key: key);

  @override
  _ImageViewPageState createState() => _ImageViewPageState();
}


class _ImageViewPageState extends State<ImageViewPage>
{
  @override
  Widget build(BuildContext context)
  {
    final theme =Theme.of(context);
    return Material(
      child: SafeArea(
      child: Stack(
          children: [
            Container(
              alignment: Alignment.center,
              child: PhotoView(
                backgroundDecoration: BoxDecoration(color: Colors.white),
                imageProvider: NetworkImage(widget.image),
                loadingBuilder: (
                  BuildContext context,
                  ImageChunkEvent loadingProgress
                ) {
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
              ),
            ),
            Material(
              type: MaterialType.transparency,
              child: SizedBox(
                height: kTextTabBarHeight,
                child: PageTitle(actions: [
                    IconButton(
                      icon: Icon(Icons.share, color: theme.iconTheme.color,),
                      onPressed: () {}
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
