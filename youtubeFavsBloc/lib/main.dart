import 'package:flutter/material.dart';
import 'package:youtubeFavsBloc/src/api.dart';
import 'package:youtubeFavsBloc/src/app.dart';

void main() {
  Api api = Api();
  api.search("Flutter");
  runApp(MyApp());
}
