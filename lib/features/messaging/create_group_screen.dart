import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../data/social_store.dart';
import '../../ui/theme.dart';
import '../../ui/widgets.dart';

import 'chat_screen.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});
  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final name = TextEditingController(text: 'Friends');
  final form = GlobalKey<FormState>();
  String template = 'Friends';
  final selected = <String>{};
  @override
  void dispose() {
    name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = StoreScope.of(context);
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(35, 12, 35, 30),
        children: [
          const Text(
            'Create Your Group',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 23, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          const Text(
            'Your group is where you and your friends\nhang out. Make yours and start talking.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.muted, fontSize: 13),
          ),
          const SizedBox(height: 34),
          Form(
            key: form,
            child: TextFormField(
              controller: name,
              maxLength: 40,
              decoration: const InputDecoration(
                hintText: 'Create My Own',
                labelText: 'Group name',
              ),
              validator: (v) => v == null || v.trim().isEmpty
                  ? 'Give your group a name'
                  : null,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Choose template',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          for (final t in [
            ('Family', CupertinoIcons.person_3),
            ('Friends', CupertinoIcons.person_2),
            ('Study Group', CupertinoIcons.book),
            ('Webinar', CupertinoIcons.videocam),
            ('Community', CupertinoIcons.globe),
          ])
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Material(
                color: template == t.$1
                    ? const Color(0xFFECE8FF)
                    : AppColors.field,
                borderRadius: BorderRadius.circular(8),
                child: ListTile(
                  dense: true,
                  leading: Icon(t.$2, color: AppColors.purple),
                  title: Text(
                    t.$1,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  trailing: template == t.$1
                      ? const Icon(
                          Icons.check_circle,
                          color: AppColors.purple,
                          size: 20,
                        )
                      : null,
                  onTap: () => setState(() {
                    template = t.$1;
                    name.text = t.$1;
                  }),
                ),
              ),
            ),
          const SizedBox(height: 12),
          const Text(
            'Add friends',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          for (final c
              in s.conversations
                  .where((c) => !c.id.contains(RegExp(r'^\d')))
                  .take(3))
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              secondary: Avatar(c.avatar, size: 34),
              title: Text(c.name, style: const TextStyle(fontSize: 13)),
              value: selected.contains(c.name),
              onChanged: (v) => setState(() {
                v == true ? selected.add(c.name) : selected.remove(c.name);
              }),
            ),
          const SizedBox(height: 22),
          GradientButton(
            'Create A Chat Group',
            onPressed: () {
              if (!form.currentState!.validate()) return;
              if (selected.isEmpty) {
                toast(context, 'Choose at least one friend');
                return;
              }
              final c = s.createGroup(name.text, selected);
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => ChatScreen(chat: c)),
              );
            },
          ),
        ],
      ),
    );
  }
}
