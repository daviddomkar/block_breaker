import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme.dart';
import '../widgets/block_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: Center(
            child: Text(
              'Block Breaker',
              textAlign: TextAlign.center,
              style: context.textTheme.displayLarge,
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: Center(
            child: BlockButton(
              onPressed: () => context.push('/level-selection'),
              child: Text(
                'Play',
                style: context.textTheme.headlineMedium,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
