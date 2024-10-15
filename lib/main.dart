import 'package:flutter/material.dart';

/// Entry point of the application.
void main() {
  runApp(const MyApp());
}

/// A [StatelessWidget] that builds the [MaterialApp].
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Container(
            width: 370, 
            height: 80, 
            decoration: BoxDecoration(
              color: Colors.white, 
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Dock(
                items: const [
                  Icons.person,
                  Icons.message,
                  Icons.call,
                  Icons.camera,
                  Icons.photo,
                ],
                builder: (icon) {
                  return Container(
                    width: 48, 
                    height: 48, 
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.primaries[icon.hashCode % Colors.primaries.length],
                    ),
                    child: Center(child: Icon(icon, color: Colors.white, size: 24)),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class Dock<T> extends StatefulWidget {
  const Dock({
    super.key,
    this.items = const [],
    required this.builder,
  });


  final List<T> items;
  final Widget Function(T) builder;

  @override
  State<Dock<T>> createState() => _DockState<T>();
}


class _DockState<T> extends State<Dock<T>> {
  late List<T> _items = widget.items.toList();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8), 
        ),
        child: ReorderableListView(
          scrollDirection: Axis.horizontal,
          onReorder: _onReorder,
          children: [
            for (int index = 0; index < _items.length; index++)
              _buildDraggableItem(_items[index], index),
          ],
        ),
      ),
    );
  }

  /// Reorders the [_items] when an item is dragged and dropped in a new position.
  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final T item = _items.removeAt(oldIndex);
      _items.insert(newIndex, item);
    });
  }

  /// Builds a draggable item wrapped with [ReorderableDragStartListener].
  Widget _buildDraggableItem(T item, int index) {
    return ReorderableDragStartListener(
      key: ValueKey(item),
      index: index,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: widget.builder(item),
      ),
    );
  }
}
