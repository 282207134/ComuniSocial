import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../data/models.dart';
import '../../data/social_store.dart';
import '../../ui/theme.dart';
import '../../ui/widgets.dart';
import '../feed/feed_screens.dart';
import '../messaging/message_screens.dart';

import 'settings_screen.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, this.public = false});
  final bool public;
  @override
  Widget build(BuildContext context) {
    final s = StoreScope.of(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: public,
        toolbarHeight: 76,
        title: Text(public ? 'Aldavideo.Ronaldo' : 'Profile'),
        actions: [
          IconButton(
            tooltip: 'Profile options',
            onPressed: () => openPage(context, const SettingsScreen()),
            icon: const Icon(Icons.more_horiz),
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(35, 18, 35, 24),
        children: [
          Row(
            children: [
              Avatar(
                public ? 'ronaldo' : 'me',
                photo: public ? null : s.avatarPhoto,
                size: 64,
              ),
              const SizedBox(width: 22),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      public ? 'Aldavideo Ronaldo' : s.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      public ? 'UI Designer And Developer' : 'UI Designer',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.muted,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      public ? 'Aldavidoron.com' : 'Aldebaror.com',
                      style: const TextStyle(fontSize: 11),
                    ),
                  ],
                ),
              ),
              if (!public)
                TextButton(
                  onPressed: () => openPage(context, const EditProfileScreen()),
                  child: const Text('Edit', style: TextStyle(fontSize: 12)),
                ),
            ],
          ),
          const SizedBox(height: 30),
          SizedBox(
            height: 66,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: public ? 5 : 6,
              separatorBuilder: (_, _) => const SizedBox(width: 10),
              itemBuilder: (_, i) => GestureDetector(
                onTap: () => openPage(
                  context,
                  !public && i == 0
                      ? const ComposeScreen()
                      : const StoryScreen(),
                ),
                child: !public && i == 0
                    ? Container(
                        width: 64,
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.purple),
                          shape: BoxShape.circle,
                        ),
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: AppColors.gradient,
                          ),
                          child: const Icon(Icons.add, color: Colors.white),
                        ),
                      )
                    : AppPhoto(
                        'highlight-${public ? i + 1 : i}',
                        width: 64,
                        height: 64,
                      ),
              ),
            ),
          ),
          const SizedBox(height: 25),
          SoftCard(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                stat(
                  public
                      ? '113'
                      : '${113 + s.posts.where((p) => p.avatar == 'me').length}',
                  public ? 'Images' : 'Posts',
                ),
                stat(public ? '1.3 M' : '5.3 M', 'Followers'),
                stat(public ? '987' : '25', 'Following'),
              ],
            ),
          ),
          if (public)
            Padding(
              padding: const EdgeInsets.only(top: 22),
              child: Row(
                children: [
                  Expanded(
                    child: GradientButton(
                      s.following ? 'FOLLOWING' : 'FOLLOW',
                      round: false,
                      onPressed: () {
                        s.following = !s.following;
                        s.save();
                      },
                    ),
                  ),
                  const SizedBox(width: 13),
                  Container(
                    decoration: BoxDecoration(
                      gradient: AppColors.gradient,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                      tooltip: 'Message profile',
                      onPressed: () {
                        var chats = s.conversations.where(
                          (c) => c.id == 'ronaldo',
                        );
                        final c = chats.isNotEmpty
                            ? chats.first
                            : Conversation(
                                id: 'ronaldo',
                                name: 'Aldavideo Ronaldo',
                                avatar: 'ronaldo',
                                preview: 'Say hello',
                                today: true,
                              );
                        if (chats.isEmpty) {
                          s.conversations.insert(0, c);
                          s.save();
                        }
                        openPage(context, ChatScreen(chat: c));
                      },
                      padding: const EdgeInsets.all(17),
                      icon: const Icon(
                        CupertinoIcons.chat_bubble_fill,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 35),
          PhotoGrid(public: public),
        ],
      ),
    );
  }

  Widget stat(String count, String label) => Expanded(
    child: Column(
      children: [
        Text(
          count,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.muted),
        ),
      ],
    ),
  );
}

class PhotoGrid extends StatelessWidget {
  const PhotoGrid({super.key, this.public = false});
  final bool public;
  @override
  Widget build(BuildContext context) {
    Widget photo(String asset, double height) => GestureDetector(
      onTap: () => openPage(
        context,
        PostDetailScreen(
          post: Post(
            id: 'album-$asset',
            author: public ? 'Aldavideo Ronaldo' : StoreScope.of(context).name,
            avatar: public ? 'ronaldo' : 'me',
            image: asset,
            likes: 325,
          ),
        ),
      ),
      child: AppPhoto(
        asset,
        height: height,
        width: double.infinity,
        radius: 16,
      ),
    );
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 18,
              child: photo(public ? 'car-driver' : 'art', 251),
            ),
            const SizedBox(width: 17),
            Expanded(
              flex: 10,
              child: Column(
                children: [
                  photo(public ? 'night-car' : 'shoes', 117),
                  const SizedBox(height: 17),
                  photo('car-interior', 117),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(child: photo(public ? 'plants' : 'street', 203)),
            const SizedBox(width: 17),
            Expanded(child: photo('fashion', 203)),
          ],
        ),
      ],
    );
  }
}
