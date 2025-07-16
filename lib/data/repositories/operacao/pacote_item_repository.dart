import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:igmp/domain/models/shared/suggestion_select.dart';
import 'package:igmp/shared/config/app_constants.dart';
import 'package:igmp/domain/models/operacao/pacote_item.dart';

class PacoteItemRepository with ChangeNotifier {
  final dio = Dio();
  final String _token;
  final List<PacoteItem> _pacotesItems;

  List<PacoteItem> get items => [..._pacotesItems];

  int get itemsCount {
    return _pacotesItems.length;
  }

  PacoteItemRepository([
    this._token = '',
    this._pacotesItems = const [],
  ]);

  // Save

  Future<bool> save(
    Map<String, dynamic> data,
  ) async {
    const url = '${AppConstants.apiUrl}/pacotes-items';

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

  Future<List<PacoteItem>> list(
    String? search,
    int? rowsPerPage,
    int? page,
    List? columnOrder,
  ) async {
    _pacotesItems.clear();
    final Map<String, dynamic> data = {
      'search': search,
      'pageSize': rowsPerPage,
      'page': page,
      'columnOrder': columnOrder,
    };
    final url = '${AppConstants.apiUrl}/pacotes-items/list';

    final response = await dio.post(
      url,
      data: data,
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token'
      }),
    );

    List dataList = response.data['items'];

    List<PacoteItem> pacoteItemList = dataList
        .map(
          (e) => PacoteItem(
            id: e['id'],
            pacoteId: e['pacoteId'],
          ),
        )
        .toList();

    _pacotesItems.addAll(pacoteItemList);

    notifyListeners();

    return pacoteItemList;
  }

  // get

  Future<PacoteItem> get(String id) async {
    PacoteItem pacoteItem = PacoteItem();

    final url = '${AppConstants.apiUrl}/pacotes-items/$id';

    final response = await dio.get(
      url,
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token'
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = response.data;
      pacoteItem.id = data['id'];
      pacoteItem.pacoteId = data['pacoteId'];
      pacoteItem.pacoteId = data['pacoteId'];
      pacoteItem.produto = data['produto'];
      pacoteItem.quantidade = data['quantidade'];
    }

    return pacoteItem;
  }

  // select

  Future<List<Map<String, String>>> select(String search) async {
    final url = '${AppConstants.apiUrl}/pacotes-items/select?filter=$search';

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

  Future<String> delete(PacoteItem pacoteItem) async {
    int index = _pacotesItems.indexWhere((p) => p.id == pacoteItem.id);

    if (index >= 0) {
      final pacoteItem = _pacotesItems[index];
      _pacotesItems.remove(pacoteItem);
      notifyListeners();

      final url = '${AppConstants.apiUrl}/pacotes-items/${pacoteItem.id}';

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
        _pacotesItems.insert(index, pacoteItem);
        notifyListeners();

        return response.data['message'];
      }

      return 'Sucesso';
    }

    return 'Item nao encontrado';
  }
}
