import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:flutter_news/Model.dart/article_model.dart';
import 'package:flutter_news/Model.dart/model.dart';
import 'package:flutter_news/helper/categoryNews.dart';
import 'package:flutter_news/helper/data.dart';
import 'package:flutter_news/helper/news.dart';
import 'package:flutter_news/screens/articleView.dart';

class CategoryPage extends StatefulWidget {
  final String category;
  const CategoryPage({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<CategoryPage> {
  late List<CategoryModel> categories;
  late List<Article> categoryArticleList;

  bool _loading = true;

  void getCategoryNews() async {
    CategoryNews categorynews = CategoryNews();
    await categorynews.getCategoryNewsByApi(widget.category);
    categoryArticleList = categorynews.newsss;
    print("this is list");
    print(categoryArticleList);
    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // = _newsModel;
    categories = getCategoty();
    getCategoryNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CupertinoNavigationBar(
        backgroundColor: Colors.white,
        middle: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Flutter").text.black.make(),
            Text(
              "News",
              style: TextStyle(color: Colors.blue),
            ).text.make(),
          ],
        ).pOnly(right: 45),
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Visibility(
                      visible: categoryArticleList.isEmpty,
                      child: Center(
                        child: Text("NO data to display"),
                      )),
                  Visibility(
                    visible: categoryArticleList.isNotEmpty,
                    child: Container(
                        child: Column(
                      children: [
                        //! Categories

                        SizedBox(
                          height: 10,
                        ),
                        //! Blogs

                        Container(
                          height: MediaQuery.of(context).size.height,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: categoryArticleList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return BlogTile(
                                imageUrl: categoryArticleList[index].urlToImage,
                                title: categoryArticleList[index].title,
                                desc: categoryArticleList[index].description,
                                url: categoryArticleList[index].articleUrl,
                              );
                            },
                          ),
                        )
                      ],
                    )).pOnly(
                      left: 5,
                      top: 10,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class BlogTile extends StatelessWidget {
  final String imageUrl, title, desc, url;

  const BlogTile(
      {Key? key,
      required this.imageUrl,
      required this.title,
      required this.desc,
      required this.url})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, CupertinoPageRoute(builder: (context) => ArticleView(webViewUrl: url)));
      },
      child: Container(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(borderRadius: BorderRadius.circular(6), child: Image.network(imageUrl)),
          10.heightBox,
          Text(title).text.xl.bold.black.make(),
          10.heightBox,
          Text(desc).text.gray600.make(),
          Divider()
        ],
      ).pOnly(left: 10, top: 10, right: 10)),
    );
  }
}
