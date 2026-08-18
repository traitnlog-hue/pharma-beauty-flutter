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

class SkinProfile {
  const SkinProfile({
    required this.skinType,
    required this.concerns,
    required this.sensitivity,
    required this.triggerHistory,
    required this.duration,
  });

  const SkinProfile.empty()
      : skinType = '',
        concerns = const [],
        sensitivity = '',
        triggerHistory = '',
        duration = '';

  final String skinType;
  final List<String> concerns;
  final String sensitivity;
  final String triggerHistory;
  final String duration;

  bool get isComplete =>
      skinType.isNotEmpty &&
      concerns.isNotEmpty &&
      sensitivity.isNotEmpty &&
      triggerHistory.isNotEmpty &&
      duration.isNotEmpty;

  String get primaryConcern => concerns.isEmpty ? '피부 장벽' : concerns.first;

  String get profileName => switch (primaryConcern) {
        '보습' => '수분 충전형',
        '민감·진정' => '진정 보호형',
        '트러블' => '트러블 밸런스형',
        '모공' => '모공 정돈형',
        '탄력' => '탄력 케어형',
        _ => '장벽 회복형',
      };

  String get recommendedIngredients {
    final avoidsExfoliants = triggerHistory.contains('레티노이드');
    return switch (primaryConcern) {
      '보습' => '판테놀 · 스쿠알란',
      '민감·진정' => '병풀 추출물 · 판테놀',
      '트러블' when avoidsExfoliants => '판테놀 · 나이아신아마이드',
      '트러블' => 'BHA · 나이아신아마이드',
      '모공' when avoidsExfoliants => '나이아신아마이드 · 판테놀',
      '모공' => '나이아신아마이드 · BHA',
      '탄력' => '저함량 레티날 · 세라마이드',
      _ => '세라마이드 · 판테놀',
    };
  }

  String get careNote {
    if (sensitivity == '매우 예민함') {
      return '활성 성분보다 장벽 보습을 먼저, 새 제품은 한 번에 하나씩 권해요.';
    }
    if (duration == '한 달 이상' || duration == '반복적으로 발생') {
      return '오래 지속되거나 반복되는 불편은 피부과 전문의와 확인해 보세요.';
    }
    return '현재 차트에서는 자극을 줄인 기본 루틴부터 시작하는 편이 좋아요.';
  }
}

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
