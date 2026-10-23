import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/social_store.dart';
import '../../ui/theme.dart';
import '../../ui/widgets.dart';

class ComposeScreen extends StatefulWidget {
  const ComposeScreen({super.key});
  @override
  State<ComposeScreen> createState() => _ComposeScreenState();
}

class _ComposeScreenState extends State<ComposeScreen> {
  final title = TextEditingController(), description = TextEditingController();
  final form = GlobalKey<FormState>();
  String? photo, image;
  bool picking = false;
  @override
  void dispose() {
    title.dispose();
    description.dispose();
    super.dispose();
  }

  Future<void> pick() async {
    final source = await showModalBottomSheet<String>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Choose from device'),
              onTap: () => Navigator.pop(ctx, 'device'),
            ),
            ListTile(
              leading: const Icon(Icons.landscape_outlined),
              title: const Text('Use demo photo'),
              onTap: () => Navigator.pop(ctx, 'demo'),
            ),
          ],
        ),
      ),
    );
    if (!mounted || source == null) return;
    if (source == 'demo') {
      setState(() {
        image = 'city';
        photo = null;
      });
      return;
    }
    setState(() => picking = true);
    try {
      final file = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 80,
      );
      if (file != null) {
        final bytes = await file.readAsBytes();
        if (bytes.length > 5 * 1024 * 1024) {
          throw StateError('Please choose an image smaller than 5 MB');
        }
        if (mounted) {
          setState(() {
            photo = base64Encode(bytes);
            image = null;
          });
        }
      }
    } catch (_) {
      if (mounted) {
        toast(
          context,
          'Could not open photo. Try another image or use the demo photo.',
        );
      }
    } finally {
      if (mounted) setState(() => picking = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(),
    body: ListView(
      padding: const EdgeInsets.fromLTRB(35, 8, 35, 35),
      children: [
        const Text(
          'Post New Status',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 23, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 26),
        InkWell(
          onTap: picking ? null : pick,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            height: 238,
            decoration: BoxDecoration(
              color: const Color(0xFFE9E5FF),
              borderRadius: BorderRadius.circular(20),
            ),
            child: image != null || photo != null
                ? Stack(
                    fit: StackFit.expand,
                    children: [
                      AppPhoto(image ?? 'city', photo: photo, radius: 20),
                      const Positioned(
                        bottom: 10,
                        right: 10,
                        child: Chip(
                          label: Text('Change photo'),
                          avatar: Icon(Icons.edit, size: 16),
                        ),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        picking
                            ? Icons.hourglass_empty
                            : Icons.add_photo_alternate_outlined,
                        color: AppColors.purple,
                        size: 45,
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'Upload your\nimage',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.purple),
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        'Max Size : 5 MB',
                        style: TextStyle(fontSize: 10, color: AppColors.muted),
                      ),
                    ],
                  ),
          ),
        ),
        const SizedBox(height: 34),
        Form(
          key: form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Title',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: title,
                maxLength: 80,
                decoration: const InputDecoration(
                  hintText: 'Give your moment a title',
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Add a title' : null,
              ),
              const SizedBox(height: 24),
              const Text(
                'Description',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: description,
                maxLines: 4,
                maxLength: 500,
                decoration: const InputDecoration(
                  hintText: 'Tell your story...',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 35),
        GradientButton(
          'Upload',
          onPressed: picking
              ? null
              : () {
                  if (!form.currentState!.validate()) return;
                  StoreScope.of(context).publish(
                    title.text,
                    description.text,
                    image: image,
                    photo: photo,
                  );
                  Navigator.pop(context, true);
                  toast(context, 'Your moment has been published');
                },
        ),
      ],
    ),
  );
}
