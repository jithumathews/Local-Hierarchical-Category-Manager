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
        // Node item row
        Container(
          margin: EdgeInsets.only(
            top: depth == 0 ? 6 : 2,
            bottom: depth == 0 ? 6 : 2,
            left: depth == 0 ? 0 : 8,
          ),
          decoration: BoxDecoration(
            color: depth == 0 ? cs.surface : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: depth == 0
                ? Border.all(color: cs.outlineVariant)
                : null,
          ),
          child: InkWell(
            onTap: () {
              if (hasChildren) {
                ref.read(expandedIdsProvider.notifier).toggle(cat.id);
              }
            },
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Row(
                children: [
                  // Expand chevron + Folder/Leaf Icon
                  if (hasChildren) ...[
                    AnimatedRotation(
                      turns: isExpanded ? 0.25 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        Icons.chevron_right_rounded,
                        size: 20,
                        color: cs.primary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      isExpanded
                          ? Icons.folder_open_rounded
                          : Icons.folder_outlined,
                      size: 20,
                      color: cs.primary,
                    ),
                  ] else ...[
                    const SizedBox(width: 6),
                    Icon(
                      depth == 0
                          ? Icons.folder_outlined
                          : Icons.subdirectory_arrow_right_rounded,
                      size: 18,
                      color: cs.onSurfaceVariant.withAlpha(160),
                    ),
                  ],

                  const SizedBox(width: 10),

                  // Category name
                  Expanded(
                    child: Text(
                      cat.name,
                      style: tt.bodyMedium?.copyWith(
                        fontWeight: depth == 0
                            ? FontWeight.w600
                            : FontWeight.w500,
                        color: cs.onSurface,
                      ),
                    ),
                  ),

                  // Subcategory count pill badge
                  if (hasChildren) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: cs.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: cs.outlineVariant),
                      ),
                      child: Text(
                        '${node.children.length}',
                        style: tt.labelSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                  ],

                  // Quick Action 1: Add subcategory directly
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline_rounded, size: 20),
                    tooltip: 'Add subcategory',
                    visualDensity: VisualDensity.compact,
                    splashRadius: 18,
                    onPressed: () => showAddCategoryDialog(
                      context,
                      ref,
                      parentId: cat.id,
                      parentName: cat.name,
                      repo: repo,
                    ),
                  ),

                  // Quick Action 2: More / Delete options
                  _NodeOptionsMenu(node: node, repo: repo),
                ],
              ),
            ),
          ),
        ),

        // Animated nested children with continuous vertical guideline
        AnimatedSize(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child: (hasChildren && isExpanded)
              ? Container(
                  margin: const EdgeInsets.only(left: 18),
                  padding: const EdgeInsets.only(left: 6),
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: cs.outlineVariant.withAlpha(160),
                        width: 1.5,
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final child in node.children)
                        CategoryTreeTile(
                          node: child,
                          depth: depth + 1,
                          repo: repo,
                        ),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

class _NodeOptionsMenu extends ConsumerWidget {
  const _NodeOptionsMenu({required this.node, required this.repo});

  final CategoryNode node;
  final CategoryRepository repo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;

    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert_rounded, size: 18),
      tooltip: 'Options',
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: cs.outlineVariant),
      ),
      itemBuilder: (_) => [
        const PopupMenuItem(
          value: 'add',
          child: Row(
            children: [
              Icon(Icons.add, size: 18),
              SizedBox(width: 8),
              Text('Add subcategory'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete_outline_rounded, size: 18, color: cs.error),
              const SizedBox(width: 8),
              Text('Delete', style: TextStyle(color: cs.error)),
            ],
          ),
        ),
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
              icon: Icon(
                Icons.delete_outline_rounded,
                size: 32,
                color: cs.error,
              ),
              title: const Text('Delete Category'),
              content: Text(
                'Are you sure you want to delete "${node.category.name}" and all of its subcategories?',
                textAlign: TextAlign.center,
              ),
              actionsAlignment: MainAxisAlignment.end,
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  style: FilledButton.styleFrom(
                    backgroundColor: cs.error,
                    foregroundColor: cs.onError,
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
                  SnackBar(
                    content: Text('Deleted "${node.category.name}"'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(e.toString()),
                    backgroundColor: cs.error,
                  ),
                );
              }
            }
          }
        }
      },
    );
  }
}
