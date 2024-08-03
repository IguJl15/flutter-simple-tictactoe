import 'dart:math';

import 'package:flutter/material.dart';

import 'tictactoe.dart';

class TicTacToeBoardWidget extends StatelessWidget {
  TicTacToeBoardWidget({
    required this.game,
    required this.onSpaceTap,
    super.key,
  }) : axisCount = sqrt(game.board.length) {
    assert(axisCount.roundToDouble() == axisCount, "Board should have a equals number of column and rows");
  }

  final TicTacToe game;
  final double axisCount;

  final void Function(int index) onSpaceTap;

  @override
  Widget build(BuildContext context) {
    const borderWidth = 4.0;

    final colorScheme = Theme.of(context).colorScheme;

    final (spaceColor, borderColor) = switch (colorScheme.brightness) {
      Brightness.light => (colorScheme.surfaceContainerLowest, colorScheme.surfaceContainerHighest),
      Brightness.dark => (colorScheme.surfaceBright, colorScheme.surfaceContainer),
    };

    return Container(
      constraints: const BoxConstraints(maxWidth: 480, maxHeight: 480),
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          clipBehavior: Clip.antiAlias,
          margin: const EdgeInsets.all(8),
          decoration: ShapeDecoration(
            color: borderColor,
            shadows: kElevationToShadow[2],
            shape: RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              side: BorderSide(
                width: borderWidth,
                color: borderColor,
                strokeAlign: BorderSide.strokeAlignOutside,
              ),
            ),
          ),
          child: GridView.builder(
            shrinkWrap: true,
            itemCount: game.board.length,
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisSpacing: borderWidth,
              crossAxisSpacing: borderWidth,
              crossAxisCount: axisCount.toInt(),
            ),
            itemBuilder: (context, index) {
              final mark = game.board[index];

              return GameMarkWidget(
                mark,
                color: spaceColor,
                onTap: () => onSpaceTap(index),
              );
            },
          ),
        ),
      ),
    );
  }
}

class GameMarkWidget extends StatelessWidget {
  const GameMarkWidget(this.mark, {required this.onTap, required this.color, super.key});

  final GameMark mark;
  final VoidCallback? onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      child: InkWell(
        onTap: onTap,
        child: Center(
          child: GameMarkIcon(mark: mark),
        ),
      ),
    );
  }
}

class GameMarkIcon extends StatelessWidget {
  const GameMarkIcon({
    super.key,
    required this.mark,
  });

  final GameMark mark;

  @override
  Widget build(BuildContext context) {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).colorScheme.onSurface, size: 32),
      child: switch (mark) {
        GameMark.circle => const Icon(Icons.circle_outlined),
        GameMark.cross => const Icon(Icons.close),
        GameMark.empty => const SizedBox.expand(),
      },
    );
  }
}
