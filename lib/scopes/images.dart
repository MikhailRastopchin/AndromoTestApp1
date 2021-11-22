import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';


class ImageFeed extends ChangeNotifier
{
  bool get isLoading => _isLoading;

  List<String> get items => _items;

  bool get hasMore => _hasMore;

  Future<void> load() async
  {
    if (_loading != null) return _loading;
    final completer = Completer();
    _loading = completer.future;
    _isLoading = true;
    notifyListeners();
    final items = await _loadFirstPage();
    _items.clear();
    _hasMore = true;
    _items.addAll(items);
    _isLoading = false;
    notifyListeners();
    _loading = null;
    completer.complete();
  }

  Future<void> loadNext() async
  {
    if (_isLoading || !_hasMore) return;
    final completer = Completer();
    _loading = completer.future;
    _isLoading = true;
    notifyListeners();
    final items = await _loadNextPage();
    if (items.isNotEmpty) _items.addAll(items);
    else _hasMore = false;
    _isLoading = false;
    notifyListeners();
    _loading = null;
    completer.complete();
  }

  Future<List<String>> _loadFirstPage() async
  {
    final imageIndexes = List.generate(10, (index) => _random.nextInt(14));
    final paths = imageIndexes.map((index) => _paths[index]).toList();
    await Future.delayed(const Duration(seconds: 1), () {});
    return paths;
  }

  Future<List<String>> _loadNextPage() async
  {
    if (items.length >= 100) return [];
    else {
      final imageIndexes = List.generate(10, (index) => _random.nextInt(14));
      final paths = imageIndexes.map((index) => _paths[index]).toList();
      await Future.delayed(const Duration(seconds: 2), () {});
      return paths;
    }
  }

  final _random = Random();

  final _paths = [
    'https://www.newsler.ru/data/content/2020/88589/e9d43fd0dd67c38b90a4cb72aeffb1aa.jpg',
    'http://uraloved.ru/images/mesta/sv-obl/ayat/kirman-7.jpg',
    'https://img-fotki.yandex.ru/get/6306/64843573.f1/0_85d0d_fb4f8844_orig.jpg',
    'https://lifeglobe.net/x/entry/0/different1-164.jpg',
    'https://img-fotki.yandex.ru/get/6307/64843573.f1/0_85d1b_2b97bd1f_orig.jpg',
    'https://upload.wikimedia.org/wikipedia/commons/7/75/%D0%A1%D0%BA%D0%B0%D0%BB%D1%8B_%D0%93%D1%80%D1%8E%D0%BD%D0%B2%D0%B0%D0%BB%D1%8C%D0%B4%D1%82%D0%B0.jpg',
    'https://www.idemvpohod.com/images/stories/mesta/skaly/ak-kaya.jpg',
    'https://alpagama.org/wp-content/uploads/2020/01/verblyud-gora-sorev-26.jpg',
    'https://cdnn21.img.ria.ru/images/150206/98/1502069800_0:0:3052:1730_600x0_80_0_0_e6831f0423ea62bb086bb6ec78260853.jpg',
    'https://praga-praha.ru/wp-content/uploads/2015/07/%D0%9F%D1%80%D0%B0%D1%85%D0%BE%D0%B2%D1%81%D0%BA%D0%B8%D0%B5-%D1%81%D0%BA%D0%B0%D0%BB%D1%8B-1.jpg',
    'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/%D0%A8%D0%B0%D0%BC%D0%B0%D0%BD-%D1%81%D0%BA%D0%B0%D0%BB%D0%B0.JPG/1200px-%D0%A8%D0%B0%D0%BC%D0%B0%D0%BD-%D1%81%D0%BA%D0%B0%D0%BB%D0%B0.JPG',
    'https://upload.wikimedia.org/wikipedia/commons/d/d8/%D0%9F%D1%91%D1%81%D1%82%D1%80%D1%8B%D0%B5_%D1%81%D0%BA%D0%B0%D0%BB%D1%8B.jpg',
    'https://uatraveller.com/wp-content/uploads/2018/10/belyie-skalyi-duvra-v-anglii-1-1140x641.jpg',
    'https://gorod-na-vagrane.ru/wp-content/uploads/2020/04/grunvaldt.jpg',
    'http://s016.radikal.ru/i334/1710/46/2c6ceb00d4c9.jpg',
  ];

  List<String> _items = [];
  bool _hasMore = true;
  bool _isLoading = false;
  Future _loading;
}

