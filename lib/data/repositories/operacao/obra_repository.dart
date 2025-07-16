import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:igmp/domain/models/shared/suggestion_select.dart';
import 'package:igmp/shared/config/app_constants.dart';
import 'package:igmp/domain/models/operacao/obra.dart';

class ObraRepository with ChangeNotifier {
  final dio = Dio();
  final String _token;
  final List<Obra> _obras;

  List<Obra> get items => [..._obras];

  int get itemsCount {
    return _obras.length;
  }

  ObraRepository([
    this._token = '',
    this._obras = const [],
  ]);

  // Save

  Future<bool> save(
    Map<String, dynamic> data,
  ) async {
    const url = '${AppConstants.apiUrl}/obras';

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

  Future<List<Obra>> list(
    String? search,
    int? rowsPerPage,
    int? page,
    List? columnOrder,
  ) async {
    _obras.clear();
    final Map<String, dynamic> data = {
      'search': search,
      'pageSize': rowsPerPage,
      'page': page,
      'columnOrder': columnOrder,
    };
    final url = '${AppConstants.apiUrl}/obras/list';

    final response = await dio.post(
      url,
      data: data,
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token'
      }),
    );

    List dataList = response.data['items'];

    List<Obra> obraList = dataList
        .map(
          (e) => Obra(
            id: e['id'],
            nome: e['nome'],
            cnpj: e['cnpj'],
            endereco: e['endereco'],
            responsavelObra: e['responsavelObra'],
            contato: e['contato'],
            tipoObra: e['tipoObra'],
          ),
        )
        .toList();

    _obras.addAll(obraList);

    notifyListeners();

    return obraList;
  }

  // get

  Future<Obra> get(String id) async {
    Obra obra = Obra();

    final url = '${AppConstants.apiUrl}/obras/$id';

    final response = await dio.get(
      url,
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token'
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = response.data;
      obra.id = data['id'];
      obra.nome = data['nome'];
      obra.cnpj = data['cnpj'];
      obra.endereco = data['endereco'];
      obra.responsavelObra = data['responsavelObra'];
      obra.contato = data['contato'];
      obra.previsaoEntrega = data['previsaoEntrega'];
      obra.tipoObra = data['tipoObra'];
      obra.plantasIguais = data['plantasIguais'];
      obra.qtdCasas = data['qtdCasas'];
      obra.grupoCasas = data['grupoCasas'];
      obra.estruturaPredio = data['estruturaPredio'];
      obra.qtdAptoPorAndar = data['qtdAptoPorAndar'];
      obra.andares = data['andares'];
      obra.qtdAptos = data['qtdAptos'];
      obra.grupoAndares = data['grupoAndares'];
      obra.padraoCorId = data['padraoCorId'];
      obra.padraoCorNome = data['padraoCorNome'];
      obra.solidaMadeirada = data['solidaMadeirada'];
      obra.coresTiposId = data['coresTiposId'];
      obra.Descricao = data['Descricao'];
    }

    return obra;
  }

  // select

  Future<List<Map<String, String>>> select(String search) async {
    final url = '${AppConstants.apiUrl}/obras/select?filter=$search';

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

  Future<String> delete(Obra obra) async {
    int index = _obras.indexWhere((p) => p.id == obra.id);

    if (index >= 0) {
      final obra = _obras[index];
      _obras.remove(obra);
      notifyListeners();

      final url = '${AppConstants.apiUrl}/obras/${obra.id}';

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
        _obras.insert(index, obra);
        notifyListeners();

        return response.data['message'];
      }

      return 'Sucesso';
    }

    return 'Item nao encontrado';
  }
}
