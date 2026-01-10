import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_utils/flutter_utils.dart';
import 'package:example/routes/app_router.dart';
import 'package:example/services/example_services.dart';
import 'package:example/controllers/example_controllers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Flutter Utils
  FlutterUtil.initialize(
    loaderSmall: const SpinKitCircle(color: Colors.blue, size: 30),
    loaderMedium: const SpinKitFadingCircle(color: Colors.blue, size: 50),
    loaderLarge: const SpinKitWave(color: Colors.blue, size: 70),
    imagesError: "assets/images/empty.png",
    imagesNoInternet: "assets/images/empty.png",
    imagesNoResults: "assets/images/empty.png",
  );
  
  // Initialize services
  await ExampleServices.initialize();
  
  // Register controllers
  ExampleControllers.register();
  
  runApp(const FlutterUtilsExampleApp());
}


class FlutterUtilsExampleApp extends StatelessWidget {
  const FlutterUtilsExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MaterialApp.router(
        title: 'Flutter Utils Example',
        routerConfig: AppRouter.router,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.light,
          ),
          appBarTheme: AppBarTheme(
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.black,
            titleTextStyle: GoogleFonts.inter(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark,
              systemNavigationBarColor: Colors.white,
              systemNavigationBarIconBrightness: Brightness.dark,
            ),
          ),
          cardTheme: CardThemeData(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
            ),
          ),
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.dark,
          ),
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

