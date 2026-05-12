class CategoriesModel {
  final int menuId;
  final int prodId;
  final int formulaId;
  final int categoryId;

  const CategoriesModel({
    required this.categoryId,
    required this.formulaId,
    required this.menuId,
    required this.prodId,
  });

  factory CategoriesModel.fromJson(Map<String, dynamic> json) {
    return CategoriesModel(
      categoryId: int.parse(json['category_id'].toString()),
      formulaId: int.parse(json['formula_id'].toString()),
      menuId: int.parse(json['menu_id'].toString()),
      prodId: int.parse(json['product_id'].toString()),
    );
  }

  Map<String, dynamic> toJson() => {
        "category_id": categoryId.toString(),
        "formula_id": formulaId.toString(),
        "menu_id": menuId.toString(),
        "product_id": prodId.toString(),
      };

  @override
  String toString() => "${toJson()}";
}
