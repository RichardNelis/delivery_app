import 'package:equatable/equatable.dart';
import 'package:match/match.dart';

import 'package:delivery_app/dto/order_product_dto.dart';
import 'package:delivery_app/models/payment_type_model.dart';

part 'order_state.g.dart';

@match
enum OrderStatus {
  initial,
  loaded,
  loading,
  error,
  success,
  updateOrder,
  confirmRemoveProduct,
  emptyBag,
}

class OrderState extends Equatable {
  final OrderStatus status;
  final List<OrderProductDTO> orderProductDTOs;
  final List<PaymentTypeModel> paymentTypes;
  final String? errorMessage;

  const OrderState({
    required this.status,
    required this.orderProductDTOs,
    required this.paymentTypes,
    this.errorMessage,
  });

  const OrderState.initial()
      : status = OrderStatus.initial,
        orderProductDTOs = const [],
        paymentTypes = const [],
        errorMessage = null;

  @override
  List<Object?> get props =>
      [status, orderProductDTOs, paymentTypes, errorMessage];

  OrderState copyWith({
    OrderStatus? status,
    List<OrderProductDTO>? orderProductDTOs,
    List<PaymentTypeModel>? paymentTypes,
    String? errorMessage,
  }) {
    return OrderState(
      status: status ?? this.status,
      orderProductDTOs: orderProductDTOs ?? this.orderProductDTOs,
      paymentTypes: paymentTypes ?? this.paymentTypes,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  double get totalOrder => orderProductDTOs.fold(
      0.0, (previousValue, element) => previousValue + element.totalPrice);
}

class OrderConfirmDeleteProductState extends OrderState {
  final OrderProductDTO orderProductDTO;
  final int index;

  const OrderConfirmDeleteProductState({
    required this.orderProductDTO,
    required this.index,
    required super.status,
    required super.orderProductDTOs,
    required super.paymentTypes,
    super.errorMessage,
  });
}
