import 'package:flutter/material.dart';

import '../models.dart';
import '../theme.dart';
import '../widgets/brand_widgets.dart';

class SkinProfileScreen extends StatefulWidget {
  const SkinProfileScreen({super.key});

  @override
  State<SkinProfileScreen> createState() => _SkinProfileScreenState();
}

class _SkinProfileScreenState extends State<SkinProfileScreen> {
  int step = 0;
  String skinType = '';
  final selectedConcerns = <String>{};
  String sensitivity = '';
  String triggerHistory = '';
  String duration = '';

  static const questions = [
    (
      '평소 피부 타입은 어떤가요?',
      '세안 후 2~3시간이 지났을 때 가장 가까운 상태를 골라주세요.',
      [
        ('건성', '당김이 있고 각질이 쉽게 보여요'),
        ('지성', '얼굴 전체에 유분이 빠르게 올라와요'),
        ('복합성', 'T존은 번들거리고 볼은 건조해요'),
        ('민감성', '작은 변화에도 붉음이나 따가움이 생겨요'),
      ],
    ),
    (
      '오늘 가장 먼저 케어할 고민은요?',
      '추천 우선순위를 위해 최대 2개까지 선택해 주세요.',
      [
        ('피부 장벽', '거칠음 · 손상 · 보호막 케어'),
        ('트러블', '면포 · 반복되는 뾰루지'),
        ('보습', '속당김 · 수분 부족'),
        ('민감·진정', '붉음 · 열감 · 따가움'),
        ('모공', '피지 · 피부결 · 늘어진 모공'),
      ],
    ),
    (
      '지금 피부는 얼마나 예민한가요?',
      '최근 2주 동안 화장품을 바른 뒤의 반응을 떠올려 주세요.',
      [
        ('매우 예민함', '쉽게 붉어지고 여러 제품이 따가워요'),
        ('간헐적 반응', '피곤하거나 컨디션이 나쁠 때 반응해요'),
        ('편안한 편', '대부분의 기초 제품을 무리 없이 사용해요'),
      ],
    ),
    (
      '자극을 느꼈던 성분이 있나요?',
      '의학적 알레르기 확정이 아닌, 사용 중 불편했던 경험을 기록해요.',
      [
        ('향료·에센셜 오일', '향이 강한 제품에서 불편했어요'),
        ('레티노이드·AHA/BHA', '고함량 활성 성분이 따갑거나 건조했어요'),
        ('알코올', '알코올 함유 제품에서 화끈거림을 느꼈어요'),
        ('알려진 자극 없음', '특별히 기억나는 자극 경험이 없어요'),
      ],
    ),
    (
      '현재 불편은 얼마나 지속됐나요?',
      '증상의 시작 시점과 반복 여부는 관리 방향을 정하는 중요한 단서예요.',
      [
        ('오늘~1주', '최근에 갑자기 시작됐어요'),
        ('1~4주', '몇 주째 비슷하게 이어지고 있어요'),
        ('한 달 이상', '한 달 넘게 좋아지지 않아요'),
        ('반복적으로 발생', '좋아졌다가 같은 문제가 다시 생겨요'),
      ],
    ),
  ];

  bool get done => step >= questions.length;

  SkinProfile get profile => SkinProfile(
        skinType: skinType,
        concerns: selectedConcerns.toList(growable: false),
        sensitivity: sensitivity,
        triggerHistory: triggerHistory,
        duration: duration,
      );

  String get currentSelection => switch (step) {
        0 => skinType,
        2 => sensitivity,
        3 => triggerHistory,
        4 => duration,
        _ => '',
      };

  void select(String value) {
    if (step == 1) {
      setState(() {
        if (!selectedConcerns.remove(value)) {
          if (selectedConcerns.length == 2) {
            selectedConcerns.remove(selectedConcerns.first);
          }
          selectedConcerns.add(value);
        }
      });
      return;
    }

    setState(() {
      switch (step) {
        case 0:
          skinType = value;
          break;
        case 2:
          sensitivity = value;
          break;
        case 3:
          triggerHistory = value;
          break;
        case 4:
          duration = value;
          break;
      }
      step += 1;
    });
  }

