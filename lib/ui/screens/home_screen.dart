import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../game/block_breaker_game.dart';
import '../../theme.dart';
import '../widgets/block_button.dart';

class HomeScreen extends StatefulWidget {
  final RouteObserver<ModalRoute<void>> routeObserver;
  final BlockBreakerGame game;

  const HomeScreen({
    super.key,
    required this.routeObserver,
    required this.game,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with RouteAware {
  BlockBreakerGame get _game => widget.game;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    widget.routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    super.didPopNext();
    _game.reset(false);
  }

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
