part of 'products_bloc.dart';

class ProductsState {
  List<Products>? prolist=[];

  ProductsState({required this.prolist});
}

class ProductsInitial extends ProductsState {
  ProductsInitial({required super.prolist});

}
