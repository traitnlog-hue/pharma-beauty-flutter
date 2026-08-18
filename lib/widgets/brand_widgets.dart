import 'package:flutter/material.dart';

import '../models.dart';
import '../theme.dart';

class BrandLogo extends StatelessWidget {
  const BrandLogo({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'LEXEM, READ YOUR SKIN',
      child: SizedBox(
        key: const Key('lexem-brand-logo'),
        width: compact ? 72 : 116,
        height: compact ? 30 : 44,
        child: Image.asset(
          'assets/branding/lexem-wordmark.png',
          fit: BoxFit.contain,
          alignment: Alignment.centerLeft,
          filterQuality: FilterQuality.high,
          semanticLabel: 'LEXEM, READ YOUR SKIN 브랜드 로고',
        ),
      ),
    );
  }
}

class SectionLabel extends StatelessWidget {
  const SectionLabel(this.index, this.label, {super.key, this.light = false});

  final String index;
  final String label;
  final bool light;

  @override
  Widget build(BuildContext context) {
    return Text(
      '$index / $label',
      style: TextStyle(
        color: light ? AppColors.ballerina : AppColors.berry,
        fontSize: 9,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.4,
      ),
    );
  }
}

class ProductBottle extends StatelessWidget {
  const ProductBottle(
      {required this.product,
      super.key,
      this.height = 210,
      this.alignment = Alignment.center});

  final BeautyProduct product;
  final double height;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: Image.asset(
        product.imageAsset,
        fit: BoxFit.cover,
        alignment: alignment,
        filterQuality: FilterQuality.high,
        semanticLabel: '${product.name} 제품 이미지',
        errorBuilder: (context, error, stackTrace) => ColoredBox(
          color: product.visualColor,
          child: const Center(child: Icon(Icons.image_not_supported_outlined)),
        ),
      ),
    );
  }
}

class MatchPill extends StatelessWidget {
  const MatchPill(this.value, {super.key, this.dark = false});

  final int value;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: dark ? AppColors.champagne : AppColors.berry,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
            color: dark ? AppColors.pearl : AppColors.champagne, width: .7),
      ),
      child: Text(
        '$value% MATCH',
        style: TextStyle(
            color: dark ? AppColors.deep : Colors.white,
            fontSize: 9,
            fontWeight: FontWeight.w700,
            letterSpacing: .4),
      ),
    );
  }
}
