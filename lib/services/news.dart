import 'dart:convert';
import 'package:news_app/models/article_model.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class News {
  List<ArticleModel> news = [];

  Future<void> getNews() async {
    DateTime nowDate = DateTime.now().subtract(const Duration(days: 30 ));
    String formattedDate = DateFormat("yyyy-MM-dd").format(nowDate);
    String url =
        "https://newsapi.org/v2/everything?q=tesla&from=$formattedDate&sortBy=publishedAt&apiKey=3a21d28d670f474db90b449c03bed0c4";
    var response = await http.get(Uri.parse(url));
    var jsonData = jsonDecode(response.body);

    if (jsonData['status'] == 'ok') {
      jsonData["articles"].forEach((element) {
        if (element["urlToImage"] != null && element['description'] != null) {
          ArticleModel articleModel = ArticleModel(
            title: element["title"],
            description: element["description"],
            url: element["url"],
            urlToImage: element["urlToImage"],
            content: element["content"],
          );
          news.add(articleModel);
        }
      });
    }
  }

  Future<void> getSearchResults(String query,
      {String sortBy = "publishedAt"}) async {
    String url =
        "https://newsapi.org/v2/everything?q=$query&sortBy=$sortBy&apiKey=3a21d28d670f474db90b449c03bed0c4";
    var response = await http.get(Uri.parse(url));
    var jsonData = jsonDecode(response.body);

    if (jsonData['status'] == "ok") {
      news.clear();
      jsonData["articles"].forEach(
        (element) {
          if (element["urlToImage"] != null && element["description"] != null) {
            ArticleModel articleModel = ArticleModel(
              title: element["title"],
              description: element["description"],
              url: element["url"],
              urlToImage: element["urlToImage"],
            );
            news.add(articleModel);
          }
        },
      );
    }
  }
}
