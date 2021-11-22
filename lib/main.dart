import 'package:flutter/material.dart';
import 'package:test_app/pages/home.dart';

import 'Global.dart';


Future<void> main() async
{
  Global.init();
  await run();
}


Future<void> run() async
{
  await Global.feeds.init();
  runApp(MyApp());
}


class MyApp extends StatelessWidget
{
  const MyApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TestApp',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(imageFeed: Global.feeds.images),
    );
  }
}
