import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:igmp/domain/models/shared/suggestion_select.dart';
import 'package:igmp/shared/config/app_constants.dart';
import 'package:igmp/domain/models/configuracao/largura_vaos.dart';

class LarguraVaosRepository with ChangeNotifier {
  final dio = Dio();
  final String _token;
  final List<LarguraVaos> _largurasVaos;

  List<LarguraVaos> get items => [..._largurasVaos];

  int get itemsCount {
    return _largurasVaos.length;
  }

  LarguraVaosRepository([
    this._token = '',
    this._largurasVaos = const [],
  ]);

  // Save

  Future<bool> save(
    Map<String, dynamic> data,
  ) async {
    const url = '${AppConstants.apiUrl}/larguras-vaos';

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

  Future<List<LarguraVaos>> list(
    String? search,
    int? rowsPerPage,
    int? page,
    List? columnOrder,
  ) async {
    _largurasVaos.clear();
    final Map<String, dynamic> data = {
      'search': search,
      'pageSize': rowsPerPage,
      'page': page,
      'columnOrder': columnOrder,
    };
    final url = '${AppConstants.apiUrl}/larguras-vaos/list';

    final response = await dio.post(
      url,
      data: data,
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token'
      }),
    );

    List dataList = response.data['items'];

    List<LarguraVaos> larguraVaosList = dataList
        .map(
          (e) => LarguraVaos(
            id: e['id'],
            nome: e['nome'],
            descricao: e['descricao'],
          ),
        )
        .toList();

    _largurasVaos.addAll(larguraVaosList);

    notifyListeners();

    return larguraVaosList;
  }

  // get

  Future<LarguraVaos> get(String id) async {
    LarguraVaos larguraVaos = LarguraVaos();

    final url = '${AppConstants.apiUrl}/larguras-vaos/$id';

    final response = await dio.get(
      url,
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token'
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = response.data;
      larguraVaos.id = data['id'];
      larguraVaos.nome = data['nome'];
      larguraVaos.descricao = data['descricao'];
    }

    return larguraVaos;
  }

  // select

  Future<List<Map<String, String>>> select(String search) async {
    final url = '${AppConstants.apiUrl}/larguras-vaos/select?filter=$search';

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

  Future<String> delete(LarguraVaos larguraVaos) async {
    int index = _largurasVaos.indexWhere((p) => p.id == larguraVaos.id);

    if (index >= 0) {
      final larguraVaos = _largurasVaos[index];
      _largurasVaos.remove(larguraVaos);
      notifyListeners();

      final url = '${AppConstants.apiUrl}/larguras-vaos/${larguraVaos.id}';

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
        _largurasVaos.insert(index, larguraVaos);
        notifyListeners();

        return response.data['message'];
      }

      return 'Sucesso';
    }

    return 'Item nao encontrado';
  }
}
