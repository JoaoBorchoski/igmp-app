import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:igmp/domain/models/shared/suggestion_select.dart';
import 'package:igmp/shared/config/app_constants.dart';
import 'package:igmp/domain/models/operacao/negociacao.dart';

class NegociacaoRepository with ChangeNotifier {
  final dio = Dio();
  final String _token;
  final List<Negociacao> _negociacoes;

  List<Negociacao> get items => [..._negociacoes];

  int get itemsCount {
    return _negociacoes.length;
  }

  NegociacaoRepository([
    this._token = '',
    this._negociacoes = const [],
  ]);

  // Save

  Future<bool> save(
    Map<String, dynamic> data,
  ) async {
    const url = '${AppConstants.apiUrl}/negociacoes';

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

  Future<List<Negociacao>> list(
    String? search,
    int? rowsPerPage,
    int? page,
    List? columnOrder,
  ) async {
    _negociacoes.clear();
    final Map<String, dynamic> data = {
      'search': search,
      'pageSize': rowsPerPage,
      'page': page,
      'columnOrder': columnOrder,
    };
    final url = '${AppConstants.apiUrl}/negociacoes/list';

    final response = await dio.post(
      url,
      data: data,
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token'
      }),
    );

    List dataList = response.data['items'];

    List<Negociacao> negociacaoList = dataList
        .map(
          (e) => Negociacao(
            id: e['id'],
          ),
        )
        .toList();

    _negociacoes.addAll(negociacaoList);

    notifyListeners();

    return negociacaoList;
  }

  // get

  Future<Negociacao> get(String id) async {
    Negociacao negociacao = Negociacao();

    final url = '${AppConstants.apiUrl}/negociacoes/$id';

    final response = await dio.get(
      url,
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token'
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = response.data;
      negociacao.id = data['id'];
      negociacao.medicaoId = data['medicaoId'];
      negociacao.medicaoObraId = data['medicaoObraId'];
      negociacao.clienteId = data['clienteId'];
      negociacao.clienteNome = data['clienteNome'];
      negociacao.statusNegociacaoId = data['statusNegociacaoId'];
      negociacao.statusNegociacaoDescricao = data['statusNegociacaoDescricao'];
      negociacao.funcionarioId = data['funcionarioId'];
      negociacao.funcionarioNome = data['funcionarioNome'];
      negociacao.dataCriacao = data['dataCriacao'];
      negociacao.dataFechamento = data['dataFechamento'];
      negociacao.valorEstimado = data['valorEstimado'];
      negociacao.descricao = data['descricao'];
      negociacao.motivoPerda = data['motivoPerda'];
    }

    return negociacao;
  }

  // select

  Future<List<Map<String, String>>> select(String search) async {
    final url = '${AppConstants.apiUrl}/negociacoes/select?filter=$search';

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

  Future<String> delete(Negociacao negociacao) async {
    int index = _negociacoes.indexWhere((p) => p.id == negociacao.id);

    if (index >= 0) {
      final negociacao = _negociacoes[index];
      _negociacoes.remove(negociacao);
      notifyListeners();

      final url = '${AppConstants.apiUrl}/negociacoes/${negociacao.id}';

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
        _negociacoes.insert(index, negociacao);
        notifyListeners();

        return response.data['message'];
      }

      return 'Sucesso';
    }

    return 'Item nao encontrado';
  }
}
