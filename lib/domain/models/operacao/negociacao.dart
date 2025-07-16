import 'package:flutter/cupertino.dart';

class Negociacao {
  String? id;
  String? medicaoId;
  String? medicaoObraId;
  String? clienteId;
  String? clienteNome;
  String? statusNegociacaoId;
  String? statusNegociacaoDescricao;
  String? funcionarioId;
  String? funcionarioNome;
  DateTime? dataCriacao;
  DateTime? dataFechamento;
  double? valorEstimado;
  String? descricao;
  String? motivoPerda;

  Negociacao({
    this.id,
    this.medicaoId,
    this.medicaoObraId,
    this.clienteId,
    this.clienteNome,
    this.statusNegociacaoId,
    this.statusNegociacaoDescricao,
    this.funcionarioId,
    this.funcionarioNome,
    this.dataCriacao,
    this.dataFechamento,
    this.valorEstimado,
    this.descricao,
    this.motivoPerda,
  });
}

class NegociacaoController {
  TextEditingController? id;
  TextEditingController? medicaoId;
  TextEditingController? medicaoObraId;
  TextEditingController? clienteId;
  TextEditingController? clienteNome;
  TextEditingController? statusNegociacaoId;
  TextEditingController? statusNegociacaoDescricao;
  TextEditingController? funcionarioId;
  TextEditingController? funcionarioNome;
  TextEditingController? dataCriacao;
  TextEditingController? dataFechamento;
  TextEditingController? valorEstimado;
  TextEditingController? descricao;
  TextEditingController? motivoPerda;

  NegociacaoController({
    this.id,
    this.medicaoId,
    this.medicaoObraId,
    this.clienteId,
    this.clienteNome,
    this.statusNegociacaoId,
    this.statusNegociacaoDescricao,
    this.funcionarioId,
    this.funcionarioNome,
    this.dataCriacao,
    this.dataFechamento,
    this.valorEstimado,
    this.descricao,
    this.motivoPerda,
  });
}
