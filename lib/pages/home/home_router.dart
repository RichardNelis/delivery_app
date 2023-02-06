import 'package:delivery_app/core/rest_client/custom_dio.dart';
import 'package:delivery_app/pages/home/home_controller.dart';
import 'package:delivery_app/pages/home/home_page.dart';
import 'package:delivery_app/repositories/products/iproducts_repository%20copy.dart';
import 'package:delivery_app/repositories/products/products_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeRouter {
  HomeRouter._();

  static Widget get page => MultiProvider(
        providers: [
          Provider<IProductRepository>(
              create: (context) =>
                  ProductRepository(dio: context.read<CustomDio>())),
          Provider(create: (context) => HomeController(context.read()))
        ],
        child: const HomePage(),
      );
}
