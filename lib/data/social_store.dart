import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models.dart';

/// Local repository and application state; no network account is implied.
class SocialStore extends ChangeNotifier {
  SocialStore(this._prefs);
  final SharedPreferences _prefs;
  static const storageKey = 'comuni.v1';
  bool onboarded = false, signedIn = false, following = true;
  bool notificationsEnabled = true;
  String name = 'Aldebaror Reo', email = 'aldebaror@gmail.com';
  String location = 'United State', phone = '+00 897654321789';
  String? avatarPhoto;
  final Set<String> friends = {};
  late List<Post> posts = _seedPosts();
  late List<Conversation> conversations = _seedChats();
  Future<void> _writes = Future.value();
  String? persistenceError;

  static Future<SocialStore> load() async {
    final s = SocialStore(await SharedPreferences.getInstance());
    final raw = s._prefs.getString(storageKey);
    if (raw != null) {
      try {
        final j = jsonDecode(raw) as Map<String, dynamic>;
        s.onboarded = j['onboarded'];
        s.signedIn = j['signedIn'];
        s.following = j['following'];
        s.notificationsEnabled = j['notificationsEnabled'];
        s.name = j['name'];
        s.email = j['email'];
        s.location = j['location'];
        s.phone = j['phone'];
        s.avatarPhoto = j['avatarPhoto'];
        s.friends.addAll(List<String>.from(j['friends']));
        s.posts = (j['posts'] as List).map((p) => Post.fromJson(p)).toList();
        s.conversations = (j['conversations'] as List)
            .map((c) => Conversation.fromJson(c))
            .toList();
      } catch (_) {
        return SocialStore(s._prefs)
          ..persistenceError =
              'Saved demo data could not be read. A fresh demo was opened.';
      }
    }
    return s;
  }

  Map<String, dynamic> _snapshot() => {
    'onboarded': onboarded,
    'signedIn': signedIn,
    'following': following,
    'notificationsEnabled': notificationsEnabled,
    'name': name,
    'email': email,
    'location': location,
    'phone': phone,
    'avatarPhoto': avatarPhoto,
    'friends': friends.toList(),
    'posts': posts.map((p) => p.toJson()).toList(),
    'conversations': conversations.map((c) => c.toJson()).toList(),
  };
  void save() {
    final encoded = jsonEncode(_snapshot());
    notifyListeners();
    _writes = _writes.then((_) async {
      try {
        if (!await _prefs.setString(storageKey, encoded)) {
          throw StateError('Storage full');
        }
      } catch (_) {
        persistenceError =
            'Could not save locally. Please free some device storage.';
        notifyListeners();
      }
    });
  }

  Future<void> flush() => _writes;
  void like(Post p) {
    p.liked = !p.liked;
    p.likes += p.liked ? 1 : -1;
    save();
  }

  void bookmark(Post p) {
    p.saved = !p.saved;
    save();
  }

  void comment(Post p, String text) {
    if (text.trim().isEmpty) return;
    p.comments.add(text.trim());
    save();
  }

  void send(Conversation c, String text) {
    if (text.trim().isEmpty) return;
    final now = TimeOfDay.now();
    final time =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    c.messages.add(ChatMessage(text.trim(), mine: true, time: time));
    c.preview = text.trim();
    save();
  }

  void publish(
    String title,
    String description, {
    String? image,
    String? photo,
  }) {
    posts.insert(
      0,
      Post(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        author: name,
        avatar: 'me',
        role: 'Just now',
        text: [
          title.trim(),
          description.trim(),
        ].where((s) => s.isNotEmpty).join('\n'),
        image: image,
        photo: photo,
      ),
    );
    save();
  }

  Conversation createGroup(String title, Set<String> members) {
    final c = Conversation(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: title.trim(),
      avatar: 'highlight-2',
      today: true,
      preview: '${members.length + 1} members · Group created',
      messages: [
        ChatMessage('You created this group with ${members.join(', ')}.'),
      ],
    );
    conversations.insert(0, c);
    save();
    return c;
  }

  void signIn() {
    signedIn = true;
    onboarded = true;
    save();
  }

  void signOut() {
    signedIn = false;
    save();
  }

  static List<Post> _seedPosts() => [
    Post(
      id: 'text',
      author: 'Alexender Walker',
      avatar: 'alex',
      role: 'Enginnering Student',
      likes: 127,
      liked: true,
      text: 'Dummy Text Is Also Used To Demonstrate The Appearance Of Different Typefaces And Layouts, Sed To Demonstrate The Appearance Of Different',
      comments: [
        'Hello Everyone, How are you today? Hope you all are fine and blessed everyday!',
      ],
    ),
    Post(
      id: 'city',
      author: 'Jessica Jones',
      avatar: 'jessica',
      role: 'Socialist',
      image: 'city',
      likes: 325,
      liked: true,
      comments: [
        'What a beautiful view!',
        'The city looks incredible at night.',
        'Love these lights.',
      ],
    ),
  ];
  static List<Conversation> _seedChats() => [
    Conversation(
      id: 'reny',
      name: 'Reny Lewis',
      avatar: 'reny',
      preview: 'Please confirm the friendship...',
      unread: 5,
      today: true,
      messages: _chat(),
    ),
    Conversation(
      id: 'jessica',
      name: 'Jessica Jones',
      avatar: 'jessica',
      preview: 'I’m On Vocation Ron...',
      unread: 1,
      today: true,
      messages: [ChatMessage('I’m on vacation! Look at the view from here.')],
    ),
    Conversation(
      id: 'alex',
      name: 'Alexender Walker',
      avatar: 'alex',
      preview: 'I’ve Gone Through The Procedure ...',
      messages: _chat(),
    ),
    Conversation(
      id: 'realbung',
      name: 'Realbung Khar',
      avatar: 'realbung',
      preview: 'How are you, friend? long time...',
    ),
    Conversation(
      id: 'anjelina',
      name: 'Anjelina Rumour',
      avatar: 'anjelina',
      preview: 'I have a job as a foreman...',
    ),
    Conversation(
      id: 'terris',
      name: 'Terris Ronad',
      avatar: 'terris',
      preview: 'Where are you going at night...',
    ),
  ];
  static List<ChatMessage> _chat() => [
    ChatMessage(
      'Hi, How’re You. I’m Jackson From College. Hope You’ll Be Fine And Also Your Family Areeta. Waiting for your Reply !',
      mine: true,
      time: '10:54',
    ),
    ChatMessage('Yes we are fine, wow really nice', time: '11:25'),
    ChatMessage('Please, Can you give me Notes', mine: true, time: '11:29'),
    ChatMessage('Ok, I give you But Where!', time: '11:30'),
    ChatMessage('Thanks, At College', mine: true),
  ];
}

class StoreScope extends InheritedNotifier<SocialStore> {
  const StoreScope({
    super.key,
    required SocialStore store,
    required super.child,
  }) : super(notifier: store);
  static SocialStore of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<StoreScope>()!.notifier!;
}
