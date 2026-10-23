import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../data/models.dart';
import '../../data/social_store.dart';
import '../../ui/theme.dart';
import '../../ui/widgets.dart';
import '../profile/profile_screens.dart';

import 'post_widgets.dart';

class PostDetailScreen extends StatelessWidget {
  const PostDetailScreen({super.key, required this.post});
  final Post post;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Avatar(post.avatar, size: 46),
      actions: [
        IconButton(
          tooltip: 'View profile',
          onPressed: () => openPage(context, const ProfileScreen(public: true)),
          icon: const Icon(Icons.more_horiz),
        ),
        const SizedBox(width: 20),
      ],
    ),
    body: Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(32, 22, 32, 0),
            children: [
              if (post.image != null || post.photo != null)
                AppPhoto(
                  post.image ?? 'city',
                  photo: post.photo,
                  width: double.infinity,
                  height: 377,
                  radius: 14,
                ),
              if (post.text.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(post.text),
                ),
              PostActions(post: post),
              const SizedBox(height: 25),
              ...post.comments.asMap().entries.map(
                (e) => CommentTile(
                  text: e.value,
                  index: e.key,
                  compact: true,
                  mine:
                      e.key >=
                      (post.id == 'text'
                          ? 1
                          : post.id == 'city'
                          ? 3
                          : 0),
                ),
              ),
            ],
          ),
        ),
        SafeArea(
          top: false,
          child: MessageComposer(
            avatar: 'me',
            onSend: (text) => StoreScope.of(context).comment(post, text),
          ),
        ),
      ],
    ),
  );
}

class CommentsScreen extends StatelessWidget {
  const CommentsScreen({super.key, required this.post});
  final Post post;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Comments')),
    body: Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(32, 25, 32, 0),
            children: [
              for (var i = 0; i < post.comments.length; i++)
                CommentTile(
                  text: post.comments[i],
                  index: i,
                  mine:
                      i >=
                      (post.id == 'text'
                          ? 1
                          : post.id == 'city'
                          ? 3
                          : 0),
                ),
              if (post.comments.length < 4) ...[
                const CommentTile(
                  text: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque interdum blandit ipsum sed scelerisque.',
                  index: 1,
                ),
                const CommentTile(
                  text: 'Such a wonderful moment. Thanks for sharing!',
                  index: 2,
                ),
                const CommentTile(
                  text: 'Looking forward to seeing more of your photos.',
                  index: 3,
                ),
              ],
            ],
          ),
        ),
        SafeArea(
          top: false,
          child: MessageComposer(
            avatar: 'me',
            onSend: (text) => StoreScope.of(context).comment(post, text),
          ),
        ),
      ],
    ),
  );
}

class CommentTile extends StatefulWidget {
  const CommentTile({
    super.key,
    required this.text,
    required this.index,
    this.compact = false,
    this.mine = false,
  });
  final String text;
  final int index;
  final bool compact, mine;
  @override
  State<CommentTile> createState() => _CommentTileState();
}

class _CommentTileState extends State<CommentTile> {
  bool liked = false;
  @override
  Widget build(BuildContext context) {
    const names = ['Santita R.', 'Caroline Tan', 'Roy Zender', 'Tom Holand'];
    const avatars = ['reny', 'luna', 'alex', 'you'];
    final i = widget.index % 4;
    return Padding(
      padding: EdgeInsets.only(bottom: widget.compact ? 15 : 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Avatar(
                widget.mine ? 'me' : avatars[i],
                size: 42,
                photo: widget.mine ? StoreScope.of(context).avatarPhoto : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            widget.mine
                                ? StoreScope.of(context).name
                                : names[i],
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        const Icon(
                          Icons.verified,
                          size: 13,
                          color: AppColors.purple,
                        ),
                      ],
                    ),
                    const Text(
                      '2 hr ago',
                      style: TextStyle(fontSize: 10, color: AppColors.muted),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Like comment',
                onPressed: () => setState(() => liked = !liked),
                icon: Icon(
                  liked ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                  color: liked ? Colors.pink : AppColors.muted,
                  size: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            widget.text,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF777777),
              height: 1.7,
            ),
          ),
          if (!widget.compact) ...[const SizedBox(height: 15), const Divider()],
        ],
      ),
    );
  }
}
