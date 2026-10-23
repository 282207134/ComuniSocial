import 'package:flutter/material.dart';

import '../../data/social_store.dart';
import '../../ui/theme.dart';
import '../../ui/widgets.dart';
import '../profile/profile_screens.dart';

import 'post_screens.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Notification'),
      automaticallyImplyLeading: false,
    ),
    body: ListView.separated(
      padding: const EdgeInsets.fromLTRB(32, 20, 32, 30),
      itemCount: 8,
      separatorBuilder: (_, _) => const Divider(height: 25),
      itemBuilder: (_, i) => InkWell(
        onTap: () => openPage(
          context,
          i % 3 == 2
              ? const ProfileScreen(public: true)
              : CommentsScreen(post: StoreScope.of(context).posts.last),
        ),
        child: Row(
          children: [
            Avatar(['reny', 'realbung', 'jessica', 'terris'][i % 4], size: 43),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Reny Lewis ${['Commented On Your Post', 'Liked Your Post.', 'Started Following You', 'Tagged You In A Post'][i % 4]}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    i == 0 ? 'Just now' : '$i Hour ago',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.muted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, this.friendsOnly = false});
  final bool friendsOnly;
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String query = '';
  bool expanded = false;
  @override
  Widget build(BuildContext context) {
    final store = StoreScope.of(context);
    final all = List.generate(6, (i) => 'Thomas F${i == 0 ? '' : ' ${i + 1}'}');
    final results = all
        .where(
          (s) =>
              s.toLowerCase().contains(query.trim().toLowerCase()) &&
              (!widget.friendsOnly || store.friends.contains(s)),
        )
        .toList();
    final shown = expanded ? results : results.take(4).toList();
    return Scaffold(
      appBar: AppBar(title: Text(widget.friendsOnly ? 'Friends' : '')),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 35),
        children: [
          SearchBox(
            hint: 'Search people',
            onChanged: (s) => setState(() => query = s),
          ),
          const SizedBox(height: 24),
          Text(
            'Result (${results.length})',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          ),
          const SizedBox(height: 22),
          if (results.isEmpty)
            const EmptyState(
              'No people found',
              'Try another name or add people from Search.',
            ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: shown.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 22,
              childAspectRatio: .70,
            ),
            itemBuilder: (_, i) {
              final person = shown[i];
              final added = store.friends.contains(person);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () =>
                          openPage(context, const ProfileScreen(public: true)),
                      child: AppPhoto(
                        'thomas-${all.indexOf(person) % 4 + 1}',
                        width: double.infinity,
                        radius: 16,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              person,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Text(
                              '800 Followers',
                              style: TextStyle(
                                fontSize: 10,
                                color: AppColors.muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        tooltip: added
                            ? 'Remove friend $person'
                            : 'Add friend $person',
                        onPressed: () {
                          added
                              ? store.friends.remove(person)
                              : store.friends.add(person);
                          store.save();
                        },
                        icon: Icon(
                          added ? Icons.check : Icons.add,
                          color: AppColors.blue,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          if (results.length > 4 && !expanded)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 25),
              child: GradientButton(
                'See More',
                onPressed: () => setState(() => expanded = true),
              ),
            ),
        ],
      ),
    );
  }
}
