import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:youtubeFavsBloc/src/models/video.dart';

const API_KEY = "AIzaSyCy5NG7mfx08iRVkKvxz1siXlRpugRjSn8";
//"https://www.googleapis.com/youtube/v3/search?part=snippet&q=$search&type=video&key=$API_KEY&maxResults=10"
//"https://www.googleapis.com/youtube/v3/search?part=snippet&q=$_search&type=video&key=$API_KEY&maxResults=10&pageToken=$_nextToken"
//"http://suggestqueries.google.com/complete/search?hl=en&ds=yt&client=youtube&hjson=t&cp=1&q=$search&format=5&alt=json"

class Api {
  search(String search) async {
    http.Response res = await http.get(
        "https://www.googleapis.com/youtube/v3/search?part=snippet&q=$search&type=video&key=$API_KEY&maxResults=10");

    decode(res);
  }

  List<Video> decode(http.Response response) {
    if (response.statusCode == 200) {
      var decoded = json.decode(response.body);

      List<Video> videos = decoded["items"].map<Video>((video) {
        return Video.fromJson(video);
      }).toList();
      return videos;
    } else {
      throw Exception("Failed to load videos");
    }
  }
}
