import 'package:example/base_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_utils/app_flavor/app_flavor.dart';
import 'package:flutter_utils/extensions/extensions.dart';
import 'package:flutter_utils/flutter_utils.dart';
import 'package:flutter_utils/widgets/widgets.dart';
import 'app_route.dart';

final getIt = GetIt.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initServices();
  runApp(const MyApp());
}

Future initServices() async {
  getIt.registerSingleton(HomeController());
  AppFlavor().init(AppFlavors.development);
  FlutterUtil.initialize(
      loaderSmall: const SpinKitCircle(color: Colors.blue),
      loaderMedium: const SpinKitCircle(color: Colors.blue),
      loaderLarge: const SpinKitCircle(color: Colors.blue,),
      imagesError: "assets/images/empty.png",
      imagesNoInternet: "assets/images/empty.png",
      imagesNoResults: "assets/images/empty.png",
      imagesSuccess: "assets/images/empty.png",
  );
  await Future.delayed(const Duration(milliseconds: 10));
}

class HomeController extends BaseController{
  int _counter = 0;
  String _title = "Hello";

  String get title => _title;
  int get counter => _counter;

  set title(String newTitle){
    _title = newTitle;
    notifyListeners();
  }

  set counter(int counter){
    _counter = counter;
    notifyListeners();
  }

  showDialog(){
    getContext()?.showSimpleCustomDialog(title: 'title', description: 'description');
  }

  nextPage(){
    getContext()?.goNamed(AppRoute.secondPage);
  }


}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return ScreenUtilInit(
        designSize: ScreenUtil.defaultSize,
        builder:  (context,child) => MaterialApp.router(
      title: 'Flutter Demo',
          routerConfig: AppRoute.router,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        // titleTextStyle: TextStyle(fontFamily: fontBreeSerif,color: Colors.black, fontSize: 28, fontWeight: FontWeight.w900)),
        systemOverlayStyle: SystemUiOverlayStyle(
            systemNavigationBarColor: Colors.white,
            // navigation bar color
            statusBarColor: Colors.transparent,
            statusBarBrightness: Brightness.light,
            systemNavigationBarIconBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.dark),
        titleTextStyle: GoogleFonts.montserrat(
            color: Colors.black, fontSize: 22.sp, fontWeight: FontWeight.w800),
      ),
        useMaterial3: true,
      ),
          builder: (context,widget)=>FlavorBanner(child: widget ?? Container()),
    ));
  }
}


class MyHomePage extends StatelessView<HomeController> {

  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return  StyledToast(
        backgroundColor: Colors.blue,
        borderRadius: BorderRadius.circular(30),
    toastAnimation: StyledToastAnimation.slideFromTop,
    toastPositions: StyledToastPosition.top,
    duration: const Duration(milliseconds: 4000),
    locale: const Locale('en', 'US'),
    child: Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(controller.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            CustomTextButton(onTap: (){}, label: "Primary",icon: Ionicons.person,),
            CustomTextButton.secondary(onTap: (){}, label: "Secondary",icon: Ionicons.chatbox),
            CustomTextButton.tertiary(onTap: controller.showDialog, label: "Tertiary",icon: Ionicons.chatbox),
            CustomTextButton(onTap: controller.nextPage, label: "Second Page",icon: Ionicons.person,).paddingSymmetric(vertical: 10),

            ReactiveWidget<HomeController>(builder: (context,controller)=>Text(
              '${controller.counter}',
              style: Theme.of(context).textTheme.headlineMedium,
            )),
          ],
        ).paddingAll(16),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          // controller.showDialog();
          // context.showSuccessDialog(title: "Simple");
          context.showNoInternetDialog();
        },//()=>controller.counter++,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    ));
  }
}
