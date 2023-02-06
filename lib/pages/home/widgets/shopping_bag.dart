import 'package:delivery_app/core/extensions/formatter_extension.dart';
import 'package:delivery_app/core/ui/helpers/size_extensions.dart';
import 'package:delivery_app/core/ui/styles/text_styles.dart';
import 'package:delivery_app/dto/order_product_dto.dart';
import 'package:delivery_app/pages/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShoopingBag extends StatelessWidget {
  final List<OrderProductDTO> orderProductDTOs;

  const ShoopingBag({super.key, required this.orderProductDTOs});

  @override
  Widget build(BuildContext context) {
    final totalBag = orderProductDTOs
        .fold<double>(
          0.0,
          (total, element) => total += element.totalPrice,
        )
        .currencyPTBR;

    return Container(
      padding: const EdgeInsets.all(20.0),
      width: context.screenWidth,
      height: 90,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5,
          )
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(7),
          topRight: Radius.circular(7),
        ),
      ),
      child: ElevatedButton(
        child: Stack(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Icon(Icons.shopping_cart_outlined),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                "Ver sacola",
                style: context.textStyles.textExtraBold
                    .copyWith(color: Colors.white, fontSize: 14),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                totalBag,
                style: context.textStyles.textExtraBold.copyWith(fontSize: 11),
              ),
            ),
          ],
        ),
        onPressed: () async {
          await _goOrder(context);
        },
      ),
    );
  }

  Future<void> _goOrder(BuildContext context) async {
    final controller = context.read<HomeController>();
    final navigator = Navigator.of(context);
    final sharedPreferences = await SharedPreferences.getInstance();

    if (!sharedPreferences.containsKey('accessToken')) {
      final loginResult = await navigator.pushNamed('/auth/login');

      if (loginResult == null || loginResult == false) {
        return;
      }
    }

    final updateBag =
        await navigator.pushNamed("/order", arguments: orderProductDTOs);

    controller.updateBag(updateBag as List<OrderProductDTO>);
  }
}
