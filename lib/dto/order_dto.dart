import 'package:delivery_app/dto/order_product_dto.dart';

class OrderDTO {
  List<OrderProductDTO> orderProductDTO;
  String address;
  String document;
  int paymentMethodId;

  OrderDTO({
    required this.orderProductDTO,
    required this.address,
    required this.document,
    required this.paymentMethodId,
  });
}
