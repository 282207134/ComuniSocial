import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../data/social_store.dart';
import '../ui/theme.dart';
import '../ui/widgets.dart';
import 'feed/feed_screens.dart';
import 'messaging/message_screens.dart';
import 'profile/profile_screens.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key, this.initialTab = 0});
  final int initialTab;
  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  late int tab = widget.initialTab;
  @override
  Widget build(BuildContext context) {
    final store = StoreScope.of(context);
    return Scaffold(
      body: Column(
        children: [
          if (store.persistenceError != null)
            SafeArea(
              bottom: false,
              child: MaterialBanner(
                content: Text(store.persistenceError!),
                actions: [
                  TextButton(
                    onPressed: () {
                      store.persistenceError = null;
                      store.save();
                    },
                    child: const Text('Dismiss'),
                  ),
                ],
              ),
            ),
          Expanded(
            child: IndexedStack(
              index: tab,
              children: const [
                FeedScreen(),
                MessagesScreen(),
                NotificationsScreen(),
                ProfileScreen(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0x18000000),
              blurRadius: 32,
              offset: Offset(0, -6),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 74,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                nav(0, 'Home', CupertinoIcons.house, CupertinoIcons.house_fill),
                nav(
                  1,
                  'Messages',
                  CupertinoIcons.chat_bubble_2,
                  CupertinoIcons.chat_bubble_2_fill,
                ),
                Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppColors.gradient,
                  ),
                  child: IconButton(
                    tooltip: 'Create post',
                    onPressed: () async {
                      final published = await openPage<bool>(
                        context,
                        const ComposeScreen(),
                      );
                      if (published == true && mounted) setState(() => tab = 0);
                    },
                    icon: const Icon(Icons.add, color: Colors.white, size: 30),
                  ),
                ),
                nav(
                  2,
                  'Notifications',
                  CupertinoIcons.bell,
                  CupertinoIcons.bell_fill,
                ),
                nav(
                  3,
                  'Profile',
                  CupertinoIcons.person,
                  CupertinoIcons.person_fill,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget nav(int i, String label, IconData outline, IconData filled) =>
      IconButton(
        key: ValueKey('nav-$label'),
        tooltip: label,
        onPressed: () => setState(() => tab = i),
        icon: Icon(
          tab == i ? filled : outline,
          size: 26,
          color: tab == i ? AppColors.purple : const Color(0xFF999999),
        ),
      );
}
