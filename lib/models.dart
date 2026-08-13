import 'package:flutter/material.dart';

enum PackageForm { pump, jar, tube }

class BeautyProduct {
  const BeautyProduct({
    required this.id,
    required this.brand,
    required this.name,
    required this.price,
    required this.match,
    required this.concern,
    required this.category,
    required this.form,
    required this.visualColor,
    required this.imageAsset,
    required this.note,
    required this.ingredients,
    required this.texture,
  });

  final int id;
  final String brand;
  final String name;
  final int price;
  final int match;
  final String concern;
  final String category;
  final PackageForm form;
  final Color visualColor;
  final String imageAsset;
  final String note;
  final List<String> ingredients;
  final String texture;

  String get formattedPrice {
    final value = price.toString();
    return '${value.substring(0, value.length - 3)},${value.substring(value.length - 3)}원';
  }
}

enum IngredientRelation { synergy, caution, neutral }

class IngredientInfo {
  const IngredientInfo({
    required this.name,
    required this.englishName,
    required this.category,
    required this.summary,
    required this.benefits,
    required this.goodWith,
    required this.cautionWith,
  });

  final String name;
  final String englishName;
  final String category;
  final String summary;
  final List<String> benefits;
  final List<String> goodWith;
  final List<String> cautionWith;
}

class RoutineConflict {
  const RoutineConflict(
      {required this.first, required this.second, required this.reason});

  final String first;
  final String second;
  final String reason;
}
