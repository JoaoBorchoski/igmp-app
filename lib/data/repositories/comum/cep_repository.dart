import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:igmp/domain/models/shared/suggestion_select.dart';
import 'package:igmp/shared/config/app_constants.dart';
import 'package:igmp/domain/models/comum/cep.dart';

class CepRepository with ChangeNotifier {
  final dio = Dio();
  final String _token;
  final List<Cep> _ceps;

  List<Cep> get items => [..._ceps];

  int get itemsCount {
    return _ceps.length;
  }

  CepRepository([
    this._token = '',
    this._ceps = const [],
  ]);

  // Save

  Future<bool> save(
    Map<String, dynamic> data,
  ) async {
    const url = '${AppConstants.apiUrl}/ceps';

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

  Future<List<Cep>> list(
    String? search,
    int? rowsPerPage,
    int? page,
    List? columnOrder,
  ) async {
    _ceps.clear();
    final Map<String, dynamic> data = {
      'search': search,
      'pageSize': rowsPerPage,
      'page': page,
      'columnOrder': columnOrder,
    };
    final url = '${AppConstants.apiUrl}/ceps/list';

    final response = await dio.post(
      url,
      data: data,
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token'
      }),
    );

    List dataList = response.data['items'];

    List<Cep> cepList = dataList
        .map(
          (e) => Cep(
            id: e['id'],
            codigoCep: e['codigoCep'],
            logradouro: e['logradouro'],
            bairro: e['bairro'],
          ),
        )
        .toList();

    _ceps.addAll(cepList);

    notifyListeners();

    return cepList;
  }

  // get

  Future<Cep> get(String id) async {
    Cep cep = Cep();

    final url = '${AppConstants.apiUrl}/ceps/$id';

    final response = await dio.get(
      url,
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token'
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = response.data;
      cep.id = data['id'];
      cep.codigoCep = data['codigoCep'];
      cep.logradouro = data['logradouro'];
      cep.bairro = data['bairro'];
      cep.estadoId = data['estadoId'];
      cep.estadoUf = data['estadoUf'];
      cep.cidadeId = data['cidadeId'];
      cep.cidadeNomeCidade = data['cidadeNomeCidade'];
    }

    return cep;
  }

  // select

  Future<List<Map<String, String>>> select(String search) async {
    final url = '${AppConstants.apiUrl}/ceps/select?filter=$search';

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

  Future<String> delete(Cep cep) async {
    int index = _ceps.indexWhere((p) => p.id == cep.id);

    if (index >= 0) {
      final cep = _ceps[index];
      _ceps.remove(cep);
      notifyListeners();

      final url = '${AppConstants.apiUrl}/ceps/${cep.id}';

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
        _ceps.insert(index, cep);
        notifyListeners();

        return response.data['message'];
      }

      return 'Sucesso';
    }

    return 'Item nao encontrado';
  }
}
