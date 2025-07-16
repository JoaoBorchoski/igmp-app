import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:igmp/domain/models/shared/suggestion_select.dart';
import 'package:igmp/shared/config/app_constants.dart';
import 'package:igmp/domain/models/comum/estado.dart';

class EstadoRepository with ChangeNotifier {
  final dio = Dio();
  final String _token;
  final List<Estado> _estados;

  List<Estado> get items => [..._estados];

  int get itemsCount {
    return _estados.length;
  }

  EstadoRepository([
    this._token = '',
    this._estados = const [],
  ]);

  // Save

  Future<bool> save(
    Map<String, dynamic> data,
  ) async {
    const url = '${AppConstants.apiUrl}/estados';

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

  Future<List<Estado>> list(
    String? search,
    int? rowsPerPage,
    int? page,
    List? columnOrder,
  ) async {
    _estados.clear();
    final Map<String, dynamic> data = {
      'search': search,
      'pageSize': rowsPerPage,
      'page': page,
      'columnOrder': columnOrder,
    };
    final url = '${AppConstants.apiUrl}/estados/list';

    final response = await dio.post(
      url,
      data: data,
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token'
      }),
    );

    List dataList = response.data['items'];

    List<Estado> estadoList = dataList
        .map(
          (e) => Estado(
            id: e['id'],
            uf: e['uf'],
            nomeEstado: e['nomeEstado'],
          ),
        )
        .toList();

    _estados.addAll(estadoList);

    notifyListeners();

    return estadoList;
  }

  // get

  Future<Estado> get(String id) async {
    Estado estado = Estado();

    final url = '${AppConstants.apiUrl}/estados/$id';

    final response = await dio.get(
      url,
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token'
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = response.data;
      estado.id = data['id'];
      estado.codigoIbge = data['codigoIbge'];
      estado.uf = data['uf'];
      estado.nomeEstado = data['nomeEstado'];
    }

    return estado;
  }

  // select

  Future<List<Map<String, String>>> select(String search) async {
    final url = '${AppConstants.apiUrl}/estados/select?filter=$search';

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

  Future<String> delete(Estado estado) async {
    int index = _estados.indexWhere((p) => p.id == estado.id);

    if (index >= 0) {
      final estado = _estados[index];
      _estados.remove(estado);
      notifyListeners();

      final url = '${AppConstants.apiUrl}/estados/${estado.id}';

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
        _estados.insert(index, estado);
        notifyListeners();

        return response.data['message'];
      }

      return 'Sucesso';
    }

    return 'Item nao encontrado';
  }
}
