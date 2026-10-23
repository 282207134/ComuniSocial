import 'package:flutter/material.dart';

import '../../ui/theme.dart';
import '../../ui/widgets.dart';

import 'auth_navigation.dart';
import 'verification_screens.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key, this.register = false, this.forgot = false});
  final bool register, forgot;
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final form = GlobalKey<FormState>();
  final name = TextEditingController(), email = TextEditingController();
  final password = TextEditingController(), confirm = TextEditingController();
  bool obscured = true, confirmObscured = true;
  @override
  void dispose() {
    for (final c in [name, email, password, confirm]) {
      c.dispose();
    }
    super.dispose();
  }

  String? validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) {
      return 'Enter your email or phone number';
    }
    if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(v.trim()) &&
        !RegExp(r'^\+?[\d\s-]{7,18}$').hasMatch(v.trim())) {
      return 'Enter a valid email or phone number';
    }
    return null;
  }

  void submit() {
    if (!form.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    if (widget.forgot) {
      showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Reset request prepared'),
          content: const Text(
            'This is a local demo. No reset email or SMS is sent. Return to Log In with any valid email and a password of 6 or more characters.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pop(context);
              },
              child: const Text('Back to Log In'),
            ),
          ],
        ),
      );
    } else if (widget.register) {
      openPage(
        context,
        PhoneScreen(name: name.text.trim(), email: email.text.trim()),
      );
    } else {
      enterApp(context);
    }
  }

  Widget field(
    String hint,
    TextEditingController c, {
    bool secret = false,
    bool isConfirm = false,
    String? Function(String?)? validator,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: TextFormField(
      key: ValueKey(hint),
      controller: c,
      validator: validator,
      obscureText: secret && (isConfirm ? confirmObscured : obscured),
      keyboardType: secret
          ? TextInputType.visiblePassword
          : hint.contains('Email')
          ? TextInputType.emailAddress
          : TextInputType.text,
      decoration: InputDecoration(
        hintText: hint,
        suffixIcon: secret
            ? IconButton(
                tooltip: 'Show password',
                onPressed: () => setState(() {
                  if (isConfirm) {
                    confirmObscured = !confirmObscured;
                  } else {
                    obscured = !obscured;
                  }
                }),
                icon: Icon(
                  (isConfirm ? confirmObscured : obscured)
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: 18,
                  color: AppColors.muted,
                ),
              )
            : null,
      ),
    ),
  );
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: widget.forgot ? AppBar() : null,
    body: SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(35, widget.forgot ? 50 : 88, 35, 30),
        child: Form(
          key: form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.forgot
                    ? 'Forget Password'
                    : widget.register
                    ? 'Register'
                    : 'Log In',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 46),
              if (!widget.forgot) ...[
                Row(
                  children: [
                    for (final entry in [
                      ('GOOGLE', const Color(0xFFD4473B)),
                      ('FACEBOOK', const Color(0xFF4666AA)),
                    ])
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: entry.$1 == 'GOOGLE' ? 10 : 0,
                          ),
                          child: ElevatedButton(
                            onPressed: () => showDialog<void>(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: Text('${entry.$1} sign in'),
                                content: const Text(
                                  'Provider sign in is not connected in this local demo. Use the form below to explore Comuni.',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx),
                                    child: const Text('Got it'),
                                  ),
                                ],
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: entry.$2,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            child: Text(
                              entry.$1,
                              style: const TextStyle(
                                fontSize: 10,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 30),
                  child: Center(
                    child: Text(
                      'OR',
                      style: TextStyle(
                        color: AppColors.muted,
                        fontSize: 11,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
              ] else ...[
                const Text(
                  'Please Enter Your Email Address /\nPhone Number To Reset Your Password',
                ),
                const SizedBox(height: 65),
              ],
              if (widget.register)
                field(
                  'Full Name',
                  name,
                  validator: (v) => v == null || v.trim().length < 2
                      ? 'Enter your full name'
                      : null,
                ),
              field(
                'Enter Email / Phone Number',
                email,
                validator: validateEmail,
              ),
              if (!widget.forgot)
                field(
                  'Password',
                  password,
                  secret: true,
                  validator: (v) =>
                      (v?.length ?? 0) < 6 ? 'Use at least 6 characters' : null,
                ),
              if (widget.register)
                field(
                  'Confirm Password',
                  confirm,
                  secret: true,
                  isConfirm: true,
                  validator: (v) =>
                      v != password.text ? 'Passwords do not match' : null,
                ),
              if (!widget.register && !widget.forgot)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () =>
                        openPage(context, const AuthScreen(forgot: true)),
                    child: const Text(
                      'Forget Password?',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              const SizedBox(height: 22),
              GradientButton(
                widget.forgot
                    ? 'Send'
                    : widget.register
                    ? 'Register'
                    : 'Login',
                round: false,
                onPressed: submit,
              ),
              if (!widget.forgot) ...[
                const SizedBox(height: 52),
                Center(
                  child: Text(
                    widget.register
                        ? 'Already Have An Account?'
                        : 'Don’t Have An Account?',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                Center(
                  child: TextButton(
                    onPressed: () => openPage(
                      context,
                      AuthScreen(register: !widget.register),
                    ),
                    child: Text(
                      widget.register ? 'LOGIN' : 'REGISTER',
                      style: const TextStyle(fontSize: 11, letterSpacing: 3),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Center(
                  child: Text(
                    'Local demo · no real account required',
                    style: TextStyle(color: AppColors.muted, fontSize: 10),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    ),
  );
}
