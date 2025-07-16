import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:igmp/domain/models/shared/suggestion_select.dart';
import 'package:igmp/shared/config/app_constants.dart';
import 'package:igmp/domain/models/configuracao/fechadura.dart';

class FechaduraRepository with ChangeNotifier {
  final dio = Dio();
  final String _token;
  final List<Fechadura> _fechaduras;

  List<Fechadura> get items => [..._fechaduras];

  int get itemsCount {
    return _fechaduras.length;
  }

  FechaduraRepository([
    this._token = '',
    this._fechaduras = const [],
  ]);

  // Save

  Future<bool> save(
    Map<String, dynamic> data,
  ) async {
    const url = '${AppConstants.apiUrl}/fechaduras';

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

  Future<List<Fechadura>> list(
    String? search,
    int? rowsPerPage,
    int? page,
    List? columnOrder,
  ) async {
    _fechaduras.clear();
    final Map<String, dynamic> data = {
      'search': search,
      'pageSize': rowsPerPage,
      'page': page,
      'columnOrder': columnOrder,
    };
    final url = '${AppConstants.apiUrl}/fechaduras/list';

    final response = await dio.post(
      url,
      data: data,
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token'
      }),
    );

    List dataList = response.data['items'];

    List<Fechadura> fechaduraList = dataList
        .map(
          (e) => Fechadura(
            id: e['id'],
            nome: e['nome'],
            descricao: e['descricao'],
          ),
        )
        .toList();

    _fechaduras.addAll(fechaduraList);

    notifyListeners();

    return fechaduraList;
  }

  // get

  Future<Fechadura> get(String id) async {
    Fechadura fechadura = Fechadura();

    final url = '${AppConstants.apiUrl}/fechaduras/$id';

    final response = await dio.get(
      url,
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token'
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = response.data;
      fechadura.id = data['id'];
      fechadura.nome = data['nome'];
      fechadura.descricao = data['descricao'];
    }

    return fechadura;
  }

  // select

  Future<List<Map<String, String>>> select(String search) async {
    final url = '${AppConstants.apiUrl}/fechaduras/select?filter=$search';

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

  Future<String> delete(Fechadura fechadura) async {
    int index = _fechaduras.indexWhere((p) => p.id == fechadura.id);

    if (index >= 0) {
      final fechadura = _fechaduras[index];
      _fechaduras.remove(fechadura);
      notifyListeners();

      final url = '${AppConstants.apiUrl}/fechaduras/${fechadura.id}';

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
        _fechaduras.insert(index, fechadura);
        notifyListeners();

        return response.data['message'];
      }

      return 'Sucesso';
    }

    return 'Item nao encontrado';
  }
}
