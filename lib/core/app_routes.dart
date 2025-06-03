import 'package:get/get.dart';
import 'package:taskapp/pages/share/share_page.dart';

import '../pages/frontpage.dart/frontPage.dart';
import '../pages/home/home_page.dart';
import '../pages/login/login.dart';
import '../pages/sign_up/sign_up.dart';
import '../pages/splash_screen/splash_screen.dart';

class AppRoutes {
  static String FRONTPAGE = '/frontPage';
  static String SPLASHSCREEN = '/splashScreen';
  static String HOMEPAGE = '/homePage';
  static String SIGNUP = '/signUp';
  static String LOGIN = '/login';
  static String SHARE = '/share';

  static List<GetPage> routes = [
    GetPage(name: FRONTPAGE, page: () => const Frontpage()),
    GetPage(name: SPLASHSCREEN, page: () => const SplashScreen()),
    GetPage(name: HOMEPAGE, page: () => const HomePage()),
    GetPage(name: SHARE, page: () => const SharePage()),
    GetPage(name: SIGNUP, page: () => const SignUp()),
    GetPage(name: LOGIN, page: () => const Login()),
  ];
}
