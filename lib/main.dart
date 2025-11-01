import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(const HuntNDivasApp());

class HuntNDivasApp extends StatelessWidget {
  const HuntNDivasApp({super.key});

  @override
  Widget build(BuildContext context) {
    const seed = Color(0xFFFF6B9A); // HuntNDivas pink
    return MaterialApp(
      title: 'HuntNDivas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: seed,
        scaffoldBackgroundColor: const Color(0xFFF6F0EA), // sand
        textTheme: GoogleFonts.openSansTextTheme()
            .apply(bodyColor: const Color(0xFF1E1E1E))
            .copyWith(
              headlineLarge: GoogleFonts.leagueSpartan(
                fontWeight: FontWeight.w800,
                fontSize: 28,
              ),
              headlineMedium: GoogleFonts.leagueSpartan(
                fontWeight: FontWeight.w700,
                fontSize: 22,
              ),
              titleLarge: GoogleFonts.montserrat(
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
      ),
      home: const HomeScreen(),
    );
  }
}

/// Home with subtle pulse on the "Upgrade to Pro" card
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _pulsing = false;

  @override
  void initState() {
    super.initState();
    // One gentle pulse a second after the screen appears.
    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      setState(() => _pulsing = true);
      Future.delayed(const Duration(milliseconds: 700), () {
        if (!mounted) return;
        setState(() => _pulsing = false);
      });
    });
  }

  void _go(BuildContext context, Widget page) {
    Navigator.of(context).push(PageRouteBuilder(
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, anim, __, child) =>
          FadeTransition(opacity: anim, child: child),
      transitionDuration: const Duration(milliseconds: 220),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 160,
            backgroundColor: cs.primary,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding:
                  const EdgeInsetsDirectional.only(start: 16, bottom: 12),
              title: Text(
                'HuntNDivas!',
                style: GoogleFonts.leagueSpartan(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFFFF6B9A), // pink
                      Color(0xFFFFA9C4), // light pink
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Tagline card
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cs.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: cs.shadow.withOpacity(0.06),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Find Your Wild',
                        style: GoogleFonts.leagueSpartan(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                        )),
                    const SizedBox(height: 6),
                    Text(
                      'Connect · Mentor · Equip',
                      style: TextStyle(color: cs.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Feature list
          SliverList.list(
            children: [
              FeatureTile(
                icon: Icons.groups_rounded,
                title: 'Community Feed',
                subtitle: '—',
                badge: 'Free',
                onTap: (ctx) async {
                  await HapticFeedback.lightImpact();
                  _go(ctx, const CommunityPage());
                },
              ),
              FeatureTile(
                icon: Icons.lightbulb_circle_rounded,
                title: 'Gear & Tips',
                subtitle: 'Field-tested advice, women-led',
                badge: 'Free',
                onTap: (ctx) async {
                  await HapticFeedback.lightImpact();
                  _go(ctx, const GearTipsPage());
                },
              ),

              // Mentor (Pro)
              FeatureTile(
                icon: Icons.school_rounded,
                title: 'Mentor Directory',
                subtitle: 'Get matched with huntresses near you',
                badge: 'Pro',
                pro: true,
                onTap: (ctx) async {
                  await HapticFeedback.lightImpact();
                  _go(ctx, const MentorDirectoryPage());
                },
              ),

              // Upgrade tile with pulse
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                child: AnimatedScale(
                  scale: _pulsing ? 1.03 : 1.0,
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeInOut,
                  child: FeatureTile(
                    icon: Icons.workspace_premium_rounded,
                    title: 'Upgrade to Pro',
                    subtitle:
                        'Unlock mentorship, events & pro gear drops',
                    highlight: true,
                    onTap: (ctx) async {
                      await HapticFeedback.selectionClick();
                      _go(ctx, const UpgradePage());
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ],
      ),

      // Inspire button
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: FilledButton.icon(
            onPressed: () => _showQuote(context),
            icon: const Icon(Icons.auto_awesome),
            label: const Text('Inspire me'),
          ),
        ),
      ),
    );
  }

  void _showQuote(BuildContext context) {
    const quotes = [
      'She doesn’t wait for permission—she finds her wild.',
      'Boots on. Head up. The woods are calling.',
      'Strong women raise strong huntresses.',
      'The trail builds the woman.',
    ];
    quotes.shuffle();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Daily inspiration'),
        content: Text(quotes.first),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

/// Reusable feature tile
class FeatureTile extends StatelessWidget {
  const FeatureTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.badge,
    required this.onTap,
    this.pro = false,
    this.highlight = false,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final String? badge;
  final bool pro;
  final bool highlight;
  final void Function(BuildContext) onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final bg = highlight ? cs.tertiaryContainer : cs.surface;
    final onBg = highlight ? cs.onTertiaryContainer : cs.onSurface;

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(18),
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => onTap(context),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .primaryContainer
                      .withValues(alpha: 0.65),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon,
                    color: Theme.of(context).colorScheme.onPrimaryContainer),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Flexible(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: onBg,
                          ),
                        ),
                      ),
                      if (badge != null) ...[
                        const SizedBox(width: 8),
                        _Badge(text: badge!, pro: pro),
                      ],
                    ]),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle!,
                        style: TextStyle(
                          color: onBg.withValues(alpha: 0.75),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.text, required this.pro});
  final String text;
  final bool pro;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final color = pro ? cs.errorContainer : cs.secondaryContainer;
    final onColor = pro ? cs.onErrorContainer : cs.onSecondaryContainer;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: onColor,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

// -------- Stub pages you can fill later --------
class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});
  @override
  Widget build(BuildContext context) => _scaffold('Community Feed');
}

class GearTipsPage extends StatelessWidget {
  const GearTipsPage({super.key});
  @override
  Widget build(BuildContext context) => _scaffold('Gear & Tips');
}

class MentorDirectoryPage extends StatelessWidget {
  const MentorDirectoryPage({super.key});
  @override
  Widget build(BuildContext context) =>
      _scaffold('Mentor Directory (Pro)',
          body: const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Coming soon: matched mentors by state & skill level. '
              'Tap Upgrade to Pro to get notified at launch.',
            ),
          ));
}

class UpgradePage extends StatelessWidget {
  const UpgradePage({super.key});
  @override
  Widget build(BuildContext context) =>
      _scaffold('Upgrade to Pro',
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Pro unlocks:'),
                const SizedBox(height: 8),
                const _Bullet('Mentor matching & DM'),
                const _Bullet('Exclusive gear drops & discounts'),
                const _Bullet('Early access to events & workshops'),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => const AlertDialog(
                        title: Text('Coming soon'),
                        content: Text(
                            'In-app purchase will be enabled in a later build.'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.workspace_premium_rounded),
                  label: const Text('Notify me'),
                ),
              ],
            ),
          ));
}

Widget _scaffold(String title, {Widget? body}) {
  return Scaffold(
    appBar: AppBar(title: Text(title)),
    body: body ??
        const Center(
          child: Text('Stub page — content coming soon.'),
        ),
  );
}

class _Bullet extends StatelessWidget {
  const _Bullet(this.text);
  final String text;
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(Icons.check_circle_rounded, color: cs.primary),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
