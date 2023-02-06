import 'package:delivery_app/core/config/env/env.dart';
import 'package:delivery_app/core/global/global_context.dart';
import 'package:delivery_app/core/provider/application_binding.dart';
import 'package:delivery_app/core/ui/theme/theme_config.dart';
import 'package:delivery_app/pages/auth/login/login_router.dart';
import 'package:delivery_app/pages/order/order_completed_page.dart';
import 'package:delivery_app/pages/order/order_router.dart';
import 'package:flutter/material.dart';

import 'pages/auth/register/register_router.dart';
import 'pages/home/home_router.dart';
import 'pages/product_detail/product_detail_router.dart';
import 'pages/splash/splash_page.dart';

Future<void> main() async {
  await Env.instance.load();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _navigatorKey = GlobalKey<NavigatorState>();

  MyApp({super.key}) {
    GlobalContext.instance.navigatorKey = _navigatorKey;
  }

  @override
  Widget build(BuildContext context) {
    return ApplicationBinding(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeConfig.theme,
        title: 'Delivery App',
        navigatorKey: _navigatorKey,
        routes: {
          '/': (context) => const SplashPage(),
          '/auth/login': (context) => LoginRouter.page,
          '/auth/register': (context) => RegisterRouter.page,
          '/home': (context) => HomeRouter.page,
          '/product_detail': (context) => ProductDetailRouter.page,
          '/order': (context) => OrderRouter.page,
          '/order/completed': (context) => const OrderCompletedPage(),
        },
      ),
    );
  }
}
