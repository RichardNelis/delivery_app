import 'package:delivery_app/core/extensions/formatter_extension.dart';
import 'package:delivery_app/core/ui/base/ibase_state.dart';
import 'package:delivery_app/core/ui/styles/text_styles.dart';
import 'package:delivery_app/core/ui/widgets/delivery_app_bar.dart';
import 'package:delivery_app/core/ui/widgets/delivery_button.dart';
import 'package:delivery_app/dto/order_product_dto.dart';
import 'package:delivery_app/models/payment_type_model.dart';
import 'package:delivery_app/pages/order/order_controller.dart';
import 'package:delivery_app/pages/order/order_state.dart';
import 'package:delivery_app/pages/order/widget/order_field.dart';
import 'package:delivery_app/pages/order/widget/order_product_tile.dart';
import 'package:delivery_app/pages/order/widget/payment_types_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:validatorless/validatorless.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends IBaseState<OrderPage, OrderController> {
  final _formKey = GlobalKey<FormState>();

  final addressTEC = TextEditingController();
  final documentTEC = TextEditingController();
  int? paymentTypeId;

  final paymentTypeValid = ValueNotifier<bool>(true);

  @override
  void onReady() {
    super.onReady();

    final orderProductDTOs =
        ModalRoute.of(context)!.settings.arguments as List<OrderProductDTO>;

    controller.load(orderProductDTOs);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrderController, OrderState>(
      listener: (context, state) {
        state.status.matchAny(
          any: () => hideLoader(),
          loading: () => showLoader(),
          error: () {
            hideLoader();
            showError(state.errorMessage ?? "Erro não informado");
          },
          confirmRemoveProduct: () {
            hideLoader();
            if (state is OrderConfirmDeleteProductState) {
              _showConfirmDeleteProductDialog(state);
            }
          },
          emptyBag: () {
            hideLoader();
            showInfo(
                "Sua sacola esta vazia, por favor selecione um produto para realizar o pedido!");
            Navigator.of(context).pop(<OrderProductDTO>[]);
          },
          success: () {
            hideLoader();
            Navigator.of(context).popAndPushNamed(
              "/order/completed",
              result: <OrderProductDTO>[],
            );
          },
        );
      },
      child: WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pop(controller.state.orderProductDTOs);
          return false;
        },
        child: Scaffold(
          appBar: DeliveryAppBar(),
          body: Form(
            key: _formKey,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10.0),
                    child: Row(
                      children: [
                        Text(
                          "Carrinho",
                          style: context.textStyles.textTitle,
                        ),
                        IconButton(
                          onPressed: () {
                            controller.emptyBag();
                          },
                          icon: Image.asset("assets/images/trashRegular.png"),
                        )
                      ],
                    ),
                  ),
                ),
                BlocSelector<OrderController, OrderState,
                    List<OrderProductDTO>>(
                  selector: (state) => state.orderProductDTOs,
                  builder: (context, orderProductDTOs) {
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        childCount: orderProductDTOs.length,
                        (context, index) {
                          final orderProduct = orderProductDTOs[index];

                          return Column(
                            children: [
                              OrderProductTile(
                                index: index,
                                orderProductDTO: orderProduct,
                              ),
                              const Divider(
                                color: Colors.grey,
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  },
                ),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Total do pedido",
                              style: context.textStyles.textExtraBold
                                  .copyWith(fontSize: 16),
                            ),
                            BlocSelector<OrderController, OrderState, double>(
                              selector: (value) {
                                return value.totalOrder;
                              },
                              builder: (context, totalOrder) {
                                return Text(
                                  totalOrder.currencyPTBR,
                                  style: context.textStyles.textExtraBold
                                      .copyWith(fontSize: 20),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const Divider(color: Colors.grey),
                      const SizedBox(height: 10),
                      OrderField(
                        title: "Endereço de Entrega",
                        controller: addressTEC,
                        validator:
                            Validatorless.required("Endereço obrigatório"),
                        hintText: "Digite um endereço",
                      ),
                      const SizedBox(height: 10),
                      OrderField(
                        title: "CPF",
                        controller: documentTEC,
                        validator: Validatorless.required("CPF obrigatório"),
                        hintText: "Digite o CPF",
                      ),
                      const SizedBox(height: 20),
                      BlocSelector<OrderController, OrderState,
                          List<PaymentTypeModel>>(
                        selector: (state) => state.paymentTypes,
                        builder: (context, paymentTypes) {
                          return ValueListenableBuilder(
                            valueListenable: paymentTypeValid,
                            builder: (_, paymentTypeValidValue, child) {
                              return PaymentTypesField(
                                paymentTypes: paymentTypes,
                                valueChanged: (value) {
                                  paymentTypeId = value;
                                },
                                valid: paymentTypeValidValue,
                                valueSelected: paymentTypeId.toString(),
                              );
                            },
                          );
                        },
                      )
                    ],
                  ),
                ),
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Divider(color: Colors.grey),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: DeliveryButton(
                          width: double.infinity,
                          height: 48,
                          label: "FINALIZAR",
                          onPressed: () {
                            final valid =
                                _formKey.currentState?.validate() ?? false;
                            final paymentTypeSelected = paymentTypeId != null;

                            paymentTypeValid.value = paymentTypeSelected;

                            if (valid && paymentTypeSelected) {
                              controller.saveOrder(
                                address: addressTEC.text,
                                document: documentTEC.text,
                                paymentMethodId: paymentTypeId!,
                              );
                            }
                          },
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showConfirmDeleteProductDialog(OrderConfirmDeleteProductState state) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
              "Deseja excluir o produto ${state.orderProductDTO.productModel.name}"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                controller.cancelDeleteProcess();
              },
              child: Text(
                "Cancelar",
                style: context.textStyles.textBold.copyWith(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                controller.decrementProduct(state.index);
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
