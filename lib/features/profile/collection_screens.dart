import 'package:flutter/material.dart';

import '../../data/social_store.dart';
import '../../ui/widgets.dart';
import '../feed/feed_screens.dart';

import 'profile_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final posts = StoreScope.of(context).posts.where((p) => p.saved).toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: ListView(
        padding: const EdgeInsets.all(30),
        children: posts.isEmpty
            ? [
                const EmptyState(
                  'Your saved moments',
                  'Tap the bookmark on a post to keep it here.',
                ),
              ]
            : posts
                  .map(
                    (p) => Padding(
                      padding: const EdgeInsets.only(bottom: 25),
                      child: PostCard(post: p),
                    ),
                  )
                  .toList(),
      ),
    );
  }
}

class AlbumScreen extends StatelessWidget {
  const AlbumScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Albums')),
    body: const SingleChildScrollView(
      padding: EdgeInsets.all(35),
      child: PhotoGrid(),
    ),
  );
}
