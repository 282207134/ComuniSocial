class Post {
  Post({
    required this.id,
    required this.author,
    required this.avatar,
    this.role = '',
    this.text = '',
    this.image,
    this.photo,
    this.likes = 0,
    this.liked = false,
    this.saved = false,
    List<String>? comments,
  }) : comments = comments ?? [];
  final String id, author, avatar, role, text;
  final String? image, photo;
  int likes;
  bool liked, saved;
  final List<String> comments;
  Map<String, dynamic> toJson() => {
    'id': id,
    'author': author,
    'avatar': avatar,
    'role': role,
    'text': text,
    'image': image,
    'photo': photo,
    'likes': likes,
    'liked': liked,
    'saved': saved,
    'comments': comments,
  };
  factory Post.fromJson(Map<String, dynamic> j) => Post(
    id: j['id'],
    author: j['author'],
    avatar: j['avatar'],
    role: j['role'],
    text: j['text'],
    image: j['image'],
    photo: j['photo'],
    likes: j['likes'],
    liked: j['liked'],
    saved: j['saved'],
    comments: List<String>.from(j['comments']),
  );
}

class ChatMessage {
  ChatMessage(this.text, {this.mine = false, this.time = '11:32'});
  final String text, time;
  final bool mine;
  Map<String, dynamic> toJson() => {'text': text, 'mine': mine, 'time': time};
  factory ChatMessage.fromJson(Map<String, dynamic> j) =>
      ChatMessage(j['text'], mine: j['mine'], time: j['time']);
}

class Conversation {
  Conversation({
    required this.id,
    required this.name,
    required this.avatar,
    required this.preview,
    this.unread = 0,
    this.today = false,
    List<ChatMessage>? messages,
  }) : messages = messages ?? [];
  final String id, name, avatar;
  String preview;
  int unread;
  final bool today;
  final List<ChatMessage> messages;
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'avatar': avatar,
    'preview': preview,
    'unread': unread,
    'today': today,
    'messages': messages.map((m) => m.toJson()).toList(),
  };
  factory Conversation.fromJson(Map<String, dynamic> j) => Conversation(
    id: j['id'],
    name: j['name'],
    avatar: j['avatar'],
    preview: j['preview'],
    unread: j['unread'],
    today: j['today'],
    messages: (j['messages'] as List)
        .map((m) => ChatMessage.fromJson(m))
        .toList(),
  );
}
