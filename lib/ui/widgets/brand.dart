import 'package:flutter/material.dart';

class Brand extends StatelessWidget {
  const Brand({super.key});
  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          Icons.spa_rounded,
          color: Theme.of(context).colorScheme.onPrimary,
          size: 21,
        ),
      ),
      const SizedBox(width: 10),
      const Flexible(
        child: Text(
          'focusflow',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 22,
            letterSpacing: -.8,
          ),
        ),
      ),
    ],
  );
}
