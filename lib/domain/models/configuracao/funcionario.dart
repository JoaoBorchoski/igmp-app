import 'package:flutter/cupertino.dart';

class Funcionario {
  String? id;
  String? nome;
  String? cpf;
  String? rg;
  String? email;
  String? cep;
  String? paisId;
  String? paisNomePais;
  String? estadoId;
  String? estadoUf;
  String? cidadeId;
  String? cidadeNomeCidade;
  String? bairro;
  String? endereco;
  int? numero;
  String? complemento;
  String? telefone;
  String? observacoes;
  String? usuarioId;
  bool? desabilitado;

  Funcionario({
    this.id,
    this.nome,
    this.cpf,
    this.rg,
    this.email,
    this.cep,
    this.paisId,
    this.paisNomePais,
    this.estadoId,
    this.estadoUf,
    this.cidadeId,
    this.cidadeNomeCidade,
    this.bairro,
    this.endereco,
    this.numero,
    this.complemento,
    this.telefone,
    this.observacoes,
    this.usuarioId,
    this.desabilitado,
  });
}

class FuncionarioController {
  TextEditingController? id;
  TextEditingController? nome;
  TextEditingController? cpf;
  TextEditingController? rg;
  TextEditingController? email;
  TextEditingController? cep;
  TextEditingController? paisId;
  TextEditingController? paisNomePais;
  TextEditingController? estadoId;
  TextEditingController? estadoUf;
  TextEditingController? cidadeId;
  TextEditingController? cidadeNomeCidade;
  TextEditingController? bairro;
  TextEditingController? endereco;
  TextEditingController? numero;
  TextEditingController? complemento;
  TextEditingController? telefone;
  TextEditingController? observacoes;
  TextEditingController? usuarioId;
  bool? desabilitado;

  FuncionarioController({
    this.id,
    this.nome,
    this.cpf,
    this.rg,
    this.email,
    this.cep,
    this.paisId,
    this.paisNomePais,
    this.estadoId,
    this.estadoUf,
    this.cidadeId,
    this.cidadeNomeCidade,
    this.bairro,
    this.endereco,
    this.numero,
    this.complemento,
    this.telefone,
    this.observacoes,
    this.usuarioId,
    this.desabilitado,
  });
}
