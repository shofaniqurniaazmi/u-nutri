import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nutritrack/model/news.dart';

class NewsProvider with ChangeNotifier {
  News? _news;
  bool _isLoading = false;
  List<Results> _firstGroupNews = [];
  List<Results> _secondGroupNews = [];

  News? get news => _news;
  List<Results> get newsResults => _news?.results ?? [];
  bool get isLoading => _isLoading;
  List<Results> get firstGroupNews => _firstGroupNews;
  List<Results> get secondGroupNews => _secondGroupNews;

  final String _url =
      'https://newsdata.io/api/1/news?apikey=pub_512145b24e23ed26e817e4017220145129057&country=id&language=id&category=health';

  Future<void> fetchNews() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse(_url));
      print('response status code ${response.statusCode}');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('print response langsung $data');
        _news = News.fromJson(data);

        // Membagi berita menjadi dua kelompok
        _divideNews();
      } else {
        throw Exception('Failed to load news');
      }
    } catch (error) {
      print('Error fetching news: $error');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _divideNews() {
    if (_news?.results != null) {
      List<Results> allNews = _news!.results!;

      // Memastikan kita memiliki setidaknya 40 berita
      if (allNews.length >= 40) {
        _firstGroupNews = allNews.sublist(0, 20);
        _secondGroupNews = allNews.sublist(20, 40);
      } else {
        // Jika kurang dari 40, bagi sebisa mungkin
        int midPoint = allNews.length ~/ 2;
        _firstGroupNews = allNews.sublist(0, midPoint);
        _secondGroupNews = allNews.sublist(midPoint);
      }
    }
  }
}
