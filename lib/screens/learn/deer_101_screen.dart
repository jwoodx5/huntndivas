import 'package:flutter/material.dart';

class Deer101Screen extends StatefulWidget {
  const Deer101Screen({super.key});

  @override
  State<Deer101Screen> createState() => _Deer101ScreenState();
}

class _Deer101ScreenState extends State<Deer101Screen> {
  // Simple local progress tracking (checkboxes)
  final _checked = <String>{};

  void _toggle(String id) {
    setState(() {
      _checked.contains(id) ? _checked.remove(id) : _checked.add(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Deer Hunting 101'),
        backgroundColor: cs.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Intro card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 6))],
            ),
            child: Text(
              'Start here: safety, scouting, and simple gear to get you in the woods with confidence.',
              style: TextStyle(color: cs.onSurface),
            ),
          ),
          const SizedBox(height: 16),

          // Lesson sections
          _Section(
            title: '1. Safety & Regulations',
            children: [
              _CheckRow(id: 'lic', text: 'Get license & tags for your state', checked: _checked.contains('lic'), onTap: _toggle),
              _CheckRow(id: 'huntered', text: 'Complete hunter education course', checked: _checked.contains('huntered'), onTap: _toggle),
              _CheckRow(id: 'regs', text: 'Read season dates & legal methods', checked: _checked.contains('regs'), onTap: _toggle),
            ],
          ),
          _Section(
            title: '2. Essential Gear (Budget friendly)',
            children: [
              _CheckRow(id: 'boots', text: 'Quiet boots that fit (women’s sizing)', checked: _checked.contains('boots'), onTap: _toggle),
              _CheckRow(id: 'layers', text: 'Base/mid/outer layers (quiet fabric)', checked: _checked.contains('layers'), onTap: _toggle),
              _CheckRow(id: 'weapon', text: 'Rifle/bow + practice ammo/arrows', checked: _checked.contains('weapon'), onTap: _toggle),
              _CheckRow(id: 'safety', text: 'Orange vest/hat + headlamp', checked: _checked.contains('safety'), onTap: _toggle),
            ],
          ),
          _Section(
            title: '3. Scouting Basics',
            children: [
              _CheckRow(id: 'sign', text: 'Learn to spot tracks, trails, beds, rubs', checked: _checked.contains('sign'), onTap: _toggle),
              _CheckRow(id: 'maps', text: 'Use maps to find access & funnels', checked: _checked.contains('maps'), onTap: _toggle),
              _CheckRow(id: 'wind', text: 'Check wind; plan downwind approach', checked: _checked.contains('wind'), onTap: _toggle),
            ],
          ),
          _Section(
            title: '4. Shot Practice',
            children: [
              _CheckRow(id: 'zero', text: 'Zero rifle / tune bow at hunting ranges', checked: _checked.contains('zero'), onTap: _toggle),
              _CheckRow(id: 'positions', text: 'Practice kneeling & seated shots', checked: _checked.contains('positions'), onTap: _toggle),
              _CheckRow(id: 'ethics', text: 'Know your ethical distance', checked: _checked.contains('ethics'), onTap: _toggle),
            ],
          ),
          _Section(
            title: '5. Field Care (Basics)',
            children: [
              _CheckRow(id: 'kits', text: 'Pack gloves, knife, game bags', checked: _checked.contains('kits'), onTap: _toggle),
              _CheckRow(id: 'howto', text: 'Watch a step-by-step field dress guide', checked: _checked.contains('howto'), onTap: _toggle),
            ],
          ),

          const SizedBox(height: 16),
          // Download / CTA placeholders
          FilledButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => const AlertDialog(
                  title: Text('Coming soon'),
                  content: Text('Printable checklist & maps download will be available for Pro.'),
                ),
              );
            },
            icon: const Icon(Icons.download_rounded),
            label: const Text('Download checklist (Pro)'),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 6))],
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        children: children,
      ),
    );
  }
}

class _CheckRow extends StatelessWidget {
  const _CheckRow({required this.id, required this.text, required this.checked, required this.onTap});
  final String id;
  final String text;
  final bool checked;
  final void Function(String id) onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: Checkbox(value: checked, onChanged: (_) => onTap(id)),
      title: Text(text),
      onTap: () => onTap(id),
    );
  }
}
