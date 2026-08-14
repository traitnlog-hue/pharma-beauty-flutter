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
          decoration: BoxDecoration(
            gradient: const LinearGradient(
                colors: [AppColors.berry, AppColors.fuchsia],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight),
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.champagne, width: 1.2),
            boxShadow: const [
              BoxShadow(
                  color: Color(0x33DF0AA4),
                  blurRadius: 16,
                  offset: Offset(0, 6))
            ],
          ),
          child: const Icon(Icons.auto_awesome_rounded,
              color: AppColors.pearl, size: 16),
        ),
        if (!compact) ...[
          const SizedBox(width: 9),
          const Text('PHARMA\nBEAUTY',
              style: TextStyle(
                  fontSize: 9,
                  height: 1.05,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2)),
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
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
            color: dark ? AppColors.pearl : AppColors.champagne, width: .7),
      ),
      child: Text(
        '$value% MATCH',
        style: TextStyle(
            color: dark ? AppColors.deep : Colors.white,
            fontSize: 9,
            fontWeight: FontWeight.w900,
            letterSpacing: .4),
      ),
    );
  }
}
