import 'package:delivery_app/dto/order_dto.dart';
import 'package:delivery_app/models/payment_type_model.dart';

abstract class IOrderRepository {
  Future<List<PaymentTypeModel>> getAllPaymentsTypes();
  Future<void> saveOrder(OrderDTO orderDTO);
}
