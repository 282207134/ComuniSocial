import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../data/social_store.dart';
import '../../ui/theme.dart';
import '../../ui/widgets.dart';
import '../auth/auth_screens.dart';
import '../feed/feed_screens.dart';
import '../messaging/message_screens.dart';
import '../shell.dart';

import 'edit_profile_screen.dart';
import 'collection_screens.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final s = StoreScope.of(context);
    Widget item(
      IconData icon,
      String title,
      VoidCallback tap, {
      String? badge,
    }) => ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: const Color(0xFF6C5BC1), size: 25),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      onTap: tap,
      trailing: badge == null
          ? null
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 3),
              decoration: BoxDecoration(
                gradient: AppColors.gradient,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                badge,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
    );
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(35, 16, 35, 30),
        children: [
          Row(
            children: [
              Avatar('me', size: 64, photo: s.avatarPhoto),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          CupertinoIcons.location,
                          size: 14,
                          color: AppColors.purple,
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            s.location,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.muted,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Edit profile',
                onPressed: () => openPage(context, const EditProfileScreen()),
                icon: const Icon(
                  CupertinoIcons.square_pencil,
                  color: AppColors.muted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          const Divider(),
          const SizedBox(height: 14),
          item(
            CupertinoIcons.house,
            'Home',
            () => Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const AppShell()),
              (_) => false,
            ),
          ),
          item(
            CupertinoIcons.globe,
            'Activity',
            () => openPage(context, const NotificationsScreen()),
            badge: '8',
          ),
          item(
            CupertinoIcons.person_2,
            'Friends',
            () => openPage(context, const SearchScreen(friendsOnly: true)),
          ),
          item(
            CupertinoIcons.chat_bubble_text,
            'Messages',
            () => openPage(context, const MessagesScreen()),
            badge: '${s.conversations.fold<int>(0, (n, c) => n + c.unread)}',
          ),
          item(
            CupertinoIcons.photo,
            'Albums',
            () => openPage(context, const AlbumScreen()),
          ),
          item(
            CupertinoIcons.heart,
            'Favorites',
            () => openPage(context, const FavoritesScreen()),
          ),
          const SizedBox(height: 70),
          const Divider(),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            secondary: const Icon(CupertinoIcons.bell, color: AppColors.purple),
            title: const Text('Notifications', style: TextStyle(fontSize: 15)),
            subtitle: const Text(
              'Local preference',
              style: TextStyle(fontSize: 11),
            ),
            value: s.notificationsEnabled,
            onChanged: (v) {
              s.notificationsEnabled = v;
              s.save();
            },
          ),
          item(
            CupertinoIcons.info_circle,
            'About Comuni',
            () => showAboutDialog(
              context: context,
              applicationName: 'Comuni',
              applicationVersion: '1.0.0',
              children: [
                const Text(
                  'A local Flutter demo based on the Pixso “Comuni Social Media app” UI.\n\nAccounts, social sign in, SMS, live streams and calls are demonstration flows. No server is connected.',
                ),
              ],
            ),
          ),
          item(Icons.logout, 'Logout', () {
            s.signOut();
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const AuthScreen()),
              (_) => false,
            );
          }),
        ],
      ),
    );
  }
}
