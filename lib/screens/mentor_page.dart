import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class MentorPage extends StatelessWidget {
  const MentorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final topics = [
      {'title': 'Deer Hunting 101', 'pro': false, 'icon': Icons.forest_rounded},
      {'title': 'Elk Hunting 101', 'pro': true, 'icon': Icons.terrain_rounded},
      {'title': 'Duck Hunting 101', 'pro': false, 'icon': Icons.water_rounded},
      {'title': 'Turkey Hunting 101', 'pro': true, 'icon': Icons.egg_rounded},
      {'title': 'Fishing 101', 'pro': false, 'icon': Icons.waves_rounded},
      {'title': 'Ice Fishing 101', 'pro': true, 'icon': Icons.ac_unit_rounded},
    ];

    return Scaffold(
      backgroundColor: cs.background,
      appBar: AppBar(
        title: const Text("Learn & Mentor"),
        centerTitle: true,
        backgroundColor: cs.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: topics.length,
        itemBuilder: (context, index) {
          final t = topics[index];
          return Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            margin: const EdgeInsets.only(bottom: 14),
            elevation: 2,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                final title = t['title'] as String;
                final isPro = (t['pro'] == true);

                if (title == 'Deer Hunting 101') {
                  // Free example: open lesson screen
                  context.push('/learn/deer101');
                  return;
                }
                // Everything else stays a placeholder (or gated)
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text(title),
                    content: Text(
                      isPro
                          ? 'Pro exclusive content. Unlock with HuntNDivas Pro.'
                          : 'Tutorial coming soon — step-by-step basics for $title!',
                    ),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      cs.tertiary.withOpacity(0.15),
                      cs.secondary.withOpacity(0.10)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: cs.primary.withOpacity(0.1),
                      child: Icon(t['icon'] as IconData,
                          color: cs.primary, size: 26),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        t['title'] as String,
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    if (t['pro'] == true)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFE3C4),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: const Text(
                          "Pro",
                          style: TextStyle(
                              color: Color(0xFF8A4B00),
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
