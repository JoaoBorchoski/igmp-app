import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:igmp/domain/models/shared/suggestion_select.dart';
import 'package:igmp/shared/config/app_constants.dart';
import 'package:igmp/domain/models/configuracao/cliente.dart';

class ClienteRepository with ChangeNotifier {
  final dio = Dio();
  final String _token;
  final List<Cliente> _clientes;

  List<Cliente> get items => [..._clientes];

  int get itemsCount {
    return _clientes.length;
  }

  ClienteRepository([
    this._token = '',
    this._clientes = const [],
  ]);

  // Save

  Future<bool> save(
    Map<String, dynamic> data,
  ) async {
    const url = '${AppConstants.apiUrl}/clientes';

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

  Future<List<Cliente>> list(
    String? search,
    int? rowsPerPage,
    int? page,
    List? columnOrder,
  ) async {
    _clientes.clear();
    final Map<String, dynamic> data = {
      'search': search,
      'pageSize': rowsPerPage,
      'page': page,
      'columnOrder': columnOrder,
    };
    final url = '${AppConstants.apiUrl}/clientes/list';

    final response = await dio.post(
      url,
      data: data,
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token'
      }),
    );

    List dataList = response.data['items'];

    List<Cliente> clienteList = dataList
        .map(
          (e) => Cliente(
            id: e['id'],
            nome: e['nome'],
            cpf: e['cpf'],
            email: e['email'],
          ),
        )
        .toList();

    _clientes.addAll(clienteList);

    notifyListeners();

    return clienteList;
  }

  // get

  Future<Cliente> get(String id) async {
    Cliente cliente = Cliente();

    final url = '${AppConstants.apiUrl}/clientes/$id';

    final response = await dio.get(
      url,
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token'
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = response.data;
      cliente.id = data['id'];
      cliente.nome = data['nome'];
      cliente.cpf = data['cpf'];
      cliente.rg = data['rg'];
      cliente.email = data['email'];
      cliente.cep = data['cep'];
      cliente.paisId = data['paisId'];
      cliente.paisNomePais = data['paisNomePais'];
      cliente.estadoId = data['estadoId'];
      cliente.estadoUf = data['estadoUf'];
      cliente.cidadeId = data['cidadeId'];
      cliente.cidadeNomeCidade = data['cidadeNomeCidade'];
      cliente.bairro = data['bairro'];
      cliente.endereco = data['endereco'];
      cliente.numero = data['numero'];
      cliente.complemento = data['complemento'];
      cliente.telefone = data['telefone'];
      cliente.observacoes = data['observacoes'];
      cliente.desabilitado = data['desabilitado'];
    }

    return cliente;
  }

  // select

  Future<List<Map<String, String>>> select(String search) async {
    final url = '${AppConstants.apiUrl}/clientes/select?filter=$search';

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

  Future<String> delete(Cliente cliente) async {
    int index = _clientes.indexWhere((p) => p.id == cliente.id);

    if (index >= 0) {
      final cliente = _clientes[index];
      _clientes.remove(cliente);
      notifyListeners();

      final url = '${AppConstants.apiUrl}/clientes/${cliente.id}';

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
        _clientes.insert(index, cliente);
        notifyListeners();

        return response.data['message'];
      }

      return 'Sucesso';
    }

    return 'Item nao encontrado';
  }
}
