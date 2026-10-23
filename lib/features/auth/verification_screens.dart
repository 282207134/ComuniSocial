import 'dart:async';

import 'package:flutter/material.dart';

import '../../data/social_store.dart';
import '../../ui/theme.dart';
import '../../ui/widgets.dart';

import 'auth_navigation.dart';

class PhoneScreen extends StatefulWidget {
  const PhoneScreen({super.key, required this.name, required this.email});
  final String name, email;
  @override
  State<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  final phone = TextEditingController();
  final form = GlobalKey<FormState>();
  @override
  void dispose() {
    phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(),
    body: ListView(
      padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 36),
      children: [
        const Text(
          'Register',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 50),
        const Text('Please Enter Your Phone Number, So\nWe Can Verify You.'),
        const SizedBox(height: 62),
        const Text(
          'Enter Your Phone Number',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        Form(
          key: form,
          child: TextFormField(
            controller: phone,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              hintText: '+00 000 0000',
              prefixIcon: Icon(Icons.phone_outlined),
            ),
            validator: (v) =>
                RegExp(r'^\+?[\d\s-]{7,18}$').hasMatch(v?.trim() ?? '')
                ? null
                : 'Enter a valid phone number',
          ),
        ),
        const SizedBox(height: 35),
        GradientButton(
          'Next',
          round: false,
          onPressed: () {
            if (!form.currentState!.validate()) return;
            openPage(
              context,
              VerifyScreen(
                name: widget.name,
                email: widget.email,
                phone: phone.text.trim(),
              ),
            );
          },
        ),
        const SizedBox(height: 35),
        const Text(
          'Demo verification code: 7835',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, color: AppColors.muted),
        ),
      ],
    ),
  );
}

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
  });
  final String name, email, phone;
  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final code = TextEditingController();
  Timer? timer;
  int seconds = 0;
  String? error;
  @override
  void dispose() {
    timer?.cancel();
    code.dispose();
    super.dispose();
  }

  void verify() {
    if (code.text != '7835') {
      setState(() => error = 'Use demo code 7835');
      return;
    }
    final s = StoreScope.of(context);
    s.name = widget.name;
    s.email = widget.email;
    s.phone = widget.phone;
    enterApp(context);
  }

  void resend() {
    setState(() => seconds = 30);
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() => seconds--);
      if (seconds == 0) t.cancel();
    });
    toast(context, 'Demo code: 7835. No SMS is sent.');
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(),
    body: ListView(
      padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 65),
      children: [
        const Text(
          'Verify Code',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        Text(
          'Check Your SMS Inbox, We Have Sent\nYou The Code At ${widget.phone}',
        ),
        const SizedBox(height: 80),
        TextField(
          controller: code,
          keyboardType: TextInputType.number,
          maxLength: 4,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 34,
            letterSpacing: 22,
            fontWeight: FontWeight.w600,
            color: AppColors.purple,
          ),
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            hintText: '— — — —',
            counterText: '',
            errorText: error,
          ),
        ),
        const SizedBox(height: 24),
        Center(
          child: TextButton(
            onPressed: seconds == 0 ? resend : null,
            child: Text(
              seconds == 0
                  ? 'Didn’t Receive A Code?  Resend Code'
                  : 'Resend in ${seconds}s',
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ),
        const SizedBox(height: 30),
        GradientButton(
          'Verify & Continue',
          onPressed: code.text.length == 4 ? verify : null,
        ),
        const SizedBox(height: 18),
        const Text(
          'Local demo · enter 7835',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.muted, fontSize: 12),
        ),
      ],
    ),
  );
}
