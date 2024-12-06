import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:news_app/models/show_category.dart';


class ShowCategoryNews{
  List<ShowCategoryModel> categories=[];

  Future<void> getCategoriesNews(String category)async{
    String url="https://newsapi.org/v2/top-headlines?country=us&category=$category&apiKey=3a21d28d670f474db90b449c03bed0c4";
    var response=await http.get(Uri.parse(url));

    var jsonData= jsonDecode(response.body);

    if(jsonData['status']=='ok'){
      jsonData["articles"].forEach((element){
        if(element["urlToImage"]!=null && element['description']!=null){
          ShowCategoryModel categoryModel= ShowCategoryModel(
            title: element["title"],
            description: element["description"],
            url: element["url"],
            urlToImage: element["urlToImage"],
            content: element["content"],
          );
          categories.add(categoryModel);
        }
      });
    }
  }
}