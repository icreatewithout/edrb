import 'package:edrb/pages/about_us.dart';
import 'package:edrb/pages/author_book_page.dart';
import 'package:edrb/pages/book_detail_page.dart';
import 'package:edrb/pages/book_list_detail_page.dart';
import 'package:edrb/pages/book_list_page.dart';
import 'package:edrb/pages/category_page.dart';
import 'package:edrb/pages/circle_detail_page.dart';
import 'package:edrb/pages/content_page.dart';
import 'package:edrb/pages/login_page.dart';
import 'package:edrb/pages/my_comment_list.dart';
import 'package:edrb/pages/my_forum_list.dart';
import 'package:edrb/pages/my_rate_list.dart';
import 'package:edrb/pages/ranking_list_page.dart';
import 'package:edrb/pages/scanner_page.dart';
import 'package:edrb/pages/search_page.dart';
import 'package:edrb/pages/user_info.dart';
import 'package:flutter/material.dart';
import '../pages/home_page.dart';

final routes = <String, WidgetBuilder>{
  MyHomePage.path: (BuildContext context, {arguments}) =>
      MyHomePage(arguments: arguments),
  CategoryPage.path: (BuildContext context, {arguments}) =>
      CategoryPage(arguments: arguments),
  BookDetailPage.path: (BuildContext context, {arguments}) =>
      BookDetailPage(arguments: arguments),
  RankingListPage.path: (BuildContext context, {arguments}) =>
      RankingListPage(arguments: arguments),
  LoginPage.path: (BuildContext context, {arguments}) =>
      LoginPage(arguments: arguments),
  ContentPage.path: (BuildContext context, {arguments}) =>
      ContentPage(arguments: arguments),
  SearchPage.path: (BuildContext context, {arguments}) =>
      SearchPage(arguments: arguments),
  AuthorBookPage.path: (BuildContext context, {arguments}) =>
      AuthorBookPage(arguments: arguments),
  BookListDetailPage.path: (BuildContext context, {arguments}) =>
      BookListDetailPage(arguments: arguments),
  BookListPage.path: (BuildContext context, {arguments}) =>
      BookListPage(arguments: arguments),
  CircleDetailPage.path: (BuildContext context, {arguments}) =>
      CircleDetailPage(arguments: arguments),
  UserInfoPage.path: (BuildContext context, {arguments}) =>
      UserInfoPage(arguments: arguments),
  MyRateListPage.path: (BuildContext context, {arguments}) =>
      MyRateListPage(arguments: arguments),
  MyForumListPage.path: (BuildContext context, {arguments}) =>
      MyForumListPage(arguments: arguments),
  MyCommentPage.path: (BuildContext context, {arguments}) =>
      MyCommentPage(arguments: arguments),
  AboutUsPage.path: (BuildContext context, {arguments}) =>
      AboutUsPage(arguments: arguments),
  ScannerPage.path: (BuildContext context, {arguments}) =>
      ScannerPage(arguments: arguments),
};

RouteFactory routeFactory = (RouteSettings settings) {
  final String? name = settings.name;
  final Function? widgetBuilder = routes[name];
  if (widgetBuilder != null) {
    if (settings.arguments == null) {
      return MaterialPageRoute(builder: (context) => widgetBuilder(context));
    }
    return MaterialPageRoute(
        builder: (context) =>
            widgetBuilder(context, arguments: settings.arguments));
  }
  return null;
};
