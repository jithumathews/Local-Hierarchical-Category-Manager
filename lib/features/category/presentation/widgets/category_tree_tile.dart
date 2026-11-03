import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/category_model.dart';
import '../../data/category_repository.dart';
import '../category_controller.dart';
import 'add_category_dialog.dart';

class CategoryTreeTile extends ConsumerWidget {
  const CategoryTreeTile({
    super.key,
    required this.node,
    required this.depth,
    required this.repo,
  });

  final CategoryNode node;
  final int depth;
  final CategoryRepository repo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cat = node.category;
    final hasChildren = node.children.isNotEmpty;
    final expandedIds = ref.watch(expandedIdsProvider);
    final isExpanded = expandedIds.contains(cat.id);
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: hasChildren
              ? () =>
                  ref.read(expandedIdsProvider.notifier).toggle(cat.id)
              : null,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: EdgeInsets.only(
              left: 16.0 * depth + 8,
              right: 8,
              top: 6,
              bottom: 6,
            ),
            child: Row(
              children: [
                // Expand / leaf icon
                if (hasChildren)
                  AnimatedRotation(
                    turns: isExpanded ? 0.25 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.chevron_right,
                      size: 20,
                      color: cs.primary,
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.all(2),
                    child: Icon(
                      Icons.circle,
                      size: 6,
                      color: cs.onSurfaceVariant.withAlpha(128),
                    ),
                  ),

                const SizedBox(width: 10),

                Expanded(
                  child: Text(
                    cat.name,
                    style: tt.bodyMedium?.copyWith(
                      fontWeight: depth == 0
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ),

                // Child count badge
                if (hasChildren) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: cs.secondaryContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${node.children.length}',
                      style: tt.labelSmall?.copyWith(
                        color: cs.onSecondaryContainer,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                ],

                // Popup menu
                _NodeMenu(node: node, repo: repo),
              ],
            ),
          ),
        ),

        // Children
        if (hasChildren && isExpanded)
          for (final child in node.children)
            CategoryTreeTile(
              node: child,
              depth: depth + 1,
              repo: repo,
            ),
      ],
    );
  }
}

class _NodeMenu extends ConsumerWidget {
  const _NodeMenu({required this.node, required this.repo});

  final CategoryNode node;
  final CategoryRepository repo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, size: 18),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      itemBuilder: (_) => const [
        PopupMenuItem(value: 'add', child: Text('Add subcategory')),
        PopupMenuItem(value: 'delete', child: Text('Delete')),
      ],
      onSelected: (value) async {
        if (value == 'add') {
          if (!context.mounted) return;
          await showAddCategoryDialog(
            context,
            ref,
            parentId: node.category.id,
            parentName: node.category.name,
            repo: repo,
          );
        } else if (value == 'delete') {
          if (!context.mounted) return;
          final confirmed = await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Delete Category'),
              content: Text(
                'Delete "${node.category.name}" and all its subcategories?',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  style: FilledButton.styleFrom(
                    backgroundColor: Theme.of(ctx).colorScheme.error,
                  ),
                  child: const Text('Delete'),
                ),
              ],
            ),
          );
          if (confirmed == true && context.mounted) {
            try {
              await ref
                  .read(categoryTreeProvider.notifier)
                  .delete(node.category.id);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Category deleted')),
                );
              }
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(e.toString())),
                );
              }
            }
          }
        }
      },
    );
  }
}
