import 'package:flutter/material.dart';

import '../models.dart';
import '../theme.dart';

class BrandLogo extends StatelessWidget {
  const BrandLogo({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 34,
          height: 34,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [AppColors.violet, AppColors.cyan],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight),
            shape: BoxShape.circle,
          ),
          child: const Text('+',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 21,
                  fontWeight: FontWeight.w500)),
        ),
        if (!compact) ...[
          const SizedBox(width: 9),
          const Text('PHARMA\nBEAUTY',
              style: TextStyle(
                  fontSize: 10,
                  height: .95,
                  fontWeight: FontWeight.w900,
                  letterSpacing: .7)),
        ],
      ],
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
        color: light ? AppColors.mint : AppColors.ink,
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
      color: dark ? AppColors.lime : AppColors.ink,
      child: Text(
        '$value% MATCH',
        style: TextStyle(
            color: dark ? AppColors.ink : Colors.white,
            fontSize: 9,
            fontWeight: FontWeight.w900,
            letterSpacing: .4),
      ),
    );
  }
}
