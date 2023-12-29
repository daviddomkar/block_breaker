import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:go_router/go_router.dart';

import '../constants.dart';
import '../core/game/block_breaker_game.dart';
import '../core/game/level.dart';
import '../services/level_manager.dart';
import '../theme.dart';
import '../widgets/block_button.dart';

class LevelSelectionScreen extends StatefulWidget {
  final RouteObserver<ModalRoute<void>> routeObserver;
  final LevelManager levelManager;
  final BlockBreakerGame game;

  const LevelSelectionScreen({
    super.key,
    required this.routeObserver,
    required this.levelManager,
    required this.game,
  });

  @override
  State<LevelSelectionScreen> createState() => _LevelSelectionScreenState();
}

class _LevelSelectionScreenState extends State<LevelSelectionScreen>
    with RouteAware {
  late final PageController _pageController;

  BlockBreakerGame get _game => widget.game;
  LevelManager get _levelManager => widget.levelManager;

  late int _selectedLevelIndex;

  @override
  void initState() {
    super.initState();

    _selectedLevelIndex = 0;

    _pageController = PageController(
      initialPage: _selectedLevelIndex,
    );

    _game.loadLevel(levels[_selectedLevelIndex]);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    widget.routeObserver.unsubscribe(this);
    _pageController.dispose();
    super.dispose();
  }

  @override
  void didPopNext() {
    super.didPopNext();

    _selectedLevelIndex = _levelManager.lastPlayedLevelIndex;

    _game.reset(false);
    _game.loadLevel(levels[_selectedLevelIndex]);

    _pageController.jumpToPage(_selectedLevelIndex);

    // This needs to be called after the first frame to ensure that the
    // IgnorePointer widget unlocks the pointer after navigating away from
    // the level screen.
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _game.notifyListeners();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _selectedLevelIndex = index;
            });
            _game.loadLevel(levels[index]);
          },
          children: [
            for (final level in levels)
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8).add(
                    const EdgeInsets.only(bottom: kSafeBottomOffset + 128 + 4),
                  ),
                  child: Text(
                    'Level ${levels.indexOf(level) + 1}',
                    textAlign: TextAlign.center,
                    style: context.textTheme.displayMedium,
                  ),
                ),
              ),
          ],
        ),
        IgnorePointer(
          child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                'Level Selection',
                style: context.textTheme.displaySmall,
              ),
            ),
          ),
        ),
        if (_selectedLevelIndex > 0)
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(8).add(const EdgeInsets.only(
                bottom: kSafeBottomOffset + 128,
                left: 8,
              )),
              child: GestureDetector(
                onTap: () {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOutCubicEmphasized,
                  );
                },
                child: Text('<', style: context.textTheme.displayLarge),
              ),
            ),
          ),
        if (_selectedLevelIndex < levels.length - 1)
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(8).add(const EdgeInsets.only(
                bottom: kSafeBottomOffset + 128,
                right: 8,
              )),
              child: GestureDetector(
                onTap: () {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOutCubicEmphasized,
                  );
                },
                child: Text('>', style: context.textTheme.displayLarge),
              ),
            ),
          ),
        if (_selectedLevelIndex <= _levelManager.highestLevelIndex)
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(8).add(
                const EdgeInsets.only(
                  bottom: kSafeBottomOffset + 48,
                ),
              ),
              child: BlockButton(
                onPressed: () {
                  context.push('/level/${_selectedLevelIndex + 1}');
                },
                child: Text(
                  'Play',
                  style: context.textTheme.titleLarge,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
