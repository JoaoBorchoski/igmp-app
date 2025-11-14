import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:igmp/domain/models/operacao/pacote_item.dart';
import 'package:igmp/domain/models/shared/suggestion_select.dart';
import 'package:igmp/shared/config/app_constants.dart';
import 'package:igmp/domain/models/operacao/pacote.dart';
import 'package:igmp/domain/models/operacao/espelho_carga.dart';
import 'package:igmp/domain/models/operacao/espelho_carga_item.dart';

class PacoteRepository with ChangeNotifier {
  final dio = Dio();
  final String _token;
  final List<Pacote> _pacotes;
  final List<EspelhoCarga> _espelhosCarga;

  List<Pacote> get items => [..._pacotes];

  int get itemsCount {
    return _pacotes.length;
  }

  PacoteRepository([
    this._token = '',
    List<Pacote>? pacotes,
    List<EspelhoCarga>? espelhosCarga,
  ])  : _pacotes = pacotes ?? [],
        _espelhosCarga = espelhosCarga ?? [];

  Future<bool> updatePacoteItem(
    String pacoteId,
    String espelhoCargaId,
  ) async {
    try {
      final url =
          '${AppConstants.apiUrl}/pacotes/confirma-carregamento/$pacoteId/$espelhoCargaId';

      final response = await dio.get(
        url,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token'
        }),
      );

      if (response.statusCode == 200) {
        return true;
      }

      return false;
    } catch (e) {
      print('Erro ao atualizar item do pacote: $e');
      return false;
    }
  }

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

  Future<EspelhoCarga> getEspelhoCarga(String id) async {
    EspelhoCarga espelhoCarga = EspelhoCarga();
    final url = '${AppConstants.apiUrl}/espelhos-carga/$id';
    final response = await dio.get(url,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token'
        }));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = response.data;
      espelhoCarga.id = id;
      espelhoCarga.pedidoId = data['pedidoId'];
      espelhoCarga.placa = data['placa'];
      espelhoCarga.motorista = data['motorista'];
      espelhoCarga.lote = data['lote'];
      espelhoCarga.descricao = data['descricao'];
      espelhoCarga.espelhoCargaItems = data['espelhoCargaItems'] != null
          ? (data['espelhoCargaItems'] as List)
              .map((item) => EspelhoCargaItem.fromJson(item))
              .toList()
          : null;
    }

    return espelhoCarga;
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

  // list espelhos carga

  Future<List<EspelhoCarga>> listEspelhosCarga(
    String? search,
    int? rowsPerPage,
    int? page,
    List? columnOrder,
  ) async {
    _espelhosCarga.clear();
    final Map<String, dynamic> data = {
      'search': search,
      'pageSize': rowsPerPage,
      'page': page,
      'columnOrder': columnOrder,
    };
    const url = '${AppConstants.apiUrl}/espelhos-carga/list';

    final response = await dio.post(
      url,
      data: data,
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token'
      }),
    );

    List dataList = response.data['items'];

    List<EspelhoCarga> espelhoCargaList = dataList
        .map(
          (e) => EspelhoCarga(
            id: e['id'],
            pedidoId: e['pedidoId'],
            placa: e['placa'],
            motorista: e['motorista'],
            lote: e['lote'],
            descricao: e['descricao'],
            createdAt:
                e['createdAt'] != null ? DateTime.parse(e['createdAt']) : null,
            updatedAt:
                e['updatedAt'] != null ? DateTime.parse(e['updatedAt']) : null,
          ),
        )
        .toList();

    _espelhosCarga.addAll(espelhoCargaList);

    notifyListeners();

    return espelhoCargaList;
  }
}
