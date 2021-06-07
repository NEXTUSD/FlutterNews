import 'dart:convert';

import 'package:flutter_news/Model.dart/article_model.dart';
import 'package:http/http.dart' as http;

class News {
  List<Article> newsss = [];
  Future<void> getNewsByApi() async {
    final apiUrl = Uri.parse(
        "https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=e21a63c96ee04d1fa75ff49a4ae48c72");

    try {
      var response = await http.get(apiUrl);
      print("response =$response ");
      var data = jsonDecode(response.body);
      print("data = $data");
      if (data['status'] == "ok") {
        data["articles"].forEach((element) {
          if (element['urlToImage'] != null && element['description'] != null) {
            Article article = Article(
              title: element['title'],
              author: element['author'],
              description: element['description'],
              urlToImage: element['urlToImage'],
              publshedAt: DateTime.parse(element['publishedAt']),
              content: element["content"],
              articleUrl: element["url"],
            );
            newsss.add(article);
          }
        });
      }
    } catch (e) {}
  }
}
