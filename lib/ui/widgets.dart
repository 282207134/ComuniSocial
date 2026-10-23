import 'dart:convert';

import 'package:flutter/material.dart';

import 'theme.dart';

Future<T?> openPage<T>(BuildContext context, Widget page) =>
    Navigator.of(context).push<T>(MaterialPageRoute(builder: (_) => page));
void toast(BuildContext context, String message) =>
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));

class GradientButton extends StatelessWidget {
  const GradientButton(
    this.label, {
    super.key,
    this.onPressed,
    this.icon,
    this.round = true,
  });
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool round;
  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      gradient: onPressed == null ? null : AppColors.gradient,
      color: onPressed == null ? const Color(0xFFB6B6B6) : null,
      borderRadius: BorderRadius.circular(round ? 28 : 6),
    ),
    child: TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        minimumSize: const Size(double.infinity, 56),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(round ? 28 : 6),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          if (icon != null) ...[
            const SizedBox(width: 20),
            Icon(icon, size: 23),
          ],
        ],
      ),
    ),
  );
}

class AppPhoto extends StatelessWidget {
  const AppPhoto(
    this.asset, {
    super.key,
    this.photo,
    this.width,
    this.height,
    this.radius = 0,
    this.fit = BoxFit.cover,
  });
  final String asset;
  final String? photo;
  final double? width, height;
  final double radius;
  final BoxFit fit;
  @override
  Widget build(BuildContext context) {
    final fallback = Image.asset(
      'assets/images/$asset.png',
      width: width,
      height: height,
      fit: fit,
    );
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: photo == null
          ? fallback
          : Image.memory(
              base64Decode(photo!),
              width: width,
              height: height,
              fit: fit,
              errorBuilder: (_, _, _) => fallback,
            ),
    );
  }
}

class Avatar extends StatelessWidget {
  const Avatar(this.asset, {super.key, this.size = 46, this.photo});
  final String asset;
  final double size;
  final String? photo;
  @override
  Widget build(BuildContext context) => AppPhoto(
    asset,
    photo: photo,
    width: size,
    height: size,
    radius: size / 2,
  );
}

class SoftCard extends StatelessWidget {
  const SoftCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });
  final Widget child;
  final EdgeInsets padding;
  @override
  Widget build(BuildContext context) => Container(
    padding: padding,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      boxShadow: const [AppColors.shadow],
    ),
    child: child,
  );
}

class SearchBox extends StatelessWidget {
  const SearchBox({
    super.key,
    this.hint = 'Find your friends?',
    this.onChanged,
    this.controller,
  });
  final String hint;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  @override
  Widget build(BuildContext context) => TextField(
    controller: controller,
    onChanged: onChanged,
    decoration: InputDecoration(
      hintText: hint,
      prefixIcon: const Icon(Icons.search, color: AppColors.purple),
    ),
  );
}

class EmptyState extends StatelessWidget {
  const EmptyState(this.title, this.subtitle, {super.key});
  final String title, subtitle;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 25),
    child: Column(
      children: [
        const Icon(Icons.inbox_outlined, size: 48, color: AppColors.purple),
        const SizedBox(height: 18),
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    ),
  );
}

class MessageComposer extends StatefulWidget {
  const MessageComposer({
    super.key,
    required this.onSend,
    this.hint = 'Type comment...',
    this.avatar,
  });
  final ValueChanged<String> onSend;
  final String hint;
  final String? avatar;
  @override
  State<MessageComposer> createState() => _MessageComposerState();
}

class _MessageComposerState extends State<MessageComposer> {
  final controller = TextEditingController();
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void send() {
    if (controller.text.trim().isEmpty) return;
    widget.onSend(controller.text);
    controller.clear();
  }

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.fromLTRB(24, 12, 24, 20),
    padding: const EdgeInsets.only(left: 10, right: 4),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(32),
      boxShadow: const [
        BoxShadow(
          color: Color(0x227C6AF3),
          blurRadius: 24,
          offset: Offset(0, 8),
        ),
      ],
    ),
    child: Row(
      children: [
        if (widget.avatar != null) Avatar(widget.avatar!, size: 36),
        Expanded(
          child: TextField(
            controller: controller,
            onSubmitted: (_) => send(),
            textInputAction: TextInputAction.send,
            decoration: InputDecoration(
              hintText: widget.hint,
              fillColor: Colors.white,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
          ),
        ),
        IconButton(
          tooltip: 'Send',
          onPressed: send,
          icon: const Icon(
            Icons.send_rounded,
            color: AppColors.purple,
            size: 22,
          ),
        ),
      ],
    ),
  );
}
