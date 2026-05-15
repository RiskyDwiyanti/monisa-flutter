import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app/routes/app_pages.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('signupBox');

  await GetStorage.init();

  // set status bar transparan
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final box = GetStorage();
    // final savedTheme = box.read<String>('app_theme') ?? 'light';

    // ThemeMode themeMode;

    // switch (savedTheme) {
    //   case 'dark':
    //     themeMode = ThemeMode.dark;
    //     break;
    //   case 'system':
    //     themeMode = ThemeMode.system;
    //     break;
    //   default:
    //     themeMode = ThemeMode.light;
    // }

    return GetMaterialApp(
      title: 'Fitpal',
      debugShowCheckedModeBanner: false,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    );
  }
}