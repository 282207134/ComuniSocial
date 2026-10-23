import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../data/models.dart';
import '../../data/social_store.dart';
import '../../ui/theme.dart';
import '../../ui/widgets.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.chat});
  final Conversation chat;
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final scroll = ScrollController();
  @override
  void dispose() {
    scroll.dispose();
    super.dispose();
  }

  void send(String v) {
    StoreScope.of(context).send(widget.chat, v);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scroll.hasClients) {
        scroll.animateTo(
          scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void call(bool video) => showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(video ? 'Video call' : 'Voice call'),
      content: const Text(
        'Calls need a connected calling service. This local demo supports text messages.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Got it'),
        ),
      ],
    ),
  );
  @override
  Widget build(BuildContext context) {
    StoreScope.of(context);
    final c = widget.chat;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        centerTitle: false,
        titleSpacing: 0,
        title: Row(
          children: [
            Avatar(c.avatar, size: 45),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    c.name,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF5440B7),
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Text(
                    'Local conversation',
                    style: TextStyle(fontSize: 11, color: AppColors.muted),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Voice call',
            onPressed: () => call(false),
            icon: const Icon(
              CupertinoIcons.phone_fill,
              size: 20,
              color: AppColors.purple,
            ),
          ),
          IconButton(
            tooltip: 'Video call',
            onPressed: () => call(true),
            icon: const Icon(
              CupertinoIcons.video_camera_solid,
              size: 23,
              color: AppColors.purple,
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: AppColors.field,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          children: [
            Expanded(
              child: c.messages.isEmpty
                  ? const Center(
                      child: EmptyState(
                        'Say hello',
                        'Send the first message to start this conversation.',
                      ),
                    )
                  : ListView.builder(
                      controller: scroll,
                      padding: const EdgeInsets.fromLTRB(30, 34, 30, 10),
                      itemCount: c.messages.length,
                      itemBuilder: (_, i) {
                        final m = c.messages[i];
                        return Align(
                          alignment: m.mine
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            constraints: const BoxConstraints(maxWidth: 260),
                            margin: const EdgeInsets.only(bottom: 20),
                            child: Column(
                              crossAxisAlignment: m.mine
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    color: m.mine
                                        ? const Color(0xFF302092)
                                        : Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: const Radius.circular(18),
                                      topRight: const Radius.circular(18),
                                      bottomLeft: Radius.circular(
                                        m.mine ? 18 : 4,
                                      ),
                                      bottomRight: Radius.circular(
                                        m.mine ? 4 : 18,
                                      ),
                                    ),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color(0x08000000),
                                        blurRadius: 18,
                                        offset: Offset(0, 9),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    m.text,
                                    style: TextStyle(
                                      fontSize: 12,
                                      height: 1.7,
                                      color: m.mine
                                          ? Colors.white
                                          : const Color(0xFF63538D),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  m.time,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: AppColors.muted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            SafeArea(
              top: false,
              child: MessageComposer(hint: 'Write now...', onSend: send),
            ),
          ],
        ),
      ),
    );
  }
}
