import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:igmp/domain/models/shared/suggestion_select.dart';
import 'package:igmp/shared/config/app_constants.dart';
import 'package:igmp/domain/models/operacao/pedido.dart';

class PedidoRepository with ChangeNotifier {
  final dio = Dio();
  final String _token;
  final List<Pedido> _pedidos;

  List<Pedido> get items => [..._pedidos];

  int get itemsCount {
    return _pedidos.length;
  }

  PedidoRepository([
    this._token = '',
    this._pedidos = const [],
  ]);

  // Save

  Future<bool> save(
    Map<String, dynamic> data,
  ) async {
    const url = '${AppConstants.apiUrl}/pedidos';

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

  Future<List<Pedido>> list(
    String? search,
    int? rowsPerPage,
    int? page,
    List? columnOrder,
  ) async {
    _pedidos.clear();
    final Map<String, dynamic> data = {
      'search': search,
      'pageSize': rowsPerPage,
      'page': page,
      'columnOrder': columnOrder,
    };
    final url = '${AppConstants.apiUrl}/pedidos/list';

    final response = await dio.post(
      url,
      data: data,
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token'
      }),
    );

    List dataList = response.data['items'];

    List<Pedido> pedidoList = dataList
        .map(
          (e) => Pedido(
            id: e['id'],
            cliente: e['cliente'],
            estadoId: e['estadoId'],
            estadoUf: e['estadoUf'],
          ),
        )
        .toList();

    _pedidos.addAll(pedidoList);

    notifyListeners();

    return pedidoList;
  }

  // get

  Future<Pedido> get(String id) async {
    Pedido pedido = Pedido();

    final url = '${AppConstants.apiUrl}/pedidos/$id';

    final response = await dio.get(
      url,
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token'
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = response.data;
      pedido.id = data['id'];
      pedido.sequencial = data['sequencial'];
      pedido.cliente = data['cliente'];
      pedido.telefone = data['telefone'];
      pedido.cep = data['cep'];
      pedido.endereco = data['endereco'];
      pedido.numero = data['numero'];
      pedido.complemento = data['complemento'];
      pedido.bairro = data['bairro'];
      pedido.estadoId = data['estadoId'];
      pedido.estadoUf = data['estadoUf'];
      pedido.cidadeId = data['cidadeId'];
      pedido.cidadeNome = data['cidadeNome'];
      pedido.status = data['status'];
    }

    return pedido;
  }

  // select

  Future<List<Map<String, String>>> select(String search) async {
    final url = '${AppConstants.apiUrl}/pedidos/select?filter=$search';

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

  Future<String> delete(Pedido pedido) async {
    int index = _pedidos.indexWhere((p) => p.id == pedido.id);

    if (index >= 0) {
      final pedido = _pedidos[index];
      _pedidos.remove(pedido);
      notifyListeners();

      final url = '${AppConstants.apiUrl}/pedidos/${pedido.id}';

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
        _pedidos.insert(index, pedido);
        notifyListeners();

        return response.data['message'];
      }

      return 'Sucesso';
    }

    return 'Item nao encontrado';
  }
}
