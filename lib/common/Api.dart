import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:edrb/common/Global.dart';
import 'package:edrb/models/author.dart';
import 'package:edrb/models/author_book.dart';
import 'package:edrb/models/book_comment_vo.dart';
import 'package:edrb/models/book_detail_vo.dart';
import 'package:edrb/models/book_forum.dart';
import 'package:edrb/models/book_forum_comment_vo.dart';
import 'package:edrb/models/book_list_comment_vo.dart';
import 'package:edrb/models/book_list_count.dart';
import 'package:edrb/models/book_list_vo.dart';
import 'package:edrb/models/book_rate_vo.dart';
import 'package:edrb/models/book_re_view.dart';
import 'package:edrb/models/book_vo.dart';
import 'package:edrb/models/catalog_vo.dart';
import 'package:edrb/models/category.dart';
import 'package:edrb/models/content_vo.dart';
import 'package:edrb/models/rate.dart';
import 'package:edrb/models/record_vo.dart';
import 'package:edrb/models/result.dart';
import 'package:edrb/models/shelf_vo.dart';
import 'package:edrb/models/user_vo.dart';
import 'package:edrb/pages/login_page.dart';
import 'package:edrb/states/UserModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class Api {
  BuildContext? buildContext;
  late Options _options;

  Api([this.buildContext]) {
    _options = Options(extra: {"context": buildContext});
  }

  static Dio dio = Dio(
    BaseOptions(
      baseUrl: "http://192.168.3.122:8080",
      headers: {HttpHeaders.contentTypeHeader: Headers.jsonContentType},
      responseType: ResponseType.json,
      validateStatus: (_) => true,
    ),
  );

  static void init() {

    print('---- > Global.isRelease ${Global.isRelease}');

    if (Global.isRelease) {
      dio.options.baseUrl = "https://api.tititxt.net";
    }
    // 设置用户token（可能是null，代表未登录）
    if (Global.profile.token != null) {
      dio.options.headers['Authorization'] = 'Bearer ${Global.profile.token}';
    }
  }

  void _handler() {
    Global.clear();
    Provider.of<UserModel>(buildContext!, listen: false).clear = UserVo();
  }

  Future<void> logout() async {
    Response res =
        await dio.post("/auth/logout", queryParameters: Global.handleData({}));
    if (res.statusCode == 200) {
      _handler();
    } else {
      EasyLoading.show(status: '退出失败');
    }
  }

  Future<void> login(Map<String, Object> data) async {
    EasyLoading.show(status: '登录中');
    Response res = await dio.post("/auth/login",
        data: json.encode(Global.handleData(data)));
    if (res.statusCode == 200) {
      Result<Map<String, dynamic>> result =
          Result.fromJson(res.data, (json) => res.data['data']);
      if (result.code == 200) {
        String token = result.data?['token'];
        UserVo userVo = UserVo.fromJson(result.data?['user']);

        dio.options.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
        Global.profile.token = token;
        Global.profile.status = true;
        Global.profile.user = userVo;
        Provider.of<UserModel>(buildContext!, listen: false).user = userVo;
        Navigator.of(buildContext!).pop();
        EasyLoading.dismiss();
      } else {
        EasyLoading.dismiss();
        EasyLoading.showError(res.data['message']);
      }
    } else {
      EasyLoading.dismiss();
      EasyLoading.showError('登录失败');
    }
  }

  Future<int> readDay() async {
    Response res = await dio.get("/book/home/user/last/read",
        queryParameters: Global.handleData({}));
    if (res.statusCode == 200) {
      return res.data['data'];
    }
    return 0;
  }

  Future<List<Record>> recordList() async {
    Response res = await dio.get("/book/home/user/record",
        queryParameters: Global.handleData({}));
    if (res.statusCode == 401) {
      _handler();
    }
    if (res.statusCode == 200) {
      Result<List> result =
          Result.fromJson(res.data, (json) => res.data['data']);
      return result.data!.map((e) => Record.fromJson(e)).toList();
    }
    return [];
  }

  Future<List<ShelfVo>> shelfList() async {
    Response res = await dio.get("/book/shelf/list",
        queryParameters: Global.handleData({}));
    if (res.statusCode == 401) {
      _handler();
    }
    if (res.statusCode == 200) {
      Result<List> result =
          Result.fromJson(res.data, (json) => res.data['data']);
      return result.data!.map((e) => ShelfVo.fromJson(e)).toList();
    }
    return [];
  }

  Future<List<BookVo>> searchBook(Map<String, Object> data) async {
    Response res =
        await dio.get("/book/search", queryParameters: Global.handleData(data));
    if (res.statusCode == 200) {
      Result<List> result =
          Result.fromJson(res.data, (json) => res.data['data']['content']);
      return result.data!.map((e) => BookVo.fromJson(e)).toList();
    }
    return [];
  }

  Future<List<Author>> searchAuthor(Map<String, Object> data) async {
    Response res =
        await dio.get("/book/author", queryParameters: Global.handleData(data));
    if (res.statusCode == 200) {
      Result<List> result =
          Result.fromJson(res.data, (json) => res.data['data']);
      return result.data!.map((e) => Author.fromJson(e)).toList();
    }
    return [];
  }

  Future<AuthorBook?> searchAuthorBook(Map<String, Object> data) async {
    Response res = await dio.get("/book/author/book",
        queryParameters: Global.handleData(data));
    if (res.statusCode == 200) {
      Result<Map<String, dynamic>> result =
          Result.fromJson(res.data, (json) => res.data['data']);
      return AuthorBook.fromJson(result.data!);
    }
    return null;
  }

  Future<List<BookVo>> homeRand(Map<String, Object> data) async {
    Response res = await dio.get("/book/home/rand",
        queryParameters: Global.handleData(data));
    if (res.statusCode == 200) {
      Result<List> result =
          Result.fromJson(res.data, (json) => res.data['data']);

      return result.data!.map((e) => BookVo.fromJson(e)).toList();
    }

    return [];
  }

  Future<List<BookVo>> homeGreat(Map<String, Object> data) async {
    data['pageNum'] = 1;
    data['pageSize'] = 8;
    Response res = await dio.get("/book/home/great",
        queryParameters: Global.handleData(data));
    if (res.statusCode == 200) {
      Result<List> result =
          Result.fromJson(res.data, (json) => res.data['data']['content']);
      return result.data!.map((e) => BookVo.fromJson(e)).toList();
    }
    return [];
  }

  Future<List<BookVo>> top200(Map<String, Object> data) async {
    Response res = await dio.get("/book/home/top200",
        queryParameters: Global.handleData(data));
    if (res.statusCode == 200) {
      Result<List> result =
          Result.fromJson(res.data, (json) => res.data['data']['content']);
      return result.data!.map((e) => BookVo.fromJson(e)).toList();
    }
    return [];
  }

  Future<List<BookVo>> top50(Map<String, Object> data) async {
    Response res = await dio.get("/book/home/top50",
        queryParameters: Global.handleData(data));
    if (res.statusCode == 200) {
      Result<List> result =
          Result.fromJson(res.data, (json) => res.data['data']['content']);
      return result.data!.map((e) => BookVo.fromJson(e)).toList();
    }
    return [];
  }

  Future<List<Category>> category() async {
    Response res = await dio.get("/book/category/list",
        queryParameters: Global.handleData({}));

    if (res.statusCode == 200) {
      Result<List> result =
          Result.fromJson(res.data, (json) => res.data['data']);
      return result.data!.map((e) => Category.fromJson(e)).toList();
    }
    return [];
  }

  Future<List<BookVo>> findList(Map<String, Object> data) async {
    Response res =
        await dio.get("/book/list", queryParameters: Global.handleData(data));
    if (res.statusCode == 200) {
      Result<List> result =
          Result.fromJson(res.data, (json) => res.data['data']['content']);
      return result.data!.map((e) => BookVo.fromJson(e)).toList();
    }
    return [];
  }

  Future<BookDetailVo> bookDetail(String id) async {
    Response res = await dio.get("/book/detail/$id",
        queryParameters: Global.handleData({}));
    if (res.statusCode == 200) {
      Result<Map<String, dynamic>> result =
          Result.fromJson(res.data, (json) => res.data['data']);
      return BookDetailVo.fromJson(result.data!);
    }
    return BookDetailVo();
  }

  Future<List<CatalogVo>> catalogList(Map<String, Object> data) async {
    Response res = await dio.get("/book/catalog/list",
        queryParameters: Global.handleData(data));
    if (res.statusCode == 200) {
      Result<List> result =
          Result.fromJson(res.data, (json) => res.data['data']['content']);
      return result.data!.map((e) => CatalogVo.fromJson(e)).toList();
    }
    return [];
  }

  Future<List<BookRateVo>> myRateList(Map<String, Object> data) async {
    Response res = await dio.get("/book/rate/my/list",
        queryParameters: Global.handleData(data));
    if (res.statusCode == 401) {
      _handler();
    }
    if (res.statusCode == 200) {
      Result<List> result =
          Result.fromJson(res.data, (json) => res.data['data']['content']);
      return result.data!.map((e) => BookRateVo.fromJson(e)).toList();
    }
    return [];
  }

  Future<List<BookRateVo>> rateList(Map<String, Object> data) async {
    Response res = await dio.get("/book/rate/list",
        queryParameters: Global.handleData(data));
    if (res.statusCode == 200) {
      Result<List> result =
          Result.fromJson(res.data, (json) => res.data['data']['content']);
      return result.data!.map((e) => BookRateVo.fromJson(e)).toList();
    }
    return [];
  }

  Future<String?> saveRate(Map<String, dynamic> data) async {
    Response res = await dio.post("/book/rate",
        data: json.encode(Global.handleData(data)));
    if (res.statusCode == 401) {
      Navigator.of(buildContext!).pushNamed(LoginPage.path);
    }
    if (res.statusCode == 200 && res.data['code'] == 200) {
      return res.data['data'];
    }
    return null;
  }

  Future<BookRateVo?> getRate(String id) async {
    Response res =
        await dio.get("/book/rate/$id", queryParameters: Global.handleData({}));
    if (res.statusCode == 200 && res.data['code'] == 200) {
      Result<Map<String, dynamic>> result =
          Result.fromJson(res.data, (json) => res.data['data']);
      return BookRateVo.fromJson(result.data!);
    }
    return null;
  }

  Future<int> delRate(String id) async {
    Response res = await dio.delete("/book/rate/del/$id",
        data: json.encode(Global.handleData({})));
    if (res.statusCode == 200 && res.data['code'] == 200) {
      return 1;
    }
    return -1;
  }

  Future<Rate?> calculate(String id) async {
    Response res = await dio.get("/book/rate/calculate/$id",
        queryParameters: Global.handleData({}));
    if (res.statusCode == 200) {
      Result<Map<String, dynamic>> result =
          Result.fromJson(res.data, (json) => res.data['data']);
      return Rate.fromJson(result.data!);
    }
    return null;
  }

  Future<int> addShelf(String id) async {
    Response res = await dio.post("/book/shelf/$id",
        data: json.encode(Global.handleData({})));
    if (res.statusCode == 401) {
      Navigator.of(buildContext!).pushNamed(LoginPage.path);
    } else {
      if (res.statusCode == 200 && res.data['code'] == 200) {
        return 0;
      }
    }
    return -1;
  }

  Future<int> delShelf(String ids) async {
    Response res = await dio.delete("/book/shelf/delete/$ids",
        data: json.encode(Global.handleData({})));
    if (res.statusCode == 401) {
      Navigator.of(buildContext!).pushNamed(LoginPage.path);
    } else {
      if (res.statusCode == 200 && res.data['code'] == 200) {
        return 0;
      }
    }
    return -1;
  }

  Future<String?> start(String bid) async {
    Response res = await dio.get("/book/content/start/$bid",
        queryParameters: Global.handleData({}));
    if (res.statusCode == 200 && res.data['code'] == 200) {
      return res.data['data'];
    }
    return null;
  }

  Future<ContentVo?> content(String cid) async {
    Response res = await dio.get("/book/content/$cid",
        queryParameters: Global.handleData({}));
    if (res.statusCode == 200 && res.data['code'] == 200) {
      Result<Map<String, dynamic>> result =
          Result.fromJson(res.data, (json) => res.data['data']);
      return ContentVo.fromJson(result.data!);
    }
    return null;
  }

  Future<String?> next(String bid, String cid) async {
    Response res = await dio.get("/book/content/next/$bid/$cid",
        queryParameters: Global.handleData({}));
    if (res.statusCode == 200 && res.data['code'] == 200) {
      Result<String> result =
          Result.fromJson(res.data, (json) => res.data['data']);
      return result.data;
    }
    return null;
  }

  Future<String?> prev(String bid, String cid) async {
    Response res = await dio.get("/book/content/prev/$bid/$cid",
        queryParameters: Global.handleData({}));
    if (res.statusCode == 200 && res.data['code'] == 200) {
      Result<String> result =
          Result.fromJson(res.data, (json) => res.data['data']);
      return result.data;
    }
    return null;
  }

  Future<int> subBookList(Map<String, dynamic> data) async {
    Response res = await dio.post("/book/booklist",
        data: json.encode(Global.handleData(data)));
    if (res.statusCode == 401) {
      Navigator.of(buildContext!).pushNamed(LoginPage.path);
    } else {
      if (res.statusCode == 200 && res.data['code'] == 200) {
        return 0;
      }
    }
    return -1;
  }

  Future<List<BookListVo>> blList(Map<String, Object> data) async {
    Response res = await dio.get("/book/booklist/list",
        queryParameters: Global.handleData(data));

    if (res.statusCode == 401) {
      _handler();
    }
    if (res.statusCode == 200) {
      Result<List> result =
          Result.fromJson(res.data, (json) => res.data['data']['content']);
      return result.data!.map((e) => BookListVo.fromJson(e)).toList();
    }
    return [];
  }

  Future<List<BookListVo>> blListPage(Map<String, Object> data) async {
    Response res = await dio.get("/book/booklist/page",
        queryParameters: Global.handleData(data));
    if (res.statusCode == 200) {
      Result<List> result =
          Result.fromJson(res.data, (json) => res.data['data']['content']);
      return result.data!.map((e) => BookListVo.fromJson(e)).toList();
    }
    return [];
  }

  Future<BookListVo?> blDetail(String id) async {
    Response res = await dio.get("/book/booklist/detail/$id",
        queryParameters: Global.handleData({}));
    if (res.statusCode == 200) {
      Result<Map<String, dynamic>> result =
          Result.fromJson(res.data, (json) => res.data['data']);
      return BookListVo.fromJson(result.data!);
    }
    return null;
  }

  Future<int> delBookList(String id) async {
    Response res = await dio.delete("/book/booklist/del/$id",
        data: json.encode(Global.handleData({})));
    if (res.statusCode == 401) {
      Navigator.of(buildContext!).pushNamed(LoginPage.path);
    } else {
      if (res.statusCode == 200 && res.data['code'] == 200) {
        return 0;
      }
    }
    return -1;
  }

  Future<int> syncBookList(String id) async {
    Response res = await dio.put("/book/booklist/sync/$id",
        data: json.encode(Global.handleData({})));
    if (res.statusCode == 401) {
      Navigator.of(buildContext!).pushNamed(LoginPage.path);
    } else {
      if (res.statusCode == 200 && res.data['code'] == 200) {
        return 0;
      }
    }
    return -1;
  }

  Future<bool> likeBookList(String id) async {
    Response res = await dio.post("/book/booklist/like/$id",
        data: json.encode(Global.handleData({})));
    if (res.statusCode == 401) {
      Navigator.of(buildContext!).pushNamed(LoginPage.path);
    } else {
      if (res.statusCode == 200 && res.data['code'] == 200) {
        return res.data['data'];
      }
    }
    return false;
  }

  Future<BookListCount?> countBookList(String id) async {
    Response res = await dio.get("/book/booklist/count/$id",
        data: json.encode(Global.handleData({})));
    if (res.statusCode == 200) {
      Result<Map<String, dynamic>> result =
          Result.fromJson(res.data, (json) => res.data['data']);
      return BookListCount.fromJson(result.data!);
    }
    return null;
  }

  Future<String?> saveComment(Map<String, Object> data) async {
    Response res = await dio.post("/book/booklist/comment",
        data: json.encode(Global.handleData(data)));
    if (res.statusCode == 401) {
      Navigator.of(buildContext!).pushNamed(LoginPage.path);
    } else {
      if (res.statusCode == 200 && res.data['code'] == 200) {
        return res.data['data'].toString();
      }
    }
    return null;
  }

  Future<List<BookListCommentVo>> blCommentList(
      Map<String, Object> data) async {
    Response res = await dio.get("/book/booklist/comment/list",
        queryParameters: Global.handleData(data));
    if (res.statusCode == 200) {
      Result<List> result =
          Result.fromJson(res.data, (json) => res.data['data']['content']);
      return result.data!.map((e) => BookListCommentVo.fromJson(e)).toList();
    }
    return [];
  }

  Future<List<UserVo>> blLikeList(Map<String, Object> data) async {
    Response res = await dio.get("/book/booklist/like/list",
        queryParameters: Global.handleData(data));
    if (res.statusCode == 200) {
      Result<List> result =
          Result.fromJson(res.data, (json) => res.data['data']['content']);
      return result.data!.map((e) => UserVo.fromJson(e)).toList();
    }
    return [];
  }

  Future<BookListCommentVo?> bookListDetail(String id) async {
    Response res = await dio.get("/book/booklist/comment/$id",
        data: json.encode(Global.handleData({})));
    if (res.statusCode == 200) {
      Result<Map<String, dynamic>> result =
          Result.fromJson(res.data, (json) => res.data['data']);
      return BookListCommentVo.fromJson(result.data!);
    }
    return null;
  }

  Future<String?> upload(XFile file) async {
    Map<String, dynamic> data = {
      'file': await MultipartFile.fromFile(file.path, filename: file.name),
    };
    FormData fd = FormData.fromMap(Global.handleData(data));

    Response res = await dio.post("/book/forum/upload", data: fd);
    if (res.statusCode == 401) {
      Navigator.of(buildContext!).pushNamed(LoginPage.path);
    } else {
      if (res.statusCode == 200 && res.data['code'] == 200) {
        return res.data['data'].toString();
      }
    }
    return null;
  }

  Future<String?> uploadAvatar(String localPath, String name) async {
    Map<String, dynamic> data = {
      'file': await MultipartFile.fromFile(localPath, filename: name),
    };
    FormData fd = FormData.fromMap(Global.handleData(data));

    Response res = await dio.post("/auth/user/upload", data: fd);
    if (res.statusCode == 200 && res.data['code'] == 200) {
      return res.data['data'];
    }
    return null;
  }

  Future<List<String>?> uploads(List<XFile> file) async {
    List<MultipartFile> files = [];

    for (XFile f in file) {
      MultipartFile mf = await MultipartFile.fromFile(f.path, filename: f.name);
      files.add(mf);
    }

    Map<String, dynamic> data = {
      'file': files,
    };
    FormData fd = FormData.fromMap(Global.handleData(data));

    Response res = await dio.post("/book/forum/upload", data: fd);
    if (res.statusCode == 401) {
      EasyLoading.dismiss();
      Navigator.of(buildContext!).pushNamed(LoginPage.path);
    } else {
      if (res.statusCode == 200 && res.data['code'] == 200) {
        Result<List<dynamic>> result =
            Result.fromJson(res.data, (json) => res.data['data']);
        return result.data?.map((e) => e.toString()).toList();
      }
    }
    return null;
  }

  Future<String?> saveForum(Map<String, dynamic> data) async {
    Response res = await dio.post("/book/forum",
        data: json.encode(Global.handleData(data)));

    if (res.statusCode == 401) {
      EasyLoading.dismiss();
      Navigator.of(buildContext!).pushNamed(LoginPage.path);
    } else {
      if (res.statusCode == 200 && res.data['code'] == 200) {
        return res.data['data'].toString();
      }
    }
    return null;
  }

  Future<List<BookForum>> myForumList(Map<String, Object> data) async {
    Response res = await dio.get("/book/forum/my/list",
        queryParameters: Global.handleData(data));
    if (res.statusCode == 200) {
      Result<List> result =
          Result.fromJson(res.data, (json) => res.data['data']['content']);
      return result.data!.map((e) => BookForum.fromJson(e)).toList();
    }
    return [];
  }

  Future<int> delForum(String id) async {
    Response res = await dio.delete("/book/forum/del/$id",
        data: json.encode(Global.handleData({})));
    if (res.statusCode == 200 && res.data['code'] == 200) {
      return 1;
    }
    return -1;
  }

  Future<List<BookForum>> forumList(Map<String, Object> data) async {
    Response res = await dio.get("/book/forum/list",
        queryParameters: Global.handleData(data));
    if (res.statusCode == 200) {
      Result<List> result =
          Result.fromJson(res.data, (json) => res.data['data']['content']);
      return result.data!.map((e) => BookForum.fromJson(e)).toList();
    }
    return [];
  }

  Future<BookForum?> bookForum(String id) async {
    Response res = await dio.get("/book/forum/detail/$id",
        data: json.encode(Global.handleData({})));
    if (res.statusCode == 200) {
      Result<Map<String, dynamic>> result =
          Result.fromJson(res.data, (json) => res.data['data']);
      return BookForum.fromJson(result.data!);
    }
    return null;
  }

  Future<String?> saveForumComment(Map<String, Object> data) async {
    Response res = await dio.post("/book/forum/comment",
        data: json.encode(Global.handleData(data)));
    if (res.statusCode == 401) {
      Navigator.of(buildContext!).pushNamed(LoginPage.path);
    } else {
      if (res.statusCode == 200 && res.data['code'] == 200) {
        return res.data['data'].toString();
      }
    }
    return null;
  }

  Future<BookForumCommentVo?> bookForumCommentDetail(String id) async {
    Response res = await dio.get("/book/forum/comment/$id",
        data: json.encode(Global.handleData({})));
    if (res.statusCode == 200) {
      Result<Map<String, dynamic>> result =
          Result.fromJson(res.data, (json) => res.data['data']);
      return BookForumCommentVo.fromJson(result.data!);
    }
    return null;
  }

  Future<List<BookForumCommentVo>> bfCommentList(
      Map<String, Object> data) async {
    Response res = await dio.get("/book/forum/comment/list",
        queryParameters: Global.handleData(data));
    if (res.statusCode == 200) {
      Result<List> result =
          Result.fromJson(res.data, (json) => res.data['data']['content']);
      return result.data!.map((e) => BookForumCommentVo.fromJson(e)).toList();
    }
    return [];
  }

  Future<List<UserVo>> bfLikeList(Map<String, Object> data) async {
    Response res = await dio.get("/book/forum/like/list",
        queryParameters: Global.handleData(data));
    if (res.statusCode == 200) {
      Result<List> result =
          Result.fromJson(res.data, (json) => res.data['data']['content']);
      return result.data!.map((e) => UserVo.fromJson(e)).toList();
    }
    return [];
  }

  Future<bool> likeBookForum(String id) async {
    Response res = await dio.post("/book/forum/like/$id",
        data: json.encode(Global.handleData({})));
    if (res.statusCode == 401) {
      Navigator.of(buildContext!).pushNamed(LoginPage.path);
    } else {
      if (res.statusCode == 200 && res.data['code'] == 200) {
        return res.data['data'];
      }
    }
    return false;
  }

  Future<List<BookReView>> findBookRe(Map<String, Object> data) async {
    Response res = await dio.get("/book/re/list",
        queryParameters: Global.handleData(data));
    if (res.statusCode == 200) {
      Result<List> result =
          Result.fromJson(res.data, (json) => res.data['data']['content']);
      return result.data!.map((e) => BookReView.fromJson(e)).toList();
    }
    return [];
  }

  Future<void> saveReadTime(String bid) async {
    await dio.post("/book/read/$bid", data: json.encode(Global.handleData({})));
  }

  Future<Map<String, dynamic>?> readTime() async {
    Response res = await dio.get("/book/read/time",
        queryParameters: Global.handleData({}));

    if (res.statusCode == 401) {}

    if (res.statusCode == 200) {
      return res.data['data'];
    }
    return null;
  }

  Future<int> updateUser(Map<String, Object> data, UserVo userVo) async {
    Response res = await dio.put("/auth/user/update",
        data: json.encode(Global.handleData(data)));
    if (res.statusCode == 200) {
      Global.profile.user = userVo;
      Provider.of<UserModel>(buildContext!, listen: false).user = userVo;
      Navigator.of(buildContext!).pop();
      return 0;
    }
    return -1;
  }

  Future<Map<String, dynamic>?> readingTime() async {
    Response res = await dio.get("/book/read/reading/time",
        queryParameters: Global.handleData({}));
    if (res.statusCode == 200) {
      return res.data['data'];
    }
    return null;
  }

  Future<List<BookCommentVo>> myComment(Map<String, Object> data) async {
    Response res = await dio.get("/book/comment/list",
        queryParameters: Global.handleData(data));
    if (res.statusCode == 200) {
      Result<List> result =
          Result.fromJson(res.data, (json) => res.data['data']['content']);
      return result.data!.map((e) => BookCommentVo.fromJson(e)).toList();
    }
    return [];
  }

  Future<int> delComment(String type, String id) async {
    Response res = await dio.delete("/book/comment/del/$type/$id",
        data: json.encode(Global.handleData({})));
    if (res.statusCode == 200 && res.data['code'] == 200) {
      return 1;
    }
    return -1;
  }

  Future<List<ContentVo>> cache(String bid, String? cid) async {
    Response res = await dio.get("/book/cache/$bid/$cid",
        queryParameters: Global.handleData({}));
    if (res.statusCode == 401) {
      Navigator.of(buildContext!).pushNamed(LoginPage.path);
    } else if (res.statusCode == 200) {
      Result<List> result =
          Result.fromJson(res.data, (json) => res.data['data']);
      return result.data!.map((e) => ContentVo.fromJson(e)).toList();
    }
    return [];
  }

  Future<int> scan(String uuid, String token) async {
    Response res = await dio.get("/auth/scan/$uuid/$token",
        queryParameters: Global.handleData({}));
    if (res.statusCode == 401) {
      Navigator.of(buildContext!).pushNamed(LoginPage.path);
    } else if (res.statusCode == 200 && res.data['code'] == 200) {
      return 1;
    }

    return -1;
  }
}
