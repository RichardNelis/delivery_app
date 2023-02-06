import 'package:delivery_app/models/product_model.dart';

class OrderProductDTO {
  final ProductModel productModel;
  final int amount;

  OrderProductDTO({required this.productModel, required this.amount});

  double get totalPrice => amount * productModel.price;

  OrderProductDTO copyWith({
    ProductModel? productModel,
    int? amount,
  }) {
    return OrderProductDTO(
      productModel: productModel ?? this.productModel,
      amount: amount ?? this.amount,
    );
  }
}
