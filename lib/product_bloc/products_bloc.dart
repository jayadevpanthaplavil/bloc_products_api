import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import '../Products.dart';
import '../ProductsJson.dart';

part 'products_event.dart';

part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  ProductsBloc() : super(ProductsInitial(prolist: [])) {
    on<FetchEvent>((event, emit) async {
        final response =
            await http.get(Uri.parse("https://dummyjson.com/products"));
        if (response.statusCode == 200) {
          var jsonString = json.decode(response.body.toString());
          var data = ProductsJson.fromJson(jsonString);
          var listProducts = data.products;
           emit(ProductsState(prolist: listProducts));
        } else {
          throw Exception("Failed to load");
        }

    });
  }
}
