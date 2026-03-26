import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/set_entry.dart';
import '../state/strength_providers.dart';

class ExercisePickerSheet extends ConsumerStatefulWidget {
  const ExercisePickerSheet({super.key});

  @override
  ConsumerState<ExercisePickerSheet> createState() =>
      _ExercisePickerSheetState();
}

class _ExercisePickerSheetState extends ConsumerState<ExercisePickerSheet> {
  final TextEditingController _searchController = TextEditingController();
  final Set<String> _selectedIds = <String>{};

  List<StrengthExerciseSummary> _items = const [];
  bool _loading = true;
  bool _gridMode = false;

  @override
  void initState() {
    super.initState();
    _load();
    _searchController.addListener(_load);
  }

  Future<void> _load() async {
    final repository = ref.read(strengthRepositoryProvider);
    final result = await repository.searchExercises(
      query: _searchController.text,
    );

    if (!mounted) return;

    setState(() {
      _items = result;
      _loading = false;
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_load);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(bottom: bottom),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.85,
          child: Column(
            children: [
              ListTile(
                title: const Text('Select exercises'),
                trailing: IconButton(
                  onPressed: () {
                    setState(() {
                      _gridMode = !_gridMode;
                    });
                  },
                  icon: Icon(_gridMode ? Icons.view_list : Icons.grid_view),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    labelText: 'Search',
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : _gridMode
                    ? GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 2.4,
                  ),
                  itemCount: _items.length,
                  itemBuilder: (context, index) {
                    final item = _items[index];
                    final selected = _selectedIds.contains(item.id);

                    return InkWell(
                      onTap: () => _toggle(item.id),
                      child: Card(
                        color: selected
                            ? Theme.of(context)
                            .colorScheme
                            .primaryContainer
                            : null,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              item.label,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                )
                    : ListView.builder(
                  itemCount: _items.length,
                  itemBuilder: (context, index) {
                    final item = _items[index];
                    final selected = _selectedIds.contains(item.id);

                    return CheckboxListTile(
                      value: selected,
                      title: Text(item.label),
                      subtitle:
                      Text(item.isStatic ? 'Static' : 'Dynamic'),
                      onChanged: (_) => _toggle(item.id),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: _selectedIds.isEmpty
                            ? null
                            : () {
                          final selected = _items
                              .where((e) => _selectedIds.contains(e.id))
                              .toList();
                          Navigator.of(context).pop(selected);
                        },
                        child: const Text('Add'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _toggle(String id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });
  }
}