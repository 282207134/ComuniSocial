import 'dart:async';

import 'package:flutter/material.dart';

import '../../data/social_store.dart';
import '../../ui/theme.dart';
import '../../ui/widgets.dart';
import '../shell.dart';

import 'auth_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? timer;
  @override
  void initState() {
    super.initState();
    timer = Timer(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      final s = StoreScope.of(context);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => s.signedIn
              ? const AppShell()
              : s.onboarded
              ? const AuthScreen()
              : const OnboardingScreen(),
        ),
      );
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Stack(
      children: [
        const Center(child: AppPhoto('logo', width: 116, height: 116)),
        const Positioned(
          bottom: 60,
          left: 0,
          right: 0,
          child: Text(
            'FROM SOCIAL-X',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.muted,
              letterSpacing: 6,
              fontSize: 12,
            ),
          ),
        ),
      ],
    ),
  );
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final pages = PageController();
  int index = 0;
  static const titles = [
    'Welcome To The Fun\nMagic Media',
    'Best Social App To\nMake New Friends',
    'Enjoy Your Life\nEvery Time',
  ];
  @override
  void dispose() {
    pages.dispose();
    super.dispose();
  }

  void finish() {
    final store = StoreScope.of(context);
    store.onboarded = true;
    store.save();
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const WelcomeScreen()));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: finish,
              child: const Text(
                'Skip',
                style: TextStyle(color: AppColors.muted),
              ),
            ),
          ),
          Expanded(
            child: PageView.builder(
              controller: pages,
              itemCount: 3,
              onPageChanged: (v) => setState(() => index = v),
              itemBuilder: (_, i) => LayoutBuilder(
                builder: (context, bounds) => SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: bounds.maxHeight),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        children: [
                          SizedBox(height: bounds.maxHeight * .06),
                          AppPhoto(
                            'onboarding-${i + 1}',
                            width: 370,
                            height: bounds.maxHeight * .45,
                            fit: BoxFit.contain,
                          ),
                          SizedBox(height: bounds.maxHeight * .10),
                          Text(
                            titles[i],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w600,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 18),
                          const Text(
                            'Dummy Text Is Also Used To Demonstrate\nThe Appearance Of Different Typefaces\nAnd Layouts',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.muted,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 12, 30, 26),
            child: Row(
              children: [
                const SizedBox(width: 48),
                const Spacer(),
                ...List.generate(
                  3,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: i == index ? 57 : 25,
                    height: 10,
                    margin: const EdgeInsets.only(right: 5),
                    decoration: BoxDecoration(
                      gradient: i == index ? AppColors.gradient : null,
                      color: i == index ? null : const Color(0xFFD8D8D8),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const Spacer(),
                IconButton(
                  tooltip: 'Next',
                  onPressed: () => index == 2
                      ? finish()
                      : pages.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                        ),
                  icon: const Icon(
                    Icons.arrow_forward,
                    color: AppColors.purple,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    body: Stack(
      children: [
        const Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: CustomPaint(
            size: Size(double.infinity, 220),
            painter: _WelcomeAccent(),
          ),
        ),
        const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'WELCOME',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 38),
              ),
              SizedBox(height: 14),
              SizedBox(
                width: 52,
                child: Divider(color: AppColors.ink, thickness: 3),
              ),
              SizedBox(height: 12),
              Text(
                'OUR APP LATEST FEATURES\nMAKE YOU CRAZY',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, height: 1.5),
              ),
            ],
          ),
        ),
        Positioned(
          left: 54,
          right: 54,
          bottom: 90,
          child: GradientButton(
            'Let’s Get Started',
            icon: Icons.arrow_circle_right,
            onPressed: () =>
                openPage(context, const AuthScreen(register: true)),
          ),
        ),
      ],
    ),
  );
}

class _WelcomeAccent extends CustomPainter {
  const _WelcomeAccent();
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    Path edge(double offset) => Path()
      ..moveTo(-10, 80 + offset)
      ..lineTo(w / 2 - 22, 204 + offset)
      ..quadraticBezierTo(w / 2, 220 + offset, w / 2 + 22, 204 + offset)
      ..lineTo(w + 10, 80 + offset);
    final shape = Path()
      ..moveTo(-10, 0)
      ..lineTo(w + 10, 0)
      ..lineTo(w + 10, 80)
      ..lineTo(w / 2 + 22, 204)
      ..quadraticBezierTo(w / 2, 220, w / 2 - 22, 204)
      ..lineTo(-10, 80)
      ..close();
    canvas.drawPath(
      shape,
      Paint()..shader = AppColors.gradient.createShader(Offset.zero & size),
    );
    canvas.drawPath(
      edge(-8),
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
  }

  @override
  bool shouldRepaint(_WelcomeAccent oldDelegate) => false;
}
