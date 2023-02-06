import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:delivery_app/core/extensions/formatter_extension.dart';
import 'package:delivery_app/core/ui/base/ibase_state.dart';
import 'package:delivery_app/core/ui/helpers/size_extensions.dart';
import 'package:delivery_app/core/ui/styles/text_styles.dart';
import 'package:delivery_app/core/ui/widgets/delivery_app_bar.dart';
import 'package:delivery_app/core/ui/widgets/delivery_increment_decrement_button.dart';
import 'package:delivery_app/dto/order_product_dto.dart';
import 'package:delivery_app/models/product_model.dart';
import 'package:delivery_app/pages/product_detail/product_detail_controller.dart';

class ProductDetailPage extends StatefulWidget {
  final ProductModel productModel;
  final OrderProductDTO? orderProductDTO;

  const ProductDetailPage({
    Key? key,
    required this.productModel,
    this.orderProductDTO,
  }) : super(key: key);

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState
    extends IBaseState<ProductDetailPage, ProductDetailController> {
  @override
  void onReady() {
    super.onReady();

    final amount = widget.orderProductDTO?.amount ?? 1;

    controller.initial(amount, widget.orderProductDTO != null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DeliveryAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: context.screenWidth,
            height: context.percentHeight(0.40),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(widget.productModel.image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              widget.productModel.name,
              style: context.textStyles.textExtraBold.copyWith(fontSize: 22),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: SingleChildScrollView(
                child: Text(widget.productModel.description),
              ),
            ),
          ),
          const Divider(),
          Row(
            children: [
              Container(
                height: 68,
                padding: const EdgeInsets.all(8.0),
                width: context.percentWidth(.50),
                child: BlocBuilder<ProductDetailController, int>(
                  builder: (context, amount) {
                    return DeliveryIncrementDecrementButton(
                      decremenTap: controller.decrement,
                      incrementTap: controller.increment,
                      amount: amount,
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                height: 68,
                width: context.percentWidth(.50),
                child: BlocBuilder<ProductDetailController, int>(
                  builder: (context, amount) {
                    return ElevatedButton(
                      style: amount == 0
                          ? ElevatedButton.styleFrom(
                              backgroundColor: Colors.red)
                          : null,
                      onPressed: () {
                        if (amount == 0) {
                          _showConfirmDelete(amount);
                        } else {
                          Navigator.of(context).pop(
                            OrderProductDTO(
                              productModel: widget.productModel,
                              amount: amount,
                            ),
                          );
                        }
                      },
                      child: Visibility(
                        visible: amount > 0,
                        replacement: Text(
                          "Remover Item",
                          style: context.textStyles.textExtraBold,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Adicionar",
                              style: context.textStyles.textExtraBold
                                  .copyWith(fontSize: 13),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: AutoSizeText(
                                (widget.productModel.price * amount)
                                    .currencyPTBR,
                                maxFontSize: 13,
                                minFontSize: 5,
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                style: context.textStyles.textExtraBold
                                    .copyWith(fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  void _showConfirmDelete(int amount) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Deseja excluir o item"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Cancelar",
                style: context.textStyles.textBold.copyWith(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();

                Navigator.of(context).pop(
                  OrderProductDTO(
                    productModel: widget.productModel,
                    amount: amount,
                  ),
                );
              },
              child: const Text(
                "Confirmar",
              ),
            ),
          ],
        );
      },
    );
  }
}
