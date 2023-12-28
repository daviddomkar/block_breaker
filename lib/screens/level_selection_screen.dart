import 'package:flutter/material.dart';

import '../theme.dart';

class LevelSelectionScreen extends StatelessWidget {
  const LevelSelectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Level Selection',
            style: context.textTheme.displayLarge,
          ),
        ],
      ),
    );
  }
}
