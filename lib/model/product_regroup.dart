import 'package:tylunch/model/remap_formula.dart';
import 'remap_individual.dart';

class ProductRegroupModel {
  final String date;
  final List<RemapFormulaModel>? remapFormula;
  final List<RemapIndividualModel>? remapIndividual;

  const ProductRegroupModel({
    required this.date,
    required this.remapFormula,
    required this.remapIndividual,
  });

  factory ProductRegroupModel.fromJson(Map<String, dynamic> json) {
    final List remapFormula = json['remap_formula'] ?? [];
    final List remapIndividual = json['remap_individual'] ?? [];

    return ProductRegroupModel(
      date: json['date'],
      remapFormula:
          remapFormula.map((e) => RemapFormulaModel.fromJson(e)).toList(),
      remapIndividual:
          remapIndividual.map((e) => RemapIndividualModel.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        "date": date.toString(),
        "remap_formula": remapFormula,
        "remap_individual": remapIndividual,
      };

  @override
  String toString() => "${toJson()}";
}
