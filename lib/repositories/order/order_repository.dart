import 'dart:developer';

import 'package:delivery_app/core/exceptions/repository_exption.dart';
import 'package:delivery_app/core/rest_client/custom_dio.dart';
import 'package:delivery_app/dto/order_dto.dart';
import 'package:delivery_app/models/payment_type_model.dart';
import 'package:delivery_app/repositories/order/iorder_repository.dart';
import 'package:dio/dio.dart';

class OrderRepository implements IOrderRepository {
  final CustomDio dio;

  OrderRepository({
    required this.dio,
  });

  @override
  Future<List<PaymentTypeModel>> getAllPaymentsTypes() async {
    try {
      final result = await dio.auth().get('/payment-types');

      return result.data
          .map<PaymentTypeModel>((p) => PaymentTypeModel.fromMap(p))
          .toList();
    } on DioError catch (e, s) {
      log("Erro ao buscar formas de pagamento", error: e, stackTrace: s);
      throw RepositoryException(message: "Erro ao buscar formas de pagamentos");
    }
  }

  @override
  Future<void> saveOrder(OrderDTO orderDTO) async {
    try {
      await dio.auth().post(
        "/orders",
        data: {
          "products:": orderDTO.orderProductDTO
              .map((e) => {
                    "id": e.productModel.id,
                    "amount": e.amount,
                    "total_price": e.totalPrice
                  })
              .toList(),
          "user_id": "#userAuthRef",
          "address": orderDTO.address,
          "cpf": orderDTO.document,
          "payment_method_id": orderDTO.paymentMethodId,
        },
      );
    } on DioError catch (e, s) {
      log("Erro ao registrar pedido", error: e, stackTrace: s);
      throw RepositoryException(message: "Erro ao registrar pedido");
    }
  }
}
