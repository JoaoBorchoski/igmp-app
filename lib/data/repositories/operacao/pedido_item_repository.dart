import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:igmp/domain/models/shared/suggestion_select.dart';
import 'package:igmp/shared/config/app_constants.dart';
import 'package:igmp/domain/models/operacao/pedido_item.dart';

class PedidoItemRepository with ChangeNotifier {
  final dio = Dio();
  final String _token;
  final List<PedidoItem> _pedidosItems;

  List<PedidoItem> get items => [..._pedidosItems];

  int get itemsCount {
    return _pedidosItems.length;
  }

  PedidoItemRepository([
    this._token = '',
    this._pedidosItems = const [],
  ]);

  // Save

  Future<bool> save(
    Map<String, dynamic> data,
  ) async {
    const url = '${AppConstants.apiUrl}/pedidos-items';

    if (data['id'] == '') {
      final response = await dio.post(
        url,
        data: data,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token'
        }),
      );

      if (response.statusCode == 200) {
        return true;
      }

      return false;
    }

    final response = await dio.put(
      '$url/${data['id']!}',
      data: data,
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token'
      }),
    );

    if (response.statusCode == 200) {
      return true;
    }

    return false;
  }

  // list

  Future<List<PedidoItem>> list(
    String? search,
    int? rowsPerPage,
    int? page,
    List? columnOrder,
  ) async {
    _pedidosItems.clear();
    final Map<String, dynamic> data = {
      'search': search,
      'pageSize': rowsPerPage,
      'page': page,
      'columnOrder': columnOrder,
    };
    final url = '${AppConstants.apiUrl}/pedidos-items/list';

    final response = await dio.post(
      url,
      data: data,
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token'
      }),
    );

    List dataList = response.data['items'];

    List<PedidoItem> pedidoItemList = dataList
        .map(
          (e) => PedidoItem(
            id: e['id'],
            pedidoId: e['pedidoId'],
            pedidoSequencial: e['pedidoSequencial'],
            corEtiqueta: e['corEtiqueta'],
          ),
        )
        .toList();

    _pedidosItems.addAll(pedidoItemList);

    notifyListeners();

    return pedidoItemList;
  }

  // get

  Future<PedidoItem> get(String id) async {
    PedidoItem pedidoItem = PedidoItem();

    final url = '${AppConstants.apiUrl}/pedidos-items/$id';

    final response = await dio.get(
      url,
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token'
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = response.data;
      pedidoItem.id = data['id'];
      pedidoItem.pedidoId = data['pedidoId'];
      pedidoItem.pedidoSequencial = data['pedidoSequencial'];
      pedidoItem.produto = data['produto'];
      pedidoItem.quantidade = data['quantidade'];
      pedidoItem.corEtiqueta = data['corEtiqueta'];
    }

    return pedidoItem;
  }

  // select

  Future<List<Map<String, String>>> select(String search) async {
    final url = '${AppConstants.apiUrl}/pedidos-items/select?filter=$search';

    final response = await dio.get(
      url,
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token'
      }),
    );

    List<SuggestionModelSelect> suggestions = [];
    if (response.statusCode == 200) {
      Map<String, dynamic> data = response.data;
      suggestions = List<SuggestionModelSelect>.from(
        data['items'].map((model) => SuggestionModelSelect.fromJson(model)),
      );
    }

    return Future.value(
      suggestions.map((e) => {'value': e.value, 'label': e.label}).toList(),
    );
  }

  // delete

  Future<String> delete(PedidoItem pedidoItem) async {
    int index = _pedidosItems.indexWhere((p) => p.id == pedidoItem.id);

    if (index >= 0) {
      final pedidoItem = _pedidosItems[index];
      _pedidosItems.remove(pedidoItem);
      notifyListeners();

      final url = '${AppConstants.apiUrl}/pedidos-items/${pedidoItem.id}';

      final response = await dio.delete(
        url,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token'
        }),
      );

      if (response.statusCode == null) {
        return 'Erro desconhecido!';
      }

      if (response.statusCode! >= 400) {
        _pedidosItems.insert(index, pedidoItem);
        notifyListeners();

        return response.data['message'];
      }

      return 'Sucesso';
    }

    return 'Item nao encontrado';
  }
}
