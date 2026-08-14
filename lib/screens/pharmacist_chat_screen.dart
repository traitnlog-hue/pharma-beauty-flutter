import 'package:flutter/material.dart';

import '../features/pharmacist_chat/chat_message.dart';
import '../features/pharmacist_chat/pharmacist_chat_service.dart';
import '../theme.dart';

class PharmacistChatScreen extends StatefulWidget {
  const PharmacistChatScreen({
    this.service = const PharmacistChatService(),
    super.key,
  });

  final PharmacistChatService service;

  @override
  State<PharmacistChatScreen> createState() => _PharmacistChatScreenState();
}

class _PharmacistChatScreenState extends State<PharmacistChatScreen> {
  final controller = TextEditingController();
  final scrollController = ScrollController();
  bool typing = false;
  late final List<ChatMessage> messages;

  @override
  void initState() {
    super.initState();
    messages = [
      const ChatMessage(
        PharmacistChatService.welcomeMessage,
        fromPharmacist: true,
      ),
    ];
  }

  @override
  void dispose() {
    controller.dispose();
    scrollController.dispose();
    super.dispose();
  }

  Future<void> send([String? preset]) async {
    final text = (preset ?? controller.text).trim();
    if (text.isEmpty || typing) return;
    controller.clear();
    setState(() {
      messages.add(ChatMessage(text, fromPharmacist: false));
      typing = true;
    });
    _scrollDown();
    await Future<void>.delayed(const Duration(milliseconds: 420));
    if (!mounted) return;
    setState(() {
      messages.add(ChatMessage(
        widget.service.answerFor(text),
        fromPharmacist: true,
      ));
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
                CircleAvatar(radius: 3, backgroundColor: AppColors.fuchsia),
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
                color: AppColors.blush,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: AppColors.roseGold.withValues(alpha: .45)),
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
                itemCount: PharmacistChatService.prompts.length,
                separatorBuilder: (_, __) => const SizedBox(width: 7),
                itemBuilder: (_, index) => ActionChip(
                  backgroundColor: AppColors.surface,
                  side: const BorderSide(color: AppColors.roseGold),
                  labelStyle: const TextStyle(
                      color: AppColors.berry,
                      fontSize: 11,
                      fontWeight: FontWeight.w800),
                  label: Text(PharmacistChatService.prompts[index]),
                  onPressed: () => send(PharmacistChatService.prompts[index]),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              decoration: const BoxDecoration(
                color: AppColors.pearl,
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
            const AssetImage('assets/characters/pharmacist-lia-pink-glam.png'),
      );
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});
  final ChatMessage message;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Row(
          mainAxisAlignment: message.fromPharmacist
              ? MainAxisAlignment.start
              : MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (message.fromPharmacist) ...[
              const _LiaAvatar(radius: 16),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 520),
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
                decoration: BoxDecoration(
                  color: message.fromPharmacist
                      ? AppColors.surface
                      : AppColors.berry,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(20),
                    topRight: const Radius.circular(20),
                    bottomLeft:
                        Radius.circular(message.fromPharmacist ? 5 : 20),
                    bottomRight:
                        Radius.circular(message.fromPharmacist ? 20 : 5),
                  ),
                  border: message.fromPharmacist
                      ? Border.all(color: AppColors.line)
                      : null,
                ),
                child: Text(
                  message.text,
                  style: TextStyle(
                    color:
                        message.fromPharmacist ? AppColors.ink : Colors.white,
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
