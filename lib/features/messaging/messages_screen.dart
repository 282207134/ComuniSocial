import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../data/social_store.dart';
import '../../ui/theme.dart';
import '../../ui/widgets.dart';

import 'chat_screen.dart';
import 'create_group_screen.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});
  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  String query = '';
  @override
  Widget build(BuildContext context) {
    final s = StoreScope.of(context);
    final chats = s.conversations
        .where((c) => c.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 78,
        centerTitle: false,
        titleSpacing: 35,
        title: const Text('Message', style: TextStyle(fontSize: 21)),
        actions: [
          IconButton(
            tooltip: 'Create group',
            onPressed: () => openPage(context, const CreateGroupScreen()),
            icon: const Icon(CupertinoIcons.square_pencil, size: 24),
          ),
          const SizedBox(width: 22),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 35),
        children: [
          SearchBox(onChanged: (v) => setState(() => query = v)),
          const SizedBox(height: 26),
          if (chats.isEmpty)
            const EmptyState(
              'No messages found',
              'Start a group or search for a different friend.',
            ),
          for (final today in [true, false]) ...[
            if (chats.any((c) => c.today == today))
              Padding(
                padding: const EdgeInsets.only(bottom: 14, top: 4),
                child: Text(
                  today ? 'Today' : 'Yesterday',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ...chats
                .where((c) => c.today == today)
                .map(
                  (c) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Dismissible(
                      key: ValueKey(c.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 25),
                        color: const Color(0xFFECE8FF),
                        child: const Icon(
                          Icons.delete_outline,
                          color: AppColors.purple,
                        ),
                      ),
                      confirmDismiss: (_) => showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Delete conversation?'),
                          content: Text(
                            'Remove your local chat with ${c.name}?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, true),
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                      ),
                      onDismissed: (_) {
                        s.conversations.remove(c);
                        s.save();
                      },
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: c.unread > 0
                              ? const [AppColors.shadow]
                              : [],
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            c.unread = 0;
                            s.save();
                            openPage(context, ChatScreen(chat: c));
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 17,
                            ),
                            child: Row(
                              children: [
                                Avatar(c.avatar, size: 44),
                                const SizedBox(width: 13),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        c.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        c.preview,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: AppColors.muted,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (c.unread > 0)
                                  Container(
                                    margin: const EdgeInsets.only(left: 7),
                                    width: 20,
                                    height: 20,
                                    alignment: Alignment.center,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFFFA03D),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Text(
                                      '${c.unread}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
          ],
          const SizedBox(height: 15),
        ],
      ),
    );
  }
}
