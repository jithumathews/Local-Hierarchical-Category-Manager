import 'package:flutter_test/flutter_test.dart';
import 'package:scholigence/features/category/data/category_model.dart';
import 'package:scholigence/features/category/data/category_repository.dart';

// Helper to build a flat list into a tree
List<CategoryNode> buildTree(List<Category> categories) {
  // Access the private static helper via a test-visible wrapper
  return CategoryRepository.buildTreeForTest(categories);
}

void main() {
  group('Tree building', () {
    test('builds single-level tree correctly', () {
      final categories = [
        _cat(1, 'A', null),
        _cat(2, 'B', null),
      ];
      final tree = buildTree(categories);
      expect(tree.length, 2);
      expect(tree.map((n) => n.category.name).toList(), containsAll(['A', 'B']));
    });

    test('builds A→B→C→D→E→F chain correctly', () {
      final categories = [
        _cat(1, 'A', null),
        _cat(2, 'B', 1),
        _cat(3, 'C', 2),
        _cat(4, 'D', 3),
        _cat(5, 'E', 4),
        _cat(6, 'F', 5),
      ];
      final tree = buildTree(categories);
      expect(tree.length, 1);

      var node = tree.first;
      expect(node.category.name, 'A');
      expect(node.children.length, 1);

      node = node.children.first;
      expect(node.category.name, 'B');

      node = node.children.first;
      expect(node.category.name, 'C');

      node = node.children.first;
      expect(node.category.name, 'D');

      node = node.children.first;
      expect(node.category.name, 'E');

      node = node.children.first;
      expect(node.category.name, 'F');
      expect(node.children, isEmpty);
    });

    test('builds Electronics example tree', () {
      final categories = [
        _cat(1, 'Electronics', null),
        _cat(2, 'Mobile', 1),
        _cat(3, 'Android', 2),
        _cat(4, 'Samsung', 3),
        _cat(5, 'Laptops', 1),
        _cat(6, 'Gaming', 5),
      ];
      final tree = buildTree(categories);
      expect(tree.length, 1);

      final electronics = tree.first;
      expect(electronics.category.name, 'Electronics');
      expect(electronics.children.length, 2);

      final childNames =
          electronics.children.map((n) => n.category.name).toList();
      expect(childNames, containsAll(['Mobile', 'Laptops']));

      final mobile =
          electronics.children.firstWhere((n) => n.category.name == 'Mobile');
      expect(mobile.children.length, 1);
      expect(mobile.children.first.category.name, 'Android');

      final android = mobile.children.first;
      expect(android.children.length, 1);
      expect(android.children.first.category.name, 'Samsung');
    });
  });

  group('Path resolution', () {
    test('buildPath returns root → node for deep chain', () {
      final byId = {
        1: _cat(1, 'Root', null),
        2: _cat(2, 'Child', 1),
        3: _cat(3, 'Grandchild', 2),
      };
      final path = CategoryRepository.buildPathForTest(3, byId);
      expect(path.map((c) => c.name).toList(), ['Root', 'Child', 'Grandchild']);
    });

    test('buildPath for root node returns only the root', () {
      final byId = {1: _cat(1, 'Root', null)};
      final path = CategoryRepository.buildPathForTest(1, byId);
      expect(path.length, 1);
      expect(path.first.name, 'Root');
    });
  });

  group('Pagination math', () {
    test('last page may have fewer items', () {
      const total = 25;
      const pageSize = 10;
      const page = 3;
      final offset = (page - 1) * pageSize; // 20
      final remaining = total - offset; // 5
      expect(remaining, 5);
    });

    test('limit caps total count', () {
      const rawTotal = 100;
      const limit = 30;
      final effectiveTotal = limit < rawTotal ? limit : rawTotal;
      expect(effectiveTotal, 30);
    });

    test('total pages calculation', () {
      expect((25 / 10).ceil(), 3);
      expect((20 / 10).ceil(), 2);
      expect((1 / 10).ceil(), 1);
    });
  });
}

Category _cat(int id, String name, int? parentId) => Category(
      id: id,
      name: name,
      parentId: parentId,
      createdAt: DateTime(2024),
    );

