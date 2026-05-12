import 'package:tylunch/model/alergens.dart';
import 'package:tylunch/model/photo.dart';

class ProductModel {
  final int id;
  final int categoryId;
  final List<PhotoModel> photo;
  final String? title;
  final String? description;
  final double price;
  final double? pricewTax;
  final int stock;
  final String dishName;
  final DateTime date;
  final int vege;
  final int calories;
  final String? content;
  final String? ingredients;
  final List<AllergenModel>? allergen;

  const ProductModel({
    required this.id,
    required this.categoryId,
    required this.photo,
    required this.title,
    required this.description,
    required this.price,
    required this.pricewTax,
    required this.stock,
    required this.dishName,
    required this.date,
    required this.vege,
    required this.calories,
    this.content,
    this.ingredients,
    required this.allergen,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final List photo = json['photos'] ?? [];
    final List allergens = json['allergens'] ?? [];

    return ProductModel(
        id: json['id'],
        categoryId: json['category_id'],
        photo: photo.map((e) => PhotoModel.fromJson(e)).toList(),
        title: json['title'],
        description: json['description'],
        price: json['price'].toDouble(),
        pricewTax: json['price_including_tax'] == null
            ? 0.0
            : double.parse(json['price_including_tax'].toString()),
        stock: json['stock'],
        dishName: json['dish_name'],
        date: DateTime.parse(json['date']),
        calories: json['calories'].toInt(),
        vege: json['vegetarian'].toInt(),
        content: json['content'],
        allergen: allergens.map((e) => AllergenModel.fromJson(e)).toList(),
        ingredients: json['ingredients']);
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "category_id": categoryId,
        "photo": photo.map((e) => e.toJson()).toList(),
        "title": title,
        "description": description,
        "price": price.toString(),
        "price_including_tax": pricewTax.toString(),
        "stock": stock,
        "dish_name": dishName,
        "date": date.toString(),
        "ingredients": vege,
        "calories": calories,
        "content": content,
        "allergens": allergen,
        "vegetarian": vege,
      };

  @override
  String toString() => "${toJson()}";
}
