import 'package:flutter/material.dart';

import '../../data/social_store.dart';
import '../shell.dart';

void enterApp(BuildContext context) {
  StoreScope.of(context).signIn();
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (_) => const AppShell()),
    (_) => false,
  );
}
