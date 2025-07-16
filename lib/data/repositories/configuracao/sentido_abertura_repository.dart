import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:igmp/domain/models/shared/suggestion_select.dart';
import 'package:igmp/shared/config/app_constants.dart';
import 'package:igmp/domain/models/configuracao/sentido_abertura.dart';

class SentidoAberturaRepository with ChangeNotifier {
  final dio = Dio();
  final String _token;
  final List<SentidoAbertura> _sentidosAbertura;

  List<SentidoAbertura> get items => [..._sentidosAbertura];

  int get itemsCount {
    return _sentidosAbertura.length;
  }

  SentidoAberturaRepository([
    this._token = '',
    this._sentidosAbertura = const [],
  ]);

  // Save

  Future<bool> save(
    Map<String, dynamic> data,
  ) async {
    const url = '${AppConstants.apiUrl}/sentidos-abertura';

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

  Future<List<SentidoAbertura>> list(
    String? search,
    int? rowsPerPage,
    int? page,
    List? columnOrder,
  ) async {
    _sentidosAbertura.clear();
    final Map<String, dynamic> data = {
      'search': search,
      'pageSize': rowsPerPage,
      'page': page,
      'columnOrder': columnOrder,
    };
    final url = '${AppConstants.apiUrl}/sentidos-abertura/list';

    final response = await dio.post(
      url,
      data: data,
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token'
      }),
    );

    List dataList = response.data['items'];

    List<SentidoAbertura> sentidoAberturaList = dataList
        .map(
          (e) => SentidoAbertura(
            id: e['id'],
            nome: e['nome'],
            descricao: e['descricao'],
          ),
        )
        .toList();

    _sentidosAbertura.addAll(sentidoAberturaList);

    notifyListeners();

    return sentidoAberturaList;
  }

  // get

  Future<SentidoAbertura> get(String id) async {
    SentidoAbertura sentidoAbertura = SentidoAbertura();

    final url = '${AppConstants.apiUrl}/sentidos-abertura/$id';

    final response = await dio.get(
      url,
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token'
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = response.data;
      sentidoAbertura.id = data['id'];
      sentidoAbertura.nome = data['nome'];
      sentidoAbertura.descricao = data['descricao'];
    }

    return sentidoAbertura;
  }

  // select

  Future<List<Map<String, String>>> select(String search) async {
    final url =
        '${AppConstants.apiUrl}/sentidos-abertura/select?filter=$search';

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

  Future<String> delete(SentidoAbertura sentidoAbertura) async {
    int index = _sentidosAbertura.indexWhere((p) => p.id == sentidoAbertura.id);

    if (index >= 0) {
      final sentidoAbertura = _sentidosAbertura[index];
      _sentidosAbertura.remove(sentidoAbertura);
      notifyListeners();

      final url =
          '${AppConstants.apiUrl}/sentidos-abertura/${sentidoAbertura.id}';

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
        _sentidosAbertura.insert(index, sentidoAbertura);
        notifyListeners();

        return response.data['message'];
      }

      return 'Sucesso';
    }

    return 'Item nao encontrado';
  }
}
