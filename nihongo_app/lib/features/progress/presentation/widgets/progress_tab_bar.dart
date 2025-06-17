import 'package:flutter/material.dart';

class ProgressTabBar extends StatelessWidget {
  const ProgressTabBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _TabButton(label: 'Tất cả', selected: true),
          _TabButton(label: 'N5'),
          _TabButton(label: 'N4'),
          _TabButton(label: 'N3'),
          _TabButton(label: 'N2'),
          _TabButton(label: 'N1'),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool selected;

  const _TabButton({required this.label, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) {},
      ),
    );
  }
} 