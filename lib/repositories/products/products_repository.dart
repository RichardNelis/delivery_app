import 'dart:developer';

import 'package:delivery_app/core/exceptions/repository_exption.dart';
import 'package:delivery_app/core/rest_client/custom_dio.dart';
import 'package:delivery_app/models/product_model.dart';
import 'package:dio/dio.dart';

import 'iproducts_repository copy.dart';

class ProductRepository implements IProductRepository {
  final CustomDio dio;

  ProductRepository({required this.dio});

  @override
  Future<List<ProductModel>> findAllProducts() async {
    try {
      final result = await dio.unauth().get('/products');
      return result.data.map<ProductModel>((p) => ProductModel.fromMap(p)).toList();
    } on DioError catch (e, s) {
      log('Error ao buscar productos', error: e, stackTrace: s);
      throw RepositoryException(message: 'Erro ao buscar produtos');
    }
  }
}
