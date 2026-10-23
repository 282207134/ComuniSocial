import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../data/models.dart';
import '../../data/social_store.dart';
import '../../ui/theme.dart';
import '../../ui/widgets.dart';
import '../profile/profile_screens.dart';

import 'post_screens.dart';

class PostCard extends StatelessWidget {
  const PostCard({super.key, required this.post});
  final Post post;
  @override
  Widget build(BuildContext context) => SoftCard(
    padding: const EdgeInsets.fromLTRB(9, 10, 9, 6),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () => openPage(context, const ProfileScreen(public: true)),
              child: Avatar(
                post.avatar,
                photo: post.avatar == 'me'
                    ? StoreScope.of(context).avatarPhoto
                    : null,
              ),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: GestureDetector(
                onTap: () =>
                    openPage(context, const ProfileScreen(public: true)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.author,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      post.role,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            PopupMenuButton<String>(
              tooltip: 'Post options',
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.more_vert, color: Color(0xFFCCCCCC)),
              itemBuilder: (_) => [
                const PopupMenuItem(
                  value: 'save',
                  child: Text('Save / Unsave post'),
                ),
                const PopupMenuItem(
                  value: 'copy',
                  child: Text('Copy post text'),
                ),
              ],
              onSelected: (v) {
                if (v == 'save') {
                  StoreScope.of(context).bookmark(post);
                } else {
                  Clipboard.setData(
                    ClipboardData(
                      text: post.text.isEmpty
                          ? 'A view shared by ${post.author}'
                          : post.text,
                    ),
                  );
                  toast(context, 'Post text copied');
                }
              },
            ),
          ],
        ),
        if (post.text.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 8),
            child: Text(
              post.text,
              style: const TextStyle(
                fontSize: 14,
                height: 1.45,
                color: Color(0xFF525252),
              ),
            ),
          ),
        if (post.image != null || post.photo != null)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: GestureDetector(
              onTap: () => openPage(context, PostDetailScreen(post: post)),
              child: AppPhoto(
                post.image ?? 'city',
                photo: post.photo,
                width: double.infinity,
                height: 226,
                radius: 20,
              ),
            ),
          ),
        PostActions(post: post),
      ],
    ),
  );
}

class PostActions extends StatelessWidget {
  const PostActions({super.key, required this.post});
  final Post post;
  @override
  Widget build(BuildContext context) {
    final s = StoreScope.of(context);
    return Row(
      children: [
        IconButton(
          style: IconButton.styleFrom(
            minimumSize: const Size(40, 48),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            padding: EdgeInsets.zero,
          ),
          tooltip: 'Like ${post.id}',
          onPressed: () => s.like(post),
          icon: Icon(
            post.liked ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
            size: 22,
            color: post.liked ? const Color(0xFFFF1854) : AppColors.ink,
          ),
        ),
        Text(
          '${post.likes}',
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
        const SizedBox(width: 6),
        IconButton(
          style: IconButton.styleFrom(
            minimumSize: const Size(40, 48),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            padding: EdgeInsets.zero,
          ),
          tooltip: 'Comments ${post.id}',
          onPressed: () => openPage(context, CommentsScreen(post: post)),
          icon: const Icon(CupertinoIcons.chat_bubble, size: 22),
        ),
        Text(
          '${post.comments.length + (post.id == 'text'
                  ? 86
                  : post.id == 'city'
                  ? 95
                  : 0)}',
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
        IconButton(
          style: IconButton.styleFrom(
            minimumSize: const Size(40, 48),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            padding: EdgeInsets.zero,
          ),
          tooltip: 'Share ${post.id}',
          onPressed: () => showModalBottomSheet<void>(
            context: context,
            builder: (ctx) => SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Share this moment',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ListTile(
                      leading: const Icon(Icons.copy),
                      title: const Text('Copy post text'),
                      onTap: () {
                        Clipboard.setData(
                          ClipboardData(
                            text:
                                '${post.author}\n${post.text.isEmpty ? 'A beautiful city view on Comuni' : post.text}',
                          ),
                        );
                        Navigator.pop(ctx);
                        toast(context, 'Copied to clipboard');
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          icon: const Icon(CupertinoIcons.paperplane, size: 21),
        ),
        const Spacer(),
        IconButton(
          style: IconButton.styleFrom(
            minimumSize: const Size(40, 48),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            padding: EdgeInsets.zero,
          ),
          tooltip: 'Save ${post.id}',
          onPressed: () => s.bookmark(post),
          icon: Icon(
            post.saved ? CupertinoIcons.bookmark_fill : CupertinoIcons.bookmark,
            size: 22,
            color: post.saved ? AppColors.purple : AppColors.ink,
          ),
        ),
      ],
    );
  }
}
