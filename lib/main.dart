import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:just_task_it/app/helpers/constants/app_theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/routes/app_pages.dart';

import 'app/modules/theme/theme_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // ← moved to top, must be first

  await Supabase.initialize(
    url: 'https://nqtfmslfmecxwjabvyqk.supabase.co',
    anonKey: 'sb_publishable_oOZE9ea5H-WNSLFW69FvmQ_SsW2f1aK',
  );

  await GetStorage.init();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.put(ThemeController()); // ← register globally

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1)),
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return SafeArea(
            top: false,
            child: GetMaterialApp(
              title: 'Just Task It',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,          // ← add light theme
              darkTheme: AppTheme.darkTheme,        // ← add dark theme
              themeMode: themeController.themeMode, // ← use saved preference
              initialRoute: AppPages.INITIAL,
              getPages: AppPages.routes,
            ),
          );
        },
      ),
    );
  }
}
