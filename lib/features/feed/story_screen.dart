import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../ui/widgets.dart';

class StoryScreen extends StatefulWidget {
  const StoryScreen({super.key, this.live = false});
  final bool live;
  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  bool liked = false;
  final comments = <String>[];
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.black,
    body: Stack(
      fit: StackFit.expand,
      children: [
        const AppPhoto('story'),
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0x55000000),
                Colors.transparent,
                Color(0xBB000000),
              ],
            ),
          ),
        ),
        SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 20, 20, 10),
                child: Row(
                  children: [
                    const Avatar('theresa', size: 55),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Theresa Webb',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            widget.live ? '● Live' : '2 Hours Ago',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'Close story',
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.cancel, color: Colors.white),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              if (!widget.live)
                Container(
                  color: Colors.black45,
                  width: double.infinity,
                  padding: const EdgeInsets.all(15),
                  child: const Text(
                    'Find My Adidas Shoes ◻',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              if (widget.live)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 35, vertical: 8),
                  child: Row(
                    children: [
                      Avatar('reny', size: 36),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Esther Howard\nThat’s cool! Go Adidas 👏',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ...comments.map(
                (c) => Padding(
                  padding: const EdgeInsets.fromLTRB(35, 4, 35, 4),
                  child: Row(
                    children: [
                      const Avatar('me', size: 28),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          c,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: MessageComposer(
                      hint: 'Leave Comments',
                      onSend: (v) => setState(() => comments.add(v)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 24),
                    child: IconButton(
                      tooltip: 'Like story',
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                      onPressed: () => setState(() => liked = !liked),
                      icon: Icon(
                        liked
                            ? CupertinoIcons.heart_fill
                            : CupertinoIcons.heart,
                        color: Colors.pink,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
