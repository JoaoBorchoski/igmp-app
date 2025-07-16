import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:igmp/domain/models/shared/suggestion_select.dart';
import 'package:igmp/shared/config/app_constants.dart';
import 'package:igmp/domain/models/configuracao/tipo_enchimento.dart';

class TipoEnchimentoRepository with ChangeNotifier {
  final dio = Dio();
  final String _token;
  final List<TipoEnchimento> _tiposEnchimento;

  List<TipoEnchimento> get items => [..._tiposEnchimento];

  int get itemsCount {
    return _tiposEnchimento.length;
  }

  TipoEnchimentoRepository([
    this._token = '',
    this._tiposEnchimento = const [],
  ]);

  // Save

  Future<bool> save(
    Map<String, dynamic> data,
  ) async {
    const url = '${AppConstants.apiUrl}/tipos-enchimento';

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

  Future<List<TipoEnchimento>> list(
    String? search,
    int? rowsPerPage,
    int? page,
    List? columnOrder,
  ) async {
    _tiposEnchimento.clear();
    final Map<String, dynamic> data = {
      'search': search,
      'pageSize': rowsPerPage,
      'page': page,
      'columnOrder': columnOrder,
    };
    final url = '${AppConstants.apiUrl}/tipos-enchimento/list';

    final response = await dio.post(
      url,
      data: data,
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token'
      }),
    );

    List dataList = response.data['items'];

    List<TipoEnchimento> tipoEnchimentoList = dataList
        .map(
          (e) => TipoEnchimento(
            id: e['id'],
            nome: e['nome'],
            descricao: e['descricao'],
          ),
        )
        .toList();

    _tiposEnchimento.addAll(tipoEnchimentoList);

    notifyListeners();

    return tipoEnchimentoList;
  }

  // get

  Future<TipoEnchimento> get(String id) async {
    TipoEnchimento tipoEnchimento = TipoEnchimento();

    final url = '${AppConstants.apiUrl}/tipos-enchimento/$id';

    final response = await dio.get(
      url,
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token'
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = response.data;
      tipoEnchimento.id = data['id'];
      tipoEnchimento.nome = data['nome'];
      tipoEnchimento.descricao = data['descricao'];
    }

    return tipoEnchimento;
  }

  // select

  Future<List<Map<String, String>>> select(String search) async {
    final url = '${AppConstants.apiUrl}/tipos-enchimento/select?filter=$search';

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

  Future<String> delete(TipoEnchimento tipoEnchimento) async {
    int index = _tiposEnchimento.indexWhere((p) => p.id == tipoEnchimento.id);

    if (index >= 0) {
      final tipoEnchimento = _tiposEnchimento[index];
      _tiposEnchimento.remove(tipoEnchimento);
      notifyListeners();

      final url =
          '${AppConstants.apiUrl}/tipos-enchimento/${tipoEnchimento.id}';

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
        _tiposEnchimento.insert(index, tipoEnchimento);
        notifyListeners();

        return response.data['message'];
      }

      return 'Sucesso';
    }

    return 'Item nao encontrado';
  }
}
