import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:youtubeFavsBloc/src/api.dart';
import 'package:youtubeFavsBloc/src/models/video.dart';

class VideosBloc implements BlocBase {
  Api api;

  List<Video> videos;

  VideosBloc() {
    api = Api();
    _searchController.stream.listen(_search);
  }

  final StreamController<List<Video>> _videoStreamController =
      StreamController<List<Video>>();
  Stream get outVideos => _videoStreamController.stream;

  final StreamController<String> _searchController = StreamController<String>();
  Sink get inSearch => _searchController.sink;

  void _search(String search) async {
    videos = await api.search(search);
    print(videos);
  }

  @override
  void addListener(void Function() listener) {
    // TODO: implement addListener
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _videoStreamController.close();
    _searchController.close();
  }

  @override
  // TODO: implement hasListeners
  bool get hasListeners => throw UnimplementedError();

  @override
  void notifyListeners() {
    // TODO: implement notifyListeners
  }

  @override
  void removeListener(void Function() listener) {
    // TODO: implement removeListener
  }
}
