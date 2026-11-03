import 'package:flutter/material.dart';

import '../../data/category_model.dart';

class SearchResultCard extends StatefulWidget {
  const SearchResultCard({super.key, required this.result});

  final CategorySearchResult result;

  @override
  State<SearchResultCard> createState() => _SearchResultCardState();
}

class _SearchResultCardState extends State<SearchResultCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final result = widget.result;
    final path = result.path;
    final breadcrumb = path.map((c) => c.name).join(' › ');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      color: cs.surfaceContainerLow,
      child: InkWell(
        onTap: () => setState(() => _expanded = !_expanded),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Breadcrumb
              Row(
                children: [
                  Expanded(
                    child: Text(
                      breadcrumb,
                      style: tt.bodySmall?.copyWith(
                        color: cs.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Icon(
                    _expanded
                        ? Icons.expand_less
                        : Icons.expand_more,
                    size: 20,
                    color: cs.onSurfaceVariant,
                  ),
                ],
              ),

              const SizedBox(height: 6),

              // Match name
              Text(
                result.match.name,
                style: tt.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              // Parent chip
              if (result.parent != null)
                Wrap(
                  spacing: 6,
                  children: [
                    Chip(
                      avatar: const Icon(Icons.arrow_upward, size: 14),
                      label: Text('Parent: ${result.parent!.name}'),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                      backgroundColor: cs.tertiaryContainer,
                      labelStyle: TextStyle(
                        color: cs.onTertiaryContainer,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),

              // Children chips
              if (result.children.isNotEmpty) ...[
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: result.children
                      .map(
                        (c) => Chip(
                          label: Text(c.name),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                          backgroundColor: cs.secondaryContainer,
                          labelStyle: TextStyle(
                            color: cs.onSecondaryContainer,
                            fontSize: 12,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],

              // Expanded mini-tree
              if (_expanded) ...[
                const Divider(height: 20),
                Text(
                  'Full hierarchy',
                  style: tt.labelSmall?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                for (int i = 0; i < path.length; i++)
                  Padding(
                    padding: EdgeInsets.only(left: 20.0 * i, top: 2),
                    child: Row(
                      children: [
                        if (i > 0)
                          Icon(
                            Icons.subdirectory_arrow_right,
                            size: 14,
                            color: cs.onSurfaceVariant.withAlpha(128),
                          ),
                        const SizedBox(width: 4),
                        Text(
                          path[i].name,
                          style: tt.bodySmall?.copyWith(
                            fontWeight: path[i].id == result.match.id
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: path[i].id == result.match.id
                                ? cs.primary
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
