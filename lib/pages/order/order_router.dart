import 'package:delivery_app/pages/order/order_controller.dart';
import 'package:delivery_app/pages/order/order_page.dart';
import 'package:delivery_app/repositories/order/iorder_repository.dart';
import 'package:delivery_app/repositories/order/order_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderRouter {
  OrderRouter._();

  static Widget get page => MultiProvider(
        providers: [
          Provider<IOrderRepository>(create: (context) => OrderRepository(dio: context.read())),
          Provider(create: (context) => OrderController(context.read())),
        ],
        child: const OrderPage(),
      );
}
