import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/category_repository.dart';
import '../category_controller.dart';

Future<void> showAddCategoryDialog(
  BuildContext context,
  WidgetRef ref, {
  int? parentId,
  String? parentName,
  required CategoryRepository repo,
}) async {
  await showDialog(
    context: context,
    builder: (ctx) => _AddCategoryDialog(
      parentId: parentId,
      parentName: parentName,
      ref: ref,
    ),
  );
}

class _AddCategoryDialog extends StatefulWidget {
  const _AddCategoryDialog({
    this.parentId,
    this.parentName,
    required this.ref,
  });

  final int? parentId;
  final String? parentName;
  final WidgetRef ref;

  @override
  State<_AddCategoryDialog> createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<_AddCategoryDialog> {
  final _formKey = GlobalKey<FormState>();
  final _ctrl = TextEditingController();
  String? _error;
  bool _saving = false;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _error = null;
      _saving = true;
    });

    try {
      await widget.ref.read(categoryTreeProvider.notifier).add(
            _ctrl.text,
            widget.parentId,
          );
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Category added')),
        );
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _saving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return AlertDialog(
      title: Text(
        widget.parentName != null
            ? 'Add Subcategory'
            : 'Add Root Category',
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.parentName != null) ...[
              Text(
                'Adding under: ${widget.parentName}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 12),
            ],
            TextFormField(
              controller: _ctrl,
              autofocus: true,
              maxLength: 50,
              enabled: !_saving,
              decoration: const InputDecoration(
                labelText: 'Category name',
                hintText: 'e.g. Electronics',
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Name cannot be empty.';
                }
                if (v.trim().length > 50) {
                  return 'Max 50 characters.';
                }
                return null;
              },
              onFieldSubmitted: (_) => _saving ? null : _submit(),
            ),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(
                _error!,
                style: TextStyle(color: cs.error, fontSize: 13),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _saving ? null : _submit,
          child: _saving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text('Add'),
        ),
      ],
    );
  }
}
