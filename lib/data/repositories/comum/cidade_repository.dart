import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:igmp/domain/models/shared/suggestion_select.dart';
import 'package:igmp/shared/config/app_constants.dart';
import 'package:igmp/domain/models/comum/cidade.dart';

class CidadeRepository with ChangeNotifier {
  final dio = Dio();
  final String _token;
  final List<Cidade> _cidades;

  List<Cidade> get items => [..._cidades];

  int get itemsCount {
    return _cidades.length;
  }

  CidadeRepository([
    this._token = '',
    this._cidades = const [],
  ]);

  // Save

  Future<bool> save(
    Map<String, dynamic> data,
  ) async {
    const url = '${AppConstants.apiUrl}/cidades';

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

  Future<List<Cidade>> list(
    String? search,
    int? rowsPerPage,
    int? page,
    List? columnOrder,
  ) async {
    _cidades.clear();
    final Map<String, dynamic> data = {
      'search': search,
      'pageSize': rowsPerPage,
      'page': page,
      'columnOrder': columnOrder,
    };
    final url = '${AppConstants.apiUrl}/cidades/list';

    final response = await dio.post(
      url,
      data: data,
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token'
      }),
    );

    List dataList = response.data['items'];

    List<Cidade> cidadeList = dataList
        .map(
          (e) => Cidade(
            id: e['id'],
            estadoId: e['estadoId'],
            estadoUf: e['estadoUf'],
            nomeCidade: e['nomeCidade'],
          ),
        )
        .toList();

    _cidades.addAll(cidadeList);

    notifyListeners();

    return cidadeList;
  }

  // get

  Future<Cidade> get(String id) async {
    Cidade cidade = Cidade();

    final url = '${AppConstants.apiUrl}/cidades/$id';

    final response = await dio.get(
      url,
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token'
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = response.data;
      cidade.id = data['id'];
      cidade.estadoId = data['estadoId'];
      cidade.estadoUf = data['estadoUf'];
      cidade.codigoIbge = data['codigoIbge'];
      cidade.nomeCidade = data['nomeCidade'];
    }

    return cidade;
  }

  // select

  Future<List<Map<String, String>>> select(
      String search, String estadoId) async {
    final url =
        '${AppConstants.apiUrl}/cidades/select?estadoId=$estadoId&filter=$search';

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

  Future<String> delete(Cidade cidade) async {
    int index = _cidades.indexWhere((p) => p.id == cidade.id);

    if (index >= 0) {
      final cidade = _cidades[index];
      _cidades.remove(cidade);
      notifyListeners();

      final url = '${AppConstants.apiUrl}/cidades/${cidade.id}';

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
        _cidades.insert(index, cidade);
        notifyListeners();

        return response.data['message'];
      }

      return 'Sucesso';
    }

    return 'Item nao encontrado';
  }
}
