import 'package:flutter/src/material/data_table.dart';
import 'package:granth_flutter/utils/model_keys.dart';

class ChallengeModel {
  int id;
  String? paginas;
  String? tipo;
  String? observacoes;
  String? faixaEtaria;

  ChallengeModel({
    required this.id,
    this.paginas,
    this.tipo,
    this.observacoes,
    this.faixaEtaria,
  });

  factory ChallengeModel.fromJson(Map<String, dynamic> json) {
    return ChallengeModel(
      id: json[ChallengeKeys.id],
      paginas: json[ChallengeKeys.pages],
      tipo: json[ChallengeKeys.tipo],
      observacoes: json[ChallengeKeys.obs],
      faixaEtaria: json[ChallengeKeys.faixa_etaria],
    );
  }
}
