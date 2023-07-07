import 'package:edrb/common/Api.dart';
import 'package:edrb/common/Global.dart';
import 'package:edrb/models/result.dart';
import 'package:edrb/pages/home_page.dart';
import 'package:edrb/routes/routes.dart';
import 'package:edrb/controller/ContentController.dart';
import 'package:edrb/states/UserModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

void main() async {
  Global.init().then((e) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ContentController()),
        ChangeNotifierProvider(create: (_) => UserModel()),
      ],
      child: MaterialApp(
        color: Colors.white,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(brightness: Brightness.light),
        initialRoute: MyHomePage.path,
        onGenerateRoute: routeFactory,
        builder: EasyLoading.init(),
      ),
    );
  }
}
