import 'package:flutter/cupertino.dart';
import 'package:igmp/domain/models/operacao/espelho_carga_item.dart';

class EspelhoCarga {
  String? id;
  String? pedidoId;
  String? placa;
  String? motorista;
  String? lote;
  String? descricao;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<EspelhoCargaItem>? espelhoCargaItems;

  EspelhoCarga({
    this.id,
    this.pedidoId,
    this.placa,
    this.motorista,
    this.lote,
    this.descricao,
    this.createdAt,
    this.updatedAt,
    this.espelhoCargaItems,
  });
}

class EspelhoCargaController {
  TextEditingController? id;
  TextEditingController? pedidoId;
  TextEditingController? placa;
  TextEditingController? motorista;
  TextEditingController? lote;
  TextEditingController? descricao;
  DateTime? createdAt;
  DateTime? updatedAt;

  EspelhoCargaController({
    this.id,
    this.pedidoId,
    this.placa,
    this.motorista,
    this.lote,
    this.descricao,
    this.createdAt,
    this.updatedAt,
  });
}
