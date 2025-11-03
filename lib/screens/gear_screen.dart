import 'package:flutter/material.dart';

class GearScreen extends StatefulWidget {
  const GearScreen({super.key});

  @override
  State<GearScreen> createState() => _GearScreenState();
}

class _GearScreenState extends State<GearScreen> {
  final _categories = const ['All', 'Big Game', 'Waterfowl', 'Fishing', 'Archery', 'Apparel', 'Footwear'];
  String _active = 'All';
  final _searchCtrl = TextEditingController();
  bool _grid = true;
  final Set<String> _saved = {};

  final List<_GearItem> _all = const [
    _GearItem(id: 'bino', name: 'Vortex Diamondback HD 10x42', category: 'Big Game', price: 199.99, rating: 4.7),
    _GearItem(id: 'pack', name: 'Mystery Ranch Pop-Up 28 (W)', category: 'Big Game', price: 329.00, rating: 4.6),
    _GearItem(id: 'waders', name: 'Frogg Toggs Women’s Waders', category: 'Waterfowl', price: 179.95, rating: 4.3),
    _GearItem(id: 'fly', name: 'Redington Fly Combo (8’6”)', category: 'Fishing', price: 119.00, rating: 4.2),
    _GearItem(id: 'release', name: 'Scott Archery Release (W)', category: 'Archery', price: 89.99, rating: 4.4),
    _GearItem(id: 'jacket', name: 'First Lite Women’s Catalyst', category: 'Apparel', price: 240.00, rating: 4.8),
    _GearItem(id: 'boot', name: 'Danner Women’s Wayfinder', category: 'Footwear', price: 159.95, rating: 4.5),
    _GearItem(id: 'call', name: 'Primos Elk Call Kit', category: 'Big Game', price: 34.99, rating: 4.1),
  ];

  List<_GearItem> get _filtered {
    final q = _searchCtrl.text.trim().toLowerCase();
    return _all.where((g) {
      final inCat = _active == 'All' || g.category == _active;
      final inQuery = q.isEmpty || g.name.toLowerCase().contains(q);
      return inCat && inQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gear & Tips'),
        backgroundColor: cs.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            tooltip: _grid ? 'List view' : 'Grid view',
            onPressed: () => setState(() => _grid = !_grid),
            icon: Icon(_grid ? Icons.view_list_outlined : Icons.grid_view_outlined),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Search gear (e.g., waders, bino)…',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: cs.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: cs.outlineVariant),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: cs.outlineVariant),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
            ),
          ),

          // Categories
          SizedBox(
            height: 40,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final c = _categories[i];
                final selected = c == _active;
                return ChoiceChip(
                  label: Text(c),
                  selected: selected,
                  onSelected: (_) => setState(() => _active = c),
                  selectedColor: cs.secondary.withOpacity(0.18),
                );
              },
            ),
          ),

          const SizedBox(height: 8),

          // Results
          Expanded(
            child: _grid ? _gridView(cs) : _listView(cs),
          ),
        ],
      ),
    );
  }

  Widget _gridView(ColorScheme cs) {
    final items = _filtered;
    if (items.isEmpty) return _emptyState();

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 0.78),
      itemCount: items.length,
      itemBuilder: (_, i) => _GearCard(
        item: items[i],
        saved: _saved.contains(items[i].id),
        onToggleSave: () => setState(() {
          _saved.contains(items[i].id) ? _saved.remove(items[i].id) : _saved.add(items[i].id);
        }),
        onBuy: () => _onBuy(items[i]),
      ),
    );
  }

  Widget _listView(ColorScheme cs) {
    final items = _filtered;
    if (items.isEmpty) return _emptyState();

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) => _GearRow(
        item: items[i],
        saved: _saved.contains(items[i].id),
        onToggleSave: () => setState(() {
          _saved.contains(items[i].id) ? _saved.remove(items[i].id) : _saved.add(items[i].id);
        }),
        onBuy: () => _onBuy(items[i]),
      ),
    );
  }

  Widget _emptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Text('No gear found. Try another category or search.'),
      ),
    );
  }

  void _onBuy(_GearItem item) {
    // Later: open your affiliate link
    // For now, just show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Open link for: ${item.name}')),
    );
  }
}

class _GearItem {
  final String id;
  final String name;
  final String category;
  final double price;
  final double rating;
  const _GearItem({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.rating,
  });
}

class _GearCard extends StatelessWidget {
  const _GearCard({
    required this.item,
    required this.saved,
    required this.onToggleSave,
    required this.onBuy,
    super.key,
  });

  final _GearItem item;
  final bool saved;
  final VoidCallback onToggleSave;
  final VoidCallback onBuy;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 6))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: placeholder image + save
            AspectRatio(
              aspectRatio: 1.4,
              child: Container(
                decoration: BoxDecoration(
                  color: cs.tertiary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(child: Icon(Icons.image, size: 42)),
              ),
            ),
            const SizedBox(height: 8),
            Text(item.name, maxLines: 2, overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w800)),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.star_rounded, color: Colors.amber.shade700, size: 18),
                Text(item.rating.toStringAsFixed(1)),
                const Spacer(),
                Text('\$${item.price.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.w800)),
              ],
            ),
            const Spacer(),
            Row(
              children: [
                IconButton(
                  onPressed: onToggleSave,
                  icon: Icon(saved ? Icons.favorite : Icons.favorite_border),
                ),
                const Spacer(),
                FilledButton.icon(
                  onPressed: onBuy,
                  icon: const Icon(Icons.shopping_bag_outlined),
                  label: const Text('Buy'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _GearRow extends StatelessWidget {
  const _GearRow({
    required this.item,
    required this.saved,
    required this.onToggleSave,
    required this.onBuy,
    super.key,
  });

  final _GearItem item;
  final bool saved;
  final VoidCallback onToggleSave;
  final VoidCallback onBuy;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 6))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Image placeholder
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: cs.tertiary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(child: Icon(Icons.image, size: 36)),
            ),
            const SizedBox(width: 12),
            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name, maxLines: 2, overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.star_rounded, color: Colors.amber.shade700, size: 18),
                      Text(item.rating.toStringAsFixed(1)),
                      const SizedBox(width: 12),
                      Text(item.category, style: TextStyle(color: cs.onSurfaceVariant)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              children: [
                IconButton(
                  onPressed: onToggleSave,
                  icon: Icon(saved ? Icons.favorite : Icons.favorite_border),
                ),
                Text('\$${item.price.toStringAsFixed(0)}',
                    style: const TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                FilledButton(
                  onPressed: onBuy,
                  child: const Text('Buy'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
