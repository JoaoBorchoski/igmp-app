import 'package:flutter/cupertino.dart';

class EspelhoCargaItem {
  String? id;
  String? descricao;
  List<EspelhoCargaItemProduto>? items;

  EspelhoCargaItem({
    this.id,
    this.descricao,
    this.items,
  });

  factory EspelhoCargaItem.fromJson(Map<String, dynamic> json) {
    return EspelhoCargaItem(
      id: json['id'],
      descricao: json['descricao'],
      items: json['items'] != null
          ? (json['items'] as List)
              .map((item) => EspelhoCargaItemProduto.fromJson(item))
              .toList()
          : null,
    );
  }
}

class EspelhoCargaItemProduto {
  String? id;
  String? produto;
  String? produtoNome;
  String? quantidade;

  EspelhoCargaItemProduto({
    this.id,
    this.produto,
    this.produtoNome,
    this.quantidade,
  });

  factory EspelhoCargaItemProduto.fromJson(Map<String, dynamic> json) {
    return EspelhoCargaItemProduto(
      id: json['id'],
      produto: json['produto'],
      produtoNome: json['produto_nome'],
      quantidade: json['quantidade'],
    );
  }
}
