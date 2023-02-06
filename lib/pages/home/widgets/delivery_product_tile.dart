import 'package:delivery_app/core/extensions/formatter_extension.dart';
import 'package:delivery_app/core/ui/styles/colors_app.dart';
import 'package:delivery_app/core/ui/styles/text_styles.dart';
import 'package:delivery_app/dto/order_product_dto.dart';
import 'package:delivery_app/pages/home/home_controller.dart';
import 'package:flutter/material.dart';

import 'package:delivery_app/models/product_model.dart';
import 'package:provider/provider.dart';

class DeliveryProductTile extends StatelessWidget {
  final ProductModel productModel;
  final OrderProductDTO? orderProductDTO;

  const DeliveryProductTile({
    Key? key,
    required this.productModel,
    required this.orderProductDTO,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final controller = context.read<HomeController>();

        final orderProductDTOResult = await Navigator.of(context)
            .pushNamed('/product_detail', arguments: {
          'product': productModel,
          'order_product': orderProductDTO,
        });

        if (orderProductDTOResult != null) {
          controller.addOrUpdateBag(orderProductDTOResult as OrderProductDTO);
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      productModel.name,
                      style: context.textStyles.textExtraBold
                          .copyWith(fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      productModel.description,
                      style:
                          context.textStyles.textRegular.copyWith(fontSize: 12),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      productModel.price.currencyPTBR,
                      style: context.textStyles.textMedium.copyWith(
                        fontSize: 12,
                        color: context.colors.secondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            FadeInImage.assetNetwork(
              placeholder: 'assets/images/loading.gif',
              image: productModel.image,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            )
          ],
        ),
      ),
    );
  }
}
