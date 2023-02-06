import 'package:delivery_app/core/extensions/formatter_extension.dart';
import 'package:delivery_app/core/ui/styles/colors_app.dart';
import 'package:delivery_app/core/ui/styles/text_styles.dart';
import 'package:delivery_app/core/ui/widgets/delivery_increment_decrement_button.dart';
import 'package:delivery_app/pages/order/order_controller.dart';
import 'package:flutter/material.dart';

import 'package:delivery_app/dto/order_product_dto.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderProductTile extends StatelessWidget {
  final int index;
  final OrderProductDTO orderProductDTO;

  const OrderProductTile({
    super.key,
    required this.index,
    required this.orderProductDTO,
  });

  @override
  Widget build(BuildContext context) {
    final product = orderProductDTO.productModel;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Image.network(
            product.image,
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style:
                        context.textStyles.textRegular.copyWith(fontSize: 16),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        (orderProductDTO.amount * product.price).currencyPTBR,
                        style: context.textStyles.textMedium.copyWith(
                          fontSize: 14,
                          color: context.colors.secondary,
                        ),
                      ),
                      DeliveryIncrementDecrementButton(
                        amount: orderProductDTO.amount,
                        incrementTap: () {
                          context
                              .read<OrderController>()
                              .incrementProduct(index);
                        },
                        decremenTap: () {
                          context
                              .read<OrderController>()
                              .decrementProduct(index);
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
