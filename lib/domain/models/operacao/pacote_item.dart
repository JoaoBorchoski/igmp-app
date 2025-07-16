import 'package:flutter/cupertino.dart';

class PacoteItem {
  String? id;
  String? pacoteId;
  String? produto;
  int? quantidade;

  PacoteItem({
    this.id,
    this.pacoteId,
    this.produto,
    this.quantidade,
  });

  factory PacoteItem.fromJson(Map<String, dynamic> json) {
    return PacoteItem(
      id: json['id'],
      pacoteId: json['pacoteId'],
      produto: json['produto_nome'],
      quantidade: int.tryParse(json['quantidade']?.toString() ?? ''),
    );
  }
}

class PacoteItemController {
  TextEditingController? id;
  TextEditingController? pacoteId;
  TextEditingController? produto;
  TextEditingController? quantidade;

  PacoteItemController({
    this.id,
    this.pacoteId,
    this.produto,
    this.quantidade,
  });
}
