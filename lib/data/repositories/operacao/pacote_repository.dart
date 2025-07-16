import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:igmp/domain/models/operacao/pacote_item.dart';
import 'package:igmp/domain/models/shared/suggestion_select.dart';
import 'package:igmp/shared/config/app_constants.dart';
import 'package:igmp/domain/models/operacao/pacote.dart';

class PacoteRepository with ChangeNotifier {
  final dio = Dio();
  final String _token;
  final List<Pacote> _pacotes;

  List<Pacote> get items => [..._pacotes];

  int get itemsCount {
    return _pacotes.length;
  }

  PacoteRepository([
    this._token = '',
    this._pacotes = const [],
  ]);

  // Save

  Future<bool> save(
    Map<String, dynamic> data,
  ) async {
    const url = '${AppConstants.apiUrl}/pacotes';

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

  Future<List<Pacote>> list(
    String? search,
    int? rowsPerPage,
    int? page,
    List? columnOrder,
  ) async {
    _pacotes.clear();
    final Map<String, dynamic> data = {
      'search': search,
      'pageSize': rowsPerPage,
      'page': page,
      'columnOrder': columnOrder,
    };
    const url = '${AppConstants.apiUrl}/pacotes/list';

    final response = await dio.post(
      url,
      data: data,
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token'
      }),
    );

    List dataList = response.data['items'];

    List<Pacote> pacoteList = dataList
        .map(
          (e) => Pacote(
            id: e['id'],
            pedidoId: e['pedidoId'],
            pedidoSequencial: e['pedidoSequencial'],
            descricao: e['descricao'],
            sequencial: e['sequencial'],
          ),
        )
        .toList();

    _pacotes.addAll(pacoteList);

    notifyListeners();

    return pacoteList;
  }

  // get

  Future<Pacote> get(String id) async {
    Pacote pacote = Pacote();

    final url = '${AppConstants.apiUrl}/pacotes/$id';

    final response = await dio.get(
      url,
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token'
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = response.data;
      pacote.id = data['id'];
      pacote.pedidoId = data['pedidoId'];
      pacote.pedidoSequencial = data['pedidoSequencial'];
      pacote.descricao = data['descricao'];
      pacote.pedidoLabel = data['pedidoLabel'];
      pacote.items = (data['items'] as List)
          .map((item) => PacoteItem.fromJson(item))
          .toList();
    }

    return pacote;
  }

  // select

  Future<List<Map<String, String>>> select(String search) async {
    final url = '${AppConstants.apiUrl}/pacotes/select?filter=$search';

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

  Future<String> delete(Pacote pacote) async {
    int index = _pacotes.indexWhere((p) => p.id == pacote.id);

    if (index >= 0) {
      final pacote = _pacotes[index];
      _pacotes.remove(pacote);
      notifyListeners();

      final url = '${AppConstants.apiUrl}/pacotes/${pacote.id}';

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
        _pacotes.insert(index, pacote);
        notifyListeners();

        return response.data['message'];
      }

      return 'Sucesso';
    }

    return 'Item nao encontrado';
  }
}
