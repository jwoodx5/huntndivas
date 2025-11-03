import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/map_screen.dart';

void main() => runApp(const HuntNDivasApp());

/* =====================  BRAND PALETTE (global)  ===================== */
const kPrimaryTeal = Color(0xFF2C8FA3); // dominant teal (app bar, accents)
const kLightTeal = Color(0xFF48CAE4); // supporting teal
const kAccentCoral = Color(0xFFFF6B9A); // pink/coral accent
const kBlushBg = Color(0xFFFEF6F4); // soft blush page background
const kCardSurface = Colors.white;
const kBodyText = Color(0xFF1E1E1E);

// Soft tints used below the hero
const kIconTileTint = Color(0xFFFFE6EE); // pink tint behind feature icons
const kIconTileFg = Color(0xFF7A3A49); // icon color on pink tint
const kUpgradePeach = Color(0xFFB2EBF2); // upgrade card background
const kCtaMauve = Color(0xFF2C8FA3); // bottom CTA button color
/* ==================================================================== */

class HuntNDivasApp extends StatelessWidget {
  const HuntNDivasApp({super.key});

  @override
  Widget build(BuildContext context) {
    final baseScheme = ColorScheme.fromSeed(seedColor: kPrimaryTeal);
    final scheme = baseScheme.copyWith(
      primary: kPrimaryTeal,
      secondary: kAccentCoral,
      tertiary: kLightTeal,
      surface: kCardSurface,
      background: kBlushBg,
    );

    return MaterialApp(
      title: 'HuntNDivas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: scheme,
        scaffoldBackgroundColor: kBlushBg,
        filledButtonTheme: FilledButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(kCtaMauve),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            textStyle: MaterialStateProperty.all<TextStyle>(
              const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
            shape: MaterialStateProperty.all<OutlinedBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            ),
            overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
              if (states.contains(MaterialState.pressed) ||
                  states.contains(MaterialState.hovered) ||
                  states.contains(MaterialState.focused)) {
                return Colors.white.withOpacity(0.08);
              }
              return null;
            }),
            elevation: MaterialStateProperty.resolveWith<double?>((states) {
              if (states.contains(MaterialState.hovered)) return 1.5;
              if (states.contains(MaterialState.pressed)) return 0;
              return 0;
            }),
          ),
        ),
        textTheme: GoogleFonts.openSansTextTheme()
            .apply(bodyColor: kBodyText)
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
      home: const AppShell(),
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
      backgroundColor: cs.background,
      body: CustomScrollView(
        slivers: [
          // ----- HERO with teal -> pink gradient -----
          SliverAppBar(
            pinned: true,
            expandedHeight: 160,
            backgroundColor: cs.primary,
            flexibleSpace: const FlexibleSpaceBar(
              titlePadding: EdgeInsetsDirectional.only(start: 16, bottom: 12),
              title: _HeroTitle(),
              background: _HeroGradient(),
            ),
          ),

          // ----- Tagline card -----
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cs.surface,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
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

          // ----- Feature list (white cards, pink icon tiles, soft pills) -----
          SliverList(
            delegate: SliverChildListDelegate([
              FeatureTile(
                icon: Icons.groups_rounded,
                title: 'Community Feed',
                subtitle: '—',
                badge: 'Free',
                iconTileTint: kIconTileTint,
                iconTileFg: kIconTileFg,
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
                iconTileTint: kIconTileTint,
                iconTileFg: kIconTileFg,
                onTap: (ctx) async {
                  await HapticFeedback.lightImpact();
                  _go(ctx, const GearTipsPage());
                },
              ),

              // Mentor (Pro) – shows peach pill
              FeatureTile(
                icon: Icons.school_rounded,
                title: 'Mentor Directory',
                subtitle: 'Get matched with huntresses near you',
                badge: 'Pro',
                pro: true,
                iconTileTint: kIconTileTint,
                iconTileFg: kIconTileFg,
                onTap: (ctx) async {
                  await HapticFeedback.lightImpact();
                  _go(ctx, const MentorDirectoryPage());
                },
              ),

              // Upgrade tile with pulse – peach block like screenshot
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                child: AnimatedScale(
                  scale: _pulsing ? 1.03 : 1.0,
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeInOut,
                  child: FeatureTile(
                    icon: Icons.workspace_premium_rounded,
                    title: 'Upgrade to Pro',
                    subtitle: 'Unlock mentorship, events & pro gear drops',
                    highlight: true,
                    highlightColor: kUpgradePeach,
                    iconTileTint: const Color(0xFFFFDCC7),
                    iconTileFg: const Color(0xFF6E3F2A),
                    onTap: (ctx) async {
                      await HapticFeedback.selectionClick();
                      _go(ctx, const UpgradePage());
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ]),
          ),
        ],
      ),

      // ----- Bottom CTA (mauve) -----
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
      ),
    );
  }
}

// ----- HERO bits -----
class _HeroTitle extends StatelessWidget {
  const _HeroTitle();
  @override
  Widget build(BuildContext context) {
    return Text(
      'HuntNDivas',
      style: GoogleFonts.leagueSpartan(
        fontSize: 22,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _HeroGradient extends StatelessWidget {
  const _HeroGradient();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            kPrimaryTeal, // teal
            kAccentCoral, // pink/coral
          ],
        ),
      ),
    );
  }
}

/// Reusable feature tile matching the soft look
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
    this.highlightColor,
    this.iconTileTint,
    this.iconTileFg,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final String? badge;
  final bool pro;
  final bool highlight;
  final Color? highlightColor;
  final Color? iconTileTint;
  final Color? iconTileFg;
  final void Function(BuildContext) onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final bg =
        highlight ? (highlightColor ?? cs.tertiaryContainer) : cs.surface;
    final onBg = highlight ? Colors.black87 : cs.onSurface;

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(22),
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: () => onTap(context),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              // Icon tile with soft tint
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: iconTileTint ?? kIconTileTint,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: iconTileFg ?? kIconTileFg),
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
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
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
                      const SizedBox(height: 6),
                      Text(
                        subtitle!,
                        style: TextStyle(
                          color: onBg.withOpacity(0.70),
                          fontSize: 14,
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
    // Free = pink pill, Pro = peach pill
    final bg = pro ? const Color(0xFFFFE3C4) : const Color(0xFFFDE7EF);
    final fg = pro ? const Color(0xFF8A4B00) : const Color(0xFFB83E63);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: fg,
          fontSize: 12,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

// -------- Stub pages --------
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
  Widget build(BuildContext context) => _scaffold('Mentor Directory (Pro)',
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
  Widget build(BuildContext context) => _scaffold('Upgrade to Pro',
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

class AppShell extends StatefulWidget {
  const AppShell({super.key});
  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  // Order of tabs (must match items below)
  late final List<Widget> _pages = const [
    MapScreen(),          // 0
    CommunityPage(),      // 1
    GearTipsPage(),       // 2
    MentorDirectoryPage(),// 3
    UpgradePage(),        // 4
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.map_outlined),      label: 'Map'),
          BottomNavigationBarItem(icon: Icon(Icons.groups_2_outlined), label: 'Community'),
          BottomNavigationBarItem(icon: Icon(Icons.lightbulb_outline), label: 'Gear'),
          BottomNavigationBarItem(icon: Icon(Icons.school_outlined),   label: 'Mentor'),
          BottomNavigationBarItem(icon: Icon(Icons.workspace_premium), label: 'Upgrade'),
        ],
      ),
    );
  }
}