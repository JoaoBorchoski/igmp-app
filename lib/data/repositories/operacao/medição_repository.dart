import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:igmp/domain/models/operacao/medi%C3%A7%C3%A3o.dart';
import 'package:igmp/domain/models/shared/suggestion_select.dart';
import 'package:igmp/shared/config/app_constants.dart';

class MedicaoRepository with ChangeNotifier {
  final dio = Dio();
  final String _token;
  final List<Medicao> _medicoes;

  List<Medicao> get items => [..._medicoes];

  int get itemsCount {
    return _medicoes.length;
  }

  MedicaoRepository([
    this._token = '',
    this._medicoes = const [],
  ]);

  // Save

  Future<bool> save(
    Map<String, dynamic> data,
  ) async {
    const url = '${AppConstants.apiUrl}/medicoes';

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

  Future<List<Medicao>> list(
    String? search,
    int? rowsPerPage,
    int? page,
    List? columnOrder,
  ) async {
    _medicoes.clear();
    final Map<String, dynamic> data = {
      'search': search,
      'pageSize': rowsPerPage,
      'page': page,
      'columnOrder': columnOrder,
    };
    final url = '${AppConstants.apiUrl}/medicoes/list';

    final response = await dio.post(
      url,
      data: data,
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token'
      }),
    );

    List dataList = response.data['items'];

    List<Medicao> medicaoList = dataList
        .map(
          (e) => Medicao(
            id: e['id'],
          ),
        )
        .toList();

    _medicoes.addAll(medicaoList);

    notifyListeners();

    return medicaoList;
  }

  // get

  Future<Medicao> get(String id) async {
    Medicao medicao = Medicao();

    final url = '${AppConstants.apiUrl}/medicoes/$id';

    final response = await dio.get(
      url,
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token'
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = response.data;
      medicao.id = data['id'];
      medicao.obraId = data['obraId'];
      medicao.nome = data['nome'];
      medicao.complemento = data['complemento'];
      medicao.espessuraParede = data['espessuraParede'];
      medicao.larguraVaosId = data['larguraVaosId'];
      medicao.larguraVaosMedida = data['larguraVaosMedida'];
      medicao.alturaVaosId = data['alturaVaosId'];
      medicao.alturaVaosMedida = data['alturaVaosMedida'];
      medicao.tipoEnchimentoId = data['tipoEnchimentoId'];
      medicao.tipoEnchimentoDescricao = data['tipoEnchimentoDescricao'];
      medicao.tipoPortaId = data['tipoPortaId'];
      medicao.tipoPortaDescricao = data['tipoPortaDescricao'];
      medicao.confirmacao = data['confirmacao'];
      medicao.complementoOrigemId = data['complementoOrigemId'];
      medicao.descricao = data['descricao'];
      medicao.sentidoAberturaId = data['sentidoAberturaId'];
      medicao.sentidoAberturaDescricao = data['sentidoAberturaDescricao'];
      medicao.alizarId = data['alizarId'];
      medicao.alizarDescricao = data['alizarDescricao'];
      medicao.fechaduraId = data['fechaduraId'];
      medicao.fechaduraDescricao = data['fechaduraDescricao'];
    }

    return medicao;
  }

  // select

  Future<List<Map<String, String>>> select(String search) async {
    final url = '${AppConstants.apiUrl}/medicoes/select?filter=$search';

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

  Future<String> delete(Medicao medicao) async {
    int index = _medicoes.indexWhere((p) => p.id == medicao.id);

    if (index >= 0) {
      final medicao = _medicoes[index];
      _medicoes.remove(medicao);
      notifyListeners();

      final url = '${AppConstants.apiUrl}/medicoes/${medicao.id}';

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
        _medicoes.insert(index, medicao);
        notifyListeners();

        return response.data['message'];
      }

      return 'Sucesso';
    }

    return 'Item nao encontrado';
  }
}
