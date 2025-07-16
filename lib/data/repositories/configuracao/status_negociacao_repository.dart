import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:igmp/domain/models/shared/suggestion_select.dart';
import 'package:igmp/shared/config/app_constants.dart';
import 'package:igmp/domain/models/configuracao/status_negociacao.dart';

class StatusNegociacaoRepository with ChangeNotifier {
  final dio = Dio();
  final String _token;
  final List<StatusNegociacao> _statusNegociacoes;

  List<StatusNegociacao> get items => [..._statusNegociacoes];

  int get itemsCount {
    return _statusNegociacoes.length;
  }

  StatusNegociacaoRepository([
    this._token = '',
    this._statusNegociacoes = const [],
  ]);

  // Save

  Future<bool> save(
    Map<String, dynamic> data,
  ) async {
    const url = '${AppConstants.apiUrl}/status-negociacoes';

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

  Future<List<StatusNegociacao>> list(
    String? search,
    int? rowsPerPage,
    int? page,
    List? columnOrder,
  ) async {
    _statusNegociacoes.clear();
    final Map<String, dynamic> data = {
      'search': search,
      'pageSize': rowsPerPage,
      'page': page,
      'columnOrder': columnOrder,
    };
    final url = '${AppConstants.apiUrl}/status-negociacoes/list';

    final response = await dio.post(
      url,
      data: data,
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token'
      }),
    );

    List dataList = response.data['items'];

    List<StatusNegociacao> statusNegociacaoList = dataList
        .map(
          (e) => StatusNegociacao(
            id: e['id'],
            nome: e['nome'],
            descricao: e['descricao'],
          ),
        )
        .toList();

    _statusNegociacoes.addAll(statusNegociacaoList);

    notifyListeners();

    return statusNegociacaoList;
  }

  // get

  Future<StatusNegociacao> get(String id) async {
    StatusNegociacao statusNegociacao = StatusNegociacao();

    final url = '${AppConstants.apiUrl}/status-negociacoes/$id';

    final response = await dio.get(
      url,
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token'
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = response.data;
      statusNegociacao.id = data['id'];
      statusNegociacao.nome = data['nome'];
      statusNegociacao.descricao = data['descricao'];
    }

    return statusNegociacao;
  }

  // select

  Future<List<Map<String, String>>> select(String search) async {
    final url =
        '${AppConstants.apiUrl}/status-negociacoes/select?filter=$search';

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

  Future<String> delete(StatusNegociacao statusNegociacao) async {
    int index =
        _statusNegociacoes.indexWhere((p) => p.id == statusNegociacao.id);

    if (index >= 0) {
      final statusNegociacao = _statusNegociacoes[index];
      _statusNegociacoes.remove(statusNegociacao);
      notifyListeners();

      final url =
          '${AppConstants.apiUrl}/status-negociacoes/${statusNegociacao.id}';

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
        _statusNegociacoes.insert(index, statusNegociacao);
        notifyListeners();

        return response.data['message'];
      }

      return 'Sucesso';
    }

    return 'Item nao encontrado';
  }
}
