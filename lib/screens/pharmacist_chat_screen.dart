import 'package:flutter/material.dart';

import '../theme.dart';

class PharmacistChatScreen extends StatefulWidget {
  const PharmacistChatScreen({super.key});

  @override
  State<PharmacistChatScreen> createState() => _PharmacistChatScreenState();
}

class _ChatMessage {
  const _ChatMessage(this.text, {required this.fromLia});
  final String text;
  final bool fromLia;
}

class _PharmacistChatScreenState extends State<PharmacistChatScreen> {
  final controller = TextEditingController();
  final scrollController = ScrollController();
  bool typing = false;
  final messages = <_ChatMessage>[
    const _ChatMessage(
      '안녕하세요, PHARMA BEAUTY의 리아 약사예요. 피부 고민이나 성분 궁합을 편하게 물어보세요.',
      fromLia: true,
    ),
  ];

  static const prompts = [
    '성분 궁합 확인',
    '민감 피부 루틴',
    '레티날 사용법',
    '제품 추천',
  ];

  @override
  void dispose() {
    controller.dispose();
    scrollController.dispose();
    super.dispose();
  }

  String answerFor(String question) {
    final query = question.toLowerCase();
    if (query.contains('임신') || query.contains('수유')) {
      return '임신·수유 중에는 레티노이드 계열 사용 전 담당 의료진이나 약사에게 먼저 확인해 주세요. 현재 복용약과 피부 상태까지 함께 봐야 안전해요.';
    }
    if (query.contains('레티날') || query.contains('레티놀')) {
      return '레티날은 저녁에 주 2회부터 시작해 보세요. 보습제와 함께 사용하고 다음 날 자외선 차단은 필수예요. 처음에는 BHA와 같은 루틴에서 겹치지 않는 편을 권해요.';
    }
    if (query.contains('bha') || query.contains('살리실')) {
      return 'BHA는 피지와 모공 고민에 잘 맞지만 과사용하면 건조할 수 있어요. 주 2~3회부터 시작하고, 레티노이드와는 날짜를 나눠 사용하는 편이 안전해요.';
    }
    if (query.contains('민감') || query.contains('자극') || query.contains('장벽')) {
      return '민감할 때는 루틴을 세라마이드·판테놀 중심의 세 단계 이내로 줄여보세요. 새 제품은 국소 테스트 후 사용하고, 붉음이나 따가움이 지속되면 사용을 중단해 주세요.';
    }
    if (query.contains('궁합')) {
      return '확인할 두 성분을 알려주세요. 예: “비타민 C와 나이아신아마이드”. 자극 가능성, 사용 순서, 아침·저녁 배치를 함께 정리해 드릴게요.';
    }
    if (query.contains('추천') || query.contains('제품')) {
      return '정확한 추천을 위해 피부 고민, 현재 자극 여부, 선호 제형을 알려주세요. 지금 등록된 피부 프로필을 기준으로도 후보를 좁힐 수 있어요.';
    }
    return '좋은 질문이에요. 피부 고민과 함께 현재 쓰는 성분이나 제품명을 알려주시면, 사용 순서와 함께 더 구체적으로 안내해 드릴게요.';
  }

  Future<void> send([String? preset]) async {
    final text = (preset ?? controller.text).trim();
    if (text.isEmpty || typing) return;
    controller.clear();
    setState(() {
      messages.add(_ChatMessage(text, fromLia: false));
      typing = true;
    });
    _scrollDown();
    await Future<void>.delayed(const Duration(milliseconds: 420));
    if (!mounted) return;
    setState(() {
      messages.add(_ChatMessage(answerFor(text), fromLia: true));
      typing = false;
    });
    _scrollDown();
  }

  void _scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!scrollController.hasClients) return;
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          toolbarHeight: 76,
          titleSpacing: 4,
          title: const Row(children: [
            _LiaAvatar(radius: 23),
            SizedBox(width: 11),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('리아 약사',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
              SizedBox(height: 2),
              Row(children: [
                CircleAvatar(radius: 3, backgroundColor: Color(0xFF42B883)),
                SizedBox(width: 5),
                Text('성분 상담 중',
                    style: TextStyle(
                        color: AppColors.muted,
                        fontSize: 10,
                        fontWeight: FontWeight.w700)),
              ]),
            ]),
          ]),
        ),
        body: SafeArea(
          child: Column(children: [
            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(16, 8, 16, 10),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
              decoration: BoxDecoration(
                color: AppColors.mint,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.sage.withValues(alpha: .2)),
              ),
              child: const Row(children: [
                Icon(Icons.verified_user_outlined, size: 17),
                SizedBox(width: 9),
                Expanded(
                  child: Text(
                    '화장품 성분 안내이며 의료 진단·처방을 대신하지 않아요.',
                    style: TextStyle(fontSize: 10, height: 1.4),
                  ),
                ),
              ]),
            ),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                itemCount: messages.length + (typing ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == messages.length) return const _TypingBubble();
                  return _MessageBubble(message: messages[index]);
                },
              ),
            ),
            SizedBox(
              height: 42,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: prompts.length,
                separatorBuilder: (_, __) => const SizedBox(width: 7),
                itemBuilder: (_, index) => ActionChip(
                  label: Text(prompts[index]),
                  onPressed: () => send(prompts[index]),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border: Border(top: BorderSide(color: AppColors.line)),
              ),
              child: Row(children: [
                Expanded(
                  child: TextField(
                    key: const Key('pharmacist-chat-input'),
                    controller: controller,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => send(),
                    decoration: const InputDecoration(
                      hintText: '성분이나 피부 고민을 물어보세요',
                      prefixIcon: Icon(Icons.auto_awesome_outlined, size: 19),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  key: const Key('pharmacist-chat-send'),
                  onPressed: send,
                  padding: const EdgeInsets.all(16),
                  icon: const Icon(Icons.arrow_upward_rounded),
                  tooltip: '보내기',
                ),
              ]),
            ),
          ]),
        ),
      );
}

class _LiaAvatar extends StatelessWidget {
  const _LiaAvatar({required this.radius});
  final double radius;

  @override
  Widget build(BuildContext context) => CircleAvatar(
        radius: radius,
        backgroundColor: AppColors.oatmeal,
        backgroundImage:
            const AssetImage('assets/characters/pharmacist-lia.png'),
      );
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});
  final _ChatMessage message;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Row(
          mainAxisAlignment:
              message.fromLia ? MainAxisAlignment.start : MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (message.fromLia) ...[
              const _LiaAvatar(radius: 16),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 520),
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
                decoration: BoxDecoration(
                  color: message.fromLia ? AppColors.surface : AppColors.deep,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(20),
                    topRight: const Radius.circular(20),
                    bottomLeft: Radius.circular(message.fromLia ? 5 : 20),
                    bottomRight: Radius.circular(message.fromLia ? 20 : 5),
                  ),
                  border: message.fromLia
                      ? Border.all(color: AppColors.line)
                      : null,
                ),
                child: Text(
                  message.text,
                  style: TextStyle(
                    color: message.fromLia ? AppColors.ink : Colors.white,
                    fontSize: 13,
                    height: 1.55,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}

class _TypingBubble extends StatelessWidget {
  const _TypingBubble();

  @override
  Widget build(BuildContext context) => const Padding(
        padding: EdgeInsets.only(bottom: 14),
        child: Row(children: [
          _LiaAvatar(radius: 16),
          SizedBox(width: 8),
          DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.all(Radius.circular(18)),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text('답변을 정리하고 있어요 ···',
                  style: TextStyle(color: AppColors.muted, fontSize: 11)),
            ),
          ),
        ]),
      );
}
