import 'package:flutter/material.dart';

import 'data/social_store.dart';
import 'features/auth/auth_screens.dart';
import 'ui/theme.dart';

class ComuniApp extends StatelessWidget {
  const ComuniApp({super.key, required this.store, this.home});
  final SocialStore store;
  final Widget? home;
  @override
  Widget build(BuildContext context) => StoreScope(
    store: store,
    child: MaterialApp(
      title: 'Comuni',
      debugShowCheckedModeBanner: false,
      theme: appTheme(),
      builder: (context, child) => ColoredBox(
        color: const Color(0xFFF5F5FA),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: child!,
          ),
        ),
      ),
      home: home ?? const SplashScreen(),
    ),
  );
}
