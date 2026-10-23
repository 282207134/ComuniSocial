import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:comuni_social/app.dart';
import 'package:comuni_social/data/social_store.dart';
import 'package:comuni_social/features/auth/auth_screens.dart';
import 'package:comuni_social/features/shell.dart';
import 'package:comuni_social/features/feed/feed_screens.dart';
import 'package:comuni_social/features/messaging/message_screens.dart';
import 'package:comuni_social/features/profile/profile_screens.dart';

void main() {
  late SocialStore store;
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    store = await SocialStore.load();
  });
  Future<void> mount(
    WidgetTester t,
    Widget page, {
    Size size = const Size(414, 896),
    double scale = 1,
  }) async {
    t.view.physicalSize = size;
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.resetPhysicalSize);
    addTearDown(t.view.resetDevicePixelRatio);
    await t.pumpWidget(
      ComuniApp(
        key: UniqueKey(),
        store: store,
        home: MediaQuery(
          data: MediaQueryData(
            size: size,
            textScaler: TextScaler.linear(scale),
          ),
          child: page,
        ),
      ),
    );
    await t.pumpAndSettle();
  }

  test(
    'social changes, conversations, groups and profile survive reload',
    () async {
      final p = store.posts.last;
      store.like(p);
      store.bookmark(p);
      store.comment(p, 'A new comment');
      final c = store.conversations.first;
      store.send(c, 'See you tomorrow');
      store.createGroup('Design friends', {'Reny Lewis'});
      store.publish('Weekend', 'A new moment', image: 'city');
      store.name = 'Jamie';
      store.signIn();
      await store.flush();
      final restored = await SocialStore.load();
      expect(restored.posts.first.text, 'Weekend\nA new moment');
      expect(restored.posts.last.saved, isTrue);
      expect(restored.posts.last.liked, isFalse);
      expect(restored.posts.last.comments.last, 'A new comment');
      expect(restored.conversations.first.name, 'Design friends');
      expect(
        restored.conversations.first.messages.single.text,
        contains('Reny Lewis'),
      );
      expect(restored.conversations[1].messages.last.text, 'See you tomorrow');
      expect(restored.name, 'Jamie');
      expect(restored.signedIn, isTrue);
    },
  );
  test('blank messages are ignored and malformed storage falls back', () async {
    store.send(store.conversations.first, '   ');
    expect(store.conversations.first.messages.length, 5);
    store.comment(store.posts.first, '  ');
    expect(store.posts.first.comments.length, 1);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(SocialStore.storageKey, '{broken');
    final fresh = await SocialStore.load();
    expect(fresh.posts.length, 2);
    expect(fresh.persistenceError, isNotNull);
  });
  testWidgets('login validates input then opens the feed', (t) async {
    await mount(t, const AuthScreen());
    await t.tap(find.text('Login'));
    await t.pumpAndSettle();
    expect(find.text('Enter your email or phone number'), findsOneWidget);
    await t.enterText(find.byType(TextFormField).at(0), 'demo@example.com');
    await t.enterText(find.byType(TextFormField).at(1), 'demo123');
    await t.tap(find.text('Login'));
    await t.pumpAndSettle();
    expect(find.text('Comuni'), findsOneWidget);
    expect(store.signedIn, isTrue);
  });
  testWidgets('publishing returns to feed and bookmarking updates favorites', (
    t,
  ) async {
    await mount(t, const AppShell());
    await t.tap(find.byTooltip('Create post'));
    await t.pumpAndSettle();
    await t.enterText(find.byType(TextFormField).at(0), 'Our new moment');
    await t.ensureVisible(find.text('Upload'));
    await t.tap(find.text('Upload'));
    await t.pumpAndSettle();
    expect(find.text('Our new moment'), findsOneWidget);
    expect(store.posts.first.author, store.name);
    await t.tap(find.byTooltip('Save ${store.posts.first.id}'));
    await t.pumpAndSettle();
    await mount(t, const FavoritesScreen());
    expect(find.text('Our new moment'), findsOneWidget);
  });
  testWidgets('search filters and adding a friend changes the Friends list', (
    t,
  ) async {
    await mount(t, const SearchScreen());
    await t.enterText(find.byType(TextField), 'unmatched');
    await t.pumpAndSettle();
    expect(find.text('No people found'), findsOneWidget);
    await t.enterText(find.byType(TextField), 'Thomas F 2');
    await t.pumpAndSettle();
    await t.tap(find.byTooltip('Add friend Thomas F 2'));
    await t.pumpAndSettle();
    await mount(t, const SearchScreen(friendsOnly: true));
    expect(find.text('Thomas F 2'), findsOneWidget);
  });
  testWidgets(
    'screens handle narrow, landscape and larger text without overflow',
    (t) async {
      for (final size in [const Size(360, 780), const Size(896, 414)]) {
        for (final page in [
          const OnboardingScreen(),
          const AuthScreen(register: true),
          const AppShell(),
          const ProfileScreen(public: true),
          const EditProfileScreen(),
          const CreateGroupScreen(),
          const ComposeScreen(),
          const SearchScreen(),
          ChatScreen(chat: store.conversations.first),
        ]) {
          await t.pumpWidget(const SizedBox());
          await mount(t, page, size: size, scale: 1.15);
          expect(t.takeException(), isNull, reason: '$page at $size');
        }
      }
    },
  );
}
