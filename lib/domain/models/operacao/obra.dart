import 'package:flutter/cupertino.dart';

class Obra {
  String? id;
  String? nome;
  String? cnpj;
  String? endereco;
  String? responsavelObra;
  String? contato;
  DateTime? previsaoEntrega;
  String? tipoObra;
  bool? plantasIguais;
  int? qtdCasas;
  String? grupoCasas;
  String? estruturaPredio;
  int? qtdAptoPorAndar;
  int? andares;
  int? qtdAptos;
  String? grupoAndares;
  String? padraoCorId;
  String? padraoCorNome;
  String? solidaMadeirada;
  String? coresTiposId;
  String? Descricao;

  Obra({
    this.id,
    this.nome,
    this.cnpj,
    this.endereco,
    this.responsavelObra,
    this.contato,
    this.previsaoEntrega,
    this.tipoObra,
    this.plantasIguais,
    this.qtdCasas,
    this.grupoCasas,
    this.estruturaPredio,
    this.qtdAptoPorAndar,
    this.andares,
    this.qtdAptos,
    this.grupoAndares,
    this.padraoCorId,
    this.padraoCorNome,
    this.solidaMadeirada,
    this.coresTiposId,
    this.Descricao,
  });
}

class ObraController {
  TextEditingController? id;
  TextEditingController? nome;
  TextEditingController? cnpj;
  TextEditingController? endereco;
  TextEditingController? responsavelObra;
  TextEditingController? contato;
  TextEditingController? previsaoEntrega;
  TextEditingController? tipoObra;
  bool? plantasIguais;
  TextEditingController? qtdCasas;
  TextEditingController? grupoCasas;
  TextEditingController? estruturaPredio;
  TextEditingController? qtdAptoPorAndar;
  TextEditingController? andares;
  TextEditingController? qtdAptos;
  TextEditingController? grupoAndares;
  TextEditingController? padraoCorId;
  TextEditingController? padraoCorNome;
  TextEditingController? solidaMadeirada;
  TextEditingController? coresTiposId;
  TextEditingController? Descricao;

  ObraController({
    this.id,
    this.nome,
    this.cnpj,
    this.endereco,
    this.responsavelObra,
    this.contato,
    this.previsaoEntrega,
    this.tipoObra,
    this.plantasIguais,
    this.qtdCasas,
    this.grupoCasas,
    this.estruturaPredio,
    this.qtdAptoPorAndar,
    this.andares,
    this.qtdAptos,
    this.grupoAndares,
    this.padraoCorId,
    this.padraoCorNome,
    this.solidaMadeirada,
    this.coresTiposId,
    this.Descricao,
  });
}
