import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:igmp/domain/models/shared/suggestion_select.dart';
import 'package:igmp/shared/config/app_constants.dart';
import 'package:igmp/domain/models/configuracao/altura_vaos.dart';

class AlturaVaosRepository with ChangeNotifier {
  final dio = Dio();
  final String _token;
  final List<AlturaVaos> _alturasVaos;

  List<AlturaVaos> get items => [..._alturasVaos];

  int get itemsCount {
    return _alturasVaos.length;
  }

  AlturaVaosRepository([
    this._token = '',
    this._alturasVaos = const [],
  ]);

  // Save

  Future<bool> save(
    Map<String, dynamic> data,
  ) async {
    const url = '${AppConstants.apiUrl}/alturas-vaos';

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

  Future<List<AlturaVaos>> list(
    String? search,
    int? rowsPerPage,
    int? page,
    List? columnOrder,
  ) async {
    _alturasVaos.clear();
    final Map<String, dynamic> data = {
      'search': search,
      'pageSize': rowsPerPage,
      'page': page,
      'columnOrder': columnOrder,
    };
    final url = '${AppConstants.apiUrl}/alturas-vaos/list';

    final response = await dio.post(
      url,
      data: data,
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token'
      }),
    );

    List dataList = response.data['items'];

    List<AlturaVaos> alturaVaosList = dataList
        .map(
          (e) => AlturaVaos(
            id: e['id'],
            nome: e['nome'],
            descricao: e['descricao'],
          ),
        )
        .toList();

    _alturasVaos.addAll(alturaVaosList);

    notifyListeners();

    return alturaVaosList;
  }

  // get

  Future<AlturaVaos> get(String id) async {
    AlturaVaos alturaVaos = AlturaVaos();

    final url = '${AppConstants.apiUrl}/alturas-vaos/$id';

    final response = await dio.get(
      url,
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token'
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = response.data;
      alturaVaos.id = data['id'];
      alturaVaos.nome = data['nome'];
      alturaVaos.descricao = data['descricao'];
    }

    return alturaVaos;
  }

  // select

  Future<List<Map<String, String>>> select(String search) async {
    final url = '${AppConstants.apiUrl}/alturas-vaos/select?filter=$search';

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

  Future<String> delete(AlturaVaos alturaVaos) async {
    int index = _alturasVaos.indexWhere((p) => p.id == alturaVaos.id);

    if (index >= 0) {
      final alturaVaos = _alturasVaos[index];
      _alturasVaos.remove(alturaVaos);
      notifyListeners();

      final url = '${AppConstants.apiUrl}/alturas-vaos/${alturaVaos.id}';

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
        _alturasVaos.insert(index, alturaVaos);
        notifyListeners();

        return response.data['message'];
      }

      return 'Sucesso';
    }

    return 'Item nao encontrado';
  }
}
