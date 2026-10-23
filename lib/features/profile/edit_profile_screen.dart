import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/social_store.dart';
import '../../ui/theme.dart';
import '../../ui/widgets.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final form = GlobalKey<FormState>();
  final name = TextEditingController(), email = TextEditingController();
  final location = TextEditingController(), phone = TextEditingController();
  String? photo;
  bool loaded = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (loaded) return;
    final s = StoreScope.of(context);
    name.text = s.name;
    email.text = s.email;
    location.text = s.location;
    phone.text = s.phone;
    photo = s.avatarPhoto;
    loaded = true;
  }

  @override
  void dispose() {
    for (final c in [name, email, location, phone]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> pick() async {
    try {
      final f = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 400,
        maxHeight: 400,
        imageQuality: 80,
      );
      if (f != null) {
        final bytes = await f.readAsBytes();
        if (mounted) setState(() => photo = base64Encode(bytes));
      }
    } catch (_) {
      if (mounted) toast(context, 'Could not open your photo library');
    }
  }

  Widget field(String label, TextEditingController c, TextInputType type) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            TextFormField(
              controller: c,
              keyboardType: type,
              decoration: InputDecoration(
                hintText: label,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return '$label is required';
                if (label == 'Email' &&
                    !RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(v.trim())) {
                  return 'Enter a valid email';
                }
                if (label == 'Phone Number' &&
                    !RegExp(r'^\+?[\d\s-]{7,18}$').hasMatch(v.trim())) {
                  return 'Enter a valid phone number';
                }
                return null;
              },
            ),
          ],
        ),
      );
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Edit Profile')),
    body: ListView(
      padding: const EdgeInsets.fromLTRB(35, 15, 35, 40),
      children: [
        Center(
          child: Stack(
            children: [
              Avatar('me', photo: photo, size: 86),
              Positioned(
                right: -4,
                bottom: -4,
                child: IconButton(
                  tooltip: 'Change avatar',
                  onPressed: pick,
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.purple,
                  ),
                  icon: const Icon(
                    Icons.camera_alt_outlined,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 45),
        Form(
          key: form,
          child: Column(
            children: [
              field('Username', name, TextInputType.name),
              field('Email', email, TextInputType.emailAddress),
              field('Location', location, TextInputType.text),
              field('Phone Number', phone, TextInputType.phone),
            ],
          ),
        ),
        const SizedBox(height: 22),
        GradientButton(
          'Save',
          onPressed: () {
            if (!form.currentState!.validate()) return;
            final s = StoreScope.of(context);
            s.name = name.text.trim();
            s.email = email.text.trim();
            s.location = location.text.trim();
            s.phone = phone.text.trim();
            s.avatarPhoto = photo;
            s.save();
            Navigator.pop(context);
            toast(context, 'Profile saved');
          },
        ),
      ],
    ),
  );
}
