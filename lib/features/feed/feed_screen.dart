import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../data/social_store.dart';
import '../../ui/theme.dart';
import '../../ui/widgets.dart';
import '../profile/profile_screens.dart';

import 'post_widgets.dart';
import 'discovery_screens.dart';
import 'compose_screen.dart';
import 'story_screen.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final store = StoreScope.of(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 78,
        centerTitle: false,
        titleSpacing: 35,
        title: ShaderMask(
          shaderCallback: (r) => AppColors.gradient.createShader(r),
          child: const Text(
            'Comuni',
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Settings',
            onPressed: () => openPage(context, const SettingsScreen()),
            icon: const Icon(CupertinoIcons.gear, size: 24),
          ),
          IconButton(
            tooltip: 'Search',
            onPressed: () => openPage(context, const SearchScreen()),
            icon: const Icon(CupertinoIcons.search, size: 25),
          ),
          const SizedBox(width: 23),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await store.flush();
        },
        child: ListView(
          key: const PageStorageKey('feed'),
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            SizedBox(
              height: 104,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: 35,
                  vertical: 8,
                ),
                itemCount: 7,
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (_, i) {
                  const names = [
                    'You',
                    'Jacob',
                    'Luna',
                    'John',
                    'Netaliya',
                    'Rohn',
                    'Theresa',
                  ];
                  const photos = [
                    'you',
                    'jacob',
                    'luna',
                    'john',
                    'netaliya',
                    'rohn',
                    'theresa',
                  ];
                  return GestureDetector(
                    onTap: () => openPage(
                      context,
                      i == 0
                          ? const ComposeScreen()
                          : StoryScreen(live: i == 6),
                    ),
                    child: SizedBox(
                      width: 58,
                      child: Column(
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: i == 0
                                        ? Colors.transparent
                                        : AppColors.purple,
                                    width: 1.6,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: AppPhoto(
                                  photos[i],
                                  width: 50,
                                  height: 50,
                                  radius: 9,
                                ),
                              ),
                              if (i == 0)
                                Positioned(
                                  bottom: -2,
                                  right: -2,
                                  child: Container(
                                    width: 23,
                                    height: 23,
                                    decoration: const BoxDecoration(
                                      gradient: AppColors.gradient,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.add,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            names[i],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            ...store.posts.map(
              (p) => Padding(
                padding: const EdgeInsets.fromLTRB(35, 12, 35, 14),
                child: PostCard(post: p),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
