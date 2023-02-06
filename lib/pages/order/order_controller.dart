import 'dart:developer';

import 'package:delivery_app/dto/order_dto.dart';
import 'package:delivery_app/dto/order_product_dto.dart';
import 'package:delivery_app/pages/order/order_state.dart';
import 'package:delivery_app/repositories/order/iorder_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderController extends Cubit<OrderState> {
  final IOrderRepository _orderRepository;

  OrderController(this._orderRepository) : super(const OrderState.initial());

  Future<void> load(List<OrderProductDTO> orderProductDTOs) async {
    try {
      emit(state.copyWith(status: OrderStatus.loading));

      final paymentTypes = await _orderRepository.getAllPaymentsTypes();

      emit(state.copyWith(
        orderProductDTOs: orderProductDTOs,
        status: OrderStatus.loaded,
        paymentTypes: paymentTypes,
      ));
    } catch (e, s) {
      log("Erro ao carregar página", error: e, stackTrace: s);
      emit(state.copyWith(
          status: OrderStatus.error, errorMessage: "Erro ao carregar página"));
    }
  }

  void incrementProduct(int index) {
    final orders = [...state.orderProductDTOs];

    final order = orders[index];

    orders[index] = order.copyWith(amount: order.amount + 1);

    emit(state.copyWith(
      orderProductDTOs: orders,
      status: OrderStatus.updateOrder,
    ));
  }

  void decrementProduct(int index) {
    final orders = [...state.orderProductDTOs];

    final order = orders[index];
    final amount = order.amount;

    if (amount == 1) {
      if (state.status != OrderStatus.confirmRemoveProduct) {
        emit(
          OrderConfirmDeleteProductState(
            orderProductDTO: order,
            index: index,
            status: OrderStatus.confirmRemoveProduct,
            orderProductDTOs: state.orderProductDTOs,
            paymentTypes: state.paymentTypes,
            errorMessage: state.errorMessage,
          ),
        );

        return;
      } else {
        orders.removeAt(index);
      }
    } else {
      orders[index] = order.copyWith(amount: order.amount - 1);
    }

    if (orders.isEmpty) {
      emit(state.copyWith(status: OrderStatus.emptyBag));
      return;
    }

    emit(state.copyWith(
      orderProductDTOs: orders,
      status: OrderStatus.updateOrder,
    ));
  }

  void cancelDeleteProcess() {
    emit(state.copyWith(status: OrderStatus.loaded));
  }

  void emptyBag() {
    emit(state.copyWith(status: OrderStatus.emptyBag));
  }

  Future<void> saveOrder({
    required String address,
    required String document,
    required int paymentMethodId,
  }) async {
    try {
      emit(state.copyWith(status: OrderStatus.loading));

      await _orderRepository.saveOrder(
        OrderDTO(
          orderProductDTO: state.orderProductDTOs,
          address: address,
          document: document,
          paymentMethodId: paymentMethodId,
        ),
      );

      emit(state.copyWith(status: OrderStatus.success));
    } catch (e, s) {
      log("Erro ao realizar pedido", error: e, stackTrace: s);
      emit(state.copyWith(status: OrderStatus.error));
    }
  }
}