  void goBack() {
    if (step == 0) return;
    setState(() => step -= 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 68,
        title: const BrandLogo(),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          tooltip: '닫기',
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 8, 22, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: LinearProgressIndicator(
                      value: done ? 1 : (step + 1) / questions.length,
                      minHeight: 4,
                      color: AppColors.fuchsia,
                      backgroundColor: AppColors.paper2,
                    ),
                  ),
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      Text(
                        done
                            ? 'SELF-REPORTED SKIN CHART · COMPLETE'
                            : 'SELF-REPORTED SKIN CHART · ${step + 1}/05',
                        style: const TextStyle(
                          color: AppColors.berry,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.1,
                        ),
                      ),
                      const Spacer(),
                      if (step > 0 && !done)
                        TextButton.icon(
                          onPressed: goBack,
                          icon: const Icon(Icons.arrow_back_rounded, size: 15),
                          label: const Text('이전'),
                        ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 260),
                      child: done
                          ? _buildResult(context)
                          : _buildQuestion(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuestion(BuildContext context) {
    final question = questions[step];
    return Column(
      key: ValueKey(step),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(question.$1, style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 10),
        Text(
          question.$2,
          style: const TextStyle(
            color: AppColors.muted,
            fontSize: 12,
            height: 1.55,
          ),
        ),
        const SizedBox(height: 24),
        Expanded(
          child: ListView.separated(
            itemCount: question.$3.length,
            separatorBuilder: (_, __) => const SizedBox(height: 9),
            itemBuilder: (context, index) {
              final option = question.$3[index];
              final selected = step == 1
                  ? selectedConcerns.contains(option.$1)
                  : currentSelection == option.$1;
              return Material(
                color: selected ? AppColors.blush : AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  key: Key('skin-chart-option-$step-$index'),
                  onTap: () => select(option.$1),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(16, 15, 14, 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: selected ? AppColors.fuchsia : AppColors.line,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 30,
                          height: 30,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color:
                                selected ? AppColors.fuchsia : AppColors.paper2,
                            shape: BoxShape.circle,
                          ),
                          child: selected
                              ? const Icon(Icons.check_rounded,
                                  color: Colors.white, size: 16)
                              : Text(
                                  '0${index + 1}',
                                  style: const TextStyle(
                                    color: AppColors.muted,
                                    fontSize: 8,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                        ),
                        const SizedBox(width: 13),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                option.$1,
                                style: const TextStyle(
                                  color: AppColors.ink,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                option.$2,
                                style: const TextStyle(
                                  color: AppColors.muted,
                                  fontSize: 10,
                                  height: 1.35,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          step == 1
                              ? Icons.add_circle_outline_rounded
                              : Icons.arrow_forward_rounded,
                          color: selected ? AppColors.fuchsia : AppColors.rose,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        if (step == 1) ...[
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              key: const Key('skin-chart-concern-next'),
              onPressed: selectedConcerns.isEmpty
                  ? null
                  : () => setState(() => step += 1),
              child: Text('선택 완료 · ${selectedConcerns.length}/2'),
            ),
          ),
        ],
        const SizedBox(height: 12),
        const _MedicalBoundaryNote(),
      ],
    );
  }

  Widget _buildResult(BuildContext context) {
    final result = profile;
    return ListView(
      key: const ValueKey('skin-chart-result'),
      children: [
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: AppColors.deep,
            borderRadius: BorderRadius.circular(AppRadii.feature),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.check_circle_rounded,
                      color: AppColors.ballerina, size: 18),
                  SizedBox(width: 8),
                  Text(
                    'CHART READY · CURATION SIGNAL ON',
                    style: TextStyle(
                      color: AppColors.ballerina,
                      fontSize: 8,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                result.profileName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -.8,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${result.skinType} · ${result.concerns.join(' · ')}',
                style: const TextStyle(
                  color: Color(0xFFE6E1FF),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 24),
              _ResultLine(label: '민감도', value: result.sensitivity),
              _ResultLine(label: '자극 이력', value: result.triggerHistory),
              _ResultLine(label: '지속 기간', value: result.duration),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadii.card),
            border: Border.all(color: AppColors.line),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'CURATION INTERPRETATION',
                style: TextStyle(
                  color: AppColors.berry,
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '${result.recommendedIngredients} 중심으로 먼저 볼게요.',
                style: const TextStyle(
                  color: AppColors.ink,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                result.careNote,
                style: const TextStyle(
                  color: AppColors.muted,
                  fontSize: 12,
                  height: 1.55,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            key: const Key('skin-chart-complete'),
            onPressed: () => Navigator.pop(context, result),
            icon: const Icon(Icons.arrow_forward_rounded, size: 18),
            label: const Text('내 차트로 맞춤 제품 보기'),
          ),
        ),
        const SizedBox(height: 14),
        const _MedicalBoundaryNote(showUrgentSigns: true),
      ],
    );
  }
}

class _ResultLine extends StatelessWidget {
  const _ResultLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 9),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 68,
              child: Text(
                label,
                style: const TextStyle(
                  color: AppColors.rose,
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Expanded(
              child: Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      );
}

class _MedicalBoundaryNote extends StatelessWidget {
  const _MedicalBoundaryNote({this.showUrgentSigns = false});

  final bool showUrgentSigns;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: AppColors.paper2,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.info_outline_rounded,
                size: 16, color: AppColors.muted),
            const SizedBox(width: 9),
            Expanded(
              child: Text(
                showUrgentSigns
                    ? '이 차트는 의료 진단이 아닙니다. 빠르게 번지는 발진, 물집·진물, 심한 통증·발열, 눈·입술 부종 또는 호흡 불편이 있으면 제품 추천보다 의료진 상담을 우선하세요.'
                    : '자가 입력을 바탕으로 한 화장품 큐레이션용 차트이며 의료 진단을 대신하지 않습니다.',
                style: const TextStyle(
                  color: AppColors.muted,
                  fontSize: 9,
                  height: 1.55,
                ),
              ),
            ),
          ],
        ),
      );
}
