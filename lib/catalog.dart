import 'package:flutter/material.dart';

import 'models.dart';

const concerns = <String>['피부 장벽', '보습', '민감·진정', '트러블', '모공', '탄력'];

const ingredients = <IngredientInfo>[
  IngredientInfo(
    name: '세라마이드',
    englishName: 'CERAMIDE',
    category: '장벽',
    summary: '피부 지질과 유사한 구조로 장벽 사이를 채우고 수분 손실을 줄여요.',
    benefits: ['장벽 강화', '수분 유지', '민감 완화'],
    goodWith: ['콜레스테롤', '지방산', '판테놀'],
    cautionWith: [],
  ),
  IngredientInfo(
    name: '판테놀',
    englishName: 'PANTHENOL',
    category: '진정',
    summary: '피부를 편안하게 진정시키고 촉촉한 보호막 형성을 도와요.',
    benefits: ['진정', '보습', '장벽 보조'],
    goodWith: ['세라마이드', '병풀 추출물', '나이아신아마이드'],
    cautionWith: [],
  ),
  IngredientInfo(
    name: '레티날',
    englishName: 'RETINAL',
    category: '탄력',
    summary: '비타민 A 계열 성분으로 피부 결, 탄력, 흔적 케어에 도움을 줘요.',
    benefits: ['탄력', '피부 결', '흔적 관리'],
    goodWith: ['세라마이드', '판테놀', '스쿠알란'],
    cautionWith: ['BHA', '비타민 C'],
  ),
  IngredientInfo(
    name: '비타민 C',
    englishName: 'VITAMIN C',
    category: '브라이트닝',
    summary: '칙칙함을 줄이고 외부 환경으로 인한 산화 스트레스를 관리해요.',
    benefits: ['광채', '잡티 관리', '항산화'],
    goodWith: ['비타민 E', '자외선 차단제', '페룰릭애씨드'],
    cautionWith: ['레티날', 'BHA'],
  ),
  IngredientInfo(
    name: 'BHA',
    englishName: 'SALICYLIC ACID',
    category: '트러블',
    summary: '지용성 각질 케어 성분으로 모공 속 피지와 묵은 각질을 정돈해요.',
    benefits: ['모공', '피지', '트러블'],
    goodWith: ['나이아신아마이드', '판테놀', '세라마이드'],
    cautionWith: ['레티날', '비타민 C'],
  ),
  IngredientInfo(
    name: '나이아신아마이드',
    englishName: 'NIACINAMIDE',
    category: '멀티 케어',
    summary: '피지, 장벽, 피부 톤을 폭넓게 관리하는 활용도 높은 성분이에요.',
    benefits: ['피지 균형', '장벽', '피부 톤'],
    goodWith: ['BHA', '판테놀', '세라마이드'],
    cautionWith: [],
  ),
];

const routineConflicts = <RoutineConflict>[
  RoutineConflict(
      first: '레티날', second: 'BHA', reason: '같은 루틴에서 사용하면 건조함과 자극 가능성이 높아져요.'),
  RoutineConflict(
      first: '레티날',
      second: '비타민 C',
      reason: '민감한 피부라면 아침과 저녁으로 나눠 사용하는 편이 안전해요.'),
  RoutineConflict(
      first: 'BHA',
      second: '비타민 C',
      reason: '고함량 제품을 함께 쓰면 따가움이 생길 수 있어 교차 사용을 권해요.'),
];

const products = <BeautyProduct>[
  BeautyProduct(
    id: 1,
    brand: 'LABORATOIRE 17',
    name: '세라마이드 배리어 세럼',
    price: 38000,
    match: 96,
    concern: '피부 장벽',
    category: '세럼',
    form: PackageForm.pump,
    visualColor: Color(0xFFBED9CF),
    imageAsset: 'assets/products/modern-barrier-serum-v1.png',
    note: '건조하고 예민해진 피부 장벽을 위한 저자극 세럼',
    ingredients: ['세라마이드 NP', '콜레스테롤', '지방산'],
    texture: '산뜻한 밀키 세럼',
  ),
  BeautyProduct(
    id: 2,
    brand: 'DERMA FORMULA',
    name: '바이옴 리커버리 크림',
    price: 42000,
    match: 92,
    concern: '보습',
    category: '크림',
    form: PackageForm.jar,
    visualColor: Color(0xFFD9D3C3),
    imageAsset: 'assets/products/modern-recovery-cream-v1.png',
    note: '오래 지속되는 보습과 편안한 마무리',
    ingredients: ['스쿠알란', '판테놀', '비피다 발효물'],
    texture: '쫀쫀한 영양 크림',
  ),
  BeautyProduct(
    id: 3,
    brand: 'PHYTOLAB',
    name: '카밍 CICA 플루이드',
    price: 29000,
    match: 89,
    concern: '민감·진정',
    category: '에센스',
    form: PackageForm.tube,
    visualColor: Color(0xFFB7CED1),
    imageAsset: 'assets/products/modern-hydrating-toner-v1.png',
    note: '열감과 붉은기를 산뜻하게 잠재우는 수분 플루이드',
    ingredients: ['병풀 추출물', '마데카소사이드', '알란토인'],
    texture: '가벼운 젤 플루이드',
  ),
  BeautyProduct(
    id: 4,
    brand: 'CLEAR STANDARD',
    name: 'BHA 클리어 토너',
    price: 26000,
    match: 87,
    concern: '트러블',
    category: '토너',
    form: PackageForm.pump,
    visualColor: Color(0xFFC7D9DE),
    imageAsset: 'assets/products/modern-hydrating-toner-v1.png',
    note: '답답한 모공과 과도한 피지를 부드럽게 정돈하는 데일리 토너',
    ingredients: ['BHA', '나이아신아마이드', '판테놀'],
    texture: '물처럼 가벼운 토너',
  ),
  BeautyProduct(
    id: 5,
    brand: 'NIGHT OBJECT',
    name: '레티날 리뉴 나이트 세럼',
    price: 49000,
    match: 85,
    concern: '탄력',
    category: '세럼',
    form: PackageForm.tube,
    visualColor: Color(0xFFD8CEC5),
    imageAsset: 'assets/products/modern-retinal-serum-v1.png',
    note: '매끈한 피부 결과 탄력을 위한 저녁 집중 세럼',
    ingredients: ['레티날', '스쿠알란', '세라마이드'],
    texture: '부드러운 크림 세럼',
  ),
  BeautyProduct(
    id: 6,
    brand: 'LUMEN LAB',
    name: '비타민 C 글로우 앰플',
    price: 36000,
    match: 83,
    concern: '모공',
    category: '앰플',
    form: PackageForm.pump,
    visualColor: Color(0xFFE5D9A8),
    imageAsset: 'assets/products/modern-vitamin-c-v1.png',
    note: '칙칙한 피부에 맑은 광채와 탄탄한 인상을 더하는 항산화 앰플',
    ingredients: ['비타민 C', '비타민 E', '페룰릭애씨드'],
    texture: '산뜻한 워터 앰플',
  ),
];

IngredientInfo? ingredientByName(String name) {
  for (final ingredient in ingredients) {
    if (ingredient.name == name) {
      return ingredient;
    }
  }
  return null;
}

RoutineConflict? findRoutineConflict(Iterable<BeautyProduct> selectedProducts) {
  final names =
      selectedProducts.expand((product) => product.ingredients).toSet();
  for (final conflict in routineConflicts) {
    if (names.contains(conflict.first) && names.contains(conflict.second)) {
      return conflict;
    }
  }
  return null;
}
