import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:igmp/domain/models/shared/suggestion_select.dart';
import 'package:igmp/shared/config/app_constants.dart';
import 'package:igmp/domain/models/configuracao/funcionario.dart';

class FuncionarioRepository with ChangeNotifier {
  final dio = Dio();
  final String _token;
  final List<Funcionario> _funcionarios;

  List<Funcionario> get items => [..._funcionarios];

  int get itemsCount {
    return _funcionarios.length;
  }

  FuncionarioRepository([
    this._token = '',
    this._funcionarios = const [],
  ]);

  // Save

  Future<bool> save(
    Map<String, dynamic> data,
  ) async {
    const url = '${AppConstants.apiUrl}/funcionarios';

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

  Future<List<Funcionario>> list(
    String? search,
    int? rowsPerPage,
    int? page,
    List? columnOrder,
  ) async {
    _funcionarios.clear();
    final Map<String, dynamic> data = {
      'search': search,
      'pageSize': rowsPerPage,
      'page': page,
      'columnOrder': columnOrder,
    };
    final url = '${AppConstants.apiUrl}/funcionarios/list';

    final response = await dio.post(
      url,
      data: data,
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token'
      }),
    );

    List dataList = response.data['items'];

    List<Funcionario> funcionarioList = dataList
        .map(
          (e) => Funcionario(
            id: e['id'],
            nome: e['nome'],
            cpf: e['cpf'],
            email: e['email'],
          ),
        )
        .toList();

    _funcionarios.addAll(funcionarioList);

    notifyListeners();

    return funcionarioList;
  }

  // get

  Future<Funcionario> get(String id) async {
    Funcionario funcionario = Funcionario();

    final url = '${AppConstants.apiUrl}/funcionarios/$id';

    final response = await dio.get(
      url,
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token'
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = response.data;
      funcionario.id = data['id'];
      funcionario.nome = data['nome'];
      funcionario.cpf = data['cpf'];
      funcionario.rg = data['rg'];
      funcionario.email = data['email'];
      funcionario.cep = data['cep'];
      funcionario.paisId = data['paisId'];
      funcionario.paisNomePais = data['paisNomePais'];
      funcionario.estadoId = data['estadoId'];
      funcionario.estadoUf = data['estadoUf'];
      funcionario.cidadeId = data['cidadeId'];
      funcionario.cidadeNomeCidade = data['cidadeNomeCidade'];
      funcionario.bairro = data['bairro'];
      funcionario.endereco = data['endereco'];
      funcionario.numero = data['numero'];
      funcionario.complemento = data['complemento'];
      funcionario.telefone = data['telefone'];
      funcionario.observacoes = data['observacoes'];
      funcionario.desabilitado = data['desabilitado'];
    }

    return funcionario;
  }

  // select

  Future<List<Map<String, String>>> select(String search) async {
    final url = '${AppConstants.apiUrl}/funcionarios/select?filter=$search';

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

  Future<String> delete(Funcionario funcionario) async {
    int index = _funcionarios.indexWhere((p) => p.id == funcionario.id);

    if (index >= 0) {
      final funcionario = _funcionarios[index];
      _funcionarios.remove(funcionario);
      notifyListeners();

      final url = '${AppConstants.apiUrl}/funcionarios/${funcionario.id}';

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
        _funcionarios.insert(index, funcionario);
        notifyListeners();

        return response.data['message'];
      }

      return 'Sucesso';
    }

    return 'Item nao encontrado';
  }
}
