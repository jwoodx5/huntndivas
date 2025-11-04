import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('HuntNDivas'),
        backgroundColor: cs.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          // 🌸 Hero card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [cs.primary.withOpacity(.18), cs.secondary.withOpacity(.15)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Find Your Wild',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: cs.onPrimaryContainer)),
                const SizedBox(height: 6),
                Text('Connect • Mentor • Equip',
                    style: TextStyle(color: cs.onSurfaceVariant)),
                const SizedBox(height: 14),
                FilledButton.icon(
                  onPressed: () => context.go('/community'),
                  icon: const Icon(Icons.groups_2_rounded),
                  label: const Text('Open Community'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 🔹 Quick links grid
          GridView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.15),
            children: [
              _QuickTile(
                icon: Icons.map_outlined,
                title: 'Map',
                subtitle: 'Ranges • Spots',
                color: cs.tertiary.withOpacity(.15),
                onTap: () => context.go('/map'),
              ),
              _QuickTile(
                icon: Icons.lightbulb_outline,
                title: 'Gear & Tips',
                subtitle: 'Women-led picks',
                color: cs.secondary.withOpacity(.15),
                onTap: () => context.go('/gear'),
              ),
              _QuickTile(
                icon: Icons.school_outlined,
                title: 'Learn & Mentor',
                subtitle: '101 guides',
                color: cs.primary.withOpacity(.12),
                onTap: () => context.go('/mentor'),
              ),
              _QuickTile(
                icon: Icons.workspace_premium,
                title: 'Upgrade',
                subtitle: 'Pro features',
                color: cs.primaryContainer.withOpacity(.24),
                onTap: () => context.go('/upgrade'),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // 🌟 “What’s new” section
          const Text('What’s New',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
          const SizedBox(height: 8),
          _NewsCard(
            title: 'Deer Hunting 101 now live',
            body: 'Start with safety, scouting, and essential gear. Check off your progress.',
            onTap: () => context.go('/learn/deer101'),
          ),
        ],
      ),
    );
  }
}

class _QuickTile extends StatelessWidget {
  const _QuickTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: cs.surface,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                    color: color, borderRadius: BorderRadius.circular(12)),
                child: Icon(icon),
              ),
              const Spacer(),
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w800, fontSize: 16)),
              const SizedBox(height: 2),
              Text(subtitle,
                  style: TextStyle(
                      color: cs.onSurfaceVariant, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}

class _NewsCard extends StatelessWidget {
  const _NewsCard({required this.title, required this.body, required this.onTap});
  final String title;
  final String body;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: cs.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: cs.tertiary.withOpacity(.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.menu_book_rounded),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(fontWeight: FontWeight.w800)),
                    const SizedBox(height: 4),
                    Text(body,
                        maxLines: 2, overflow: TextOverflow.ellipsis),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
