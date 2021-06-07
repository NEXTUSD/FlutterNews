import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news/Model.dart/article_model.dart';
import 'package:flutter_news/helper/news.dart';
import 'package:flutter_news/screens/articleView.dart';
import 'package:flutter_news/screens/categoryScreens.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:flutter_news/Model.dart/model.dart';
import 'package:flutter_news/helper/data.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<CategoryModel> categories;
  late List<Article> articleList;

  bool _loading = true;

  Future getNews() async {
    News news = News();
    await news.getNewsByApi();
    articleList = news.newsss;
    print("this is list");
    print(articleList);
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
    getNews();
  }

  Future<void> _getData() async {
    setState(() {
      getNews();
    });
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
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _getData,
        child: _loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Container(
                    child: Column(
                  children: [
                    //! Categories
                    Container(
                      height: 70,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: categories.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          return CategoryTile(
                            name: categories[index].categoryName,
                            imageUrl: categories[index].imageUrl,
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    //! Blogs

                    Container(
                      // height: MediaQuery.of(context).size.height,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemCount: articleList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return BlogTile(
                            imageUrl: articleList[index].urlToImage,
                            title: articleList[index].title,
                            desc: articleList[index].description,
                            url: articleList[index].articleUrl,
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
      ),
    );
  }
}

class CategoryTile extends StatelessWidget {
  final String imageUrl;
  final String name;

  const CategoryTile({
    Key? key,
    required this.imageUrl,
    required this.name,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, CupertinoPageRoute(builder: (context) => CategoryPage(category: name)));
      },
      child: Container(
        //   margin: EdgeInsets.only(right: 15),
        child: Stack(children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              height: 60,
              width: 120,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Colors.black38,
            ),
            height: 60,
            width: 120,
            child: Text(name).text.semiBold.white.make(),
          )
        ]),
      ).p4(),
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
