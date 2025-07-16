import 'package:flutter/cupertino.dart';

class Medicao {
  String? id;
  String? obraId;
  String? nome;
  String? complemento;
  String? espessuraParede;
  String? larguraVaosId;
  String? larguraVaosMedida;
  String? alturaVaosId;
  String? alturaVaosMedida;
  String? tipoEnchimentoId;
  String? tipoEnchimentoDescricao;
  String? tipoPortaId;
  String? tipoPortaDescricao;
  bool? confirmacao;
  String? complementoOrigemId;
  String? descricao;
  String? sentidoAberturaId;
  String? sentidoAberturaDescricao;
  String? alizarId;
  String? alizarDescricao;
  String? fechaduraId;
  String? fechaduraDescricao;

  Medicao({
    this.id,
    this.obraId,
    this.nome,
    this.complemento,
    this.espessuraParede,
    this.larguraVaosId,
    this.larguraVaosMedida,
    this.alturaVaosId,
    this.alturaVaosMedida,
    this.tipoEnchimentoId,
    this.tipoEnchimentoDescricao,
    this.tipoPortaId,
    this.tipoPortaDescricao,
    this.confirmacao,
    this.complementoOrigemId,
    this.descricao,
    this.sentidoAberturaId,
    this.sentidoAberturaDescricao,
    this.alizarId,
    this.alizarDescricao,
    this.fechaduraId,
    this.fechaduraDescricao,
  });
}

class MedicaoController {
  TextEditingController? id;
  TextEditingController? obraId;
  TextEditingController? nome;
  TextEditingController? complemento;
  TextEditingController? espessuraParede;
  TextEditingController? larguraVaosId;
  TextEditingController? larguraVaosMedida;
  TextEditingController? alturaVaosId;
  TextEditingController? alturaVaosMedida;
  TextEditingController? tipoEnchimentoId;
  TextEditingController? tipoEnchimentoDescricao;
  TextEditingController? tipoPortaId;
  TextEditingController? tipoPortaDescricao;
  bool? confirmacao;
  TextEditingController? complementoOrigemId;
  TextEditingController? descricao;
  TextEditingController? sentidoAberturaId;
  TextEditingController? sentidoAberturaDescricao;
  TextEditingController? alizarId;
  TextEditingController? alizarDescricao;
  TextEditingController? fechaduraId;
  TextEditingController? fechaduraDescricao;

  MedicaoController({
    this.id,
    this.obraId,
    this.nome,
    this.complemento,
    this.espessuraParede,
    this.larguraVaosId,
    this.larguraVaosMedida,
    this.alturaVaosId,
    this.alturaVaosMedida,
    this.tipoEnchimentoId,
    this.tipoEnchimentoDescricao,
    this.tipoPortaId,
    this.tipoPortaDescricao,
    this.confirmacao,
    this.complementoOrigemId,
    this.descricao,
    this.sentidoAberturaId,
    this.sentidoAberturaDescricao,
    this.alizarId,
    this.alizarDescricao,
    this.fechaduraId,
    this.fechaduraDescricao,
  });
}
