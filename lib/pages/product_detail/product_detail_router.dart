import 'package:delivery_app/pages/product_detail/product_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'product_detail_page.dart';

class ProductDetailRouter {
  ProductDetailRouter._();

  static Widget get page => MultiProvider(
        providers: [
          Provider(
            create: (context) => ProductDetailController(),
          ),
        ],
        builder: (context, child) {
          final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;

          return ProductDetailPage(
            productModel: args['product'],
            orderProductDTO: args['order_product'],
          );
        },
      );
}
