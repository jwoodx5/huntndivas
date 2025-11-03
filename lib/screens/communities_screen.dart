import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CommunitiesScreen extends StatefulWidget {
  const CommunitiesScreen({super.key});

  @override
  State<CommunitiesScreen> createState() => _CommunitiesScreenState();
}

class _CommunitiesScreenState extends State<CommunitiesScreen> {
  final _categories = const [
    'All', 'Big Game', 'Waterfowl', 'Fishing', 'Archery', 'New Huntresses'
  ];
  String _active = 'All';

  final _searchCtrl = TextEditingController();
  bool _refreshing = false;

  final List<_Post> _posts = [
    _Post(
      author: 'Alyssa M.',
      avatar: 'AM',
      title: 'First archery doe! Any tips for tuning a rest?',
      body: 'Shot at 22 yards. Bow is a Diamond Edge. Open to feedback!',
      tags: const ['Archery', 'Big Game'],
      likes: 12,
      comments: 4,
      minutesAgo: 42,
    ),
    _Post(
      author: 'Jess R.',
      avatar: 'JR',
      title: 'Colorado stock tanks near Larkspur?',
      body: 'Looking for public options for a Saturday morning scout.',
      tags: const ['Scouting', 'Big Game'],
      likes: 6,
      comments: 1,
      minutesAgo: 95,
    ),
    _Post(
      author: 'Maya K.',
      avatar: 'MK',
      title: 'Best women’s waders under \$200?',
      body: 'Cold feet after 2 hours. What are you all using this season?',
      tags: const ['Waterfowl', 'Gear'],
      likes: 18,
      comments: 7,
      minutesAgo: 180,
    ),
  ];

  List<_Post> get _filtered {
    final q = _searchCtrl.text.trim().toLowerCase();
    return _posts.where((p) {
      final inCat = _active == 'All' ||
          p.tags.any((t) => t.toLowerCase() == _active.toLowerCase());
      final inQuery = q.isEmpty ||
          p.title.toLowerCase().contains(q) ||
          p.body.toLowerCase().contains(q) ||
          p.tags.any((t) => t.toLowerCase().contains(q));
      return inCat && inQuery;
    }).toList();
  }

  Future<void> _pull() async {
    setState(() => _refreshing = true);
    await Future.delayed(const Duration(milliseconds: 700));
    setState(() => _refreshing = false);
  }

  void _newPostDialog() {
    final titleCtrl = TextEditingController();
    final bodyCtrl = TextEditingController();
    String category = 'Big Game';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Create post'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: titleCtrl,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  hintText: 'What do you want to ask/share?',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: bodyCtrl,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Details',
                  hintText: 'Add more context…',
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: category,
                items: const [
                  DropdownMenuItem(value: 'Big Game', child: Text('Big Game')),
                  DropdownMenuItem(value: 'Waterfowl', child: Text('Waterfowl')),
                  DropdownMenuItem(value: 'Fishing', child: Text('Fishing')),
                  DropdownMenuItem(value: 'Archery', child: Text('Archery')),
                  DropdownMenuItem(value: 'New Huntresses', child: Text('New Huntresses')),
                ],
                onChanged: (v) => category = v ?? category,
                decoration: const InputDecoration(labelText: 'Category'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              if (titleCtrl.text.trim().isEmpty) return;
              setState(() {
                _posts.insert(
                  0,
                  _Post(
                    author: 'You',
                    avatar: 'YO',
                    title: titleCtrl.text.trim(),
                    body: bodyCtrl.text.trim(),
                    tags: [category],
                    likes: 0,
                    comments: 0,
                    minutesAgo: 1,
                  ),
                );
                _active = 'All';
              });
              Navigator.pop(context);
            },
            child: const Text('Post'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Communities',
          style: GoogleFonts.leagueSpartan(fontWeight: FontWeight.w800),
        ),
        backgroundColor: cs.primary,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _newPostDialog,
        icon: const Icon(Icons.add),
        label: const Text('Post'),
      ),
      body: RefreshIndicator(
        onRefresh: _pull,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Column(
                  children: [
                    TextField(
                      controller: _searchCtrl,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: 'Search posts, tags…',
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
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 40,
                      child: ListView.separated(
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
                            labelStyle: const TextStyle(fontWeight: FontWeight.w700),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            if (_refreshing)
              const SliverToBoxAdapter(child: LinearProgressIndicator(minHeight: 2)),

            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final post = _filtered[index];
                  return _PostCard(post: post);
                },
                childCount: _filtered.length,
              ),
            ),

            if (_filtered.isEmpty)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: Text('No posts yet. Be the first to share!')),
                ),
              ),

            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ),
      ),
    );
  }
}

class _PostCard extends StatefulWidget {
  const _PostCard({required this.post});
  final _Post post;

  @override
  State<_PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<_PostCard> {
  late int _likes = widget.post.likes;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final p = widget.post;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Container(
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 6))],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: cs.secondary.withOpacity(0.25),
                    child: Text(p.avatar, style: const TextStyle(fontWeight: FontWeight.w800)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(p.author, style: const TextStyle(fontWeight: FontWeight.w700)),
                        Text('${p.minutesAgo} min ago', style: TextStyle(color: cs.onSurfaceVariant, fontSize: 12)),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    itemBuilder: (_) => const [
                      PopupMenuItem(value: 'report', child: Text('Report')),
                      PopupMenuItem(value: 'save', child: Text('Save')),
                    ],
                    icon: const Icon(Icons.more_vert),
                    onSelected: (_) {},
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Title & body
              Text(p.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
              const SizedBox(height: 6),
              Text(p.body),

              const SizedBox(height: 10),

              // Tags
              Wrap(
                spacing: 8,
                runSpacing: -6,
                children: p.tags
                    .map((t) => Chip(
                          label: Text(t),
                          backgroundColor: cs.tertiary.withOpacity(0.15),
                          padding: EdgeInsets.zero,
                        ))
                    .toList(),
              ),

              const SizedBox(height: 8),

              // Actions
              Row(
                children: [
                  IconButton(
                    onPressed: () => setState(() => _likes++),
                    icon: const Icon(Icons.favorite_border),
                  ),
                  Text('$_likes'),
                  const SizedBox(width: 16),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.mode_comment_outlined),
                  ),
                  Text('${p.comments}'),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.share_outlined, size: 18),
                    label: const Text('Share'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Post {
  final String author;
  final String avatar;
  final String title;
  final String body;
  final List<String> tags;
  final int likes;
  final int comments;
  final int minutesAgo;
  const _Post({
    required this.author,
    required this.avatar,
    required this.title,
    required this.body,
    required this.tags,
    required this.likes,
    required this.comments,
    required this.minutesAgo,
  });
}
