import 'package:example/base_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_utils/app_flavor/app_flavor.dart';
import 'package:flutter_utils/extensions/extensions.dart';
import 'package:flutter_utils/flutter_utils.dart';
import 'package:flutter_utils/util/src/helper.dart';
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
    loaderLarge: const SpinKitCircle(color: Colors.blue),
    imagesError: "assets/images/empty.png",
    imagesNoInternet: "assets/images/empty.png",
    imagesNoResults: "assets/images/empty.png",
  );
  await Future.delayed(const Duration(milliseconds: 10));
}

class HomeController extends BaseController {
  int _counter = 0;
  String _title = "Hello";

  String get title => _title;
  int get counter => _counter;

  set title(String newTitle) {
    _title = newTitle;
    notifyListeners();
  }

  set counter(int counter) {
    _counter = counter;
    notifyListeners();
  }

  showDialog() {
    getContext()
        ?.showSimpleCustomDialog(title: 'title', description: 'description');
  }

  nextPage() {
    getContext()?.goNamed(AppRoute.secondPage);
  }

  LoadStatus initialStatus = LoadStatus.loading;
  LoadStatus loadMoreStatus = LoadStatus.idle;
  final List<Item> items = [];
  int _currentPage = 0;

  Future<void> loadInitial() async {
    initialStatus = LoadStatus.loading;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2)); // Simulate API call

    items.clear();
    items.addAll(List.generate(
      20,
      (index) => Item(
        id: index + 1,
        title: 'Initial Item ${index + 1}',
      ),
    ));

    initialStatus = LoadStatus.initialLoadSuccess;
    notifyListeners();
  }

  Future<void> loadMore() async {
    if (loadMoreStatus == LoadStatus.loading) return;

    loadMoreStatus = LoadStatus.loading;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1)); // Simulate API call

    _currentPage++;
    final newItems = List.generate(
      10,
      (index) => Item(
        id: items.length + index + 1,
        title: 'Page $_currentPage - Item ${index + 1}',
      ),
    );

    items.addAll(newItems);

    loadMoreStatus =
        items.length >= 50 ? LoadStatus.completed : LoadStatus.idle;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: ScreenUtil.defaultSize,
        builder: (context, child) => MaterialApp.router(
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
                      color: Colors.black,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w800),
                ),
                useMaterial3: true,
              ),
              builder: (context, widget) =>
                  FlavorBanner(child: widget ?? Container()),
            ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final controller = getIt<HomeController>();

  @override
  void initState() {
    super.initState();
    controller.loadInitial();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animated Load More Demo'),
      ),
      body: ReactiveWidget<HomeController>(
        builder: (context, controller) {
          return LoadMore(
            status: controller.loadMoreStatus,
            initialStatus: controller.initialStatus,
            onLoadMore: controller.loadMore,
            onRefresh: controller.loadInitial,
            animateNewItems: true, // Enable animations
            staggerDuration: const Duration(milliseconds: 50),
            animationDuration: const Duration(milliseconds: 400),
            child: CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final item = controller.items[index];
                      return Card(
                        margin: const EdgeInsets.all(8),
                        child: ListTile(
                          title: Text('Item ${item.id}'),
                          subtitle: Text(item.title),
                        ),
                      );
                    },
                    childCount: controller.items.length,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// Mock Item Model
class Item {
  final int id;
  final String title;

  Item({required this.id, required this.title});
}
