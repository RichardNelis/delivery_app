import 'package:delivery_app/models/product_model.dart';

abstract class IProductRepository {
  Future<List<ProductModel>> findAllProducts();
}
