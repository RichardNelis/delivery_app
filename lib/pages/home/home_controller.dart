import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:delivery_app/dto/order_product_dto.dart';

import 'package:delivery_app/pages/home/home_state.dart';
import 'package:delivery_app/repositories/products/iproducts_repository%20copy.dart';

class HomeController extends Cubit<HomeState> {
  final IProductRepository _repository;

  HomeController(this._repository) : super(const HomeState.initial());

  Future<void> loadProducts() async {
    try {
      emit(state.copyWith(status: HomeStateStatus.loading));

      await Future.delayed(const Duration(seconds: 3));

      final products = await _repository.findAllProducts();

      emit(state.copyWith(status: HomeStateStatus.loaded, products: products));
    } catch (e, s) {
      log('Erro ao buscar os produtos', error: e, stackTrace: s);
      emit(
        state.copyWith(
          status: HomeStateStatus.error,
          errorMessage: 'Erro ao buscar os produtos',
        ),
      );
    }
  }

  void addOrUpdateBag(OrderProductDTO orderProductDTO) {
    final shoppingBag = [...state.shoppingBag];

    final orderProductIndex = shoppingBag.indexWhere(
        (element) => element.productModel == orderProductDTO.productModel);

    if (orderProductIndex > -1) {
      if (orderProductDTO.amount == 0) {
        shoppingBag.removeAt(orderProductIndex);
      } else {
        shoppingBag[orderProductIndex] = orderProductDTO;
      }
    } else {
      shoppingBag.add(orderProductDTO);
    }

    emit(state.copyWith(shoppingBag: shoppingBag));
  }

  void updateBag(List<OrderProductDTO> updateBag) {
    emit(state.copyWith(shoppingBag: updateBag));
  }
}
