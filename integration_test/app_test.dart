import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:comuni_social/app.dart';
import 'package:comuni_social/data/social_store.dart';
import 'package:comuni_social/features/auth/auth_screens.dart';
import 'package:comuni_social/features/shell.dart';
import 'package:comuni_social/features/feed/feed_screens.dart';
import 'package:comuni_social/features/profile/profile_screens.dart';
import 'package:comuni_social/features/messaging/message_screens.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Android end-to-end journey and screen gallery', (t) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(SocialStore.storageKey);
    var store = await SocialStore.load();
    Future<void> shot(String name) async {
      FocusManager.instance.primaryFocus?.unfocus();
      await t.pumpAndSettle();
      final bytes = await binding.takeScreenshot(name);
      await File('/data/user/0/com.comuni.comuni_social/app_flutter/$name.png')
          .writeAsBytes(bytes);
    }

    Future<void> show(Widget page) async {
      await t.pumpWidget(const SizedBox());
      await t.pumpWidget(
        ComuniApp(
          key: UniqueKey(),
          store: store,
          home: page is AppShell ? page : const AppShell(),
        ),
      );
      await t.pumpAndSettle();
      if (page is! AppShell) {
        final context = t.element(find.byType(AppShell));
        Navigator.of(context)
            .push(MaterialPageRoute<void>(builder: (_) => page));
        await t.pumpAndSettle();
      }
    }

    await t.pumpWidget(ComuniApp(store: store));
    await binding.convertFlutterSurfaceToImage();
    await t.pump(const Duration(milliseconds: 100));
    await shot('01-splash');
    await t.pump(const Duration(seconds: 2));
    await t.pumpAndSettle();
    await shot('02-onboarding-1');
    await t.tap(find.byTooltip('Next'));
    await t.pumpAndSettle();
    await shot('03-onboarding-2');
    await t.tap(find.byTooltip('Next'));
    await t.pumpAndSettle();
    await shot('04-onboarding-3');
    await t.tap(find.byTooltip('Next'));
    await t.pumpAndSettle();
    await shot('05-welcome');
    await t.tap(find.text('Let’s Get Started'));
    await t.pumpAndSettle();
    await shot('06-register-empty');
    await t.enterText(find.byKey(const ValueKey('Full Name')), 'Aldebaror Reo');
    await t.enterText(
      find.byKey(const ValueKey('Enter Email / Phone Number')),
      'aldebaror@gmail.com',
    );
    await t.enterText(find.byKey(const ValueKey('Password')), 'demo123');
    await t.enterText(
      find.byKey(const ValueKey('Confirm Password')),
      'demo123',
    );
    await shot('07-register-filled');
    await t.ensureVisible(find.text('Register').last);
    await t.tap(find.text('Register').last);
    await t.pumpAndSettle();
    await shot('08-phone-empty');
    await t.enterText(find.byType(TextFormField), '+00 897654321789');
    await shot('09-phone-filled');
    await t.tap(find.text('Next'));
    await t.pumpAndSettle();
    await shot('10-verify-empty');
    await t.enterText(find.byType(TextField), '7835');
    await shot('11-verify-filled');
    await t.tap(find.text('Verify & Continue'));
    await t.pumpAndSettle();
    expect(find.text('Comuni'), findsOneWidget);
    await shot('16-home');
    final likes = store.posts.first.likes;
    await t.tap(find.byTooltip('Like text'));
    await t.pumpAndSettle();
    expect(store.posts.first.likes, likes - 1);
    await t.tap(find.byTooltip('Save text'));
    await t.pumpAndSettle();
    expect(store.posts.first.saved, isTrue);
    await t.tap(find.byTooltip('Comments text'));
    await t.pumpAndSettle();
    await t.enterText(find.byType(TextField), 'Happy to be here!');
    await t.tap(find.byTooltip('Send'));
    await t.pumpAndSettle();
    expect(store.posts.first.comments.last, 'Happy to be here!');
    await shot('18-comments');
    await t.pageBack();
    await t.pumpAndSettle();
    await t.tap(find.byKey(const ValueKey('nav-Messages')));
    await t.pumpAndSettle();
    await shot('21-messages');
    await t.tap(find.text('Reny Lewis').first);
    await t.pumpAndSettle();
    await shot('22-chat');
    await t.enterText(find.byType(TextField), 'See you at college!');
    await t.tap(find.byTooltip('Send'));
    await t.pumpAndSettle();
    expect(store.conversations.first.messages.last.text, 'See you at college!');
    await t.pageBack();
    await t.pumpAndSettle();
    await t.tap(find.byTooltip('Create group'));
    await t.pumpAndSettle();
    await shot('23-create-group');
    await t.ensureVisible(find.byType(CheckboxListTile).first);
    await t.tap(find.byType(CheckboxListTile).first);
    await t.ensureVisible(find.text('Create A Chat Group'));
    await t.tap(find.text('Create A Chat Group'));
    await t.pumpAndSettle();
    expect(find.text('Friends'), findsOneWidget);
    expect(store.conversations.first.name, 'Friends');
    await store.flush();
    final reloaded = await SocialStore.load();
    expect(reloaded.conversations.first.name, 'Friends');
    expect(reloaded.posts.first.comments.last, 'Happy to be here!');

    // Render each remaining real page using a clean repository for review images.
    await prefs.remove(SocialStore.storageKey);
    store = await SocialStore.load();
    await show(const AuthScreen());
    await shot('12-login-empty');
    await t.enterText(find.byType(TextFormField).first, 'john.parker@mail.com');
    await t.enterText(find.byType(TextFormField).last, 'demo123');
    await shot('13-login-filled');
    await show(const AuthScreen(forgot: true));
    await shot('14-forgot-empty');
    await t.enterText(find.byType(TextFormField), 'john.parker@mail.com');
    await shot('15-forgot-filled');
    await show(const AppShell(initialTab: 2));
    await shot('17-notifications');
    await show(const SearchScreen());
    await shot('19-search');
    await show(const ProfileScreen(public: true));
    await shot('20-public-profile');
    await show(PostDetailScreen(post: store.posts.last));
    await shot('24-post-detail');
    await show(const AppShell(initialTab: 3));
    await shot('25-my-profile');
    await t.tap(find.text('Edit'));
    await t.pumpAndSettle();
    await shot('26-edit-profile');
    await t.enterText(find.byType(TextFormField).first, 'Aldebaror Reo');
    await t.ensureVisible(find.text('Save'));
    await t.tap(find.text('Save'));
    await t.pumpAndSettle();
    expect(store.name, 'Aldebaror Reo');
    await show(const ComposeScreen());
    await shot('27-compose-empty');
    await t.tap(find.text('Upload your\nimage'));
    await t.pumpAndSettle();
    await t.tap(find.text('Use demo photo'));
    await t.pumpAndSettle();
    await t.enterText(find.byType(TextFormField).first, 'City Lights');
    await t.enterText(
      find.byType(TextFormField).last,
      'A little magic after sunset.',
    );
    await shot('28-compose-filled');
    // Publish through the shell so the new post can be verified in its destination.
    await show(const AppShell());
    await t.tap(find.byTooltip('Create post'));
    await t.pumpAndSettle();
    await t.enterText(find.byType(TextFormField).first, 'My first Comuni post');
    await t.ensureVisible(find.text('Upload'));
    await t.tap(find.text('Upload'));
    await t.pumpAndSettle();
    expect(find.text('My first Comuni post'), findsOneWidget);
    await shot('29-published');
    await show(const SettingsScreen());
    await shot('30-settings');
    await show(const StoryScreen());
    await shot('31-story');
    await show(const StoryScreen(live: true));
    await shot('32-live-story');
    await show(const FavoritesScreen());
    await shot('33-favorites-empty');
    store.bookmark(store.posts.last);
    await t.pumpAndSettle();
    await shot('34-favorites');
    await show(const MessagesScreen());
    final swipe = await t.startGesture(
      t.getCenter(find.byKey(const ValueKey('realbung'))),
    );
    await swipe.moveBy(const Offset(-100, 0));
    await t.pump(const Duration(milliseconds: 250));
    await shot('38-message-swipe');
    await swipe.moveBy(const Offset(-250, 0));
    await swipe.up();
    await t.pumpAndSettle();
    await shot('39-delete-confirmation');
    await t.tap(find.text('Delete'));
    await t.pumpAndSettle();
    expect(store.conversations.any((c) => c.id == 'realbung'), isFalse);
    await show(const AlbumScreen());
    await shot('35-albums');
    await show(const SearchScreen(friendsOnly: true));
    await shot('36-friends-empty');
    await show(const SearchScreen());
    await t.tap(find.byTooltip('Add friend Thomas F'));
    await t.pumpAndSettle();
    await show(const SearchScreen(friendsOnly: true));
    await shot('37-friends');
    await store.flush();
    expect(t.takeException(), isNull);
    // Leave a clean authenticated demo for manual review after the test.
    await prefs.remove(SocialStore.storageKey);
    store = await SocialStore.load();
    store.signIn();
    await store.flush();
    await show(const AppShell());
    await Future<void>.delayed(const Duration(seconds: 4));
  });
}
